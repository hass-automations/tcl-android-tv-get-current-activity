adb shell '
RESUMED=$(dumpsys activity activities 2>/dev/null | grep -m1 "mResumedActivity" | awk "{print \$4}"); \

if echo "$RESUMED" | grep -qi "TvActivity"; then \
  # TV is on HDMI input
  ACTIVE_ID=$(dumpsys tv_input 2>/dev/null | awk "/sessionStateMap/ {found=1} found && /inputId:/ {gsub(/[^0-9]/,\"\",\$2); print \$2; exit}"); \
  PORT=$(dumpsys tv_input 2>/dev/null | awk -v target="$ACTIVE_ID" "/TvInputHardwareInfo/ {id=\"\";port=\"\"} /id=/ {match(\$0,/id=[0-9]+/); if(RSTART) id=substr(\$0,RSTART+3,RLENGTH-3)} /hdmi_port=/ {match(\$0,/hdmi_port=[0-9]+/); if(RSTART) port=substr(\$0,RSTART+10,RLENGTH-10)} id==target && port!=\"\" {print port; exit}"); \
  echo "HDMI $PORT"; \
else \
  # App is active — get human-readable label
  PKG=$(echo "$RESUMED" | awk -F/ "{print \$1}"); \
  LABEL=$(dumpsys package $PKG 2>/dev/null | grep -m1 "application-label:" | sed "s/.*application-label://; s/^ *//; s/ *\$//"); \
  if [ -z "$LABEL" ]; then LABEL="$PKG"; fi; \
  echo "$LABEL"; \
fi
'
