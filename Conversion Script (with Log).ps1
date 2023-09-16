$sox = "C:\Program Files (x86)\sox-14-4-2\sox.exe"
$flac_files = Get-ChildItem -Filter *.flac

New-Item -ItemType Directory -Force -Path ".\converted"

$logFilePath = "converted\downsample.txt"

foreach ($file in $flac_files) {
    $flacInfo = & $sox --i $file.FullName 2>&1

    if ($flacInfo -match "Precision\s*:\s*24-bit" -and ($flacInfo -match "Sample Rate\s*:\s*96000" -or $flacInfo -match "Sample Rate\s*:\s*192000")) {
        & $sox -S $file.FullName -R -G -b 16 "converted\$($file.Name)" rate -v -L 48000 dither
        $logMessage = "Downsampled using SoX v14.4.2: $($file.Name) -R -G -b 16 $($file.Name) rate -v -L 48000 dither`n"
        Add-Content -Path $logFilePath -Value $logMessage
    }
    elseif ($flacInfo -match "Precision\s*:\s*24-bit" -and ($flacInfo -match "Sample Rate\s*:\s*88200" -or $flacInfo -match "Sample Rate\s*:\s*176400")) {
        & $sox -S $file.FullName -R -G -b 16 "converted\$($file.Name)" rate -v -L 44100 dither
        $logMessage = "Downsampled using SoX v14.4.2: $($file.Name) -R -G -b 16 $($file.Name) rate -v -L 44100 dither`n"
        Add-Content -Path $logFilePath -Value $logMessage
    }
    elseif ($flacInfo -match "Precision\s*:\s*24-bit" -and ($flacInfo -match "Sample Rate\s*:\s*44100" -or $flacInfo -match "Sample Rate\s*:\s*48000")) {
        & $sox -S $file.FullName -R -G -b 16 "converted\$($file.Name)" dither
        $logMessage = "Downsampled using SoX v14.4.2: $($file.Name) -R -G -b 16 $($file.Name) dither`n"
        Add-Content -Path $logFilePath -Value $logMessage
    }
}

Read-Host "Press Enter to continue..."
