$ACCOUNT_ID = "6045b0c922c5f02ca8efe49010a2e687"
$EMAIL = "majakojh@gmail.com"
$API_KEY = "62160ad0e9c5ad0e3ebdf7c73e183c08bb43f"

Write-Host "[INFO] Creating D1 database..." -ForegroundColor Cyan

$d1Response = Invoke-WebRequest -Uri "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/d1/database" `
  -Method POST `
  -Headers @{
    "X-Auth-Email" = $EMAIL
    "X-Auth-Key" = $API_KEY
    "Content-Type" = "application/json"
  } `
  -Body (@{
    "name" = "frontend-test-db"
  } | ConvertTo-Json) `
  -UseBasicParsing | Select-Object -ExpandProperty Content | ConvertFrom-Json

if ($d1Response.success) {
  $DB_ID = $d1Response.result.uuid
  Write-Host "[OK] D1 Database created: $DB_ID" -ForegroundColor Green
  $DB_ID | Out-File -FilePath "db-id.txt" -Encoding UTF8
} else {
  Write-Host "[ERROR] Failed to create D1 database" -ForegroundColor Red
  $d1Response | ConvertTo-Json | Out-Host
  exit 1
}

Write-Host "[INFO] Creating R2 bucket..." -ForegroundColor Cyan

$r2Response = Invoke-WebRequest -Uri "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/r2/buckets" `
  -Method POST `
  -Headers @{
    "X-Auth-Email" = $EMAIL
    "X-Auth-Key" = $API_KEY
    "Content-Type" = "application/json"
  } `
  -Body (@{
    "name" = "frontend-test-bucket"
  } | ConvertTo-Json) `
  -UseBasicParsing | Select-Object -ExpandProperty Content | ConvertFrom-Json

if ($r2Response.success) {
  $BUCKET_NAME = $r2Response.result.name
  Write-Host "[OK] R2 Bucket created: $BUCKET_NAME" -ForegroundColor Green
  $BUCKET_NAME | Out-File -FilePath "bucket-name.txt" -Encoding UTF8
} else {
  Write-Host "[ERROR] Failed to create R2 bucket" -ForegroundColor Red
  $r2Response | ConvertTo-Json | Out-Host
  exit 1
}

Write-Host "`n[INFO] Resources created successfully!" -ForegroundColor Green
Write-Host "D1 Database ID: $DB_ID" -ForegroundColor Cyan
Write-Host "R2 Bucket Name: $BUCKET_NAME" -ForegroundColor Cyan
