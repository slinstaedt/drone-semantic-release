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
if test "${_msg:0:${#_prefix}}" != "$_prefix" && test -n "${DRONE_WORKSPACE:-}"; then
	case ${PLUGIN_MODE:-push} in
		push)
			echo "standard-version $@ $_params"
			standard-version $@ $_params
			git push --set-upstream origin $DRONE_COMMIT_BRANCH
			git push --tags
			;;
		prepare)
			echo "standard-version $@ $_params"
			standard-version $@ $_params
			git checkout -d $(git describe --exact-match --abbrev=0)
			;;
		perform)
			git checkout $DRONE_COMMIT_BRANCH
			git push --set-upstream origin $DRONE_COMMIT_BRANCH
			git push --tags
			;;
	esac
else
	# Bitbucket ignores [SKIP CI]
	echo "Skipping release for commit: $_msg"
fi
