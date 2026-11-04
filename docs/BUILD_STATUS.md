# `kf6_darwin` Build & Validation Status Matrix

All 33 packages (27 KDE Frameworks 6 modules at `6.31.0-1`, 5 image/metadata/color dependencies, and KDE `gwenview` `26.08.2-1`) are built, audited (`scripts/audit-package.sh`), installed into `/opt/pacman` via `/opt/pacman/bin/pacman -U --noconfirm`, and smoke-tested across both `darwin_x86_64` and `darwin_arm64`.

| Tier | Package | Version | `darwin_x86_64` | `darwin_arm64` | Installed (`/opt/pacman`) | Smoke Test | Status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Dep | `libjpeg-turbo` | `3.2.1-1` | PASS | PASS | `pacman -U` (`0 missing`) | `gwenview_smoketest` | `validated` |
| Dep | `libpng` | `1.6.59-1` | PASS | PASS | `pacman -U` (`0 missing`) | `gwenview_smoketest` | `validated` |
| Dep | `libtiff` | `4.7.2-1` | PASS | PASS | `pacman -U` (`0 missing`) | `gwenview_smoketest` | `validated` |
| Dep | `lcms2` | `2.20-1` | PASS | PASS | `pacman -U` (`0 missing`) | `gwenview_smoketest` | `validated` |
| Dep | `exiv2` | `0.28.9-1` | PASS | PASS | `pacman -U` (`0 missing`) | `gwenview_smoketest` | `validated` |
| Tier 0 | `extra-cmake-modules` | `6.31.0-1` | PASS | PASS | `pacman -U` (`0 missing`) | `ecm_smoketest` | `validated` |
| Tier 1 | `kcoreaddons` | `6.31.0-1` | PASS | PASS | `pacman -U` (`0 missing`) | `kcoreaddons_smoketest` | `validated` |
| Tier 1 | `kconfig` | `6.31.0-1` | PASS | PASS | `pacman -U` (`0 missing`) | `kconfig_smoketest` | `validated` |
| Tier 1 | `ki18n` | `6.31.0-1` | PASS | PASS | `pacman -U` (`0 missing`) | `ki18n_smoketest` | `validated` |
| Tier 1 | `kwidgetsaddons` | `6.31.0-1` | PASS | PASS | `pacman -U` (`0 missing`) | `kwidgetsaddons_smoketest` | `validated` |
| Tier 1 | `kguiaddons` | `6.31.0-1` | PASS | PASS | `pacman -U` (`0 missing`) | `kguiaddons_smoketest` | `validated` |
| Tier 1 | `kitemmodels` | `6.31.0-1` | PASS | PASS | `pacman -U` (`0 missing`) | `kitemmodels_smoketest` | `validated` |
| Tier 1 | `kwindowsystem` | `6.31.0-1` | PASS | PASS | `pacman -U` (`0 missing`) | `kwindowsystem_smoketest` | `validated` |
| Tier 1 | `karchive` | `6.31.0-1` | PASS | PASS | `pacman -U` (`0 missing`) | `karchive_smoketest` | `validated` |
| Tier 1 | `kdbusaddons` | `6.31.0-1` | PASS | PASS | `pacman -U` (`0 missing`) | `kdbusaddons_smoketest` | `validated` |
| Tier 1 | `solid` | `6.31.0-1` | PASS | PASS | `pacman -U` (`0 missing`) | `solid_smoketest` | `validated` |
| Tier 1 | `kcodecs` | `6.31.0-1` | PASS | PASS | `pacman -U` (`0 missing`) | `kcodecs_smoketest` | `validated` |
| Tier 1 | `kitemviews` | `6.31.0-1` | PASS | PASS | `pacman -U` (`0 missing`) | `kitemviews_smoketest` | `validated` |
| Tier 1 | `sonnet` | `6.31.0-1` | PASS | PASS | `pacman -U` (`0 missing`) | `sonnet_smoketest` | `validated` |
| Tier 2 | `kcrash` | `6.31.0-1` | PASS | PASS | `pacman -U` (`0 missing`) | `kcrash_smoketest` | `validated` |
| Tier 2 | `kcolorscheme` | `6.31.0-1` | PASS | PASS | `pacman -U` (`0 missing`) | `kcolorscheme_smoketest` | `validated` |
| Tier 2 | `knotifications` | `6.31.0-1` | PASS | PASS | `pacman -U` (`0 missing`) | `knotifications_smoketest` | `validated` |
| Tier 2 | `kcompletion` | `6.31.0-1` | PASS | PASS | `pacman -U` (`0 missing`) | `kcompletion_smoketest` | `validated` |
| Tier 2 | `kconfigwidgets` | `6.31.0-1` | PASS | PASS | `pacman -U` (`0 missing`) | `kconfigwidgets_smoketest` | `validated` |
| Tier 2 | `kiconthemes` | `6.31.0-1` | PASS | PASS | `pacman -U` (`0 missing`) | `kiconthemes_smoketest` | `validated` |
| Tier 2 | `kservice` | `6.31.0-1` | PASS | PASS | `pacman -U` (`0 missing`) | `kservice_smoketest` | `validated` |
| Tier 2 | `kjobwidgets` | `6.31.0-1` | PASS | PASS | `pacman -U` (`0 missing`) | `kjobwidgets_smoketest` | `validated` |
| Tier 2 | `kbookmarks` | `6.31.0-1` | PASS | PASS | `pacman -U` (`0 missing`) | `kbookmarks_smoketest` | `validated` |
| Tier 2 | `ktextwidgets` | `6.31.0-1` | PASS | PASS | `pacman -U` (`0 missing`) | `ktextwidgets_smoketest` | `validated` |
| Tier 3 | `kxmlgui` | `6.31.0-1` | PASS | PASS | `pacman -U` (`0 missing`) | `kxmlgui_smoketest` | `validated` |
| Tier 3 | `kio` | `6.31.0-1` | PASS | PASS | `pacman -U` (`0 missing`) | `kio_smoketest` | `validated` |
| Tier 3 | `kparts` | `6.31.0-1` | PASS | PASS | `pacman -U` (`0 missing`) | `kparts_smoketest` | `validated` |
| App | `gwenview` | `26.08.2-1` | PASS | PASS | `pacman -U` (`0 missing`) | `gwenview_smoketest` | `validated` |

See [`out/latest-hashes.txt`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/out/latest-hashes.txt) and [`out/latest-hashes.json`](file:///Users/revanth/Projects/porting_arch_apps/kf6_darwin/out/latest-hashes.json) for full SHA-256 and SHA-512 cryptographic digests of all source tarballs and built packages.
