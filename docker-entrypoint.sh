#!/bin/sh
set -euo pipefail

source git-env-setup.sh

#test -f CHANGELOG.md || _params+=("--first-release")

_params=""
_params="$_params $(env2args snake '--scripts.$k \"$v\"' PLUGIN_SCRIPTS_)"
_params="$_params $(env2args snake '--skip.$k' PLUGIN_SKIP_)"
_params="$_params $(env2args noop '--dry-run' PLUGIN_DRY_RUN)"
_params="$_params $(env2args noop '--sign' PLUGIN_SIGN)"

echo "standard-version $@ $_params"
standard-version $@ $_params
if test -n "${DRONE_WORKSPACE:-}" && test "${PLUGIN_PUSH_SKIP:-}" != "true"; then
	git push
	git push --tags
fi
