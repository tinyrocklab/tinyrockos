PKG_NAME=tinyrockos
PKG_VERSION=0.0.0

BUILDDIR?=$(CURDIR)/.build

BUILDDIR_ROOTFS=$(BUILDDIR)/rootfs
PKGSDIR=$(CURDIR)/pkgs
SRCDIR=$(CURDIR)/src

.PHONY: all
all: $(BUILDDIR)/$(PKG_NAME)-rootfs-$(PKG_VERSION).tar.gz

.PHONY: clean
clean:
	@-$(RM) -r $(BUILDDIR)/$(PKG_NAME)-rootfs-$(PKG_VERSION).tar.gz $(BUILDDIR_ROOTFS)
	@$(MAKE) -C $(PKGSDIR)/busybox clean

$(BUILDDIR)/$(PKG_NAME)-rootfs-$(PKG_VERSION).tar.gz: $(BUILDDIR_ROOTFS)/system/bin/busybox
	$(info Generating rootfs...)
	@tar -C $(BUILDDIR_ROOTFS) -czf $@ .

$(BUILDDIR_ROOTFS)/system/bin/busybox: $(PKGSDIR)/busybox/Makefile Makefile
	$(info Generating busybox...)
	@$(MAKE) -C $(<D)
	@$(MAKE) DESTDIR=$(BUILDDIR_ROOTFS) TARGET=/system -C $(<D) install-commands
	@touch $@
