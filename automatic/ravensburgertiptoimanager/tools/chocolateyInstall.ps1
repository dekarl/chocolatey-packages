$url = 'http://static.tiptoi.com/software/windows/install.exe'
$etag = 'generate etag'
$checksum = 'generate checksum'

$packageArgs = @{
    packageName = 'ravensburgertiptoimanager'
    fileType = 'exe'
    url = $url
    checksum = $checksum
    checksumType = 'sha256'
#    url64 = $url
#    checksum64 = $checksum
#    checksumType64 = 'sha256'
    silentArgs = '-q'
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
