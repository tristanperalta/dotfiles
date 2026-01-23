SOURCE_FILES = bashrc gemrc gitconfig tmux.conf bash_aliases Xresources
DOT_FILES = $(foreach f, $(SOURCE_FILES), $(addprefix ., $(f)))
TARGET_FILES = $(foreach f, $(DOT_FILES), $(addprefix $(HOME)/, $(f)))

all: $(TARGET_FILES) $(HOME)/.config/i3/config $(HOME)/.config/i3status/config $(HOME)/.config/kitty/kitty.conf keybindings

$(HOME)/.config/i3/config: i3config
	mkdir -p $(@D)
	ln -snf ${CURDIR}/i3config $@

$(HOME)/.config/i3status/config: i3status
	mkdir -p $(@D)
	ln -snf ${CURDIR}/i3status $@

$(HOME)/.config/kitty/kitty.conf: config/kitty/kitty.conf
	mkdir -p $(@D)
	ln -snf ${CURDIR}/config/kitty/kitty.conf $@

$(HOME)/.%: %
	ln -snf ${CURDIR}/$< $@

.PHONY: clean keybindings
clean:
	rm -rf $(TARGET_FILES)

keybindings:
	gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Kitty'
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command '/usr/bin/kitty'
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Control><Alt>t'
	gsettings set org.gnome.desktop.input-sources xkb-options "['caps:swapescape']"
