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
The Enable-PowerShell function is designed to enable PowerShell on your system by addressing various methods that might have disabled it. It performs the following actions:
Enable Group Policy Settings: Modifies the Group Policy setting EnableLUA to enable PowerShell at the registry path HKLM:\Software\Policies\Microsoft\Windows\System.
Enable Registry Settings: Modifies the Registry setting EnableLUA to enable PowerShell at the registry path HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System.
Set Execution Policy: Sets the Execution Policy to Unrestricted at the Local Machine scope.
Unblock PowerShell Executable: Unblocks the PowerShell executable (powershell.exe) by removing the Zone.Identifier alternate data stream if it is present.
Remove AppLocker Policies: Removes AppLocker Policies that might restrict PowerShell execution from the registry path HKLM:\Software\Policies\Microsoft\Windows\SrpV2.
Remove Software Restriction Policies (SRP): Removes SRP settings that might restrict PowerShell execution from the registry path HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers.
Remove Windows Defender Application Control (WDAC) Policies: Removes WDAC Policies that might restrict PowerShell execution from the registry path HKLM:\Software\Policies\Microsoft\Windows Defender Application Control.
Remove Antivirus or Security Software Restrictions: Removes Antivirus or Security Software Restrictions that might disable PowerShell from the registry path HKLM:\Software\Policies\Microsoft\Windows\CurrentVersion\WindowsUpdate\Automatic Updates.
The function provides detailed output for each step it takes to ensure that PowerShell is enabled on your system.
#>
##################################################################################################################################################################
#==============================Beginning==========================================================================================================================
##################################################################################################################################################################
function Enable-PowerShell {
    # Enable Group Policy settings
    $regPathGP = "HKLM:\Software\Policies\Microsoft\Windows\System"
    $regValueGP = "EnableLUA"

    if (Test-Path -Path $regPathGP) {
        Set-ItemProperty -Path $regPathGP -Name $regValueGP -Value 1
        Write-Output "Enabled PowerShell via Group Policy setting 'EnableLUA' at path '$regPathGP'."
    } else {
        Write-Output "Group Policy setting 'EnableLUA' at path '$regPathGP' does not exist."
    }

    # Enable Registry settings
    $regPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System"
    $regValue = "EnableLUA"

    if (Test-Path -Path $regPath) {
        Set-ItemProperty -Path $regPath -Name $regValue -Value 1
        Write-Output "Enabled PowerShell via Registry setting 'EnableLUA' at path '$regPath'."
    } else {
        Write-Output "Registry setting 'EnableLUA' at path '$regPath' does not exist."
    }

    # Set Execution Policy
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine -Force
    Write-Output "Set Execution Policy to 'Unrestricted' at the Local Machine scope."

    # Unblock PowerShell executable
    $powershellPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
    $powershellProperties = Get-ItemProperty -Path $powershellPath

    if ($powershellProperties -and $powershellProperties.ZoneIdentifier) {
        Remove-ItemProperty -Path $powershellPath -Name Zone.Identifier
        Write-Output "Unblocked PowerShell executable at path '$powershellPath'."
    } else {
        Write-Output "PowerShell executable at path '$powershellPath' is not blocked."
    }

    # Remove AppLocker Policies
    $appLockerPolicyPath = "HKLM:\Software\Policies\Microsoft\Windows\SrpV2"
    if (Test-Path -Path $appLockerPolicyPath) {
        Remove-Item -Path $appLockerPolicyPath -Recurse -Force
        Write-Output "Removed AppLocker Policies at path '$appLockerPolicyPath'."
    }

    # Remove Software Restriction Policies (SRP)
    $srpPath = "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers"
    if (Test-Path -Path $srpPath) {
        Remove-Item -Path $srpPath -Recurse -Force
        Write-Output "Removed Software Restriction Policies (SRP) at path '$srpPath'."
    }

    # Remove Windows Defender Application Control (WDAC) Policies
    $wdacPolicyPath = "HKLM:\Software\Policies\Microsoft\Windows Defender Application Control"
    if (Test-Path -Path $wdacPolicyPath) {
        Remove-Item -Path $wdacPolicyPath -Recurse -Force
        Write-Output "Removed Windows Defender Application Control (WDAC) Policies at path '$wdacPolicyPath'."
    }

    # Remove Antivirus or Security Software Restrictions
    $securitySoftwarePath = "HKLM:\Software\Policies\Microsoft\Windows\CurrentVersion\WindowsUpdate\Automatic Updates"
    if (Test-Path -Path $securitySoftwarePath) {
        Remove-Item -Path $securitySoftwarePath -Recurse -Force
        Write-Output "Removed Antivirus or Security Software Restrictions at path '$securitySoftwarePath'."
    }

    Write-Output "PowerShell has been enabled."
}

# Run the function
Enable-PowerShell
##################################################################################################################################################################
#==============================End================================================================================================================================
##################################################################################################################################################################
