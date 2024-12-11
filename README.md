# Simplified Guide: Setting Up and Running the Reconnaissance Script

## Step 1: Install Golang

1. Download Go:
   ```
   wget -c https://go.dev/dl/go1.22.5.linux-amd64.tar.gz
   ```

2. Remove any existing Go installation:
   ```
   sudo rm -rf /usr/local/go
   ```

3. Extract Go to /usr/local:
   ```
   sudo tar -C /usr/local -xzf go1.22.5.linux-amd64.tar.gz
   ```

4. Set up Go environment:
   ```
   echo 'export GOROOT=/usr/local/go' >> ~/.bashrc
   echo 'export GOPATH=$HOME/go' >> ~/.bashrc
   echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$HOME/.local/bin:$PATH' >> ~/.bashrc
   source ~/.bashrc
   ```

5. Verify installation:
   ```
   go version
   ```

## Step 2: Install Required Tools

Run these commands:

```
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
```

## Step 3: make it ready 
1. Make the script executable:
   ```
   chmod +x betmenrecon.sh
   ```

## Step 4: Run the Script

1. Execute the script:
   ```
   ./betmenrecon.sh
   ```

2. Enter the target domain when prompted.

3. Confirm the domain.

4. Wait for the scan to complete.

## Step 5: View Results

- Check the terminal for a summary of findings.
- Detailed results are in the `recon_results_[domain]` directory.

## Troubleshooting

- If tools aren't found, run: `source ~/.bashrc`
- For errors, ensure all tools are installed correctly.
- Adjust thread counts in the script if performance issues occur.

## Important Note

Ensure you have permission to scan the target domain and comply with all applicable laws and regulations.
