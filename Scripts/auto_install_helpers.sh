#!/bin/bash

# Define the URL of the helper_functions.sh file on GitHub
HELPER_FILE_URL="https://raw.githubusercontent.com/h3nryza/tools/main/scripts/helper_functions.sh"

# Define the location of the helper_functions.sh file on the local machine
LOCAL_HELPER_FILE="$HOME/.helper_functions.sh"

# Download the helper_functions.sh file from GitHub
echo "Downloading helper_functions.sh from GitHub..."
curl -o "$LOCAL_HELPER_FILE" -s "$HELPER_FILE_URL"

if [ $? -ne 0 ]; then
  echo "Failed to download helper_functions.sh."
  exit 1
fi

echo "Successfully downloaded helper_functions.sh to $LOCAL_HELPER_FILE"

# Detect whether the user is using Zsh or Bash and insert the appropriate source line
SHELL_CONFIG=""

if [ -n "$ZSH_VERSION" ]; then
  SHELL_CONFIG="$HOME/.zshrc"
  echo "Detected Zsh shell."
elif [ -n "$BASH_VERSION" ]; then
  SHELL_CONFIG="$HOME/.bashrc"
  echo "Detected Bash shell."
else
  echo "Could not detect Bash or Zsh. Please add the following manually to your shell configuration file:"
  echo "source ~/.helper_functions.sh"
  exit 1
fi

# Check if the source command is already present in the shell config file
if ! grep -q "source ~/.helper_functions.sh" "$SHELL_CONFIG"; then
  echo "Inserting source command into $SHELL_CONFIG..."
  echo "if [ -f ~/.helper_functions.sh ]; then" >> "$SHELL_CONFIG"
  echo "  source ~/.helper_functions.sh" >> "$SHELL_CONFIG"
  echo "fi" >> "$SHELL_CONFIG"
else
  echo "source command already exists in $SHELL_CONFIG."
fi

# Add the manual reload function to the shell config file if it doesn't exist
if ! grep -q "load_helpers" "$SHELL_CONFIG"; then
  echo "Adding load_helpers function to $SHELL_CONFIG..."
  cat <<EOL >> "$SHELL_CONFIG"

# Function to manually reload the helper functions
load_helpers() {
  if [ -f ~/.helper_functions.sh ]; then
    source ~/.helper_functions.sh
    echo "Helper functions reloaded."
  else
    echo "helper_functions.sh file not found."
  fi
}
EOL
else
  echo "load_helpers function already exists in $SHELL_CONFIG."
fi

# Reload the shell configuration to make the helper functions available immediately
echo "Reloading $SHELL_CONFIG..."
source "$SHELL_CONFIG"

echo "Setup complete! Helper functions are ready to use."
