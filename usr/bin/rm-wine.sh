#!/bin/bash

set -x

rm -f $HOME/.config/menus/applications-merged/wine-*
rm -f $HOME/.local/share/applications/wine*
rm -f $HOME/.local/share/desktop-directorie/wine-*
rm -f $HOME/.local/share/icons/hicolor/*/apps/*wine*.png
rm -f $HOME/.local/share/mime/application/x-wine-*
rm -f $HOME/.local/share/mime/packages/x-wine-*
rm -rf $HOME/.wine
