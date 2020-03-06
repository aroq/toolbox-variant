#!/usr/bin/env bash

# Set strict bash mode
set -euo pipefail

function toolbox_variant_exec() {
  _log TRACE "Start 'toolbox_variant_exec' function with args: $*"
  TOOLBOX_DOCKER_SKIP=${TOOLBOX_DOCKER_SKIP-false}
  if [ "${TOOLBOX_DOCKER_SKIP}" == "true" ]; then
    _log DEBUG "Skip processing of variant variables"
  else
    _toolbox_variant_prepare_env_vars "$@"
  fi

  toolbox_wrap_exec "${@}"
  _log TRACE "End 'toolbox_variant_exec' function"
}

function _toolbox_variant_prepare_env_vars() {
  _log TRACE "Start 'toolbox_variant_prepare_env_vars' function with args: $*"

  TOOLBOX_DOCKER_ENV_PREFIX_ARRAY=${TOOLBOX_DOCKER_ENV_PREFIX_ARRAY:-()}
  TOOLBOX_DOCKER_ENV_PREFIX_ARRAY+=("VARIANT_")

  _log TRACE "END 'toolbox_variant_prepare_env_vars' function"
}
