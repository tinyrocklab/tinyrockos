PKG_NAME=tinyrockos
PKG_VERSION=0.0.0

BUILDDIR?=$(CURDIR)/.build

BUILDDIR_INITRAMFS=$(BUILDDIR)/initramfs
BUILDDIR_ISOFS=$(BUILDDIR)/isofs
BUILDDIR_ROOTFS=$(BUILDDIR)/rootfs
PKGSDIR=$(CURDIR)/pkgs
SRCDIR=$(CURDIR)/src
SRCDIR_INITRAMFS=$(SRCDIR)/init

.PHONY: all
all: $(BUILDDIR)/$(PKG_NAME)-rootfs-$(PKG_VERSION).tar.gz $(BUILDDIR)/$(PKG_NAME)-$(PKG_VERSION).iso

.PHONY: clean
clean:
	@-$(RM) -r $(BUILDDIR)/$(PKG_NAME)-rootfs-$(PKG_VERSION).tar.gz $(BUILDDIR_ROOTFS)
	@$(MAKE) -C $(PKGSDIR)/busybox clean

$(BUILDDIR)/$(PKG_NAME)-rootfs-$(PKG_VERSION).tar.gz: $(BUILDDIR_ROOTFS)/system/bin/busybox
	$(info Generating $(@F)...)
	@tar -C $(BUILDDIR_ROOTFS) -czf $@ .

$(BUILDDIR)/$(PKG_NAME)-$(PKG_VERSION).iso: $(BUILDDIR_ISOFS)/boot/bzImage $(BUILDDIR_ISOFS)/boot/initramfs.cpio
	$(info Generating $(@F)...)
	@xorriso -as mkisofs $(BUILDDIR_ISOFS) -o $@ 2> /dev/null

$(BUILDDIR_ISOFS)/boot/bzImage: $(PKGSDIR)/linux/Makefile Makefile
	$(info Generating $(@F)...)
	@$(MAKE) -C $(<D)
	@$(MAKE) DESTDIR=$(BUILDDIR_ISOFS) -C $(<D) install
	@touch $@

$(BUILDDIR_ISOFS)/boot/initramfs.cpio: $(SRCDIR_INITRAMFS)/init.sh $(BUILDDIR_INITRAMFS)/system/bin/busybox Makefile
	$(info Generating $(@F)...)
	@cp $< $(BUILDDIR_INITRAMFS)/init
	@chmod -R 777 $(BUILDDIR_INITRAMFS)
	@(cd $(BUILDDIR_INITRAMFS) && find . | cpio -o -H newc > $@)

$(BUILDDIR_INITRAMFS)/system/bin/busybox $(BUILDDIR_ROOTFS)/system/bin/busybox: %/system/bin/busybox: $(PKGSDIR)/busybox/Makefile Makefile
	$(info Generating $(@F)...)
	@$(MAKE) -C $(<D)
	@$(MAKE) DESTDIR=$* TARGET=/system -C $(<D) install-commands
	@touch $@
