TARGET = lib/mpv_inhibit_gnome.so
TARGET_DIR = $(dir $(TARGET))
SRC_DIR = src
XDG_CONFIG_DIR := $(or $(XDG_CONFIG_HOME),$(HOME)/.config)
SCRIPTS := mpv/scripts
PREFIX := /usr/local
SYS_PLUGIN_DIR := $(PREFIX)/lib/mpv_inhibit_gnome
SYS_SCRIPTS_DIR := /etc/$(SCRIPTS)
FLATPAK_SCRIPTS_DIR := $(HOME)/.var/app/$(MPV_FLATPAK)/config/$(SCRIPTS)

PKG_CONFIG = pkg-config
INSTALL := install
MKDIR := mkdir -p
RMDIR := rmdir -p
LN := ln
RM := rm

WARN := -Wall
DEBUG := -g
FLAGS += $(WARN) $(DEBUG) -fPIC
CFLAGS += $(FLAGS) $(shell $(PKG_CONFIG) --cflags mpv dbus-1)
LDFLAGS += $(FLAGS) -shared
LDLIBS += $(shell $(PKG_CONFIG) --libs dbus-1)

SRCS := $(shell find $(SRC_DIR) -name *.c)
OBJS := $(patsubst src/%.c,build/%.o,$(SRCS))

UID ?= $(shell id -u)

$(TARGET): $(OBJS)
	@$(MKDIR) $(@D)
	$(CC) $(LDFLAGS) $^ $(LDLIBS) -o $@

build/%.o: src/%.c
	@$(MKDIR) $(@D)
	$(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<

ifneq ($(UID),0)
install: user-install
uninstall: user-uninstall
else
install: sys-install
uninstall: sys-uninstall
endif

define INSTALL_PLUGIN
.PHONY: $(1)-install $(1)-uninstall
$(1)-install: $$(TARGET)
	$(MKDIR) "$(2)"
	$(INSTALL) -t "$(2)" $$<

$(1)-uninstall:
	$(RM) "$(2)/$$(notdir $$(TARGET))"
	$(RMDIR) "$(2)"
endef

$(eval $(call INSTALL_PLUGIN,user,$(USER_SCRIPTS_DIR)))
$(eval $(call INSTALL_PLUGIN,sys,$(DESTDIR)$(SYS_SCRIPTS_DIR)))

MPV_FLATPAK=io.mpv.Mpv
$(eval $(call INSTALL_PLUGIN,flatpak,$(FLATPAK_SRIPTS_DIR)))

.PHONY: flatpakoverride
flatpakoverride:
	flatpak override --user --talk-name=org.gnome.SessionManager $(MPV_FLATPAK)

.PHONY: flatpakunoverride
flatpakunoverride:
	flatpak override --user --no-talk-name=org.gnome.SessionManager $(MPV_FLATPAK)

.PHONY: clean
clean:
	$(RM) -r build
	$(RM) $(TARGET)
	test ! -d $(TARGET_DIR) || $(RMDIR) $(TARGET_DIR)
