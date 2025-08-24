# Network Diagnostic Tool - PowerShell
# Author: Alfred
# GitHub: https://github.com/alfredx777
# Description: Quickly test and log common network issues.

function Show-Menu {
    Clear-Host
    Write-Host "===================="
    Write-Host " Network Diagnostic Tool"
    Write-Host "===================="
    Write-Host "1. Run Ping Test"
    Write-Host "2. Check DNS Resolution"
    Write-Host "3. Show IP Configuration"
    Write-Host "4. Save Full Diagnostic Report"
    Write-Host "5. Exit"
}

function Run-PingTest {
    Write-Host "`nRunning Ping Test..."
    $hosts = @("8.8.8.8", "1.1.1.1", "google.com")
    foreach ($h in $hosts) {
        Test-Connection -ComputerName $h -Count 2 -Quiet | Out-File -Append network_log.txt
        Write-Host "Pinged $h"
    }
}

function Check-DNS {
    Write-Host "`nChecking DNS Resolution..."
    Resolve-DnsName google.com | Out-File -Append network_log.txt
    Resolve-DnsName microsoft.com | Out-File -Append network_log.txt
    Write-Host "DNS check complete."
}

function Show-IPConfig {
    Write-Host "`nIP Configuration:"
    Get-NetIPAddress | Format-Table
    Get-NetIPAddress | Out-File -Append network_log.txt
}

function Save-FullReport {
    Write-Host "`nSaving full report to network_report.txt..."
    "=== Network Diagnostic Report ===" | Out-File network_report.txt
    ipconfig /all | Out-File -Append network_report.txt
    Test-Connection google.com -Count 2 | Out-File -Append network_report.txt
    Resolve-DnsName google.com | Out-File -Append network_report.txt
    Get-NetAdapter | Out-File -Append network_report.txt
    Write-Host "Report saved as network_report.txt"
}

do {
    Show-Menu
    $choice = Read-Host "Enter your choice"
    switch ($choice) {
        "1" { Run-PingTest }
        "2" { Check-DNS }
        "3" { Show-IPConfig }
        "4" { Save-FullReport }
        "5" { exit }
        default { Write-Host "Invalid option, try again." }
    }
    Pause
} while ($true)
