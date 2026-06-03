# 云闪付滑块验证绕过 Tweak
# 编译: GitHub Actions macOS + Theos
# 注入: TrollFools

TARGET := iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = com.unionpay.chsp

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = Tweak

Tweak_FILES = Tweak.xm
Tweak_CFLAGS = -fobjc-arc
Tweak_FRAMEWORKS = UIKit WebKit Foundation
Tweak_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries

include $(THEOS_MAKE_PATH)/library.mk
