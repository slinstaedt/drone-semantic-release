#!/bin/sh
set -euo pipefail

source git-env-setup.sh

#test -f CHANGELOG.md || _params+=("--first-release")

_params=""
#_params="$_params $(env2args snake '--scripts.$k \"$v\"' PLUGIN_SCRIPTS_)"
#_params="$_params $(env2args snake '--skip.$k' PLUGIN_SKIP_)"
#_params="$_params $(env2args noop '--dry-run' PLUGIN_DRY_RUN)"
#_params="$_params $(env2args noop '--sign' PLUGIN_SIGN)"
_params="$_params $(env2args camel '--$k "$v"' PLUGIN_SR_)"


_msg=${DRONE_COMMIT_MESSAGE:-''}
_prefix=${PLUGIN_SKIP_ON_COMMIT_PREFIX:-'chore(release)'}
if test "${_msg:0:${#_prefix}}" != "$_prefix"; then
	echo "standard-version $@ $_params"
	standard-version $@ $_params
	if test -n "${DRONE_WORKSPACE:-}" && test "${PLUGIN_SKIP_PUSH:-}" != "true"; then
		git push
		git push --follow-tags
	fi
else
	# Bitbucket ignores [SKIP CI]
	echo "Skipping release for commit: $_msg"
fi
