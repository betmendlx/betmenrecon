#!/bin/bash

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored text
print_color() {
    printf "${!1}%s${NC}\n" "$2"
}

# Function to sanitize domain input
sanitize_domain() {
    echo "$1" | sed -e 's/^https\?:\/\///' -e 's/\.txt$//' -e 's/\/$//'
}

# Function to run command in background and display spinner
run_background() {
    local cmd="$1"
    local output_file="$2"
    local pid_file="${output_file}.pid"
    
    eval "$cmd" > "$output_file" 2>&1 & echo $! > "$pid_file"
    
    local pid=$(cat "$pid_file")
    local spin='-\|/'
    local i=0
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf "\r[${spin:$i:1}] Running..."
        sleep .1
    done
    printf "\r[✓] Done!     \n"
    rm "$pid_file"
}

# Main script
print_color "BLUE" "===== High-Performance Reconnaissance Script ====="

# Prompt for domain
read -p "$(print_color "YELLOW" "Enter the target domain (without http/https): ")" input_domain

# Sanitize the input
domain=$(sanitize_domain "$input_domain")

# Confirm with user
print_color "YELLOW" "Sanitized domain: $domain"
read -p "Is this correct? (y/n): " confirm

if [[ $confirm != [yY] ]]; then
    print_color "RED" "Exiting script. Please run again with the correct domain."
    exit 1
fi

output_dir="recon_results_${domain}"
mkdir -p "$output_dir"
output_file="${output_dir}/results-${domain}.txt"

# Subfinder (run in background)
print_color "GREEN" "\nRunning subfinder..."
run_background "subfinder -d $domain -silent" "${output_dir}/subdomains.txt"

# httpx (run in background)
print_color "GREEN" "\nRunning httpx..."
run_background "cat ${output_dir}/subdomains.txt | httpx -silent -threads 50" "${output_dir}/live_subdomains.txt"

# nuclei (run in background)
print_color "GREEN" "\nRunning nuclei..."
run_background "cat ${output_dir}/live_subdomains.txt | nuclei -silent -c 50 -s critical,high,medium,low" "$output_file"

print_color "BLUE" "\n===== Reconnaissance Complete ====="
print_color "GREEN" "Final results saved in $output_file"

# Display summary of findings
if [ -s "$output_file" ]; then
    critical=$(grep -c "critical" "$output_file")
    high=$(grep -c "high" "$output_file")
    medium=$(grep -c "medium" "$output_file")
    low=$(grep -c "low" "$output_file")

    print_color "YELLOW" "\nSummary of findings:"
    print_color "RED" "Critical: $critical"
    print_color "RED" "High: $high"
    print_color "YELLOW" "Medium: $medium"
    print_color "GREEN" "Low: $low"

    # Display the contents of the output file (only vulnerabilities)
    print_color "BLUE" "\nDetected vulnerabilities:"
    grep -E "critical|high|medium|low" "$output_file"
else
    print_color "RED" "No results found in $output_file. Please check the files in $output_dir for more information."
fi

print_color "GREEN" "\nAll results are saved in the '$output_dir' directory."
