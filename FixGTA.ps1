# Suppress the output of Add-Type by redirecting it to $null
$null = Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class NativeMethods {
    [DllImport("ntdll.dll")] public static extern uint NtSuspendProcess(IntPtr processHandle);
    [DllImport("ntdll.dll")] public static extern uint NtResumeProcess(IntPtr processHandle);
}
"@

function Suspend-Process($name) {
    $process = Get-Process -Name $name -ErrorAction SilentlyContinue
    if ($process) { 
        $null = [NativeMethods]::NtSuspendProcess($process.Handle) 
    }
}

function Resume-Process($name) {
    $process = Get-Process -Name $name -ErrorAction SilentlyContinue
    if ($process) { 
        $null = [NativeMethods]::NtResumeProcess($process.Handle) 
    }
}

Suspend-Process "GTA5"
Write-Output "Suspended. Please wait 15 seconds..."

# Create the countdown progress bar
$duration = 15
for ($i = $duration; $i -ge 1; $i--) {
    $progress = (($duration - $i) / $duration) * 100
    Write-Progress -PercentComplete $progress -Status "Waiting..." -Activity "Please wait $i more seconds"
    Start-Sleep -Seconds 1
}

Resume-Process "GTA5"
Write-Output "Resumed. Player interference removed."
