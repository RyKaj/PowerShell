<#######################################################################################################################################################

.SYNOPSIS
    Debug information


.DESCRIPTION
    Output all information user would require to create or debug deployment process without requring to RDP to server

.SOURCECODELOCATION
	

.USEAGE
            

.EXAMPLE 1



.HISTORY
    Oct 20 2016        Ryan Kajiura                Created 
    Apr 08 2019        R. Kajiura                  Add DOT NET CORE INFO
    May 07 2019        R. Kajiura                  PowerShell version
    May 08 2019        R. Kajiura                  PowerShell execution value
    Nov 08 2019        R. Kajiura                  Add DOT NET INFO
    Dec 18 2019        R. Kajiura                  Add TypeScript version and Regions
#######################################################################################################################################################>

#region PrivateFunction
    #region CommonParameters
    <#######################################################################################################################################################

    .SYNOPSIS
        List of Common Parameters in PowerShell

    #######################################################################################################################################################>
    function Get_CommonParameters {

        $CommonParameters = @(
			"Verbose"
            , "Debug"
            , "ErrorAction"
            , "ErrorVariable"
            , "WarningAction"
            , "WarningVariable"
            , "OutVariable"
            , "OutBuffer"
            , "WhatIf"
            , "Confirm"
            , "InformationAction"
            , "InformationVariable"
            , "pipelinevariable"
        );

        return $CommonParameters;
    }
    #endregion CommonParameter
	
#endregion PrivateFunction

#region PublicFunction

    function DeploymentDebuggingLogs {
	    #param ()

		#######################################################################################################
		# Constants
		#######################################################################################################
		[DateTime] $STARTTIME = Get-Date;
		[String] $ExecutionScope = "CurrentUser";
		[String] $ExecutionPolicy = "Unrestricted";
		[String] $DebugFunctionFontColour = "Green";
		[String] $ErrorFunctionFontColour = "Red";
        [string]$ComputerName = ${env:COMPUTERNAME};

		write-host "`r`n-------------------------------------------------------------------";
		write-host "function being executed '$($MyInvocation.MyCommand)' " -ForegroundColor ${DebugFunctionFontColour};
		write-host "-------------------------------------------------------------------`r`n";

		#######################################################################################################
		###   DEBUG
		#######################################################################################################    
		if (${DebugMode} -eq $true) {
			write-host "function being executed '$($MyInvocation.MyCommand)' ";
			foreach ( $key in (Get-Command -Name $MyInvocation.InvocationName).Parameters.Keys | ? { $( Invoke-Command -ScriptBlock { Get_CommonParameters } ) -cnotcontains $_ }  ) {
				$value = (Get-Variable $key -ErrorAction SilentlyContinue).Value;
				Write-Host "parameter...$key -> $value";
			}
		}



        #BEGIN {
        # } # BEGIN
        #PROCESS{
        
            #region AdminCheck
                Write-Host "---------------------------------------------------------------------";
                try {
                    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
                    {
                        Write-host "You do not have Administrator rights to run this script! `nPlease re-run this script as an Administrator!" -ForegroundColor ${ErrorFunctionFontColour};
                    }          
                }
                catch { 
                    Write-Host "Administrator Check failed";
                } 
                finally {}
            #endregion AdminCheck
	    
            #region UserName
                Write-Host "---------------------------------------------------------------------";
                Write-Host "PowerShell User Name: $(${env:UserName}); ";
            #endregion UserName
	    
            #region EnvPath
                Write-Host "---------------------------------------------------------------------";
                Write-Host "PowerShell Environment path: $(${env:path});";
            #endregion EnvPath
	                
            #region SystemRequiredReboot
                Write-Host "---------------------------------------------------------------------";

                #-----------------------------------------------------------------------------------
                # Main Source is in NetworkComputerInformation.ps1
                #-----------------------------------------------------------------------------------
				try{
					$result = @{
						CBSRebootPending = (Get-ChildItem "HKLM:Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -ErrorAction SilentlyContinue).CBSRebootPending;
						WindowsUpdateRebootRequired = (Get-Item "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -ErrorAction SilentlyContinue).WindowsUpdateRebootRequired;
						FileRenamePending = (Get-ItemProperty "HKLM:SYSTEM\CurrentControlSet\Control\Session Manager" -Name PendingFileRenameOperations -ErrorAction SilentlyContinue).FileRenamePending;
						SCCMRebootPending = $false;
					}

					$util = [wmiclass]"\\.\root\ccm\clientsdk:CCM_ClientUtilities";
					$status = $util.DetermineIfRebootPending();

					if ( ( $status -ne $null ) -and $status.RebootPending ) {
						$result.SCCMRebootPending = $true;
					}
					# Normalize Result Array
					if ( $result.CBSRebootPending -eq $null ) { 
						$result.CBSRebootPending = $false;
					}
					if ( $result.WindowsUpdateRebootRequired -eq $null ) { 
						$result.WindowsUpdateRebootRequired = $false;
					}
					if ( $result.FileRenamePending -eq $null ) { 
						$result.FileRenamePending = $false;
					}
		
					$temp = $result.ContainsValue( $true );

					write-host "${ComputerName} boot is requried? $temp ";				
				}				
                catch { 
                    Write-Host "Unable to determine if ${ComputerName} needs a reboot...";
                } 
                finally {}

            #endregion SystemRequiredReboot
        
            #region SystemInformation
                Write-Host "---------------------------------------------------------------------";
                write-host "Computer System Information for '${ComputerName}' ";

                Get-WmiObject -Class Win32_ComputerSystem -ComputerName ${ComputerName} -ErrorAction STOP |
                                                SELECT  Name,
                                                        Manufacturer,
                                                        Model,
                                                        PartOfDomain,
                                                        Domain,
                                                        Workgroup,
                                                        DNSHostName,
                                                        @{
                                                            Name = 'Physical Processors';
                                                            Expression = { $_.NumberOfProcessors }
                                                        },
                                                        @{
                                                            Name = 'Logical Processors';
                                                            Expression = { $_.NumberOfLogicalProcessors }
                                                        },
                                                        @{
                                                            Name = 'Total Physical Memory (Gb)';
                                                            Expression = { "{0:F0}" -f $_.TotalPhysicalMemory / 1GB -as [double] }
                                                        },
                                                        CurrentTimeZone,
                                                        DaylightInEffect,
                                                        HypervisorPresent,
                                                        PrimaryOwnerName,
                                                        UserName;

            #endregion SystemInformation
        
            #region SystemOSInformation
                Write-Host "---------------------------------------------------------------------";
                write-host "Operating System Information for '${ComputerName}' ";

                Get-WmiObject -Class Win32_OperatingSystem -ComputerName ${ComputerName} -ErrorAction STOP | 
                                                Select  Name,
                                                        Manufacturer,
                                                        Caption,
                                                        Version,
                                                        @{
	                                                        name = "MUILanguages"
	                                                        Expression = {
		                                                        $(
			                                                        Foreach ($property in $_.MUILanguages.PSObject.Properties) {
				                                                        "$($property.Name) - $($property.Value)";
			                                                        }
		                                                        )
	                                                        }
                                                        },
                                                        BuildNumber,
                                                        BuildType,
                                                        InstallDate,
                                                        OSArchitecture,
                                                        PortableOperatingSystem,
                                                        Primary,
                                                        BootDevice,
                                                        LastBootUpTime,
                                                        LocalDateTime,
                                                        CurrentTimeZone,
                                                        RegisteredUser,
                                                        SerialNumber,
                                                        SystemDevice,
                                                        SystemDirectory,
                                                        SystemDrive,
                                                        WindowsDirectory,
                                                        EncryptionLevel,
                                                        @{
	                                                        Name = 'FreePhysicalMemory (GB)';
	                                                        Expression = { "{0:F0}" -f $_.FreePhysicalMemory / 1GB -as [double] }
                                                        },
                                                        @{
	                                                        Name = 'FreeSpaceInPagingFiles (GB)';
	                                                        Expression = { "{0:F0}" -f $_.FreeSpaceInPagingFiles / 1GB -as [double] }
                                                        },
                                                        @{
	                                                        Name = 'FreeVirtualMemory (GB)';
	                                                        Expression = { "{0:F0}" -f $_.FreeVirtualMemory / 1GB -as [double] }
                                                        },
                                                        @{
	                                                        Name = 'SizeStoredInPagingFiles (GB)';
	                                                        Expression = { "{0:F0}" -f $_.SizeStoredInPagingFiles / 1GB -as [double] }
                                                        },
                                                        Status;

            #endregion SystemOSInformation
        
            #region SystemMemroyInformation
                Write-Host "---------------------------------------------------------------------";
                write-host "Physical Memory Information for '${ComputerName}' ";

                Get-WmiObject -Class Win32_PhysicalMemory -ComputerName ${ComputerName} -ErrorAction STOP |
                                            Select  Caption,
                                                    Description,
                                                    InstallDate,
                                                    Name,
                                                    Status,
                                                    CreationClassName,
                                                    Manufacturer,
                                                    Model,
                                                    OtherIdentifyingInfo,
                                                    PartNumber,
                                                    PoweredOn,
                                                    SerialNumber,
                                                    SKU,
                                                    Tag,
                                                    Version,
                                                    HotSwappable,
                                                    Removable,
                                                    Replaceable,
                                                    FormFactor,
                                                    BankLabel,
                                                    @{
                                                        Name = 'Capcity (Gb)';
                                                        Expression = { "{0:F0}" -f $_.Capacity / 1GB -as [double] }
                                                    },
                                                    DataWidth,
                                                    InterleavePosition,
                                                    MemoryType,
                                                    PositionInRow,
                                                    Speed,
                                                    TotalWidth,
                                                    Attributes,
                                                    ConfiguredClockSpeed,
                                                    ConfiguredVoltage,
                                                    DeviceLocator,
                                                    InterleaveDataDepth,
                                                    MaxVoltage,
                                                    MinVoltage,
                                                    SMBIOSMemoryType,
                                                    TypeDetail,
                                                    PSComputerName;

            #endregion SystemMemroyInformation
        
            #region SystemLogicDiskInformation
                Write-Host "---------------------------------------------------------------------";
                write-host "Disk Information for '${ComputerName}' ";

                Get-WmiObject -Class Win32_LogicalDisk -ComputerName ${ComputerName} -ErrorAction STOP | 
                            Select-Object   DeviceID,
                                            FileSystem,
                                            VolumeName,
                                            @{
                                                Name = "Total Size (GB)";
                                                Expression = { $_.Size /1Gb -as [double] };
                                            
                                            },
                                            @{
                                                Name = "Free Space (GB)";
                                                Expression = { $_.Freespace / 1Gb -as [double] };
                                            }

            #endregion SystemLogicDiskInformation
        
            #region SystemDiskInformatiuon
                Write-Host "---------------------------------------------------------------------";
                Write-Host "Logical Disk Information for '${ComputerName}' ";

                Get-WmiObject -Class Win32_DiskDrive -ComputerName ${ComputerName} -ErrorAction STOP | 
                                        Select  DeviceID,
                                                FirmwareRevision,
                                                Manufacturer,
                                                Model,
                                                MediaType,
                                                SerialNumber,
                                                InterfaceType,
                                                Partitions,
                                                @{
                                                    Name = "Total Size (GB)";
                                                    Expression = { $_.Size /1Gb -as [double] };
                                            
                                                },
                                                TotalCylinders,
                                                TotalHeads,
                                                TotalSectors,
                                                TotalTracks,
                                                TracksPerCylinderBytePerSector,
                                                SectorsPerTrack,
                                                @{
                                                    name = "Capabilities"
                                                    Expression = {
                                                        $(
                                                            Foreach ($property in $_.Capabilities.PSObject.Properties) {
                                                                "$($property.Name): $($property.Value)";
                                                            }
                                                        )
                                                    }
                                                },
                                                @{
                                                    name = "Capability Descriptions"
                                                    Expression = {
                                                        $(
                                                            Foreach ($property in $_.CapabilityDescriptions.PSObject.Properties) {
                                                                "$($property.Name): $($property.Value)";
                                                            }
                                                        )
                                                    }
                                                },
                                                Status;

            #endregion SystemDiskInformatiuon
        
            #region SystemVolumnInformation
                Write-Host "---------------------------------------------------------------------";
                Write-Host "Volume Information for '${ComputerName}' ";

                Get-WmiObject -Class Win32_Volume -ComputerName ${ComputerName} -ErrorAction STOP | 
                            Select-Object   Label,
                                            Name,
                                            DeviceID,
                                            SystemVolume,
                                            @{
                                                Name = "Total Size (GB)";
                                                Expression = { $_.Capacity / 1Gb -as [double] };
                                            },
                                            @{
                                                Name = "Free Space (GB)";
                                                Expression = { $_.Freespace / 1Gb -as [double] }
                                            }

            #endregion SystemVolumnInformation
	    
            #region PowerShellVersion
                Write-Host "---------------------------------------------------------------------";
                try { 
                    Write-Host "PowerShell version";
                    $PSVersionTable.PSVersion;
                } 
                catch { 
                    Write-Host "PowerShell not installed";
                } 
                finally {}

            #endregion PowerShellVersion
	    
            #region PowerShellExecutionPolicy
                Write-Host "---------------------------------------------------------------------";
                try { 
                    Write-Host "PowerShell Execution Policy";
                    Get-ExecutionPolicy;
                    Write-Host "`r`nPowerShell Execution Policy list";
                    Get-ExecutionPolicy -List | Format-Table;
                } 
                catch { 
                    Write-Host "PowerShell not installed";
                } 
                finally {}

            #endregion PowerShellExecutionPolicy
	    
            #region NPMVersion
                Write-Host "---------------------------------------------------------------------";
   	            try { 
                    write-Host "npm version: $(npm -v)";
                } 
                catch { 
                    Write-Host "npm is not installed";
                } 
                finally {}    
            #endregion NPMVersion
        
            #region NodeVersion
                Write-Host "---------------------------------------------------------------------";
                try { 
                    write-Host "Node version: $(node -v)";
                } 
                catch { 
                    Write-Host "Node is not installed"; 
                } 
                finally {}

            #endregion NodeVersion
        
            #region TypeScriptVersion
                Write-Host "---------------------------------------------------------------------";
                try { 
                    write-Host "TypeScript version: $(tsc -v)";
                } 
                catch { 
                    Write-Host "TypeScript is not installed"; 
                } 
                finally {}

            #endregion TypeScriptVersion
        
            #region DOTNETInfo
                Write-Host "---------------------------------------------------------------------";
                try { 
                    Write-Host "DOTNET INFO";

                    $dotNetRegistry  = 'SOFTWARE\Microsoft\NET Framework Setup\NDP';
                    $dotNet4Registry = 'SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full';
                    $dotNet4Builds = @{
                            '30319'  = @{ Version = [System.Version]'4.0'     ;                                               }
                            '378389' = @{ Version = [System.Version]'4.5'     ;                                               }
                            '378675' = @{ Version = [System.Version]'4.5.1'   ; Comment = '(8.1/2012R2)'                      }
                            '378758' = @{ Version = [System.Version]'4.5.1'   ; Comment = '(8/7 SP1/Vista SP2)'               }
                            '379893' = @{ Version = [System.Version]'4.5.2'   ;                                               }
                            '380042' = @{ Version = [System.Version]'4.5'     ; Comment = 'and later with KB3168275 rollup'   }
                            '393295' = @{ Version = [System.Version]'4.6'     ; Comment = '(Windows 10)'                      }
                            '393297' = @{ Version = [System.Version]'4.6'     ; Comment = '(NON Windows 10)'                  }
                            '394254' = @{ Version = [System.Version]'4.6.1'   ; Comment = '(Windows 10)'                      }
                            '394271' = @{ Version = [System.Version]'4.6.1'   ; Comment = '(NON Windows 10)'                  }
                            '394802' = @{ Version = [System.Version]'4.6.2'   ; Comment = '(Windows 10 Anniversary Update)'   }
                            '394806' = @{ Version = [System.Version]'4.6.2'   ; Comment = '(NON Windows 10)'                  }
                            '460798' = @{ Version = [System.Version]'4.7'     ; Comment = '(Windows 10 Creators Update)'      }
                            '460805' = @{ Version = [System.Version]'4.7'     ; Comment = '(NON Windows 10)'                  }
                            '461308' = @{ Version = [System.Version]'4.7.1'   ; Comment = '(Windows 10 Fall Creators Update)' }
                            '461310' = @{ Version = [System.Version]'4.7.1'   ; Comment = '(NON Windows 10)'                  }
                            '461808' = @{ Version = [System.Version]'4.7.0356';                                               }
                            '461814' = @{ Version = [System.Version]'4.7.2'   ;                                               }
                    };
 
                    $temp = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse;

                    $temp = $temp |
                                Get-ItemProperty -name Version, Release -EA 0 |
                                ? { $_.PSChildName -match '^(?!S)\p{L}' } |
                                Select  @{
                                            name = ".NET Framework";
                                            expression = { 
                                                $_.PSChildName
                                            } 
                                        }, 
                                        @{
                                            name = "Product"; 
                                            expression = { 
                                                $dotNet4Builds[$_.Release] 
                                            }
                                        }, 
                                        Version, 
                                        Release |
                                Sort    Version;

                    $temp | Format-Table;
                } 
                catch { 
                    Write-Host "DOTNET Runtime is not installed";
                } 
                finally {}

            #endregion DOTNETInfo
        
            #region DOTNETCoreInfo
                Write-Host "---------------------------------------------------------------------";
                try { 
                    Write-Host "DOTNET CORE INFO";
                    dotnet --info;
                } 
                catch { 
                    Write-Host "DOTNET Core Runtime is not installed";
                } 
                finally {}

            #endregion DOTNETCoreInfo

            #region JavaVerion
    	        Write-Host "---------------------------------------------------------------------";
                try { 
                    Write-Host "Java Version";
                    & cmd /c "java -version 2>&1";
                } 
                catch { 
                    Write-Host "Java is not installed";
                } 
                finally {}

            #endregion JavaVerion

            #region JavaJDKVersion
                Write-Host "---------------------------------------------------------------------";
                try { 
                    Write-Host "Java Compiler Version";
                    & cmd /c "javac -version 2>&1";
                } 
                catch { 
                    Write-Host "Java is not installed";
                } 
                finally {}

            #endregion JavaJDKVersion
	    
            #region MavenVersion
	            Write-Host "---------------------------------------------------------------------";
                try { 
                    Write-Host "Maven Version";
                    & cmd /c "mvn --version 2>&1";
                } 
                catch { 
                    Write-Host "Java is not installed";
                } 
                finally {}

            #endregion MavenVersion

        # } # PROCESS
        #End {   
        
            $Error.Clear();
            #exit 0; # to surpress any error code when running in Octopus

            Write-Host "-------------------------------------------------------------------";
            "function '{0}' - Total Duration: {1:HH:mm:ss}" -f$($MyInvocation.MyCommand), ([datetime]$((Get-Date) - ${StartTime}).Ticks) | write-host -ForegroundColor ${DebugFunctionFontColour};
            Write-Host "-------------------------------------------------------------------";
        #} #End


    }  #function 

#endregion PublicFunction

DeploymentDebuggingLogs