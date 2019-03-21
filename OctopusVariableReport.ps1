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
	OctopusVariableReport -OCTOPUSDomain "http://ABC123.com" -APIKEY "API-00000000000000";

.Example Providng API KEY  - change output directory
	OctopusVariableReport -OCTOPUSDomain "http://ABC123.com" -APIKEY "API-00000000000000" -outputlocation "$($env:USERPROFILE)\Downloads\OctopusVariableReport.html";


.Reference
	Octopus Swagger
    http://ABC123.com/octopus/swaggerui/index.html#/
#>


function OctopusVariableReport {
    param(
        [Parameter(Mandatory=$true)] [String] ${OCTOPUSDomain}
		, [Parameter(Mandatory=$true)] [String] ${APIKEY}		
		, [Parameter(Mandatory=$false)] [String] ${outputlocation} = "$($env:USERPROFILE)\Downloads\OctopusVariableReport.html"
        , [Parameter(Mandatory=$false)] [bool] $DebugMode = $true
        )

    clear;
    
    write-host "function being executed '$($MyInvocation.MyCommand)' ";
	
	
    #######################################################################################################
    # Constants
    #######################################################################################################
    [DateTime] $STARTTIME = get-date;	
    [String] $SPACER = "<br />";
    
    # Connection variables
    [String]$OCTOPUSURI = "${OCTOPUSDomain}/octopus/api"


    #######################################################################################################
    ## Variables
    #######################################################################################################
    $temp= "";
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
        #Start-Job -Name "ProjectList" -ScriptBlock { 
            Write-Host "Collecting Project Information...";
            $ProjectList = Invoke-RestMethod -Uri "${OCTOPUSURI}/projects/all?ApiKey=${APIKEY}" -Method Get;
        #} ;
        #Wait-Job -Name "ProjectList";

        #Start-Job -Name "ProjectList" -ScriptBlock { 
            Write-Host "Collecting Project Group Information...";
            $ProjectGroups = Invoke-RestMethod -Uri "${OCTOPUSURI}/projectgroups/all?ApiKey=${APIKEY}" -Method Get;
        #} ;
        #Wait-Job -Name "ProjectList";

        #Start-Job -Name "UserRole" -ScriptBlock { 
            Write-Host "Collecting Project Trigger Information...";
            $ProjectTriggers = Invoke-RestMethod -Uri "${OCTOPUSURI}/projecttriggers?ApiKey=${APIKEY}" -Method Get;
        #};
        #Wait-Job -Name "UserRole";
        
        #Start-Job -Name "ProjectList" -ScriptBlock { 
            Write-Host "Collecting Life Cycles Information...";
            $LifeCycles = Invoke-RestMethod -Uri "${OCTOPUSURI}/lifecycles/all?ApiKey=${APIKEY}" -Method Get;
        #} ;
        #Wait-Job -Name "ProjectList";                
       
        #Start-Job -Name "ProjectList" -ScriptBlock { 
            Write-Host "Collecting Library Variable Sets Information...";
            $LibraryVariableSets = Invoke-RestMethod -Uri "${OCTOPUSURI}/libraryvariablesets/all?ApiKey=${APIKEY}" -Method Get;
        #} ;
        #Wait-Job -Name "ProjectList";

        #Start-Job -Name "ProjectList" -ScriptBlock { 
#            Write-Host "Collecting Variables Information...";
#            $LibraryVariable = Invoke-RestMethod -Uri "${OCTOPUSURI}/variables/all?ApiKey=${APIKEY}" -Method Get;
        #} ;
        #Wait-Job -Name "ProjectList";

        #Start-Job -Name "ProjectList" -ScriptBlock { 
            Write-Host "Collecting Environment Information...";
            $EnvironmentsList = Invoke-RestMethod -Uri "${OCTOPUSURI}/environments/all?ApiKey=${APIKEY}" -Method Get;
        #} ;
        #Wait-Job -Name "ProjectList";

        #Start-Job -Name "ProjectList" -ScriptBlock { 
            Write-Host "Collecting Machines Information...";
            $MachineList = Invoke-RestMethod -Uri "${OCTOPUSURI}/machines/all?ApiKey=${APIKEY}" -Method Get;
        #} ;
        #Wait-Job -Name "ProjectList";        
    
        #Start-Job -Name "ProjectList" -ScriptBlock { 
            Write-Host "Collecting Channels Information...";
            $ChannelsList = Invoke-RestMethod -Uri "${OCTOPUSURI}/channels?ApiKey=${APIKEY}" -Method Get;
        #} ;
        #Wait-Job -Name "ProjectList";

        #Start-Job -Name "UserRole" -ScriptBlock { 
            Write-Host "Collecting User Roles Information...";
            $UserRole = Invoke-RestMethod -Uri "${OCTOPUSURI}/userroles/all?ApiKey=${APIKEY}" -Method Get;
        #};
        #Wait-Job -Name "UserRole";

#Start-Job -Name "UserRole" -ScriptBlock { 
#    Write-Host "Collecting Machines roles Information...";
#    $MachineRoles = Invoke-RestMethod -Uri "${OCTOPUSURI}/machineroles/all?ApiKey=${APIKEY}" -Method Get;
#};
#Wait-Job -Name "UserRole";

    #Start-Job -Name "UserRole" -ScriptBlock { 
        Write-Host "Collecting Octopus Searver Nodes Information...";
        $OctopusServerNodes = Invoke-RestMethod -Uri "${OCTOPUSURI}/octopusservernodes/all?ApiKey=${APIKEY}" -Method Get;
    #};
    #Wait-Job -Name "UserRole";

        
        
    # } # BEGIN    

    #PROCESS{
        #---------------------------------------------------------------------
        # Getting all Project Triggers and convert to HTML fragment
        #---------------------------------------------------------------------    
        #region OctopusServer
            Write-Host "Processing Project TriggersSets Information...";
            $subhead = "<h2>Octopus Server Information</h2>";
            $htmlbody += ${subhead};

            $htmlbody += $OctopusServerNodes |
                Select  Id,
                        Name,
                        LastSeen,
                        Rank,
                        IsOffline,
                        MaxConcurrentTasks,
                        IsInMaintenanceMode,
                        Links |
                Sort Name |
                ConvertTo-Html -Fragment;

        #endregion OctopusServer

        #---------------------------------------------------------------------
        # Getting all Project  and convert to HTML fragment
        #---------------------------------------------------------------------   
        #region Projects
        Write-Host "Processing Prjoject Information...";
        $subhead = "<h2>Project</h2>";
        $htmlbody += ${subhead};

        $htmlbody += ${ProjectList} | Sort Name |
                            select  Id,
                                    VariableSetId,
                                    DeploymentProcessId,
                                    ClonedFromProjectId,
                                    DiscreteChannelRelease,
                                    @{
                                        name = "IncludedLibraryVariableSetIds"
                                        Expression = { 
                                            $(
                                                Foreach ($property in $_.IncludedLibraryVariableSetIds.split(",")) {
                                                    $( $LibraryVariableSets | where { $_.id -eq $property } | select Name).name
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
                                                    "$($property.Name): $($property.Value) ";
                                                }
                                            )
                                        }
                                    },
                                    @{
                                        name = "ReleaseCreationStrategy"
                                        Expression = {
                                            $(
                                                Foreach ($property in $_.ReleaseCreationStrategy.PSObject.Properties) {
                                                    "$($property.Name): $($property.Value) ";
                                                }
                                            )
                                        }
                                    },
                                    @{
                                        name = "Templates"
                                        Expression = {
                                            $(
                                                Foreach ($property in $_.Templates.PSObject.Properties) {
                                                    "$($property.Name): $($property.Value) ";
                                                }
                                            )
                                        }
                                    },
                                    @{
                                        name = "AutoDeployReleaseOverrides"
                                        Expression = {
                                            $(
                                                Foreach ($property in $_.AutoDeployReleaseOverrides.PSObject.Properties) {
                                                    "$($property.Name): $($property.Value) ";
                                                }
                                            )
                                        }
                                    },
                                    Name,
                                    Slug,
                                    Description,
                                    IsDisabled,
                                    @{
                                        name = "ProjectGroup"
                                        Expression = { 
                                            $(
                                                $temp = $_.ProjectGroupId;
                                                ($ProjectGroupsSubAPI | Where-Object { $_.Id -eq $temp } | Select Name).Name
                                            )       
                                       }
                                    },

                                    @{
                                        name = "Lifecycle"
                                        Expression = { 
                                            $(
                                                $temp = $_.LifecycleId;
                                                ($LifeCycles | Where-Object { $_.Id -eq $temp } | Select Name).Name
                                            )       
                                       }
                                    },
                                    AutoCreateRelease,
                                    @{
                                        name = "ProjectConnectivityPolicy"
                                        Expression = {
                                            $(
                                                Foreach ($property in $_.ProjectConnectivityPolicy.PSObject.Properties) {
                                                    "$($property.Name): $($property.Value) "
                                                }
                                            )
                                        }
                                    },
                                    @{
                                        name = "Links"
                                        Expression = {
                                            $(
                                                Foreach ($property in $_.Links.PSObject.Properties) {
                                                    "$($property.Name):  ${OCTOPUSDomain}$($property.Value) "
                                                }
                                            )
                                        }
                                    }  |                             
                            ConvertTo-Html -Fragment
        $htmlbody += ${SPACER};

        #endregion Projects
        
        
#---------------------------------------------------------------------
# Getting all Project Groups and convert to HTML fragment
#---------------------------------------------------------------------    
#region ProjectGroups
##  $ProjectGroups
#endregion ProjectGroups

        #---------------------------------------------------------------------
        # Getting all Project Triggers and convert to HTML fragment
        #---------------------------------------------------------------------    
        #region ProjectTrigger
            Write-Host "Processing Project TriggersSets Information...";
            $subhead = "<h2>Project Triggers</h2>";
            $htmlbody += ${subhead};

            $subhead = "<h3>Total Triggers: $($ProjectTriggers.TotalResults)</h3>";
            $htmlbody += ${subhead};

            $htmlbody += $ProjectTriggers.Items |
                Select  Id,
                        Name,
                        ProjectID,
                        @{
                            name = "Project Name"
                            Expression = {
                                $(
                                    $temp = $_.ProjectID;
                                    ($ProjectList | where { $_.id -eq  $temp } | Select Name).Name
                                )
                            }
                        },                
                        IsDisabled,
                        @{
                            name = "Filter"
                            Expression = {
                                $(
                                    Foreach ($property in $_.Filter.PSObject.Properties) {
                                        "$($property.Name): $($property.Value) "
                                    }
                                )
                            }
                        },
                        Action,
                        Links |
                Sort Name |
                ConvertTo-Html -Fragment;

        #endregion ProjectTrigger

#---------------------------------------------------------------------
# Getting all LifeCycle and convert to HTML fragment
#---------------------------------------------------------------------    
#region LifeCycle
##  $LifeCycles
#endregion LifeCycle
        
        #---------------------------------------------------------------------
        # Getting all Library variables and convert to HTML fragment
        #---------------------------------------------------------------------    
        #region LibraryVariable
        Write-Host "Processing Library Variable Sets Information...";
        $subhead = "<h2>Library  Variables</h2>";
        $htmlbody += ${subhead};

        $htmlbody += ${LibraryVariableSets} | 
                        Where-Object { $_.ContentType -eq "Variables" } | 
                        Select  ID, 
                                Name, 
                                Description, 
                                @{
                                    name = "Templates"
                                    Expression = {
                                        $(
                                            Foreach ($property in $_.Templates.PSObject.Properties) {
                                                "$($property.Name): $($property.Value) "
                                            }
                                        )
                                    }
                                },
                                @{
                                    name = "Links"
                                    Expression = {
                                        $(
                                            Foreach ($property in $_.Links.PSObject.Properties) {
                                                "$($property.Name): ${OCTOPUSDomain}$($property.Value) "
                                            }
                                        )
                                    }
                                } |
                        Sort Name |
                        ConvertTo-Html -Fragment
        $htmlbody += ${SPACER};

        #endregion LibraryVariable

        #---------------------------------------------------------------------
        # Getting all Script Module variables and convert to HTML fragment
        #---------------------------------------------------------------------   
        #region ModuleVariable
        Write-Host "Processing Library ScriptModule Sets Information...";
        $subhead = "<h2>ScriptModule  Variables</h2>";
        $htmlbody += ${subhead};

        $htmlbody += ${LibraryVariableSets} | 
                        Where-Object { $_.ContentType -eq "ScriptModule" } |                         
                        Select  ID, 
                                Name, 
                                Description, 
                                @{
                                    name = "Templates"
                                    Expression = {
                                        $(
                                            Foreach ($property in $_.Templates.PSObject.Properties) {
                                                "$($property.Name): $($property.Value) "
                                            }
                                        )
                                    }
                                },
                                @{
                                    name = "Links"
                                    Expression = {
                                        $(
                                            Foreach ($property in $_.Links.PSObject.Properties) {
                                                "$($property.Name): ${OCTOPUSDomain}$($property.Value) "
                                            }
                                        )
                                    }
                                } |
                        Sort Name |
                        ConvertTo-Html -Fragment
        $htmlbody += ${SPACER};
        
        #endregion ModuleVariable

        #---------------------------------------------------------------------
        # Getting all Project Variables and convert to HTML fragment
        #---------------------------------------------------------------------   
        #region ProjectVariable
        Write-Host "Processing Project variables ...";
        $subhead = "<h2>Project Variables</h2>";
        $htmlbody += ${subhead};

        foreach ($i in ${ProjectList} | Sort Name | select Name, VariableSetId ) {   
            #Start-Job -Name "librarytemp" -ScriptBlock { 
                #Write-Host $($i.VariableSetId)
                $librarytemp = Invoke-RestMethod -Uri "${OCTOPUSURI}/variables/$($i.VariableSetId)?ApiKey=${APIKEY}" -Method Get;
            #};
            #Wait-Job -Name "librarytemp";

            $tempProjectName = $($i.Name);
            $tempProjectVariableID  = $($i.VariableSetId);

            write-host "Processing Project variable: ${tempProjectName}...";
            $librarytemp | foreach {

                $subhead = "<h3>Project: ${tempProjectName} - ${tempProjectVariableID}</h3>";
                $htmlbody += ${subhead};
       
                $htmlbody += $_.Variables | 
                                SELECT  Id,
                                        Name,
                                        Description,
                                        Value,
                                        @{
                                            name = "Scope"
                                            Expression = {
                                                $(

                                                    Foreach ($property in $_.Scope.PSObject.Properties ) {
                                                        switch ($($property.name)) {
                                                            "Environment" {
                                                               "$($property.name): $( $( $EnvironmentsList | where { $_.Id -eq $($property.value) } | select Name).name) |"
                                                            }
                                                            "Machine" {
                                                                "$($property.name): $( $( $MachineList | where { $_.Id -eq $($property.value) } | select Name).name) |"
                                                            }
                                                            "Channel" {
                                                                "$($property.name): $( $( $ChannelsList.Items | where { $_.Id -eq $($property.value) } | select Name) ) |"
                                                            }
                                                            #"Role Role" {
                                                            #    "RKTest1 Role - $($property.Name)"
                                                            #    "$($property.Name): $($property.Value) "
                                                            #}
                                                            default {
                                                                "RKTest1 - $($property.Name)"
                                                                "$($property.Name): $($property.Value) "
                                                            }
                                                        }                
                                                    }
                                                )
                                            }
                                        },
                                        IsEditable,
                                        Prompt,
                                        Type,
                                        IsSensitive |
                                Sort Name |
                                ConvertTo-Html -Fragment
                   
            }
        }
        $htmlbody += ${SPACER};

        #endregion ProjectVariable

        #---------------------------------------------------------------------
        # Getting all Global Variables and convert to HTML fragment
        #---------------------------------------------------------------------  
        #region GlobalVariable
                
        Write-Host "Processing Global variables ...";
        $subhead = "<h2>Global Variables</h2>";
        $htmlbody += ${subhead};

        foreach ($i in ${LibraryVariableSets} | select  name, VariableSetId | Sort Name ) {

            #Start-Job -Name "librarytemp" -ScriptBlock { 
                $librarytemp = Invoke-RestMethod -Uri "${OCTOPUSURI}/variables/$($i.VariableSetId)?ApiKey=${APIKEY}" -Method Get;
            #};
            #Wait-Job -Name "librarytemp";

            $tempProjectName = $($i.Name);

            write-host "Processing Global variable: ${tempProjectName}";
            $librarytemp | foreach {

                $subhead = "<h3>Project: ${tempProjectName}</h3>";
                $htmlbody += ${subhead};
       
                $htmlbody += $_.Variables |                                 
                                SELECT  Id,
                                        Name,
                                        Description,
                                        Value,
                                        @{
                                            name = "Scope"
                                            Expression = {
                                                $(
                                                    Foreach ($property in $_.Scope.PSObject.Properties) {
                                                        switch ($($property.name)) {
                                                            "Environment" {
                                                                "$($property.name): $( $($EnvironmentsList | where { $_.Id -eq $($property.Value) } | select Name).name) "
                                                            }
                                                            default {
                                                                "RKTest2 - $($property.Name)"
                                                                "$($property.Name): $($property.Value) "
                                                            }
                                                        }
                                                        
                                                    }
                                                )
                                            }
                                        },
                                        IsEditable,
                                        Prompt,
                                        Type,
                                        IsSensitive |
                                Sort Name |
                                ConvertTo-Html -Fragment          
            }
        }
        $htmlbody += ${SPACER};

        #endregion GlobalVariable 

        #---------------------------------------------------------------------
        # Getting all Machines and convert to HTML fragment
        #---------------------------------------------------------------------  
        #region Machines                
        Write-Host "Processing Machines ...";
        $subhead = "<h2>Machines</h2>";
        $htmlbody += ${subhead};

        $htmlbody += $MachineList |  
                        Select  Id, 
                                @{
                                    name = "EnvironmentIds"
                                    Expression = {
                                        $(
                                            Foreach ($property in $_.EnvironmentIds.PSObject.Properties) {
                                                "$($property.Name): $($property.Value) "
                                            }
                                        )
                                    }
                                },
                                @{
                                    name = "Roles"
                                    Expression = {
                                        $(
                                            Foreach ($property in $_.Roles.PSObject.Properties) {
                                                "$($property.Name): $($property.Value) "
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
                                                "$($property.Name): $($property.Value) "
                                            }
                                        )
                                    }
                                },
                                @{
                                    name = "TenantTags"
                                    Expression = {
                                        $(
                                            Foreach ($property in $_.TenantTags.PSObject.Properties) {
                                                "$($property.Name): $($property.Value) "
                                            }
                                        )
                                    }
                                },
                                Name, 
                                Thumbprint, 
                                Uri, 
                                IsDisabled, 
                                MachinePolicyId, 
                                Status, 
                                HealthStatus, 
                                HasLatestCalamari, 
                                StatusSummary, 
                                IsInProcess, 
                                Endpoint, 
                                Links |
                        Sort Name |
                    ConvertTo-Html -Fragment 

        $htmlbody += ${SPACER};

        #---------------------------------------------------------------------
        # Getting all Machines Roles and convert to HTML fragment
        #---------------------------------------------------------------------  
        #region MachinesRoles
        #Write-Host "Processing Machines Roles...";
        #$subhead = "<h2>Machines Roles</h2>";
        #$htmlbody += ${subhead};
        #
        #$htmlbody += $MachineRoles | Select | ConvertTo-Html -Fragment 
        #
        #$htmlbody += ${SPACER};

        #endregion MachinesRoles

       
    # } # PROCESS    


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
				    <h1 align=""center"">Server Info: $($env:COMPUTERNAME)</h1>
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

}  #Function

