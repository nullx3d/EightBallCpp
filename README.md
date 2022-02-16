# EightBallCpp

This is a C++ version of the Fortify EightBall demo application.

You will required Visual Studio 2019 or later. It may work in earlier versions but this has
not been tested. Build the application from the IDE or command line using "msbuild" and then
you can run it as follows:

```
> .\Debug\EightBall.exe am i beautiful
You have entered a question with 3 words:
Am i beautiful?
The Magic 8 Ball says:
The outlook is poor
```

You can scan the source code with Fortify using the IDE plugin or from the command line.
To scan from the command line you will need an `.env` environment file similar to the following:

```
# The URL of Software Security Center
SSC_URL=http://YOUR-SERVER_:8080/ssc
SSC_USERNAME=admin
SSC_PASSWORD=admin
# SSC Authentication Token (recommended to use CIToken)
SSC_AUTH_TOKEN=XXXX
# Name of the application in SSC
SSC_APP_NAME=EightBallCpp
# Name of the application version in SSC
SSC_APP_VER_NAME=main
FOD_API_URL=https://api.emea.fortify.com
FOD_API_KEY=XXX
FOD_API_SECRET=YYY
```

The SSC and FOD settings are only used if set the appropriate flags in the `bin\fortify-sca.ps1` file.

You should then startup a new "Developer PowerShell" from Visual Studio and enter the following:

```
.\bin\fortify-sca.ps1
```

If scanning locally you can open the resultant `EightBallCpp.fpr` with the Fortify Audit Workbench 
executable `auditworkbench`.

---

Kevin Lee - kevin.lee@microfocus.com

