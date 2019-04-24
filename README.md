# Battery Notify
   *A simple script and service for notifying the user about various battery level events*

## Setup
   To setup, just run the setup script:
   ```bash
   $ ./setup.sh
   ```
   This will create a symlink between the files within this repo and the necessary system files.

## To-do
   - [ ] Build battery script
     - [ ] Send notifications on status change (Charging/Not)
     - [ ] Send notifications for low battery (5% 10% 15% 20% 30% 50%)
     - [ ] Send notifications for full battery while charging
   - [ ] Build Systemd Service file
   - [ ] Build setup script
   - [ ] Add possibility custom scripts for each event

