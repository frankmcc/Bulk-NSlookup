#requires -version 2
<#
.SYNOPSIS
  Performs a repetative nslookup on a list of domain names against a specified name server.

.DESCRIPTION
  This is a simple method of retreiving DNS records for multiple domains.  
  We simply give the script a list of domains in a text file, then perform various NSLOOKUP commands
  on each domain.

.PARAMETER <Parameter_Name>
    None

.INPUTS
  Name Server $nameserver
  nslookup types $type

.OUTPUTS
  Results file stored in $logfile variable

.NOTES
  Version:        1.0
  Author:         <Name>
  Creation Date:  <Date>
  Purpose/Change: Initial script development
  
.EXAMPLE
  Nothing to see here

#>

# Clear the Screen 
Clear-Host

# There will be errors -  Don't bother us with silly details, just keep going
$ErrorActionPreference = 'SilentlyContinue'

# This is where we are going to put the results
$logfile = ".\nslookup.txt"

# If there is an old log, delete, we don't need it.  Create a new one.
Remove-Item $logfile >$null
New-Item $logfile >$null

# The Location of the Text file contining the Domain Names to parse.
$gcpath = ".\DNS.txt" 

<# This is a plain text file with a list of domains to parse.  On domain name per line.
Example:
domain1.com
domain2.net
something.domain.org
#>
$domains = get-content $gcpath

# Get Busy
# Give instructions:
Write-Host ""
Write-Host "This script will read a list of domains from a plain text file located in  $gcpath. Edit the script to change this."
Write-Host ""
Write-Host "This is a plain text file with a list of domains to parse.  On domain name per line."
Write-Host "Example:"
Write-Host "domain1.com"
Write-Host "domain2.net"
Write-Host "something.domain.org"
Write-Host ""
Write-Host "Please make sure the file is in the correct location and is formatted correctly"
Write-Host ""

#Pick a name server to query
$nameserver = Read-Host "Name Server to use (IP or FQDN) "
Write-Host ""

# Set the nslookup type
$types = ("A"), ("ALL"), ("CNAME"), ("MX"), ("SRV"), ("TXT") 

do {
  $type = Read-Host "NSLookup Type ($types)"
} 
until ($types.like($type))


" " | Out-File -filepath $logfile -Append -width 180
"Using $nameserver for lookups." | Out-File -filepath $logfile -Append -width 180
" " | Out-File -filepath $logfile -Append -width 180
"Looking for records of type $type" | Out-File -filepath $logfile -Append -width 180
" " | Out-File -filepath $logfile -Append -width 180

foreach ($domain in $domains) {
 
  Resolve-DnsName $domain -type $type | Out-File -filepath $logfile -Append -width 180
  
  "-----------------------------------------------------------------" | Out-File -filepath $logfile -Append -width 180
  " " | Out-File -filepath $logfile -Append -width 180
}

get-content $logfile

Write-host "Job Complete please view the log at $logfile for your results."