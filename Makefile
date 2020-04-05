SOURCE_FILES = bashrc gemrc gitconfig tmux.conf bash_aliases
DOT_FILES = $(foreach f, $(SOURCE_FILES), $(addprefix ., $(f)))
TARGET_FILES = $(foreach f, $(DOT_FILES), $(addprefix $(HOME)/, $(f)))

all: $(TARGET_FILES)

$(HOME)/.%: %
	ln -snf ${CURDIR}/$< $@

.PHONY: clean
clean:
	rm -rf $(TARGET_FILES)
