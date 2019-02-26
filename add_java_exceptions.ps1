$check = $false
$file = "C:\Windows\Sun\Java\Deployment\exception.sites"
$list = Get-Content .\exceptions.txt

$javaConfig = "C:\Windows\Sun\Java\Deployment\deployment.properties"
$javaExceptionSetting = "deployment.user.security.exception.sites=c\:/windows/sun/java/deployment/exception.sites"


if (!(Test-Path "c:\Windows\Sun\Java\Deployment\")) {
    New-Item -ItemType directory -Path c:\Windows\Sun\Java\Deployment\
}
if (!(Test-Path "c:\Windows\Sun\Java\Deployment\deployment.config")) {
		xcopy deployment.config c:\Windows\Sun\Java\Deployment\ /I /Y
}
if (!(Test-Path "c:\Windows\Sun\Java\Deployment\deployment.properties")) {
		xcopy deployment.properties c:\Windows\Sun\Java\Deployment\ /I /Y
}
if (!(Test-Path "c:\Windows\Sun\Java\Deployment\exception.sites")) {
		xcopy exception.sites c:\Windows\Sun\Java\Deployment\ /I /Y
}


ForEach ($line in $list) {
    $check = $false
    Get-Content $file | foreach {
        
        if ($_ -eq $line) {
            $check = $true
        }
    
    }
    if ($check -eq $false) {
        Add-Content $file -Value ($line) -PassThru
    }
}

$f = Get-Content $file
$lineno = ($f) -match '\Dhttp'
if ($lineno -ne $null) {
    $a = $lineno -replace "http://", "`r`nhttp://"
    $b = ($f -replace $lineno, $a).Trim()
    $b | set-content $file
}


$javaconfigContent = Get-Content $javaConfig
if ($javaconfigContent | Select-String -Pattern "deployment.user.security.exception.sites") {
    $javaconfigContent | foreach {
        if ($_ -like "*deployment.user.security.exception.sites*") {
            
            if ($_ -eq $javaExceptionSetting) {

                $changejavaSetting = $false
            } else {
                $a = ($javaConfigContent).replace($_, $javaExceptionSetting) 
                $changejavaSetting = $true
            }
        }
    }
} else {
    $javaConfigContent += $javaExceptionSetting
    $a = $javaConfigContent
    $changejavaSetting = $true
}

if ($changejavaSetting = $true) {
        $a | Set-Content $javaConfig
}

