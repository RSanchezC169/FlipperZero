##################################################################################################################################################################
##################################################################################################################################################################
<#
                 _..--+~/@-~--.
             _-=~      (  .   "}
          _-~     _.--=.\ \""""
        _~      _-       \ \_\
       =      _=          '--'
      '      =                             .
     :      :       ____                   '=_. ___
___  |      ;                            ____ '~--.~.
     ;      ;                               _____  } |
  ___=       \ ___ __     __..-...__           ___/__/__
     :        =_     _.-~~          ~~--.__
_____ \         ~-+-~                   ___~=_______
     ~@#~~ == ...______ __ ___ _--~~--_
                                                    =
██████╗ ███████╗ █████╗ ███╗   ██╗ ██████╗██╗  ██╗███████╗███████╗ ██████╗ ██╗ ██████╗ █████╗ 
██╔══██╗██╔════╝██╔══██╗████╗  ██║██╔════╝██║  ██║██╔════╝╚══███╔╝██╔════╝███║██╔════╝██╔══██╗
██████╔╝███████╗███████║██╔██╗ ██║██║     ███████║█████╗    ███╔╝ ██║     ╚██║███████╗╚██████║
██╔══██╗╚════██║██╔══██║██║╚██╗██║██║     ██╔══██║██╔══╝   ███╔╝  ██║      ██║██╔═══██╗╚═══██║
██║  ██║███████║██║  ██║██║ ╚████║╚██████╗██║  ██║███████╗███████╗╚██████╗ ██║╚██████╔╝█████╔╝
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝ ╚═════╝ ╚═╝ ╚═════╝ ╚════╝ 
Script Version: 1
OS Version Script was written on: Microsoft Windows 11 Pro : 10.0.25100 Build 26100
PSVersion 5.1.26100.2161 : PSEdition Desktop : Build Version 10.0.26100.2161
Flipper Zero FirmWare mntm-001 https://momentum-fw.dev/update/
Description of Script: 
The Test-PowerShellDisabled function is designed to check if PowerShell is disabled on your system through various methods. It performs the following checks:
Group Policy Settings: Verifies if PowerShell is disabled via the Group Policy setting EnableLUA in the registry path HKLM:\Software\Policies\Microsoft\Windows\System.
Registry Settings: Checks if PowerShell is disabled via the Registry setting EnableLUA in the registry path HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System.
Execution Policy Settings: Checks if the Execution Policy is set to Restricted at the Local Machine scope.
PowerShell Executable Blocking: Checks if the PowerShell executable (powershell.exe) is blocked by examining the Zone.Identifier alternate data stream.
AppLocker Policies: Checks if AppLocker Policies that might restrict PowerShell execution exist at the registry path HKLM:\Software\Policies\Microsoft\Windows\SrpV2.
Software Restriction Policies (SRP): Checks if SRP settings that might restrict PowerShell execution exist at the registry path HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers.
Windows Defender Application Control (WDAC) Policies: Checks if WDAC Policies that might restrict PowerShell execution exist at the registry path HKLM:\Software\Policies\Microsoft\Windows Defender Application Control.
Antivirus or Security Software Restrictions: Checks if Antivirus or Security Software Restrictions might disable PowerShell at the registry path HKLM:\Software\Policies\Microsoft\Windows\CurrentVersion\WindowsUpdate\Automatic Updates.
The function provides detailed output on how PowerShell might be disabled if any of these checks are triggered.
#>
##################################################################################################################################################################
#==============================Beginning==========================================================================================================================
##################################################################################################################################################################
function Test-PowerShellDisabled {
    # Check Group Policy settings
    $regPathGP = "HKLM:\Software\Policies\Microsoft\Windows\System"
    $regValueGP = "EnableLUA"

    if ((Test-Path -Path "$regPathGP\$regValueGP") -and ((Get-ItemProperty -Path $regPathGP -Name $regValueGP).$regValueGP -eq 0)) {
        Write-Output "PowerShell is disabled via Group Policy setting 'EnableLUA' at path '$regPathGP'."
        return $true
    }

    # Check Registry settings
    $regPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System"
    $regValue = "EnableLUA"

    if ((Test-Path -Path "$regPath\$regValue") -and ((Get-ItemProperty -Path $regPath -Name $regValue).$regValue -eq 0)) {
        Write-Output "PowerShell is disabled via Registry setting 'EnableLUA' at path '$regPath'."
        return $true
    }

    # Check Execution Policy settings
    $executionPolicy = Get-ExecutionPolicy -Scope LocalMachine

    if ($executionPolicy -eq 'Restricted') {
        Write-Output "PowerShell is restricted by Execution Policy set to 'Restricted' at the Local Machine scope."
        return $true
    }

    # Check if PowerShell executable is blocked
    $powershellPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
    $fileBlocked = Get-Item -Path $powershellPath | Select-String -Pattern "Zone.Identifier"

    if ($fileBlocked) {
        Write-Output "PowerShell executable is blocked at path '$powershellPath'."
        return $true
    }

    # Check AppLocker Policies
    $appLockerPolicyPath = "HKLM:\Software\Policies\Microsoft\Windows\SrpV2"
    if (Test-Path -Path $appLockerPolicyPath) {
        Write-Output "PowerShell may be disabled via AppLocker Policies at path '$appLockerPolicyPath'."
        return $true
    }

    # Check Software Restriction Policies (SRP)
    $srpPath = "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers"
    if (Test-Path -Path $srpPath) {
        Write-Output "PowerShell may be disabled via Software Restriction Policies (SRP) at path '$srpPath'."
        return $true
    }

    # Check Windows Defender Application Control (WDAC) Policies
    $wdacPolicyPath = "HKLM:\Software\Policies\Microsoft\Windows Defender Application Control"
    if (Test-Path -Path $wdacPolicyPath) {
        Write-Output "PowerShell may be disabled via Windows Defender Application Control (WDAC) Policies at path '$wdacPolicyPath'."
        return $true
    }

    # Check Antivirus or Security Software Restrictions
    $securitySoftwarePath = "HKLM:\Software\Policies\Microsoft\Windows\CurrentVersion\WindowsUpdate\Automatic Updates"
    if (Test-Path -Path $securitySoftwarePath) {
        Write-Output "PowerShell may be disabled via Antivirus or Security Software Restrictions at path '$securitySoftwarePath'."
        return $true
    }

    Write-Output "PowerShell is not disabled."
    return $false
}

# Run the function
Test-PowerShellDisabled
##################################################################################################################################################################
#==============================End================================================================================================================================
##################################################################################################################################################################
