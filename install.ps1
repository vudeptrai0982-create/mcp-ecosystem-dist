$ErrorActionPreference = "SilentlyContinue"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Clear-Host
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   ĐANG CÀI ĐẶT MCP HUB PRO 2026 - KỸ SƯ AI TỰ TRỊ         " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

$InstallTarget = "$env:LOCALAPPDATA\MCP_Hub_Pro"
$BinTarget     = "$InstallTarget\bin"
$RuntimeTarget = "$InstallTarget\runtime\python"
$DocsTarget    = "$InstallTarget\Exchange_Data\Standards_Docs"

New-Item -ItemType Directory -Force -Path $BinTarget | Out-Null
New-Item -ItemType Directory -Force -Path $RuntimeTarget | Out-Null
New-Item -ItemType Directory -Force -Path $DocsTarget | Out-Null

$BaseUrl = "https://github.com/vudeptrai0982-create/mcp-ecosystem-dist/releases/download/v1.0"

# 1. Tải môi trường Python
if (-not (Test-Path "$RuntimeTarget\python.exe")) {
    Write-Host "`n[1/3] Đang tải môi trường Python Embed siêu gọn..." -ForegroundColor Green
    $PyZipPath = "$InstallTarget\py_embed.zip"
    Invoke-WebRequest -Uri "$BaseUrl/python_embed_light.zip" -OutFile $PyZipPath
    Expand-Archive -Path $PyZipPath -DestinationPath $RuntimeTarget -Force
    Remove-Item $PyZipPath -Force
} else {
    Write-Host "`n[1/3] Môi trường Python đã có sẵn, bỏ qua bước tải." -ForegroundColor Gray
}

# 2. Tải toàn bộ mã nguồn & giao diện
Write-Host "`n[2/3] Đang cài đặt giao diện điều khiển & lõi AI..." -ForegroundColor Green
$AppZipPath = "$InstallTarget\app.zip"
Invoke-WebRequest -Uri "$BaseUrl/app_package.zip" -OutFile $AppZipPath
Expand-Archive -Path $AppZipPath -DestinationPath $InstallTarget -Force
Remove-Item $AppZipPath -Force

# 3. Kích hoạt Add-in cho Revit
Write-Host "`n[3/3] Tự động đồng bộ plugin vào Revit..." -ForegroundColor Green
$RevitYears = @("2021", "2022", "2023", "2024", "2025", "2026")
foreach ($Year in $RevitYears) {
    $RevFolder = "$env:APPDATA\Autodesk\Revit\Addins\$Year"
    if (Test-Path $RevFolder) {
        Copy-Item "$InstallTarget\MCP_Hub.addin" -Destination "$RevFolder\MCP_Hub.addin" -Force
        Write-Host " -> Đã kích hoạt cho Revit $Year" -ForegroundColor Gray
    }
}

# 4. Tạo Icon ngoài Desktop
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\MCP Hub Pro 2026.lnk")
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments  = "-NoProfile -ExecutionPolicy Bypass -File `"$InstallTarget\run_dashboard.ps1`""
$Shortcut.WindowStyle = 7
$Shortcut.IconLocation = "shell32.dll,43"
$Shortcut.Save()

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "  CÀI ĐẶT THÀNH CÔNG! BIỂU TƯỢNG ĐÃ XUẤT HIỆN TRÊN DESKTOP." -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan

Start-Process "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$InstallTarget\run_dashboard.ps1`""