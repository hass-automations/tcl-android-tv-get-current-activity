This ADB script determines what is currently displayed on a TCL Android TV (tested on `TCL 50C645`):

- If an HDMI input is active → returns "HDMI X" (port number).  
- If an app is running → returns the human-readable app name (e.g., "YouTube", "Netflix").  
- Always returns a single line.
