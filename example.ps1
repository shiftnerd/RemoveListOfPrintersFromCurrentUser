if (-not (Get-Module -Name 'RunAsUser')) {
    Install-Module RunAsUser
}

Import-Module RunAsUser
$scriptblock = { 
    $printersList = @('Canon iPF785 (Color Plotter)', 'Canon iR-ADV 4245 (B_W)', 'Canon iR-ADV 4545 (B_W)', 'Canon iR-ADV C7570 (Color)', 'Canon iR-ADV C7770i-N2 PSV1.0US', 'Oce PlotWave 450')
    $printersList | ForEach-Object -Begin {
        $printersMapped = Get-Printer
    } -Process {
        if ($_ -in $printersMapped.Name) {
            Write-Verbose -Message "$_ exists, removing"
            Remove-Printer -ConnectionName ('\\TMP-FILE-01\' + $_)
        }
        else {
            Write-Verbose -Message "Printer $_ does not exist"
        }
    }
}

invoke-ascurrentuser -scriptblock $scriptblock -NoWait -CacheToDisk
