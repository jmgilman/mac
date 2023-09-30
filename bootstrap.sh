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

log "Checking if Nix is installed..."
if ! command -v nix &>/dev/null; then
    log "Installing Nix..."
    curl -sL -o nix-installer https://install.determinate.systems/nix/nix-installer-aarch64-darwin
    chmod +x nix-installer

    ./nix-installer \
        --logger pretty \
        --extra-conf "sandbox = false" \
        --extra-conf "trusted-users = josh"

    log "Validating Nix installation..."
    ./nix-installer self-test --logger pretty

    success "Nix installed successfully!"
fi

log "Checking if rosetta is installed..."
if [[ ! -d /usr/libexec/rosetta ]]; then
    log "Installing rosetta..."
    sudo softwareupdate --install-rosetta --agree-to-license
    success "Rosetta installed successfully!"
fi

log "Checking if xcode is installed..."
if ! command -v xcode-select &>/dev/null; then
    log "Installing xcode..."

    # This temporary file prompts the 'softwareupdate' utility to list the Command Line Tools
    clt_placeholder="/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress"
    /usr/bin/sudo /usr/bin/touch "${clt_placeholder}"

    clt_label_command="/usr/sbin/softwareupdate -l |
                        grep -B 1 -E 'Command Line Tools' |
                        awk -F'*' '/^ *\\*/ {print \$2}' |
                        sed -e 's/^ *Label: //' -e 's/^ *//' |
                        sort -V |
                        tail -n1"
    clt_label="$(chomp "$(/bin/bash -c "${clt_label_command}")")"

    if [[ -n "${clt_label}" ]]; then
        log "Installing ${clt_label}"
        /usr/bin/sudo "/usr/sbin/softwareupdate" "-i" "${clt_label}"
        /usr/bin/sudo "/usr/bin/xcode-select" "--switch" "/Library/Developer/CommandLineTools"
    fi

    /usr/bin/sudo "/bin/rm" "-f" "${clt_placeholder}"
fi
