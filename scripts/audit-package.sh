#!/usr/bin/env bash
# ==============================================================================
# audit-package.sh — Mach-O, Install-Name, RPATH, and Archive Hygiene Auditor
# ==============================================================================
set -euo pipefail

TARGET_PATH="${1:-}"
EXPECTED_ARCH="${2:-}" # optional: x86_64 or arm64

if [[ -z "${TARGET_PATH}" ]]; then
    echo "Usage: $0 <path-to-staging-dir-or-pkg-or-binary> [expected_arch: x86_64|arm64]"
    exit 1
fi

echo "=== Auditing Target: ${TARGET_PATH} (Expected Arch: ${EXPECTED_ARCH:-any}) ==="

FAILURES=0
MACHO_COUNT=0

audit_binary() {
    local bin="$1"
    local ftype
    ftype=$(file -b "${bin}" 2>/dev/null || true)
    if ! echo "${ftype}" | grep -qE "Mach-O.*(executable|dynamically linked shared library|bundle)"; then
        return 0
    fi

    MACHO_COUNT=$((MACHO_COUNT + 1))
    echo -e "\n--> Auditing Mach-O: ${bin}"

    local lipo_out
    lipo_out=$(lipo -info "${bin}" 2>&1 || true)
    echo "    ${lipo_out}"

    if [[ -n "${EXPECTED_ARCH}" ]]; then
        if ! echo "${lipo_out}" | grep -qw "${EXPECTED_ARCH}"; then
            echo "    [FAIL] Architecture mismatch: expected ${EXPECTED_ARCH}, got: ${lipo_out}"
            FAILURES=$((FAILURES + 1))
        else
            echo "    [OK] Architecture matches ${EXPECTED_ARCH}."
        fi
    fi

    local bad_deps
    bad_deps=$(otool -L "${bin}" | tail -n +2 | grep -E '/opt/local|/usr/local|/opt/homebrew' || true)
    if [[ -n "${bad_deps}" ]]; then
        echo "    [FAIL] Forbidden runtime dependencies (/opt/local, /usr/local, /opt/homebrew):"
        echo "${bad_deps}"
        FAILURES=$((FAILURES + 1))
    else
        echo "    [OK] No forbidden MacPorts/Homebrew/usr-local references."
    fi

    local unexpanded_rpath
    unexpanded_rpath=$(otool -L "${bin}" | tail -n +2 | awk '{print $1}' | grep -E '^@(rpath|loader_path|executable_path)/' || true)
    if [[ -n "${unexpanded_rpath}" ]]; then
        local rpaths
        rpaths=$(otool -l "${bin}" | awk '/cmd LC_RPATH/{getline; getline; if ($1 == "path") print $2}' || true)
        echo "    [INFO] Relative/RPATH references present; defined LC_RPATHs: ${rpaths:-none}"
        local bad_rpaths
        bad_rpaths=$(echo "${rpaths}" | grep -E '/Users/|/opt/local|/usr/local|/opt/homebrew|staging|build' || true)
        if [[ -n "${bad_rpaths}" ]]; then
            echo "    [FAIL] Forbidden build-tree or third-party LC_RPATH detected:"
            echo "${bad_rpaths}"
            FAILURES=$((FAILURES + 1))
        fi
    fi

    if codesign -v "${bin}" 2>/dev/null; then
        echo "    [OK] Valid Mach-O code signature."
    else
        echo "    [FAIL] Invalid or missing Mach-O code signature."
        FAILURES=$((FAILURES + 1))
    fi
}

if [[ -f "${TARGET_PATH}" && "${TARGET_PATH}" == *.pkg.tar.zst ]]; then
    TMP_AUDIT="$(mktemp -d)"
    trap 'rm -rf "${TMP_AUDIT}"' EXIT
    echo "--> Inspecting package archive metadata and ownership..."
    bad_owners=$(bsdtar -tvf "${TARGET_PATH}" | awk '($3 != "root" && $3 != "0") || ($4 != "wheel" && $4 != "0") {print $0}' | head -n 5 || true)
    if [[ -n "${bad_owners}" ]]; then
        echo "[FAIL] Non-root:wheel (0:0) entries detected in archive:"
        echo "${bad_owners}"
        FAILURES=$((FAILURES + 1))
    else
        echo "[OK] All archive entries normalized to UID/GID 0:0 (root:wheel)."
    fi

    outside_prefix=$(bsdtar -tf "${TARGET_PATH}" | grep -vE '^(\.PKGINFO|\.BUILDINFO|\.MTREE|opt/|opt/pacman(/.*)?)$' || true)
    if [[ -n "${outside_prefix}" ]]; then
        echo "[FAIL] Unexpected files outside /opt/pacman:"
        echo "${outside_prefix}"
        FAILURES=$((FAILURES + 1))
    else
        echo "[OK] All payload paths reside strictly under opt/pacman/."
    fi

    bsdtar -xf "${TARGET_PATH}" -C "${TMP_AUDIT}"
    while IFS= read -r -d '' f; do
        audit_binary "${f}"
    done < <(find "${TMP_AUDIT}" -type f -print0)
elif [[ -d "${TARGET_PATH}" ]]; then
    while IFS= read -r -d '' f; do
        audit_binary "${f}"
    done < <(find "${TARGET_PATH}" -type f -print0)
elif [[ -f "${TARGET_PATH}" ]]; then
    audit_binary "${TARGET_PATH}"
else
    echo "Error: Target path not found: ${TARGET_PATH}"
    exit 1
fi

echo -e "\n=== Audit Summary: ${MACHO_COUNT} Mach-O files inspected, ${FAILURES} failure(s) ==="
if [[ ${FAILURES} -gt 0 ]]; then
    exit 1
fi

