#
# Example script to perform Fortify SCA static analysis
#

# Import some supporting functions
Import-Module $PSScriptRoot\modules\FortifyFunctions.psm1

# Import local environment specific settings
$EnvSettings = $(ConvertFrom-StringData -StringData (Get-Content ".\.env" | Where-Object {-not ($_.StartsWith('#'))} | Out-String))
$AppName = $EnvSettings['SSC_APP_NAME']
$AppVersion = $EnvSettings['SSC_APP_VER_NAME']
$SSCUrl = $EnvSettings['SSC_URL']
$SSCAuthToken = $EnvSettings['SSC_AUTH_TOKEN'] # CIToken
$ScanSwitches = "-Dcom.fortify.sca.follow.imports=true"
$UseMSBuild = $True
$UseFOD = $False

# Test we have Fortify installed successfully
Test-Environment
if ([string]::IsNullOrEmpty($AppName)) { throw "Application Name has not been set" }

# Run the translation and scan

Write-Host Running translation...
if ($UseMSBuild -eq $True) {
    & sourceanalyzer '-Dcom.fortify.sca.ProjectRoot=.fortify' $ScanSwitches -b "$AppName" `
    -verbose MSBuild EightBall.sln /p:Configuration="Debug" /p:Platform="Win32" /target:"rebuild"
} else {
    & sourceanalyzer '-Dcom.fortify.sca.ProjectRoot=.fortify' $ScanSwitches -b "$AppName" `
        -verbose CL.exe /c /ZI /nologo /W3 /WX- /diagnostics:column /Od /Oy- /D WIN32 /D _DEBUG `
        /D _CONSOLE /D _UNICODE /D UNICODE /EHsc /RTC1 /MDd /GS /fp:precise /Zc:wchar_t /Zc:forScope `
        /Zc:inline /Yc"stdafx.h" /Fp"Debug\EightBall.pch" /Fo"Debug\\" /Fd"Debug\vc142.pdb" `
        /external:W3 /Gd /TP /analyze- /FC /errorReport:queue stdafx.cpp
    & sourceanalyzer '-Dcom.fortify.sca.ProjectRoot=.fortify' $ScanSwitches -b "$AppName" `
        -verbose CL.exe /c /ZI /nologo /W3 /WX- /diagnostics:column /Od /Oy- /D WIN32 /D _DEBUG `
        /D _CONSOLE /D _UNICODE /D UNICODE /EHsc /RTC1 /MDd /GS /fp:precise /Zc:wchar_t /Zc:forScope `
        /Zc:inline /Yc"stdafx.h" /Fp"Debug\EightBall.pch" /Fo"Debug\\" /Fd"Debug\vc142.pdb" `
        /external:W3 /Gd /TP /analyze- /FC /errorReport:queue Shell.cpp
    & sourceanalyzer '-Dcom.fortify.sca.ProjectRoot=.fortify' $ScanSwitches -b "$AppName" `
        -verbose CL.exe /c /ZI /nologo /W3 /WX- /diagnostics:column /Od /Oy- /D WIN32 /D _DEBUG `
        /D _CONSOLE /D _UNICODE /D UNICODE /EHsc /RTC1 /MDd /GS /fp:precise /Zc:wchar_t /Zc:forScope `
        /Zc:inline /Yc"stdafx.h" /Fp"Debug\EightBall.pch" /Fo"Debug\\" /Fd"Debug\vc142.pdb" `
        /external:W3 /Gd /TP /analyze- /FC /errorReport:queue Eightball.cpp
}

if ($UseFOD -eq $True) {
    Write-Host Creating Mobile Build session
    & sourceanalyzer '-Dcom.fortify.sca.ProjectRoot=.fortify' -b "$AppName" -verbose -export-build-session "$($AppName).mbs"
    Compress-Archive -Path "$($AppName).mbs" -Force -DestinationPath FoDPackage.zip
    Write-Host Zip file FoDPackage.zip can now be uploaded to FOD...
} else {
    Write-Host Running scan...
    & sourceanalyzer '-Dcom.fortify.sca.ProjectRoot=.fortify' $ScanSwitches -b "$AppName" -verbose `
        -build-project "$AppName" -build-version "$AppVersion" -build-label "SNAPSHOT" -scan -f "$($AppName).fpr"

    # summarise issue count by analyzer
    & fprutility -information -analyzerIssueCounts -project "$($AppName).fpr"

    Write-Host Generating PDF report...
    & ReportGenerator '-Dcom.fortify.sca.ProjectRoot=.fortify' -user "Demo User" -format pdf -f "$($AppName).pdf" -source "$($AppName).fpr"

    #if (![string]::IsNullOrEmpty($SSCUrl)) {
    #    Write-Host Uploading results to SSC...
    #    & fortifyclient uploadFPR -file "$($AppName).fpr" -url $SSCUrl -authtoken $SSCAuthToken -application $AppName -applicationVersion $AppVersion
    #}
}

Write-Host Done.
