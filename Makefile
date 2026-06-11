DEBUG = 0
FINALPACKAGE = 1
PACKAGE_VERSION = 0.0.1

# 强制使用 14.5 SDK 保证兼容性，避免由于缺库导致的白苹果或崩溃
TARGET := iphone:clang:14.5:14.0
ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = sharingd SpringBoard Preferences

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AirDrop
AirDrop_FILES = Tweak.x
AirDrop_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
