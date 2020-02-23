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
	

.Example Providng API KEY
	OctopusAuditReport -OCTOPUSDomain "http://ABC123.com" -APIKEY "API-00000000000000";

.Example Providng API KEY - Change output directory
	OctopusAuditReport -OCTOPUSDomain "http://ABC123.com" -APIKEY "API-00000000000000" -outputlocation "$($env:USERPROFILE)\Downloads\OctopusAuditReport.html";



.Reference
	Octopus Swagger
    http://ABC123.com/octopus/swaggerui/index.html#/
	
#>

#region PrivateFunction

#endregion PrivateFunction


#region PublicFunction

    function OctopusAuditReport {
        param(
            [Parameter(Mandatory=$true)] [String] ${OCTOPUSDomain}
		    , [Parameter(Mandatory=$true)] [String] ${APIKEY}		
		    , [Parameter(Mandatory=$false)] [String] ${outputlocation} = "$($env:USERPROFILE)\Downloads\OctopusAuditReport.html"
            , [Parameter(Mandatory=$false)] [bool] $DebugMode = $false
            )

        clear;
    
        write-host "function being executed '$($MyInvocation.MyCommand)' ";
	
	

        #######################################################################################################
        # Constants
        #######################################################################################################
        [DateTime] $STARTTIME = get-date;            	        
        [String] $SPACER = "<br />";
        [String] $SpaceId = "Spaces-1";
        [String] $OCTOPUSURI = "${OCTOPUSDomain}/octopus/api/${SpaceId}/";
        [String] $OCTOPUSURINoSpace = "${OCTOPUSDomain}/octopus/api/";


        #################################################################################################
        ##   Variables
        #################################################################################################
        $header = @{ "X-Octopus-ApiKey" = ${APIKEY} };
        
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
            clear;
            #Start-Job -Name "Account" -ScriptBlock { 
                Write-Host "Collecting Accounts Information...";
                $Account = Invoke-RestMethod -Uri "${OCTOPUSURI}/accounts/all" -Headers ${header} -Method Get; 
            #};
            #Wait-Job -Name "Account";

            #Start-Job -Name "ActionTemplate" -ScriptBlock { 
                Write-Host "Collecting Action Template Information...";
                $ActionTemplates = Invoke-RestMethod -Uri "${OCTOPUSURI}/actiontemplates/all" -Headers ${header} -Method Get;
            #};
            #Wait-Job -Name "ActionTemplate";

            #Start-Job -Name "Channels" -ScriptBlock { 
                Write-Host "Collecting Channels Information...";
                $Channels = Invoke-RestMethod -Uri "${OCTOPUSURI}/channels/all" -Headers ${header} -Method Get;
            #};
            #Wait-Job -Name "Channels";

            #Start-Job -Name "CommunityActionTemplate" -ScriptBlock { 
                Write-Host "Collecting Community Action Template Information...";
                $CommunityActionTemplate = Invoke-RestMethod -Uri "${OCTOPUSURINoSpace}/communityactiontemplates" -Headers ${header} -Method Get;
            #};
            #Wait-Job -Name "CommunityActionTemplate";
            
            #Start-Job -Name "deployments" -ScriptBlock { 
                Write-Host "Collecting Deployment Information..";
                $deployments = Invoke-RestMethod -Uri "${OCTOPUSURI}/deployments" -Headers ${header} -Method Get;
            #};
            #Wait-Job -Name "deployments";

            #Start-Job -Name "Environments" -ScriptBlock {
                Write-Host "Collecting Environments Information...";
                $Environments = Invoke-RestMethod -Uri "${OCTOPUSURI}/environments/all" -Headers ${header} -Method Get;
            #};
            #Wait-Job -Name "Environments";

            #Start-Job -Name "Feeds" -ScriptBlock { 
                Write-Host "Collecting Feeds Information...";
                $Feeds = Invoke-RestMethod -Uri "${OCTOPUSURI}/feeds/all" -Headers ${header} -Method Get;
            #};
            #Wait-Job -Name "Feeds";

            #Start-Job -Name "Interruptions" -ScriptBlock { 
                Write-Host "Collecting Interruptions Information...";
                $Interruptions = Invoke-RestMethod -Uri "${OCTOPUSURI}/interruptions" -Headers ${header} -Method Get;
            #};
            #Wait-Job -Name "Interruptions";

            #Start-Job -Name "LifeCycles" -ScriptBlock { 
                Write-Host "Collecting Life Cycle Information...";
                $LifeCycles = Invoke-RestMethod -Uri "${OCTOPUSURI}/lifecycles/all" -Headers ${header} -Method Get;
            #};
            #Wait-Job -Name "LifeCycles";

            #Start-Job -Name "LibraryVarablesSets" -ScriptBlock { 
                Write-Host "Collecting Library Variable Sets Information...";
                $LibraryVariableSets = Invoke-RestMethod -Uri "${OCTOPUSURI}/libraryvariablesets/all" -Headers ${header} -Method Get;
            #};
            #Wait-Job -Name "LibraryVarablesSets";

            #Start-Job -name "Machines" -ScriptBlock { 
                Write-Host "Collecting Machines Information...";
                $Machines = Invoke-RestMethod -Uri "${OCTOPUSURI}/machines/all" -Headers ${header} -Method Get;
            #};
            #Wait-Job -Name "Machines";

            #Start-Job -Name "MachinePolicies" -ScriptBlock { 
                Write-Host "Collecting Machines Policies Information...";
                $MachinePolicies = Invoke-RestMethod -Uri "${OCTOPUSURI}/machinepolicies/all" -Headers ${header} -Method Get;
            #};
            #Wait-Job -Name "MachinePolicies";

            #Start-Job -Name "MachineRoles" -ScriptBlock { 
                Write-Host "Collecting Machines Policies Information...";
                $MachineRoles = Invoke-RestMethod -Uri "${OCTOPUSURI}/machineroles/all" -Headers ${header} -Method Get;
            #};
            #Wait-Job -Name "MachineRoles";

            #Start-Job -Name "Project" -ScriptBlock { 
                Write-Host "Collecting Projects Information...";
                $Projects = Invoke-RestMethod -Uri "${OCTOPUSURI}/projects/all" -Headers ${header} -Method Get;
            #};
            #Wait-Job -Name "Project";

            #Start-Job -Name "ProjectGroup" -ScriptBlock { 
                Write-Host "Collecting Project Groups Information...";
                $ProjectGroups = Invoke-RestMethod -Uri "${OCTOPUSURI}/projectgroups/all" -Headers ${header} -Method Get;
            #};
            #Wait-Job -Name "ProjectGroup"

            #Start-Job -Name "Proxies" -ScriptBlock { 
                Write-Host "Collecting Proxy Information...";
                $Proxies = Invoke-RestMethod -Uri "${OCTOPUSURI}/proxies/all" -Headers ${header} -Method Get;
            #};
            #Wait-Job -Name "Proxies";

            #Start-Job -Name "Release" -ScriptBlock { 
                Write-Host "Collecting Release Information...";
                $Release = Invoke-RestMethod -Uri "${OCTOPUSURI}/releases" -Headers ${header} -Method Get;
            #} ;
            #Wait-Job -Name "Release";

            #Start-Job -Name "Scheduler" -ScriptBlock { 
                Write-Host "Collecting SMTP Information...";
                $Scheduler = Invoke-RestMethod -Uri "${OCTOPUSURINoSpace}/scheduler" -Headers ${header} -Method Get;
            #} ;
            #Wait-Job -Name "Scheduler";

            #Start-Job -Name "SMTPConfig" -ScriptBlock { 
                Write-Host "Collecting SMTP Information...";
                $SMTPConfig = Invoke-RestMethod -Uri "${OCTOPUSURINoSpace}/smtpconfiguration" -Headers ${header} -Method Get;
            #} ;
            #Wait-Job -Name "SMTPConfig";

            #Start-Job -Name "Spaces" -ScriptBlock { 
                Write-Host "Collecting SMTP Information...";
                $Spaces = Invoke-RestMethod -Uri "${OCTOPUSURINoSpace}/spaces" -Headers ${header} -Method Get;
            #} ;
            #Wait-Job -Name "Spaces";

            #Start-Job -Name "Tags" -ScriptBlock { 
                Write-Host "Collecting Tags Information...";
                $Tags = Invoke-RestMethod -Uri "${OCTOPUSURI}/tagsets/all" -Headers ${header} -Method Get;
            #};
            #Wait-Job -Name "Tags";

            #Start-Job -Name "Tasks" -ScriptBlock { 
                Write-Host "Collecting Tasks Information...";
                $Tasks = Invoke-RestMethod -Uri "${OCTOPUSURI}/tasks" -Headers ${header} -Method Get;
            #};
            #Wait-Job -Name "Tasks";

            #Start-Job -Name "Teams" -ScriptBlock { 
                Write-Host "Collecting Teams Information...";
                $teams = Invoke-RestMethod -Uri "${OCTOPUSURINoSpace}/teams" -Headers ${header} -Method Get;
            #};
            #Wait-Job -Name "Teams";

            #Start-Job -Name "Tenants" -ScriptBlock { 
                Write-Host "Collecting Tenants Information...";
                $Tenants = Invoke-RestMethod -Uri "${OCTOPUSURI}/tenants/all" -Headers ${header} -Method Get;
            #};
            #Wait-Job -Name "Tenants";

            #Start-Job -Name "User" -ScriptBlock {
                Write-Host "Collecting User Information...";
                $User = Invoke-RestMethod -Uri "${OCTOPUSURINoSpace}/users/all" -Headers ${header} -Method Get;
            #};
            #Wait-Job -Name "User";

            #Start-Job -Name "UserRole" -ScriptBlock { 
                Write-Host "Collecting User Roles Information...";
                $UserRole = Invoke-RestMethod -Uri "${OCTOPUSURINoSpace}/userroles/all" -Headers ${header} -Method Get;
            #};
            #Wait-Job -Name "UserRole";


        #}  #BEGIN
        
        #PROCESS {

                #---------------------------------------------------------------------
                # Getting all the Deployment Process on this Octopus instance and convert to HTML fragment
                #---------------------------------------------------------------------
                #region Deployment
                Write-Host "Processing Feeds Information...";
                $subhead = "<h3>Deployment Feeds Information - Count: $($Feeds.Count)</h3>";
                $htmlbody += ${subhead};
                
                $htmlbody +=  $Feeds | 
                                select  ID,
                                        Name,
                                        FeedType,
                                        FeedURI,
                                        UserName,
                                        @{
                                            name = "Password"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Password.PSObject.Properties) {
                                                        "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                    }
                                                )
                                            }
                                        },
                                        DownloadAttempts,
                                        DownloadRetryBackoffSeconds,
                                        @{
                                            name = "PackageAcquisitionLocationOption"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.PackageAcquisitionLocationOption.PSObject.Properties) {
                                                        "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "Links"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Links.PSObject.Properties) {
                                                        "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                    }
                                                )
                                            }
                                        },
                                        LastModifiedOn,
                                        LastModifiedBy |
                                Sort Name |
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                #endregion Deployment

                #---------------------------------------------------------------------
                # Getting all Accounts on this Octopus instance and convert to HTML fragment
                #---------------------------------------------------------------------    
                #region AccountsProcessing
                Write-Host "Processing Accounts Information...";
                $subhead = "<h3>Deployment Accounts Information - Count: $($Account.Count)</h3>";
                $htmlbody += ${subhead};
                
                $htmlbody +=  $Account |
                                Sort Name |
                                Select   Id,
                                            Name,
                                            UserName,
                                            AccountType,
                                            @{
                                                name = "EnvironmentIds"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.EnvironmentIds.PSObject.Properties) {
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                        }
                                                    )
                                                }
                                            },
                                            Description,
                                            @{
                                                name = "PrivateKeyFile"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.PrivateKeyFile.PSObject.Properties) {
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "PrivateKeyPassphrase"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.PrivateKeyPassphrase.PSObject.Properties) {
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                        }
                                                    )
                                                }
                                            },
                                            TenantedDeploymentParticipation,                                        
                                            @{
                                                name = "TenantIds"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.TenantIds.PSObject.Properties) {
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "TenantTags"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.TenantTags.PSObject.Properties) {
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                        }
                                                    )
                                                }
                                            },
                                            LastModifiedOn,
                                            LastModifiedBy |                            
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                #endregion Accounts
 
                #---------------------------------------------------------------------
                # Getting all the User Roles on this Octopus instance and convert to HTML fragment
                #---------------------------------------------------------------------
                #region UserRoles
                
                Write-Host "Processing User Roles information...";
                $subhead = "<h3>User Roles Information - Count: $($UserRole.Count)</h3>";
                $htmlbody += ${subhead};
    
                $htmlbody += $UserRole | 
                                Sort Name |
                                Select   ID,
                                            Name,
                                            Description,
                                            SupportedRestrictions,
                                            @{
                                                name = "Permission Descriptions"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.PermissionDescriptions.PSObject.Properties) {
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "Granted Permissions"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.GrantedPermissions.PSObject.Properties) {
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                        }
                                                    )
                                                }
                                            },
                                            CanBeDeleted,
                                            @{
                                                name = "Links"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.Links.PSObject.Properties) {
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                        }
                                                    )
                                                }
                                            } |
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                #endregion UserRoles

                #---------------------------------------------------------------------
                # Getting all the users on this Octopus instance and convert to HTML fragment
                #---------------------------------------------------------------------
                #region Users
                Write-Host "Processing Users information...";
                $subhead = "<h3>User Information - Count: $($User.Count)</h3>";
                $htmlbody += ${subhead};
    
                $htmlbody += ${User} | 
                                Sort DisplayName |
                                select  ID,
                                        UserName,
                                        DisplayName,
                                        EmailAddress,
                                        Password,    
                                        CanPasswordBeEdited,
                                        IsActive,
                                        IsService,
                                        IsRequestor,
                                        @{
                                            name = "Identities"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Identities.PSObject.Properties) {
                                                        "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "Links"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Links.PSObject.Properties) {
                                                        "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                    }
                                                )
                                            }
                                        } |                            
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};     

                #endregion Users

                #---------------------------------------------------------------------
                # Getting all the users on this Octopus instance and convert to HTML fragment
                #---------------------------------------------------------------------
                #region UsersPermissions
                Write-Host "Processing User Permissions...";
                Foreach (
                            $userItem in  ${User} | 
                                Select  Id, 
                                        UserName, 
                                        DisplayName | 
                                Sort DisplayName 
                        ) 
                {

                    Write-Host "Processing '$( $userItem.DisplayName )' User Permissions...  ";
                    $UserPermission = Invoke-RestMethod -Uri "${OCTOPUSURINoSpace}/users/$($userItem.id)/permissions" -Headers ${header} -Method Get;

                    $subhead = "<h3>User Permission - $( $userItem.DisplayName ) </h3>";
                    $htmlbody += ${subhead};
                                
                        #region SpacePermissions
                        Write-Host "Processing User Space Permissions... $( $userItem.DisplayName ) ";
                        $subhead = "<h4>User Space Permission</h4>";
                        $htmlbody += ${subhead};

                        $htmlbody += $UserPermission.SpacePermissions | 
                                                Select  @{
                                                            name = "Account Create"
                                                            Expression = {
                                                                    $item = $_.AccountCreate.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Account Delete"
                                                             Expression = {
                                                                    $item = $_.AccountDelete.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Account Edit"
                                                            Expression = {
                                                                    $item = $_.AccountEdit.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Account View"
                                                            Expression = {
                                                                    $item = $_.AccountView.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Account Template Create"
                                                            Expression = {
                                                                    $item = $_.ActionTemplateCreate.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Account Template Delete"
                                                            Expression = {
                                                                    $item = $_.ActionTemplateDelete.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Account Template Edit"
                                                            Expression = {
                                                                    $item = $_.ActionTemplateEdit.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Account Template View"
                                                            Expression = {
                                                                    $item = $_.ActionTemplateView.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Artifact Create"
                                                            Expression = {
                                                                    $item = $_.ArtifactCreate.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Artifact Delete"
                                                            Expression = {
                                                                    $item = $_.ArtifactDelete.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression

                                                        },
                                                        @{
                                                            name = "Artifact Edit"
                                                            Expression = {
                                                                    $item = $_.ArtifactEdit.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression

                                                        },
                                                        @{
                                                            name = "Artifact View"
                                                            Expression = {
                                                                    $item = $_.ArtifactView.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression

                                                        },
                                                        @{
                                                            name = "BuiltIn Feed Administer"
                                                            Expression = {
                                                                    $item = $_.BuiltInFeedAdminister.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "BuiltIn Feed Download"
                                                            Expression = {
                                                                    $item = $_.BuiltInFeedDownload.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "BuiltIn Feed Push"
                                                            Expression = {
                                                                    $item = $_.BuiltInFeedPush.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Certificate Create"
                                                            Expression = {
                                                                    $item = $_.CertificateCreate.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Certificate Delete"
                                                            Expression = {
                                                                    $item = $_.CertificateDelete.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Certificate Edit"
                                                            Expression = {
                                                                    $item = $_.CertificateEdit.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Certificate Export Private Key"
                                                            Expression = {
                                                                    $item = $_.CertificateExportPrivateKey.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Certificate View"
                                                            Expression = {
                                                                    $item = $_.CertificateView.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Defect Report"
                                                            Expression = {
                                                                    $item = $_.DefectReport.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Defect Resolve"
                                                            Expression = {
                                                                    $item = $_.DefectResolve.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Deployment Create"
                                                            Expression = {
                                                                    $item = $_.DeploymentCreate.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Deployment Delete"
                                                            Expression = {
                                                                    $item = $_.DeploymentDelete.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Deployment View"
                                                            Expression = {
                                                                    $item = $_.DeploymentView.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Environment Create"
                                                            Expression = {
                                                                    $item = $_.EnvironmentCreate.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Environment Delete"
                                                            Expression = {
                                                                    $item = $_.EnvironmentDelete.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Environment Edit"
                                                            Expression = {
                                                                    $item = $_.EnvironmentEdit.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Environment View"
                                                            Expression = {
                                                                    $item = $_.EnvironmentView.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Equals"
                                                            Expression = {
                                                                    $item = $_.Equals.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Event View"
                                                            Expression = {
                                                                    $item = $_.EventView.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Feed Edit"
                                                            Expression = {
                                                                    $item = $_.FeedEdit.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Feed View"
                                                            Expression = {
                                                                    $item = $_.FeedView.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Get Hash Code"
                                                            Expression = {
                                                                    $item = $_.GetHashCode.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Get Type"
                                                            Expression = {
                                                                    $item = $_.GetType.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Interruption Submit"
                                                            Expression = {
                                                                    $item = $_.InterruptionSubmit.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Interruption View"
                                                            Expression = {
                                                                    $item = $_.InterruptionView.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Interruption View Submit Responsible"
                                                            Expression = {
                                                                    $item = $_.InterruptionViewSubmitResponsible.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Library Variable Set Create"
                                                            Expression = {
                                                                    $item = $_.LibraryVariableSetCreate.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Library Variable Set Delete"
                                                            Expression = {
                                                                    $item = $_.LibraryVariableSetDelete.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        }, 
                                                        @{
                                                            name = "Library Variable Set Edit"
                                                            Expression = {
                                                                    $item = $_.LibraryVariableSetEdit.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Library Variable Set View"
                                                            Expression = {
                                                                    $item = $_.LibraryVariableSetView.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Lifecycle Create"
                                                            Expression = {
                                                                    $item = $_.LifecycleCreate.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Lifecycle Delete"
                                                            Expression = {
                                                                    $item = $_.LifecycleDelete.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Lifecycle Edit"
                                                            Expression = {
                                                                    $item = $_.LifecycleEdit.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Lifecycle View"
                                                            Expression = {
                                                                    $item = $_.LifecycleView.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Machine Create"
                                                            Expression = {
                                                                    $item = $_.MachineCreate.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Machine Delete"
                                                            Expression = {
                                                                    $item = $_.MachineDelete.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Machine Edit"
                                                            Expression = {
                                                                    $item = $_.MachineEdit.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Machine Policy Create"
                                                            Expression = {
                                                                    $item = $_.MachinePolicyCreate.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Machine Policy Delete"
                                                            Expression = {
                                                                    $item = $_.MachinePolicyDelete.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Machine Policy Edit"
                                                            Expression = {
                                                                    $item = $_.MachinePolicyEdit.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Machine Policy View"
                                                            Expression = {
                                                                    $item = $_.MachinePolicyView.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Machine View"
                                                            Expression = {
                                                                    $item = $_.MachineView.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Package Metadata Push"
                                                            Expression = {
                                                                    $item = $_.PackageMetadataPush.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Process Edit"
                                                            Expression = {
                                                                    $item = $_.ProcessEdit.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Process View"
                                                            Expression = {
                                                                    $item = $_.ProcessView.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "ProjectCreate"
                                                            Expression = {
                                                                    $item = $_.ProjectCreate.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Project Delete"
                                                            Expression = {
                                                                    $item = $_.ProjectDelete.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Project Edit"
                                                            Expression = {
                                                                    $item = $_.ProjectEdit.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Project Group Create"
                                                            Expression = {
                                                                    $item = $_.ProjectGroupCreate.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Project Group Delete"
                                                            Expression = {
                                                                    $item = $_.ProjectGroupDelete.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Project Group Edit"
                                                            Expression = {
                                                                    $item = $_.ProjectGroupEdit.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Project Group View"
                                                            Expression = {
                                                                    $item = $_.ProjectGroupView.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Project View"
                                                            Expression = {
                                                                    $item = $_.ProjectView.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Proxy Create"
                                                            Expression = {
                                                                    $item = $_.ProxyCreate.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Proxy Delete"
                                                            Expression = {
                                                                    $item = $_.ProxyDelete.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Proxy Edit"
                                                            Expression = {
                                                                    $item = $_.ProxyEdit.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Proxy View"
                                                            Expression = {
                                                                    $item = $_.ProxyView.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Release Create"
                                                            Expression = {
                                                                    $item = $_.ReleaseCreate.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Release Delete"
                                                            Expression = {
                                                                    $item = $_.ReleaseDelete.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Release Edit"
                                                            Expression = {
                                                                    $item = $_.ReleaseEdit.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Release View"
                                                            Expression = {
                                                                    $item = $_.ReleaseView.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Subscription Create"
                                                            Expression = {
                                                                    $item = $_.SubscriptionCreate.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Subscription Delete"
                                                            Expression = {
                                                                    $item = $_.SubscriptionDelete.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Subscription Edit"
                                                            Expression = {
                                                                    $item = $_.SubscriptionEdit.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Subscription View"
                                                            Expression = {
                                                                    $item = $_.SubscriptionView.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "TagSet Create"
                                                            Expression = {
                                                                    $item = $_.TagSetCreate.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Tagset Delete"
                                                            Expression = {
                                                                    $item = $_.TagsetDelete.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Tagset Edit"
                                                            Expression = {
                                                                    $item = $_.TagsetEdit.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Task Cancel"
                                                            Expression = {
                                                                    $item = $_.TaskCancel.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Task Create"
                                                            Expression = {
                                                                    $item = $_.TaskCreate.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Task Edit"
                                                            Expression = {
                                                                    $item = $_.TasakEdit.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Task View"
                                                            Expression = {
                                                                    $item = $_.TaskView.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "TeamCreate"
                                                            Expression = {
                                                                    $item = $_.TeamCreate.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Team Delete"
                                                             Expression = {
                                                                    $item = $_.TeamDelete.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Team Edit"
                                                            Expression = {
                                                                    $item = $_.TeamEdit.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Team View"
                                                            Expression = {
                                                                    $item = $_.TeamView.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Tenant Create"
                                                            Expression = {
                                                                    $item = $_.TenantCreate.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Tenant Delete"
                                                            Expression = {
                                                                    $item = $_.TenantDelete.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Tenant Edit"
                                                            Expression = {
                                                                    $item = $_.TenantEdit.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Tenant View"
                                                            Expression = {
                                                                    $item = $_.TenantView.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "ToString"
                                                            Expression = {
                                                                    $item = $_.ToString.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Trigger Create"
                                                            Expression = {
                                                                    $item = $_.TriggerCreate.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Trigger Delete"
                                                            Expression = {
                                                                    $item = $_.TriggerDelete.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Trigger Edit"
                                                            Expression = {
                                                                    $item = $_.TriggerEdit.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Trigger View"
                                                            Expression = {
                                                                    $item = $_.TriggerView.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Variable Edit"
                                                            Expression = {
                                                                    $item = $_.VariableEdit.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Variable Edit Unscoped"
                                                            Expression = {
                                                                    $item = $_.VariableEditUnscoped.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Variable View "
                                                            Expression = {
                                                                    $item = $_.VariableView.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Variable View Unscoped"
                                                            Expression = {
                                                                    $item = $_.VariableViewUnscoped.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Worker Edit"
                                                            Expression = {
                                                                    $item = $_.WorkerEdit.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        },
                                                        @{
                                                            name = "Worker View"
                                                            Expression = {
                                                                    $item = $_.WorkerView.PSObject.Properties;
                                                                    if ( $item.Name -eq "SyncRoot" ) {
                                                                        $item = $( $item | ? { $_.Name -eq "SyncRoot" } ).value;

                                                                        "Restricted To Environments: $( $( $Environments | ? { $_.id -in $item.RestrictedToEnvironmentIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Tenants: $( $( $Tenants | ? { $_.id -in $item.RestrictedToTenantIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Project Groups: $( $( $ProjectGroups | ? { $_.id -in $item.RestrictedToProjectGroupIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Projects: $( $( $Projects | ? { $_.id -in $item.RestrictedToProjectIds } | select Name ).name | Sort Name ) | ";

                                                                        "Restricted To Spaces: $( $( $Spaces.Items | ? { $_.id -in $item.SpaceId } | select Name ).name | Sort Name ) | ";
                                                                    }
                                                                    else {
                                                                        "$($item.Name): $($item.Value) | ";
                                                                    }
                                                            } # Expression
                                                        } |
                                    ConvertTo-Html -Fragment;
                        $htmlbody += ${SPACER};

                        #endregion SpacePermissions

                        #region UserTeamsPermission
                        Write-Host "Processing '$( $userItem.DisplayName )' Team Permissions... ";

                        $subhead = "<h4>User Team Permission</h4>";
                        $htmlbody += ${subhead};

                        $htmlbody += $UserPermission.Teams | 
                                            Select  Id,
                                                    Name,
                                                    IsDirectlyAssigned,
                                                    @{
                                                        name = "External Group Names"
                                                        Expression = {
                                                            $(
                                                                Foreach ($property in $_.ExternalGroupNames.PSObject.Properties) {
                                                                    "$($property.Name): $($property.Value) | ";
                                                                }
                                                            )
                                                        }
                                                    },
                                                    SpaceId,
                                                    @{
                                                        name = "Space Names"
                                                        Expression = {
                                                            $temp = $_.SpaceId
                                                            "$( $( $Spaces.Items | ? { $_.id -in $temp } | select Name ).name | Sort Name ) | ";
                                                        }
                                                    } |
                                            Sort Name | 
                                            ConvertTo-Html -Fragment;
                        $htmlbody += ${SPACER};
                        #endregion UserTeamsPermission

                        #region SystemPermissions
                        $subhead = "<h4>User System Permission </h4>";
                        $htmlbody += ${subhead};

                        $htmlbody += $UserPermission.SystemPermissions | 
                                    Select  @{ 
                                                Name='Name'; 
                                                Expression = {
                                                    $_;
                                                }
                                            } | 
                                    Sort Name |
                                    ConvertTo-Html -Fragment;
                        $htmlbody += ${SPACER};

                        #endregion SystemPermissions

                    } # foreach userItem


                #endregion UsersPermissions

                #---------------------------------------------------------------------
                # Getting all the Teams on this Octopus instance and convert to HTML fragment
                #---------------------------------------------------------------------
                #region Teams
                Write-Host "Processing Teams information...";

                $subhead = "<h3>Team Information - Count: $($teams.TotalResults)</h3>";
                $htmlbody += ${subhead};

                $htmlbody += $teams.Items | 
                                select  ID,
                                        Name,
                                        @{
                                            name = "Member UserIds"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.MemberUserIds.PSObject.Properties) {
                                                        if ($($property.Name) -eq "SyncRoot") {
                                                            $temp = $($property.Value);
                                                            foreach ( $i in $($property.Value).Split(" ") ) {
                                                                $temp = $i.Trim();
                                                                "$( $( $User | ? { $_.id -contains $temp } | select DisplayName ).DisplayName ) | ";
                                                            }
                                                        }
                                                        else {
                                                            "$($property.Name): $($property.Value) | ";
                                                        }
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "External Security Groups"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.ExternalSecurityGroups.PSObject.Properties) {
                                                        "$($property.Name): $($property.Value) | ";
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "Tenant Tags"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.TenantTags.PSObject.Properties) {
                                                        "$($property.Name): $($property.Value) | ";
                                                    }
                                                )
                                            }
                                        },
                                        CanBeDeleted,
                                        CanBeRenamed,
                                        CanChangeRoles,
                                        CanChangeMembers,
                                        @{
                                                name = "Links"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.Links.PSObject.Properties) {
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                        }
                                                    )
                                                }
                                            } |
                                Sort Name |    
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                #endregion Teams

                #---------------------------------------------------------------------
                # All Users and Roles
                #     https://github.com/OctopusDeploy/OctopusDeploy-Api/blob/master/REST/PowerShell/Users/FindUsersWithUserRole.ps1
                #---------------------------------------------------------------------
                #region TeamsRoleUserMap
                # Loop through teams

                Write-Host "Processing Roles and User Mapping Information...";
                $subhead = "<h3>Role and User Mapping</h3>";
                $htmlbody += ${subhead};

                foreach ( ${itemUserRole} in ${UserRole} ) 
                {
                    $subhead = "<h4>Role : $($itemUserRole.Name)</h4>";
                    $htmlbody += ${subhead};
                    $tempHTML = "";

                    foreach ( ${itemTeam} in ${teams}.items.Links | Where-Object -Property "ScopedUserRoles" | select -First 1)
                    {
                    
                        # Get the scoped user role
    #write-host "$OCTOPUSDomain/$($itemTeam.Self)/scopeduserroles"
                        ${scopedUserRole} = Invoke-RestMethod -Method Get -Uri ( "$OCTOPUSDomain/$($itemTeam.Self)/scopeduserroles" ) -Headers $header;
                    
                        $tempHTML += ${scopedUserRole}.Items 
                                            #? { $_.UserRoleId -eq $( ${itemUserRole}.Name ) }
                    $htmlbody += $tempHTML | 
                                    SELECT  ID, 
                                            UserRoleID, 
                                            TeamId, 
                                            ProjectIds, 
                                            @{
                                                name = "Project name"
                                                Expression = {
                                                    $temp = $_.ProjectIds;
                                                    "$( $( $Projects | ? { $_.id -eq $temp } | Select name ).Name )";
                                                }
                                            },
                                            EnvironmentIds, 
                                            @{
                                                name = "Environment name"
                                                Expression = {
                                                    $temp = $_.EnvironmentIds;
                                                    "$( $( $Environments | ? { $_.id -eq $temp } | Select name ).Name )";
                                                }
                                            },
                                            TenantIds,
                                            @{
                                                name = "Tenant name"
                                                Expression = {
                                                    $temp = $_.TenantIds;
                                                    "$( $( $Tenants  | ? { $_.id -eq $temp } | Select name ).Name )";
                                                }
                                            },
                                            ProjectGroupIds, 
                                            @{
                                                name = "Project Group name"
                                                Expression = {
                                                    $temp = $_.ProjectGroupIds;
                                                    "$( $( $ProjectGroups  | ? { $_.id -eq $temp } | Select name ).Name )";
                                                }
                                            },
                                            SpaceID, 
                                            @{
                                                name = "Space name"
                                                Expression = {
                                                    $temp = $_.SpaceID;
                                                    "$( $( $Spaces.items  | ? { $_.id -eq $temp } | Select name ).Name )";

                                                }
                                            },
                                            @{
                                                name = "Links"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.Links.PSObject.Properties) {
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                        }
                                                    )
                                                }
                                            } | 
                                    ConvertTo-Html -Fragment;
        
                    } # foreach $itemTeam

                   # $htmlbody += $tempHTML | 
                   #                 SELECT  ID, 
                   #                         UserRoleID, 
                   #                         TeamId, 
                   #                         ProjectIds, 
                   #                         @{
                   #                             name = "Project name"
                   #                             Expression = {
                   #                                 $temp = $_.ProjectIds;
                   #                                 "$( $( $Projects | ? { $_.id -eq $temp } | Select name ).Name )";
                   #                             }
                   #                         },
                   #                         EnvironmentIds, 
                   #                         @{
                   #                             name = "Environment name"
                   #                             Expression = {
                   #                                 $temp = $_.EnvironmentIds;
                   #                                 "$( $( $Environments | ? { $_.id -eq $temp } | Select name ).Name )";
                   #                             }
                   #                         },
                   #                         TenantIds,
                   #                         @{
                   #                             name = "Tenant name"
                   #                             Expression = {
                   #                                 $temp = $_.TenantIds;
                   #                                 "$( $( $Tenants  | ? { $_.id -eq $temp } | Select name ).Name )";
                   #                             }
                   #                         },
                   #                         ProjectGroupIds, 
                   #                         @{
                   #                             name = "Project Group name"
                   #                             Expression = {
                   #                                 $temp = $_.ProjectGroupIds;
                   #                                 "$( $( $ProjectGroups  | ? { $_.id -eq $temp } | Select name ).Name )";
                   #                             }
                   #                         },
                   #                         SpaceID, 
                   #                         @{
                   #                             name = "Space name"
                   #                             Expression = {
                   #                                 $temp = $_.SpaceID;
                   #                                 "$( $( $Spaces.items  | ? { $_.id -eq $temp } | Select name ).Name )";
                   #
                   #                             }
                   #                         },
                   #                         @{
                   #                             name = "Links"
                   #                             Expression = {
                   #                                 $(
                   #                                     Foreach ($property in $_.Links.PSObject.Properties) {
                   #                                         "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                   #                                     }
                   #                                 )
                   #                             }
                   #                         } | 
                   #                 ConvertTo-Html -Fragment;
                   #
                    $htmlbody += ${SPACER};

                }  # ${itemUserRole}





                #endregion TeamsRoleUserMap

                #---------------------------------------------------------------------
                # Getting all Deployments on this Octopus instance and convert to HTML fragment
                #---------------------------------------------------------------------
                #region Enviroment
                
                Write-Host "Processing Enviroments Information...";
                $subhead = "<h3>Enviroments Information - Count: $($Environments.Count)</h3>";
                $htmlbody += ${subhead};

                $htmlbody += $Environments | 
                                Select  ID,
                                        Name,
                                        Description,
                                        SortOrder,
                                        UseGuidedFailure,
                                        AllowDynamticInfrastructure,
                                        @{
                                            name = "Links"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Links.PSObject.Properties) {
                                                        "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                    }
                                                )
                                            }
                                        } |
                                Sort Name | 
                                ConvertTo-Html -Fragment;


                $htmlbody += ${SPACER};

                #endregion Enviroment

                #---------------------------------------------------------------------
                # Getting all Machines/Tenticles for this Octopus instance and convert to HTML fragment
                #---------------------------------------------------------------------
                #region Machines
                Write-Host "Processing Tenticle Machine Information...";
                $subhead = "<h3>Tenticle Machine Information - Count: $($Machines.Count)</h3>";
                $htmlbody += ${subhead};

                $htmlbody += $Machines |
                                    Select  ID,
                                            Name,
                                            @{
                                                name = "EnvironmentIds"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.EnvironmentIds.PSObject.Properties) {
                                                            switch ( $( $property.name ) ) {
                                                                "SyncRoot" {
                                                                    $(
                                                                        foreach ($item in $property.Value ) {
                                                                            "$( $( $Environments | ? { $_.Id -eq $item.trim() } | Select Name ).Name ) |"
                                                                        }
                                                                    )
                                                                }

                                                                default {
                                                                    "$($property.Name) : $($property.Value) | ";
                                                                }
                                                            } # switch property.name
                                                        
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "Roles"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.Roles.PSObject.Properties) {
                                                            "$($property.Name) : $($property.Value) | ";
                                                        }
                                                    )
                                                }
                                            },
                                            TenantedDeploymentParticipation,
                                            @{
                                                name = "TenantIds"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.TenantIds.PSObject.Properties) {
                                                            switch ( $( $property.name ) ) {
                                                                "SyncRoot" {
                                                                    $(
                                                                        foreach ($item in $property.Value ) {
                                                                            "$( $( $Tenants | ? { $_.Id -eq $item.trim() } | Select Name ).Name ) |"
                                                                        }
                                                                    )
                                                                }
                                                                default {
                                                                    "$($property.Name) : $($property.Value) | ";
                                                                }
                                                            } # switch property.name
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "TenantTags"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.TenantTags.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) | ";
                                                        }
                                                    )
                                                }
                                            },
                                            Thumbprint,
                                            Uri,
                                            IsDisabled,
                                            MachinePolicyId,
                                            @{
                                                name = "Machine Policy Name"
                                                Expression = {
                                                    $temp = $_.MachinePolicyId;
                                                    "$( $( ${MachinePolicies} | ? { $_.id -eq $temp } | select Name ).Name )";

                                                }
                                            }, 
                                            Status,
                                            HealthStatus,
                                            HasLatestCalamari,
                                            StatusSummary,
                                            IsInProcess,
                                            @{
                                                name = "Endpoint"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.Endpoint.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) | ";
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "Links"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.Links.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) | ";
                                                        }
                                                    )
                                                }
                                            } |
                                    Sort Name |
                                    ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};
 
                #endregion Machines

                #---------------------------------------------------------------------
                # Getting all Machines Roles for this Octopus instance and convert to HTML fragment
                #---------------------------------------------------------------------
                #region MachineRoles

                #######################################################################################
                # This Section Exists in OctopusVariableReport.ps1
                #######################################################################################
                Write-Host "Processing Machine Roles Information...";
                $subhead = "<h3>Machine Roles</h3>";
                $htmlbody += ${subhead};

                $htmlbody += $MachineRoles | 
                                Select  @{ 
                                            Name='Name'; 
                                            Expression = {
                                                $_;
                                            }
                                        } |
                                Sort Name |
                                ConvertTo-Html -Fragment;

                #endregion MachineRoles
 
                #---------------------------------------------------------------------
                # Getting all Project Groups for this Octopus instance and convert to HTML fragment
                #---------------------------------------------------------------------
                #region ProjectGroup

                #######################################################################################
                # This Section Exists in OctopusVariableReport.ps1
                #######################################################################################


                Write-Host "Processing Project Group Information...";
                $subhead = "<h3>Group Information - Count: $($ProjectGroups.Count)</h3>";
                $htmlbody += ${subhead};

                $htmlbody += $ProjectGroups |
                                    Select  ID,
                                            Name,
                                            Description,
                                            @{
                                                name = "EnvironmentIds"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.EnvironmentIds.PSObject.Properties) {
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                        }
                                                    )
                                                }
                                            },
                                            RetentionPolicyId,
                                            @{
                                                name = "Links"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.Links.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) | ";
                                                        }
                                                    )
                                                }
                                            } |
                                    Sort Name | 
                                    ConvertTo-Html -Fragment;
                $htmlbody += ${SPACER};

                #endregion ProjectGroup

                #---------------------------------------------------------------------
                # Getting all Projects for this Octopus instance and convert to HTML fragment
                #---------------------------------------------------------------------
                #region Projects

                #######################################################################################
                # This Section Exists in OctopusVariableReport.ps1
                #######################################################################################
                Write-Host "Processing Projects Information...";
                $subhead = "<h3>Project Information - Count: $($Projects.Count)</h3>";
                $htmlbody += ${subhead};
          
                $htmlbody += $Projects |
                                    Select  Id,
                                            VariableSetId,
                                            #@{
                                            #    name = "VariableSet Name"
                                            #    Expression = {
                                            #        $temp = $_.VariableSetId;
                                            #        $temp = Invoke-RestMethod -Method Get -Uri ( "$OCTOPUSURI/variables/$($temp)" ) -Headers $header;
                                            #    }
                                            #}, 
                                            DeploymentProcessId,   
                                            #@{
                                            #    name = "Deployment Process Name"
                                            #    Expression = {
                                            #        $temp = $_.DeploymentProcessId;
                                            #        $temp = Invoke-RestMethod -Method Get -Uri ( "$OCTOPUSURI/deploymentprocesses/$($temp)" ) -Headers $header;
                                            #
                                            #    }
                                            #}, 
                                            ClonedFromProjectId,
                                            DiscreteChannelRelease,
                                            @{
	                                            name = "IncludedLibraryVariableSetIds"
	                                            Expression = {
		                                            $(
			                                            Foreach ($property in $_.IncludedLibraryVariableSetIds.PSObject.Properties) {
				                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
			                                            }
		                                            )
	                                            }
                                            },
                                            DefaultToSkipIfAlreadyInstalled,
                                            TenantedDeploymentMode,
                                            DefaultGuidedFailureMode,
                                            @{
	                                            name = "VersioningStrategy"
	                                            Expression = {
		                                            $(
			                                            Foreach ($property in $_.VersioningStrategy.PSObject.Properties) {
				                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
			                                            }
		                                            )
	                                            }
                                            },
                                            @{
	                                            name = "ReleaseCreationStrategy"
	                                            Expression = {
		                                            $(
			                                            Foreach ($property in $_.ReleaseCreationStrategy.PSObject.Properties) {
				                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
			                                            }
		                                            )
	                                            }
                                            },
                                            @{
	                                            name = "Templates"
	                                            Expression = {
		                                            $(
			                                            Foreach ($property in $_.Templates.PSObject.Properties) {
				                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
			                                            }
		                                            )
	                                            }
                                            },
                                            @{
	                                            name = "AutoDeployReleaseOverrides"
	                                            Expression = {
		                                            $(
			                                            Foreach ($property in $_.AutoDeployReleaseOverrides.PSObject.Properties) {
				                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
			                                            }
		                                            )
	                                            }
                                            },
                                            Name,
                                            Slug,
                                            Description,
                                            IsDisabled,
                                            ProjectGroupId,
                                            @{
                                                name = "Project Group Name"
                                                Expression = {
                                                    $(
                                                        $temp = $_.ProjectGroupId;
                                                        $( $ProjectGroups | ? { $_.id -eq  $temp } | Select Name).Name
                                                    )
                                                }
                                            },


                                            LifecycleId,
                                            @{
                                                name = "LifeCycle Name"
                                                Expression = {
                                                    $(
                                                        $temp = $_.LifecycleID;
                                                        $( $LifeCycles | ? { $_.id -eq  $temp } | Select Name).Name
                                                    )
                                                }
                                            },
                                            AutoCreateRelease,
                                            @{
	                                            name = "ProjectConnectivityPolicy"
	                                            Expression = {
		                                            $(
			                                            Foreach ($property in $_.ProjectConnectivityPolicy.PSObject.Properties) {
				                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
			                                            }
		                                            )
	                                            }
                                            },
                                            @{
	                                            name = "Links"
	                                            Expression = {
		                                            $(
			                                            Foreach ($property in $_.Links.PSObject.Properties) {
				                                            "$($property.Name): $($property.Value) | ";
			                                            }
		                                            )
	                                            }
                                            } |
                                    Sort Name |
                                    ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};                    

                #endregion Project
                    
                #---------------------------------------------------------------------
                # Getting all Action Templates for this Octopus instance and convert to HTML fragment
                #---------------------------------------------------------------------
                #region ActionTemplate
                Write-Host "Processing Action Templates Information...";
                $subhead = "<h3>Action Templates - Count: $($ActionTemplates.Count)</h3>";
                $htmlbody += ${subhead};

                $htmlbody += $ActionTemplates | Sort Name |
                                Select  ID,
                                        Name,
                                        Description,
                                        ActionType,
                                        Version,
                                        CommunityActionTemplateId,
                                        @{
                                            name = "Community Action Template Name"
                                            Expression = {
                                                $temp = $_.CommunityActionTemplateId;
                                                "$( $( $CommunityActionTemplate.Items | ? { $_.Id -eq $temp } | Select Name ).Name )";
                                            }
                                        },
                                        @{
                                            name = "Packages"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Packages.PSObject.Properties) {
                                                        "$($property.Name) - $($property.Value) | ";
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "Properties"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Properties.PSObject.Properties) {
                                                        "$($property.Name) - $($property.Value) | ";
                                                    }
                                                )
                                            }
                                        },
                                       @{
                                            name = "Parameters"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Parameters.PSObject.Properties) {
                                                        "$($property.Name) - $($property.Value) | ";
                                                    }
                                                )
                                            }
                                        },
                                       @{
                                            name = "Links"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Links.PSObject.Properties) {
                                                        "$($property.Name) - $($property.Value) | ";
                                                    }
                                                )
                                            }
                                        } |
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};
      
                #endregion ActionTemplate

                #---------------------------------------------------------------------
                # Getting all MachinePolicies for this Octopus instance and convert to HTML fragment
                #---------------------------------------------------------------------
                #region MachinePolicies

                Write-Host "Processing Machine Policies Information...";
                $subhead = "<h3>Machine Policies Information - Count: $($MachinePolicies.Count)</h3>";
                $htmlbody += ${subhead};
 
 
                $htmlbody += $MachinePolicies |
                                    Select  ID,
                                            Name,
                                            Description,
                                            IsDefault,
                                            @{
                                                name = "MachineHealthCheckPolicy"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.MachineHealthCheckPolicy.PSObject.Properties) {
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "MachineConnectivityPolicy"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.MachineConnectivityPolicy.PSObject.Properties) {
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "MachineCleanupPolicy"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.MachineCleanupPolicy.PSObject.Properties) {
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "MachineUpdatePolicy"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.MachineUpdatePolicy.PSObject.Properties) {
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "Links"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.Links.PSObject.Properties) {
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                        }
                                                    )
                                                }
                                            } |
                                    Sort Name |
                                    ConvertTo-Html -Fragment;
                $htmlbody += ${SPACER};

                #endregion MachinePolicies

                #---------------------------------------------------------------------
                # Getting all Life Cycle for this Octopus instance and convert to HTML fragment
                #---------------------------------------------------------------------
                #region LifeCyle

                #######################################################################################
                # This Section Exists in OctopusVariableReport.ps1
                #######################################################################################

                Write-Host "Processing Life Cycle Information...";
                $subhead = "<h3>LifeCycle Information - Count: $($LifeCycles.Count)</h3>";
                $htmlbody += ${subhead};

                $htmlbody += $LifeCycles |
                                Select  ID,
                                        Name,
                                        Description,
                                        @{
                                            name = "ReleaseRetentionPolicy"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.ReleaseRetentionPolicy.PSObject.Properties) {
                                                        "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "TentacleRetentionPolicy"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.TentacleRetentionPolicy.PSObject.Properties) {
                                                        "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                    }
                                                )
                                            }
                                        },
                                        Phase,
                                        @{
                                            name = "Links"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Links.PSObject.Properties) {
                                                        "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                    }
                                                )
                                            }
                                        } |
                                Sort Name |
                                ConvertTo-Html -Fragment;


                $htmlbody += ${SPACER};

                #endregion LifeCyle

                #---------------------------------------------------------------------
                # Getting all Interruptions for this Octopus instance and convert to HTML fragment
                #---------------------------------------------------------------------
                #region Interruptions

                Write-Host "Processing Interruptions Information...";

                $subhead = "<h3>Interruptions Information - Count: $($Interruptions.TotalResults)</h3>";
                $htmlbody += ${subhead};

                $htmlbody += $Interruptions.Items |
                                Select  ID,
                                        TaskId,
                                        @{
                                            name = "Task Name"
                                            Expression = {
                                                $temp = $_.TaskId
                                                "$( $( $Tasks.Items | ? { $_.id -eq $temp } | Select Name).Name )";
                                            }
                                        },
                                        Title,
                                        IsPending,
                                        @{
                                            name = "Related DocumentIds"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.RelatedDocumentIds.PSObject.Properties) {
                                                        "$($property.Name): $($property.Value) | ";
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "Form"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Form.PSObject.Properties) {
                                                        "$($property.Name): $($property.Value) | ";
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "Responsible TeamIds"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.ResponsibleTeamIds.PSObject.Properties) {
                                                        "$($property.Name): $($property.Value) | ";
                                                    }
                                                )
                                            }
                                        },
                                        ResponsibleUserId,
                                        @{
                                            name = "Responsible User Name"
                                            Expression = {
                                                $temp = $_.ResponsibleUserId;
                                                "$( $( $User | ? { $_.id -eq $temp } | Select DisplayName).DisplayName )";
                                            }
                                        },
                                        CanTakeResponsibility,
                                        HasResponsibility,
                                        CorrelationId,
                                        Created,
                                        IsLinkedToOtherInterruption,
                                        @{
                                            name = "Links"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Links.PSObject.Properties) {
                                                        "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                    }
                                                )
                                            }
                                        } |
                                Sort Title |
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                #endregion Interruptions

                #---------------------------------------------------------------------
                # Getting all Proxy for this Octopus instance and convert to HTML fragment
                #---------------------------------------------------------------------
                #region Proxy
                Write-Host "Processing Proxy Information...";
                $subhead = "<h3>Proxy Information - Count: $(${Proxies}.Count)</h3>";
                $htmlbody += ${subhead};
          
                $htmlbody += $Proxies | 
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                #endregion Proxy

                #---------------------------------------------------------------------
                # Getting all Tasks for this Octopus instance and convert to HTML fragment
                #---------------------------------------------------------------------
                #region Tasks
                Write-Host "Processing Tasks Information...";
                $subhead = "<h3>Tasks Information - Count: $($Tasks.TotalResults)</h3>";
                $htmlbody += ${subhead};

                $htmlbody += $Tasks.Items |
                                Select  ID,
                                        Name,
                                        Description,
                                        Arguments,
                                        State,
                                        Completed,
                                        QueueTime,
                                        QueueTimeExpiry,
                                        StartTime,
                                        LastUpdatedTime,
                                        CompletedTime,
                                        ServerNode,
                                        Duration,
                                        ErrorMessage,
                                        HasBeenPickedUpByProcessor,
                                        IsCompleted,
                                        FinishedSuccessfully,
                                        HasPendingInterruptions,
                                        CanRerun,
                                        HasWarningsOrErrors,
                                        @{
                                            name = "Links"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Links.PSObject.Properties) {
                                                        "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                    }
                                                )
                                            }
                                        } |
                                Sort Name |
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                #endregion Tasks

                #---------------------------------------------------------------------
                # Getting all Library Variables Set for this Octopus instance and convert to HTML fragment
                #---------------------------------------------------------------------
                #region LibraryVariableSets
                Write-Host "Processing Library Variable Set Information...";
                $subhead = "<h3>Library Variable Sets - Count: $($LibraryVariableSets.Count)</h3>";
                $htmlbody += ${subhead};

                $htmlbody += ${LibraryVariableSets} | 
                                Sort Name |
                                Select  ID, 
                                        Name, 
                                        Description, 
                                        Responsible,
                                        @{
                                            name = "Links"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Links.PSObject.Properties) {
                                                        "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                    }
                                                )
                                            }
                                        } |
                                ConvertTo-Html -Fragment
                $htmlbody += ${SPACER};

                #endregion LibraryVariableSets

                #---------------------------------------------------------------------
                # Getting all Channelss Variables Set for this Octopus instance and convert to HTML fragment
                #---------------------------------------------------------------------
                #region Channels
                Write-Host "Processing Channels Information...";

                $subhead = "<h3>Channels Sets - Count: $($Channels.Count)</h3>";
                $htmlbody += ${subhead};

                $htmlbody += $Channels |
                                Sort    ProjectID,
                                        LifecycleID,
                                        Name |
                                Select  ID,
                                        Name,
                                        Description,
                                        ProjectID,
                                        @{
                                            name = "Project Name"
                                            Expression = {
                                                $temp = $_.ProjectID;
                                                $( $Projects | ? { $_.id -eq $temp } | Select Name).name
                                            }
                                        },
                                        LifecycleID,
                                        @{
                                            name = "LifeCycle Name"
                                            Expression = {
                                                $temp = $_.LifecycleID;
                                                $( $LifeCycles | ? { $_.id -eq  $temp } | Select Name).Name
                                            }
                                        },                                    
                                        IsDefault  |
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                #endregion Channels

                #---------------------------------------------------------------------
                # Getting all TagSets for this Octopus instance and convert to HTML fragment
                #---------------------------------------------------------------------
                #region Tags
                Write-Host "Processing TagSets Information...";
                $subhead = "<h3>Tag Sets - Count: $($Tags.Count)</h3>";
                $htmlbody += ${subhead};

                $htmlbody += $Tags |
                                Sort Name |
                                Select  ID,
                                        Name,
                                        Description,
                                        SortOrder,
                                        @{
                                            name = "Tags"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Tags.PSObject.Properties) {
                                                        "$($property.Name): $($property.Value) | ";
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "Links"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Links.PSObject.Properties) {
                                                        "$($property.Name): $($property.Value) | ";
                                                    }
                                                )
                                            }
                                        } |
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};
                
                #endregion Tags

                #---------------------------------------------------------------------
                # Getting all Tenants for this Octopus instance and convert to HTML fragment
                #---------------------------------------------------------------------
                #region Tenants
                Write-Host "Processing Tenants Information...";
                $subhead = "<h3>Tenants - Count: $($Tenants.Count)</h3>";
                $htmlbody += ${subhead};

                $htmlbody += $Tenants |
                                Sort Name |
                                Select  ID,
                                        Name,
                                        @{
                                            name = "Tenant Tags"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.TenantTags.PSObject.Properties) {
                                                        "$($property.Name): $($property.Value) | ";
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "Project Environments"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.ProjectEnvironments.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) ->> ";

                                                            $( $Projects | ? { $_.Id -contains $($property.Name) } | select Name ).Name

                                                            $temp = $($property.Value);
                                                            foreach ( $i in $($property.Value).Split(" ") ) {
                                                                $temp = $i.Trim();
                                                                "$( $( $Environments | ? { $_.id -contains $temp } | select Name ).Name ) | "
                                                            }
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "Links"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Links.PSObject.Properties) {
                                                        "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                    }
                                                )
                                            }
                                        } |
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                #endregion Tenants

                #---------------------------------------------------------------------
                # Getting all Tenants for this Octopus instance and convert to HTML fragment
                #---------------------------------------------------------------------
                #region Deployments
            
                Write-Host "Processing Development Information...";
                $subhead = "<h3>Development - Count: $($deployments.TotalResults)</h3>";
                $htmlbody += ${subhead};

           
                $htmlbody += $deployments.Items |
                                Select  ID,
                                        ReleaseId,
                                        EnvironmentId,
                                        @{
                                            name = "Environment Name"
                                            Expression = {
                                                $temp = $_.EnvironmentId;
                                                $( $Environments | ? { $_.id -eq $temp } | Select Name).name
                                            }
                                        },
                                        TenantId,
                                        ForcePackageDownload,
                                        ForcePackageRedeployment,
                                        @{
                                            name = "Skip Actions"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Links.PSObject.Properties) {
                                                        "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "Specific Machine Ids"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Links.PSObject.Properties) {
                                                        "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "Excluded Machine Ids"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Links.PSObject.Properties) {
                                                        "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                    }
                                                )
                                            }
                                        },
                                        DeploymentProcessId,
                                        ManifestVariableSetId,
                                        TaskId,
                                        ChannelId,
                                        @{
                                            name = "Channel Name"
                                            Expression = {
                                                $temp = $_.ChannelId;
                                                $( $Channels | ? { $_.id -eq $temp } | Select Name).name
                                            }
                                        },
                                        ProjectId,
                                        @{
                                            name = "Project Name"
                                            Expression = {
                                                $temp = $_.ProjectID;
                                                $( $Projects | ? { $_.id -eq $temp } | Select Name).name
                                            }
                                        },
                                        UseGuidedFailure,
                                        Comments,
                                        FormValues,
                                        QueueTime,
                                        QueueTimeExpiry,
                                        Name,
                                        Created,
                                        @{
                                            name = "Links"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Links.PSObject.Properties) {
                                                        "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                    }
                                                )
                                            }
                                        } |
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};

                #endregion Deployments
            
                #---------------------------------------------------------------------
                # Getting all Release Information and convert to HTML fragment
                #---------------------------------------------------------------------
                #region Releases

                Write-Host "Processing Release Information...";
                $subhead = "<h3>Release - Count: $($Release.TotalResults)</h3>";
                $htmlbody += ${subhead};

                $htmlbody += $Release.Items | 
                                select  Id,
                                        Assembled,
                                        ReleaseNotes,
                                        ProjectID,
                                        @{
                                            name = "Project Name"
                                            Expression = {
                                                $temp = $_.ProjectID;
                                                $( $Projects | ? { $_.id -eq $temp } | Select Name).name
                                            }
                                        },
                                        ChannelID,
                                        @{
                                            name = "Channel Name"
                                            Expression = {
                                                $temp = $_.ChannelId;
                                                $( $Channels | ? { $_.id -eq $temp } | Select Name).name
                                            }
                                        },
                                        ProjectVariableSetSnapshotId,
                                        @{
                                            name = "Library Variable Set Snapshot Ids"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.LibraryVariableSetSnapshotIds.PSObject.Properties) {
                                                        "$($property.Name): $($property.Value) | ";
                                                    }
                                                )
                                            }
                                        },
                                        ProjectDeploymentProcessSnapshotId,
                                        @{
                                            name = "Selected Packages"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.SelectedPackages.PSObject.Properties) {
                                                        "$($property.Name): $($property.Value) | ";
                                                    }
                                                )
                                            }
                                        },
                                        version,
                                        @{
                                            name = "Links"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Links.PSObject.Properties) {
                                                        "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                    }
                                                )
                                            }
                                        } |
                                ConvertTo-Html -Fragment;
                                    
                $htmlbody += ${SPACER};
                #endregion Releases

                #---------------------------------------------------------------------
                # Getting all SMTP Information and convert to HTML fragment
                #---------------------------------------------------------------------
                #region SMTP

                Write-Host "Processing SMTP Information...";
                $subhead = "<h3>SMTP</h3>";
                $htmlbody += ${subhead};

                $htmlbody += $SMTPConfig |   
                                select  Id,
                                        smtphost,
                                        smtpport,
                                        sendemailfrom,
                                        smtllogin,
                                        enablessl,
                                        @{
                                            name = "Links"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Links.PSObject.Properties) {
                                                        "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                    }
                                                )
                                            }
                                        } |
                                ConvertTo-Html -Fragment;
                                    
                $htmlbody += ${SPACER};
                #endregion SMTP

                #---------------------------------------------------------------------
                # Getting all Spaces Information and convert to HTML fragment
                #---------------------------------------------------------------------
                #region Spaces

                Write-Host "Processing Spaces Information...";
                $subhead = "<h2>Spaces - Count: $($Spaces.TotalResults) </h2>";
                $htmlbody += ${subhead};

                $htmlbody += $Spaces.items |   
                                select  Id,
                                        name,
                                        description,
                                        IsDefault,
                                        TaskQueueStopped,
                                        @{
                                            name = "Space Managers Teams"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Links.PSObject.Properties) {
                                                        "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                    }
                                                )
                                            }
                                        }, 
                                        @{
                                            name = "Space Managers Team Members"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Links.PSObject.Properties) {
                                                        "$($property.Name) - ${OCTOPUSDomain}$($property.Value) | ";
                                                    }
                                                )
                                            }
                                        }, 
                                        @{
                                            name = "Links"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Links.PSObject.Properties) {
                                                        "$($property.Name): $($property.Value) | ";
                                                    }
                                                )
                                            }
                                        } |
                                Sort Name |
                                ConvertTo-Html -Fragment;
                                    
                $htmlbody += ${SPACER};
                #endregion Spaces

                #---------------------------------------------------------------------
                # Getting all Scheduler Information and convert to HTML fragment
                #---------------------------------------------------------------------
                #region Scheduler

                Write-Host "Processing Scheduler Information...";
                $subhead = "<h2>Scheduler is running: $( $Scheduler.IsRunning ) </h2>";
                $htmlbody += ${subhead};

                $htmlbody += $Scheduler.TaskStatus | 
                                    Select  Name,
                                            IsEnabled,
                                            Links |
                                    Sort    Name |
                                    ConvertTo-Html -Fragment;
            
                $htmlbody += ${SPACER};

                #endregion Scheduler
        

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
                                H4 {font-size: 14px;}
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
        
                write-host "Generated File ${outputlocation}";
                $htmlreport | Out-File ${outputlocation} -Encoding Utf8 -force;              
            #} #End



            write-host "-------------------------------------------------------------------";
            "Total Duration: {0:HH:mm:ss}" -f ([datetime]$((Get-Date) - ${StartTime}).Ticks) | Write-Host;
            write-host "-------------------------------------------------------------------";



        #} #End


    } # function OctopusAuditReport

#endregion PublicFunction


