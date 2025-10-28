$ACCOUNT_ID = "6045b0c922c5f02ca8efe49010a2e687"
$EMAIL = "majakojh@gmail.com"
$API_KEY = "62160ad0e9c5ad0e3ebdf7c73e183c08bb43f"
$PROJECT_NAME = "frontend-test"

Write-Host "[INFO] Checking project information..." -ForegroundColor Cyan

$projectResponse = Invoke-WebRequest -Uri "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/pages/projects/$PROJECT_NAME" `
  -Method GET `
  -Headers @{
    "X-Auth-Email" = $EMAIL
    "X-Auth-Key" = $API_KEY
    "Content-Type" = "application/json"
  } `
  -UseBasicParsing | Select-Object -ExpandProperty Content | ConvertFrom-Json

if ($projectResponse.success) {
  $project = $projectResponse.result

  Write-Host "[OK] Project found!" -ForegroundColor Green
  Write-Host "  Name: $($project.name)" -ForegroundColor Cyan
  Write-Host "  ID: $($project.id)" -ForegroundColor Cyan
  Write-Host "  Subdomain: $($project.subdomain)" -ForegroundColor Cyan
  Write-Host "  Created: $($project.created_on)" -ForegroundColor Cyan
  Write-Host "  Production Branch: $($project.production_branch)" -ForegroundColor Cyan

  Write-Host "`n[INFO] Build Configuration:" -ForegroundColor Cyan
  Write-Host "  Build Command: $($project.build_config.build_command)" -ForegroundColor Yellow
  Write-Host "  Destination Dir: $($project.build_config.destination_dir)" -ForegroundColor Yellow
  Write-Host "  Root Dir: $($project.build_config.root_dir)" -ForegroundColor Yellow

  Write-Host "`n[INFO] Environment Variables:" -ForegroundColor Cyan
  if ($project.deployment_configs.production.env_vars) {
    $project.deployment_configs.production.env_vars.PSObject.Properties | ForEach-Object {
      Write-Host "  $($_.Name): $($_.Value.value)" -ForegroundColor Yellow
    }
  }

  Write-Host "`n[INFO] URL: https://$($project.subdomain)" -ForegroundColor Green
} else {
  Write-Host "[ERROR] Failed to get project information" -ForegroundColor Red
  $projectResponse | ConvertTo-Json | Out-Host
}
