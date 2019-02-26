$checkExceptions = $true
$checkConfig = $false
$file = "C:\Windows\Sun\Java\Deployment\exception.sites"

#list of servers
#edit below
$list = @(
"http://server1", "http://server2")

#do not change this
$javaConfig = "C:\Windows\Sun\Java\Deployment\deployment.properties"
$javaExceptionSetting = "deployment.user.security.exception.sites=c\:/windows/sun/java/deployment/exception.sites"

$f = Get-Content $file 
foreach ($line in $list) {
    $containsWord = $f | %{$_ -match $line}
    If(!($containsWord -contains $true)) {
        $checkExceptions = $false
        break
    }
}
if ($f -match '\Dhttp') { $checkExceptions = $false}

Get-Content $javaConfig | foreach {
    if ($_ -eq $javaExceptionSetting) {
         $checkConfig = $true
    } else {
        $checkConfig = $false
    }
}

if ($checkExceptions -eq $true -and $checkConfig -eq $true) {
        write-host "ok"
}