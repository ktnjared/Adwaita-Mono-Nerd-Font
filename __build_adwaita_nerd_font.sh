#!/bin/bash

# get user's current directory
CURRENT_DIR=${PWD}

# use $HOME/Downloads if XDG_DOWNLOAD_DIR is not set
FONT_TMP_DOWNLOAD="${XDG_DOWNLOAD_DIR:-$HOME/Downloads}/_adwaita_nf"

# define local user font directory
case ${OS} in
mac | darwin)
    FONT_DIR="${HOME}/Library/Fonts/"
    ;;
linux)
    FONT_DIR="${HOME}/.fonts/"
    ;;
esac

# ensure fontforge is installed
if ! type fontforge &>/dev/null; then
    echo "FontForge is not installed."
    exit 1
fi

# download original adwaita fonts
if [[ ! -d ${FONT_TMP_DOWNLOAD} ]]; then
    mkdir ${FONT_TMP_DOWNLOAD}
fi

# cd to downloads
pushd ${FONT_TMP_DOWNLOAD}

# clone adwaita-fonts from GNOME GitLab
git clone https://gitlab.gnome.org/GNOME/adwaita-fonts.git

# download fontpatcher
NF_FONTPATCHER_URL=https://github.com/ryanoasis/nerd-fonts/releases/latest/download/
NF_FONTPATCHER_ZIP=FontPatcher.zip

curl -O -L "${NF_FONTPATCHER_URL}${NF_FONTPATCHER_ZIP}"

# extract fontpatcher
unzip -d font-patcher -uo ${NF_FONTPATCHER_ZIP}

# make nerd fonts!
echo "Patching AdwaitaMono-Bold..."
fontforge -script font-patcher/font-patcher -c adwaita-fonts/mono/AdwaitaMono-Bold.ttf

echo "Patching AdwaitaMono-BoldItalic..."
fontforge -script font-patcher/font-patcher -c adwaita-fonts/mono/AdwaitaMono-BoldItalic.ttf

echo "Patching AdwaitaMono-Italic..."
fontforge -script font-patcher/font-patcher -c adwaita-fonts/mono/AdwaitaMono-Italic.ttf

echo "Patching AdwaitaMono-Regular..."
fontforge -script font-patcher/font-patcher -c adwaita-fonts/mono/AdwaitaMono-Regular.ttf

# deploy fonts to local user font dir
echo "Deploying fonts..."
mv AdwaitaMonoNerdFont-*.ttf ${FONT_DIR}/

# confirm
declare -i deployed=0
if [[ ! -z ${FONT_DIR}/AdwaitaMonoNerdFont-Bold.ttf ]]; then
    echo "    AdwaitaMonoNerdFont-Bold.ttf deployed."
    ((deployed++))
fi

if [[ ! -z ${FONT_DIR}/AdwaitaMonoNerdFont-Bold.ttf ]]; then
    echo "    AdwaitaMonoNerdFont-BoldItalic.ttf deployed."
    ((deployed++))
fi

if [[ ! -z ${FONT_DIR}/AdwaitaMonoNerdFont-Bold.ttf ]]; then
    echo "    AdwaitaMonoNerdFont-Italic.ttf deployed."
    ((deployed++))
fi

if [[ ! -z ${FONT_DIR}/AdwaitaMonoNerdFont-Bold.ttf ]]; then
    echo "    AdwaitaMonoNerdFont-Regular.ttf deployed."
    ((deployed++))
fi

if [[ deployed -eq 4 ]]; then
    echo "Completed. AdwaitaMono Nerd Fonts have been deployed to ${FONT_DIR}."
fi

# return to the previous directory
popd ${CURRENT_DIR}
