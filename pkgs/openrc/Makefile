PKG_NAME=openrc
PKG_VERSION=0.54
PKG_DIST_NAME=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_DIST_URL=https://github.com/OpenRC/openrc/archive/refs/tags/$(PKG_VERSION).tar.gz

BUILDDIR?=$(CURDIR)/.build
TARGET?=

SRCDIR=$(BUILDDIR)/$(PKG_NAME)-$(PKG_VERSION)

# .PHONY: all
# all: $(SRCDIR)/busybox

# .PHONY: clean
# clean:
# 	@-$(RM) -r $(BUILDDIR)

.PHONY: install
install: $(SRCDIR)/buildir/src/openrc/openrc
# 	@install -d $(DESTDIR)$(TARGET)/bin
# 	@install $< $(DESTDIR)$(TARGET)/bin/$(<F)

$(SRCDIR)/buildir/src/openrc/openrc: $(SRCDIR)/buildir/build.ninja
	$(info Building package...)
	@meson compile -C $(<D)

$(SRCDIR)/buildir/build.ninja: $(SRCDIR)/meson.build
	(cd $(<D) && meson setup $(@D))

$(SRCDIR)/meson.build: $(BUILDDIR)/$(PKG_DIST_NAME)
	$(info Uncompressing tarball...)
	@(cd $(<D) && tar -xf $(<F))
	@touch $@

$(BUILDDIR)/$(PKG_DIST_NAME):
	$(info Downloading tarball...)
	@mkdir -p $(BUILDDIR)
	@wget -O $@ $(PKG_DIST_URL)
