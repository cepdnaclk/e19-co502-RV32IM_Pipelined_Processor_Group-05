# Open asm.txt, split each line into a list (array), and write to out.hex
# Parse command line arguments for input and output files (GCC style)
param(
    [string[]]$args
)

$inputPath = $null
$outputPath = "name.hex"

for ($i = 0; $i -lt $args.Length; $i++) {
    if ($args[$i] -eq "-o" -and ($i + 1) -lt $args.Length) {
        $outputPath = $args[$i + 1]
        $i++
    } elseif (-not $args[$i].StartsWith("-")) {
        $inputPath = $args[$i]
    }
}

if (-not $inputPath) {
    Write-Error "No input file specified."
    exit 1
}

Get-Content $inputPath | ForEach-Object {
    $fields = $_.Trim() -split '\s+'
    $fields = $fields | Where-Object { $_ -ne '' }
    $fields[1]
} | Set-Content $outputPath