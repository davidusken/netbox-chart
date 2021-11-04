{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "netbox.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "netbox.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Fully qualified app name for postgresql child chart.
*/}}
{{- define "netbox.postgresql.fullname" -}}
{{- if .Values.postgresql.fullnameOverride }}
{{- .Values.postgresql.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "postgresql" .Values.postgresql.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Fully qualified app name for redis child chart.
*/}}
{{- define "netbox.redis.fullname" -}}
{{- if .Values.redis.fullnameOverride }}
{{- .Values.redis.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "redis" .Values.redis.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "netbox.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "netbox.labels" -}}
helm.sh/chart: {{ include "netbox.chart" . }}
{{ include "netbox.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "netbox.selectorLabels" -}}
app.kubernetes.io/name: {{ include "netbox.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "netbox.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "netbox.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Name of the Secret that contains the PostgreSQL password
*/}}
{{- define "netbox.postgresql.secret" -}}
{{- if .Values.postgresql.enabled -}}
{{ include "netbox.postgresql.fullname" . }}
{{- else if .Values.externalDatabase.existingSecretName -}}
{{ .Values.externalDatabase.existingSecretName }}
{{- else -}}
{{ .Values.existingSecret | default (include "netbox.fullname" .) }}
{{- end -}}
{{- end }}

{{/*
Name of the key in Secret that contains the PostgreSQL password
*/}}
{{- define "netbox.postgresql.secretKey" -}}
{{- if .Values.postgresql.enabled -}}
postgresql-password
{{- else if .Values.externalDatabase.existingSecretName -}}
{{ .Values.externalDatabase.existingSecretKey }}
{{- else -}}
db_password
{{- end -}}
{{- end }}

{{/*
Name of the Secret that contains the Redis tasks password
*/}}
{{- define "netbox.tasksRedis.secret" -}}
{{- if .Values.redis.enabled -}}
{{ include "netbox.redis.fullname" . }}
{{- else if .Values.tasksRedis.existingSecretName -}}
{{ .Values.tasksRedis.existingSecretName }}
{{- else -}}
{{ .Values.existingSecret | default (include "netbox.fullname" .) }}
{{- end -}}
{{- end }}

{{/*
Name of the key in Secret that contains the Redis tasks password
*/}}
{{- define "netbox.tasksRedis.secretKey" -}}
{{- if .Values.redis.enabled -}}
redis-password
{{- else if .Values.tasksRedis.existingSecretName -}}
{{ .Values.tasksRedis.existingSecretKey }}
{{- else -}}
redis_tasks_password
{{- end -}}
{{- end }}

{{/*
Name of the Secret that contains the Redis cache password
*/}}
{{- define "netbox.cacheRedis.secret" -}}
{{- if .Values.redis.enabled -}}
{{ include "netbox.redis.fullname" . }}
{{- else if .Values.cacheRedis.existingSecretName -}}
{{ .Values.cacheRedis.existingSecretName }}
{{- else -}}
{{ .Values.existingSecret | default (include "netbox.fullname" .) }}
{{- end -}}
{{- end }}

{{/*
Name of the key in Secret that contains the Redis cache password
*/}}
{{- define "netbox.cacheRedis.secretKey" -}}
{{- if .Values.redis.enabled -}}
redis-password
{{- else if .Values.cacheRedis.existingSecretName -}}
{{ .Values.cacheRedis.existingSecretKey }}
{{- else -}}
redis_cache_password
{{- end -}}
{{- end }}
