{{/* vim: set filetype=mustache: */}}

{{- define "image.registry" -}}
{{ default .Values.images.registry .Values.global.imageRegistry  }}
{{- end -}}

{{- define "image.repository" -}}
{{ default .Values.images.repository.comon .Values.global.imageRegistry  }}
{{- end -}}

{{- define "imagePullSecrets" }}
{{- if .Values.global.imagePullSecrets }}
  {{- range .Values.global.imagePullSecrets }}
- name: {{ . }}
  {{- end }}
{{- end }}
{{- end }}

{{/*
Merge global and backend server environment variables
*/}}
{{- define "backend_server_env" -}}
{{- $globalEnv := .Values.global.env | default (dict) -}}
{{- $localEnv := .Values.app.backend_server.env | default (dict) -}}
{{- $mergedEnv := merge $localEnv $globalEnv (dict "ENV" .Release.Namespace ) -}}
{{- $mergedEnv | toYaml | nindent 2 -}}
{{- end -}}

{{/*
Merge global and web server environment variables
*/}}
{{- define "web_server_env" -}}
{{- $globalEnv := .Values.global.env | default (dict) -}}
{{- $localEnv := .Values.app.web_server.env | default (dict) -}}
{{- $mergedEnv := merge $localEnv $globalEnv (dict "ENV" .Release.Namespace ) -}}
{{- $mergedEnv | toYaml | nindent 2 -}}
{{- end -}}

{{/*
Merge global and room server environment variables
*/}}
{{- define "room_server_env" -}}
{{- $globalEnv := .Values.global.env | default (dict) -}}
{{- $localEnv := .Values.app.room_server.env | default (dict) -}}
{{- $mergedEnv := merge $localEnv $globalEnv (dict "ENV" .Release.Namespace ) -}}
{{- $mergedEnv | toYaml | nindent 2 -}}
{{- end -}}


{{/*
Merge global and socket server environment variables
*/}}
{{- define "socket_server_env" -}}
{{- $globalEnv := .Values.global.env | default (dict) -}}
{{- $localEnv := .Values.app.socket_server.env | default (dict) -}}
{{- $mergedEnv := merge  $localEnv $globalEnv (dict "ENV" .Release.Namespace ) -}}
{{- $mergedEnv | toYaml | nindent 2 -}}
{{- end -}}


{{/*
Merge global and fusion server environment variables
*/}}
{{- define "fusion_server_env" -}}
{{- $globalEnv := .Values.global.env | default (dict) -}}
{{- $localEnv := .Values.app.fusion_server.env | default (dict) -}}
{{- $mergedEnv := merge  $localEnv $globalEnv (dict "ENV" .Release.Namespace ) -}}
{{- $mergedEnv | toYaml | nindent 2 -}}
{{- end -}}


{{/*
Merge global and document server environment variables
*/}}
{{- define "document_server_env" -}}
{{- $globalEnv := .Values.global.env | default (dict) -}}
{{- $localEnv := .Values.app.document_server.env | default (dict) -}}
{{- $mergedEnv := merge  $localEnv $globalEnv (dict "ENV" .Release.Namespace ) -}}
{{- $mergedEnv | toYaml | nindent 2 -}}
{{- end -}}

{{/*
Merge global and nest_rest server environment variables
*/}}
{{- define "nest_rest_server_env" -}}
{{- $globalEnv := .Values.global.env | default (dict) -}}
{{- $localEnv := .Values.app.nest_rest_server.env | default (dict) -}}
{{- $mergedEnv := merge  $localEnv $globalEnv (dict "ENV" .Release.Namespace ) -}}
{{- $mergedEnv | toYaml | nindent 2 -}}
{{- end -}}


{{/*
Merge global and image_proxy server environment variables
*/}}
{{- define "imageproxy_server_env" -}}
{{- $globalEnv := .Values.global.env | default (dict) -}}
{{- $localEnv := .Values.app.imageproxy_server.env | default (dict) -}}
{{- $mergedEnv := merge  $localEnv $globalEnv (dict "ENV" .Release.Namespace ) -}}
{{- $mergedEnv | toYaml | nindent 2 -}}
{{- end -}}

{{/*
Merge global and space_job_executor server environment variables
*/}}
{{- define "space_job_executor_env" -}}
{{- $globalEnv := .Values.global.env | default (dict) -}}
{{- $localEnv := .Values.app.space_job_executor.env | default (dict) -}}
{{- $mergedEnv := merge  $localEnv $globalEnv (dict "ENV" .Release.Namespace ) -}}
{{- $mergedEnv | toYaml | nindent 2 -}}
{{- end -}}

{{/*
Merge global and databus server environment variables
*/}}
{{- define "databus_server_env" -}}
{{- $globalEnv := .Values.global.env | default (dict) -}}
{{- $localEnv := .Values.app.databus_server.env | default (dict) -}}
{{- $mergedEnv := merge  $localEnv $globalEnv (dict "ENV" .Release.Namespace ) -}}
{{- $mergedEnv | toYaml | nindent 2 -}}
{{- end -}}

{{/*
Merge global and ai server environment variables
*/}}
{{- define "ai_server_env" -}}
{{- $globalEnv := .Values.global.env | default (dict) -}}
{{- $localEnv := .Values.app.ai_server.env | default (dict) -}}
{{- $mergedEnv := merge  $localEnv $globalEnv (dict "ENV" .Release.Namespace ) -}}
{{- $mergedEnv | toYaml | nindent 2 -}}
{{- end -}}

{{/*
Merge global and dingtalk server environment variables
*/}}
{{- define "dingtalk_server_env" -}}
{{- $globalEnv := .Values.global.env | default (dict) -}}
{{- $localEnv := .Values.app.dingtalk_server.env | default (dict) -}}
{{- $mergedEnv := merge  $localEnv $globalEnv (dict "ENV" .Release.Namespace ) -}}
{{- $mergedEnv | toYaml | nindent 2 -}}
{{- end -}}

{{/*
Merge global and init-appdata env environment variables
*/}}
{{- define "appdata_env" -}}
{{- $globalEnv := .Values.global.env | default (dict) -}}
{{- $localEnv := .Values.initAppData | default (dict) -}}
{{- $mergedEnv := merge $localEnv $globalEnv (dict "ENV" .Release.Namespace ) -}}
{{- $mergedEnv | toYaml | nindent 2 -}}
{{- end -}}