{{/*
Set redis host
*/}}
{{- define "redis.host" -}}
{{- if .Values.redis.enabled -}}
{{- .Values.redis.host }}
{{- end -}}
{{- end -}}

{{/*
Set redis port
*/}}
{{- define "redis.port" -}}
{{- if .Values.redis.enabled -}}
{{- .Values.redis.port }}
{{- end -}}
{{- end -}}

{{/*
Set mysql host
*/}}
{{- define "mysql.host" -}}
{{- if .Values.mysql.enabled -}}
{{- .Values.mysql.host }}
{{- end -}}
{{- end -}}

{{/*
Set mysql port
*/}}
{{- define "mysql.port" -}}
{{- if .Values.mysql.enabled -}}
{{- .Values.mysql.port }}
{{- end -}}
{{- end -}}

{{/*
Set minio host
*/}}
{{- define "minio.host" -}}
{{- if .Values.minio.enabled -}}
{{- .Values.minio.host }}
{{- end -}}
{{- end -}}

{{/*
Set minio port
*/}}
{{- define "minio.port" -}}
{{- if .Values.minio.enabled -}}
{{- .Values.minio.port }}
{{- end -}}
{{- end -}}


{{- define "imagePullSecret" }}
{{- with .Values.global.imageCredentials }}
{{- printf "{\"auths\":{\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"email\":\"%s\",\"auth\":\"%s\"}}}" .registry .username .password .email (printf "%s:%s" .username .password | b64enc) | b64enc }}
{{- end }}
{{- end }}

