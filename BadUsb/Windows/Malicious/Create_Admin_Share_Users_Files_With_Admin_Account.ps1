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

    # Prompt the user for the password
    $securePassword = Read-Host -Prompt "Enter the password for the new admin account" -AsSecureString

    # Create the new local user account
    New-LocalUser -Name $username -Password $securePassword -FullName $fullName -Description $description

    # Add the new user to the Administrators group
    Add-LocalGroupMember -Group "Administrators" -Member $username

    Write-Output "Admin account '$username' created and added to the Administrators group."

    # Share other users' files and folders with the new admin account
    $usersPath = "C:\Users"
    $users = Get-ChildItem -Path $usersPath | Where-Object { $_.PSIsContainer -and $_.Name -ne $username -and $_.Name -ne "Public" }

    foreach ($user in $users) {
        $userProfilePath = Join-Path -Path $usersPath -ChildPath $user.Name

        # Share the user's profile folder with the new admin account
        icacls $userProfilePath /grant $username:(OI)(CI)F
        Write-Output "Granted full control of $userProfilePath to $username."
    }

    Write-Output "Files and folders of other users have been shared with the new admin account '$username'."
}

# Example usage
New-AdminAccount -username "NewAdminUser"
##################################################################################################################################################################
#==============================End================================================================================================================================
##################################################################################################################################################################
