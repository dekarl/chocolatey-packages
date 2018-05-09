$packageName = 'ravensburgertiptoimanager' 
$fileType = 'exe'
$url = 'http://static.tiptoi.com/software/windows/install.exe' 
$url64 = $url 
$silentArgs = '-q' 
$validExitCodes = @(0) 

try {

Install-ChocolateyPackage $packageName $fileType $silentArgs $url

    Write-ChocolateySuccess "$packageName"
} catch {
    Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
    throw
}