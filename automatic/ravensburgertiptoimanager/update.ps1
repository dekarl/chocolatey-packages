import-module au

$releases = 'https://github.com/prey/prey-node-client/releases'

function global:au_SearchReplace {
   @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*\`$url\s*=\s*)('.*')"        = "`$1'$($Latest.Url32)'"
            "(?i)(^\s*\`$etag\s*=\s*)('.*')"       = "`$1'$($Latest.Etag)'"
            "(?i)(^\s*\`$checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
        }
    }
}

function global:au_GetLatest {
    $localEtag     = (Select-String -Path .\tools\chocolateyInstall.ps1 -Pattern 'etag.*''(.*)''').Matches.Groups[1].Value
    $localUrl      = (Select-String -Path .\tools\chocolateyInstall.ps1 -Pattern 'url.*''(.*)''').Matches.Groups[1].Value
    $localVersion  = (Select-String -Path .\ravensburgertiptoimanager.nuspec -Pattern 'version>(.*)<').Matches.Groups[1].Value

    # just a static url without version hosted on AWS S3
    $binaryHead = Invoke-WebRequest -Method Head -Uri $localUrl

    $remoteEtag = $binaryHead.Headers.etag
    if ($localEtag -ne $remoteEtag) {
        $filename = [System.IO.Path]::GetTempFileName()
        Invoke-WebRequest $localUrl -OutFile $filename -UseBasicParsing
        $remoteChecksum32 = (Get-FileHash $filename -Algorithm sha256).Hash
        $remoteVersion = (Get-Item $filename).VersionInfo.ProductVersion
        rm $filename -ea ignore

        return @{
            Checksum32 = $remoteChecksum32.ToLower()
            Etag       = $remoteEtag
            Url32      = $localUrl
            Version    = $remoteVersion
        }
    }
    else {
        return 'ignore'
    }
}

update -ChecksumFor 32