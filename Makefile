SOURCE_FILES = bashrc gemrc gitconfig tmux.conf bash_aliases Xresources
DOT_FILES = $(foreach f, $(SOURCE_FILES), $(addprefix ., $(f)))
TARGET_FILES = $(foreach f, $(DOT_FILES), $(addprefix $(HOME)/, $(f)))

all: $(TARGET_FILES) $(HOME)/.config/i3/config $(HOME)/.config/i3status/config

$(HOME)/.config/i3/config: i3config
	ln -snf ${CURDIR}/i3config $@

$(HOME)/.config/i3status/config: i3status
	ln -snf ${CURDIR}/i3status $@

$(HOME)/.%: %
	ln -snf ${CURDIR}/$< $@

.PHONY: clean
clean:
	rm -rf $(TARGET_FILES)
