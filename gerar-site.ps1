# Gera o site do Ikai (o app Flutter compilado para a web) dentro de
# backend\public. O servidor entrega esse site no mesmo endereço da API.
#
# Rode sempre que mudar algo em lib\ e quiser atualizar o site hospedado:
#   .\gerar-site.ps1
# Depois faça o commit e o envio ao GitHub; o Render publica sozinho.

$ErrorActionPreference = 'Stop'
$raiz = $PSScriptRoot
$destino = Join-Path $raiz 'backend\public'

Set-Location $raiz
if (Test-Path $destino) { Remove-Item -Recurse -Force $destino }

# API_URL=origem: o app usa o endereço da própria página como servidor.
# --web-content-hash: nomes de arquivo mudam a cada versão (sem cache velho).
flutter build web --release `
  --dart-define=API_URL=origem `
  --web-content-hash `
  --output $destino

# O motor gráfico (canvaskit, 37 MB) é baixado do servidor do Google
# (gstatic.com) pelo próprio app; a cópia local só pesaria no GitHub.
Remove-Item -Recurse -Force (Join-Path $destino 'canvaskit')
Remove-Item -Force (Join-Path $destino 'flutter.js.map') -ErrorAction SilentlyContinue

Write-Host ''
Write-Host "Site gerado em $destino"
