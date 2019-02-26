function Copy-model
{
    Param($AxModel, $Source, $Destination)

    Write-Host "Installing model" $AxModel

    $SourcePath = Join-Path $Source $AxModel
    $DestinationPath = Join-Path $Destination $AxModel

    robocopy $SourcePath $DestinationPath /S /PURGE /NFL /NDL /NJH /NJS
}

function Test-Administrator  
{  
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    
    return (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function Get-MetadataPath
{
    Param([string]$ServiceName)

    $MetadataPath = Get-AX7SdkDeploymentMetadataPath
    
    if ([string]::IsNullOrEmpty($MetadataPath) -eq $true)
    {
        if (-Not (Test-Administrator))
        {
            Write-Warning "it is necessary to run this as Administrator"
            Read-Host -Prompt "Press Enter to continue"
            exit            
        }

        Set-AX7SdkRegistryValuesFromAosWebConfig $ServiceName
        $MetadataPath = Get-AX7SdkDeploymentMetadataPath
    }

    return $MetadataPath
}

Clear-Host

if ([string]::IsNullOrEmpty($env:DynamicsSDK) -eq $true)

{
    Write-Warning "DynamicsSDK value is not properly set up"
    Read-Host -Prompt "Press Enter to continue"
    exit
}

Import-Module (Join-Path -Path $env:DynamicsSDK -ChildPath "DynamicsSDKCommon.psm1") -Force

$AosServiceName = Get-AX7SdkDeploymentAosWebsiteName
if ([string]::IsNullOrEmpty($AosServiceName) -eq $true)
{
    Write-Warning "AosWebsiteName value is not properly set up"
    Read-Host -Prompt "Press Enter to continue"
    exit
}

$MetadataPath = Get-MetadataPath $AosServiceName
if ([string]::IsNullOrEmpty($MetadataPath) -eq $true)
{
    Write-Warning "AosWebsiteName value is not properly set up"
    Read-Host -Prompt "Press Enter to continue"
    exit
}


$Models = "ProductFlavor", "ProductFlavorIntegration"

foreach ($Model in $Models)
{
    Copy-model $Model $PSScriptRoot $MetadataPath
}

Read-Host -Prompt "Press Enter to continue"