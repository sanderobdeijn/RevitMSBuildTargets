Get-Location
$nuspecOrigFilePaths = Split-Path -Path "*.orig" -Leaf -Resolve;

$dllDirectories = Get-ChildItem -Path "" -Directory -Force -ErrorAction SilentlyContinue
$netVersions = @{'2015'="net45";'2016'="net45";'2017'="net452";'2018'="net46";'2019'="net47"}

foreach ($dllDirectoryObject in $dllDirectories)
{
    $revitversion = $dllDirectoryObject.PSChildName;
    $dllDirectoryPath = $dllDirectoryObject.FullName;
    $netVersion = $netVersions["2015"];

    foreach ($nuspecOrigFilePath in $nuspecOrigFilePaths)
    {
        Write-Host "Processing nuspec file: $nuspecOrigFilePath";
        Write-Host "Set Revit version to $RevitVersion";
   
        if(Test-Path ($nuspecOrigFilePath))
        {
            $nuspecFile = Get-Content($nuspecOrigFilePath) -Encoding utf8;

            $revitVersionSearchString = '\[RevitVersion\]';
    
            $nuspecFile = $nuspecFile -replace $revitVersionSearchString, $RevitVersion;

            $netVersionSearchString = '\[NetVersion\]';
    
            $nuspecFile = $nuspecFile -replace $netVersionSearchString, $netVersion;

            $nuspecFilePath = $nuspecOrigFilePath -replace('.orig','');
            $nuspecFilePath = $nuspecFilePath -replace('.nuspec',"-$RevitVersion.nuspec");

            $nuspecFile | Out-File ($nuspecFilePath) -Encoding utf8;
        
            Write-Host $nuspecFilePath

            nuget pack "$nuspecFilePath";
            Write-Host "File processed";

            del $nuspecFilePath;
        }
    }
}