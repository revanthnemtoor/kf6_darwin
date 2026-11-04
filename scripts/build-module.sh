#!/usr/bin/env bash
# ==============================================================================
# build-module.sh — Build, Stage, Audit, and Package a KF6 Module for Darwin
# ==============================================================================
# Usage:
#   ./scripts/build-module.sh <pkgname> [--arch x86_64|arm64|both] [--install] [--force]
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

PKG_NAME=""
ARCH_TARGET="both"
DO_INSTALL=false
FORCE_BUILD=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --arch)
            ARCH_TARGET="$2"
            shift 2
            ;;
        --install)
            DO_INSTALL=true
            shift
            ;;
        --force|--rebuild)
            FORCE_BUILD=true
            shift
            ;;
        -*)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
        *)
            PKG_NAME="$1"
            shift
            ;;
    esac
done

if [[ -z "${PKG_NAME}" ]]; then
    echo "Usage: $0 <pkgname> [--arch x86_64|arm64|both] [--install] [--force]" >&2
    exit 1
fi

PKGBUILD_FILE="${REPO_ROOT}/packages/kde/${PKG_NAME}/PKGBUILD"
if [[ ! -f "${PKGBUILD_FILE}" ]]; then
    PKGBUILD_FILE="${REPO_ROOT}/packages/deps/${PKG_NAME}/PKGBUILD"
fi
if [[ ! -f "${PKGBUILD_FILE}" ]]; then
    echo "ERROR: PKGBUILD not found for ${PKG_NAME}" >&2
    exit 1
fi

PKG_VER=$(grep -E '^pkgver=' "${PKGBUILD_FILE}" | head -n 1 | cut -d'=' -f2 | tr -d ' "'"'")
PKG_REL=$(grep -E '^pkgrel=' "${PKGBUILD_FILE}" | head -n 1 | cut -d'=' -f2 | tr -d ' "'"'")
PKG_DESC=$(grep -E '^pkgdesc=' "${PKGBUILD_FILE}" | head -n 1 | cut -d'=' -f2- | sed -E 's/^["'"'"']|["'"'"']$//g')
PKG_URL=$(grep -E '^url=' "${PKGBUILD_FILE}" | head -n 1 | cut -d'=' -f2- | sed -E 's/^["'"'"']|["'"'"']$//g')
EXPECTED_SHA256=$(grep -E '^sha256sums=' "${PKGBUILD_FILE}" | grep -oE '[0-9a-f]{64}' | head -n 1 || true)
EXPECTED_SHA512=$(grep -E '^sha512sums=' "${PKGBUILD_FILE}" | grep -oE '[0-9a-f]{128}' | head -n 1 || true)

TARBALL="${REPO_ROOT}/sources/${PKG_NAME}-${PKG_VER}.tar.xz"
if [[ ! -f "${TARBALL}" && -f "${REPO_ROOT}/sources/${PKG_NAME}-${PKG_VER}.tar.gz" ]]; then
    TARBALL="${REPO_ROOT}/sources/${PKG_NAME}-${PKG_VER}.tar.gz"
fi
SRC_URL="https://download.kde.org/stable/frameworks/${PKG_VER%.*}/${PKG_NAME}-${PKG_VER}.tar.xz"

mkdir -p "${REPO_ROOT}/sources" "${REPO_ROOT}/out/darwin_x86_64" "${REPO_ROOT}/out/darwin_arm64"

if [[ ! -f "${TARBALL}" ]]; then
    echo "==> Downloading ${SRC_URL}..."
    curl -fSL --retry 3 -o "${TARBALL}" "${SRC_URL}"
fi

ACTUAL_SHA256=$(shasum -a 256 "${TARBALL}" | awk '{print $1}')
ACTUAL_SHA512=$(shasum -a 512 "${TARBALL}" | awk '{print $1}')

if [[ -n "${EXPECTED_SHA256}" && "${ACTUAL_SHA256}" != "${EXPECTED_SHA256}" ]]; then
    echo "ERROR: SHA-256 mismatch for ${TARBALL}" >&2
    exit 1
fi
if [[ -n "${EXPECTED_SHA512}" && "${ACTUAL_SHA512}" != "${EXPECTED_SHA512}" ]]; then
    echo "ERROR: SHA-512 mismatch for ${TARBALL}" >&2
    exit 1
fi

SRC_EXTRACT_DIR="${REPO_ROOT}/build/src"
mkdir -p "${SRC_EXTRACT_DIR}"
if [[ ! -d "${SRC_EXTRACT_DIR}/${PKG_NAME}-${PKG_VER}" ]]; then
    tar -xf "${TARBALL}" -C "${SRC_EXTRACT_DIR}"
    if [[ "${PKG_NAME}" == "libtiff" && -d "${SRC_EXTRACT_DIR}/tiff-${PKG_VER}" && ! -d "${SRC_EXTRACT_DIR}/${PKG_NAME}-${PKG_VER}" ]]; then
        mv "${SRC_EXTRACT_DIR}/tiff-${PKG_VER}" "${SRC_EXTRACT_DIR}/${PKG_NAME}-${PKG_VER}"
    fi
fi

if [[ -d "${REPO_ROOT}/patches/${PKG_NAME}" ]]; then
    for patch_file in "${REPO_ROOT}/patches/${PKG_NAME}/"*.patch; do
        [[ -f "${patch_file}" ]] || continue
        if patch -d "${SRC_EXTRACT_DIR}/${PKG_NAME}-${PKG_VER}" -Np1 --dry-run -s < "${patch_file}" >/dev/null 2>&1; then
            echo "==> Applying patch $(basename "${patch_file}") to ${PKG_NAME}..."
            patch -d "${SRC_EXTRACT_DIR}/${PKG_NAME}-${PKG_VER}" -Np1 < "${patch_file}"
        fi
    done
fi

JOBS="$(sysctl -n hw.ncpu)"

build_for_arch() {
    local arch="$1"
    local pkg_arch="darwin_${arch}"
    local build_dir="${REPO_ROOT}/build/${pkg_arch}/${PKG_NAME}"
    local stage_dir="${REPO_ROOT}/build/${pkg_arch}/stage_${PKG_NAME}"
    local arm_sysroot="${REPO_ROOT}/build/darwin_arm64/sysroot/opt/pacman"
    local qt6_arm_sysroot="${REPO_ROOT}/../qt6_darwin/staging/pkg_arm64/opt/pacman"
    local qt6_arm_deps="${REPO_ROOT}/../qt6_darwin/staging/sysroot_arm64/opt/pacman"
    local pkg_out="${REPO_ROOT}/out/${pkg_arch}/${PKG_NAME}-${PKG_VER}-${PKG_REL}-${pkg_arch}.pkg.tar.zst"

    if [[ -f "${pkg_out}" && "${FORCE_BUILD}" == "false" ]]; then
        echo "==> [${PKG_NAME} (${pkg_arch})] Package already exists: ${pkg_out} (skipping; use --force to rebuild)"
        if [[ "${DO_INSTALL}" == "true" && "${arch}" == "$(uname -m)" ]]; then
            /opt/pacman/bin/pacman -U --noconfirm "${pkg_out}"
        fi
        return 0
    fi

    echo "=================================================================="
    echo "==> Building ${PKG_NAME} ${PKG_VER}-${PKG_REL} for ${pkg_arch}"
    echo "=================================================================="

    rm -rf "${build_dir}" "${stage_dir}"
    mkdir -p "${build_dir}" "${stage_dir}"

    export LC_ALL=en_US.UTF-8
    export PATH="/opt/pacman/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/local/bin:/usr/local/bin"

    local cmake_arch_args=()
    if [[ "${arch}" == "arm64" ]]; then
        mkdir -p "${arm_sysroot}/lib/pkgconfig"
        rm -rf "${arm_sysroot}/bin"
        cat > "${arm_sysroot}/lib/pkgconfig/libzstd.pc" <<EOF
prefix=${arm_sysroot}
exec_prefix=\${prefix}
includedir=\${prefix}/include
libdir=\${exec_prefix}/lib

Name: zstd
Description: fast lossless compression algorithm library
URL: https://facebook.github.io/zstd/
Version: 1.5.7
Libs: -L\${libdir} -lzstd
Cflags: -I\${includedir}
EOF
        export PKG_CONFIG_LIBDIR="${arm_sysroot}/lib/pkgconfig:${qt6_arm_sysroot}/lib/pkgconfig:${qt6_arm_deps}/lib/pkgconfig:/opt/pacman/share/pkgconfig"
        export PKG_CONFIG_PATH="${PKG_CONFIG_LIBDIR}"
        cmake_arch_args+=(
            -DCMAKE_SYSTEM_NAME=Darwin
            -DCMAKE_SYSTEM_PROCESSOR=arm64
            -DQT_HOST_PATH="/opt/pacman"
            -DKF6_HOST_TOOLING="/opt/pacman/lib/cmake"
            -DPARSETRIGRAMS_EXECUTABLE="/opt/pacman/bin/parsetrigrams6"
            -DBUILD_DESIGNERPLUGIN=OFF
            -DGETTEXT_MSGFMT_EXECUTABLE="/opt/pacman/bin/msgfmt"
            -DGETTEXT_MSGMERGE_EXECUTABLE="/opt/pacman/bin/msgmerge"
            -DOPENSSL_ROOT_DIR="${qt6_arm_deps}"
            -DOPENSSL_CRYPTO_LIBRARY="${qt6_arm_deps}/lib/libcrypto.dylib"
            -DOPENSSL_SSL_LIBRARY="${qt6_arm_deps}/lib/libssl.dylib"
            -DOPENSSL_INCLUDE_DIR="${qt6_arm_deps}/include"
            -DLIBLZMA_LIBRARY="${arm_sysroot}/lib/liblzma.a"
            -DLIBLZMA_INCLUDE_DIR="${arm_sysroot}/include"
            -DZLIB_LIBRARY="${arm_sysroot}/lib/libz.dylib"
            -DZLIB_INCLUDE_DIR="${arm_sysroot}/include"
            -DZSTD_LIBRARY="${arm_sysroot}/lib/libzstd.dylib"
            -DZSTD_INCLUDE_DIR="${arm_sysroot}/include"
            -DEXPAT_LIBRARY="${arm_sysroot}/lib/libexpat.dylib"
            -DEXPAT_INCLUDE_DIR="${arm_sysroot}/include"
            -DCMAKE_PREFIX_PATH="${arm_sysroot};${qt6_arm_sysroot};${qt6_arm_deps};/opt/pacman"
            -DCMAKE_FIND_ROOT_PATH="${arm_sysroot};${qt6_arm_sysroot};${qt6_arm_deps};/opt/pacman"
        )
        if [[ -f "${arm_sysroot}/lib/libjpeg.dylib" ]]; then
            cmake_arch_args+=(
                -DJPEG_LIBRARY="${arm_sysroot}/lib/libjpeg.dylib"
                -DJPEG_INCLUDE_DIR="${arm_sysroot}/include"
            )
        fi
        if [[ -f "${arm_sysroot}/lib/libpng.dylib" ]]; then
            cmake_arch_args+=(
                -DPNG_LIBRARY="${arm_sysroot}/lib/libpng.dylib"
                -DPNG_PNG_INCLUDE_DIR="${arm_sysroot}/include"
            )
        fi
        if [[ -f "${arm_sysroot}/lib/libtiff.dylib" ]]; then
            cmake_arch_args+=(
                -DTIFF_LIBRARY="${arm_sysroot}/lib/libtiff.dylib"
                -DTIFF_INCLUDE_DIR="${arm_sysroot}/include"
            )
        fi
        if [[ -f "${arm_sysroot}/lib/liblcms2.dylib" ]]; then
            cmake_arch_args+=(
                -DLCMS2_LIBRARIES="${arm_sysroot}/lib/liblcms2.dylib"
                -DLCMS2_INCLUDE_DIR="${arm_sysroot}/include"
            )
        fi
    else
        local x86_pc_dir="${REPO_ROOT}/build/darwin_x86_64/pkgconfig"
        mkdir -p "${x86_pc_dir}"
        cat > "${x86_pc_dir}/libzstd.pc" <<EOF
prefix=/opt/pacman
exec_prefix=\${prefix}
includedir=\${prefix}/include
libdir=\${exec_prefix}/lib

Name: zstd
Description: fast lossless compression algorithm library
URL: https://facebook.github.io/zstd/
Version: 1.5.7
Libs: -L\${libdir} -lzstd
Cflags: -I\${includedir}
EOF
        export PKG_CONFIG_LIBDIR="${x86_pc_dir}:/opt/pacman/lib/pkgconfig:/opt/pacman/share/pkgconfig"
        export PKG_CONFIG_PATH="${PKG_CONFIG_LIBDIR}"
        cmake_arch_args+=(
            -DLIBLZMA_LIBRARY="/opt/pacman/lib/liblzma.a"
            -DLIBLZMA_INCLUDE_DIR="/opt/pacman/include"
            -DCMAKE_PREFIX_PATH="/opt/pacman"
        )
    fi

    local extra_mod_args=(
        -DBUILD_PYTHON_BINDINGS=OFF
    )
    if [[ "${PKG_NAME}" == "extra-cmake-modules" ]]; then
        extra_mod_args+=(
            -DBUILD_HTML_DOCS=OFF
            -DBUILD_MAN_DOCS=OFF
            -DBUILD_QTHELP_DOCS=OFF
        )
    elif [[ "${PKG_NAME}" == "kcoreaddons" ]]; then
        extra_mod_args+=(
            -DENABLE_INOTIFY=OFF
        )
    elif [[ "${PKG_NAME}" == "ki18n" ]]; then
        if [[ "${arch}" == "arm64" ]]; then
            extra_mod_args+=(
                -DLibIntl_INCLUDE_DIRS="${arm_sysroot}/include"
                -DLibIntl_LIBRARIES="${arm_sysroot}/lib/libintl.dylib"
            )
        fi
    elif [[ "${PKG_NAME}" == "kiconthemes" ]]; then
        extra_mod_args+=(
            -DUSE_BreezeIcons=OFF
        )
    elif [[ "${PKG_NAME}" == "ktextwidgets" ]]; then
        extra_mod_args+=(
            -DWITH_TEXT_TO_SPEECH=OFF
        )
    elif [[ "${PKG_NAME}" == "libjpeg-turbo" ]]; then
        extra_mod_args+=(
            -DCMAKE_ASM_NASM_COMPILER="/usr/local/bin/nasm"
            -DENABLE_SHARED=ON
            -DENABLE_STATIC=OFF
            -DWITH_JPEG8=ON
        )
    elif [[ "${PKG_NAME}" == "libpng" ]]; then
        extra_mod_args+=(
            -DPNG_SHARED=ON
            -DPNG_STATIC=OFF
            -DPNG_FRAMEWORK=OFF
            -DPNG_TESTS=OFF
        )
    elif [[ "${PKG_NAME}" == "libtiff" ]]; then
        extra_mod_args+=(
            -DBUILD_SHARED_LIBS=ON
            -Dtiff-static=OFF
            -Dtiff-framework=OFF
            -Dtiff-tests=OFF
            -Dtiff-docs=OFF
            -Dtiff-contrib=OFF
        )
    elif [[ "${PKG_NAME}" == "lcms2" ]]; then
        extra_mod_args+=(
            -DLCMS2_BUILD_SHARED=ON
            -DLCMS2_BUILD_STATIC=OFF
            -DLCMS2_BUILD_TESTS=OFF
        )
    elif [[ "${PKG_NAME}" == "exiv2" ]]; then
        extra_mod_args+=(
            -DBUILD_SHARED_LIBS=ON
            -DEXIV2_ENABLE_INIH=OFF
            -DEXIV2_ENABLE_BROTLI=OFF
            -DEXIV2_ENABLE_NLS=OFF
            -DEXIV2_BUILD_SAMPLES=OFF
            -DEXIV2_BUILD_UNIT_TESTS=OFF
            -DEXIV2_BUILD_DOC=OFF
        )
    elif [[ "${PKG_NAME}" == "gwenview" ]]; then
        extra_mod_args+=(
            -DGWENVIEW_SEMANTICINFO_BACKEND="None"
            -DGWENVIEW_IMAGEANNOTATOR=OFF
            -DWITHOUT_X11=ON
        )
    fi

    cmake -B "${build_dir}" -S "${SRC_EXTRACT_DIR}/${PKG_NAME}-${PKG_VER}" -G Ninja \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX="/opt/pacman" \
        -DCMAKE_INSTALL_NAME_DIR="/opt/pacman/lib" \
        -DKDE_INSTALL_BUNDLEDIR="/opt/pacman/Applications/KDE" \
        -DAPPLE_SUPPRESS_X11_WARNING=ON \
        -DPython3_EXECUTABLE="/usr/bin/python3" \
        -DBISON_EXECUTABLE="/opt/local/bin/bison" \
        -DCMAKE_IGNORE_PREFIX_PATH="/opt/local;/usr/local;/opt/homebrew" \
        -DCMAKE_OSX_ARCHITECTURES="${arch}" \
        -DCMAKE_OSX_DEPLOYMENT_TARGET="15.0" \
        -DCMAKE_INSTALL_RPATH="/opt/pacman/lib" \
        -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
        -DBUILD_TESTING=OFF \
        "${cmake_arch_args[@]}" \
        ${extra_mod_args[@]+"${extra_mod_args[@]}"}

    cmake --build "${build_dir}" --parallel "${JOBS}"
    DESTDIR="${stage_dir}" cmake --install "${build_dir}"

    if [[ "${arch}" == "arm64" ]]; then
        DESTDIR="${REPO_ROOT}/build/darwin_arm64/sysroot" cmake --install "${build_dir}" >/dev/null
    fi

    if [[ -d "${SRC_EXTRACT_DIR}/${PKG_NAME}-${PKG_VER}/LICENSES" ]]; then
        mkdir -p "${stage_dir}/opt/pacman/share/licenses/${PKG_NAME}"
        cp -a "${SRC_EXTRACT_DIR}/${PKG_NAME}-${PKG_VER}/LICENSES/"* "${stage_dir}/opt/pacman/share/licenses/${PKG_NAME}/" 2>/dev/null || true
    fi

    find "${stage_dir}" -name ".DS_Store" -delete 2>/dev/null || true

    # Normalize LC_RPATH (remove any cross-compile sysroot/build-tree RPATHs added by KDECMakeSettings) and ad-hoc codesign Mach-O binaries
    while IFS= read -r -d '' f; do
        if file -b "$f" | grep -qE "Mach-O.*(executable|dynamically linked shared library|bundle)"; then
            while IFS= read -r rp; do
                if [[ -n "${rp}" && "${rp}" != "/opt/pacman/lib" && "${rp}" != "@loader_path"* && "${rp}" != "@executable_path"* ]]; then
                    install_name_tool -delete_rpath "${rp}" "$f" 2>/dev/null || true
                fi
            done < <(otool -l "$f" | awk '/cmd LC_RPATH/{getline; getline; if ($1 == "path") print $2}')
            codesign --sign - --force "$f" 2>/dev/null || true
        fi
    done < <(find "${stage_dir}/opt/pacman" -type f -print0)

    local installed_size builddate
    installed_size=$(du -sk "${stage_dir}/opt/pacman" | awk '{print $1 * 1024}')
    builddate=$(date +%s)

    local deps_list=()
    while IFS= read -r d; do
        [[ -n "${d}" ]] && deps_list+=("${d}")
    done < <(bash -c "source '${PKGBUILD_FILE}' && printf '%s\n' \"\${depends[@]:-}\"")

    {
        echo "# Generated by kf6_darwin build-module.sh"
        echo "pkgname = ${PKG_NAME}"
        echo "pkgbase = ${PKG_NAME}"
        echo "xdata = pkgtype=pkg"
        echo "pkgver = ${PKG_VER}-${PKG_REL}"
        echo "pkgdesc = ${PKG_DESC}"
        echo "url = ${PKG_URL}"
        echo "builddate = ${builddate}"
        echo "packager = Revanth <revanth@darwin>"
        echo "size = ${installed_size}"
        echo "arch = ${pkg_arch}"
        echo "license = BSD-3-Clause"
        echo "license = LGPL-2.1-or-later"
        for dep in "${deps_list[@]:-}"; do
            [[ -n "${dep}" ]] && echo "depend = ${dep}"
        done
    } > "${stage_dir}/.PKGINFO"

    cat > "${stage_dir}/.BUILDINFO" <<EOF
format = 2
pkgname = ${PKG_NAME}
pkgbase = ${PKG_NAME}
pkgver = ${PKG_VER}-${PKG_REL}
pkgarch = ${pkg_arch}
pkgbuild_sha256sum = $(shasum -a 256 "${PKGBUILD_FILE}" | awk '{print $1}')
packager = Revanth <revanth@darwin>
builddate = ${builddate}
builddir = ${build_dir}
startdir = ${REPO_ROOT}
buildtool = makepkg-darwin
buildenv = !distcc
buildenv = color
buildenv = !ccache
EOF

    (
        cd "${stage_dir}"
        rm -f .MTREE "${pkg_out}"
        find .PKGINFO .BUILDINFO opt -print0 | LC_ALL=C /usr/bin/sort -z | \
            LANG=C bsdtar -cnf - --null -T - \
            --uid 0 --gid 0 --uname root --gname wheel \
            --format=mtree \
            --options='!all,use-set,type,uid,gid,mode,time,size,md5,sha256,link' \
            | gzip -c -f -n > .MTREE

        find .PKGINFO .BUILDINFO .MTREE opt -print0 | LC_ALL=C /usr/bin/sort -z | \
            LANG=C bsdtar -cnf - --null -T - \
            --uid 0 --gid 0 --uname root --gname wheel \
            | zstd -T0 -19 -o "${pkg_out}"
    )

    "${SCRIPT_DIR}/audit-package.sh" "${pkg_out}" "${arch}"

    if [[ "${DO_INSTALL}" == "true" && "${arch}" == "$(uname -m)" ]]; then
        echo "==> Installing ${pkg_out} into /opt/pacman..."
        /opt/pacman/bin/pacman -U --noconfirm "${pkg_out}"
    fi
}

if [[ "${ARCH_TARGET}" == "x86_64" || "${ARCH_TARGET}" == "both" ]]; then
    build_for_arch "x86_64"
fi
if [[ "${ARCH_TARGET}" == "arm64" || "${ARCH_TARGET}" == "both" ]]; then
    build_for_arch "arm64"
fi

"${SCRIPT_DIR}/generate-hashes.sh"

