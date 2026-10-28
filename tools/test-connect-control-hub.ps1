# Local simulations only: no real ADB commands, network changes, or robot connection.
$ErrorActionPreference = 'Stop'
. "$PSScriptRoot\connect-control-hub.ps1" -LibraryOnly
$script:passed = 0
$address = '192.168.43.1:5555'
$empty = "List of devices attached`r`n"
$ready = "$empty$address`tdevice product:control_hub model:REV_Robotics_Control_Hub"
$model = @{ Command = "-s $address shell getprop ro.product.model"; Text = 'REV Robotics Control Hub'; Code = 0 }
$api = @{ Command = "-s $address shell getprop ro.build.version.sdk"; Text = '25'; Code = 0 }

function Check-Scenario {
    param([string]$Name, [object[]]$Steps, [int]$Expected, [string]$Adb = 'simulated-adb.exe', [string]$Target = $address)
    $state = @{ Index = 0; Steps = $Steps }
    $runner = {
        param($Executable, $AdbArguments)
        if ($state.Index -ge $state.Steps.Count) { throw 'Unexpected extra ADB call' }
        $step = $state.Steps[$state.Index]
        $state.Index++
        if (($AdbArguments -join ' ') -ne $step.Command) { throw "Unexpected command: $($AdbArguments -join ' ')" }
        return @{ ExitCode = $step.Code; Text = $step.Text }
    }.GetNewClosure()
    $actual = Invoke-TeamConnection -Adb $Adb -Address $Target -Runner $runner
    if ($actual -ne $Expected -or $state.Index -ne $Steps.Count) { throw "$Name failed (exit $actual, calls $($state.Index))" }
    $script:passed++
    Write-Host "PASS: $Name"
}

Check-Scenario 'ADB missing' @() 1 -Adb ''
Check-Scenario 'Invalid custom address' @() 1 -Target 'bad address & command'
Check-Scenario 'Cannot list devices' @(@{Command='devices -l';Text='daemon unavailable';Code=1}) 1
Check-Scenario 'Already connected Hub - no connect needed' @(@{Command='devices -l';Text=$ready;Code=0}, $model, $api) 0
Check-Scenario 'Offline target - no disconnect or retry' @(@{Command='devices -l';Text="$empty$address`toffline";Code=0}) 1
Check-Scenario 'Unauthorized target' @(@{Command='devices -l';Text="$empty$address`tunauthorized";Code=0}) 1
Check-Scenario 'Connect and verify' @(
    @{Command='devices -l';Text=$empty;Code=0},
    @{Command="connect $address";Text="connected to $address";Code=0},
    @{Command='devices -l';Text=$ready;Code=0}, $model, $api
) 0
Check-Scenario 'Connection refused or timeout' @(
    @{Command='devices -l';Text=$empty;Code=0},
    @{Command="connect $address";Text='connection timed out';Code=1},
    @{Command='devices -l';Text=$empty;Code=0}
) 1
Check-Scenario 'Connect message alone is not success' @(
    @{Command='devices -l';Text=$empty;Code=0},
    @{Command="connect $address";Text="connected to $address";Code=0},
    @{Command='devices -l';Text="$empty$address`tunauthorized";Code=0}
) 1
Check-Scenario 'Wrong device at target address' @(
    @{Command='devices -l';Text=$ready;Code=0},
    @{Command="-s $address shell getprop ro.product.model";Text='Pixel';Code=0}
) 1
Check-Scenario 'Unsupported Android version' @(
    @{Command='devices -l';Text=$ready;Code=0}, $model,
    @{Command="-s $address shell getprop ro.build.version.sdk";Text='23';Code=0}
) 1
Check-Scenario 'Unrelated phone stays connected' @(
    @{Command='devices -l';Text="$empty PHONE123`tdevice".Replace(' PHONE','PHONE');Code=0},
    @{Command='-s PHONE123 shell getprop ro.product.model';Text='Pixel';Code=0},
    @{Command="connect $address";Text='connection refused';Code=1},
    @{Command='devices -l';Text="$empty PHONE123`tdevice".Replace(' PHONE','PHONE');Code=0}
) 1
Check-Scenario 'Existing USB Control Hub' @(
    @{Command='devices -l';Text="$empty HUBUSB`tdevice".Replace(' HUB','HUB');Code=0},
    @{Command='-s HUBUSB shell getprop ro.product.model';Text='REV Robotics Control Hub';Code=0},
    @{Command='-s HUBUSB shell getprop ro.build.version.sdk';Text='25';Code=0}
) 0
$custom = '192.168.50.1:5555'
Check-Scenario 'Custom address' @(
    @{Command='devices -l';Text=$empty;Code=0},
    @{Command="connect $custom";Text='connection refused';Code=1},
    @{Command='devices -l';Text=$empty;Code=0}
) 1 -Target $custom

# Discovery must understand the Java-properties escaping written by IntelliJ.
$testRoot = Join-Path ([IO.Path]::GetTempPath()) ('FTC helper test ' + [guid]::NewGuid())
$sdk = Join-Path $testRoot 'SDK with spaces'
$platform = Join-Path $sdk 'platform-tools'
try {
    [void](New-Item -ItemType Directory -Path $platform -Force)
    $fake = Join-Path $platform 'adb.exe'
    [IO.File]::WriteAllText($fake, '') # Discovery only. Never executed.
    $escaped = $sdk.Replace('\', '\\').Replace(':', '\:')
    [IO.File]::WriteAllText((Join-Path $testRoot 'local.properties'), "sdk.dir=$escaped")
    if ((Find-TeamAdb $testRoot) -ne $fake) { throw 'SDK discovery failed' }
    $script:passed++
    Write-Host 'PASS: local.properties discovery with escaped path and spaces'
} finally {
    if (Test-Path -LiteralPath (Join-Path $testRoot 'local.properties')) { Remove-Item -LiteralPath (Join-Path $testRoot 'local.properties') }
    if (Test-Path -LiteralPath (Join-Path $platform 'adb.exe')) { Remove-Item -LiteralPath (Join-Path $platform 'adb.exe') }
    if (Test-Path -LiteralPath $platform) { Remove-Item -LiteralPath $platform }
    if (Test-Path -LiteralPath $sdk) { Remove-Item -LiteralPath $sdk }
    if (Test-Path -LiteralPath $testRoot) { Remove-Item -LiteralPath $testRoot }
}
Write-Host "$script:passed local checks passed. No hardware deployment was tested."
