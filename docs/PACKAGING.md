# `kf6_darwin` Packaging & Automation Guide (Fish Shell Compatible)

## 1. Building, Auditing, and Installing a Package

All commands below are directly compatible with the **Fish** shell.

```fish
# Build a single module for both darwin_x86_64 and darwin_arm64 and install via pacman -U:
./scripts/build-module.sh extra-cmake-modules --arch both --install

# Audit any built package archive or Mach-O binary:
./scripts/audit-package.sh out/darwin_x86_64/gwenview-26.08.2-1-darwin_x86_64.pkg.tar.zst x86_64
./scripts/audit-package.sh out/darwin_arm64/gwenview-26.08.2-1-darwin_arm64.pkg.tar.zst arm64
```

## 2. Installing Packages Directly with `pacman -U`

```fish
# Install all KF6 dependencies, frameworks, and Gwenview in topological order:
/opt/pacman/bin/pacman -U --noconfirm \
    out/darwin_x86_64/libjpeg-turbo-3.2.1-1-darwin_x86_64.pkg.tar.zst \
    out/darwin_x86_64/libpng-1.6.59-1-darwin_x86_64.pkg.tar.zst \
    out/darwin_x86_64/libtiff-4.7.2-1-darwin_x86_64.pkg.tar.zst \
    out/darwin_x86_64/lcms2-2.20-1-darwin_x86_64.pkg.tar.zst \
    out/darwin_x86_64/exiv2-0.28.9-1-darwin_x86_64.pkg.tar.zst \
    out/darwin_x86_64/extra-cmake-modules-6.31.0-1-darwin_x86_64.pkg.tar.zst \
    out/darwin_x86_64/kcoreaddons-6.31.0-1-darwin_x86_64.pkg.tar.zst \
    out/darwin_x86_64/kconfig-6.31.0-1-darwin_x86_64.pkg.tar.zst \
    out/darwin_x86_64/ki18n-6.31.0-1-darwin_x86_64.pkg.tar.zst \
    out/darwin_x86_64/kwidgetsaddons-6.31.0-1-darwin_x86_64.pkg.tar.zst \
    out/darwin_x86_64/kguiaddons-6.31.0-1-darwin_x86_64.pkg.tar.zst \
    out/darwin_x86_64/kitemmodels-6.31.0-1-darwin_x86_64.pkg.tar.zst \
    out/darwin_x86_64/kwindowsystem-6.31.0-1-darwin_x86_64.pkg.tar.zst \
    out/darwin_x86_64/karchive-6.31.0-1-darwin_x86_64.pkg.tar.zst \
    out/darwin_x86_64/kdbusaddons-6.31.0-1-darwin_x86_64.pkg.tar.zst \
    out/darwin_x86_64/solid-6.31.0-1-darwin_x86_64.pkg.tar.zst \
    out/darwin_x86_64/kcodecs-6.31.0-1-darwin_x86_64.pkg.tar.zst \
    out/darwin_x86_64/kitemviews-6.31.0-1-darwin_x86_64.pkg.tar.zst \
    out/darwin_x86_64/sonnet-6.31.0-1-darwin_x86_64.pkg.tar.zst \
    out/darwin_x86_64/kcrash-6.31.0-1-darwin_x86_64.pkg.tar.zst \
    out/darwin_x86_64/kcolorscheme-6.31.0-1-darwin_x86_64.pkg.tar.zst \
    out/darwin_x86_64/knotifications-6.31.0-1-darwin_x86_64.pkg.tar.zst \
    out/darwin_x86_64/kcompletion-6.31.0-1-darwin_x86_64.pkg.tar.zst \
    out/darwin_x86_64/kconfigwidgets-6.31.0-1-darwin_x86_64.pkg.tar.zst \
    out/darwin_x86_64/kiconthemes-6.31.0-1-darwin_x86_64.pkg.tar.zst \
    out/darwin_x86_64/kservice-6.31.0-1-darwin_x86_64.pkg.tar.zst \
    out/darwin_x86_64/kjobwidgets-6.31.0-1-darwin_x86_64.pkg.tar.zst \
    out/darwin_x86_64/kbookmarks-6.31.0-1-darwin_x86_64.pkg.tar.zst \
    out/darwin_x86_64/ktextwidgets-6.31.0-1-darwin_x86_64.pkg.tar.zst \
    out/darwin_x86_64/kxmlgui-6.31.0-1-darwin_x86_64.pkg.tar.zst \
    out/darwin_x86_64/kio-6.31.0-1-darwin_x86_64.pkg.tar.zst \
    out/darwin_x86_64/kparts-6.31.0-1-darwin_x86_64.pkg.tar.zst \
    out/darwin_x86_64/gwenview-26.08.2-1-darwin_x86_64.pkg.tar.zst
```

## 3. Launching Native macOS Gwenview

```fish
# Run Gwenview directly or via macOS open:
/opt/pacman/Applications/KDE/gwenview.app/Contents/MacOS/gwenview
# or:
open /opt/pacman/Applications/KDE/gwenview.app
```

## 4. Regenerating Hash Manifests & Checking Upstream Updates

```fish
# Regenerate out/latest-hashes.txt and out/latest-hashes.json:
./scripts/generate-hashes.sh

# Check upstream KDE invent tags and auto-package:
./scripts/auto-update-and-package.sh --module extra-cmake-modules --arch both
```
