<# 
.AUTHOR: Ryan Kajiura - http://ca.linkedin.com/in/ryankajiura

.SYNOPSIS 
	Script that will generate an HTML report on the Bitbucket project configurations
 
.DESCRIPTION 
	This script will access all Bitbucket GET API and proivde a report. Default output will the users download directory

 .OUTPUTS
    Default save location will be logged in users download directory

.PARAMETER -DebugMode
    List parameter and variables
	
.PARAMETER -Verbose
    See more detailed progress as the script is running.

	
.Example Providng ID/Password
	GetBitbucketAuditReport -BitbucketDomain "http://ABC123.com" -username "ryank" -password "abc123";

.Example Providng ID/Password - change output directory
	GetBitbucketAuditReport -BitbucketDomain "http://ABC123.com" -username "ryank" -password "abc123" -outputlocation "$($env:USERPROFILE)\Downloads\BitbucketAuditReport.html";

.Example Providng ID/Password - change output directory and number of records to return
	GetBitbucketAuditReport -BitbucketDomain "http://ABC123.com" -username "ryank" -password "abc123" -outputlocation "$($env:USERPROFILE)\Downloads\BitbucketAuditReport.html" -RecordLimit = 10;
		


.Reference
    Bitbucket Resources
        https://docs.atlassian.com/bitbucket-server/rest/5.16.0/bitbucket-rest.html

#>


#function GetBitbucketAuditReport {
#    param(
#        [Parameter(Mandatory=$true)] [String] ${BitbucketDomain}
#		, [Parameter(Mandatory=$true)] [String] ${username}
#		, [Parameter(Mandatory=$true)] [String] ${password}
#		, [Parameter(Mandatory=$false)] [String] ${outputlocation} = "$($env:USERPROFILE)\Downloads\BitbucketAuditReport.html"
#		, [Parameter(Mandatory=$false)] [String] ${RecordLimit} = 1000
#        , [Parameter(Mandatory=$false)] [bool] $DebugMode = $false
#        )
#
#    clear;
#    
#    write-host "function being executed '$($MyInvocation.MyCommand)' ";

${outputlocation} = "$($env:USERPROFILE)\Downloads\BitbucketAuditReport.html"

# Main Production Server
${BitbucketDomain} = "https://git.pyrsoftware.ca/stash";
${username} = "kajiurya";
${password} = "Pokerst@r00";
${limits} = 1000

	
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
	
	


    #BEGIN {
        $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes( ( "{0}:{1}" -f ${username}, ${password} ) ) );
        $header = @{ Authorization="Basic ${base64AuthInfo}" };
        $header["X-Atlassian-Token"] = "nocheck";


        #Start-Job -Name "Users" -ScriptBlock { 
            $Users = Invoke-RestMethod -Headers ${header} -Uri "${BitbucketURI}/admin/users?limit=${limits}" -Method Get;
        #};
        #Wait-Job -Name "Users";

        #Start-Job -Name "Groups" -ScriptBlock { 
            $Groups = Invoke-RestMethod -Headers ${header} -Uri "${BitbucketURI}/admin/groups?limit=${limits}" -Method Get;
        #};
        #Wait-Job -Name "Groups";

        #Start-Job -Name "Projects" -ScriptBlock { 
            $Projects = Invoke-RestMethod -Headers ${header} -Uri "${BitbucketURI}/projects?limit=${limits}" -Method Get;
        #};
        #Wait-Job -Name "Projects";

        #Start-Job -Name "RecentRepo" -ScriptBlock { 
            $RecentRepo = Invoke-RestMethod -Headers ${header} -Uri "${BitbucketURI}/profile/recent/repos?limit=${limits}" -Method Get;
        #};
        #Wait-Job -Name "RecentRepo";



    # } # BEGIN    

    #PROCESS{
        #---------------------------------------------------------------------
        # Getting Users and convert to HTML fragment
        #---------------------------------------------------------------------
        #region Users
        Write-Host "`nCollecting Users Information...";
        $subhead = "<h2>Users - Count: $($Users.size)</h2>";
        $htmlbody += ${subhead};

        if ( $Users.isLastPage -like "True" ){
            $subhead = "<h3>Need to increase fetch limits </h3>";
            $htmlbody += ${subhead};
        }


        $htmlbody += $Users.values |
                        SELECT  name,
                                emailAddress,
                                id,
                                displayname,
                                active,
                                slug,
                                type,
                                @{
                                    name = "links"
                                    Expression = {
                                        $(
                                            Foreach ($property in $_.links.PSObject.Properties) {
                                                "$($property.Name): $($property.Value) ";
                                            }
                                        )
                                    }
                                } |
                        Sort name |
                        ConvertTo-Html -Fragment;

        $htmlbody += ${SPACER};

        #endregion Users

        #---------------------------------------------------------------------
        # Getting Groups and convert to HTML fragment
        #---------------------------------------------------------------------
        #region Groups        
        Write-Host "`nCollecting Groups Information...";
        $subhead = "<h2>Groups - Count: $($Groups.size)</h2>";
        $htmlbody += ${subhead};

        if ( $Groups.isLastPage -like "True" ){
            $subhead = "<h3>Need to increase fetch limits </h3>";
            $htmlbody += ${subhead};
        }


        $htmlbody += $Groups.values |
                        SELECT  name,
                                deletable|
                        Sort name |
                        ConvertTo-Html -Fragment;

        $htmlbody += ${SPACER};

        #endregion Groups

        #---------------------------------------------------------------------
        # Getting all Projects and convert to HTML fragment
        #---------------------------------------------------------------------
        #region Project
        Write-Host "`nCollecting Project Information...";
        $subhead = "<h2>Projects - Count: $($Projects.size)</h2>";
        $htmlbody += ${subhead};

        if ( $Projects.isLastPage -like "True" ){
            $subhead = "<h3>Need to increase fetch limits </h3>";
            $htmlbody += ${subhead};
        }


        $htmlbody += $Projects.values |
                        SELECT  key,
                                id,
                                name,
                                description,
                                public,
                                type,
                                @{
                                    name = "links"
                                    Expression = {
                                        $(
                                            Foreach ($property in $_.links.PSObject.Properties) {
                                                "$($property.Name): $($property.Value) ";
                                            }
                                        )
                                    }
                                } |
                        Sort name |
                        ConvertTo-Html -Fragment;

        $htmlbody += ${SPACER};

        #endregion Project

        #---------------------------------------------------------------------
        # Getting all Projects and repos permission and convert to HTML fragment
        #---------------------------------------------------------------------
        #region ProjectRepos
        Write-Host "`nCollecting Projects repos Information...";
        $Projects.values | SELECT  key | foreach {
            $temp = $_;

            $subhead = "<h2>Project / $($temp.key) repositories </h2>";
            $htmlbody += ${subhead};
            
            
            ##Start-Job -Name "repos" -ScriptBlock { 
Write-Host "Fetching repo from project $($temp.key)...";
                $repos = Invoke-RestMethod -Headers ${header} -Uri "${BitbucketURI}/projects/$($temp.key)/repos?limit=${limits}" -Method Get;
            ##};
            ##Wait-Job -Name "repos";
                                               
            $htmlbody += $repos.values |
                            SELECT  slug,
                                    id,
                                    name,
                                    statusMessage,
                                    forkable |
                            Sort name |
                            ConvertTo-Html -Fragment;

            $htmlbody += ${SPACER};

        }

        #endregion ProjectRepos

        #---------------------------------------------------------------------
        # Getting all Recent Repo and convert to HTML fragment
        #---------------------------------------------------------------------
        #region ProjectRepoDetail
        Write-Host "`nCollecting Recent Repos Information...";
        $subhead = "<h2>Recent Repos - Count: $($RecentRepo.size)</h2>";
        $htmlbody += ${subhead};

        if ( $RecentRepo.isLastPage -like "True" ){
            $subhead = "<h3>Need to increase fetch limits </h3>";
            $htmlbody += ${subhead};
        }

        $htmlbody += $RecentRepo.values |
                        SELECT  slug,
                                id,
                                name,
                                scmId,
                                state,
                                statusMessage,
                                forkable,
                                @{
                                    name = "project"
                                    Expression = {
                                        $(
                                            Foreach ($property in $_.project.PSObject.Properties) {
                                                "$($property.Name): $($property.Value) ";
                                            }
                                        )
                                    }
                                },
                                @{
                                    name = "project.links"
                                    Expression = {
                                        $(
                                            Foreach ($property in $_.project.links.PSObject.Properties) {
                                                "$($property.Name): $($property.Value) ";
                                            }
                                        )
                                    }
                                } |#
                        Sort name |
                        ConvertTo-Html -Fragment;

        $htmlbody += ${SPACER};


        #endregion ProjectRepoDetail

<#
######  Unauthorized ###

        #---------------------------------------------------------------------
        # Getting all Projects - repos and convert to HTML fragment
        #---------------------------------------------------------------------
        #Write-Host "`nCollecting Projects repos Information...";
        #
        #$Projects.values | SELECT  key | foreach {
        #    $temp = $_;
        #
        #    $subhead = "<h2>Project / $($temp.key) repositories </h2>";
        #    $htmlbody += ${subhead};
        #    
        #    
        #    #Start-Job -Name "repos" -ScriptBlock { 
        #       $ProjPermissionGroups = Invoke-RestMethod -Headers ${header}  -Uri "${BitbucketURI}/projects/$($temp.key)/permissions/groups?limit=${limits}" -Method Get;
        #    #};
        #    #Wait-Job -Name "repos";
        #    #Start-Job -Name "repos" -ScriptBlock { 
        #       $ProjPermissionUsers = Invoke-RestMethod -Headers ${header}  -Uri "${BitbucketURI}/projects/$($temp.key)/permissions/users?limit=${limits}" -Method Get;               
        #    #};                                                                        
        #    #Wait-Job -Name "repos";
        #                                       
        #    $htmlbody += $repos.values |
        #                    SELECT  slug,
        #                            id,
        #                            name,
        #                            statusMessage,
        #                            forkable |
        #                    Sort name |
        #                    ConvertTo-Html -Fragment;
        #
        #    $htmlbody += ${SPACER};
        #
        #}
        
                
            #---------------------------------------------------------------------
            # Getting Cluster and convert to HTML fragment
            #---------------------------------------------------------------------
            Write-Host "`nCollecting Cluster Information...";
            #Start-Job -Name "Cluster" -ScriptBlock { 
                $Cluster = Invoke-RestMethod -Headers ${header} -Uri "${BitbucketURI}/admin/cluster?limit=${limits}" -Method Get;
            #};
            #Wait-Job -Name "Cluster";

            $subhead = "<h2>Users - Count: $($Cluster.size)</h2>";
            $htmlbody += ${subhead};

            $subhead = "<h3>is it last page - Count: $($Users.isLastPage)</h3>";
            $htmlbody += ${subhead};


            $htmlbody += $Groups.values |
                            SELECT  name,
                                    deletable|
                            Sort name |
                            ConvertTo-Html -Fragment;

            #---------------------------------------------------------------------
            # Getting License and convert to HTML fragment
            #---------------------------------------------------------------------
            Write-Host "`nLicense Users Information...";
            #Start-Job -Name "License" -ScriptBlock { 
                $License = Invoke-RestMethod -Headers ${header} -Uri "${BitbucketURI}/admin/license?limit=${limits}" -Method Get;
            #};
            #Wait-Job -Name "License";

            $subhead = "<h2>Users - Count: $($Cluster.size)</h2>";
            $htmlbody += ${subhead};

            $subhead = "<h3>is it last page - Count: $($Users.isLastPage)</h3>";
            $htmlbody += ${subhead};


            $htmlbody += $Groups.values |
                            SELECT  name,
                                    deletable|
                            Sort name |
                            ConvertTo-Html -Fragment;

#>
        #---------------------------------------------------------------------
        # Generate the HTML report and output to file
        #---------------------------------------------------------------------
        #region ReportDetail
        Write-Host "`nProducing HTML report...";
    
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
				        <h3 align=""center"">Generated: {1}</h3>
                        <h3 align=""center"">Elapsed Time to Generate Report: {2:HH:mm:ss}</h3>" -f ( 
                                                                                                        $($env:COMPUTERNAME),
                                                                                                        ${reportime}, 
                                                                                                        ${elapsedTime}
                                                                                                    );
        
        
        $htmltail = "</body>
			    </html>"

        $htmlreport = ${htmlhead} + ${htmlbody} + ${htmltail};
        
        #endregion ReportDetail

    # } # PROCESS    


    #End {   
		write-host "Generated File ${outputlocation}";
		$htmlreport | Out-File ${outputlocation} -Encoding Utf8 -force;

    #} #End
	
#}  #Function