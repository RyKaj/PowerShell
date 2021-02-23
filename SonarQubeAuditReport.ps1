<# 
.AUTHOR: Ryan Kajiura - http://ca.linkedin.com/in/ryankajiura

.SYNOPSIS 
	Script that will generate an HTML report on the SonarQube project configurations
 
.DESCRIPTION 
	This script will access all SonarQube GET API and proivde a report. Default output will the users download directory

.OUTPUTS
    Default save location will be logged in users download directory

Z.PARAMETER -DebugMode
    List parameter and variables
	
.PARAMETER -Verbose
    See more detailed progress as the script is running.

	
.Example Providng Token or ID/PW
	GetBitbucketCommitsReport -BitbucketDomain "http://ABC123.com" -username "90asd8f90dsa890fd8s" -password "";

.Example Providng Token or ID/PW - change output directory
	GetBitbucketCommitsReport -BitbucketDomain "http://ABC123.com" -username "90asd8f90dsa890fd8s" -password "" -outputlocation "$($env:USERPROFILE)\Downloads\BitbucketAuditReport.html";


	
.Reference
    SonarQube API Resources
        http://<your domain>/sonar/web_api?deprecated=true

#>

#region PrivateFunction

#endregion PrivateFunction


#region PublicFunction

#    function GetSonarQubeReport {
#        param(
#            [Parameter(Mandatory=$true)] [String] ${SonarQubeDomain}
#		    , [Parameter(Mandatory=$true)] [String] ${username}
#		    , [Parameter(Mandatory=$true)] [String] ${password}
#		    , [Parameter(Mandatory=$true)] [String[]] ${UsersCommit}
#		    , [Parameter(Mandatory=$false)] [String] ${outputlocation} = "$($env:USERPROFILE)\Downloads\SonarQubeReport.html"
#		    , [Parameter(Mandatory=$false)] [String] ${RecordLimit} = 1000
#            , [Parameter(Mandatory=$false)] [bool] $DebugMode = $false
#            )
        clear;

[String] ${SonarQubeDomain} = "http://sonarqube.pyrsoftware.ca"
[String] ${outputlocation} = "$($env:USERPROFILE)\Downloads\SonarQubeReport.html"
[String] ${RecordLimit} = 1000
    
#        write-host "function being executed '$($MyInvocation.MyCommand)' ";
	

        #######################################################################################################
        # Constants
        #######################################################################################################
        [DateTime] $STARTTIME = get-date;            	        
        [String] $SPACER = "<br />";

        [String]$username = "03ff750ea6db9c76e1d572155373ead678125da3"; #Report
        [String]$password = "";
    
        [String]$SONARQUBEURI = "${SonarQubeDomain}"


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
            
                #Start-Job -Name "version" -ScriptBlock { 
                    Write-Host "Collecting SonarQube version...";
                    $SQVersion = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/api/server/version" -Method Get;
                #};
                #Wait-Job -Name "version";

                #Start-Job -Name "ComputerEngineActivity" -ScriptBlock { 
                    Write-Host "Collecting Computer Engine Activity Information...";
                    try { 
                        $ComputerEngineActivity = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/api/ce/activity" -Method Get;
                    }
                    catch { 
                        Write-Verbose -Verbose $_;
                    }
                    finally { }
                #};
                #Wait-Job -Name "ComputerEngineActivity";

                #Start-Job -Name "ComputerEngineComponent" -ScriptBlock { 
                    Write-Host "Collecting Computer Engine Component Information...";
                    try { 
                        $ComputerEngineComponent = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/api/ce/component" -Method Get;
                    }
                    catch {
                        Write-Verbose -Verbose $_;
                    }
                    finally { }
                #};
                #Wait-Job -Name "ComputerEngineComponent";
                
                #Start-Job -Name "ComputerEngineTasks" -ScriptBlock { 
                    Write-Host "Collecting Computer Engine Tasks Information...";
                    try { 
                        $ComputerEngineTasks = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/api/ce/task" -Method Get;
                    }
                    catch {
                        Write-Verbose -Verbose $_;
                    }
                    finally { }
                #};
                #Wait-Job -Name "ComputerEngineTasks";

                #Start-Job -Name "ComputerEngineTasks" -ScriptBlock { 
                    Write-Host "Collecting Components Information...";
                    try { 
                        $ComputerEngineTasks = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/api/components/show" -Method Get;
                    }
                    catch {
                        Write-Verbose -Verbose $_;
                    }
                    finally { }
                #};
                #Wait-Job -Name "ComputerEngineTasks";

                #Start-Job -Name "ComputerEngineTasks" -ScriptBlock { 
                    Write-Host "Collecting Components Tree Information...";
                    try { 
                        $ComputerEngineTasks = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/api/components/tree" -Method Get;
                    }
                    catch {
                        Write-Verbose -Verbose $_;
                    }
                    finally { }
                #};
                #Wait-Job -Name "ComputerEngineTasks";

                #Start-Job -Name "DuplicationList" -ScriptBlock { 
                    Write-Host "Collecting Components Tree Information...";
                    try { 
                        $DuplicationList = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/api/components/show" -Method Get;
                    }
                    catch {
						Write-Verbose -Verbose $_;
                    }
                    finally { }
                #};
                #Wait-Job -Name "DuplicationList";

                #Start-Job -Name "FavoriteList" -ScriptBlock { 
                    Write-Host "Collecting Favorites Information...";
                    try { 
                        $FavoriteList = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/api/favorites/search" -Method Get;
                    }
                    catch {
						Write-Verbose -Verbose $_;
                    }
                    finally { }
                #};
                #Wait-Job -Name "FavoriteList";

                #Start-Job -Name "SCMAccounts" -ScriptBlock { 
                    Write-Host "Collecting SCM Accounts Information...";
                    try { 
                        $SCMAccounts = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/api/issues/authors" -Method Get;            
                    }
                    catch {
						Write-Verbose -Verbose $_;
                    }
                    finally { }
                #};
                #Wait-Job -Name "SCMAccounts";

                #Start-Job -Name "Issues" -ScriptBlock { 
                    Write-Host "Collecting Issues Information...";
                    try { 
                        $Issues = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/api/issues/search" -Method Get;
                    }
                    catch {
						Write-Verbose -Verbose $_;
                    }
                    finally { }
                #};
                #Wait-Job -Name "Issues";

                #Start-Job -Name "Tags" -ScriptBlock { 
                    Write-Host "Collecting Tags Information...";
                    try { 
                        $Tags = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/api/issues/tags" -Method Get;
                    }
                    catch {
						Write-Verbose -Verbose $_;
                    }
                    finally { }
                #};
                #Wait-Job -Name "Tags";

                #Start-Job -Name "LangList" -ScriptBlock { 
                    Write-Host "Collecting Language Information...";
                    try { 
                        $LangList = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/api/languages/list" -Method Get;
                    }
                    catch {
						Write-Verbose -Verbose $_;
                    }
                    finally { }
                #};
                #Wait-Job -Name "LangList";


# #api/measures/component
# #api/measures/component_tree
# #api/measures/search_history
# $Test = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/api/settings/list_definitions" -Method Get;

                #Start-Job -Name "CustomMetricsList" -ScriptBlock { 
                    Write-Host "Collecting Custom Metrics Information...";
                    try { 
                        $CustomMetricsList = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/api/metrics/domains" -Method Get;
                    }
                    catch {
						Write-Verbose -Verbose $_;
                    }
                    finally { }
                #};
                #Wait-Job -Name "CustomMetricsList";

                #Start-Job -Name "MetricsList" -ScriptBlock { 
                    Write-Host "Collecting Metrics Information...";
                    try { 
                        $MetricsList = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/api/metrics/search" -Method Get;
                    }
                    catch {
						Write-Verbose -Verbose $_;
                    }
                    finally { }
                #};
                #Wait-Job -Name "MetricsList";

                #Start-Job -Name "MetricsTypes" -ScriptBlock { 
                    Write-Host "Collecting Metrics Types Information...";
                    try { 
                        $MetricsTypes = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/api/metrics/types" -Method Get;
                    }
                    catch {
						Write-Verbose -Verbose $_;
                    }
                    finally { }
                #};
                #Wait-Job -Name "MetricsTypes";

                #Start-Job -Name "NotificationMethods" -ScriptBlock { 
                    Write-Host "Collecting Notification Methods Information...";
                    try { 
                        $NotificationMethods = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/api/notifications/list" -Method Get;
                    }
                    catch {
						Write-Verbose -Verbose $_;
                    }
                    finally { }
                #};
                #Wait-Job -Name "NotificationMethods";

                #Start-Job -Name "PermissionTemplates" -ScriptBlock { 
                    Write-Host "Collecting Permission template Information...";
                    try { 
                        $PermissionTemplates = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/api/permissions/search_templates" -Method Get;
                    }
                    catch {
						Write-Verbose -Verbose $_;
                    }
                    finally { }
                #};
                #Wait-Job -Name "PermissionTemplates";

                #Start-Job -Name "PluginInstalled" -ScriptBlock { 
                    Write-Host "Collecting Installed Plugins Information...";
                    try { 
                        $PluginInstalled = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/api/plugins/installed" -Method Get;
                    }
                    catch {
						Write-Verbose -Verbose $_;
                    }
                    finally { }
                #};
                #Wait-Job -Name "PluginInstalled";

                #Start-Job -Name "PluginRequireUpdated" -ScriptBlock { 
                    Write-Host "Collecting Installed Plugins Require Update Information...";
                    try { 
                        $PluginRequireUpdated = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/api/plugins/updates" -Method Get;
                    }
                    catch {
						Write-Verbose -Verbose $_;
                    }
                    finally { }
                #};
                #Wait-Job -Name "PluginRequireUpdated";

                #Start-Job -Name "ProjectList" -ScriptBlock { 
                    Write-Host "Collecting Project Information...";
                    try { 
                        $ProjectList = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/api/projects/search" -Method Get;
                    }
                    catch {
						Write-Verbose -Verbose $_;
                    }
                    finally { }
                #};
                #Wait-Job -Name "ProjectList";

                #Start-Job -Name "DefinitionList" -ScriptBlock { 
                    Write-Host "Collecting Definition Information...";
                    try { 
                        $DefinitionList = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/api/settings/list_definitions" -Method Get;
                    }
                    catch {
						Write-Verbose -Verbose $_;
                    }
                    finally { }
                #};
                #Wait-Job -Name "FeeDefinitionListds";

                #Start-Job -Name "SettingList" -ScriptBlock { 
                    Write-Host "Collecting Settings Information...";
                    try { 
                        $SettingList = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/api/settings/values" -Method Get;
                    }
                    catch {
						Write-Verbose -Verbose $_;
                    }
                    finally { }
                #};
                #Wait-Job -Name "SettingList";

                #Start-Job -Name "Feeds" -ScriptBlock { 
                    Write-Host "Collecting Database Migration Information...";
                    try { 
                        $SysDBMigration = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/api/system/db_migration_status" -Method Get;
                    }
                    catch {
						Write-Verbose -Verbose $_;
                    }
                    finally { }
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Feeds" -ScriptBlock { 
                    Write-Host "Collecting System Health Information...";
                    try { 
                        $SysHealth = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/api/system/health" -Method Get;
                    }
                    catch {
						Write-Verbose -Verbose $_;
                    }
                    finally { }
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "SysLogs" -ScriptBlock { 
                    Write-Host "Collecting System Logs Information...";
                    try { 
                        $SysLogs = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/api/system/logs" -Method Get;
                    }
                    catch {
						Write-Verbose -Verbose $_;
                    }
                    finally { }
                #};
                #Wait-Job -Name "SysLogs";

                #Start-Job -Name "SysStatus" -ScriptBlock { 
                    Write-Host "Collecting System Status Information...";
                    try { 
                        $SysStatus = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/api/system/status" -Method Get;
                    }
                    catch {
						Write-Verbose -Verbose $_;
                    }
                    finally { }
                #};
                #Wait-Job -Name "SysStatus";

                #Start-Job -Name "SysUpgrade" -ScriptBlock { 
                    Write-Host "Collecting System Upgrade Information...";
                    try { 
                        $SysUpgrade = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/api/system/upgrades" -Method Get;
                    }
                    catch {
						Write-Verbose -Verbose $_;
                    }
                    finally { }
                #};
                #Wait-Job -Name "SysUpgrade";

                #Start-Job -Name "Groups" -ScriptBlock { 
                    Write-Host "Collecting Groups Information...";
                    try { 
                        $Groups = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/api/system/upgrades" -Method Get;
                    }
                    catch {
						Write-Verbose -Verbose $_;
                    }
                    finally { }
                #};
                #Wait-Job -Name "Groups";

                #Start-Job -Name "User" -ScriptBlock { 
                    Write-Host "Collecting User Information...";
                    try { 
                        $User = Invoke-RestMethod -Headers ${header} -Uri "${SONARQUBEURI}/api/users/search" -Method Get;
                    }
                    catch {
						Write-Verbose -Verbose $_;
                    }
                    finally { }
                #};
                #Wait-Job -Name "User";


        #    }  #BEGIN
        
        #    PROCESS {

                #$SQVersion

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

                
                $htmlbody +=  $FavoriteList.favorites | 
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
                Write-Host "Processing Issues Information...";
                $subhead = "<h2>Issues</h2>";
                $htmlbody += ${subhead};
                    
                $htmlbody +=  $Issues.issues | 
                                ConvertTo-Html -Fragment;
                
                $htmlbody += ${SPACER};

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
                                        releaseDate,
                                        changeLogUrl,
                                        downloadUrl,
                                        @{
                                            name = "plugins"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.plugins.PSObject.Properties) {
                                                        "$($property.Name) - $($property.Value) "
                                                    }
                                                )
                                            }
                                        } |
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
                                        active,
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
                                        local,
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
				                <h1 align=""center"">Server Executed On: {0}</h1>
                                <h2 align=""center"">SonarQube Version: {1}</h2>
				                <h3 align=""center"">Generated: {2:HH:mm:ss}</h3>
                                <h3 align=""center"">Elapsed Time to Generate Report: {3:HH:mm:ss}</h3>" -f ( 
                                                                                                                $($env:COMPUTERNAME),
                                                                                                                $($SQVersion),
                                                                                                                $($reportime), 
                                                                                                                $($elapsedTime)
                                                                                                            );


                $htmltail = "</body>
		                </html>"

                $htmlreport = ${htmlhead} + ${htmlbody} + ${htmltail};
            
                #endregion ReportDetail
        
                Write-Verbose -Verbose ( "Total Duration: {0:HH:mm:ss}" -f ${elapsedTime} ) ;
		        Write-Verbose -Verbose "Generated File ${outputlocation}";
		        $htmlreport | Out-File ${outputlocation} -Encoding Utf8 -force;

            #} #End


#    } # GetSonarQubeReport

#endregion PublicFunction