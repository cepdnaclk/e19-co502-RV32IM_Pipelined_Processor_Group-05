# Open asm.txt, split each line into a list (array), and write to out.hex
# Parse command line arguments for input and output files (GCC style)
param(
    [string[]]$args
)

$inputPath = $null
$outputPath = "out.hex"

for ($i = 0; $i -lt $args.Length; $i++) {
    if ($args[$i] -eq "-o" -and ($i + 1) -lt $args.Length) {
        $outputPath = $args[$i + 1]
        $i++
    }
    elseif ($args[$i] -eq "-i" -and ($i + 1) -lt $args.Length) {
        $inputPath = $args[$i + 1]
        $i++
    }
}

if (-not $inputPath) {
    Write-Error "No input file specified."
    exit 1
}

Get-Content $inputPath | ForEach-Object {
    $fields = $_.Trim() -split '\s+'
    $fields = $fields | Where-Object { $_ -ne '' }
    # print fields as list
    if ($fields.Count -gt 0) {
        $fields = $fields | ForEach-Object { $_.Trim() }
        # if fields[1] starts with '<' print nothing
        if (-not ($fields[1] -and $fields[1].StartsWith('<'))) {
            $fields[1]
        }
    }
} | Set-Content $outputPath