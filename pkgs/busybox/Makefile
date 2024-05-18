PKG_NAME=busybox
PKG_VERSION=1.36.1
PKG_DIST_NAME=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_DIST_URL=https://www.busybox.net/downloads/$(PKG_DIST_NAME)

BUILDDIR?=$(CURDIR)/.build
TARGET?=

SRCDIR=$(BUILDDIR)/$(PKG_NAME)-$(PKG_VERSION)

.PHONY: all
all: $(SRCDIR)/busybox

.PHONY: clean
clean:
	@-$(RM) -r $(BUILDDIR)

.PHONY: install
install: $(SRCDIR)/busybox
	@install -d $(DESTDIR)$(TARGET)/bin
	@install $< $(DESTDIR)$(TARGET)/bin/$(<F)

.PHONY: install-commands
install-commands: $(SRCDIR)/busybox install
	@for prog in $$($< --list); do ln -sf busybox $(DESTDIR)$(TARGET)/bin/$$prog; done

$(SRCDIR)/busybox: $(SRCDIR)/.config $(SRCDIR)/Makefile
	$(info Building package...)
	@$(MAKE) -C $(<D)

$(SRCDIR)/.config: $(SRCDIR)/Makefile
	$(info Configuring package...)
	@$(MAKE) -C $(@D) defconfig
	@(cd $(SRCDIR) && patch -p1 < $(CURDIR)/patches/config.patch)

$(SRCDIR)/Makefile: $(BUILDDIR)/$(PKG_DIST_NAME)
	$(info Uncompressing tarball...)
	@(cd $(<D) && tar -xf $(<F))
	@touch $@

$(BUILDDIR)/$(PKG_DIST_NAME):
	$(info Downloading tarball...)
	@mkdir -p $(BUILDDIR)
	@wget -O $@ $(PKG_DIST_URL)
