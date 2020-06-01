#!/usr/bin/env bash

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Set up the config file
cat > ~/.zshrc <<EOF
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="avit"

export PATH="$HOME/.local/bin:$HOME/.rbenv/bin:/opt/flutter/bin:$PATH"
export SDKMAN_DIR="/home/bnjns/.sdkman"
export AWS_MFA_SERIAL_NUMBER="arn:aws:iam::898005449250:mfa/Ben.Jones.nonprod"
export AWS_TMP_CREDENTIALS_FILE=/tmp/aws_creds.json

function dotenv {
  set -a
  [ -f .env ] && . .env
  set +a
}

function runTests {
  ./gradlew clean test
}

function publishLibrary {
  local version="$1"
  unset AWS_PROFILE

  if [[ -z "${version}" ]]; then
	  echo "please provide a version to publish and try again"
	  return 1
  fi

  rm -rf ~/.gradle/caches/modules-2/files-2.1/com.ovofieldforce.*
  rm -rf ~/.gradle/caches/modules-2/files-2.1/com.kaluza.*
  LIBRARY_BUILD_VERSION="${version}" ./gradlew clean build publish
}

function aws-login {
  read-awsmfa-credentials
  aws sts get-caller-identity &> /dev/null || awsmfa
  read-awsmfa-credentials
}

function read-awsmfa-credentials {
  export AWS_ACCESS_KEY_ID="$(aws configure get aws_access_key_id --profile default)"
  export AWS_SECRET_ACCESS_KEY="$(aws configure get aws_secret_access_key --profile default)"
  export AWS_SESSION_TOKEN="$(aws configure get aws_session_token --profile default)"
}

function aws-set-profile {
  unset AWS_PROFILE
  unset PROFILE_ARGS

  export AWS_PROFILE="$1"
  export PROFILE_ARGS="--profile $1"
}

# ZSH config
plugins=(docker docker-compose git nvm)
source /home/bnjns/.oh-my-zsh/oh-my-zsh.sh
prompt_context(){}
eval "$(rbenv init -)"

# Enable SDKMAN
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Enable NVM
[ -z "$NVM_DIR" ] && export NVM_DIR="$HOME/.nvm"
source /usr/share/nvm/nvm.sh
source /usr/share/nvm/bash_completion
source /usr/share/nvm/install-nvm-exec

# Initialise AWS profile
aws-set-profile ovo-spike

EOF

# Reload
. ~/.zshrc
