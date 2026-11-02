# Regenerates the padded splash logos. Usage (from project root):
#   powershell -ExecutionPolicy Bypass -File tool\make_splash.ps1 [-Ratio 0.6] [-Ratio12 0.5]
param([double]$Ratio = 0.60, [double]$Ratio12 = 0.50)
Add-Type -AssemblyName System.Drawing
$src = [System.Drawing.Image]::FromFile("$PWD\assets\images\app_icon.png")
function New-Splash($name, $canvas, $ratio) {
  $bmp = New-Object System.Drawing.Bitmap $canvas, $canvas
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.Clear([System.Drawing.Color]::White)
  $g.InterpolationMode = 'HighQualityBicubic'
  $size = [int]($canvas * $ratio)
  $pos = [int](($canvas - $size) / 2)
  $g.DrawImage($src, $pos, $pos, $size, $size)
  $bmp.Save("$PWD\assets\images\$name", [System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose(); $bmp.Dispose()
}
New-Splash "splash_logo.png" 1024 $Ratio
New-Splash "splash_logo_android12.png" 1152 $Ratio12
$src.Dispose()
dart run flutter_native_splash:create
