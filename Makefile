SERVDIR     = $(HOME)/.local/share/systemd/user
SCRIPTDIR   = $(HOME)/.local/bin
SERVFILE    = battery-notify.service
SCRIPTFILE  = battery-notify.sh


install:
	mkdir -p $(SERVDIR)
	mkdir -p $(SCRIPTDIR)
	cp $(SERVFILE) $(SERVDIR)/$(SERVFILE)
	cp $(SCRIPTFILE) $(SCRIPTDIR)/$(SCRIPTFILE)
	chmod 0644 $(SERVDIR)/$(SERVFILE)
	chmod 0755 $(SCRIPTDIR)/$(SCRIPTFILE)

uninstall:
	rm $(SERVDIR)/$(SERVFILE)
	rm $(SCRIPTDIR)/$(SCRIPTFILE)

enable:
	systemctl --user enable battery-notify.service

disable:
	systemctl --user disable battery-notify.service

start:
	systemctl --user start battery-notify.service

stop:
	systemctl --user stop battery-notify.service
