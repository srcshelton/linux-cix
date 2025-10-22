#! /usr/bin/env bash

set -euo pipefail

# Merge base and overlay Kconfig fragments
#
# Usage: merge-overlay.sh <base-config> <overlay-file> <output-dir>
base="${1:-}"
overlay="${2:-}"
dir="${3:-}"

[[ -n "${base:-}" && -n "${overlay:-}" ]] ||
	exit 1

if [[ -z "${dir:-}" ]]; then
	echo >&2 "FATAL:  Output directory '${dir}' is not specified"
	exit 1
fi
if ! [[ -s "${base}" ]]; then
	echo >&2 "FATAL: Base configuration '${base}' is missing or empty"
	exit 1
fi
if ! [[ -s "${overlay}" ]]; then
	echo >&2 "WARN:  Configuration overlay '${overlay}' is missing or empty"
	cp "${base}" "${dir}"/.config
	exit 0
fi

# Prefer kernel's merge_config if present
if [[ -x "scripts/kconfig/merge_config.sh" ]]; then
	scripts/kconfig/merge_config.sh -O "${dir}" -r "${base}" "${overlay}"
	exit ${?}
else
	echo >&2 "WARN:  'scripts/kconfig/merge_config.sh' not executable, falling back to 'olddefconfig' merges only"

	if ! mkdir -p "${dir}"; then
		echo >&2 "FATAL: mkdir() on '${dir}' failed: ${?}"
		exit ${?}
	fi
		
	# Fallback: simple append + olddefconfig approach:
	cp "${base}" "${dir}"/.config
	cat "${overlay}" >> "${dir}"/.config
	# try olddefconfig to make sure unresolved symbols get defaults
	make V=1 O="${dir}" -C . olddefconfig
fi

# vi: set colorcolumn=80 sw=4 syntax=bash ts=4
