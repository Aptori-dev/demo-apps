#!/usr/bin/env pwsh

param(
[Parameter(Mandatory = $true, Position = 0)]
[string]$Email,

[Parameter(Mandatory = $true, Position = 1)]
[string]$Password,

[Parameter(Mandatory = $false, Position = 2)]
[string]$Target = $env:SIFT_TARGET_URL
)

if (-not $Target) {
Write-Error "SIFT_TARGET_URL is not set and -Target was not provided."
exit 1
}

$body = @{
email    = $Email
password = $Password
} | ConvertTo-Json

$uri = "$Target/identity/api/auth/login"

try {
$resp = Invoke-RestMethod -Uri $uri -Method Post -ContentType 'application/json' -Body $body -ErrorAction Stop
} catch {
Write-Error "HTTP request failed: $_"
exit 1
}

if (-not $resp.token) {
Write-Error "Response did not contain a token."
exit 1
}

Write-Output ("Bearer " + $resp.token)
