# KF6 Darwin (`kf6_darwin`)

Native macOS packaging and porting project for **KDE Frameworks 6 (KF6 6.31.0)** and **KDE Gwenview (26.08.2)** across Intel (`darwin_x86_64`) and Apple Silicon (`darwin_arm64`), built atop the **Qt 6.12.0 Darwin** foundation in `/opt/pacman`.

## Project Scope & Independence
- **Target Installation Prefix**: `/opt/pacman`
- **Supported Architectures**: `darwin_x86_64` and `darwin_arm64`
- **Total Packaged Modules**: **33 packages** (66 Darwin archives across `darwin_x86_64` and `darwin_arm64`):
  - **Non-KDE Dependencies (5)**: `libjpeg-turbo` (`3.2.1-1`), `libpng` (`1.6.59-1`), `libtiff` (`4.7.2-1`), `lcms2` (`2.20-1`), `exiv2` (`0.28.9-1`)
  - **KF6 Tier 0 (1)**: `extra-cmake-modules` (`6.31.0-1`)
  - **KF6 Tier 1 (13)**: `kcoreaddons`, `kconfig`, `ki18n`, `kwidgetsaddons`, `kguiaddons`, `kitemmodels`, `kwindowsystem`, `karchive`, `kdbusaddons`, `solid`, `kcodecs`, `kitemviews`, `sonnet` (all `6.31.0-1`)
  - **KF6 Tier 2 (10)**: `kcrash`, `kcolorscheme`, `knotifications`, `kcompletion`, `kconfigwidgets`, `kiconthemes`, `kservice`, `kjobwidgets`, `kbookmarks`, `ktextwidgets` (all `6.31.0-1`)
  - **KF6 Tier 3 (3)**: `kxmlgui`, `kio`, `kparts` (all `6.31.0-1`)
  - **Target Application (1)**: `gwenview` (`26.08.2-1`, native macOS `.app` bundle + `libgwenviewlib.6.dylib` + `kimageannotator-qt6`)

## Directory Layout
```text
kf6_darwin/
├── PKGBUILD
├── README.md
├── LICENSE
├── packages/
│   ├── deps/         # PKGBUILDs for libjpeg-turbo, libpng, libtiff, lcms2, exiv2
│   └── kde/          # PKGBUILDs for all 27 KF6 modules + gwenview
├── patches/
│   └── gwenview/     # macOS bundle Info.plist patch for gwenview 26.08.2
├── scripts/
│   ├── build-module.sh
│   ├── auto-update-and-package.sh
│   ├── dependency-check.sh
│   ├── audit-package.sh
│   └── generate-hashes.sh
├── out/
│   ├── latest-hashes.txt
│   └── latest-hashes.json
├── tests/
│   ├── smoketest/    # 29 standalone CMake smoke tests (x86_64 + arm64)
│   ├── integration/
│   └── architecture/
└── docs/
    ├── DEPENDENCIES.md
    ├── BUILD_STATUS.md
    ├── PACKAGING.md
    └── PORTING_NOTES.md
```

## Quick Commands

```bash
# Build, audit, and package any module for both architectures:
./scripts/build-module.sh <module> all

# Audit a built Pacman archive:
./scripts/audit-package.sh out/darwin_x86_64/<pkg>.pkg.tar.zst darwin_x86_64

# Regenerate SHA-256 / SHA-512 hash manifests:
./scripts/generate-hashes.sh
```
