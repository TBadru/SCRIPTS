#!/bin/bash

echo "=== Starting Cleanup of Legacy and Suspicious Launch Items ==="

# Adobe/Rogue Amoeba/Camo/Sensei/OpenVPN — remove if no longer needed
PLISTS_TO_REMOVE=(
  "/Library/LaunchDaemons/com.reincubate.macos.cam.PrivilegedHelper.plist"
  "/Library/LaunchDaemons/com.rogueamoeba.aceagent.plist"
  "/Library/LaunchDaemons/com.rogueamoeba.acetool.plist"
  "/Library/LaunchDaemons/org.cindori.SenseiDaemon.plist"
  "/Library/LaunchDaemons/org.cindori.SenseiHelper.plist"
  "/Library/LaunchDaemons/org.openvpn.client.plist"
  "/Library/LaunchDaemons/org.openvpn.helper.plist"
  "/Library/LaunchDaemons/com.starstechnologies.updater.plist"
  "/Library/LaunchAgents/org.cindori.SenseiMonitor.plist"
)

for plist in "${PLISTS_TO_REMOVE[@]}"; do
  if [ -f "$plist" ]; then
    echo "Removing: $plist"
    sudo rm -f "$plist"
  else
    echo "Not found (already removed?): $plist"
  fi
done

echo "=== Cleanup Complete ==="
echo "💡 Reboot your Mac to finish cleanup and clear any lingering blocked extensions."

