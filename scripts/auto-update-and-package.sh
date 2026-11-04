#!/usr/bin/env bash
# ==============================================================================
# auto-update-and-package.sh — Upstream KF6 Release Checker, Builder & Hasher
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

CHECK_ONLY=false
FORCE=false
ARCH_TARGET="both"
ONLY_MODULE=""
DO_INSTALL=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --check)
            CHECK_ONLY=true
            shift
            ;;
        --force|--rebuild)
            FORCE=true
            shift
            ;;
        --arch)
            ARCH_TARGET="$2"
            shift 2
            ;;
        --module)
            ONLY_MODULE="$2"
            shift 2
            ;;
        --install)
            DO_INSTALL=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [--check] [--force|--rebuild] [--arch x86_64|arm64|both] [--module <name>] [--install]"
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
    esac
done

echo "--> Querying upstream KDE Frameworks 6 stable release series..."
LATEST_SERIES=$(curl -fsSL --max-time 15 https://download.kde.org/stable/frameworks/ | grep -oE '6\.[0-9]+' | sort -uV | tail -n 1)
LATEST_VER="${LATEST_SERIES}.0"
echo "    Latest upstream KF6 release: ${LATEST_VER}"

for pkgbuild in "${REPO_ROOT}"/packages/kde/*/PKGBUILD; do
    [[ -f "${pkgbuild}" ]] || continue
    pkgname=$(grep -E '^pkgname=' "${pkgbuild}" | head -n 1 | cut -d'=' -f2 | tr -d ' "'"'")
    if [[ -n "${ONLY_MODULE}" && "${ONLY_MODULE}" != "${pkgname}" ]]; then
        continue
    fi

    local_ver=$(grep -E '^pkgver=' "${pkgbuild}" | head -n 1 | cut -d'=' -f2 | tr -d ' "'"'")
    local_rel=$(grep -E '^pkgrel=' "${pkgbuild}" | head -n 1 | cut -d'=' -f2 | tr -d ' "'"'")
    git_url="https://invent.kde.org/frameworks/${pkgname}.git"
    upstream_commit=$(git ls-remote --tags "${git_url}" "refs/tags/v${LATEST_VER}^{}" "refs/tags/v${LATEST_VER}" 2>/dev/null | tail -n 1 | awk '{print $1}' || echo "none")
    upstream_sha256=$(curl -fsSL --max-time 15 "https://download.kde.org/stable/frameworks/${LATEST_SERIES}/${pkgname}-${LATEST_VER}.tar.xz.sha256" 2>/dev/null | awk '{print $1}' || echo "")

    pkg_x86="${REPO_ROOT}/out/darwin_x86_64/${pkgname}-${LATEST_VER}-${local_rel}-darwin_x86_64.pkg.tar.zst"
    pkg_arm="${REPO_ROOT}/out/darwin_arm64/${pkgname}-${LATEST_VER}-${local_rel}-darwin_arm64.pkg.tar.zst"

    missing_pkg=false
    if [[ "${ARCH_TARGET}" == "x86_64" || "${ARCH_TARGET}" == "both" ]]; then
        [[ -f "${pkg_x86}" ]] || missing_pkg=true
    fi
    if [[ "${ARCH_TARGET}" == "arm64" || "${ARCH_TARGET}" == "both" ]]; then
        [[ -f "${pkg_arm}" ]] || missing_pkg=true
    fi

    if [[ "${CHECK_ONLY}" == "true" ]]; then
        echo "  [${pkgname}] local=${local_ver} upstream=${LATEST_VER} commit=${upstream_commit:0:12} sha256=${upstream_sha256:0:16}... missing_pkg=${missing_pkg}"
        continue
    fi

    if [[ "${FORCE}" == "true" || "${local_ver}" != "${LATEST_VER}" || "${missing_pkg}" == "true" ]]; then
        build_args=("${pkgname}" "--arch" "${ARCH_TARGET}")
        [[ "${FORCE}" == "true" ]] && build_args+=("--force")
        [[ "${DO_INSTALL}" == "true" ]] && build_args+=("--install")
        "${SCRIPT_DIR}/build-module.sh" "${build_args[@]}"
    else
        echo "==> [${pkgname}] Current stable ${LATEST_VER} packages present and verified."
    fi
done

if [[ "${CHECK_ONLY}" == "false" ]]; then
    "${SCRIPT_DIR}/generate-hashes.sh"
fi

