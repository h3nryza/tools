# How to install helper scripts

Save this script as helper_functions.sh and place it in your home directory:
```
~/.helper_functions.sh
```

Add the following line to your .bashrc or .zshrc to load the script:
```
if [ -f ~/.helper_functions.sh ]; then
  source ~/.helper_functions.sh
fi
```

Reload your shell configuration:
```
source ~/.bashrc  # For Bash
source ~/.zshrc   # For Zsh
```

# Auto-magically install the tools
curl -s https://raw.githubusercontent.com/h3nryza/tools/main/scripts/auto_helper_installer_script.sh | bash