function SetRecommendedSettings()
{
    $settingsFileName = "settings.json"
    $jsonFilePath = "./.vscode"
    $fullPath = [IO.Path]::Combine($jsonFilePath, $settingsFileName)
    
    $recommendedSettings = @{}
    $recommendedSettings.Add("editor.mouseWheelZoom", $true)
    
    $settingsFileExists = Test-Path $fullPath

    if(!$settingsFileExists)
    {
        $emptyJsonData = "{}"
        $fileType = "file"

        New-Item `
            -path $jsonFilePath `
            -name $settingsFileName `
            -type $fileType `
            -value $emptyJsonData `
            -Force
    }
        
    $jsonContent = Get-Content -Path $fullPath -Raw | ConvertFrom-Json
    
    Foreach($key in $recommendedSettings.Keys)
    {
        if(!($jsonContent -contains $key))
        {
            $value = $recommendedSettings.$key
            
            Add-Member `
                -InputObject $jsonContent `
                -Type NoteProperty `
                -Name $key `
                -Value $value
        }
    }
    
    $updatedJson = ConvertTo-Json -InputObject $jsonContent
    Set-Content -Value $updatedJson -Path $fullPath
}

function InstallRecommendedExtensions()
{
    code --install-extension eamodio.gitlens # Git Lens
    code --install-extension ms-vscode.vscode-node-azure-pack # Azure Tools
    code --install-extension ms-dotnettools.csdevkit # C# Dev Kit
    code --install-extension ms-azuretools.vscode-docker # Docker
    code --install-extension fudge.auto-using # Auto-Usings for C#
    code --install-extension ms-vscode.powershell # PowerShell
}

SetRecommendedSettings
InstallRecommendedExtensions
