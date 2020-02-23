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
        [String]$OCTOPUSURI = "${OCTOPUSDomain}/octopus/api"

        #################################################################################################
        ##   Variables
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
	
            


        #    BEGIN{
                clear;

                #Start-Job -Name "Feeds" -ScriptBlock { 
                    Write-Host "Collecting Feeds Information...";
                    $Feeds = Invoke-RestMethod -Uri "${OCTOPUSURI}/feeds/all?ApiKey=${APIKEY}" -Method Get;
                #};
                #Wait-Job -Name "Feeds";

                #Start-Job -Name "Account" -ScriptBlock { 
                    Write-Host "Collecting Accounts Information...";
                    $Account = Invoke-RestMethod -Uri "${OCTOPUSURI}/accounts/all?ApiKey=${APIKEY}" -Method Get; 
                #};
                #Wait-Job -Name "Account";

                #Start-Job -Name "UserRole" -ScriptBlock { 
                    Write-Host "Collecting User Roles Information...";
                    $UserRole = Invoke-RestMethod -Uri "${OCTOPUSURI}/userroles/all?ApiKey=${APIKEY}" -Method Get;
                #};
                #Wait-Job -Name "UserRole";

                #Start-Job -Name "User" -ScriptBlock {
                    Write-Host "Collecting User Information...";
                    $User = Invoke-RestMethod -Uri "${OCTOPUSURI}/users/all?ApiKey=${APIKEY}" -Method Get;
                #};
                #Wait-Job -Name "User";

                #Start-Job -Name "Teams" -ScriptBlock { 
                    Write-Host "Collecting Teams Information...";
                    $teams = Invoke-RestMethod -Uri "${OCTOPUSURI}/teams?ApiKey=${APIKEY}" -Method Get;
                #};
                #Wait-Job -Name "Teams";

                #Start-Job -Name "Environments" -ScriptBlock {
                    Write-Host "Collecting Environments Information...";
                    $Environments = Invoke-RestMethod -Uri "${OCTOPUSURI}/environments/all?ApiKey=${APIKEY}" -Method Get;
                #};
                #Wait-Job -Name "Environments";

                #Start-Job -name "Machines" -ScriptBlock { 
                    Write-Host "Collecting Machines Information...";
                    $Machines = Invoke-RestMethod -Uri "${OCTOPUSURI}/machines/all?ApiKey=${APIKEY}" -Method Get;
                #};
                #Wait-Job -Name "Machines";

                #Start-Job -Name "ProjectGroup" -ScriptBlock { 
                    Write-Host "Collecting Project Groups Information...";
                    $ProjectGroups = Invoke-RestMethod -Uri "${OCTOPUSURI}/projectgroups/all?ApiKey=${APIKEY}" -Method Get;
                #};
                #Wait-Job -Name "ProjectGroup";

                #Start-Job -Name "Project" -ScriptBlock { 
                    Write-Host "Collecting Projects Information...";
                    $Projects = Invoke-RestMethod -Uri "${OCTOPUSURI}/projects/all?ApiKey=${APIKEY}" -Method Get;
                #};
                #Wait-Job -Name "Project";

                #Start-Job -Name "ActionTemplate" -ScriptBlock { 
                    Write-Host "Collecting Action Template Information...";
                    $ActionTemplates = Invoke-RestMethod -Uri "${OCTOPUSURI}/actiontemplates/all?ApiKey=${APIKEY}" -Method Get;
                #};
                #Wait-Job -Name "ActionTemplate";

                #Start-Job -Name "MachinePolicies" -ScriptBlock { 
                    Write-Host "Collecting Machines Policies Information...";
                    $MachinePolicies = Invoke-RestMethod -Uri "${OCTOPUSURI}/machinepolicies/all?ApiKey=${APIKEY}" -Method Get;
                #};
                #Wait-Job -Name "MachinePolicies";

                #Start-Job -Name "LifeCycles" -ScriptBlock { 
                    Write-Host "Collecting Life Cycle Information...";
                    $LifeCycles = Invoke-RestMethod -Uri "${OCTOPUSURI}/lifecycles/all?ApiKey=${APIKEY}" -Method Get;
                #};
                #Wait-Job -Name "LifeCycles";

                #Start-Job -Name "Interruptions" -ScriptBlock { 
                    Write-Host "Collecting Interruptions Information...";
                    $Interruptions = Invoke-RestMethod -Uri "${OCTOPUSURI}/interruptions?ApiKey=${APIKEY}" -Method Get;
                #};
                #Wait-Job -Name "Interruptions";

                #Start-Job -Name "Proxies" -ScriptBlock { 
                    Write-Host "Collecting Proxy Information...";
                    $Proxies = Invoke-RestMethod -Uri "${OCTOPUSURI}/proxies/all?ApiKey=${APIKEY}" -Method Get;
                #};
                #Wait-Job -Name "Proxies";

                #Start-Job -Name "Tasks" -ScriptBlock { 
                    Write-Host "Collecting Tasks Information...";
                    $Tasks = Invoke-RestMethod -Uri "${OCTOPUSURI}/tasks?ApiKey=${APIKEY}" -Method Get;
                #};
                #Wait-Job -Name "Tasks";

                #Start-Job -Name "LibraryVarablesSets" -ScriptBlock { 
                    Write-Host "Collecting Library Variable Sets Information...";
                    $LibraryVariableSets = Invoke-RestMethod -Uri "${OCTOPUSURI}/libraryvariablesets/all?ApiKey=${APIKEY}" -Method Get;
                #};
                #Wait-Job -Name "LibraryVarablesSets";

                #Start-Job -Name "ProjectList" -ScriptBlock { 
                #    Write-Host "Collecting Variables Information...";
                #    $LibraryVariable = Invoke-RestMethod -Uri "${OCTOPUSURI}/variables/all?ApiKey=${APIKEY}" -Method Get;
                #} ;
                #Wait-Job -Name "ProjectList";

                #Start-Job -Name "Channels" -ScriptBlock { 
                    Write-Host "Collecting Channels Information...";
                    $Channels = Invoke-RestMethod -Uri "${OCTOPUSURI}/channels/all?ApiKey=${APIKEY}" -Method Get;
                #};
                #Wait-Job -Name "Channels";

                #Start-Job -Name "Tags" -ScriptBlock { 
                    Write-Host "Collecting Tags Information...";
                    $Tags = Invoke-RestMethod -Uri "${OCTOPUSURI}/tagsets/all?ApiKey=${APIKEY}" -Method Get;
                #};
                #Wait-Job -Name "Tags";

                #Start-Job -Name "Tenants" -ScriptBlock { 
                    Write-Host "Collecting Tenants Information...";
                    $Tenants = Invoke-RestMethod -Uri "${OCTOPUSURI}/tenants/all?ApiKey=${APIKEY}" -Method Get;
                #};
                #Wait-Job -Name "Tenants";

                #Start-Job -Name "deployments" -ScriptBlock { 
                    Write-Host "Collecting Tenants Information...";
                    $deployments = Invoke-RestMethod -Uri "${OCTOPUSURI}/deployments?ApiKey=${APIKEY}" -Method Get;
                #};
                #Wait-Job -Name "deployments";

                #Start-Job -Name "ProjectList" -ScriptBlock { 
                    Write-Host "Collecting Release Information...";
                    $Release = Invoke-RestMethod -Uri "${OCTOPUSURI}/releases?ApiKey=${APIKEY}" -Method Get;
                #} ;
                #Wait-Job -Name "ProjectList";

        #    }  #BEGIN
        
        #    PROCESS {

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
                                                        "$($property.Name) - ${OCTOPUSDomain}$($property.Value) ";
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
                                                        "$($property.Name) - ${OCTOPUSDomain}$($property.Value) ";
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "Links"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Links.PSObject.Properties) {
                                                        "$($property.Name) - ${OCTOPUSDomain}$($property.Value) ";
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
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) ";
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
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) ";
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "PrivateKeyPassphrase"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.PrivateKeyPassphrase.PSObject.Properties) {
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) ";
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
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) ";
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "TenantTags"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.TenantTags.PSObject.Properties) {
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) ";
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
                                                name = "PermissionDescriptions"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.PermissionDescriptions.PSObject.Properties) {
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) ";
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "GrantedPermissions"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.GrantedPermissions.PSObject.Properties) {
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) ";
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
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) ";
                                                        }
                                                    )
                                                }
                                            }  |
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
    
                $htmlbody += $User | 
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
                                                        "$($property.Name) - ${OCTOPUSDomain}$($property.Value) ";
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "Links"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Links.PSObject.Properties) {
                                                        "$($property.Name) - ${OCTOPUSDomain}$($property.Value) ";
                                                    }
                                                )
                                            }
                                        } |
                            
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};     

                #endregion Users

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
                                            name = "MemberUserIds"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.MemberUserIds.PSObject.Properties) {
                                                        if ($($property.Name) -contains "SyncRoot") {
                                                            $temp = $($property.Value);
                                                            foreach ( $i in $($property.Value).Split(" ") ) {
                                                                $temp = $i.Trim();
                                                                "$( $( $User | Where { $_.id -contains $temp } | select DisplayName ).DisplayName ) | "
                                                            }
                                                        }
                                                        else {
                                                            "$($property.Name): $($property.Value) ";
                                                        }
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "ExternalSecurityGroups"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.ExternalSecurityGroups.PSObject.Properties) {
                                                        "$($property.Name): $($property.Value) ";
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "TenantTags"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.TenantTags.PSObject.Properties) {
                                                        "$($property.Name): $($property.Value) ";
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
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) ";
                                                        }
                                                    )
                                                }
                                            } |
                                Sort Name |    
                                ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};       

                #endregion Teams

                #---------------------------------------------------------------------
                # Getting all Deployments on this Octopus instance and convert to HTML fragment
                #---------------------------------------------------------------------
                #region Env
                
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
                                                        "$($property.Name) - ${OCTOPUSDomain}$($property.Value) ";
                                                    }
                                                )
                                            }
                                        } |
                                Sort Name | 
                                ConvertTo-Html -Fragment;


                $htmlbody += ${SPACER};

                #endregion Env

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
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) ";
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "Roles"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.Roles.PSObject.Properties) {
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) ";
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
                                                            "$($property.Name): $($property.Value) ";
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "TenantTags"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.TenantTags.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) ";
                                                        }
                                                    )
                                                }
                                            },                                        
                                            Thumbprint,
                                            Uri,
                                            IsDisabled,
    MachinePolicyId,
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
                                                            "$($property.Name): $($property.Value) ";
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "Links"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.Links.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) ";
                                                        }
                                                    )
                                                }
                                            } |
                                    Sort Name |
                                    ConvertTo-Html -Fragment;

                $htmlbody += ${SPACER};
 
                #endregion Machines
 
                #---------------------------------------------------------------------
                # Getting all Project Groups for this Octopus instance and convert to HTML fragment
                #---------------------------------------------------------------------
                #region ProjectGroup
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
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) ";
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
                                                            "$($property.Name): $($property.Value) ";
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
                                            #        $(  $LibraryVariableSets | where { $_.id -eq $temp }  | select Name ).name
                                            #    }
                                            #}, 
    DeploymentProcessId,
    ClonedFromProjectId,
                                            DiscreteChannelRelease,
                                            @{
	                                            name = "IncludedLibraryVariableSetIds"
	                                            Expression = {
		                                            $(
			                                            Foreach ($property in $_.IncludedLibraryVariableSetIds.PSObject.Properties) {
				                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) ";
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
				                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) ";
			                                            }
		                                            )
	                                            }
                                            },
                                            @{
	                                            name = "ReleaseCreationStrategy"
	                                            Expression = {
		                                            $(
			                                            Foreach ($property in $_.ReleaseCreationStrategy.PSObject.Properties) {
				                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) ";
			                                            }
		                                            )
	                                            }
                                            },
                                            @{
	                                            name = "Templates"
	                                            Expression = {
		                                            $(
			                                            Foreach ($property in $_.Templates.PSObject.Properties) {
				                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) ";
			                                            }
		                                            )
	                                            }
                                            },
                                            @{
	                                            name = "AutoDeployReleaseOverrides"
	                                            Expression = {
		                                            $(
			                                            Foreach ($property in $_.AutoDeployReleaseOverrides.PSObject.Properties) {
				                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) ";
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
                                                        $( $ProjectGroups | where { $_.id -eq  $temp } | Select Name).Name
                                                    )
                                                }
                                            },


                                            LifecycleId,
                                            @{
                                                name = "LifeCycle Name"
                                                Expression = {
                                                    $(
                                                        $temp = $_.LifecycleID;
                                                        $( $LifeCycles | where { $_.id -eq  $temp } | Select Name).Name
                                                    )
                                                }
                                            },
                                            AutoCreateRelease,
                                            @{
	                                            name = "ProjectConnectivityPolicy"
	                                            Expression = {
		                                            $(
			                                            Foreach ($property in $_.ProjectConnectivityPolicy.PSObject.Properties) {
				                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) ";
			                                            }
		                                            )
	                                            }
                                            },
                                            @{
	                                            name = "Links"
	                                            Expression = {
		                                            $(
			                                            Foreach ($property in $_.Links.PSObject.Properties) {
				                                            "$($property.Name): $($property.Value) ";
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
                                            name = "Packages"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Packages.PSObject.Properties) {
                                                        "$($property.Name) - $($property.Value) ";
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "Properties"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Properties.PSObject.Properties) {
                                                        "$($property.Name) - $($property.Value) ";
                                                    }
                                                )
                                            }
                                        },
                                       @{
                                            name = "Parameters"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Parameters.PSObject.Properties) {
                                                        "$($property.Name) - $($property.Value) ";
                                                    }
                                                )
                                            }
                                        },
                                       @{
                                            name = "Links"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Links.PSObject.Properties) {
                                                        "$($property.Name) - $($property.Value) ";
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
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) ";
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "MachineConnectivityPolicy"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.MachineConnectivityPolicy.PSObject.Properties) {
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) ";
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "MachineCleanupPolicy"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.MachineCleanupPolicy.PSObject.Properties) {
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) ";
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "MachineUpdatePolicy"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.MachineUpdatePolicy.PSObject.Properties) {
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) ";
                                                        }
                                                    )
                                                }
                                            },
                                            @{
                                                name = "Links"
                                                Expression = {
                                                    $(
                                                        Foreach ($property in $_.Links.PSObject.Properties) {
                                                            "$($property.Name) - ${OCTOPUSDomain}$($property.Value) ";
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
                                                        "$($property.Name) - ${OCTOPUSDomain}$($property.Value) ";
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "TentacleRetentionPolicy"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.TentacleRetentionPolicy.PSObject.Properties) {
                                                        "$($property.Name) - ${OCTOPUSDomain}$($property.Value) ";
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
                                                        "$($property.Name) - ${OCTOPUSDomain}$($property.Value) ";
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
                                        Title,
                                        IsPending,
                                        @{
                                            name = "RelatedDocumentIds"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.RelatedDocumentIds.PSObject.Properties) {
                                                        "$($property.Name): $($property.Value) ";
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "Form"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Form.PSObject.Properties) {
                                                        "$($property.Name): $($property.Value) ";
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "ResponsibleTeamIds"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.ResponsibleTeamIds.PSObject.Properties) {
                                                        "$($property.Name): $($property.Value) ";
                                                    }
                                                )
                                            }
                                        },
    ResponsibleUserId,
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
                                                        "$($property.Name): $($property.Value) ";
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
                                                        "$($property.Name): $($property.Value) ";
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
                                                        "$($property.Name): $($property.Value) ";
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
                                Sort    Name, 
                                        ID |
                                Select  ID,
                                        Name,
                                        Description,
                                        ProjectID,
                                        @{
                                            name = "Project Name"
                                            Expression = {
                                                $temp = $_.ProjectID;
                                                $( $Projects | where { $_.id -eq $temp } | Select Name).name
                                            }
                                        },
                                        LifecycleID,
                                        @{
                                            name = "LifeCycle Name"
                                            Expression = {
                                                $temp = $_.LifecycleID;
                                                $( $LifeCycles | where { $_.id -eq  $temp } | Select Name).Name
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
                                                        "$($property.Name): $($property.Value) ";
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "Links"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Links.PSObject.Properties) {
                                                        "$($property.Name): $($property.Value) ";
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
                                            name = "TenantTags"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.TenantTags.PSObject.Properties) {
                                                        "$($property.Name): $($property.Value) ";
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "ProjectEnvironments"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.ProjectEnvironments.PSObject.Properties) {
                                                            "$($property.Name): $($property.Value) ->> ";

                                                            $( $Projects | Where { $_.Id -contains $($property.Name) } | select Name ).Name

                                                            $temp = $($property.Value);
                                                            foreach ( $i in $($property.Value).Split(" ") ) {
                                                                $temp = $i.Trim();
                                                                "$( $( $Environments | Where { $_.id -contains $temp } | select Name ).Name ) | "
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
                                                        "$($property.Name): $($property.Value) ";
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
                                                $( $Environments | where { $_.id -eq $temp } | Select Name).name
                                            }
                                        },
                                        TenantId,
                                        ForcePackageDownload,
                                        ForcePackageRedeployment,
                                        @{
                                            name = "SkipActions"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Links.PSObject.Properties) {
                                                        "$($property.Name): $($property.Value) ";
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "SpecificMachineIds"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Links.PSObject.Properties) {
                                                        "$($property.Name): $($property.Value) ";
                                                    }
                                                )
                                            }
                                        },
                                        @{
                                            name = "ExcludedMachineIds"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Links.PSObject.Properties) {
                                                        "$($property.Name): $($property.Value) ";
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
                                                $( $Channels | where { $_.id -eq $temp } | Select Name).name
                                            }
                                        },
                                        ProjectId,
                                        @{
                                            name = "Project Name"
                                            Expression = {
                                                $temp = $_.ProjectID;
                                                $( $Projects | where { $_.id -eq $temp } | Select Name).name
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
                                                        "$($property.Name): $($property.Value) ";
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
                                                $( $Projects | where { $_.id -eq $temp } | Select Name).name
                                            }
                                        },
                                        ChannelID,
                                        @{
                                            name = "Channel Name"
                                            Expression = {
                                                $temp = $_.ChannelId;
                                                $( $Channels | where { $_.id -eq $temp } | Select Name).name
                                            }
                                        },
                                        ProjectVariableSetSnapshotId,
                                        @{
                                            name = "LibraryVariableSetSnapshotIds"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.LibraryVariableSetSnapshotIds.PSObject.Properties) {
                                                        "$($property.Name): $($property.Value) ";
                                                    }
                                                )
                                            }
                                        },
                                        ProjectDeploymentProcessSnapshotId,
                                        @{
                                            name = "SelectedPackages"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.SelectedPackages.PSObject.Properties) {
                                                        "$($property.Name): $($property.Value) ";
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
                                                        "$($property.Name): $($property.Value) ";
                                                    }
                                                )
                                            }
                                        } |
                                ConvertTo-Html -Fragment;
                                    
                $htmlbody += ${SPACER};
                #endregion Releases


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
        
                write-host "Generated File ${outputlocation}";
                $htmlreport | Out-File ${outputlocation} -Encoding Utf8 -force;              
            #} #End



            write-host "-------------------------------------------------------------------";
            "Total Duration: {0:HH:mm:ss}" -f ([datetime]$((get-date) - ${StartTime}).Ticks) | write-host;
            write-host "-------------------------------------------------------------------";


    } # function OctopusAuditReport

#endregion PublicFunction


