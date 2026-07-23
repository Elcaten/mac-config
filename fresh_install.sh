defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"
defaults -currentHost write -g AppleFontSmoothing -int 0
defaults write -g ApplePressAndHoldEnabled -bool false
copy com.local.KeyRemapping.plist ~/Library/LaunchAgents/ # maps Caps Lock to Ctrl