Get-Process | Select-Object Name, Path, StartTime |
    Where-Object { $_.Path -ne $null } |
    Sort-Object Name |
    Export-Csv -Path "C:\Scripts_For_Github\baseline_processes.csv" -NoTypeInformation