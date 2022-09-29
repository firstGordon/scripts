#######Viariables#########
$file=$args[0]
$fileB=$args[1]
$wfile='tempA.csv'
$wfileB='tempB.csv'
#$exportfile=$file
$exportfile='test.csv'
$exportheader="Testdefinition;Bla;Bla"
$header = 'Testdefinition', 'Bla1', 'Bla2'

#######Main#########

#remove header from inputfiles
Get-Content $file | Select-Object -Skip 1 | Set-Content $wfile
Get-Content $fileB | Select-Object -Skip 1 | Set-Content $wfileB

#import as csv
$csvA = Import-Csv $wfile -Delimiter ";" -Header $header
$csvB = Import-Csv $wfileB -Delimiter ";" -Header $header

$csvA | Get-Member
$csvB | Get-Member

$csvA | Format-Table
$csvB | Format-Table

#begin to compare the files
Write-Output ""
Write-Output "Searching for failed results"

#set header for exportfile
Set-Content $exportfile -Value $exportheader

$csvA.Testdefinition | ForEach-Object {
    #get testnames
    Write-Output "The Testdefinition is: $_"
    $testSearch = $_
    #search testnames
    $testlinenumber = $csvB.Testdefinition | select-string $testSearch
    $testlinenumber = $testlinenumber.LineNumber
    $testlinecontent = $csvB.Testdefinition | select-string $testSearch
    #compare testnames
    if ($_ -eq $testlinecontent)
    {
        Write-Output "Testline found: $testlinecontent in Line $testlinenumber"
        Write-Output "$_ = $testlinecontent"
        #build new row with "adhoc" qualifier
        $testlinexport = "$_;$testlinenumber;adhoc"

        Write-Output $testlinexport
        #add new row with "adhoc" qualifier to csv
        $testlinexport | Add-Content -Path $exportfile
    }
    else
    {
        Write-Output "Testline not found"
        #build new row with no qualifier
        $testlinexport = "$_;$testlinenumber;NULL"

        Write-Output $testlinexport
        $testlinexport | Add-Content -Path $exportfile
        #add new row with no qualifier to csv
    }

    Write-Output ""
}

#read file back in fpr nice terminal output summary at the end
$exportCsv = Import-Csv $exportfile -Delimiter ";" -Header $header
$exportCsv | Format-Table

#cleanup temp files
Remove-Item -Path $wfile
Remove-Item -Path $wfileB


