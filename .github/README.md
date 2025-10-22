# Kernel CI for Linux (GitHub Actions)

This CI workflow builds the Linux kernel for the specified branch or commit, supporting GCC and Clang on ARM64 or x86 runners.

## Overview

The pipeline performs the following:
1. Builds selected configs (`defconfig`, `cix.config`, `allyesconfig`, etc.)
2. Enforces strict warnings (`CONFIG_WERROR=y`, `CONFIG_SECTION_MISMATCH_WARN_ONLY=n`)
3. Supports optional caching and clean builds
4. Supports optional checkpatch validation
5. Optionally uploads build artifacts

## Configuration

You can trigger this workflow manually under the **Actions** tab or automatically on commits to tracked branches.

| Input | Description | Default |
|-------|--------------|----------|
| `clean` | Clean cached builds before running | `false` |
| `arch` | Target architecture (`arm64` or `x86_64`) | `arm64` |
| `compiler` | Compiler to use (`gcc` or `clang`) | `gcc` |
| `configs` | Comma-separated list of configs | `defconfig,cix,allyesconfig,allmodconfig` |
| `additional_make_vars` | Extra vars (e.g. `KCFLAGS=-O3`) | empty |
| `enable_checkpatch` | Run checkpatch validation | `false` |
| `enable_artifacts` | Upload build artifacts | `false` |
| `concurrency_limit` | Max parallel jobs | `2` |

## Helper Scripts

- `.github/scripts/merge-overlay.sh`: merges a base and overlay config
- `.github/scripts/set-kconfig-option.sh`: forces config values

## Example

To build the kernel using Clang and `KCFLAGS=-O3`:

```bash
gh workflow run Kernel-CI --ref v6.6-mybranch -f compiler=clang -f additional_make_vars="KCFLAGS=-O3"
```

## Extending

You can pin toolchains or use Docker containers by extending the setup stage.

- **Pin toolchains:** Download specific GCC/Clang versions at setup.
- **Custom containers:** Set `container:` in the job definition.
- **Reproducible toolchains:** Use known tarballs (e.g. from kernel.org toolchains).

