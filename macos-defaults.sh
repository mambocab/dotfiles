#!/usr/bin/env bash
# This script is run automatically by direnv when its contents change.
# It MUST remain idempotent — safe to run multiple times with the same result.
set -euo pipefail

# Remap Caps Lock → Control for all keyboards (-1--1-0 means any vendor/product)
defaults -currentHost write -g "com.apple.keyboard.modifiermapping.-1--1-0" -array \
    '<dict>
        <key>HIDKeyboardModifierMappingSrc</key><integer>30064771129</integer>
        <key>HIDKeyboardModifierMappingDst</key><integer>30064771300</integer>
    </dict>'

# Mouse button shortcuts: Mission Control (button 4) and Application Windows (button 5)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add \
    38 '<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>8</integer><integer>8</integer><integer>0</integer></array><key>type</key><string>button</string></dict></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add \
    39 '<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>16</integer><integer>16</integer><integer>0</integer></array><key>type</key><string>button</string></dict></dict>'

# Auto-hide the Dock and restart it to apply
defaults write com.apple.dock autohide -bool true
killall Dock
