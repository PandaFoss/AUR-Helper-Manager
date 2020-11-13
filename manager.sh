#!/usr/bin/env bash

# Copyright Max Ferrer (Panda Foss) <maxi.fg13@gmail.com>

######################### Variables #########################
SEARCH_AND_DOWNLOAD=('auracle'
                     'pbget'
                     'repoctl'
                     'yaah')
SEARCH_AND_BUILD=('aurutils'
                  'bauerbill'
                  'pkgbuilder'
                  'repofish'
                  'rua')
PACMAN_WRAPPERS=('aura-bin'
                 'yay-bin'
                 'pacaur'
                 'pikaur'
                 'pakku-git'
                 'trizen')
GRAPHICAL=('yup-bin'
           'argon'
           'cylon'
           'pamac-aur'
           'pakku-gui'
           'octopi'
           'pkgbrowser')
ALL=("${SEARCH_AND_DOWNLOAD[@]}" "${SEARCH_AND_BUILD[@]}"
     "${PACMAN_WRAPPERS[@]}" "${GRAPHICAL[@]}")
COUNT=0
MAX_QTY="$((${#ALL[@]} -1))"
CLR='\e[0m'
NORMAL='\e[39m'
BOLD='\e[1m'
BLUE='\e[24m'

######################### Functions #########################

# Perform ckecks
check() {
    [ "$(id -u)" -eq 0 ] && echo "Please do not run this script as root, it could be dangerous." && exit
    [ ! -f /usr/bin/pacman ] && echo "This distribution seems not to be Arch Linux or derivative!" && exit
}

# Search and download function
s_and_d() {
    echo -e "${BOLD}${BLUE}::${NORMAL} Search and download${CLR}"
    for name in "${SEARCH_AND_DOWNLOAD[@]}"; do
        echo -e "${BOLD}${COUNT}.${CLR} ${name}"
        COUNT=$((COUNT+1))
    done
    echo ""
}

# Search and build function
s_and_b() {
    echo -e "${BOLD}${BLUE}::${NORMAL} Search and build${CLR}"
    for name in "${SEARCH_AND_BUILD[@]}"; do
        echo -e "${BOLD}${COUNT}.${CLR} ${name}"
        COUNT=$((COUNT+1))
    done
    echo ""
}

# Pacman wrappers function
wrappers() {
    echo -e "${BOLD}${BLUE}::${NORMAL} Pacman wrappers${CLR}"
    for name in "${PACMAN_WRAPPERS[@]}"; do
        echo -e "${BOLD}${COUNT}.${CLR} ${name}"
        COUNT=$((COUNT+1))
    done
    echo ""
}

# Graphical function
graphical() {
    echo -e "${BOLD}${BLUE}::${NORMAL} Graphical${CLR}"
    for name in "${GRAPHICAL[@]}"; do
        echo -e "${BOLD}${COUNT}.${CLR} ${name}"
        COUNT=$((COUNT+1))
    done
    echo ""
}

# Installation function
# $1 = helper to be installed
install() {
    local helper="$1"
    echo -e "${BOLD}${BLUE}::${NORMAL} Installing ${helper}${CLR}"
    git clone https://aur.archlinux.org/"${helper}".git
    cd "${helper}" || return
    makepkg -si
}

# Main function
main() {
    check
    s_and_d
    s_and_b
    wrappers
    graphical
    echo -n "Select option [0..${MAX_QTY}]: "
    read -r ans
    local re='^[0-9]+$'
    if ! [[ ${ans} =~ ${re} ]]; then
       echo "error: Not a number"
       exit 1
    elif ! [[ "${ans}" -ge "0" ]] && ! [[ ${ans} -le "${MAX_QTY}" ]]; then
       echo "Error: The number entered must be between 0 and ${MAX_QTY}"
       exit 2
    fi
    echo ""
    install "${ALL[ans]}"
}

main
