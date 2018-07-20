$URL = "http://fastdownloads2.texthelp.com/readwrite12/installers/uk/setup.zip"
$InstallerPath = "C:\Temp\Installers\"
$File = "Setup.zip"
$File2 = "Read&Write.exe" 
$Path = $installerPath + "\" + $File
$Path2 = $installPath + "\" + $File2
$InstallPath = "C:\Temp\Installers\Setup"


$InstallCheck = Join-Path ([System.Environment]::GetFolderPath("ProgramFilesX86")) "TextHelp\Read and Write 12\ReadAndWrite.exe"

if (!(Test-Path -PathType Container -Path $installPath)) {
    Try {
        New-Item $installPath -ItemType Directory -ErrorAction Stop
    }
    Catch {
        Throw "Failed to create Installer Directory"
    }
}



if(!(Test-Path $installCheck)) {
     try {
        $down = New-Object System.Net.WebClient
        $down.DownloadFile($URL,$Path)
        $unzip = Unzip $Path $InstallPath
        $exec = New-Object -com shell.application
        $exec.shellexecute($Path2) 
        $regadd = reg add "HKLM\SOFTWARE\WOW6432Node\Texthelp\Read&Write" /v "ProductCode" /t REG_SZ /d "CODE GOES HERE" /f
     }
     catch {
         Throw "Failed to install Package"
     }       
}


Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}



if (! (Test-Path "$ENV:SystemDrive\Users\Default\AppData\Roaming\Texthelp\ReadAndWrite\12"))
{
 mkdir "$ENV:SystemDrive\Users\Default\AppData\Roaming\Texthelp\ReadAndWrite\12"
}
 
Copy-Item -Path "$InstallerPath\RWSettings.xml" -Destination "$ENV:SystemDrive\Users\Default\AppData\Roaming\Texthelp\ReadAndWrite\12\" -Force