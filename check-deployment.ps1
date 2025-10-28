$ACCOUNT_ID = "6045b0c922c5f02ca8efe49010a2e687"
$EMAIL = "majakojh@gmail.com"
$API_KEY = "62160ad0e9c5ad0e3ebdf7c73e183c08bb43f"
$PROJECT_NAME = "frontend-test"

Write-Host "[INFO] Checking deployment status..." -ForegroundColor Cyan

$deploymentsResponse = Invoke-WebRequest -Uri "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/pages/projects/$PROJECT_NAME/deployments" `
  -Method GET `
  -Headers @{
    "X-Auth-Email" = $EMAIL
    "X-Auth-Key" = $API_KEY
    "Content-Type" = "application/json"
  } `
  -UseBasicParsing | Select-Object -ExpandProperty Content | ConvertFrom-Json

if ($deploymentsResponse.success) {
  $deployment = $deploymentsResponse.result[0]

  Write-Host "[INFO] Latest deployment:" -ForegroundColor Cyan
  Write-Host "  Status: $($deployment.deployment_trigger.metadata.commit_message)" -ForegroundColor Yellow
  Write-Host "  ID: $($deployment.id)" -ForegroundColor Yellow
  Write-Host "  Created: $($deployment.created_on)" -ForegroundColor Yellow
  Write-Host "  Status: $($deployment.latest_stage.status)" -ForegroundColor Yellow

  if ($deployment.latest_stage.status -eq "success") {
    Write-Host "[OK] Deployment successful!" -ForegroundColor Green
    Write-Host "  URL: https://frontend-test-9zc.pages.dev" -ForegroundColor Green
  } elseif ($deployment.latest_stage.status -eq "progress") {
    Write-Host "[INFO] Deployment in progress..." -ForegroundColor Yellow
  } else {
    Write-Host "[WARNING] Deployment status: $($deployment.latest_stage.status)" -ForegroundColor Yellow
  }
} else {
  Write-Host "[ERROR] Failed to get deployment status" -ForegroundColor Red
  $deploymentsResponse | ConvertTo-Json | Out-Host
}
