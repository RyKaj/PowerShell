<# 
.AUTHOR: Ryan Kajiura - http://ca.linkedin.com/in/ryankajiura

.SYNOPSIS 
	Script that will generate an HTML report on the Bitbucket project configurations
 
.DESCRIPTION 
	This script will access all Bitbucket GET API and proivde a report. Default output will the users download directory

.OUTPUTS
    Default save location will be logged in users download directory

Z.PARAMETER -DebugMode
    List parameter and variables
	
.PARAMETER -Verbose
    See more detailed progress as the script is running.

	
.Example Providng ID/Password
	GetBitbucketCommitsReport -BitbucketDomain "http://ABC123.com" -username "ryank" -password "abc123" -UsersCommit "ryana, ryanb, ryanc, ryand";

.Example Providng ID/Password - change output directory
	GetBitbucketCommitsReport -BitbucketDomain "http://ABC123.com" -username "ryank" -password "abc123" -UsersCommit "ryana, ryanb, ryanc, ryand" -outputlocation "$($env:USERPROFILE)\Downloads\BitbucketAuditReport.html";

.Example Providng ID/Password - change output directory and number of records to return
	GetBitbucketCommitsReport -BitbucketDomain "http://ABC123.com" -username "ryank" -password "abc123" -UsersCommit "ryana, ryanb, ryanc, ryand" -outputlocation "$($env:USERPROFILE)\Downloads\BitbucketAuditReport.html" -RecordLimit = 10;
		



.Reference
    Bitbucket Resources
        https://docs.atlassian.com/bitbucket-server/rest/5.16.0/bitbucket-rest.html

#>


#function GetBitbucketCommitsReport {
#    param(
#        [Parameter(Mandatory=$true)] [String] ${BitbucketDomain}
#		, [Parameter(Mandatory=$true)] [String] ${username}
#		, [Parameter(Mandatory=$true)] [String] ${password}
#		, [Parameter(Mandatory=$true)] [String[]] ${UsersCommit}
#		, [Parameter(Mandatory=$false)] [String] ${outputlocation} = "$($env:USERPROFILE)\Downloads\BitbucketCommitReport.html"
#		, [Parameter(Mandatory=$false)] [String] ${limits} = 1000
#        , [Parameter(Mandatory=$false)] [bool] $DebugMode = $false
#        )
    clear;

#    write-host "function being executed '$($MyInvocation.MyCommand)' ";

    

${outputlocation} = "$($env:USERPROFILE)\Downloads\BitbucketCommitReport.html"

# Main Production Server
${BitbucketDomain} = "https://git.pyrsoftware.ca/stash";
${username} = "kajiurya";
${password} = "Pokerst@r00";
${limits} = 1000

$ProjectKey = "SER";
$ProjectName = "Server";
$RepoName = "coreserver";
$FindCommitId = "d43814fe59c";


#${token} = "11b9c1d4675f24417cd264662157c357f0";  # "Report" under kajiurya account
## https://git.pyrsoftware.ca/stash/rest/api/1.0/projects/

##  https://git.pyrsoftware.ca/stash/projects/SER/repos/coreserver/commits?merges=include
## t: d43814fe59c  and the next one was from c71db0bd044 we would like to know jiras that are includ




    #################################################################################################
    ## Variables - Static
    #################################################################################################
    [DateTime] $STARTTIME = Get-Date;
    [String] $SPACER = "<br />";
    [String] $BitbucketURI = "${BitbucketDomain}/rest/api/1.0";
    

    #################################################################################################
    ## Variables - Session
    #################################################################################################
    $temp = "";
    $htmlreport = @();
    $htmlbody = @();
    $ListTemp = @{};
    $counter = 0;


    #######################################################################################################
    ###   DEBUG
    #######################################################################################################
#    if ($DebugMode -eq $True) {        
#        foreach ( $key in (Get-Command -Name $MyInvocation.InvocationName).Parameters.Keys ) {
#            $value = (Get-Variable $key -ErrorAction SilentlyContinue).Value
#            if ( ${value} -or ${value} -eq 0 ) {
#                Write-Host "Function parameter...${key} -> ${value}";
#            } 
#        }        
#    }
	
	
#region BeingProcess
    #BEGIN {
        $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes( ( "{0}:{1}" -f ${username}, ${password} ) ) );
        $header = @{ Authorization="Basic ${base64AuthInfo}" };
        $header["X-Atlassian-Token"] = "nocheck";
		
        #Start-Job -Name "Projects" -ScriptBlock { 
            $Projects = Invoke-RestMethod -Headers ${header} -Uri "${BitbucketURI}/projects?limit=${limits}" -Method Get;
            # https://git.pyrsoftware.ca/stash/rest/api/1.0/projects/
        #};
        #Wait-Job -Name "Projects";


    # } # BEGIN
#endregion BeingProcess

#region Process

    #PROCESS{
        #---------------------------------------------------------------------
        # Getting all Projects - Commits and convert to HTML fragment
        #---------------------------------------------------------------------
        #region Commits

        Write-Host "Collecting Projects commits Information...";
        foreach ( $proj in $Projects.values | ? { $_.name -eq $ProjectName -or $_.key -eq $ProjectKey } | SELECT key ) {
            Write-Host "Collecting Projects '$($proj.key)' commits Information...";    
            ##Start-Job -Name "Project" -ScriptBlock { 
                $repos = Invoke-RestMethod -Headers ${header} -Uri "${BitbucketURI}/projects/$($proj.key)/repos?limit=${limits}" -Method Get;
            ##};
            ##Wait-Job -Name "Project";


            foreach ( $projRepo in $repos.values | 
# ? { $_.slug -eq "coreserver" } |
                    select slug
                    ) 
            {
                ##Start-Job -Name "ProjectCommits" -ScriptBlock { 
                    Write-Host "Fetching slug '$($projRepo.slug)' from project '$($ProjectName)' and key '$($proj.key)'...";

                    #$commits = Invoke-RestMethod -Headers ${header} -Uri "${BitbucketURI}/projects/$($proj.key)/repos/$($projRepo.slug)/commits?limit=${limits}" -Method Get;
                    $commits = Invoke-RestMethod -Headers ${header} -Uri "${BitbucketURI}/projects/$($proj.key)/repos/$($projRepo.slug)/commits?merges=include&limit=${limits}" -Method Get;
                ##};
                ##Wait-Job -Name "ProjectCommits";

                $temp = $commits.values | ? { $_.displayId -in $FindCommitId -or  $_.id -eq $FindCommitId }
                if ( ( $temp | measure ).Count -eq 0) { 
                    continue;  
                }

                foreach ( $commitid in $commits.values )  {

                        $JobListTemp = New-Object -TypeName PSObject;
                        $JobListTemp | Add-Member -MemberType NoteProperty -Name id -Value $commitid.id;
                        $JobListTemp | Add-Member -MemberType NoteProperty -Name displayId -Value $commitid.displayId;
                        $JobListTemp | Add-Member -MemberType NoteProperty -Name AuthorName -Value $commitid.author.name;
                        $JobListTemp | Add-Member -MemberType NoteProperty -Name CommitterName -Value $commitid.committer.name;
                        $JobListTemp | Add-Member -MemberType NoteProperty -Name CommitterDate -Value ( ([datetime]"1/1/1970").AddMilliseconds( $commitid.committerTimestamp).DateTime );

                        $JobListTemp | Add-Member -MemberType NoteProperty -Name message -Value $commitid.message; 
                        $JobListTemp | Add-Member -MemberType NoteProperty -Name parentsId -Value ($commitid.parents).id;
                        $JobListTemp | Add-Member -MemberType NoteProperty -Name parentsdisplayId -Value ($commitid.parents).displayId;
                           
                        $ListTemp.Add( $counter, $JobListTemp );
                        $counter++;


                        $temp = $commitid | ? { $_.displayId -eq $FindCommitId -or  $_.id -eq $FindCommitId }
                        if ( ( $temp | measure ).Count  -gt 0 ) {
                            break;
                        }
            
                } #$commitid
                
            } #$repos.values
                
            $htmlbody += $ListTemp.Values | Sort CommitterDate -Descending | ConvertTo-Html -Fragment;
            $htmlbody += ${SPACER};

        }  #$Projects.values

        #endregion Commits


    # } # PROCESS    
#endregion Process

#region EndProcess
    #End {   
        #---------------------------------------------------------------------
        # Generate the HTML report and output to file
        #---------------------------------------------------------------------
	    #region ReportDetail
        Write-Host "Producing HTML report";
    
        $reportime = Get-Date -format f;
        $elapsedTime = ([datetime]$( ( Get-Date ) - ${StartTime}).Ticks );

        #Common HTML head and styles
	    $htmlhead = "<html>
				        <style>
				            BODY {{font-family: Arial; font-size: 8pt;}}
				            H1 {{font-size: 20px;}}
				            H2 {{font-size: 18px;}}
				            H3 {{font-size: 16px;}}
				            TABLE {{ border: 1px solid black; border-collapse: collapse; font-size: 8pt; }}
				            TH {{ border: 1px solid black; background: #dddddd; padding: 5px; color: #000000; }}
				            TD {{ border: 1px solid black; padding: 5px; }}
				            td.pass {{ background: #7FFF00; }}
				            td.warn {{ background: #FFE600; }}
				            td.fail {{ background: #FF0000; color: #ffffff; }}
				            td.info {{ background: #85D4FF; }}
				        </style>
				        <body>
				        <h1 align=""center"">Server Info: {0}</h1>
				        <h3 align=""center"">Generated: {1:HH:mm:ss}</h3>
                        <h3 align=""center"">Elapsed Time to Generate Report: {2:HH:mm:ss}</h3>" -f ( 
                                                                                                        ${BitbucketDomain},
                                                                                                        ${reportime}, 
                                                                                                        ${elapsedTime}
                                                                                                    );
        
        
        $htmltail = "</body>
			    </html>"

        $htmlreport = ${htmlhead} + ${htmlbody} + ${htmltail};

        #endregion ReportDetail


        Write-Verbose -Verbose ( "Total Duration: {0:HH:mm:ss}" -f ${elapsedTime} ) ;
		write-Verbose "Generated File ${outputlocation}";
		$htmlreport | Out-File ${outputlocation} -Encoding Utf8 -force;

    #} #End
#endregion EndProcess	
	
#}  #Function	