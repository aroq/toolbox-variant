#!/usr/bin/env bash

# Set strict bash mode
set -euo pipefail

function _prepare_variant_env_vars {
  local variant_env_file
  variant_env_file="$(mktemp)"

  TOOLBOX_DOCKER_VARIANT_VARS_ENTRYPOINT=${TOOLBOX_DOCKER_VARIANT_VARS_ENTRYPOINT:-sh}

  export TOOLBOX_DOCKER_RUN_TOOL_ENV_FILE=${TOOLBOX_DOCKER_RUN_TOOL_ENV_FILE:-}
  (env | grep ^VARIANT_) >> "${variant_env_file}"
  TOOLBOX_DOCKER_RUN_TOOL_ENV_FILE="${TOOLBOX_DOCKER_RUN_TOOL_ENV_FILE} --env-file=${variant_env_file}"
  _log DEBUG "${YELLOW}'VARIANT_*' variable list - ${variant_env_file}:${RESTORE}"
  _log DEBUG "$(cat "${variant_env_file}")"

  local variant_env_file="toolbox/.toolbox/.tmp/.variant.vars.env"
  docker run --rm -i -t -w "$(pwd)" \
    --entrypoint="${TOOLBOX_DOCKER_VARIANT_VARS_ENTRYPOINT}" \
    -v "$(pwd):$(pwd)" aroq/toolbox \
    -c "yq r -j ${TOOL_PATH} | jq -r '. | recurse(.tasks[]?) | select(.bindParamsFromEnv == true) | .parameters | .[]? | .name' | uniq > ${variant_env_file}"

  _log DEBUG "${YELLOW}Variable list generated from the variant command - ${variant_env_file}:${RESTORE}"
  _log DEBUG "$(cat ${variant_env_file})"

  if [[ -f "${variant_env_file}" ]]; then
    TOOLBOX_DOCKER_RUN_TOOL_ENV_FILE="${TOOLBOX_DOCKER_RUN_TOOL_ENV_FILE} --env-file ${variant_env_file}"
  fi
}

