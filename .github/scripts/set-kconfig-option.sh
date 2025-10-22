#! /usr/bin/env bash

set -euo pipefail

# Very small helper that will append KEY=VALUE to a config-file
#
# Usage: set-kconfig-option.sh <config-file> <KEY> <VALUE>
cfg="${1:-}"
key="${2:-}"
val="${3:-}"

[[ -n "${cfg:-}" && -n "${key:-}" && -n "${val:-}" ]] ||
	exit 1

if ! [[ -f "${cfg}" ]]; then
  echo >&2 "FATAL: Configuration '${cfg}' not found"
  exit 2
fi
if ! [[ -s "${cfg}" ]]; then
  echo >&2 "FATAL: Configuration '${cfg}' is empty"
  exit 2
fi

if [[ -x scripts/config ]]; then
	scripts/config --file "${cfg}" --set-val "${key}" "${val}"
else
	# Remove any previous setting lines for the key
	sed -e "/^${key}=/d" -i "${cfg}" || :

	# Append new value
	echo "${key}=${val}" >> "${cfg}"
fi
