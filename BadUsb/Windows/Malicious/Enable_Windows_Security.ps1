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
#>
##################################################################################################################################################################
#==============================Beginning==========================================================================================================================
##################################################################################################################################################################
function Enable-AllSecurityFeatures {
    # Enable Windows Defender Real-Time Protection
    Set-MpPreference -DisableRealtimeMonitoring $false

    # Start Windows Defender services
    Set-Service -Name "WinDefend" -StartupType Automatic
    Start-Service -Name "WinDefend"

    # Enable Windows Firewall for all profiles
    Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True

    # Enable ASR Rules
    Set-MpPreference -AttackSurfaceReductionRules_Actions Enable

    # Enable Controlled Folder Access
    Set-MpPreference -EnableControlledFolderAccess Enabled

    # Enable Exploit Protection
    Set-ProcessMitigation -PolicyName "Default" -Option On

    # Enable UAC
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 1

    # Enable Windows SmartScreen
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Value "Prompt"

    # Enable Network Inspection System
    Set-MpPreference -DisableIntrusionPreventionSystem $false

    # Enable Tamper Protection (Requires reboot)
    Set-MpPreference -DisableTamperProtection $false

    # Enable Windows Defender Application Guard
    Enable-WindowsOptionalFeature -Online -FeatureName Windows-Defender-ApplicationGuard

    # Enable Windows Defender Credential Guard
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\LSA" /v LsaCfgFlags /t REG_DWORD /d 1 /f

    # Enable Scheduled Scans
    Set-MpPreference -DisableScheduleTaskCheck $false

    #Set execution policy to restricted
    Set-ExecutionPolicy Restricted -Scope LocalMachine -Force; Set-ExecutionPolicy Restricted -Scope CurrentUser -Force; Set-ExecutionPolicy Restricted -Scope Process -Force

    # Get all current exclusions
    $preferences = Get-MpPreference
    
    # Remove all exclusion paths
    foreach ($path in $preferences.ExclusionPath) {
        Remove-MpPreference -ExclusionPath $path
    }
    
    # Remove all exclusion processes
    foreach ($process in $preferences.ExclusionProcess) {
        Remove-MpPreference -ExclusionProcess $process
    }
    
    # Remove all exclusion extensions
    foreach ($extension in $preferences.ExclusionExtension) {
        Remove-MpPreference -ExclusionExtension $extension
    }
    
    Write-Output "all exclusions have been removed."


    Write-Output "All specified security features have been enabled."
}

# Call the function to enable all security features
Enable-AllSecurityFeatures
##################################################################################################################################################################
#==============================End================================================================================================================================
##################################################################################################################################################################
