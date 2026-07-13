# Local test server for the Nualight Warranty Status site.
# Run:  powershell -ExecutionPolicy Bypass -File serve.ps1
# Then open http://localhost:8791/  (Ctrl+C to stop)
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:8791/")
$listener.Start()
Write-Host "Serving $root on http://localhost:8791/  (Ctrl+C to stop)"

$types = @{
  ".html" = "text/html; charset=utf-8"
  ".css"  = "text/css; charset=utf-8"
  ".js"   = "text/javascript; charset=utf-8"
  ".csv"  = "text/csv; charset=utf-8"
  ".json" = "application/json; charset=utf-8"
  ".svg"  = "image/svg+xml"
  ".png"  = "image/png"
  ".jpg"  = "image/jpeg"
  ".jpeg" = "image/jpeg"
  ".pdf"  = "application/pdf"
}

while ($listener.IsListening) {
  $context = $listener.GetContext()
  $request = $context.Request
  $response = $context.Response
  try {
    $localPath = $request.Url.LocalPath
    if ($localPath -eq "/") { $localPath = "/index.html" }
    $filePath = Join-Path $root ([System.Uri]::UnescapeDataString($localPath.TrimStart("/")))
    if (Test-Path $filePath -PathType Leaf) {
      $bytes = [System.IO.File]::ReadAllBytes($filePath)
      $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
      if ($types.ContainsKey($ext)) { $response.ContentType = $types[$ext] }
      $response.Headers.Add("Cache-Control", "no-cache")
      $response.ContentLength64 = $bytes.Length
      $response.OutputStream.Write($bytes, 0, $bytes.Length)
    } else {
      $response.StatusCode = 404
    }
  } catch {
  } finally {
    $response.OutputStream.Close()
  }
}
