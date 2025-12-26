{{/*
Expand the name of the chart.
*/}}
{{- define "kstreams.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kstreams.fullname" -}}
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
Create chart name and version as used by the chart label.
*/}}
{{- define "kstreams.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "kstreams.labels" -}}
helm.sh/chart: {{ include "kstreams.chart" . }}
{{ include "kstreams.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "kstreams.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kstreams.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "kstreams.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "kstreams.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
이미지 이름
Usage:
  {{ include "kstreams.image" .Values.image }}
*/}}
{{- define "kstreams.image" -}}
  {{- if .registry }}{{ .registry }}/{{- end }}
  {{- .repository }}
  {{- if .tag -}}
    :{{ .tag }}
  {{- end }}
  {{- if .digest }}
    @{{ .digest }}
  {{- end }}
{{- end -}}

{{/*
Require string input.
Prevent scientific notation of big numbers.(1e+06)
Use this instead of "| quote".
*/}}
{{- define "kstreams.mustBeString" -}}
{{- if not (kindIs "string" .) -}}
{{- fail (printf "String Input Required. 숫자값(%v)에 따옴표 쓰세용. " . ) -}}
{{- end -}}
{{- . -}}
{{- end -}}

