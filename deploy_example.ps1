# === CONFIGURATION ===
$RemoteUser = "ubuntu"
$RemoteHost = "your-host-here"
$RemotePath = "/tmp/flutterweb"
$SshKey = "path\to\ssh\key"

function Write-Color {
    param (
        [string]$Text,
        [ConsoleColor]$Color = "White"
    )
    $origColor = $Host.UI.RawUI.ForegroundColor
    $Host.UI.RawUI.ForegroundColor = $Color
    Write-Host $Text
    $Host.UI.RawUI.ForegroundColor = $origColor
}

# Get path to this script (assumed to be inside the Flutter project)
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $ScriptDir

Write-Color "⚙️  Cleaning Flutter project..." Cyan
flutter clean

Write-Color "🚧  Building Flutter web..." Yellow
flutter build web
if ($LASTEXITCODE -ne 0) {
    Write-Color "❌  Build failed. Aborting." Red
    exit 1
}

# Copy .htaccess file to build
Copy-Item -Path "web\.htaccess" -Destination "build\web\.htaccess"

Write-Color "📤  Uploading files to remote server..." Yellow
$scpCmd = "scp -i `"$SshKey`" -r build\web\* build\web\.htaccess $RemoteUser@${RemoteHost}:`"$RemotePath`""
Invoke-Expression $scpCmd

Write-Color "🚀  Running remote deployment script..." Yellow
$sshCmd = "ssh -i `"$SshKey`" $RemoteUser@$RemoteHost 'bash ~/deploy_web.sh'"
Invoke-Expression $sshCmd

Write-Color "✅  Deployment complete!" Green
