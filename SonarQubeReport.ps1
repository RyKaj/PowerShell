<# 
.AUTHOR: Ryan Kajiura - http://ca.linkedin.com/in/ryankajiura

.SYNOPSIS 
	Script that will generate an HTML report on the Octopus project configurations
 
.DESCRIPTION 
	This script will access all Octopus GET API and proivde a report. Default output will the users download directory

.OUTPUTS
    Default save location will be logged in users download directory

.PARAMETER -DebugMode
    List parameter and variables
	
.PARAMETER -Verbose
    See more detailed progress as the script is running.


.Example 
	SonarQubeAuditReport -SonarQubeDomain "http://ABC123.com" -username "ABC" -password "ABC123";

.Example Change output location
	SonarQubeAuditReport -SonarQubeDomain "http://ABC123.com" -username "ABC" -password "ABC123" -outputlocation "C:\abc\SonarQubeReport.html"
	

.Reference
    SonarQube API Resources
	http://ABC123.com/web_api
	
#>

#region PrivateFunction

#endregion PrivateFunction


#region PublicFunction

    function SonarQubeAuditReport {
        param(
            [Parameter(Mandatory=$true)] [String] ${SonarQubeDomain}
		    , [Parameter(Mandatory=$true)] [String] ${username}		
		    , [Parameter(Mandatory=$true)] [String] ${password}		
		    , [Parameter(Mandatory=$false)] [String] ${outputlocation} = "$($env:USERPROFILE)\Downloads\SonarQubeReport.html"
            , [Parameter(Mandatory=$false)] [bool] $DebugMode = $false
            )

        clear;
    
        write-host "function being executed '$($MyInvocation.MyCommand)' ";
	
        #######################################################################################################
        # Constants
        #######################################################################################################
        [DateTime] $STARTTIME = get-date;            	        
        [String] $SPACER = "<br />";
        [String]$SONARQUBEURI = "${SonarQubeDomain}/sonar"


        #################################################################################################
        ##   Variables
        #################################################################################################
        $temp = "";
        $htmlreport = @();
        $htmlbody = @();

            

        #BEGIN {
            $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes( ( "{0}:{1}" -f ${username}, ${password} ) ) );
            $header = @{ Authorization="Basic ${base64AuthInfo}" };
		    clear;

        #    BEGIN{
            
                #Start-Job -Name "Feeds" -ScriptBlock { 
                    Write-Host "Collecting SonarQube version...";
                    $SQVersion = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/server/version" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Feeds" -ScriptBlock { 
                    Write-Host "Collecting Computer Engine Activity Information...";
                    $ComputerEngineActivity = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/ce/activity" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Rules" -ScriptBlock { 
                    Write-Host "Collecting Java Rules...";
                    $RulesJava = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/rules/search?languages=java" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Rules" -ScriptBlock { 
                    Write-Host "Collecting CSharp Rules...";
                    $RulesCSharp = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/rules/search?languages=cs" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Rules" -ScriptBlock { 
                    Write-Host "Collecting JavaScript Rules...";
                    $RulesJavaScript = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/rules/search?languages=js" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Rules" -ScriptBlock { 
                    Write-Host "Collecting Python Rules...";
                    $RulesPython = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/rules/search?languages=py" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Rules" -ScriptBlock { 
                    Write-Host "Collecting PHP Rules...";
                    $RulesPHP = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/rules/search?languages=php" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Rules" -ScriptBlock { 
                    Write-Host "Collecting VB.NET Rules...";
                    $RulesVBNet = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/rules/search?languages=vbnet" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Rules" -ScriptBlock { 
                    Write-Host "Collecting TypeScript Rules...";
                    $RulesTypeScript = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/rules/search?languages=ts" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Rules" -ScriptBlock { 
                    Write-Host "Collecting Flex Rules...";
                    $RulesFlex = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/rules/search?languages=flex" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Rules" -ScriptBlock { 
                    Write-Host "Collecting Flex Rules...";
                    $RulesHTML = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/rules/search?languages=web" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Rules" -ScriptBlock { 
                    Write-Host "Collecting Kotlin Rules...";
                    $RulesKotlin = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/rules/search?languages=kotlin" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Rules" -ScriptBlock { 
                    Write-Host "Collecting Ruby Rules...";
                    $RulesRuby = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/rules/search?languages=ruby" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Rules" -ScriptBlock { 
                    Write-Host "Collecting Scala Rules...";
                    $RulesScala = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/rules/search?languages=scala" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Rules" -ScriptBlock { 
                    Write-Host "Collecting Go Rules...";
                    $RulesGo = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/rules/search?languages=go" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Rules" -ScriptBlock { 
                    Write-Host "Collecting CSS Rules...";
                    $RulesCSS = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/rules/search?languages=css" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Rules" -ScriptBlock { 
                    Write-Host "Collecting XML Rules...";
                    $RulesXML = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/rules/search?languages=xml" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Rules" -ScriptBlock { 
                    Write-Host "Collecting JSP Rules...";
                    $RulesJSP = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/rules/search?languages=jsp" -Method Get;
                #};
                #Wait-Job -Name "Feeds";
            
                #Start-Job -Name "Feeds" -ScriptBlock { 
                #    Write-Host "Collecting Computer Engine Component Information...";
                    $ComputerEngineComponent = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/component/search?languages=jsp" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Feeds" -ScriptBlock { 
                    Write-Host "Collecting Favorites Information...";
                    $FavoriteList = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/favorites/search" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Feeds" -ScriptBlock { 
                    Write-Host "Collecting SCM Accounts Information...";
                    $SCMAccounts = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/issues/authors" -Method Get;            
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Feeds" -ScriptBlock { 
                    Write-Host "Collecting Issues Information...";
                    $Issues = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/issues/search" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Feeds" -ScriptBlock { 
                    Write-Host "Collecting Tags Information...";
                    $Tags = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/issues/tags" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Feeds" -ScriptBlock { 
                    Write-Host "Collecting Language Information...";
                    $LangList = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/languages/list" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Feeds" -ScriptBlock { 
                    Write-Host "Collecting Custom Metrics Information...";
                    $CustomMetricsList = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/metrics/domains" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Feeds" -ScriptBlock { 
                    Write-Host "Collecting Metrics Information...";
                    $MetricsList = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/metrics/search" -Method Get;
                #};
                #Wait-Job -Name "Feeds";
                #Start-Job -Name "Feeds" -ScriptBlock { 
                    Write-Host "Collecting Metrics Types Information...";
                    $MetricsTypes = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/metrics/types" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Feeds" -ScriptBlock { 
                    Write-Host "Collecting Notification Methods Information...";
                    $NotificationMethods = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/notifications/list" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Feeds" -ScriptBlock { 
                    Write-Host "Collecting Permission template Information...";
                    $PermissionTemplates = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/permissions/search_templates" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Feeds" -ScriptBlock { 
                    Write-Host "Collecting Installed Plugins Information...";
                    $PluginInstalled = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/plugins/installed" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Feeds" -ScriptBlock { 
                    Write-Host "Collecting Installed Plugins Require Update Information...";
                    $PluginRequireUpdated = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/plugins/updates" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Feeds" -ScriptBlock { 
                    Write-Host "Collecting Project Information...";
                    $ProjectList= Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/projects/search" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Feeds" -ScriptBlock { 
                    Write-Host "Collecting Definition Information...";
                    $DefinitionList = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/settings/list_definitions" -Method Get;
                #};
                #Wait-Job -Name "Feeds";
            
                #Start-Job -Name "Feeds" -ScriptBlock { 
                    Write-Host "Collecting Settings Information...";
                    $SettingList = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/settings/values" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Feeds" -ScriptBlock { 
                    Write-Host "Collecting Database Migration Information...";
                    $SysDBMigration = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/system/db_migration_status" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Feeds" -ScriptBlock { 
                    Write-Host "Collecting System Health Information...";
                    $SysHealth = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/system/health" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Feeds" -ScriptBlock { 
                    Write-Host "Collecting System Logs Information...";
                    $SysLogs = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/system/logs" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Feeds" -ScriptBlock { 
                    Write-Host "Collecting System Status Information...";
                    $SysStatus = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/system/status" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Feeds" -ScriptBlock { 
                    Write-Host "Collecting System Upgrade Information...";
                    $SysUpgrade = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/system/upgrades" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Feeds" -ScriptBlock { 
                    Write-Host "Collecting Groups Information...";
                    $Groups = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/user_groups/search" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Feeds" -ScriptBlock { 
                    Write-Host "Collecting System Upgrade Information...";
                    $User = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/users/search" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

        #    }  #BEGIN
        
        #    PROCESS {


                #---------------------------------------------------------------------
                # Getting all the Computer Engine Activity instance and convert to HTML fragment
                #---------------------------------------------------------------------
                #region Deployment
                Write-Host "Processing Computer Engine Activity Information...";
                $subhead = "<h2>Computer Engine Activity Information</h2>";
                $htmlbody += ${subhead};
                
                $htmlbody +=  $ComputerEngineActivity.tasks  | 
                                select  id,
                                        type,
                                        componentId,
                                        componentKey,
                                        componentName,
                                        componentQualifier,
                                        analysisId,
                                        status,
                                        submittedAt,
                                        submitterLogin,
                                        startedAt,
                                        executedAt,
                                        executionTimeMs,
                                        logs,
                                        hasScannerContext,
                                        organization,
                                        warningCount,
                                        @{
                                            name = "warnings"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.warnings.PSObject.Properties) {
                                                        "$($property.Name): $($property.Value) "
                                                    }
                                                )
                                            }
                                        } |
                                Sort ComponentName |
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                #endregion Deployment

                #---------------------------------------------------------------------
                # Getting all the Rules and convert to HTML fragment
                #---------------------------------------------------------------------
                #region Rules
            
                    #region RulesJava
                    Write-Host "Processing Rules - Java Information...";
                    $subhead = "<h2>Rules - Java </h2>";
                    $htmlbody += ${subhead};
                
                    $htmlbody +=  $RulesJava.rules |
                                    select  Name,
                                            key,
                                            repo,
                                            createdAt,
                                            htmlDesc,
                                            #mdDesc,
                                            @{
                                                name = "mdDesc"
                                                Expression = {
                                                    $_.mdDesc -replace '<.*?>',''
                                                }
                                            },
                                            severity,
                                            status,
                                            tags,
                                            @{
                                                name = "sysTags"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.sysTags.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) "
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "params"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.params.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) "
                                                        }
                                                    )
                                                }
                                            },
                                            debtOverloaded,
                                            remFnOverloaded,
                                            scope,
                                            isExternal,
                                            type |
                                    Sort severity, Name |
                                    ConvertTo-Html -Fragment;

                    $htmlbody += ${SPACER};

                    #endregion RulesJava

                    #region RulesCS
                    Write-Host "Processing Rules - C# Information...";
                    $subhead = "<h2>Rules - C#</h2>";
                    $htmlbody += ${subhead};
                
                    $htmlbody +=  $RulesCSharp.rules |
                                    select  Name,
                                            key,
                                            repo,
                                            createdAt,
                                            htmlDesc,
                                            mdDesc,
                                            severity,
                                            status,
                                            tags,
                                            @{
                                                name = "sysTags"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.sysTags.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) "
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "params"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.params.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) "
                                                        }
                                                    )
                                                }
                                            },
                                            debtOverloaded,
                                            remFnOverloaded,
                                            scope,
                                            isExternal,
                                            type |
                                    Sort severity, Name |
                                    ConvertTo-Html -Fragment;

                    $htmlbody += ${SPACER};

                    #endregion RulesCS
			
                    #region RulesJavaScript
                    Write-Host "Processing Rules - JavaScript Information...";
                    $subhead = "<h2>Rules - JavaScript </h2>";
                    $htmlbody += ${subhead};
                
                    $htmlbody +=  $RulesJavaScript.rules |
                                    select  Name,
                                            key,
                                            repo,
                                            createdAt,
                                            htmlDesc,
                                            mdDesc,
                                            severity,
                                            status,
                                            tags,
                                            @{
                                                name = "sysTags"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.sysTags.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) "
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "params"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.params.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) "
                                                        }
                                                    )
                                                }
                                            },
                                            debtOverloaded,
                                            remFnOverloaded,
                                            scope,
                                            isExternal,
                                            type |
                                    Sort severity, Name |
                                    ConvertTo-Html -Fragment;

                    $htmlbody += ${SPACER};

                    #endregion RulesJavaScript

                    #region RulesPython
                    Write-Host "Processing Rules - Python Information...";
                    $subhead = "<h2>Rules - Python </h2>";
                    $htmlbody += ${subhead};
                
                    $htmlbody +=  $RulesPython.rules |
                                    select  Name,
                                            key,
                                            repo,
                                            createdAt,
                                            htmlDesc,
                                            mdDesc,
                                            severity,
                                            status,
                                            tags,
                                            @{
                                                name = "sysTags"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.sysTags.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) "
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "params"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.params.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) "
                                                        }
                                                    )
                                                }
                                            },
                                            debtOverloaded,
                                            remFnOverloaded,
                                            scope,
                                            isExternal,
                                            type |
                                    Sort severity, Name |
                                    ConvertTo-Html -Fragment;

                    $htmlbody += ${SPACER};

                    #endregion RulesPython

                    #region RulesPHP
                    Write-Host "Processing Rules - PHP Information...";
                    $subhead = "<h2>Rules - PHP </h2>";
                    $htmlbody += ${subhead};
                
                    $htmlbody +=  $RulesPHP.rules |
                                    select  Name,
                                            key,
                                            repo,
                                            createdAt,
                                            htmlDesc,
                                            mdDesc,
                                            severity,
                                            status,
                                            tags,
                                            @{
                                                name = "sysTags"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.sysTags.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) "
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "params"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.params.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) "
                                                        }
                                                    )
                                                }
                                            },
                                            debtOverloaded,
                                            remFnOverloaded,
                                            scope,
                                            isExternal,
                                            type |
                                    Sort severity, Name |
                                    ConvertTo-Html -Fragment;

                    $htmlbody += ${SPACER};

                    #endregion RulesPHP

                    #region RulesVBNet
                    Write-Host "Processing Rules - VBNet Information...";
                    $subhead = "<h2>Rules - VBNet </h2>";
                    $htmlbody += ${subhead};
                
                    $htmlbody +=  $RulesVBNet.rules |
                                    select  Name,
                                            key,
                                            repo,
                                            createdAt,
                                            htmlDesc,
                                            mdDesc,
                                            severity,
                                            status,
                                            tags,
                                            @{
                                                name = "sysTags"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.sysTags.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) "
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "params"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.params.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) "
                                                        }
                                                    )
                                                }
                                            },
                                            debtOverloaded,
                                            remFnOverloaded,
                                            scope,
                                            isExternal,
                                            type |
                                    Sort severity, Name |
                                    ConvertTo-Html -Fragment;

                    $htmlbody += ${SPACER};

                    #endregion RulesVBNet

                    #region RulesTypeScript
                    Write-Host "Processing Rules - TypeScript Information...";
                    $subhead = "<h2>Rules - TypeScript </h2>";
                    $htmlbody += ${subhead};
                
                    $htmlbody +=  $RulesTypeScript.rules |
                                    select  Name,
                                            key,
                                            repo,
                                            createdAt,
                                            htmlDesc,
                                            mdDesc,
                                            severity,
                                            status,
                                            tags,
                                            @{
                                                name = "sysTags"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.sysTags.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) "
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "params"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.params.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) "
                                                        }
                                                    )
                                                }
                                            },
                                            debtOverloaded,
                                            remFnOverloaded,
                                            scope,
                                            isExternal,
                                            type |
                                    Sort severity, Name |
                                    ConvertTo-Html -Fragment;

                    $htmlbody += ${SPACER};

                    #endregion RulesTypeScript

                    #region RulesFlex
                    Write-Host "Processing Rules - Flex Information...";
                    $subhead = "<h2>Rules - Flex </h2>";
                    $htmlbody += ${subhead};
                
                    $htmlbody +=  $RulesFlex.rules |
                                    select  Name,
                                            key,
                                            repo,
                                            createdAt,
                                            htmlDesc,
                                            mdDesc,
                                            severity,
                                            status,
                                            tags,
                                            @{
                                                name = "sysTags"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.sysTags.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) "
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "params"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.params.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) "
                                                        }
                                                    )
                                                }
                                            },
                                            debtOverloaded,
                                            remFnOverloaded,
                                            scope,
                                            isExternal,
                                            type |
                                    Sort severity, Name |
                                    ConvertTo-Html -Fragment;

                    $htmlbody += ${SPACER};

                    #endregion RulesFlex

                    #region RulesKotlin
                    Write-Host "Processing Rules - Kotlin Information...";
                    $subhead = "<h2>Rules - Kotlin </h2>";
                    $htmlbody += ${subhead};
                
                    $htmlbody +=  $RulesKotlin.rules |
                                    select  Name,
                                            key,
                                            repo,
                                            createdAt,
                                            htmlDesc,
                                            mdDesc,
                                            severity,
                                            status,
                                            tags,
                                            @{
                                                name = "sysTags"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.sysTags.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) "
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "params"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.params.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) "
                                                        }
                                                    )
                                                }
                                            },
                                            debtOverloaded,
                                            remFnOverloaded,
                                            scope,
                                            isExternal,
                                            type |
                                    Sort severity, Name |
                                    ConvertTo-Html -Fragment;

                    $htmlbody += ${SPACER};

                    #endregion RulesKotlin
			
                    #region RulesRuby
                    Write-Host "Processing Rules - Ruby Information...";
                    $subhead = "<h2>Rules - Ruby </h2>";
                    $htmlbody += ${subhead};
                
                    $htmlbody +=  $RulesRuby.rules |
                                    select  Name,
                                            key,
                                            repo,
                                            createdAt,
                                            htmlDesc,
                                            mdDesc,
                                            severity,
                                            status,
                                            tags,
                                            @{
                                                name = "sysTags"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.sysTags.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) "
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "params"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.params.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) "
                                                        }
                                                    )
                                                }
                                            },
                                            debtOverloaded,
                                            remFnOverloaded,
                                            scope,
                                            isExternal,
                                            type |
                                    Sort severity, Name |
                                    ConvertTo-Html -Fragment;

                    $htmlbody += ${SPACER};

                    #endregion RulesRuby
			
                    #region RulesScala
                    Write-Host "Processing Rules - Scala Information...";
                    $subhead = "<h2>Rules - Scala </h2>";
                    $htmlbody += ${subhead};
                
                    $htmlbody +=  $RulesScala.rules |
                                    select  Name,
                                            key,
                                            repo,
                                            createdAt,
                                            htmlDesc,
                                            mdDesc,
                                            severity,
                                            status,
                                            tags,
                                            @{
                                                name = "sysTags"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.sysTags.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) "
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "params"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.params.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) "
                                                        }
                                                    )
                                                }
                                            },
                                            debtOverloaded,
                                            remFnOverloaded,
                                            scope,
                                            isExternal,
                                            type |
                                    Sort severity, Name |
                                    ConvertTo-Html -Fragment;

                    $htmlbody += ${SPACER};

                    #endregion RulesScala

                    #region RulesGo
                    Write-Host "Processing Rules - Go Information...";
                    $subhead = "<h2>Rules - Go </h2>";
                    $htmlbody += ${subhead};
                
                    $htmlbody +=  $RulesGo.rules |
                                    select  Name,
                                            key,
                                            repo,
                                            createdAt,
                                            htmlDesc,
                                            mdDesc,
                                            severity,
                                            status,
                                            tags,
                                            @{
                                                name = "sysTags"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.sysTags.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) "
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "params"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.params.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) "
                                                        }
                                                    )
                                                }
                                            },
                                            debtOverloaded,
                                            remFnOverloaded,
                                            scope,
                                            isExternal,
                                            type |
                                    Sort severity, Name |
                                    ConvertTo-Html -Fragment;

                    $htmlbody += ${SPACER};

                    #endregion RulesGo
			
                    #region RulesCSS
                    Write-Host "Processing Rules - CSS Information...";
                    $subhead = "<h2>Rules - CSS </h2>";
                    $htmlbody += ${subhead};
                
                    $htmlbody +=  $RulesCSS.rules |
                                    select  Name,
                                            key,
                                            repo,
                                            createdAt,
                                            htmlDesc,
                                            mdDesc,
                                            severity,
                                            status,
                                            tags,
                                            @{
                                                name = "sysTags"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.sysTags.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) "
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "params"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.params.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) "
                                                        }
                                                    )
                                                }
                                            },
                                            debtOverloaded,
                                            remFnOverloaded,
                                            scope,
                                            isExternal,
                                            type |
                                    Sort severity, Name |
                                    ConvertTo-Html -Fragment;

                    $htmlbody += ${SPACER};

                    #endregion RulesCSS

                    #region RulesXML
                    Write-Host "Processing Rules - XML Information...";
                    $subhead = "<h2>Rules - XML </h2>";
                    $htmlbody += ${subhead};
                
                    $htmlbody +=  $RulesXML.rules |
                                    select  Name,
                                            key,
                                            repo,
                                            createdAt,
                                            htmlDesc,
                                            mdDesc,
                                            severity,
                                            status,
                                            tags,
                                            @{
                                                name = "sysTags"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.sysTags.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) "
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "params"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.params.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) "
                                                        }
                                                    )
                                                }
                                            },
                                            debtOverloaded,
                                            remFnOverloaded,
                                            scope,
                                            isExternal,
                                            type |
                                    Sort severity, Name |
                                    ConvertTo-Html -Fragment;

                    $htmlbody += ${SPACER};

                    #endregion RulesXML

                    #region RulesJSP
                    Write-Host "Processing Rules - JSP Information...";
                    $subhead = "<h2>Rules - JSP </h2>";
                    $htmlbody += ${subhead};
                
                    $htmlbody +=  $RulesJSP.rules |
                                    select  Name,
                                            key,
                                            repo,
                                            createdAt,
                                            htmlDesc,
                                            mdDesc,
                                            severity,
                                            status,
                                            tags,
                                            @{
                                                name = "sysTags"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.sysTags.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) "
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "params"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.params.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) "
                                                        }
                                                    )
                                                }
                                            },
                                            debtOverloaded,
                                            remFnOverloaded,
                                            scope,
                                            isExternal,
                                            type |
                                    Sort severity, Name |
                                    ConvertTo-Html -Fragment;

                    $htmlbody += ${SPACER};

                    #endregion RulesJSP

                #endregion Rules

                #---------------------------------------------------------------------
                # Getting all the Languages and convert to HTML fragment
                #---------------------------------------------------------------------
                #region Favorites
                Write-Host "Processing Favorites Information...";
                $subhead = "<h2>Favorites Information</h2>";
                $htmlbody += ${subhead};

                $subhead = "<h3>Pages Index: $($FavoriteList.paging.pageIndex)</h3>";
                $htmlbody += ${subhead};

                $subhead = "<h3>Pages pageSize: $($FavoriteList.paging.pageSize)</h3>";
                $htmlbody += ${subhead};

                
                $htmlbody +=  $FavoriteList.favorites   | 
                                select  organization,
                                        key,
                                        name,
                                        qualifier |
                                Sort name |
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                #endregion Favorites

                #---------------------------------------------------------------------
                # Getting all the Languages and convert to HTML fragment
                #---------------------------------------------------------------------
                #region SCMAccounts
                Write-Host "Processing SCM Accounts Information...";
                $subhead = "<h2>SCM Accounts</h2>";
                $htmlbody += ${subhead};
                
                $htmlbody +=  $SCMAccounts.authors | 
                                Select @{
                                            name = "Users"
                                            Expression = {
                                                $_
                                            }
                                        } | 
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                #endregion SCMAccounts

                #---------------------------------------------------------------------
                # Getting all the Languages and convert to HTML fragment
                #---------------------------------------------------------------------
                #region Issues
                #Write-Host "Processing Issues Information...";
                #$subhead = "<h2>SCM Accounts</h2>";
                #$htmlbody += ${subhead};
                #    
                #$htmlbody +=  $Issues.issues | 
                #                ConvertTo-Html -Fragment;
                #
                #$htmlbody += ${SPACER};

                #endregion Issues            

                #---------------------------------------------------------------------
                # Getting all the Languages and convert to HTML fragment
                #---------------------------------------------------------------------
                #region SCMAccounts
                Write-Host "Processing Tagss Information...";
                $subhead = "<h2>Tags</h2>";
                $htmlbody += ${subhead};
                
                $htmlbody +=  $Tags.tags | 
                                Select @{
                                            name = "Tags"
                                            Expression = {
                                                $_
                                            }
                                        } | 
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                #endregion SCMAccounts

                #---------------------------------------------------------------------
                # Getting all the Languages and convert to HTML fragment
                #---------------------------------------------------------------------
                #region LangaugeList
                Write-Host "Processing Language Information...";
                $subhead = "<h2>Language Information</h2>";
                $htmlbody += ${subhead};
                
                $htmlbody +=  $LangList.languages   | 
                                select  key,
                                        name |
                                Sort name |
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                #endregion LangaugeList

                #---------------------------------------------------------------------
                # Getting all Custom Metrics and convert to HTML fragment
                #---------------------------------------------------------------------
                #region CustomMetrics
                Write-Host "Processing Custom Metrics Information...";
                $subhead = "<h2>Custom Metrics</h2>";
                $htmlbody += ${subhead};
                
                $htmlbody +=  $CustomMetricsList.domains | 
                                Select @{
                                            name = "Domains"
                                            Expression = {
                                                $_
                                            }
                                        } | 
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                #endregion CustomMetrics

                #---------------------------------------------------------------------
                # Getting all Metrics and convert to HTML fragment
                #---------------------------------------------------------------------
                #region Metrics
                Write-Host "Processing Metrics Information...";
                $subhead = "<h2>Metrics</h2>";
                $htmlbody += ${subhead};
                
                $htmlbody +=  $MetricsList.metrics | 
                                Select  ID,
                                        Key,
                                        Type,
                                        name,
                                        Description,
                                        domain,
                                        Direction,
                                        Qualititative,
                                        hidden,
                                        custom | 
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                #endregion Metrics           

                #---------------------------------------------------------------------
                # Getting all Metrics Types and convert to HTML fragment
                #---------------------------------------------------------------------
                #region MetricTypes
                Write-Host "Processing Metrics Types Information...";
                $subhead = "<h2>Metrics Types </h2>";
                $htmlbody += ${subhead};
                
                $htmlbody +=  $MetricsTypes.types | 
                                Select @{
                                            name = "Types"
                                            Expression = {
                                                $_
                                            }
                                        } | 
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                #endregion MetricTypes

                #---------------------------------------------------------------------
                # Getting all Metrics Types and convert to HTML fragment
                #---------------------------------------------------------------------
                #region NotificationTypes
                Write-Host "Processing Notification Methods Types Information...";
                $subhead = "<h2>Notification Methods Global Types </h2>";
                $htmlbody += ${subhead};
                
                $htmlbody +=  $NotificationMethods.globalTypes | 
                                Select @{
                                            name = "Global Types"
                                            Expression = {
                                                $_
                                            }
                                        } | 
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                $subhead = "<h2>Channels </h2>";
                $htmlbody += ${subhead};

                $htmlbody +=  $NotificationMethods.channels | 
                                Select @{
                                            name = "channels"
                                            Expression = {
                                                $_
                                            }
                                        } | 
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                $subhead = "<h2>Notification </h2>";
                $htmlbody += ${subhead};

                #endregion NotificationTypes

                #---------------------------------------------------------------------
                # Getting all Metrics Types and convert to HTML fragment
                #---------------------------------------------------------------------
                #region TemplatePermission
                Write-Host "Processing Metrics Types Information...";
                $subhead = "<h2>Default Template</h2>";
                $htmlbody += ${subhead};
                
                $htmlbody +=  $PermissionTemplates.defaultTemplates | 
                                Select  templateID,
                                        qualifier | 
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                $subhead = "<h2>Permissions Template</h2>";
                $htmlbody += ${subhead};

                $htmlbody +=  $PermissionTemplates.permissionTemplates | 
                                Select  Id,
                                        name,
                                        description,
                                        projectkeypattern,
                                        createdat,
                                        updatedat,
                                        @{
	                                        name = "permissions"
	                                        Expression = {
		                                        $(
			                                        Foreach ($property in $_.permissions.PSObject.Properties) {
				                                        "$($property.Name) - $($property.Value)"
			                                        }
		                                        )
	                                        }
                                        } | 
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                $subhead = "<h2>Permissions</h2>";
                $htmlbody += ${subhead};

                $htmlbody +=  $PermissionTemplates.permissions |
                                    Select  Key,
                                            Name,
                                            Description |
                                    ConvertTo-Html -Fragment;


                #endregion TemplatePermission

                #---------------------------------------------------------------------
                # Getting all Metrics Types and convert to HTML fragment
                #---------------------------------------------------------------------
                #region UpdatedPlugin
                Write-Host "Processing Installed Plugins Information...";
                $subhead = "<h2>Installed Plugins</h2>";
                $htmlbody += ${subhead};
                
                $htmlbody +=  $PluginInstalled.plugins | 
                                Select  key,
                                        name,
                                        description,
                                        version,
                                        license,
                                        organizationname,
                                        organizationurl,
                                        editionbundled,
                                        homepageurl,
                                        issuetrackerurl,
                                        implementationBuild,
                                        @{
                                            name = "updatedat"
                                            Expression = {
                                                $(
                                                    ([datetime]"1/1/1970").AddMilliseconds($_.updatedat).DateTime
                                                )
                                            }
                                        },
                                        filename,
                                        sonarlintsupported,
                                        hash | 
                                sort name |
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                #endregion UpdatedPlugin

                #---------------------------------------------------------------------
                # Getting all Metrics Types and convert to HTML fragment
                #---------------------------------------------------------------------
                #region UpdatedPlugin
                Write-Host "Processing Plugins Update Information...";
                $subhead = "<h2>Installed Update Plugins</h2>";
                $htmlbody += ${subhead};

                $subhead = "<h3>Installed Refresh: $($PluginRequireUpdated.updateCenterRefresh)</h3>";
                $htmlbody += ${subhead};

                $htmlbody +=  $PluginRequireUpdated.plugins | 
                                Select  key,
                                        name,
                                        category,
                                        description,
                                        license,
                                        organizationname,
                                        homepageurl,
                                        issuetrackerurl,
                                        editionBundled,
                                        @{
                                            name = "updates"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.updates.PSObject.Properties) {
                                                        "$($property.Name) - $($property.Value) "
                                                    }
                                                )
                                            }
                                        }  | 
                                sort name |
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                #endregion UpdatedPlugin

                #---------------------------------------------------------------------
                # Getting all Metrics Types and convert to HTML fragment
                #---------------------------------------------------------------------
                #region UpdatedPlugin
                Write-Host "Processing Project ListInformation...";
                $subhead = "<h2>Installed Plugins</h2>";
                $htmlbody += ${subhead};

                $htmlbody +=  $ProjectList.components | 
                                Select  organization,
                                        id,
                                        key,
                                        name,
                                        qualifier,
                                        visibility,
                                        lastAnalysisdate | 
                                sort name |
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                #endregion UpdatedPlugin

                #---------------------------------------------------------------------
                # Getting all Metrics Types and convert to HTML fragment
                #---------------------------------------------------------------------
                #region DefinitionList
                Write-Host "Processing Definition List Information...";
                $subhead = "<h2>Definition List</h2>";
                $htmlbody += ${subhead};

                $htmlbody +=  $DefinitionList.definitions | 
                                Select  key,
                                        name,
                                        description,
                                        category,
                                        subcategory,
                                        defaultvalue,
                                        multivalues,
                                        @{
                                            name = "options"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.options.PSObject.Properties) {
                                                        "$($property.Name) - $($property.Value) "
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "fields"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.fields.PSObject.Properties) {
                                                        "$($property.Name) - $($property.Value) "
                                                    }
                                                )
                                            }
                                        }  | 
                                sort name |
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                #endregion DefinitionList
            
                #---------------------------------------------------------------------
                # Getting all Metrics Types and convert to HTML fragment
                #---------------------------------------------------------------------
                #region SettingsList
                Write-Host "Processing Settings List Information...";
                $subhead = "<h2>Settings List</h2>";
                $htmlbody += ${subhead};

                $htmlbody +=  $SettingList.settings | 
                                Select  key,
                                        value,
                                        inherited | 
                                sort key |
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                #endregion SettingsList
            
                #---------------------------------------------------------------------
                # Getting all Metrics Types and convert to HTML fragment
                #---------------------------------------------------------------------
                #region DBMigration
                Write-Host "Processing Database Migration Information...";
                $subhead = "<h2>Database Migration Status</h2>";
                $htmlbody += ${subhead};

                $htmlbody +=  $SysDBMigration  | 
                                Select  state,
                                        message | 
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                #endregion DBMigration

                #---------------------------------------------------------------------
                # Getting all Metrics Types and convert to HTML fragment
                #---------------------------------------------------------------------
                #region SysHealth
                Write-Host "Processing System Health Information...";
                $subhead = "<h2>System Health</h2>";
                $htmlbody += ${subhead};

                $htmlbody +=  $SysHealth  | 
                                Select  health,
                                        @{
                                            name = "causes"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.causes.PSObject.Properties) {
                                                        "$($property.Name) - $($property.Value) "
                                                    }
                                                )
                                            }
                                        } | 
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                #endregion SysHealth
            
                #---------------------------------------------------------------------
                # Getting all Metrics Types and convert to HTML fragment
                #---------------------------------------------------------------------
                #region DBMigration
                Write-Host "Processing System Log Information...";
                $subhead = "<h2>System Logs</h2>";
                $htmlbody += ${subhead};

                $htmlbody +=  $SysLogs  | 
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                #endregion DBMigration
 
                #---------------------------------------------------------------------
                # Getting all Metrics Types and convert to HTML fragment
                #---------------------------------------------------------------------
                #region SysStatus
                Write-Host "Processing System Status Information...";
                $subhead = "<h2>System Status</h2>";
                $htmlbody += ${subhead};

                $htmlbody +=  $SysStatus |
                                Select  id,
                                        Version,
                                        status |
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                #endregion SysStatus           
 
                #---------------------------------------------------------------------
                # Getting all Metrics Types and convert to HTML fragment
                #---------------------------------------------------------------------
                #region SysUpgrade
                Write-Host "Processing System Status Information...";
                $subhead = "<h2>System Upgrade</h2>";
                $htmlbody += ${subhead};

                #$SysUpgrade.updateCenterRefresh

                $htmlbody +=  $SysUpgrade.upgrades |
                                Select  version,
                                        description,
                                        releasedata,
                                        chagnelogurl,
                                        downlaodurl,
                                        plugins |
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                #endregion SysUpgrade               
            
                #---------------------------------------------------------------------
                # Getting all Metrics Types and convert to HTML fragment
                #---------------------------------------------------------------------
                #region SysGroups
                Write-Host "Processing Groups Information...";
                $subhead = "<h2>Groups</h2>";
                $htmlbody += ${subhead};
                $htmlbody +=  $Groups.groups |
                                Select  id,
                                        name,
                                        description,
                                        memberCount,
                                        defualt |
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                #endregion SysGroups

                #---------------------------------------------------------------------
                # Getting all Metrics Types and convert to HTML fragment
                #---------------------------------------------------------------------
                #region SysGroups
                Write-Host "Processing User Information...";
                $subhead = "<h2>User</h2>";
                $htmlbody += ${subhead};


                $htmlbody +=  $User.users |
                                Select  login,
                                        name,
                                        actiem,
                                        @{
                                            name = "groups"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.groups.PSObject.Properties) {
                                                        "$($property.Name) - $($property.Value) "
                                                    }
                                                )
                                            }
                                        },
                                        tofkenscount,
                                        local,
                                        edtranlidentity,
                                        externalprovider |
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                #endregion SysGroups

            #} #PROCESS
    
            #End {
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
			                <h1 align=""center"">Server Info: $env:computername</h1>
			                <h3 align=""center"">Generated: ${reportime}</h3>"

                $htmltail = "</body>
		                </html>"

                $htmlreport = ${htmlhead} + ${htmlbody} + ${htmltail};
            
                #endregion ReportDetail
        
                Write-Host "Generated File stored '${outputlocation}' ";
                $htmlreport | Out-File ${outputlocation} -Encoding Utf8 -force;              

                Write-Host "-------------------------------------------------------------------";
                "Total Duration: {0:HH:mm:ss}" -f ([datetime]$((Get-Date) - ${StartTime}).Ticks) | Write-Host;
                Write-Host "-------------------------------------------------------------------";

            #} #End



    } # SonarQubeAuditReport

#endregion PublicFunction