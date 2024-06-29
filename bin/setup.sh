#!/usr/bin/env bash

BG="\e[104m"
TEXT="\e[97m"
GREEN="\e[32m"
RED="\e[91m"
ENDCOLOR="\e[0m"
BOLD_STYLE="\033[1m"
NORMAL_STYLE="\033[0m"

say () {
  printf "${BG}${TEXT} -- $1 -- ${ENDCOLOR}"
  printf "\n\n"
}

abort_if_not_installed () {
  tool=$1
  installation_instructions_url=$2
  if (command -v $1 &> /dev/null); then
    printf " ☑️   ${BOLD_STYLE}${tool}${NORMAL_STYLE} is already installed.\n"
  else
    printf "\n${RED}"
    printf " ❌  ${BOLD_STYLE}${tool}${NORMAL_STYLE}${RED} not found.\n"
    printf "     You'll need to install it before proceeding: \n"
    printf "     - ${installation_instructions_url}\n"
    printf "${ENDCOLOR}"
    exit 1
  fi
}

printf "${GREEN}Running setup script for bootstrap-eks-k8s repo\n\n${ENDCOLOR}"

say "Checking for prerequisites"
abort_if_not_installed aws https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
abort_if_not_installed terraform https://developer.hashicorp.com/terraform/install
printf "\n"

say "Configuring local git authentication method"
printf "Configuring git locally to allow Terraform to retrieve private modules "
printf "from other repositories...\n\n"
git config --local \
  url."git@github.com:epgui".insteadOf "https://github.com/epgui"
printf "${GREEN}"
printf " ✅  <https://github.com/epgui> now redirects to "
printf "<git@github.com:epgui> when working in this project.\n"
printf "${ENDCOLOR}"
printf "\n"

say "Done"
printf "${GREEN} 🤖  Good to go!${ENDCOLOR}\n"
