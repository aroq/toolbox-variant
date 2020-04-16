#!/usr/bin/env bash

function toolbox_variant_exec() {
  _log TRACE "Start 'toolbox_variant_exec' function with args: $*"

  if [ "${TOOLBOX_EXEC_CONTEXT}" = "HOST" ] || [ "${TOOLBOX_EXEC_CONTEXT}" = "DOCKER_OUTSIDE" ]; then
    _log DEBUG "Skip processing of variant variables"
  else
    toolbox_docker_add_env_var_file_from_prefix "VARIANT_"
  fi

  toolbox_exec_handler "toolbox_wrap_exec" "$@"

  _log TRACE "End 'toolbox_variant_exec' function"
}
