



function EnableUpdates {

    Param(
        [Parameter(Mandatory=$true)]
        [System.IO.Path]$csvFile
    )

    $servers = Import-csv -Path $csvFile -Encoding UTF8

    Foreach ($server in $servers) {
        if(Test-WsMan -ComputerName $server) {
            Get-Service wuauserv | Set-Service -StartupType Automatic -PassThru | Start-Service
            $server += $connectiveComputers
        }
        else {
            Write-error "Powershell could not connect to $server"
        }

        
    }
}

function CheckUsersOnline {
    process {
        foreach ($cserver in $connectiveComputers) {
            try {
                quser /server:$cserver 2>&1 | Select-Object -Skip 1 | ForEach-Object {
                    $CurrentLine = $_.Trim() -Replace '\s+',' ' -Split '\s'
                    $HashProps = @{
                        UserName = $CurrentLine[0]
                        ComputerName = $cserver
                    }
    
                    # If session is disconnected different fields will be selected
                    if ($CurrentLine[2] -eq 'Disc') {
                            $HashProps.SessionName = $null
                            $HashProps.Id = $CurrentLine[1]
                            $HashProps.State = $CurrentLine[2]
                            $HashProps.IdleTime = $CurrentLine[3]
                            $HashProps.LogonTime = $CurrentLine[4..6] -join ' '
                            $HashProps.LogonTime = $CurrentLine[4..($CurrentLine.GetUpperBound(0))] -join ' '
                    } else {
                            $HashProps.SessionName = $CurrentLine[1]
                            $HashProps.Id = $CurrentLine[2]
                            $HashProps.State = $CurrentLine[3]
                            $HashProps.IdleTime = $CurrentLine[4]
                            $HashProps.LogonTime = $CurrentLine[5..($CurrentLine.GetUpperBound(0))] -join ' '
                    }
    
                    $connectedUsers += New-Object -TypeName PSCustomObject -Property $HashProps |
                    # Select-Object -Property UserName,ComputerName,SessionName,Id,State,IdleTime,LogonTime,Error
                }
            } catch {
                New-Object -TypeName PSCustomObject -Property @{
                    ComputerName = $Computer
                    Error = $_.Exception.Message
                } | #Select-Object -Property UserName,ComputerName,SessionName,Id,State,IdleTime,LogonTime,Error
            }
            foreach ($user in $connectedUsers) {
                if($_.State = 'Disconnected') {

                }
            }

}