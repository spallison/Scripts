#Author: Simon Allison 
#Author Blog: http://simonallison.blog
#Author Company:  Havant & South Downs College (www.hsdc.ac.uk) 

#Description Built for Read and Write Gold 12 for Intune Deployment 
#Version 4.0 

#Silent Intall Read & Write Gold v12 
#Make sure you assign "All Users" or some users under Assignments - Powershell scripts run only for Users 

#Check if Software is installed 
$CheckRW = Join-Path ([System.Environment]::GetFolderPath("ProgramFilesX86")) "TextHelp\Read and Write 12\ReadAndWrite.exe"

if(!(Test-Path $CheckRW)) {
     try {
        $archive = 'C:\Temp\Installers\Setup.zip'
        $Install = 'C:\Temp\Installers\Setup'
        $url = 'http://fastdownloads2.texthelp.com/readwrite12/installers/uk/setup.zip'
        Invoke-WebRequest $url -OutFile $archive -UseBasicParsing
        Expand-Archive -Path $archive -DestinationPath $Install
        $Install = 'C:\Temp\Installers\Setup'
        Start-Process "$Install\Read&Write.exe" -ArgumentList "/S /v/qn" -Wait -Passthru

Remove-Item -path $archive -Recurse

Remove-Item -path $Install -Recurse

#Replace CODE GOES HERE with your Product Code  
reg add "HKLM\SOFTWARE\WOW6432Node\Texthelp\Read&Write" /v "ProductCode" /t REG_SZ /d "CODE GOES HERE" /f
}
catch {
         Throw "Failed to install Package"
     }       

}

# Open Firewall Ports for .exe - to get rid of the prompt for users.   
New-NetFirewallRule -DisplayName "Read&Write 12" -Direction Inbound -Program "${ENV:ProgramFiles(x86)}\texthelp\read and write 12\readandwrite.exe" -Protocol tcp -Action Allow
New-NetFirewallRule -DisplayName "Read&Write 12" -Direction Inbound -Program "${ENV:ProgramFiles(x86)}\texthelp\read and write 12\readandwrite.exe" -Protocol udp -Action Allow
