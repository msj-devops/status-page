{{/*
Nazwa chartu (etykieta app.kubernetes.io/name).
*/}}
{{- define "status-page.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Przedrostek nazw obiektów: nazwa release'u. Dwa release'y w jednej przestrzeni nazw nie kolidują.
Skracamy do 40 znaków, bo do nazw dopisujemy jeszcze przyrostki (-healthcheck-cele).
*/}}
{{- define "status-page.fullname" -}}
{{- .Release.Name | trunc 40 | trimSuffix "-" }}
{{- end }}

{{/*
Etykiety wspólne dla wszystkich obiektów.
*/}}
{{- define "status-page.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{ include "status-page.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/part-of: {{ include "status-page.name" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Etykiety do selektorów: tylko te, które się nie zmieniają. Składnik (component) dopisuje każdy szablon.
*/}}
{{- define "status-page.selectorLabels" -}}
app.kubernetes.io/name: {{ include "status-page.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Nazwa PVC z raportami: istniejący (persistence.existingClaim) albo tworzony przez chart.
*/}}
{{- define "status-page.pvc" -}}
{{- .Values.persistence.existingClaim | default (printf "%s-raporty" (include "status-page.fullname" .)) }}
{{- end }}
