<#                                
 ____  _
|  _ \(_)___  ___ _____   _____ _ __
| | | | / __|/ __/ _ \ \ / / _ \ '__|
| |_| | \__ \ (_| (_) \ V /  __/ |      2.profile_include.ps1
|____/|_|___/\___\___/ \_/ \___|_|      v1.0 | 26th-March-2023

 _____                 _   _
|  ___|   _ _ __   ___| |_(_) ___  _ __  ___
| |_ | | | | '_ \ / __| __| |/ _ \| '_ \/ __|
|  _|| |_| | | | | (__| |_| | (_) | | | \__ \
|_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
                                                                
.SYNOPSIS
    Script to include other PowerShell scripts 
.DESCRIPTION
    Execute the script_files that are 'included' using this 'discover_functions.ps1' script
.NOTES
    AUTHOR
        - Sanjeev Stephan Murmu
    SCRIPT
        - discover_functions.ps1
    VERSION
        - v1.0    
        
#-----------------------------------------------------#>

param (
  [int]$directory_index=4
)

$json_filename               = $Directory_JSON.info.file
$autodiscover_this_directory = ReadJsonPath($Directory_JSON.profile[$directory_index].path)
$ascii_path                  = ReadJsonPath($Directory_JSON.profile[$directory_index].ascii)
$title                       = $Directory_JSON.profile[$directory_index].title
$directory_short_path        = $Directory_JSON.profile[$directory_index].path
$directory_title             = Split-Path -Leaf $autodiscover_this_directory 
$no_of_files_included        = 0

if(Test-Path $autodiscover_this_directory)
{
    Write-Host "|    |          |        |    ├ FOUND ] Directory : $autodiscover_this_directory" -ForegroundColor Yellow
    Write-Host "|    |          |        |    ├ STARTED ] Auto Discovery of $title Scripts in the Directories { $directory_title } " -ForegroundColor White   
    Write-Host "|    |          |        |    ├ LOADING-ALL ] The {*.ps1} in the { $directory_short_path } " -ForegroundColor Cyan

    # Get all the *.ps1 files in the "dependency" directory
    $dependency_files = Get-ChildItem -Path $autodiscover_this_directory -Filter "*.ps1" | Select-Object -ExpandProperty FullName

    Write-Debug "Directory Dependency : $autodiscover_this_directory"
    # Loop through each dependency file and include it in the profile
    foreach ($path in $dependency_files) {
        if (Test-Path $path) {

            $no_of_files_included = $no_of_files_included + 1
            Write-Host "|    |          |        |    ├ OK ] $title : $(Split-Path -Leaf $path)" -ForegroundColor Green -BackgroundColor Black
            . $path
        } else {
            Write-Host "|    |          |        |    ├ Missing $(Split-Path -Leaf $path) at path $path" -ForegroundColor Red
        }
    }
    
    ## Check the Number of Files have been discovered and display output accordingly
    if($no_of_files_included -eq 0) 
    {      Write-Host "|    |          |        |    └────[ FAILED ] No Files Have been Discovered in { $directory_title }" -ForegroundColor Red  }
    else { Write-Host "|    |          |        |    └────[ SUCCESS ] Total { $no_of_files_included } Scripts have been Successfully Discovered in { $directory_title }" -ForegroundColor Green }
           Write-Host "|    |          |        |  " -ForegroundColor Green
} else { Write-Error "$title directory path is empty : $autodiscover_this_directory"} 
