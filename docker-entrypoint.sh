#!/bin/bash
set -euo pipefail

_params=()
for _kv in $(env); do
    _key=$(echo $_kv | cut -d '=' -f 1)
    _val=$(echo $_kv | cut -d '=' -f 2)
    if [[ "$_key" = PLUGIN_* ]]; then
        _key=${_key#PLUGIN_}
        _params+=("--$(echo $_key | tr '[:upper:]' '[:lower:]' | sed -E 's/_(.)/\U\1/g')=$_val")
        test -v $_key || export $_key=$_val
    fi
done

test -v GIT_AUTHOR_NAME || export GIT_AUTHOR_NAME=drone
test -v GIT_AUTHOR_EMAIL || export GIT_AUTHOR_EMAIL=drone@localhost
test -v GIT_COMMITTER_NAME || export GIT_COMMITTER_NAME=drone
test -v GIT_COMMITTER_EMAIL || export GIT_COMMITTER_EMAIL=drone@localhost
#test -v EMAIL || export EMAIL=drone@localhost

test -f CHANGELOG.md || _params+=("--first-release")
echo "standard-version ${_params[@]} $@"
standard-version "${_params[@]}" "$@"
