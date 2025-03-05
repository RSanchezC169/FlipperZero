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
Description of Script: This PowerShell script generates all possible unique and non-repeating combinations of the numbers 0 through 9 for a specified length given by the user. 
                        It ensures each generated combination is unique and manages file storage efficiently by creating new files when the current file exceeds 1GB in size.
Features:
User Input for Length: Prompts the user to enter the desired length for the combinations.
Unique Combinations: Ensures that each generated combination of numbers is unique and non-repeating.
Directory Management: Checks if the specified directory exists and creates it if it does not.
Efficient File Storage: Manages file sizes by creating a new file to store combinations when the current file exceeds 1GB in size.
HashSet for Uniqueness: Utilizes a HashSet to store and verify the uniqueness of each combination.
#>
##################################################################################################################################################################
#==============================Beginning==========================================================================================================================
##################################################################################################################################################################
#Clear host
Clear-Host

# Ask the user for the desired length
$length = Read-Host "Please enter the desired length for the combinations"

# Define the characters to be used in combinations
$characters = '0123456789'

# Check if the directory exists, if not, create it
$directoryPath = "C:\Temp"
if (-not (Test-Path -Path $directoryPath)) {
    New-Item -ItemType Directory -Path $directoryPath
}

# Function to get the current file path
function Get-CurrentFilePath {
    param (
        [int]$index
    )
    return "$directoryPath\Combinations_$index.txt"
}

# Initialize variables
$combinations = @()
$maxFileSize = 1GB
$fileIndex = 0
$currentFilePath = Get-CurrentFilePath -index $fileIndex
$generatedCombinations = New-Object System.Collections.Generic.HashSet[string]

# Helper function to generate combinations
function Generate-Combinations {
    param (
        [int]$length,
        [string[]]$characters,
        [string]$prefix = ""
    )
    if ($prefix.Length -eq $length) {
        if (-not $generatedCombinations.Contains($prefix)) {
            $generatedCombinations.Add($prefix)
            $combinations += $prefix
            Write-Output $prefix

            # Check file size and create new file if necessary
            if (Test-Path $currentFilePath) {
                if ((Get-Item $currentFilePath).Length -ge $maxFileSize) {
                    $fileIndex++
                    $currentFilePath = Get-CurrentFilePath -index $fileIndex
                }
            }

            # Write the combination to the current file
            $prefix | Out-File -FilePath $currentFilePath -Append
        }
    }
    else {
        foreach ($character in $characters) {
            Generate-Combinations -length $length -characters $characters -prefix ($prefix + $character)
        }
    }
}

# Generate the combinations
Generate-Combinations -length $length -characters $characters.ToCharArray()
##################################################################################################################################################################
#==============================End================================================================================================================================
##################################################################################################################################################################
