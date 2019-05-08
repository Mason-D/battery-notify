# Battery Notify
   *A simple script and service for notifying the user about various battery level events*

## Setup
   ### Install
   To install, just run *make install*.
   ```bash
   $ make install

   $ # If you want this to run on startup, enable the service
   $ make enable

   $ # If you want to run the script without restarting
   $ make start
   ```
   This will install the service file and script file.

   If systemctl cannot see battery-notify.service, try reloading the systemctl daemon.
   ```bash
   $ systemctl --user daemon-reload
   ```

   ### Uninstall
   To uninstall, just run *make uninstall*.
   ```bash
   $ make uninstall
   ```

   If you just want to disable this program on startup, run *make disable*.
   ```bash
   $ make disable
   ```

   If you want to stop this program now, run *make stop*.
   ```bash
   $ make stop
   ```

## To-do
   - [ ] Build battery script
     - [x] Send notifications for low battery (5% 10% 15% 20% 30% 50%)
     - [x] Send notifications for full battery while charging
     - [ ] Fully test script
     - [ ] Beautify notifications
   - [x] Build Systemd Service file
   - [x] Build Makefile
     - [x] Install
       - [x] Copy service file
       - [x] Copy script
       - [x] Create directories if they don't exist
     - [x] Uninstall
       - [x] Remove installed files
   - [ ] Add possibility custom scripts for each event

