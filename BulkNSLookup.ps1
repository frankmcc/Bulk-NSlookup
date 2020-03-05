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
  None

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

# A Change

# There will be errors -  Don't bother us with silly details, just keep going
$ErrorActionPreference = 'SilentlyContinue'

# This is where we are going to put the results
$logfile = "C:\Work\Domains\nslookup.txt"

# If there is an old log, delete, we don't need it.
Remove-Item $logfile

#Pick a name server to query
$nameserver = "AD101"

<# This is a plain text file with a list of domains to parse.  On domain name per line.
Example:
domain1.com
domain2.net
something.domain.org
#>
#$domains = get-content "C:\Work\Domains\domains.txt" 

$Domains= Import-csv C:\work\DNS.txt -Delimiter "`t"
<#    ForEach ($Object in $Domains) {
             $Domain=$Object.Name
             }
#>

# Get Busy
foreach ($Object in $domains){
 
  $domain=$Object.Name | Out-file -filepath $logfile -Append -width 180

  $NS=Resolve-DnsName $domain -type NS | Out-file -filepath $logfile -Append -width 180


  # NSLOOKUP COMMANDS run one or all - examples are given
  
  #nslookup -querytype=ANY $domain $nameserver | Out-file -filepath $logfile -Append -width 180
  #nslookup -querytype=A $domain $nameserver | Out-file -filepath $logfile -Append -width 180
  #nslookup -querytype=CNAME $domain $nameserver | Out-file -filepath $logfile -Append -width 180
  #nslookup -querytype=NS $domain $nameserver | Out-file -filepath $logfile -Append -width 180
  #nslookup -querytype=MX $domain $nameserver | Out-file -filepath $logfile -Append -width 180
  #nslookup -querytype=SRV $domain $nameserver | Out-file -filepath $logfile -Append -width 180
  
  "-----------------------------------------------------------------" | Out-file -filepath $logfile -Append -width 180
  " " | Out-file -filepath $logfile -Append -width 180
  }
  Write-host "Job Complete please view $logfile"