# Double-click connect-control-hub.bat. This script never changes Wi-Fi or installs code.
[CmdletBinding()]
param(
    [string]$HubAddress = '192.168.43.1:5555',
    [switch]$LibraryOnly
)

function Find-TeamAdb {
    param([string]$ProjectRoot)
    $candidates = @()
    $properties = Join-Path $ProjectRoot 'local.properties'
    if (Test-Path -LiteralPath $properties) {
        $line = Get-Content -LiteralPath $properties | Where-Object { $_ -match '^\s*sdk\.dir\s*=' } | Select-Object -Last 1
        if ($line) {
            $sdk = ($line -replace '^\s*sdk\.dir\s*=\s*', '').Trim()
            $sdk = $sdk.Replace('\:', ':').Replace('\\', '\').Replace('\ ', ' ')
            $candidates += Join-Path $sdk 'platform-tools\adb.exe'
        }
    }
    foreach ($sdk in @($env:ANDROID_HOME, $env:ANDROID_SDK_ROOT, 'C:\Android\Sdk', "$env:LOCALAPPDATA\Android\Sdk", "$env:USERPROFILE\Android\Sdk")) {
        if ($sdk) { $candidates += Join-Path $sdk 'platform-tools\adb.exe' }
    }
    $onPath = Get-Command adb.exe -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($onPath) { $candidates += $onPath.Source }
    foreach ($candidate in $candidates) {
        if (Test-Path -LiteralPath $candidate -PathType Leaf) { return $candidate }
    }
    return $null
}

function Invoke-TeamAdb {
    param([string]$Adb, [string[]]$AdbArguments)
    $info = New-Object System.Diagnostics.ProcessStartInfo
    $info.FileName = $Adb
    $info.Arguments = ($AdbArguments | ForEach-Object { '"' + $_.Replace('"', '\"') + '"' }) -join ' '
    $info.UseShellExecute = $false
    $info.CreateNoWindow = $true
    $info.RedirectStandardOutput = $true
    $info.RedirectStandardError = $true
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $info
    try {
        [void]$process.Start()
        $stdout = $process.StandardOutput.ReadToEndAsync()
        $stderr = $process.StandardError.ReadToEndAsync()
        if (-not $process.WaitForExit(15000)) {
            $process.Kill() # Only this client process, never the shared ADB server.
            return @{ ExitCode = 1; Text = 'ADB command timed out after 15 seconds.' }
        }
        return @{ ExitCode = $process.ExitCode; Text = ($stdout.Result + "`n" + $stderr.Result).Trim() }
    } catch {
        return @{ ExitCode = 1; Text = $_.Exception.Message }
    } finally { $process.Dispose() }
}

function Get-TeamDevices {
    param([string]$Text)
    foreach ($line in ($Text -split '\r?\n')) {
        if ($line -match '^([^\s"]+)\s+(device|offline|unauthorized)\b') {
            [pscustomobject]@{ Serial = $Matches[1]; State = $Matches[2] }
        }
    }
}

function Show-TeamConnectionHelp {
    Write-Host 'Join the Control Hub Wi-Fi in Windows, wait for it to connect, then run this helper again.'
    Write-Host 'No internet on the robot Wi-Fi is normal. This helper does not switch Wi-Fi for you.'
    Write-Host 'If the device is offline or unauthorized, ask a coach to check the Hub and debugging access.'
    Write-Host 'Default Hub address: 192.168.43.1:5555. A custom robot network may use a different address.'
    Write-Host 'See WINDOWS_FTC_SETUP_GUIDE.md for help. No pairing mode is needed.'
}

function Test-TeamHub {
    param([string]$Adb, [string]$Serial, [scriptblock]$Runner)
    $model = & $Runner $Adb @('-s', $Serial, 'shell', 'getprop', 'ro.product.model')
    if ($model.ExitCode -ne 0 -or $model.Text -notmatch '(?i)(control[ _-]?hub|rev robotics)') { return $false }
    $sdk = & $Runner $Adb @('-s', $Serial, 'shell', 'getprop', 'ro.build.version.sdk')
    $api = 0
    return ($sdk.ExitCode -eq 0 -and [int]::TryParse($sdk.Text.Trim(), [ref]$api) -and $api -ge 24)
}

function Invoke-TeamConnection {
    param([string]$Adb, [string]$Address, [scriptblock]$Runner = ${function:Invoke-TeamAdb})
    if ($Address -notmatch '^[a-zA-Z0-9][a-zA-Z0-9.-]*:[0-9]{1,5}$') {
        Write-Host 'Invalid Hub address. Use an address such as 192.168.43.1:5555.'
        return 1
    }
    if (-not $Adb) {
        Write-Host 'ADB was not found. Complete the Android SDK setup in WINDOWS_FTC_SETUP_GUIDE.md.'
        return 1
    }
    Write-Host "Using ADB: $Adb"
    Write-Host "Checking connected devices. Default target: $Address"
    $listed = & $Runner $Adb @('devices', '-l')
    if ($listed.ExitCode -ne 0) {
        Write-Host "ADB could not list devices: $($listed.Text)"
        Show-TeamConnectionHelp
        return 1
    }
    $devices = @(Get-TeamDevices $listed.Text)
    foreach ($device in $devices) {
        Write-Host "Device: $($device.Serial) - $($device.State)"
        if ($device.State -eq 'device' -and (Test-TeamHub $Adb $device.Serial $Runner)) {
            Write-Host "SUCCESS: Control Hub ready: $($device.Serial)"
            Write-Host 'Select this device and TeamCode in IntelliJ, then click the green Run triangle.'
            return 0
        }
    }
    $target = $devices | Where-Object Serial -eq $Address | Select-Object -First 1
    if ($target) {
        Write-Host "The target is $($target.State), or could not be verified as a compatible Control Hub."
        Show-TeamConnectionHelp
        return 1
    }
    Write-Host "Connecting to $Address (other device connections will be left alone)..."
    $connected = & $Runner $Adb @('connect', $Address)
    Write-Host $connected.Text
    $listed = & $Runner $Adb @('devices', '-l')
    $target = @(Get-TeamDevices $listed.Text) | Where-Object Serial -eq $Address | Select-Object -First 1
    if ($connected.ExitCode -eq 0 -and $listed.ExitCode -eq 0 -and $target -and $target.State -eq 'device' -and (Test-TeamHub $Adb $Address $Runner)) {
        Write-Host "SUCCESS: Control Hub ready: $Address"
        Write-Host 'Select this device and TeamCode in IntelliJ, then click the green Run triangle.'
        return 0
    }
    Write-Host 'Connection was not verified. Nothing has been uploaded.'
    Show-TeamConnectionHelp
    return 1
}

if (-not $LibraryOnly) {
    Write-Host 'Stripes & Circuits - FTC Team 36701'
    Write-Host 'Connect Control Hub (does not upload code or change Wi-Fi)'
    try {
        $adb = Find-TeamAdb (Split-Path -Parent $PSScriptRoot)
        exit (Invoke-TeamConnection -Adb $adb -Address $HubAddress)
    } catch {
        Write-Host "Connection helper could not finish: $($_.Exception.Message)"
        Show-TeamConnectionHelp
        exit 1
    }
}
