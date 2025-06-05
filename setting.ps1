# Windows Privacy & Performance Optimization Script
# Some operations require Administrator privileges

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "WARNING: Not running as Administrator!" -ForegroundColor Red
    Write-Host "Some registry modifications (HKLM) will be skipped." -ForegroundColor Yellow
    Write-Host "To apply all changes, run PowerShell as Administrator." -ForegroundColor Yellow
    Write-Host ""
}

Write-Host "Applying Windows Privacy & Performance Optimizations..." -ForegroundColor Cyan

# ===== MOUSE SETTINGS =====
Write-Host "Configuring mouse settings..." -ForegroundColor Yellow
$MousePath = "HKCU:\Control Panel\Mouse"
Set-ItemProperty -Path $MousePath -Name "MouseSpeed" -Value "0" -Type String
Set-ItemProperty -Path $MousePath -Name "MouseThreshold1" -Value "0" -Type String  
Set-ItemProperty -Path $MousePath -Name "MouseThreshold2" -Value "0" -Type String

# ===== DISABLE FAST BOOT/HIBERNATION =====
Write-Host "Disabling fast boot..." -ForegroundColor Yellow
if ($isAdmin) {
    try {
        $PowerPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
        if (-not (Test-Path $PowerPath)) {
            New-Item -Path $PowerPath -Force | Out-Null
        }
        Set-ItemProperty -Path $PowerPath -Name "HiberbootEnabled" -Value 0 -Type DWord
        Write-Host "Fast boot disabled successfully" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to disable fast boot: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "Skipping fast boot disable (requires Administrator)" -ForegroundColor Yellow
}

# ===== REMOVE SHARING CONTEXT MENU HANDLERS =====
Write-Host "Removing sharing context menu handlers..." -ForegroundColor Yellow
$SharingPaths = @(
    "HKCR:\*\shellex\ContextMenuHandlers\Sharing",
    "HKCR:\Directory\Background\shellex\ContextMenuHandlers\Sharing",
    "HKCR:\Directory\shellex\ContextMenuHandlers\Sharing",
    "HKCR:\Directory\shellex\CopyHookHandlers\Sharing",
    "HKCR:\Directory\shellex\PropertySheetHandlers\Sharing",
    "HKCR:\Drive\shellex\ContextMenuHandlers\Sharing",
    "HKCR:\Drive\shellex\PropertySheetHandlers\Sharing",
    "HKCR:\LibraryFolder\background\shellex\ContextMenuHandlers\Sharing",
    "HKCR:\UserLibraryFolder\shellex\ContextMenuHandlers\Sharing"
)

foreach ($path in $SharingPaths) {
    if (Test-Path $path) {
        Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Removed: $path" -ForegroundColor Green
    }
}

# ===== DISABLE FILE SHARING (via CLSID) =====
Write-Host "Disabling file sharing via CLSID..." -ForegroundColor Yellow
$CLSIDPath = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"
if (-not (Test-Path $CLSIDPath)) {
    New-Item -Path $CLSIDPath -Force | Out-Null
}
Set-ItemProperty -Path $CLSIDPath -Name "(Default)" -Value "" -Type String

# ===== PRIVACY SETTINGS =====
Write-Host "Configuring privacy settings..." -ForegroundColor Yellow

# Disable Advertising ID
$AdvertisingPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
if (-not (Test-Path $AdvertisingPath)) {
    New-Item -Path $AdvertisingPath -Force | Out-Null
}
Set-ItemProperty -Path $AdvertisingPath -Name "Enabled" -Value 0 -Type DWord

# Disable Tailored Experiences
$PrivacyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy"
if (-not (Test-Path $PrivacyPath)) {
    New-Item -Path $PrivacyPath -Force | Out-Null
}
Set-ItemProperty -Path $PrivacyPath -Name "TailoredExperiencesWithDiagnosticDataEnabled" -Value 0 -Type DWord

# Disable Online Speech Recognition
$SpeechPath = "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy"
if (-not (Test-Path $SpeechPath)) {
    New-Item -Path $SpeechPath -Force | Out-Null
}
Set-ItemProperty -Path $SpeechPath -Name "HasAccepted" -Value 0 -Type DWord

# Disable Inking & Typing Recognition Improvement
$TIPCPath = "HKCU:\Software\Microsoft\Input\TIPC"
if (-not (Test-Path $TIPCPath)) {
    New-Item -Path $TIPCPath -Force | Out-Null
}
Set-ItemProperty -Path $TIPCPath -Name "Enabled" -Value 0 -Type DWord

# Inking & Typing Personalization
$InputPersonalizationPath = "HKCU:\Software\Microsoft\InputPersonalization"
if (-not (Test-Path $InputPersonalizationPath)) {
    New-Item -Path $InputPersonalizationPath -Force | Out-Null
}
Set-ItemProperty -Path $InputPersonalizationPath -Name "RestrictImplicitInkCollection" -Value 1 -Type DWord
Set-ItemProperty -Path $InputPersonalizationPath -Name "RestrictImplicitTextCollection" -Value 1 -Type DWord

$TrainedDataPath = "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore"
if (-not (Test-Path $TrainedDataPath)) {
    New-Item -Path $TrainedDataPath -Force | Out-Null
}
Set-ItemProperty -Path $TrainedDataPath -Name "HarvestContacts" -Value 0 -Type DWord

$PersonalizationPath = "HKCU:\Software\Microsoft\Personalization\Settings"
if (-not (Test-Path $PersonalizationPath)) {
    New-Item -Path $PersonalizationPath -Force | Out-Null
}
Set-ItemProperty -Path $PersonalizationPath -Name "AcceptedPrivacyPolicy" -Value 0 -Type DWord

# ===== TELEMETRY & TRACKING =====
Write-Host "Disabling telemetry and tracking..." -ForegroundColor Yellow

# Disable Telemetry (requires admin)
if ($isAdmin) {
    try {
        $DataCollectionPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
        if (-not (Test-Path $DataCollectionPath)) {
            New-Item -Path $DataCollectionPath -Force | Out-Null
        }
        Set-ItemProperty -Path $DataCollectionPath -Name "AllowTelemetry" -Value 0 -Type DWord
        Write-Host "Telemetry disabled successfully" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to disable telemetry: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "Skipping telemetry disable (requires Administrator)" -ForegroundColor Yellow
}

# Disable Start Menu tracking
$ExplorerAdvancedPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Set-ItemProperty -Path $ExplorerAdvancedPath -Name "Start_TrackProgs" -Value 0 -Type DWord

# Disable Activity History
if ($isAdmin) {
    try {
        $SystemPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
        if (-not (Test-Path $SystemPath)) {
            New-Item -Path $SystemPath -Force | Out-Null
        }
        Set-ItemProperty -Path $SystemPath -Name "PublishUserActivities" -Value 0 -Type DWord
        Write-Host "Activity history disabled successfully" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to disable activity history: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "Skipping activity history disable (requires Administrator)" -ForegroundColor Yellow
}

# Set Feedback Frequency to Never
$SiufPath = "HKCU:\SOFTWARE\Microsoft\Siuf\Rules"
if (-not (Test-Path $SiufPath)) {
    New-Item -Path $SiufPath -Force | Out-Null
}
Set-ItemProperty -Path $SiufPath -Name "NumberOfSIUFInPeriod" -Value 0 -Type DWord
# Note: PeriodInNanoSeconds with "-" value is handled differently in PowerShell
Remove-ItemProperty -Path $SiufPath -Name "PeriodInNanoSeconds" -ErrorAction SilentlyContinue

# ===== TASKBAR & EXPLORER SETTINGS =====
Write-Host "Configuring taskbar and explorer settings..." -ForegroundColor Yellow

# Enable End Task in Taskbar
$TaskbarDevPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings"
if (-not (Test-Path $TaskbarDevPath)) {
    New-Item -Path $TaskbarDevPath -Force | Out-Null
}
Set-ItemProperty -Path $TaskbarDevPath -Name "TaskbarEndTask" -Value 1 -Type DWord

# Show file extensions
Set-ItemProperty -Path $ExplorerAdvancedPath -Name "HideFileExt" -Value 0 -Type DWord

# Enable file checkboxes for easier selection
Set-ItemProperty -Path $ExplorerAdvancedPath -Name "AutoCheckSelect" -Value 1 -Type DWord

# Show hidden files and folders
Set-ItemProperty -Path $ExplorerAdvancedPath -Name "Hidden" -Value 1 -Type DWord

# Show protected operating system files (optional - uncomment if needed)
# Set-ItemProperty -Path $ExplorerAdvancedPath -Name "ShowSuperHidden" -Value 1 -Type DWord

# ===== DARK MODE =====
Write-Host "Enabling dark mode..." -ForegroundColor Yellow
$PersonalizePath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
if (-not (Test-Path $PersonalizePath)) {
    New-Item -Path $PersonalizePath -Force | Out-Null
}
# Enable dark mode for apps and system
Set-ItemProperty -Path $PersonalizePath -Name "AppsUseLightTheme" -Value 0 -Type DWord
Set-ItemProperty -Path $PersonalizePath -Name "SystemUsesLightTheme" -Value 0 -Type DWord

Write-Host "Optimizations completed!" -ForegroundColor Green
if ($isAdmin) {
    Write-Host "All registry modifications applied successfully." -ForegroundColor Green
} else {
    Write-Host "User-level optimizations applied. Run as Administrator for system-level changes." -ForegroundColor Yellow
}
Write-Host "Note: Some changes may require a restart to take full effect." -ForegroundColor Yellow
Write-Host "Mouse acceleration has been disabled - you may need to adjust mouse sensitivity." -ForegroundColor Cyan
Write-Host "Explorer now shows: file extensions, checkboxes, and hidden items." -ForegroundColor Cyan
Write-Host "Dark mode enabled for apps and system interface." -ForegroundColor Cyan