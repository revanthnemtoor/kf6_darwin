#!/usr/bin/env bash
# ==============================================================================
# generate-hashes.sh — Generate out/latest-hashes.txt and out/latest-hashes.json
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
OUT_DIR="${REPO_ROOT}/out"
SOURCES_DIR="${REPO_ROOT}/sources"

mkdir -p "${OUT_DIR}/darwin_x86_64" "${OUT_DIR}/darwin_arm64"

HASH_TXT="${OUT_DIR}/latest-hashes.txt"
HASH_JSON="${OUT_DIR}/latest-hashes.json"
NOW_ISO=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

{
    echo "# KF6 Darwin Module State & Cryptographic Hash Manifest"
    echo "# Generated: ${NOW_ISO}"
    echo "# Format: pkgname | status | version | git_commit | src_sha256 | src_sha512 | x86_64_sha256 | x86_64_sha512 | arm64_sha256 | arm64_sha512"
    echo "# ----------------------------------------------------------------------------------------------------------------------------------"
} > "${HASH_TXT}.tmp"

JSON_ENTRIES=()

for pkgbuild in "${REPO_ROOT}"/packages/deps/*/PKGBUILD "${REPO_ROOT}"/packages/kde/*/PKGBUILD; do
    [[ -f "${pkgbuild}" ]] || continue
    pkgname=$(grep -E '^pkgname=' "${pkgbuild}" | head -n 1 | cut -d'=' -f2 | tr -d ' "'"'")
    pkgver=$(grep -E '^pkgver=' "${pkgbuild}" | head -n 1 | cut -d'=' -f2 | tr -d ' "'"'")
    pkgrel=$(grep -E '^pkgrel=' "${pkgbuild}" | head -n 1 | cut -d'=' -f2 | tr -d ' "'"'")
    git_commit=$(grep -E '^_commit=' "${pkgbuild}" | head -n 1 | cut -d'=' -f2 | awk '{print $1}' | tr -d ' "'"'" || echo "none")

    src_file="${SOURCES_DIR}/${pkgname}-${pkgver}.tar.xz"
    if [[ ! -f "${src_file}" && -f "${SOURCES_DIR}/${pkgname}-${pkgver}.tar.gz" ]]; then
        src_file="${SOURCES_DIR}/${pkgname}-${pkgver}.tar.gz"
    fi
    if [[ -f "${src_file}" ]]; then
        src_sha256=$(shasum -a 256 "${src_file}" | awk '{print $1}')
        src_sha512=$(shasum -a 512 "${src_file}" | awk '{print $1}')
    else
        src_sha256="none"
        src_sha512="none"
    fi

    pkg_x86="${OUT_DIR}/darwin_x86_64/${pkgname}-${pkgver}-${pkgrel}-darwin_x86_64.pkg.tar.zst"
    pkg_arm="${OUT_DIR}/darwin_arm64/${pkgname}-${pkgver}-${pkgrel}-darwin_arm64.pkg.tar.zst"

    x86_sha256="none"
    x86_sha512="none"
    if [[ -f "${pkg_x86}" ]]; then
        x86_sha256=$(shasum -a 256 "${pkg_x86}" | awk '{print $1}')
        x86_sha512=$(shasum -a 512 "${pkg_x86}" | awk '{print $1}')
    fi

    arm_sha256="none"
    arm_sha512="none"
    if [[ -f "${pkg_arm}" ]]; then
        arm_sha256=$(shasum -a 256 "${pkg_arm}" | awk '{print $1}')
        arm_sha512=$(shasum -a 512 "${pkg_arm}" | awk '{print $1}')
    fi

    status="pending"
    if [[ "${x86_sha256}" != "none" && "${arm_sha256}" != "none" && "${src_sha256}" != "none" ]]; then
        status="validated"
    elif [[ "${src_sha256}" != "none" ]]; then
        status="source-verified"
    fi

    echo "${pkgname} | ${status} | ${pkgver}-${pkgrel} | ${git_commit} | ${src_sha256} | ${src_sha512} | ${x86_sha256} | ${x86_sha512} | ${arm_sha256} | ${arm_sha512}" >> "${HASH_TXT}.tmp"

    JSON_ENTRIES+=("$(printf '{"package":"%s","status":"%s","version":"%s-%s","git_commit":"%s","source_sha256":"%s","source_sha512":"%s","darwin_x86_64":{"file":"darwin_x86_64/%s","sha256":"%s","sha512":"%s"},"darwin_arm64":{"file":"darwin_arm64/%s","sha256":"%s","sha512":"%s"}}' \
        "${pkgname}" "${status}" "${pkgver}" "${pkgrel}" "${git_commit}" "${src_sha256}" "${src_sha512}" \
        "$(basename "${pkg_x86}")" "${x86_sha256}" "${x86_sha512}" \
        "$(basename "${pkg_arm}")" "${arm_sha256}" "${arm_sha512}")")
done

mv "${HASH_TXT}.tmp" "${HASH_TXT}"

{
    printf '{\n  "generated_at": "%s",\n  "modules": [\n    ' "${NOW_ISO}"
    sep=""
    for entry in "${JSON_ENTRIES[@]}"; do
        printf '%s%s' "${sep}" "${entry}"
        sep=$',\n    '
    done
    printf '\n  ]\n}\n'
} > "${HASH_JSON}"

echo "✓ Updated ${HASH_TXT} and ${HASH_JSON}"

