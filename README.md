# orphanarium
Powershell Script for removing orphaned index files generated by Symantec DLP

#### Instructions:
#### 1. Run the Script
#### 2. Provide the Symantec DLP DEBUG logs folder, e.g. C:\ProgramData\Symantec\DataLossPrevention\EnforceServer\15.5\logs\debug
#### 3. Provide the ServerPlatformCommon index folder path, e.g. C:\ProgramData\Symantec\DataLossPrevention\ServerPlatformCommon\15.5\index
#### 4. Script will run regex on the FileReader logs and pull out any orphaned index files
#### 5. Answer 'Yes' to proceed with the script removing these items, or 'No' to exit the script