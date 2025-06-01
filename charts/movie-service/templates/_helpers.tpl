{{- define "movie-service.fullname" -}}
{{ printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "movie-service.name" -}}
{{ .Chart.Name }}
{{- end }}

