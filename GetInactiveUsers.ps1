import-module activedirectory 

$DaysInactive = 30 #change the days if you want
$time = (Get-Date).Adddays(-($DaysInactive))

Get-ADUser -Filter {LastLogonTimeStamp -lt $time} -Properties LastLogonTimeStamp |
select-object Name | ConvertTo-Csv -NoTypeInformation | % { $_ -replace '"', ""} | Select-Object -Skip 1 |out-file "OLD_Users.csv" -fo -en ascii

$COMPUTERS = get-content "OLD_Users.csv"
$COMPUTERS|Foreach{
Get-ADUser $_ | Disable-ADAccount 
Get-ADUser $_ | Move-ADObject -TargetPath "ou=UsersDisabled,dc=domainname,dc=com,dc=do"}
