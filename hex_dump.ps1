foreach ($fname in @("image1.catrobat-image", "image2.catrobat-image", "img.catrobat-image")) {
    $path = "C:\Users\amitm\Desktop\New folder\$fname"
    $bytes = [System.IO.File]::ReadAllBytes($path)
    Write-Host "=== $fname (size: $($bytes.Length)) ==="
    Write-Host "First 100 bytes (hex):"
    $hexLine = ""
    for ($i = 0; $i -lt 100 -and $i -lt $bytes.Length; $i++) {
        $hexLine += "{0:X2} " -f $bytes[$i]
        if (($i + 1) % 16 -eq 0) {
            Write-Host ("  {0:D4}: {1}" -f ($i - 15), $hexLine)
            $hexLine = ""
        }
    }
    if ($hexLine -ne "") {
        $padI = [math]::Floor(($i-1) / 16) * 16
        Write-Host ("  {0:D4}: {1}" -f $padI, $hexLine)
    }
    Write-Host ""
}
