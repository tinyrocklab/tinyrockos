ARCH?=x86_64

PKG_NAME=linux
PKG_VERSION=6.9.1

_PKG_VERSION_MAJOR=$(shell echo $(PKG_VERSION) | sed 's/\.[0-9]*//g')

PKG_DIST_NAME=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_DIST_URL=https://cdn.kernel.org/pub/linux/kernel/v$(_PKG_VERSION_MAJOR).x/$(PKG_DIST_NAME)

BUILDDIR?=$(CURDIR)/.build
TARGET?=

SRCDIR=$(BUILDDIR)/$(PKG_NAME)-$(PKG_VERSION)

.PHONY: all
all: $(SRCDIR)/arch/$(ARCH)/boot/bzImage

.PHONY: clean
clean:
	@-$(RM) -r $(BUILDDIR)

.PHONY: install
install: $(SRCDIR)/arch/$(ARCH)/boot/bzImage
	@install -d $(DESTDIR)$(TARGET)/boot
	@install $< $(DESTDIR)$(TARGET)/boot/$(<F)

$(SRCDIR)/arch/$(ARCH)/boot/bzImage: $(SRCDIR)/.config $(SRCDIR)/Makefile
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
