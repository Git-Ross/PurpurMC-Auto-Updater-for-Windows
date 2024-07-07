# Define the API endpoint
$apiUrl = "https://api.purpurmc.org/v2/purpur/1.21"
$downloadUrl = "https://api.purpurmc.org/v2/purpur/1.21/latest/download"

# Define the log file path
$logFilePath = Join-Path -Path $PSScriptRoot -ChildPath "purpur_download_log.txt"

# Function to write to the log file
function Write-Log {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - $message"
    Add-Content -Path $logFilePath -Value $logMessage
}

# Log the start of the script
Write-Log "Starting check for latest Purpur build..."

# Send a GET request to the API and parse the JSON response
$response = Invoke-RestMethod -Uri $apiUrl -Method Get

# Extract the 'latest' build number from the response
$latestBuild = $response.builds.latest

# Log the latest build number
Write-Log "Latest build number from API: $latestBuild"

# Define the download directory and file path
$downloadDir = "$PSScriptRoot\Purpur Downloads"
$jarFileName = "purpur-1.21-$latestBuild.jar"
$jarFilePath = Join-Path -Path $downloadDir -ChildPath $jarFileName

# Create the download directory if it doesn't exist
If (-Not (Test-Path -Path $downloadDir)) {
    New-Item -ItemType Directory -Path $downloadDir
    Write-Log "Created directory: $downloadDir"
}

# Get the list of existing .jar files in the download directory
$existingFiles = Get-ChildItem -Path $downloadDir -Filter "purpur-1.21-*.jar" | Select-Object -ExpandProperty Name

# Extract build numbers from existing files
$existingBuilds = $existingFiles | ForEach-Object {
    if ($_ -match "purpur-1.21-(\d+).jar") {
        [PSCustomObject]@{
            FileName = $_
            BuildNumber = [int]$matches[1]
        }
    }
}

# Log the existing build numbers
if ($existingBuilds) {
    $existingBuildsString = ($existingBuilds.BuildNumber -join ", ")
    Write-Log "Existing build numbers: $existingBuildsString"
} else {
    Write-Log "No existing builds found."
}

# Determine if the latest build is newer than any existing builds
$latestIsNewer = if ($existingBuilds) { $latestBuild -gt ($existingBuilds | Measure-Object -Property BuildNumber -Maximum).Maximum } else { $true }

if ($latestIsNewer) {
    Write-Log "Latest build is newer than existing builds. Proceeding with download."

    # Download the .jar file to the specified directory
    try {
        Invoke-WebRequest -Uri $downloadUrl -OutFile $jarFilePath
        Write-Log "Successfully downloaded $jarFileName to $downloadDir"
    } catch {
        Write-Log "Failed to download $jarFileName. Error: $_"
        exit 1
    }
    
    # Define the destination path with the new name
    $destFilePath = Join-Path -Path $PSScriptRoot -ChildPath "purpur.jar"
    
    # Copy the downloaded .jar file to the same directory as the script and rename it
    try {
        Copy-Item -Path $jarFilePath -Destination $destFilePath -Force
        Write-Log "Successfully copied and renamed $jarFileName to $destFilePath"
    } catch {
        Write-Log "Failed to copy and rename $jarFileName. Error: $_"
        exit 1
    }
} else {
    Write-Log "No newer build found. Latest build $latestBuild is not newer than existing builds."
}

# Remove old files, keeping only the latest 3 builds
if ($existingBuilds) {
    $filesToDelete = $existingBuilds | Sort-Object -Property BuildNumber -Descending | Select-Object -Skip 3

    foreach ($file in $filesToDelete) {
        $filePath = Join-Path -Path $downloadDir -ChildPath $file.FileName
        try {
            Remove-Item -Path $filePath -Force
            Write-Log "Deleted old build file: $filePath"
        } catch {
            Write-Log "Failed to delete old build file: $filePath. Error: $_"
        }
    }
}

# Log the end of the script
Write-Log "Completed check for latest Purpur build."
