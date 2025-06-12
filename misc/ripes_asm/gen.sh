#!/bin/bash

# Default output file
output_path="out.hex"
input_path=""

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -i)
            input_path="$2"
            shift 2
            ;;
        -o)
            output_path="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if [[ -z "$input_path" ]]; then
    echo "No input file specified." >&2
    exit 1
fi

# Process input file
output_lines=()
while IFS= read -r line || [[ -n "$line" ]]; do
    # Trim and split the line into an array
    read -ra fields <<< "$(echo "$line" | xargs)"  # xargs trims and normalizes whitespace

    # If second field exists and does not start with '<', save it
    if [[ ${#fields[@]} -gt 1 && "${fields[1]}" != \<* ]]; then
        output_lines+=("${fields[1]}")
    fi
done < "$input_path"

# Write to output file
printf "%s\n" "${output_lines[@]}" > "$output_path"
