<#
    @Author: Chuck McCoy
	@Version: 12/20/2017
	Reads csv file with license expiration information.  Checks which licenses
	Will expire within 90, 60, and 30 days of the current date.  Outputs those
	licenses so that user knows which ones will expire in the time frames.  Also,
	writes that information to a file.
	Usage:
	    C:\Users\$env:username\scripts\powershell\checkExpirations.ps1 <PATH\TO\FILE | Help>
#>


param(
    [Parameter(Mandatory=$true,Position=1)]
        $file,
	[Parameter(Position=2)]
	    $log
)

IF ($log -Like ""){
    $log = "C:\Users\$env:username\Desktop\license_expirations.log"
}

IF ($file -Like "[Hh]elp"){
    Write-Host "Usage:"
	Write-Host "    C:\Users\$env:username\scripts\powershell\checkExpirations.ps1 <PATH\TO\FILE | Help>"
	Write-Host
	Write-Host "i.e. C:\Users\$env:username\scripts\powershell\checkExpirations.ps1 C:\Users\$env:username\Desktop\license_expirations.csv"
}ELSE{
    IF (-NOT(Test-Path $file -ErrorAction SilentlyContinue)){
	    Write-Host "File Not Found: Check your spelling, and be sure to enter a full path including extension."
	    EXIT
	}
    <#
        Set necessary variables
        $currentDate - Stores the current date
        $i - Counter variable for loop
        $days - Variable for number of days out
        $information - Stores information from file (so it only needs to be read once).
    #>
    $currentDate=Get-Date
    $days=90
    $information=Import-Csv -Path $file

    <#
        Loop runs through $information and compares expiration dates to the current date
        plus $days.  In this fashion we can check which licenses expire 90, 60, and 30
        days from the current date.
    #>
	$currentDate | Out-File -FilePath $log -Append
    while ($days -gt 0){
        Write-Host
		
        Write-Host "The Following will expire in less than $days days..."
		"The Following will expire in less than $days days..." | Out-File -FilePath $log -Append
		
		$information | Where-Object {[DateTime]$_.Expiration -le ($currentDate.AddDays($days))}
        $information | Where-Object {[DateTime]$_.Expiration -le ($currentDate.AddDays($days))}	| Out-File -FilePath $log -Append		
		
        $days -= 30
    }
	
	"-------------------------------------------------------------" | Out-File -FilePath $log -Append
}

