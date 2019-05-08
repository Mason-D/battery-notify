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
     - [x] Send notifications for low battery (5% 10% 15% 20% 30% 50%)
     - [x] Send notifications for full battery while charging
     - [ ] Fully test script
     - [ ] Beautify notifications
   - [x] Build Systemd Service file
   - [ ] Build setup script
     - [ ] Symlink service file
     - [ ] Symlink script
     - [ ] Create directories if they don't exist
   - [ ] Add possibility custom scripts for each event

