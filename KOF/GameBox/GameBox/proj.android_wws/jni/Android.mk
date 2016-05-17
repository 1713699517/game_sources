LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := game_shared

LOCAL_MODULE_FILENAME := libgame

                   
LOCAL_C_INCLUDES :=	$(LOCAL_PATH)/../../Classes \
			$(LOCAL_PATH)/../../GameEngine \
			$(LOCAL_PATH)/../../GameEngine/misc \
			$(LOCAL_PATH)/../../../cocos2dx/support/zip_support \
			$(LOCAL_PATH)/../../../extensions/crypto

FILE_LIST := $(wildcard $(LOCAL_PATH)/../../GameEngine/*.c)
FILE_LIST := $(wildcard $(LOCAL_PATH)/../../GameEngine/*.cpp)
FILE_LIST += $(wildcard $(LOCAL_PATH)/../../GameEngine/misc/*.cpp)
FILE_LIST += $(wildcard $(LOCAL_PATH)/../../Classes/*.cpp)
FILE_LIST += hellocpp/main.cpp

#FILE_LIST += ../../Classes/AppDelegate.cpp
#FILE_LIST += ../../Classes/TestScene.cpp
#FILE_LIST += ../../Classes/GameUpdateScene.cpp

LOCAL_SRC_FILES := $(FILE_LIST:$(LOCAL_PATH)/%=%)
                   	
LOCAL_WHOLE_STATIC_LIBRARIES := cocos2dx_static cocosdenshion_static cocos_extension_static cocos_lua_static

LOCAL_JNI_SHARED_LIBRARIES := libchannel
LOCAL_JNI_SHARED_LIBRARIES += libwwslogin
            
include $(BUILD_SHARED_LIBRARY)

$(call import-module,CocosDenshion/android) \
$(call import-module,cocos2dx) \
$(call import-module,extensions) \
$(call import-module,scripting/lua/proj.android/jni)
