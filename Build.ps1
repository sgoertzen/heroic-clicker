function GetScriptDirectory {
    Split-Path -Parent $PSCommandPath
}

$currentdir = GetScriptDirectory;
$zipdir = "$currentdir/build/"
$destination = "$currentdir/Release.zip"
$exefile = "$currentdir/HeroicClicker.exe"
    
# Clean up
If(Test-path $destination) {Remove-item $destination}
If(Test-path $zipdir) {Remove-Item $zipdir -Force -Recurse}
If(Test-path $exefile) {Remove-Item $exefile -Force}
    
# Compile the script 
& "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" /in "$currentdir/HeroicClicker.ahk"
# Wait for exe to show up
while (!(Test-Path $exefile)) { Start-Sleep 1 }

# Copy files into our build directory
New-Item($zipdir) -type directory
Copy-Item "$currentdir/HeroicClicker.exe" $zipdir
Copy-Item "$currentdir/gold.png" $zipdir
Copy-Item "$currentdir/red.png" $zipdir

# Build a zip file out of the .exe and the images
Add-Type -A System.IO.Compression.FileSystem;
[IO.Compression.ZipFile]::CreateFromDirectory($zipdir, $destination)

# Remove our build files and directories
Remove-Item $zipdir -Force -Recurse
while (Test-Path $exefile) { Remove-Item $exefile -Force; Start-Sleep .25 }
