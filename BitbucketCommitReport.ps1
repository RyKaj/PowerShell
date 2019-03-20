<# 
.SYNOPSIS 
Script that will generate an HTML report on the Bitbucket project configurations
 
.DESCRIPTION 
This script will access all Bitbucket GET API and proivde a report. Default output will the users download directory




Author: Ryan Kajiura

 
.Required Changes
	Search and change these variable values to your organizations information
		$username - Credentials
		$password - Credentials
		$BitbucketDomain - Corporate Domain
		$limits - amount of records that are returned
		$FindSpecifcUserCommits - array of user ids that you want to investigate
		

.Reference
    Bitbucket Resources
        https://docs.atlassian.com/bitbucket-server/rest/5.16.0/bitbucket-rest.html

#>



    #################################################################################################
    ## Variables - Static
    #################################################################################################    
    [DateTime] $STARTTIME = Get-Date;
    [String] $SPACER = "<br />";
    [String] $htmlfile = "Bitbucket Commits Report.html";
    [String] $outputlocation = "$($env:USERPROFILE)\Downloads\${htmlfile}";
    [String] $BitbucketDomain = "http://ABC.com";
    [String] $BitbucketURI = "${BitbucketDomain}/rest/api/1.0";
    [String] $limits = 1000;

    #################################################################################################
    ## Variables - Session
    #################################################################################################    
    $temp = "";
    $username = "abc";
    $password = "abc123";
    $htmlreport = @();
    $htmlbody = @();


    #################################################################################################
    ## List all users
    #################################################################################################    

    $FindSpecifcUserCommits = @(
                    , "ryank"
                   )




    #BEGIN {
        $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes( ( "{0}:{1}" -f ${username}, ${password} ) ) );
        $header = @{ Authorization="Basic ${base64AuthInfo}" };
        $header["X-Atlassian-Token"] = "nocheck";

        
        #Start-Job -Name "Projects" -ScriptBlock { 
            $Projects = Invoke-RestMethod -Headers ${header} -Uri "${BitbucketURI}/projects?limit=${limits}" -Method Get;
        #};
        #Wait-Job -Name "Projects";


    # } # BEGIN    

    #PROCESS{
      
        #---------------------------------------------------------------------
        # Getting all Projects and convert to HTML fragment
        #---------------------------------------------------------------------
        #region ProjectDetail
        #Write-Host "Collecting Project Information...";



        #endregion ReportDetail

        #---------------------------------------------------------------------
        # Getting all Projects - Commits and convert to HTML fragment
        #---------------------------------------------------------------------
        #region Commits

        Write-Host "Collecting Projects commits Information...";

        foreach ($proj in $Projects.values | SELECT key ) {
            Write-Host "Collecting Projects '${proj}' commits Information...";    
            ##Start-Job -Name "Project" -ScriptBlock { 
                $repos = Invoke-RestMethod -Headers ${header} -Uri "${BitbucketURI}/projects/$($proj.key)/repos?limit=${limits}" -Method Get;
            ##};
            ##Wait-Job -Name "Project";


            foreach ($projRepo in $repos.values | select slug) {
                ##Start-Job -Name "ProjectCommits" -ScriptBlock { 
                    $commits = Invoke-RestMethod -Headers ${header} -Uri "${BitbucketURI}/projects/$($proj.key)/repos/$($projRepo.slug)/commits?limit=${limits}" -Method Get;
                ##};
                ##Wait-Job -Name "ProjectCommits";



                foreach ($user in $FindSpecifcUserCommits) {
                    $temp = $commits.values | Where-Object { $_.author.name -eq ${user} };

                    ##Start-Job -Name "ProjectCommits" -ScriptBlock { 
                        $commits = Invoke-RestMethod -Headers ${header} -Uri "${BitbucketURI}/projects/$($proj.key)/repos/$($projRepo.slug)/commits?limit=${limits}" -Method Get;
                    ##};
                    ##Wait-Job -Name "ProjectCommits";

                    $temp = $commits.values | Where-Object { $_.author.name -eq ${user} };

                    if ($temp.Length -eq 0) { continue; }


                    #Start-Job -Name "Users" -ScriptBlock { 
                        $UserProfile = Invoke-RestMethod -Headers ${header} -Uri "${BitbucketURI}/users/${user}" -Method Get;
                    #};
                    #Wait-Job -Name "Users";
					
                    $subhead = "<h2>$($UserProfile.displayName) committs</h2>";
                    $htmlbody += ${subhead};

                    $subhead = "<h3>Project: '$($proj.key)' - Repo: '$($projRepo.slug)'</h3>";       
                    $htmlbody += ${subhead};

                    $htmlbody += $temp |
                                    SELECT  id,
                                            displayId,
                                            @{
                                                name = "author"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.author.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) ";
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "authorTimestamp"
                                                Expression = {
                                                    $(
                                                        ([datetime]"1/1/1970").AddMilliseconds($_.authorTimestamp).DateTime
                                                    )
                                                }
                                            },
                                            @{
                                                name = "committer"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.committer.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) ";
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "committerTimestamp"
                                                Expression = {
                                                    $(
                                                        ([datetime]"1/1/1970").AddMilliseconds($_.committerTimestamp).DateTime
                                                    )
                                                }
                                            },
                                            message,
                                            @{
                                                name = "parents"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.parents) {
                                                            "id: $($property.id)  - DisplayID: $($property.displayId) "
                                                        }
                                                    )
                                                }
                                            } |
                                    Sort    name,
                                            committerTimestamp -Descending |
                                    ConvertTo-Html -Fragment;
                    $htmlbody += ${SPACER};                
            
                } #$Users
                
            } #$repos.values
                
        }  #$Projects.values

        #endregion Commits


        #---------------------------------------------------------------------
        # Generate the HTML report and output to file
        #---------------------------------------------------------------------
	    #region ReportDetail
        Write-Host "Producing HTML report";
    
        $reportime = Get-Date -format f;
        
        #Common HTML head and styles
	    $htmlhead="<html>
				    <style>
				        BODY {font-family: Arial; font-size: 8pt;}
				        H1 {font-size: 20px;}
				        H2 {font-size: 18px;}
				        H3 {font-size: 16px;}
				        TABLE {border: 1px solid black; border-collapse: collapse; font-size: 8pt;}
				        TH {border: 1px solid black; background: #dddddd; padding: 5px; color: #000000;}
				        TD {border: 1px solid black; padding: 5px; }
				        td.pass {background: #7FFF00;}
				        td.warn {background: #FFE600;}
				        td.fail {background: #FF0000; color: #ffffff;}
				        td.info {background: #85D4FF;}
				    </style>
				    <body>
				    <h1 align=""center"">Server Info: ${BitbucketDomain}</h1>
				    <h3 align=""center"">Generated: ${reportime}</h3>"
        
        $htmltail = "</body>
			    </html>"

        $htmlreport = ${htmlhead} + ${htmlbody} + ${htmltail};

        #endregion ReportDetail


    # } # PROCESS    


    #End {   
		write-host "Generated File ${outputlocation}";
		$htmlreport | Out-File ${outputlocation} -Encoding Utf8 -force;

    #} #End