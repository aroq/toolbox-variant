#!/usr/bin/env bash

# Includes
. "{{ getenv "TOOLBOX_DEPS_DIR" "toolbox/deps" }}/toolbox-utils/includes/init.sh"
. "{{ getenv "TOOLBOX_DEPS_DIR" "toolbox/deps" }}/toolbox-utils/includes/util.sh"
. "{{ getenv "TOOLBOX_DEPS_DIR" "toolbox/deps" }}/toolbox-utils/includes/log.sh"
. "{{ getenv "TOOLBOX_DEPS_DIR" "toolbox/deps" }}/toolbox-utils/includes/exec.sh"
. "{{ getenv "TOOLBOX_DEPS_DIR" "toolbox/deps" }}/toolbox-docker/includes/docker.sh"
. "{{ getenv "TOOLBOX_DEPS_DIR" "toolbox/deps" }}/toolbox-wrap/includes/wrap.sh"
. "{{ getenv "TOOLBOX_DEPS_DIR" "toolbox/deps" }}/toolbox-variant/includes/variant.sh"

# Setup variables
{{- if has .task "env" -}}
{{- range $k, $v := .task.env -}}
{{- if $v }}
export {{ $k }}=${ {{- $k }}:-{{ $v }}}
{{- end -}}
{{- end }}
export TOOLBOX_DOCKER_ENV_VARS="-e {{ $s := coll.Keys .task.env }}{{ join $s " -e " }}"
{{ end }}
export TOOLBOX_DOCKER_IMAGE=${TOOLBOX_DOCKER_IMAGE:-{{ .task.image }}}
export TOOLBOX_TOOL_NAME="{{ (ds "task_name" ).name }}"

# Setup tool dirs
{{ if has .task "tool_dirs" -}}
export TOOLBOX_TOOL_DIRS="toolbox,{{ $l := reverse .task.tool_dirs }}{{ join $l "," }}"
{{ end -}}

{{ if has .task "config_context_prefix" -}}
if [ -z "${VARIANT_CONFIG_CONTEXT-}" ]; then
export VARIANT_CONFIG_CONTEXT="{{ $l := reverse .task.config_context_prefix }}{{ join $l "," }}"
else
  export VARIANT_CONFIG_CONTEXT="${VARIANT_CONFIG_CONTEXT},{{ $l := reverse .task.config_context_prefix }}{{ join $l "," }}"
fi
{{ end -}}

{{ if has .task "config_dir_prefix" -}}
if [ -z "${VARIANT_CONFIG_DIR-}" ]; then
export VARIANT_CONFIG_DIR="{{ $l := reverse .task.config_dir_prefix }}{{ join $l "," }}"
else
  export VARIANT_CONFIG_DIR="${VARIANT_CONFIG_DIR},{{ $l := reverse .task.config_dir_prefix }}{{ join $l "," }}"
fi
{{ end -}}

{{ if has .task "cmd" -}}
export TOOLBOX_TOOL={{ .task.cmd}}
{{ else }}
export TOOLBOX_TOOL="tools/${TOOLBOX_TOOL_NAME}"
{{ end -}}

if [ $# -eq 0 ]; then
  toolbox_variant_exec "${TOOLBOX_TOOL}"
else
  toolbox_variant_exec "${TOOLBOX_TOOL}" "${@}"
fi
