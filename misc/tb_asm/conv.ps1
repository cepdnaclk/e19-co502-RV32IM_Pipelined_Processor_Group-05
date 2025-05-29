# Define input and output file paths
$inputFile = "riscv_asm.txt"
$outputFile = "verilog_asm.txt"

# Clear or create output file
if (Test-Path $outputFile) {
    Clear-Content $outputFile
} else {
    New-Item $outputFile -ItemType File | Out-Null
}

# Process each line
Get-Content $inputFile | ForEach-Object {
    $line = $_.Split("#")[0].Trim()  # Remove comments
    if ($line -ne "") {
        # Remove commas and split into parts
        $parts = $line -replace ",", "" -split "\s+"
        $instr = $parts[0].ToUpper()

        # Process and collect arguments with hex replacement, including negative hex
        $processedArgs = @()
        foreach ($arg in $parts[1..($parts.Length - 1)]) {
            if ($arg -match "^-0x[0-9a-fA-F]+$") {
            $processedArgs += "-32'h" + $arg.Substring(3)
            } elseif ($arg -match "^0x[0-9a-fA-F]+$") {
            $processedArgs += "32'h" + $arg.Substring(2)
            } else {
            $processedArgs += $arg
            }
        }

        $args = $processedArgs -join ", "
        $formattedLine = "        $instr($args);"
        Add-Content -Path $outputFile -Value $formattedLine
    }
}
