# `kf6_darwin` macOS Porting & Cross-Compilation Notes

## 1. `KDEInstallDirsCommon.cmake` `BUNDLEDIR` on macOS (`APPLE`)
- Upstream `extra-cmake-modules` sets `BUNDLEDIR` to an absolute `/Applications/KDE` on `APPLE`.
- Every PKGBUILD and [`scripts/build-module.sh`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/scripts/build-module.sh) passes `-DKDE_INSTALL_BUNDLEDIR="/opt/pacman/Applications/KDE"` so macOS `.app` bundles (`gwenview.app`, `gwenview_importer.app`, `kiod6.app`, `kssld6.app`, `kUrlNavigatorDropIntoNewFolder.app`) stage cleanly inside `/opt/pacman/Applications/KDE`.

## 2. Cross-Compiling `darwin_arm64` from `darwin_x86_64`
- Passing `-DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_SYSTEM_PROCESSOR=arm64` along with `-DCMAKE_OSX_ARCHITECTURES=arm64` sets `CMAKE_CROSSCOMPILING=TRUE`, which activates:
  - `KF6Config`'s host-tooling lookup (`-DKF6_HOST_TOOLING="/opt/pacman/lib/cmake"`) so `KF6::kconfig_compiler` executes the host `x86_64` `/opt/pacman/lib/libexec/kf6/kconfig_compiler_kf6`.
  - `Qt6`'s host-tooling lookup (`-DQT_HOST_PATH="/opt/pacman"`) so `moc`, `rcc`, `uic`, `lrelease`, and `qmltyperegistrar` run natively on the `x86_64` host.
  - `sonnet`'s host trigram generator (`-DPARSETRIGRAMS_EXECUTABLE="/opt/pacman/bin/parsetrigrams6"`).
  - Automatic disabling of host-only Qt Designer plugins (`-DBUILD_DESIGNERPLUGIN=OFF`).
- Because `KDECMakeSettings.cmake` sets `CMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE`, cross-compiled `arm64` binaries initially receive `LC_RPATH` entries pointing to the `arm64` staging sysroot directories. [`scripts/build-module.sh`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/scripts/build-module.sh) strips all non-`/opt/pacman/lib` build-tree RPATHs via `install_name_tool -delete_rpath` and re-signs every Mach-O file (`codesign --sign - --force`), verified by [`scripts/audit-package.sh`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/scripts/audit-package.sh).

## 3. Module-Specific macOS Porting Notes
- **`kcoreaddons`**: Disabled Linux `inotify` (`-DENABLE_INOTIFY=OFF`) so `KDirWatch` uses Qt's native macOS FSEvents/kqueue backend.
- **`karchive`**: Linked against static `/opt/pacman/lib/liblzma.a` (`-DLIBLZMA_LIBRARY=/opt/pacman/lib/liblzma.a`) because `/opt/pacman/lib/liblzma.5.dylib` in the upstream core prefix carried a legacy `/usr/local/opt/xz/lib/liblzma.5.dylib` install name; provided a clean `libzstd.pc` override pointing to `/opt/pacman`.
- **`solid`**: Built with native macOS `IOKit` and `DiskArbitration` backends (`-DBISON_EXECUTABLE=/opt/local/bin/bison` as a build-time parser generator).
- **`sonnet`**: Built with the native macOS `NSSpellChecker` (`AppKit`) backend.
- **`kiconthemes`**: Built with `-DUSE_BreezeIcons=OFF` to avoid requiring `python3-lxml` icon resource generation.
- **`ktextwidgets`**: Built with `-DWITH_TEXT_TO_SPEECH=OFF` since `Qt6TextToSpeech` is not part of the `qt6_darwin` base set.
- **`gwenview` (`26.08.2`)**: Applied [`patches/gwenview/0001-macos-bundle-plist.patch`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/patches/gwenview/0001-macos-bundle-plist.patch) to remove a stale `MACOSX_BUNDLE_INFO_PLIST` reference to a removed `app/MacOSXBundleInfo.plist.in` file, update the bundle display name from `Gwenview5` to `Gwenview`, and fix `MACOSX_BUNDLE_SHORT_VERSION_STRING` to use `${RELEASE_SERVICE_VERSION_MAJOR}.${RELEASE_SERVICE_VERSION_MINOR}`.
