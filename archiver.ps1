#Title:  Archiver
#Author: Aaron Clevenger
#Description: Goes through a folder and zips files on a folder by folder basis.


#Script configuration

#Set up the file path for winzip.exe
$WinZipCmdLine = 'C:\Program Files\WinZip\WZZIP.EXE'
Set-Alias wzzip $WinZipCmdLine

#Set up the password you want to use
$DataTeamPwd = 'helloworld'

#Print the current directory
Function Print-Tree
{
    Tree . > test.txt
}

#Function to get the files in a directory 
Function Get-Files()
{
    $Files = Get-ChildItem .                  |
             Where-Object {!$_.PSIsContainer} |
             Foreach-Object {$_.Name}
    return $Files
}


#Function to get the folders in a directory 
Function Get-Folders()
{
    $Folders = Get-ChildItem .               |
             Where-Object {$_.PSIsContainer} |
             Foreach-Object {$_.Name}
    return $Folders
}

#Print a report of the files by file size
Function Get-Report()
{
    Get-Childitem . -Rec |
    Where-Object {!$_.PSIsContainer} |
    Select-Object FullName, LastWriteTime, Length |
    Export-Csv -NoTypeInformation -Delimiter ',' -Path file.csv
}

#Join the string of files for the folder using part of the .NET framework
#Make sure to exclude the script from the archive
$Files = Get-Files
$FileList = [String]::Join(" .`\",$Files)

Function Zip-Files()
{
    $a = $pwd.toString().Split("\\")
    Write-Host $a[-1]
    wzzip $a[-1] "-s$DataTeamPwd .\$a"
}

$Folders = Get-Folders

Function Zip-Folders()
{
    wzzip $Folders[0] -r -p "-s$DataTeamPwd"
}

Zip-Files
Zip-Folders
Get-Report
