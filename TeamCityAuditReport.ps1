<# 
.AUTHOR: Ryan Kajiura

.SYNOPSIS 
	Script that will generate an HTML report on Team City configurations
 
.DESCRIPTION 
	This script will access all Team City GET API and proivde a report. Default output will the users download directory

.OUTPUTS
    Default save location will be logged in users download directory
	

.Example Providng ID/Password
	GetTeamCityAuditReport -TeamCityDomain "http://ABC123.com" -username "ryank" -password "abc123";

.Example Providng ID/Password - change output directory
	GetTeamCityAuditReport -TeamCityDomain "http://ABC123.com" -username "ryank" -password "abc123" -outputlocation "$($env:USERPROFILE)\Downloads\TeamCityAuditReport.html";

		
.Reference
    TeamCity Resources
        https://confluence.jetbrains.com/display/TCD18/REST+API
        https://dploeger.github.io/teamcity-rest-api/

#>


#region PrivateFunction

#endregion PrivateFunction


#region PublicFunction

    function GetTeamCityAuditReport {
        param(
            [Parameter(Mandatory=$true)] [String] ${TeamCityDomain}
		    , [Parameter(Mandatory=$true)] [String] ${username}
		    , [Parameter(Mandatory=$true)] [String] ${password}
		    , [Parameter(Mandatory=$false)] [String] ${outputlocation} = "$($env:USERPROFILE)\Downloads\TeamCityAuditReport.html"
            , [Parameter(Mandatory=$false)] [bool] $DebugMode = $false
            )

        clear;
    
        write-host "function being executed '$($MyInvocation.MyCommand)' ";
	

        #################################################################################################
        ## Variables - Static
        #################################################################################################    
        [DateTime] $STARTTIME = Get-Date;	
        [String] $SPACER = "<br />";
	    [String] $TeamCityURI = "${TeamCityDomain}/httpAuth/app/rest";
    

        #################################################################################################
        ## Variables - Session
        #################################################################################################    
        $temp = "";
        $htmlreport = @();
        $htmlbody = @();

        #######################################################################################################
        ###   DEBUG
        #######################################################################################################
        if ($DebugMode -eq $True) {        
            foreach ( $key in (Get-Command -Name $MyInvocation.InvocationName).Parameters.Keys ) {
                $value = (Get-Variable $key -ErrorAction SilentlyContinue).Value
                if ( ${value} -or ${value} -eq 0 ) {
                    Write-Host "Function parameter...${key} -> ${value}";
                } 
            }        
        }
	
	

	
        #BEGIN {
            $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes( ( "{0}:{1}" -f ${username}, ${password} ) ) );
            $header = @{ Authorization="Basic ${base64AuthInfo}" };
            #$header["X-Atlassian-Token"] = "nocheck";

            #Start-Job -Name "Users" -ScriptBlock { 
                Write-Host "Collecting Users Information...";
                $Users = Invoke-RestMethod -Headers $header -Uri "${TeamCityURI}/users" -Method Get;
            #}; 
            #Wait-Job -Name "Users";
            #Start-Job -Name "UsersGroups" -ScriptBlock { 
                Write-Host "Collecting Group Information...";
                $Groups = Invoke-RestMethod -Headers $header -Uri "${TeamCityURI}/userGroups" -Method Get;
            #};
            #Wait-Job -Name "UsersGroups";
            #Start-Job -Name "Agents" -ScriptBlock { 
                Write-Host "Collecting Agents ...";
                $Agents = Invoke-RestMethod -Headers $header -Uri "${TeamCityURI}/agents" -Method Get;            
            #};
            #Wait-Job -Name "Agents";        
            #Start-Job -Name "Projects" -ScriptBlock { 
                Write-Host "Collecting Projects ...";
                $Projects = Invoke-RestMethod -Headers $header -Uri "${TeamCityURI}/projects" -Method Get;
            #};
            #Wait-Job -Name "Projects";        
            #Start-Job -Name "Bulid" -ScriptBlock { 
                Write-Host "Collecting Build Configuration...";
                $BuildConfig = Invoke-RestMethod -Headers $header -Uri "${TeamCityURI}/buildTypes" -Method Get;
            #};
            #Wait-Job -Name "Bulid";        
            #Start-Job -Name "VCS" -ScriptBlock { 
                Write-Host "Collecting VCS Configuration...";
                $VCSConfig = Invoke-RestMethod -Headers $header -Uri "${TeamCityURI}/vcs-roots" -Method Get;
            #};
            #Wait-Job -Name "VCS";

        # } # BEGIN    
  

        #PROCESS{
            clear;

            #---------------------------------------------------------------------
            # Getting Users details and convert to HTML fragment
            #---------------------------------------------------------------------
            #region Users
            Write-Host "Processing Users...";
            Foreach ($item in $Users.users.user | select username  | sort username ) {
                Write-Host "Collecting User details $($item.username)...";

                #Start-Job -Name "Users" -ScriptBlock { 
                    $UsersDetails = Invoke-RestMethod -Headers $header -Uri "${TeamCityURI}/users/$($item.username)" -Method Get;
                #}; 
                #Wait-Job -Name "Users";
                #Start-Job -Name "Roles" -ScriptBlock { 
                    $UsersRoles = Invoke-RestMethod -Headers $header -Uri "${TeamCityURI}/users/$($item.username)/roles" -Method Get;
                #}; 
                #Wait-Job -Name "Roles";


                $subhead = "<h2>User: $($UsersDetails.user.name)</h2>";
                $htmlbody += ${subhead};

                $subhead = "<h3>Detail Information: $($UsersDetails.user.name) </h3>";
                $htmlbody += ${subhead};
                $htmlbody += $UsersDetails.user |
                                SELECT  id,
                                        name,
                                        username,
                                        email,
                                        href,
                                        @{
                                            name = "properties"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Properties.property) {
                                                        "$($property.Name): $($property.Value) "
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "roles"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.roles.role) {
                                                        "$($property.roleid): $($property.scope) ";
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "groups"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Groups.group) {
                                                        "$($property.key): $($property.name) ";
                                                    }
                                                )
                                            }
                                        } |
                                ConvertTo-Html -Fragment -As LIST;

                $htmlbody += ${SPACER};

                $subhead = "<h3>User Roles: $($UsersDetails.user.name) </h3>";
                $htmlbody += ${subhead};

                $htmlbody += $UsersRoles.roles.role |                 
                                SELECT  roleid,
                                        scope,
                                        href |
                                ConvertTo-Html -Fragment -As LIST;

               $htmlbody += ${SPACER};
            }  # for $Users.users.user

            #endregion Users

            #---------------------------------------------------------------------
            # Getting Users details and convert to HTML fragment
            #---------------------------------------------------------------------
            #region Roles
            Write-Host "Processing Roles...";
            Foreach ($item in $Users.users.user | select username  | sort username ) {
                Write-Host "Collecting User details $($item.username)...";

                #Start-Job -Name "Users" -ScriptBlock { 
                    $UsersDetails = Invoke-RestMethod -Headers $header -Uri "${TeamCityURI}/users/$($item.username)" -Method Get;
                #}; 
                #Wait-Job -Name "Users";
                #Start-Job -Name "Roles" -ScriptBlock { 
                    $UsersRoles = Invoke-RestMethod -Headers $header -Uri "${TeamCityURI}/users/$($item.username)/roles" -Method Get;
                #}; 
                #Wait-Job -Name "Roles";


                $subhead = "<h2>Roles: $($UsersDetails.user.name)</h2>";
                $htmlbody += ${subhead};

                $subhead = "<h3>Detail Information </h3>";
                $htmlbody += ${subhead};

                $htmlbody += $UsersDetails.user |                 
                                SELECT  id,
                                        name,
                                        username,
                                        email,
                                        href,
                                        @{
                                            name = "properties"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Properties.property) {
                                                        "$($property.Name): $($property.Value) ";
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "roles"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.roles.role) {
                                                        "$($property.roleid): $($property.scope) ";
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "groups"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Groups.group) {
                                                        "$($property.key): $($property.name) ";
                                                    }
                                                )
                                            }
                                        }|
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                $subhead = "<h3>Roles</h3>";
                $htmlbody += ${subhead};

                $htmlbody += $UsersRoles.roles.role |                 
                                SELECT  roleid,
                                        scope,
                                        href |
                                ConvertTo-Html -Fragment;

               $htmlbody += ${SPACER};
            }

            #endregion Roles

            #---------------------------------------------------------------------
            # Getting Users details and convert to HTML fragment
            #---------------------------------------------------------------------
            #region Groups
            Write-Host "Processing Groups...";
            $subhead = "<h2>Groups - Count: $($Groups.groups.group.Count)</h2>";
            $htmlbody += ${subhead};

            $htmlbody += $Groups.groups.group | Sort Name |
                            SELECT  Key,
                                    name,
                                    href,
                                    description -first 1 |
                            ConvertTo-Html -Fragment;

            $htmlbody += ${SPACER};

            Foreach ($item in $Groups.groups.group | SELECT -Skip 1 | sort name ) {
                $subhead = "<h3>Groups: $($item.name)</h3>";
                $htmlbody += ${subhead};        

    $GroupDetails = Invoke-RestMethod -Headers $header -Uri "${TeamCityURI}/userGroups/$($item.key)" -Method Get;

                $htmlbody += $Groups.groups.group |
                                SELECT  Key,
                                        name,
                                        description,
                                        parent-groups,
                                        users,
                                        roles,
                                        properties |
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};
           
            }
            #endregion Groups

            #---------------------------------------------------------------------
            # Getting Agents and convert to HTML fragment
            #---------------------------------------------------------------------
            #region Agents
            Write-Host "Processing Agents...";
            $subhead = "<h2>Agent - Count: $($Agents.agents.agent.Count)</h2>";
            $htmlbody += ${subhead};

            $htmlbody += $Agents.agents.agent | Sort Name |
                            SELECT  id,
                                    name,
                                    typeId,
                                    href,
                                    webUrl |
                            ConvertTo-Html -Fragment;

            $htmlbody += ${SPACER};

            #endregion Agents

            #---------------------------------------------------------------------
            # Getting Agents information and convert to HTML fragment
            #---------------------------------------------------------------------
            #region AgentDetail       
            Write-Host "Processing Agents Information...";
            Foreach ($item in $Agents.agents.agent | sort name ) {
                #Start-Job -Name "Agents" -ScriptBlock { 
                    $AgentDetail = Invoke-RestMethod -Headers $header -Uri "${TeamCityURI}/agents/$($item.name)" -Method Get;            
                #};
                #Wait-Job -Name "Agents";


                Write-Host "Collecting Agents information - $($item.name)...";
                $subhead = "<h2>Agent: $($item.name)</h2>";
                $htmlbody += ${subhead};


                $htmlbody += $AgentDetail.agent  | 
                    SELECT  id,
                            name,
                            type,
                            connected,
                            enabled,
                            authorized,
                            uptodate,
                            ip,
                            href,
                            weburl,
                            build,
                            @{
                                name = "enabledInfo"
                                Expression = {
                                    $(
                                        "$($_.enabledInfo.comment.timestamp)"
                                    )
                                }
                            },
                            @{
                                name = "authorizedInfo"
                                Expression = {
                                    $(
                                        "$($_.authorizedInfo.comment.Username) : $($_.authorizedInfo.comment.name) : $($_.authorizedInfo.comment.timestamp)"
                                    )
                                }
                            },
                            @{
                                name = "properties"
                                Expression = {
                                    $(
                                        Foreach ($property in $_.properties.property) {
                                            "$($property.Name): $($property.Value) ";
                                        }
                                    )
                                }
                            },
                            @{
                                name = "pool"
                                Expression = {
                                    $(
                                        "$($_.Pool.id) : $($_.Pool.name) : $($_.pool.href)"
                                    )
                                }
                            } |
                    ConvertTo-Html -Fragment;
      
                $htmlbody += ${SPACER};
            }

            #endregion AgentDetial
        
            #---------------------------------------------------------------------
            # Getting Projects and convert to HTML fragment
            #---------------------------------------------------------------------
            #region Projects
            Write-Host "Processing Projects...";
            $subhead = "<h2>Projects - Count: $($Projects.projects.project.Count)</h2>";
            $htmlbody += ${subhead};

            $htmlbody += $Projects.projects.project | 
						    Sort parentProjectID, name | 
                            SELECT  id,
                                    name,
                                    parentProjectId,
                                    archived,
                                    href,
                                    webUrl |
                            ConvertTo-Html -Fragment;

            $htmlbody += ${SPACER};

            #endregion Projects

            #---------------------------------------------------------------------
            # Getting Projects at Root level and convert to HTML fragment
            #---------------------------------------------------------------------
            #region ProjectDetialRoot
            Write-Host "Processing Root Level Project Information...";
            Foreach ($item in $Projects.projects.project | select ID -First 1| sort id ) {
                Write-Host "Collecting Projects $($item.id)...";

                #Start-Job -Name "Projects" -ScriptBlock { 
                    $ProjectDetails = Invoke-RestMethod -Headers $header -Uri "${TeamCityURI}/projects/$($item.id)" -Method Get;
                #};
                #Wait-Job -Name "Projects";

                if ($ProjectDetails.project.projects.count -eq 0) { continue; }


                $subhead = "<h2>Projects - Root Level</h2>";
                $htmlbody += ${subhead};

                $htmlbody += $ProjectDetails.project.projects.project | 
                                SELECT  id,
                                        name,
                                        href,
                                        webUrl |
                                ConvertTo-Html -Fragment;


               $htmlbody += ${SPACER};
            }
            #endregion ProjectDetailRoot

            #---------------------------------------------------------------------
            # Getting Projects and convert to HTML fragment
            #---------------------------------------------------------------------
            #region ProjectDetial
            Write-Host "Processing Projects Information...";
            Foreach ($item in $Projects.projects.project | select ID -Skip 1 | sort id ) {
                Write-Host "Collecting Projects $($item.id)...";

                #Start-Job -Name "Projects" -ScriptBlock { 
                    $ProjectDetails = Invoke-RestMethod -Headers $header -Uri "${TeamCityURI}/projects/$($item.id)" -Method Get;
                #};
                #Wait-Job -Name "Projects";

                if ($ProjectDetails.project.projects.count -eq 0) { continue; }


                $subhead = "<h2>$($ProjectDetails.project.parentProjectId) - $($ProjectDetails.project.name)</h2>";
                $htmlbody += ${subhead};

                $htmlbody += $ProjectDetails.project.projects.project | 
                                SELECT  id,
                                        name,
                                        href,
                                        webUrl |
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};
            }

            #endregion ProjectDetail

            #---------------------------------------------------------------------
            # Getting Build Configuration and convert to HTML fragment
            #---------------------------------------------------------------------
            #region BuildConfig
            Write-Host "Processing Build Configuration...";
            $subhead = "<h2>Build Configurations - Count: $($BuildConfig.buildTypes.buildType.Count)</h2>";
            $htmlbody += ${subhead};

            $htmlbody += $BuildConfig.buildTypes.buildType | Sort projectName |
                            SELECT  id,
                                    name,
                                    paused,
                                    projectName,
                                    projectId,
                                    href,
                                    webUrl |                        
                            ConvertTo-Html -Fragment;

            $htmlbody += ${SPACER};

            #endregion BuildConfig

            #---------------------------------------------------------------------
            # Getting Build Configuration linked to Projects and convert to HTML fragment
            #---------------------------------------------------------------------
            #region BuildConfigDetail
            Write-Host "Processing Build Configuration Information...";
            Foreach ($item in $BuildConfig.buildTypes.buildType.id | sort id ) {

                Write-Host "Collecting Build Configuration Information - $($item) ...";
                #Start-Job -Name "Builds" -ScriptBlock { 
                    $BuildConfigDetail = Invoke-RestMethod -Headers $header -Uri "${TeamCityURI}/buildTypes/$($item)" -Method Get;
                #};
                #Wait-Job -Name "Builds";

        
                $subhead = "<h2>Build Configurations - $($BuildConfigDetail.buildType.projectName) - $($BuildConfigDetail.buildType.name)</h2>";
                $htmlbody += ${subhead};

                $htmlbody += $BuildConfigDetail.buildType | Sort name | 
                                SELECT  id,
                                        name,
                                        description,
                                        projectName,
                                        projectId,
                                        href,
                                        webUrl,
                                        @{
                                            name = "project"
                                            Expression = {
                                                $(
                                                    "$($property.Name) [ inherited: $($property.inherited) ]: $($property.Value) ";
                                                    Foreach ($property in $_.project.parameters.property) {
                                                        "$($property.Name) [ inherited: $($property.inherited) ]: $($property.Value) ";
                                                    }

                                                    "Step ID: $($_.project.Step.id) : Step Name: $($_.project.Step.name)"

                                                    Foreach ($property in $_.project.steps.step.properties) {
                                                        "$($property.Name) [ inherited: $($property.inherited) ]: $($property.Value) ";
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "templates"
                                            Expression = {
                                                $(
                                                    "Template ID: $($_.templates.id) : Template Name: $($_.templates.Name)"
                                                )
                                            }
                                        },
                                        #@{
                                        #    name = "vcs-root-entries"
                                        #    Expression = {
                                        #        $(
                                        #            $_.'vcs-root-entries'  | ConvertTo-Xml -As String
                                        #        )
                                        #    }
                                        #},
                                        @{
                                            name = "settings"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.settings.property) {
                                                        "$($property.Name) : $($property.Value) ";
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "parameters"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.parameters.property) {
                                                        "$($property.Name): $($property.Value) ";
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "features"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.features.properties) {
                                                        "$($property.Name): $($property.Value) ";
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "triggers"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.triggers.trigger.property) {
                                                        "$($property.Name): $($property.Value) ";
                                                    }
                                                )
                                            }
                                        } | #,
                                        #@{
                                        #    name = "snapshot-dependencies"
                                        #    Expression = {
                                        #        $(
                                        #            $_.'snapshot-dependencies'  | ConvertTo-Xml -As String
                                        #        )
                                        #    }
                                        #},
                                        #@{
                                        #    name = "artifact-dependencies"
                                        #    Expression = {
                                        #        $(
                                        #            $_.'artifact-dependencies'  | ConvertTo-Xml -As String
                                        #            Foreach ($property in $_.triggers.trigger.property) {
                                        #                "$($property.Name): $($property.Value) ";
                                        #            }
                                        #
                                        #        )
                                        #    }
                                        #},
                                        #@{
                                        #    name = "agent-requirements"
                                        #    Expression = {
                                        #        $(
                                        #            Foreach ($property in $_.'agent-requirements') {
                                        #                "$($property.Name): $($property.Value) ";
                                        #            }
                                        #        )
                                        #    }
                                        #},
                                        #@{
                                        #    name = "builds"
                                        #    Expression = {
                                        #        $(
                                        #            $_.builds  | ConvertTo-Xml -As String
                                        #        )
                                        #    }
                                        #},
                                        #@{
                                        #    name = "investigations"
                                        #    Expression = {
                                        #        $(
                                        #            $_.investigations  | ConvertTo-Xml -As String
                                        #        )
                                        #    }
                                        #},
                                        #@{
                                        #        name = "compatibleAgents"
                                        #        Expression = {
                                        #            $(
                                        #                $_.compatibleAgents  | ConvertTo-Xml -As String
                                        #            )
                                        #        }
                                        #} |
                                ConvertTo-Html -Fragment;
            
                $htmlbody += ${SPACER};
            }

            #endregion BuildConfigDetail

            #---------------------------------------------------------------------
            # Getting Projects Build Configurations and convert to HTML fragment
            #---------------------------------------------------------------------
            #region BuildConfig
            Write-Host "Processing Projects Build Configuration Information...";

            Foreach ($item in $Projects.projects.project | select ID -Skip 1 | sort id ) {
                Write-Host "Collecting Projects $($item.id)...";

                #Start-Job -Name "Builds" -ScriptBlock { 
                    $ProjectBuildConfig = Invoke-RestMethod -Headers $header -Uri "${TeamCityURI}/projects/$($item.id)/buildTypes" -Method Get;
                #};
                #Wait-Job -Name "Builds";
                if ($ProjectBuildConfig.buildTypes.count -eq 0) { continue; }

                $subhead = "<h2>$($item.id) - $($ProjectBuildConfig.buildTypes.buildType.name -join ",")</h2>";
                $htmlbody += ${subhead};

                $htmlbody += $ProjectBuildConfig.buildTypes.buildType | 
                                SELECT  id,
                                        name,
                                        description,
                                        projectName,
                                        projectId,
                                        href,
                                        webUrl |
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};
            }

            #endregion BuildConfig

            #---------------------------------------------------------------------
            # Getting VCS and convert to HTML fragment
            #---------------------------------------------------------------------
            #region VCS
            Write-Host "Processing VCS Configuration...";
            $subhead = "<h2>VCS Configurations - $($VCSConfig.'vcs-roots'.count)</h2>";
            $htmlbody += ${subhead};

            $htmlbody += $VCSConfig.'vcs-roots'.'vcs-root' | sort Name | 
                            SELECT  id,
                                    name,
                                    href |
                            ConvertTo-Html -Fragment;

            $htmlbody += ${SPACER};

            #endregion VCS

            #---------------------------------------------------------------------
            # Getting VCS and convert to HTML fragment
            #---------------------------------------------------------------------
            #region VCSDetail
            Write-Host "Processing VCS Detailed Configuration...";

            foreach ($item in $VCSConfig.'vcs-roots'.'vcs-root' | sort Name) {
                Write-Host "Collecting VCS Detailed Configuration... processing '$($item.name)' ";

                $subhead = "<h2>VCS Configurations - $($item.name)</h2>";
                $htmlbody += ${subhead};
        
                $temp = $item.href -replace  "/httpAuth/app/rest/vcs-roots/id:", "";
            
                #Start-Job -Name "VCS" -ScriptBlock { 
                    $VCSConfigDetail = Invoke-RestMethod -Headers $header -Uri "${TeamCityURI}/vcs-roots/$temp" -Method Get;
                #};
                #Wait-Job -Name "VCS";

                $htmlbody += $VCSConfigDetail.'vcs-root' |
                                SELECT  id,
                                        name,
                                        href,
                                        vcsName,
                                        @{
                                            name = "properties"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Properties.property) {
                                                        "$($property.Name): $($property.Value) ";
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "vcsRootInstances"
                                            Expression = {
                                                $(
                                                    "$($_.vcsRootInstances.href)";
                                                )
                                            }
                                        } |
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

            }

            #endregion VCSDetail


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
				        <h1 align=""center"">Server Info: ${TeamCityDomain}</h1>
				        <h3 align=""center"">Generated: ${reportime}</h3>"
        
            $htmltail = "</body>
			        </html>"

            $htmlreport = ${htmlhead} + ${htmlbody} + ${htmltail};

            #endregion ReportDetail	


        # } # PROCESS


        #End {   
		    write-host "Generated File ${outputlocation}";
		    $htmlreport | Out-File ${outputlocation} -Encoding Utf8 -force;

            Write-Host "-------------------------------------------------------------------";
            "Total Duration: {0:HH:mm:ss}" -f ([datetime]$((Get-Date) - ${StartTime}).Ticks) | Write-Host;
            Write-Host "-------------------------------------------------------------------";
        #} #End


    } # GetTeamCityAuditReport

#endregion PublicFunction