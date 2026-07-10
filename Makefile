ARCHS = arm64
ifeq ($(SIM),1)
	TARGET = simulator:clang:17.2:14.0
	ARCHS += x86_64
	THEOS_PACKAGE_SCHEME =
	THEOS_PACKAGE_INSTALL_PREFIX = /opt/simject
else
	TARGET = iphone:clang:16.5:14.0
	ARCHS += arm64e
	THEOS_PACKAGE_SCHEME = rootless
endif

export ARCHS TARGET THEOS_PACKAGE_SCHEME THEOS_PACKAGE_INSTALL_PREFIX

INSTALL_TARGET_PROCESSES = SpringBoard


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MockupUtil

MockupUtil_FILES = Tweak.x
MockupUtil_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += CCModule
include $(THEOS_MAKE_PATH)/aggregate.mk

deploy:: package
ifeq ($(SIM),1)
	@echo "Deploying to simulator..."
	
	sudo rsync -a \
        "$(THEOS_STAGING_DIR)/$(THEOS_PACKAGE_INSTALL_PREFIX)/" \
        "$(THEOS_PACKAGE_INSTALL_PREFIX)/"

	@echo "Restarting SpringBoard..."
	resim
else
	@echo "Deploying to physical device..."
	@$(MAKE) install
endif
