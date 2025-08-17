
export THEOS=/var/mobile/theos

ARCHS = arm64
#Add arm64e if it needed

DEBUG = 0
FINALPACKAGE = 1
FOR_RELEASE = 1

#THEOS_PACKAGE_SCHEME = rootless

#rootfull = 1, rootless = 0
ROOTLESS = 1


ifeq ($(ROOTLESS), 1)
THEOS_PACKAGE_SCHEME = rootless
endif


include $(THEOS)/makefiles/common.mk

_THEOS_TARGET_ONLY_OBJCFLAGS := -std=gnu11
_THEOS_PLATFORM_DPKG_DEB_COMPRESSION = gzip # gzip is faster than lzma but the deb will be few KB more.

TWEAK_NAME = ESPVNGPRO


$(TWEAK_NAME)_FRAMEWORKS = UIKit Foundation Security QuartzCore CoreGraphics CoreText  AVFoundation Accelerate GLKit SystemConfiguration GameController

$(TWEAK_NAME)_LDFLAGS += JRMemory.framework/JRMemory


$(TWEAK_NAME)_EXTRA_FRAMEWORKS += 
$(TWEAK_NAME)_CCFLAGS = -std=c++11 -fno-rtti -fno-exceptions -DNDEBUG

$(TWEAK_NAME)_CFLAGS = -fobjc-arc -Wno-deprecated-declarations -Wno-unused-variable -Wno-unused-value

$(TWEAK_NAME)_FILES = GwGn.mm Dolphins.mm MenuWindow.mm $(wildcard View/*.mm) $(wildcard View/*.m) $(wildcard View/*.cpp) $(wildcard imgui/*.mm) $(wildcard imgui/*.cpp)


#$(TWEAK_NAME)_LIBRARIES += substrate
# GO_EASY_ON_ME = 1


### Obfuscate Dylib ###
before-package::
	@find $(THEOS_STAGING_DIR) -type f -name "*.dylib" -path "*/_/*" -exec $(THEOS_LIBRARY_PATH)/iGMenu.framework/concorde --target {} --output {} --whitelist-class-prefix GAD \;
	@find . -name ".DS_Store" -delete



include $(THEOS_MAKE_PATH)/tweak.mk
