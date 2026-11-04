# Maintainer: Revanth Reddy Nemtoor <revanthreddyn123@gmail.com>
# Root PKGBUILD entrypoint for the current primary milestone (extra-cmake-modules)
# Canonical per-module PKGBUILDs reside in packages/kde/<pkgname>/PKGBUILD.
pkgname=extra-cmake-modules
pkgver=6.31.0
pkgrel=1
pkgdesc="Extra modules and scripts for CMake (KDE Frameworks 6 for Darwin)"
arch=('darwin_x86_64' 'darwin_arm64')
url="https://invent.kde.org/frameworks/extra-cmake-modules"
license=('BSD-3-Clause' 'BSD-2-Clause' 'MIT' 'CC0-1.0')
depends=()
makedepends=('cmake' 'ninja')
options=('!strip')
_commit="2958379fb49c71129f119ec17f88df0b5ea21550" # refs/tags/v6.31.0^{}
source=("https://download.kde.org/stable/frameworks/${pkgver%.*}/${pkgname}-${pkgver}.tar.xz")
sha256sums=('8f74af329e4c918358bfe54316f8cf4d530c28444595a3e2fb15075f72877f17')
sha512sums=('312f8cc67dce2730e7751d80861c3fa1f220efa3230dc63d79641a9e8b1d95d0888ad8de9f7ee059e634a897a0d2a2d7ec80685fea96e1fd93f90c093a0817c0')

build() {
  local _arch
  case "${CARCH:-$(uname -m)}" in
    x86_64|darwin_x86_64) _arch="x86_64" ;;
    arm64|darwin_arm64)   _arch="arm64" ;;
    *)                    _arch="$(uname -m)" ;;
  esac

  export PKG_CONFIG_PATH="/opt/pacman/lib/pkgconfig"
  export PATH="/opt/pacman/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/local/bin:/usr/local/bin"

  cmake -B build -S "${pkgname}-${pkgver}" -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/opt/pacman \
    -DCMAKE_OSX_ARCHITECTURES="${_arch}" \
    -DCMAKE_OSX_DEPLOYMENT_TARGET=15.0 \
    -DCMAKE_PREFIX_PATH=/opt/pacman \
    -DCMAKE_IGNORE_PREFIX_PATH="/opt/local;/usr/local;/opt/homebrew" \
    -DBUILD_HTML_DOCS=OFF \
    -DBUILD_MAN_DOCS=OFF \
    -DBUILD_QTHELP_DOCS=OFF \
    -DBUILD_TESTING=OFF

  cmake --build build --parallel
}

package() {
  DESTDIR="${pkgdir}" cmake --install build

  if [[ -d "${pkgname}-${pkgver}/LICENSES" ]]; then
    install -d "${pkgdir}/opt/pacman/share/licenses/${pkgname}"
    cp -a "${pkgname}-${pkgver}/LICENSES/"* "${pkgdir}/opt/pacman/share/licenses/${pkgname}/"
  fi

  find "${pkgdir}" -name ".DS_Store" -delete 2>/dev/null || true
}

