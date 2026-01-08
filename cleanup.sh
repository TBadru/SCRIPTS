ls -l /Library/LaunchAgents
ls -l /Library/LaunchDaemons
ls -l ~/Library/LaunchAgents
#!/bin/bash

LOG_FILE="$HOME/Desktop/cleanup_log_$(date +%Y%m%d_%H%M%S).txt"
echo "=== Cleanup Log Started: $(date) ===" | tee -a "$LOG_FILE"

confirm() {
  echo -n "$1 [y/N]: "
  read -r reply
  [[ "$reply" =~ ^[Yy]$ ]]
}

cleanup_items() {
  echo -e "\n>> $1"
  for item in "${@:2}"; do
    if [ -e "$item" ]; then
      echo "Removing: $item" | tee -a "$LOG_FILE"
      sudo rm -rf "$item"
    else
      echo "Not found: $item" | tee -a "$LOG_FILE"
    fi
  done
}

# 1. Stop and unload LaunchDaemons/Agents if loaded
unload_items=(
  "com.reincubate.macos.cam.PrivilegedHelper"
  "com.rogueamoeba.aceagent"
  "com.rogueamoeba.acetool"
  "org.cindori.SenseiDaemon"
  "org.cindori.SenseiHelper"
  "org.openvpn.client"
  "org.openvpn.helper"
  "com.starstechnologies.updater"
  "org.cindori.SenseiMonitor"
)

echo -e "\n=== Attempting to unload launch daemons/agents ===" | tee -a "$LOG_FILE"
for label in "${unload_items[@]}"; do
  sudo launchctl bootout system "/Library/LaunchDaemons/${label}.plist" 2>/dev/null
  sudo launchctl bootout gui/$(id -u) "/Library/LaunchAgents/${label}.plist" 2>/dev/null
done

# 2. Confirm and clean each group

if confirm "Remove leftover files for Reincubate Camo (virtual webcam)?"; then
  cleanup_items "Cleaning up Camo" \
    "/Library/LaunchDaemons/com.reincubate.macos.cam.PrivilegedHelper.plist" \
    "/Applications/Camo Studio.app" \
    "/Library/Application Support/Reincubate"
fi

if confirm "Remove leftover files for Rogue Amoeba (Loopback, Audio Hijack, etc.)?"; then
  cleanup_items "Cleaning up Rogue Amoeba" \
    "/Library/LaunchDaemons/com.rogueamoeba.aceagent.plist" \
    "/Library/LaunchDaemons/com.rogueamoeba.acetool.plist" \
    "/Library/Application Support/Rogue Amoeba" \
    "/Applications/Audio Hijack.app" \
    "/Applications/Loopback.app"
fi


if confirm "Remove leftover files for Cindori Sensei (system monitor)?"; then
  cleanup_items "Cleaning up Sensei" \
    "/Library/LaunchDaemons/org.cindori.SenseiDaemon.plist" \
    "/Library/LaunchDaemons/org.cindori.SenseiHelper.plist" \
    "/Library/LaunchAgents/org.cindori.SenseiMonitor.plist" \
    "/Applications/Sensei.app" \
    "/Library/Application Support/Sensei"
fi

if confirm "Remove leftover files for OpenVPN?"; then
  cleanup_items "Cleaning up OpenVPN" \
    "/Library/LaunchDaemons/org.openvpn.client.plist" \
    "/Library/LaunchDaemons/org.openvpn.helper.plist" \
    "/Applications/OpenVPN Connect.app" \
    "/Library/Application Support/OpenVPN"
fi

if confirm "Remove unknown item: com.starstechnologies.updater?"; then
  cleanup_items "Cleaning up Stars Technologies (unidentified software)" \
    "/Library/LaunchDaemons/com.starstechnologies.updater.plist"
fi

echo -e "\n✅ Cleanup complete. Log saved to $LOG_FILE"
echo "🔁 Please reboot your Mac to finalize all changes."
