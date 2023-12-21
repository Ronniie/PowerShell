# Source path where the folders to be copied are located
$sourcePath = "\\ip_to_your_server_or_dir\"

# Destination path where folders will be copied to
$destinationPath = "D:\"

# Folders to copy
$foldersToCopy = @("Archive", "Test", "Test2")

# Folders to exclude from copying
$excludedFolders = @("Media", "zip")

# Iterate through each folder in the list
foreach ($folder in $foldersToCopy) {
    # Check if the current folder is not in the list of excluded folders
    if ($excludedFolders -notcontains $folder) {
        # Create the source and destination paths for the current folder
        $source = Join-Path -Path $sourcePath -ChildPath $folder
        $destination = Join-Path -Path $destinationPath -ChildPath $folder

        # Copy the contents of the source folder to the destination folder recursively and forcefully
        Copy-Item -Path $source -Destination $destination -Recurse -Force
    }
}

# End of the script
