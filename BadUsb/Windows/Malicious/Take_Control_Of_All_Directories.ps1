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
The Grant-FullControlAllDirectories function is designed to grant full control permissions to the Administrators group for all directories and subdirectories starting from a specified root directory. This function is useful for administrative purposes where access to all directories on the system is required.

Parameters:
RootPath: (Mandatory) The root directory path from which to start the process. This parameter is a string.

Function Steps:
Check Root Path: The function checks if the specified root path exists and is a directory using the Test-Path cmdlet.
Take Ownership of Root Directory: The function uses the takeown command to take ownership of the root directory and all its subdirectories recursively.
Grant Full Control Permissions on Root Directory: The function uses the icacls command to grant full control permissions to the Administrators group on the root directory and all its subdirectories recursively.
Get All Subdirectories: The function retrieves all subdirectories within the specified root path recursively using the Get-ChildItem cmdlet.
Take Ownership and Grant Full Control on Subdirectories: The function loops through each subdirectory, taking ownership and granting full control permissions to the Administrators group using the takeown and icacls commands.
#>
##################################################################################################################################################################
#==============================Beginning==========================================================================================================================
##################################################################################################################################################################
function Grant-FullControlAllDirectories {
    param (
        [Parameter(Mandatory=$true)]
        [string]$RootPath
    )

    # Check if the specified root path exists
    if (-Not (Test-Path -Path $RootPath -PathType Container)) {
        Write-Output "The specified root path does not exist or is not a directory."
        return
    }

    # Take ownership of the root directory
    takeown /f $RootPath /r /d y
    Write-Output "Taken ownership of root directory: $RootPath"

    # Grant full control permissions on the root directory
    icacls $RootPath /grant administrators:F /T /C
    Write-Output "Granted full control permissions on root directory: $RootPath"

    # Get all subdirectories recursively
    $subDirectories = Get-ChildItem -Path $RootPath -Recurse -Directory

    foreach ($dir in $subDirectories) {
        # Take ownership of the subdirectory
        takeown /f $dir.FullName /r /d y
        Write-Output "Taken ownership of subdirectory: $($dir.FullName)"

        # Grant full control permissions on the subdirectory
        icacls $dir.FullName /grant administrators:F /T /C
        Write-Output "Granted full control permissions on subdirectory: $($dir.FullName)"
    }

    Write-Output "Completed granting full control permissions on all directories."
}

# Example usage
$rootPath = "C:\"
Grant-FullControlAllDirectories -RootPath $rootPath
##################################################################################################################################################################
#==============================End================================================================================================================================
##################################################################################################################################################################
