#!/usr/bin/env bash
# ==============================================================================
# dependency-check.sh — Verify /opt/pacman Qt6 & System Dependencies for KF6
# ==============================================================================
set -euo pipefail

PREFIX="/opt/pacman"
PACMAN_BIN="${PREFIX}/bin/pacman"

echo "=== Checking KF6 Darwin Foundation Dependencies in ${PREFIX} ==="

if [[ ! -x "${PACMAN_BIN}" ]]; then
    echo "ERROR: ${PACMAN_BIN} not found or not executable." >&2
    exit 1
fi

REQUIRED_QT6_PKGS=(
    qt6-base
    qt6-svg
    qt6-imageformats
    qt6-shadertools
    qt6-tools
    qt6-languageserver
    qt6-declarative
    qt6-quicktimeline
    qt6-lottie
    qt6-quick3d
    qt6-quick3dphysics
    qt6-multimedia
    qt6-networkauth
    qt6-websockets
    qt6-serialport
    qt6-connectivity
)

MISSING=0
for pkg in "${REQUIRED_QT6_PKGS[@]}"; do
    if ver=$("${PACMAN_BIN}" -Q "${pkg}" 2>/dev/null); then
        printf "  [OK] %-22s -> %s\n" "${pkg}" "${ver}"
    else
        printf "  [MISSING] %s\n" "${pkg}"
        MISSING=$((MISSING + 1))
    fi
done

echo ""
echo "=== Checking Host Build Tooling ==="
for tool in cmake ninja clang codesign bsdtar zstd git curl shasum; do
    if path=$(command -v "${tool}" 2>/dev/null); then
        printf "  [OK] %-12s -> %s\n" "${tool}" "${path}"
    else
        printf "  [MISSING] %s\n" "${tool}"
        MISSING=$((MISSING + 1))
    fi
done

if [[ ${MISSING} -gt 0 ]]; then
    echo "ERROR: ${MISSING} required dependency check(s) failed." >&2
    exit 1
fi

echo ""
echo "✓ All Qt 6.12.0 Darwin packages and host build tools verified."

