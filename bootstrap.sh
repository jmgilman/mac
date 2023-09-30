#! /usr/bin/env bash
#
# Author: Joshua Gilman
#
# Usage: bootstrap.sh
#

set -o errexit
set -o nounset
set -o pipefail

readonly yellow='\e[0;33m'
readonly green='\e[0;32m'
readonly red='\e[0;31m'
readonly reset='\e[0m'

log() {
    printf "${yellow}>> %s${reset}\n" "${*}"
}

success() {
    printf "${green} %s${reset}}\n" "${*}"
}

error() {
    printf "${red}!!! %s${reset}\n" "${*}" 1>&2
}

cleanup() {
    result=$?
    rm -rf "${WORK_DIR}"
    exit ${result}
}

trap cleanup EXIT ERR
log "Welcome to the bootstrap script!"

WORK_DIR=$(mktemp -d)
log "Using work directory: ${WORK_DIR}"

log "Checking if homebrew is installed..."
if ! command -v brew &>/dev/null; then
    log "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "eval $(/opt/homebrew/bin/brew shellenv)" >>~/.zprofile
fi

log "Checking if Nix is installed..."
if ! command -v nix &>/dev/null; then
    log "Installing Nix..."
    curl -sL -o nix-installer https://install.determinate.systems/nix/nix-installer-aarch64-darwin
    chmod +x nix-installer

    ./nix-installer install macos \
        --logger pretty \
        --extra-conf "sandbox = false" \
        --extra-conf "trusted-users = josh"

    log "Validating Nix installation..."
    ./nix-installer self-test --logger pretty

    success "Nix installed successfully!"
fi

log "Configuring environment..."
set +o nounset
# shellcheck disable=SC1091
source "/etc/bashrc"
set -o nounset

log "Check if repo is cloned..."
if [[ ! -d ~/code/mac ]]; then
    log "Cloning repo..."
    mkdir -p ~/code
    git clone https://github.com/jmgilman/mac ~/code/mac
fi

log "Activating configuration..."
sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.bak
nix --extra-experimental-features nix-command run --extra-experimental-features flakes nix-darwin -- switch --flake ~/code/mac

success "Done!"
