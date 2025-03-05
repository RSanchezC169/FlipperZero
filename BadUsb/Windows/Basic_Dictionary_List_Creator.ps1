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
Description of Script: This PowerShell script is designed to generate all possible combinations of passwords for a specified length given by the user. 
                        The characters used for combinations include uppercase and lowercase alphabets, special characters, and numbers.
Features:
Customizable Length: Prompts the user to input the desired length for password combinations.
Character Set: Utilizes a diverse set of characters including uppercase letters, lowercase letters, numbers, and special symbols.
Unique Combinations: Ensures each generated password combination is unique.
Efficient Storage: When the generated file reaches 1GB in size, it automatically creates a new file to store subsequent results, maintaining file management efficiency.
Directory Management: Automatically creates the required directory if it does not exist.
#>
##################################################################################################################################################################
#==============================Beginning==========================================================================================================================
##################################################################################################################################################################
#when file size gets to 1gb it creates new file to hold results
Clear-Host
$length = Read-Host "Please enter the desired length for the combinations"

# Define the characters to be used in combinations
$characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@#$%^&*()<>[]123456789'
$combinations = @()
$maxFileSize = 1GB
$fileIndex = 0
$filePathBase = "C:\Temp\Combinations"
$generatedCombinations = New-Object System.Collections.Generic.HashSet[string]

# Function to get the current file path
function Get-CurrentFilePath {
    param (
        [int]$index
    )
    return "$filePathBase`_$index.txt"
}

# Check if the directory exists, if not, create it
if (-not (Test-Path -Path "C:\Temp")) {
    New-Item -ItemType Directory -Path "C:\Temp"
}

$currentFilePath = Get-CurrentFilePath -index $fileIndex

# Loop through each possible combination given the length and characters
for ($i = 0; $i -lt [Math]::Pow($characters.Length, [int]$length); $i++) {
    $combination = ''
    $current = $i
    for ($j = 0; $j -lt [int]$length; $j++) {
        $combination = $characters[$current % $characters.Length] + $combination
        $current = [Math]::Floor($current / $characters.Length)
    }

    # Check for uniqueness and add combination if unique
    if (-not $generatedCombinations.Contains($combination)) {
        $generatedCombinations.Add($combination)
        $combinations += $combination
        Write-Output $combination

        # Check file size and create new file if necessary
        if (Test-Path $currentFilePath) {
            if ((Get-Item $currentFilePath).Length -ge $maxFileSize) {
                $fileIndex++
                $currentFilePath = Get-CurrentFilePath -index $fileIndex
            }
        }

        # Write the combination to the current file
        $combination | Out-File -FilePath $currentFilePath -Append
    }
}
##################################################################################################################################################################
#==============================End================================================================================================================================
##################################################################################################################################################################
