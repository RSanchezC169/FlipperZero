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
The Enable-BuiltInAdministrator function is designed to enable the built-in Administrator account on a Windows system, set a specified password for this account, and prompt the user to log in manually. This function is useful for administrative purposes where access to the built-in Administrator account is required.

Parameters:
Password: (Mandatory) The password to be set for the built-in Administrator account. This parameter is a string.

Function Steps:
Enable the Built-in Administrator Account: The function uses the Enable-LocalUser cmdlet to enable the built-in Administrator account.
Set the Password for the Built-in Administrator Account: The function uses the Set-LocalUser cmdlet to set the specified password for the built-in Administrator account. The password is converted to a secure string to ensure proper handling.
Prompt the User to Log In Manually: The function outputs a message prompting the user to log out of their current account and log in as the 'Administrator' account using the provided password. Note that programmatically logging in to the account is not feasible due to security restrictions.
#>
##################################################################################################################################################################
#==============================Beginning==========================================================================================================================
##################################################################################################################################################################
function Enable-BuiltInAdministrator {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Password
    )

    # Enable the built-in Administrator account
    Enable-LocalUser -Name "Administrator"
    Write-Output "Enabled the built-in Administrator account."

    # Set the password for the built-in Administrator account
    Set-LocalUser -Name "Administrator" -Password (ConvertTo-SecureString $Password -AsPlainText -Force)
    Write-Output "Set the password for the built-in Administrator account."

    # Prompt the user to log in manually
    Write-Output "Please log out of your current account and log in as the 'Administrator' account using the password you provided."

    # Note: Logging in programmatically is not feasible due to security restrictions.
}

# Run the function and provide the password as a parameter
Enable-BuiltInAdministrator -Password "123456789"
##################################################################################################################################################################
#==============================End================================================================================================================================
##################################################################################################################################################################
