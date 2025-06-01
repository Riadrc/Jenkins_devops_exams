{{- define "cast-service.fullname" -}}
{{ printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "cast-service.name" -}}
{{ .Chart.Name }}
{{- end }}

