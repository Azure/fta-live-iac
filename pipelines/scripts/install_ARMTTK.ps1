[CmdletBinding()]
param (
    $installPath = "$env:USERPROFILE"
)

# Create the install folder
$installDir = New-Item -ItemType Directory -Path $installPath -Force
# Fetch the latest ARM-TTK ZIP archive
(New-Object Net.WebClient).DownloadFile("https://aka.ms/arm-ttk-latest", "$installPath\arm-ttk-latest.zip")
# Extract the archive
Expand-Archive -Path "$installPath\arm-ttk-latest.zip" -DestinationPath "$installPath\arm-ttk-latest"
# Confirm files are present
Get-ChildItem -Path "$installPath\arm-ttk-latest" -Recurse
# Done!
