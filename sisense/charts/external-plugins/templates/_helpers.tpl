{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "external-plugins.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "external-plugins.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "external-plugins.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create Sisense version from chart version
*/}}
{{- define "external-plugins.sisense.version" -}}
{{- $sisenseVersion := split "." .Chart.Version -}}
{{- printf "%s.%s.%s" $sisenseVersion._0 $sisenseVersion._1 $sisenseVersion._2 | trimSuffix "." -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "external-plugins.labels" -}}
release: {{ .Release.Name }}
app: {{ template "external-plugins.name" . }}
external-plugins-service: "true"
chart: {{ template "external-plugins.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
sisense-version: {{ include "external-plugins.sisense.version" . }}
{{- if .Values.labels -}}
{{- range $key,$value := .Values.labels }}
{{ $key }}: {{ $value }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "external-plugins.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "external-plugins.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Helper function to determine CPU limit based on conditions
*/}}
{{- define "external-plugins.limits.cpu" -}}
{{- if (.Values.resources.limits).cpu -}}
{{- .Values.resources.limits.cpu -}}
{{- else if eq "small" (.Values.global.deploymentSize | lower | default "small") -}}
{{- .Values.resources_small.limits.cpu -}}
{{- else if eq "large" (.Values.global.deploymentSize | lower) -}}
{{- .Values.resources_large.limits.cpu -}}
{{- else -}}
{{- .Values.resources_small.limits.cpu -}}
{{- end -}}
{{- end -}}


{{/*
Helper function to determine Memory limit based on conditions
*/}}
{{- define "external-plugins.limits.memory" -}}
{{- if (.Values.resources.limits).memory -}}
{{- .Values.resources.limits.memory -}}
{{- else if eq "small" (.Values.global.deploymentSize | lower | default "small") -}}
{{- .Values.resources_small.limits.memory -}}
{{- else if eq "large" (.Values.global.deploymentSize | lower) -}}
{{- .Values.resources_large.limits.memory -}}
{{- else -}}
{{- .Values.resources_small.limits.memory -}}
{{- end -}}
{{- end -}}
