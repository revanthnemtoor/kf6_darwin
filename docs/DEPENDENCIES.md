# `kf6_darwin` Dependency Graph & Topological Build Order

## 1. External Read-Only Dependency Roots
- **Qt 6 (`6.12.0-1`)**: `/Users/revanth/Projects/porting_arch_apps/qt6_darwin`
  - Installed into `/opt/pacman` (`darwin_x86_64`) and staged in `staging/pkg_arm64/opt/pacman` & `staging/sysroot_arm64/opt/pacman` (`darwin_arm64`).
  - Packages: `qt6-base`, `qt6-declarative`, `qt6-svg`, `qt6-tools`, `qt6-multimedia`, `qt6-5compat`, `qt6-shadertools`, `qt6-serialport`, `qt6-websockets`, `qt6-connectivity`, `qt6-networkauth`, `qt6-scxml`, `qt6-Quick3D`.
- **Core Pacman Prefix**: `/Users/revanth/Projects/Pacman_Arch_Porting`
  - Installed in `/opt/pacman`: `zlib`, `zstd`, `xz`, `bzip2`, `gettext`, `libunistring`, `libiconv`, `openssl`, `pcre2`, `sqlite`, `dbus`, `expat`.

---

## 2. Non-KDE Application Dependencies (`packages/deps/`)
Built and packaged inside `kf6_darwin` for `/opt/pacman` on both `darwin_x86_64` and `darwin_arm64`:

| Order | Package | Version | Upstream Tag Commit | Direct Dependencies |
| :--- | :--- | :--- | :--- | :--- |
| D1 | [`libjpeg-turbo`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/deps/libjpeg-turbo/PKGBUILD) | `3.2.1-1` | `7b4993786d856cbccabfc0ed2f923ba000e326cc` | None (`WITH_JPEG8=ON`) |
| D2 | [`libpng`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/deps/libpng/PKGBUILD) | `1.6.59-1` | `cd952f49f95bb27154ae77dbb103032d95f6e580` | `zlib` |
| D3 | [`libtiff`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/deps/libtiff/PKGBUILD) | `4.7.2-1` | `d01a94be176f5f6a87f7ee1c0b32e65416aa2b4d` | `zlib`, `zstd`, `xz`, `libjpeg-turbo` |
| D4 | [`lcms2`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/deps/lcms2/PKGBUILD) | `2.20-1` | `7717fce0d85447ef3b2df0cca2e99207c15eeecd` | `libjpeg-turbo`, `libtiff` |
| D5 | [`exiv2`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/deps/exiv2/PKGBUILD) | `0.28.9-1` | `b0859fc61fea5dedfc898aece6b15893ddf4314e` | `expat`, `zlib` |

---

## 3. KDE Frameworks 6 (`6.31.0-1`) & Target Application (`packages/kde/`)

### Tier 0 — Build System Foundation
| Order | Package | Version | Upstream Tag Commit | Direct Dependencies |
| :--- | :--- | :--- | :--- | :--- |
| 1 | [`extra-cmake-modules`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/kde/extra-cmake-modules/PKGBUILD) | `6.31.0-1` | `c85f6ab8ccce20f9fc3cfccb1abbcbe05fb1ff2c` | None |

### Tier 1 — Core Frameworks (Qt 6 + System Libraries Only)
| Order | Package | Version | Upstream Tag Commit | Direct Dependencies |
| :--- | :--- | :--- | :--- | :--- |
| 2 | [`kcoreaddons`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/kde/kcoreaddons/PKGBUILD) | `6.31.0-1` | `fb6c3186aa9f4324802a9aa4d40de923b16eb0e4` | `qt6-base`, `qt6-declarative` |
| 3 | [`kconfig`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/kde/kconfig/PKGBUILD) | `6.31.0-1` | `a2ab6c3217c4c9eb1aa5888116ec25bd030d0591` | `qt6-base`, `qt6-declarative` |
| 4 | [`ki18n`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/kde/ki18n/PKGBUILD) | `6.31.0-1` | `8b7be0ef03a8f5e0c29e3db8f274e74bb83cb982` | `qt6-base`, `qt6-declarative`, `gettext` |
| 5 | [`kwidgetsaddons`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/kde/kwidgetsaddons/PKGBUILD) | `6.31.0-1` | `8a1568b07b09d46e6bf092781cf0c8fa349818f4` | `qt6-base` |
| 6 | [`kguiaddons`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/kde/kguiaddons/PKGBUILD) | `6.31.0-1` | `7b7df9b86c717a49505e86db3ee53c2cb04a3047` | `qt6-base`, `qt6-declarative` |
| 7 | [`kitemmodels`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/kde/kitemmodels/PKGBUILD) | `6.31.0-1` | `4de96d4910688081e730689aa097a230b0da4977` | `qt6-base`, `qt6-declarative` |
| 8 | [`kwindowsystem`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/kde/kwindowsystem/PKGBUILD) | `6.31.0-1` | `0dcab8f288589578c70d76dc58cf854434b19725` | `qt6-base`, `qt6-declarative` |
| 9 | [`karchive`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/kde/karchive/PKGBUILD) | `6.31.0-1` | `3d2a5c32d3b4d0da2bb530e013f472ee7a440d4e` | `qt6-base`, `bzip2`, `xz`, `zlib`, `zstd`, `openssl` |
| 10 | [`kdbusaddons`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/kde/kdbusaddons/PKGBUILD) | `6.31.0-1` | `bc032ef28d078772933aaab7b1ee6bf3a5e78c8b` | `qt6-base` |
| 11 | [`solid`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/kde/solid/PKGBUILD) | `6.31.0-1` | `51f582909ab6d0da69db652c017c91f48b2088a1` | `qt6-base`, `qt6-declarative` (IOKit + DiskArbitration) |
| 12 | [`kcodecs`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/kde/kcodecs/PKGBUILD) | `6.31.0-1` | `66a65d825d9cb46d687b585f6a16866374b76e66` | `qt6-base` |
| 13 | [`kitemviews`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/kde/kitemviews/PKGBUILD) | `6.31.0-1` | `4c99e2d8d59a4a9573b0df44e4a1c176ee8e137c` | `qt6-base` |
| 14 | [`sonnet`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/kde/sonnet/PKGBUILD) | `6.31.0-1` | `5ab9e7f42a31c2e6b7dc78056098df91e6e6bd64` | `qt6-base`, `qt6-declarative` (macOS NSSpellChecker) |

### Tier 2 — Second-Level Frameworks
| Order | Package | Version | Upstream Tag Commit | Direct Dependencies |
| :--- | :--- | :--- | :--- | :--- |
| 15 | [`kcrash`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/kde/kcrash/PKGBUILD) | `6.31.0-1` | `9ee8786eeb2296199f91038f92e70af36f827e8e` | `qt6-base`, `kcoreaddons` |
| 16 | [`kcolorscheme`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/kde/kcolorscheme/PKGBUILD) | `6.31.0-1` | `b01fde3096de99584786aa412e0130661c97f7e8` | `qt6-base`, `kconfig`, `kguiaddons`, `ki18n` |
| 17 | [`knotifications`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/kde/knotifications/PKGBUILD) | `6.31.0-1` | `d9bb48df3a9b8465072f5c12d53dc2e49ab6c95b` | `qt6-base`, `qt6-declarative`, `kconfig`, `kcoreaddons` |
| 18 | [`kcompletion`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/kde/kcompletion/PKGBUILD) | `6.31.0-1` | `b9094f8773b8e143ffd3793a933157b72930499d` | `qt6-base`, `kcodecs`, `kconfig`, `kwidgetsaddons` |
| 19 | [`kconfigwidgets`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/kde/kconfigwidgets/PKGBUILD) | `6.31.0-1` | `02b7a0bd5f9eaff65900dd85029a7edefdfb14bd` | `qt6-base`, `kcodecs`, `kcolorscheme`, `kconfig`, `kcoreaddons`, `kguiaddons`, `ki18n`, `kwidgetsaddons` |
| 20 | [`kiconthemes`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/kde/kiconthemes/PKGBUILD) | `6.31.0-1` | `420364ec1a81b77ea43e4055df8254f29c14bce4` | `qt6-base`, `qt6-svg`, `qt6-declarative`, `karchive`, `kcolorscheme`, `kconfig`, `ki18n`, `kwidgetsaddons` |
| 21 | [`kservice`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/kde/kservice/PKGBUILD) | `6.31.0-1` | `3dd29f7847e88d3f45d833ce1a772738e73915e9` | `qt6-base`, `kconfig`, `kcoreaddons`, `ki18n` |
| 22 | [`kjobwidgets`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/kde/kjobwidgets/PKGBUILD) | `6.31.0-1` | `70d855f13040f1ee64002392629a7ac070a9798d` | `qt6-base`, `kcoreaddons`, `knotifications`, `kwidgetsaddons` |
| 23 | [`kbookmarks`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/kde/kbookmarks/PKGBUILD) | `6.31.0-1` | `4942bef169183eda666f470cf8a18ce4e16ec75e` | `qt6-base`, `kconfig`, `kconfigwidgets`, `kcoreaddons`, `kwidgetsaddons` |
| 24 | [`ktextwidgets`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/kde/ktextwidgets/PKGBUILD) | `6.31.0-1` | `7f7e7b1b5d46a4398b5e41966deab13c59a3035d` | `qt6-base`, `kcompletion`, `kconfig`, `ki18n`, `kwidgetsaddons`, `sonnet` |

### Tier 3 — High-Level Integration Frameworks
| Order | Package | Version | Upstream Tag Commit | Direct Dependencies |
| :--- | :--- | :--- | :--- | :--- |
| 25 | [`kxmlgui`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/kde/kxmlgui/PKGBUILD) | `6.31.0-1` | `e47ccaf51aa34a538117161cac1f0b8039e66526` | `qt6-base`, `kconfig`, `kconfigwidgets`, `kcoreaddons`, `kguiaddons`, `ki18n`, `kiconthemes`, `kitemviews`, `kwidgetsaddons` |
| 26 | [`kio`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/kde/kio/PKGBUILD) | `6.31.0-1` | `2dd4bdc916a6f46d297d8788f5b628181483315d` | `qt6-base`, `karchive`, `kbookmarks`, `kcolorscheme`, `kcompletion`, `kconfig`, `kcoreaddons`, `kcrash`, `kguiaddons`, `ki18n`, `kiconthemes`, `kitemviews`, `kjobwidgets`, `kservice`, `kwidgetsaddons`, `kwindowsystem`, `solid` |
| 27 | [`kparts`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/kde/kparts/PKGBUILD) | `6.31.0-1` | `8269e8ee3ba115ad3bfc665730377ed518f286fb` | `qt6-base`, `kconfig`, `kcoreaddons`, `ki18n`, `kio`, `kjobwidgets`, `kservice`, `kwidgetsaddons`, `kxmlgui` |

### Target Application — KDE Gwenview
| Order | Package | Version | Upstream Tag Commit | Direct Dependencies |
| :--- | :--- | :--- | :--- | :--- |
| 28 | [`gwenview`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/packages/kde/gwenview/PKGBUILD) | `26.08.2-1` | `8b0e102721811a171ccee23ddfb86d0dd8302012` | `qt6-base`, `qt6-multimedia`, `qt6-svg`, `kio`, `kitemmodels`, `ki18n`, `kparts`, `kwindowsystem`, `kiconthemes`, `knotifications`, `kguiaddons`, `kwidgetsaddons`, `kcrash`, `libjpeg-turbo`, `libpng`, `libtiff`, `lcms2`, `exiv2` |
