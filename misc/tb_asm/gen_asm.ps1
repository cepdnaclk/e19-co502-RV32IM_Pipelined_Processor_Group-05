# get the additional output file as argument -o <output_file> if -o is given
param(
    [string[]]$args
)

# Parse arguments
$outputFile = $null
for ($i = 0; $i -lt $args.Length; $i++) {
    if ($args[$i] -eq '-o' -and $i + 1 -lt $args.Length) {
        $outputFile = $args[$i + 1]
        break
    }
}

# Check if iverilog is installed
if (-not (Get-Command iverilog -ErrorAction SilentlyContinue)) {
    Write-Host "iverilog could not be found. Please install it to use this script."
    exit
}

# Run iverilog and vvp
iverilog -g2012 -o reg_file_tb reg_file.v
vvp reg_file_tb

# Process mem_contents.txt: keep lines before the first line starting with "x"
$lines = Get-Content mem_contents.txt

# Find the index of the first line starting with "x"
$firstXLine = $lines | Where-Object { $_ -match '^x' } | Select-Object -First 1
$firstXIndex = $lines.IndexOf($firstXLine)
if ($firstXIndex -ne -1) {
    # Keep lines before the first "x" line
    $lines = $lines[0..($firstXIndex - 1)]
}
$mem_block = $lines | Where-Object { $_.Trim() -ne "" }

Write-Host "Generated hex :"
Write-Host "-------------------------------------"

# open reg_file.v as text
$reg_file = Get-Content reg_file.v

# find the line after the first line containing "initial begin"
$initialBeginLine = $reg_file | Where-Object { $_ -match 'initial begin' } | Select-Object -First 1
$initialBeginIndex = $reg_file.IndexOf($initialBeginLine) + 1

# Select non-empty lines between "initial begin" and the next "end"
$endLine = $reg_file[$initialBeginIndex..($reg_file.Count - 1)] | Where-Object { $_ -match 'end' } | Select-Object -First 1
$endIndex = $reg_file.IndexOf($endLine)
$reg_block = $reg_file[$initialBeginIndex..($endIndex - 1)] | Where-Object { $_.Trim() -ne "" }

# write reg_block to host
# $reg_block | ForEach-Object { Write-Host $_ }
# write mem_block to host
# $mem_block | ForEach-Object { Write-Host $_ }

# set up 2 iterators
$reg_block_len = $reg_block.Count
$mem_block_len = $mem_block.Count

$j = 0

# loop through mem_block
for ($i = 0; $i -lt $mem_block_len; $i++) {
    # get the current line
    $line = $mem_block[$i]

    # if the current $reg_block[$j] contains "Label(" then skip until the next line which does not
    while ($reg_block[$j] -match 'Label\(') {
        # get current line as j and trim white space and trailing ;
        $reg_block[$j] = $reg_block[$j].Trim()
        $reg_block[$j] = $reg_block[$j].TrimEnd(';')
        Write-Host "    $($reg_block[$j])"
        $j++
        if ($j -ge $reg_block_len) {
            break
        }
    }

    # write the line to host
    Write-Host "$($i * 4)`t|`t$line ;`t$($reg_block[$j])"

    # increment j
    $j++
}


if ($outputFile) {
    # If -o option is provided, write to the specified file
    $lines | Set-Content -Path $outputFile
} else {
    # Otherwise, write to the default file
    $lines | Set-Content -Path "mem_contents.hex"
}

# clean up
Remove-Item reg_file_tb
Remove-Item mem_contents.txt