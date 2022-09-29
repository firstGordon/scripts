$fileA=$args[0]
$fileB=$args[1]
# Get the file hashes
$hashSrc = Get-FileHash -Path $fileA -Algorithm "SHA256"
$hashDest = Get-FileHash -Path $fileB -Algorithm "SHA256"

# Compare the hashes & note this in the log
If ($hashSrc.Hash -ne $hashDest.Hash)
{
  Add-Content -Path $fileA -Value " Source File Hash: $hashSrc does not equal Existing Destination File Hash: $hashDest the files are NOT EQUAL."
}