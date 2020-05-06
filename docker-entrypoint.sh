#!/bin/sh
set -euo pipefail

function checkDefaults {
    env | grep -q "^$1=" || export $1="$2"
}

checkDefaults DRONE_COMMIT_AUTHOR_NAME drone
checkDefaults DRONE_COMMIT_AUTHOR_EMAIL drone@localhost

for _e in $(env2args); do export $_e; done
checkDefaults GIT_AUTHOR_NAME "$DRONE_COMMIT_AUTHOR_NAME"
checkDefaults GIT_AUTHOR_EMAIL "$DRONE_COMMIT_AUTHOR_EMAIL"
checkDefaults GIT_COMMITTER_NAME "$DRONE_COMMIT_AUTHOR_NAME"
checkDefaults GIT_COMMITTER_EMAIL "$DRONE_COMMIT_AUTHOR_EMAIL"

#test -f CHANGELOG.md || _params+=("--first-release")

_params=""
_params="$_params $(env2args snake '--scripts.$k \"$v\"' PLUGIN_SCRIPTS_)"
_params="$_params $(env2args snake '--skip.$k' PLUGIN_SKIP_)"
_params="$_params $(env2args noop '--dry-run' PLUGIN_DRY_RUN)"
_params="$_params $(env2args noop '--sign' PLUGIN_SIGN)"

echo "standard-version $@ $_params"
standard-version $@ $_params

checkDefaults PUSH false
if [[ "$PUSH" = true ]]; then
    git push --follow-tags
fi
