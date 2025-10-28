$ACCOUNT_ID = "6045b0c922c5f02ca8efe49010a2e687"
$EMAIL = "majakojh@gmail.com"
$API_KEY = "62160ad0e9c5ad0e3ebdf7c73e183c08bb43f"
$PROJECT_NAME = "frontend-test"
$GITHUB_REPO = "iamaman11/frontend-test"

Write-Host "[INFO] Creating Cloudflare Pages project..." -ForegroundColor Cyan

$pagesResponse = Invoke-WebRequest -Uri "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/pages/projects" `
  -Method POST `
  -Headers @{
    "X-Auth-Email" = $EMAIL
    "X-Auth-Key" = $API_KEY
    "Content-Type" = "application/json"
  } `
  -Body (@{
    "name" = $PROJECT_NAME
    "production_branch" = "master"
    "source" = @{
      "type" = "github"
      "config" = @{
        "owner" = "iamaman11"
        "repo_name" = "frontend-test"
        "production_branch" = "master"
        "pr_comments_enabled" = $false
        "deployments_enabled" = $true
      }
    }
    "build_config" = @{
      "build_command" = "npm run build"
      "destination_dir" = ".next"
      "root_dir" = "/"
      "web_analytics_token" = ""
    }
    "deployment_configs" = @{
      "production" = @{
        "env_vars" = @{
          "D1_DATABASE_ID" = @{
            "type" = "plain_text"
            "value" = "df73446a-fff3-408e-b339-c84fc7ead9a0"
          }
          "R2_BUCKET_NAME" = @{
            "type" = "plain_text"
            "value" = "frontend-test-bucket"
          }
        }
      }
      "preview" = @{
        "env_vars" = @{}
      }
    }
  } | ConvertTo-Json -Depth 10) `
  -UseBasicParsing | Select-Object -ExpandProperty Content | ConvertFrom-Json

if ($pagesResponse.success) {
  $PROJECT_ID = $pagesResponse.result.id
  $PROJECT_URL = $pagesResponse.result.subdomain
  Write-Host "[OK] Pages project created successfully!" -ForegroundColor Green
  Write-Host "Project ID: $PROJECT_ID" -ForegroundColor Cyan
  Write-Host "Project URL: https://$PROJECT_URL" -ForegroundColor Cyan

  $PROJECT_ID | Out-File -FilePath "pages-project-id.txt" -Encoding UTF8
  $PROJECT_URL | Out-File -FilePath "pages-url.txt" -Encoding UTF8
} else {
  Write-Host "[ERROR] Failed to create Pages project" -ForegroundColor Red
  Write-Host "Response:" -ForegroundColor Yellow
  $pagesResponse | ConvertTo-Json | Out-Host
  exit 1
}

Write-Host "`n[INFO] Deployment will start automatically from GitHub!" -ForegroundColor Green
Write-Host "[INFO] Check deployment status at: https://dash.cloudflare.com/account/pages/view/$PROJECT_NAME" -ForegroundColor Green
