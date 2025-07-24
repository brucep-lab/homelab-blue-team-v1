# Load baseline
$baseline = Import-Csv "C:\Scripts\baseline_processes.csv"
$baselinePaths = $baseline.Path

# Prepare output
$now = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$logPath = "C:\Scripts\anomaly_log_$now.csv"

# Get current processes
$current = Get-Process | Where-Object { $_.Path -ne $null }

# Compare and find anomalies
$anomalies = foreach ($proc in $current) {
    if (-not ($baselinePaths -contains $proc.Path)) {
        [PSCustomObject]@{
            Time       = Get-Date
            Name       = $proc.Name
            Path       = $proc.Path
            StartTime  = $proc.StartTime
        }
    }
}

# Output anomalies to file
if ($anomalies.Count -gt 0) {
    $anomalies | Export-Csv -Path $logPath -NoTypeInformation
}
