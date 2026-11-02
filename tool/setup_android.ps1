# Patches android/ for notifications + Firebase (idempotent; safe to re-run).
#   powershell -ExecutionPolicy Bypass -File tool\setup_android.ps1
$ErrorActionPreference = 'Stop'
$manifestPath = 'android\app\src\main\AndroidManifest.xml'
if (-not (Test-Path $manifestPath)) { throw 'Run from the project root (android\ folder not found).' }

# ---- AndroidManifest.xml
$m = Get-Content $manifestPath -Raw -Encoding UTF8
if ($m -notmatch 'POST_NOTIFICATIONS') {
  $perms = @'
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
    <uses-permission android:name="android.permission.VIBRATE"/>

'@
  $m = [regex]::Replace($m, '(\s*)<application', "`n$perms    <application", 1)
}
if ($m -notmatch 'ScheduledNotificationReceiver') {
  $recv = @'
        <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
        <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED"/>
                <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
                <action android:name="android.intent.action.QUICKBOOT_POWERON"/>
                <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
            </intent-filter>
        </receiver>
        <meta-data android:name="com.google.firebase.messaging.default_notification_channel_id" android:value="munjiz_reminders"/>

'@
  $m = $m -replace '</application>', "$recv    </application>"
}
Set-Content $manifestPath $m -Encoding UTF8

# ---- app/build.gradle(.kts)
$kts = 'android\app\build.gradle.kts'
$groovy = 'android\app\build.gradle'
if (Test-Path $kts) {
  $g = Get-Content $kts -Raw -Encoding UTF8
  if ($g -notmatch 'isCoreLibraryDesugaringEnabled') {
    $g = $g -replace 'compileOptions\s*\{', "compileOptions {`n        isCoreLibraryDesugaringEnabled = true"
  }
  if ($g -notmatch 'coreLibraryDesugaring\(') {
    $g += "`n`ndependencies {`n    coreLibraryDesugaring(`"com.android.tools:desugar_jdk_libs:2.1.4`")`n}`n"
  }
  $g = $g -replace 'minSdk\s*=\s*flutter\.minSdkVersion', 'minSdk = maxOf(flutter.minSdkVersion, 23)'
  Set-Content $kts $g -Encoding UTF8
} elseif (Test-Path $groovy) {
  $g = Get-Content $groovy -Raw -Encoding UTF8
  if ($g -notmatch 'coreLibraryDesugaringEnabled') {
    $g = $g -replace 'compileOptions\s*\{', "compileOptions {`n        coreLibraryDesugaringEnabled true"
  }
  if ($g -notmatch "coreLibraryDesugaring '") {
    $g += "`n`ndependencies {`n    coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.1.4'`n}`n"
  }
  $g = $g -replace 'minSdkVersion\s+flutter\.minSdkVersion', 'minSdkVersion Math.max(flutter.minSdkVersion, 23)'
  Set-Content $groovy $g -Encoding UTF8
} else { throw 'build.gradle(.kts) not found' }

Write-Host 'Android patched. Next: flutterfire configure' -ForegroundColor Green
