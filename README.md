
# Dotfiles

## Windows Setup

### Manual Installations

- Git
- Node
- Python
- VSCode
- Google Drive
- Scoop
- VMWare Workstation Pro (Free for Personal)

### Clone Dotfiles

Clone the dotfiles repository:
```bash
git clone git@github.com:codephilip/dotfiles.git
```

### Scoop / Homebrew

Open PowerShell as Administrator and set the execution policy:
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

If running as admin is disabled, use the regular terminal:
```powershell
iwr -useb get.scoop.sh | iex
```

Update Scoop:
```powershell
scoop update
```

### SSH Setup

GitHub no longer supports password authentication. Generate an SSH key to pull down the dotfiles:

**Generate SSH Keys:**
1. Open a terminal and generate a new SSH key pair:
    ```bash
    ssh-keygen -t ed25519 -C "example@email.com"
    ```
    Follow the prompts to save the key in the default location (`~/.ssh/id_ed25519`).

**Add the SSH Key to the SSH Agent:**
1. Start the SSH agent and add your new key:
    ```bash
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    ```

**Add the SSH Key to Your GitHub Account:**
1. Copy the contents of your SSH public key to the clipboard:
    ```bash
    cat ~/.ssh/id_ed25519.pub
    ```
2. Go to GitHub and navigate to **Settings > SSH and GPG keys**.
3. Click **New SSH key**, give it a title, and paste your key into the "Key" field. Click **Add SSH key**.

**Clone the Repository Using SSH:**
```bash
git clone git@github.com:codephilip/dotfiles.git
```

### Running the Install Script

Make the install script executable:
```bash
chmod +x install.sh
```

Run the install script:
```bash
./install.sh
```

### Windows Terminal Configuration

Add Git Bash to the Profile and set up font and appearance:

```json
{
    "profiles": {
        "defaults": {
            "font": {
                "face": "Hack Nerd Font"
            }
        },
        "list": [
            {
                "commandline": "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe",
                "guid": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",
                "hidden": false,
                "name": "Windows PowerShell"
            },
            {
                "commandline": "%SystemRoot%\System32\cmd.exe",
                "guid": "{0caa0dad-35be-5f56-a8ff-afceeeaa6101}",
                "hidden": false,
                "name": "Command Prompt"
            },
            {
                "guid": "{b453ae62-4e3d-5e58-b989-0a998ec441b8}",
                "hidden": false,
                "name": "Azure Cloud Shell",
                "source": "Windows.Terminal.Azure"
            },
            {
                "guid": "{00000000-0000-0000-ba54-000000000002}",
                "name": "Git Bash",
                "commandline": "C:\Program Files\Git\bin\bash.exe",
                "icon": "C:\Program Files\Git\mingw64\share\git\git-for-windows.ico",
                "startingDirectory": "%USERPROFILE%",
                "hidden": false
            }
        ]
    }
}
```

### fzf Installation

Clone and install fzf:
```bash
git clone https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all
```

### VSCode

Managed via GitHub account sync.

### Oh My Posh

Use PowerShell as admin:

**Install Oh My Posh:**
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))
```

**Add to PATH:**
```powershell
$env:Path += ";C:\Users\user\AppData\Local\Programs\oh-my-posh\bin"
```

**Update Oh My Posh:**
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))
```

#### Fonts

Install Nerd Fonts:
```powershell
oh-my-posh font install
```

#### Themes

Configure themes:

**Edit PowerShell Profile:**
```powershell
notepad $PROFILE
```
If the profile does not exist, create it:
```powershell
New-Item -Path $PROFILE -Type File -Force
```
Add the following line:
```powershell
oh-my-posh init pwsh | Invoke-Expression
```
Reload your profile:
```powershell
. $PROFILE
```

**Change Themes:**
```powershell
oh-my-posh init pwsh --config ~/.poshthemes/montys.omp.json | Invoke-Expression
```

### Neovim Setup

**Install gcc:**
```bash
scoop install gcc
```

**Clone LazyVim Configuration:**
Make a backup of your current Neovim files:
```bash
git clone https://github.com/LazyVim/starter "${env:USERPROFILE}\.config\nvim"
Remove-Item $env:LOCALAPPDATA\nvim\.git -Recurse -Force
```

**Setting XDG_CONFIG_HOME in PowerShell Profile:**
1. Edit PowerShell Profile:
    ```powershell
    notepad $PROFILE
    ```
2. Add XDG_CONFIG_HOME Variable:
    ```powershell
    $env:XDG_CONFIG_HOME = "$HOME\.config"
    ```
3. Save and Close the profile script.
4. Restart PowerShell to apply the changes.
5. Verify the Environment Variable:
    ```powershell
    echo $env:XDG_CONFIG_HOME
    ```

**Start Neovim:**
```bash
nvim
```
Refer to the comments in the files on how to customize **LazyVim**.

**Run Neovim Verbosely:**
```bash
nvim -V3
```

**Add Neovim to PATH in `.bashrc`:**
```bash
echo 'export PATH="/c/Neovim/bin:$PATH"' >> ~/.bashrc 
source ~/.bashrc
```

### Environment Variables in Windows

**View Environment Variables:**
```powershell
Get-ChildItem Env:
echo $env:PATH
```

**Adding a Directory to PATH:**
```powershell
$env:PATH += ";C:\Path\To\Directory"
```

**Permanently Add to User PATH:**
```powershell
[System.Environment]::SetEnvironmentVariable("PATH", $env:PATH + ";C:\Path\To\Directory", [System.EnvironmentVariableTarget]::User)
```

**Permanently Add to System PATH:**
```powershell
[System.Environment]::SetEnvironmentVariable("PATH", $env:PATH + ";C:\Path\To\Directory", [System.EnvironmentVariableTarget]::Machine)
```

### Editing Environment Variables via System Properties

1. Open System Properties:
    - Press `Win + Pause/Break` or right-click on `This PC` (or `My Computer`) and select `Properties`.
    - Click on `Advanced system settings` on the left panel.
    - In the System Properties window, click on the `Environment Variables` button.

### Bash Configuration

The settings are captured in `.bashrc` and `.bash_profile`.

Note that: `.bashrc` and `.bash_profile` are not recognized as symlinks.

### WSL (Ubuntu) for Windows

The basic install is part of the install_windows.sh

```powershell
wsl --install
wsl --update

# Check WSL Version
wsl --list --verbose

# Set WSL Version for a Distribution:
# wsl --set-version <DistroName> <WSLVersion>
```

Restart computer to avoid:
```
Installing, this may take a few minutes...
WslRegisterDistribution failed with error: 0x80080005
Error: 0x80080005 Server execution failed
Press any key to continue...
```

#### Update Windows Terminal Profile:
```json
"profiles": {
    "list": [
        {
            "name": "Ubuntu",
            "source": "Windows.Terminal.Wsl",
            "startingDirectory": "//wsl$/Ubuntu/home/<Your-WSL-Username>/mnt/c/Users/<Your-Windows-Username>/<Your-Desired-Folder>"
        }
    ]
}
```

In Linux once the Installation is complete:

```bash
sudo apt update
sudo apt install tmux neovim
```

Create a separate .bashrc in WSL and add the following:
```bash
# Change to the desired directory on startup
if [ -d "/mnt/c/Users/philip/Documents" ]; then
    cd /mnt/c/Users/philip/Documents
fi
```

then source ~/.bashrc

