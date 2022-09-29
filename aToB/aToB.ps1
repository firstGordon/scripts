$file=$args[0]
$fileB=$args[1]
$wfile='tempA.csv'
$wfileB='tempB.csv'
$exportfile=$file
$exportheader="Testdefinition;Bla;Bla"

$header = 'Testdefinition', 'Bla1', 'Bla2'

Get-Content $file | select -Skip 1 | Set-Content $wfile
Get-Content $fileB | select -Skip 1 | Set-Content $wfileB

#$search="Simone"
#Write-Host $search
#$linenumber= Get-Content $file | select-string $search
#Write-Host $linenumber.LineNumber


$csvA = Import-Csv $wfile -Delimiter ";" -Header $header
$csvB = Import-Csv $wfileB -Delimiter ";" -Header $header

$csvA | Get-Member
$csvB | Get-Member

$csvA | Format-Table
$csvB | Format-Table


Write-Output ""
Write-Output "Sucher"
#   $csvB.Testdefinition | ForEach-Object {
#    $testSearch = "$_"
#    $csvA | Where-Object -Property Testdefinition -eq '$testSearch'
#}

#https://www.tutorialspoint.com/how-to-edit-the-csv-file-using-powershell

Set-Content $exportfile -Value $exportheader

$csvA.Testdefinition | ForEach-Object {
    Write-Output "The Testdefinition is: $_"
    $testSearch = $_
    #Write-Output $testSearch
    
    $testlinenumber = $csvB.Testdefinition | select-string $testSearch
    $testlinenumber = $testlinenumber.LineNumber
    $testlinecontent = $csvB.Testdefinition | select-string $testSearch
    
    if ($_ -eq $testlinecontent)
    {        
        Write-Output "Testline found: $testlinecontent in Line $testlinenumber"
        Write-Output "$_ = $testlinecontent"

        $testlinexport = "$_;$testlinenumber;adhoc"
                
        Write-Output $testlinexport
        $testlinexport | Add-Content -Path $exportfile       
    }    
    else
    {    
        Write-Output "Testline not found"

        $testlinexport = "$_;$testlinenumber;NULL"

        Write-Output $testlinexport
        $testlinexport | Add-Content -Path $exportfile
    }
    
    Write-Output $testlinexpor
    #$testSearch.Bla2 = $testSearch.Bla2 -split ';\s*' + ('adhoc').Where({$testSearch.$_ -eq $testlinecontent} ) -join '; '
    
    #if ($_ -eq $testlinecontent)
    #{
        #$_.'Bla2' = "adhoc"        
    #}

 
    Write-Output ""
}

Remove-Item -Path $wfile
Remove-Item -Path $wfileB


#$testlinexport | Export-Csv -Path test.csv -Delimiter ";" -NoTypeInformation
#$testlinexport | Export-Csv -Path test.csv -Delimiter ";" -NoTypeInformation












