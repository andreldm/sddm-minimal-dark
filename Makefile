TARGET=/usr/share/sddm/themes/minimal-dark

install:
	mkdir -p $(TARGET)
	install -c angle-down.png $(TARGET)
	install -c background.png $(TARGET)
	install -c COPYING $(TARGET)
	install -c Main.qml $(TARGET)
	install -c metadata.desktop $(TARGET)
	install -c screenshot.png $(TARGET)

uninstall:
	rm -f $(TARGET)

.PHONY: install uninstall
