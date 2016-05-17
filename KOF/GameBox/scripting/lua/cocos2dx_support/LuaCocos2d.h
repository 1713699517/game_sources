
#ifndef __LUACOCOS2D_H_
#define __LUACOCOS2D_H_

extern "C" {
#include "tolua++.h"
#include "tolua_fix.h"
}

#include <map>
#include <string>
#include "tolua_fix.h"
#include "cocos2d.h"
#include "CCLuaEngine.h"
#include "SimpleAudioEngine.h"

#include "ConfigurationManager.h"
#include "UserControl.h"
#include "Sprite.h"
#include "Device.h"
#include "TcpClient.h"
#include "FileStream.h"
#include "FloatLayer.h"
#include "DataReader.h"
#include "DataWriter.h"
#include "MovieClip.h"
#include "LanguageManager.h"
#include "DateTime.h"
#include "Application.h"
#include "TabPage.h"
#include "Tab.h"
#include "Icon.h"
#include "DynamicIcon.h"
#include "HorizontalLayout.h"
#include "VerticalLayout.h"
#include "Slider.h"
#include "Tips.h"
#include "Menu.h"
#include "ScreenTurn.h"
#include "PageTurn.h"
#include "VolumeControl.h"
#include "RadioBox.h"
#include "AlertDialog.h"
#include "ResourceLoader.h"
#include "EditBox.h"
#include "MD5Crypto.h"
#include "PageScrollView.h"
#include "Joystick.h"
#include "PMath.h"
#include "Window.h"
#include "CCTouchSet.h"
#include "RichTextBox.h"
#include "SpriteRGBA.h"
#include "LabelColor.h"
#include "UUID.h"
#include "MemoryManager.h"
#include "AWebView.h"
#include "TouchContainer.h"
#include "UserCache.h"

#include "../../../GameBox/Classes/LoginVerifyLua.h"
#include "../../../GameBox/Classes/RechargeScene.h"
#include "../../../GameBox/Classes/LoginHttpApi.h"
#include "../../../GameBox/Classes/GameUpdateScene.h"

using namespace cocos2d;
using namespace CocosDenshion;
using namespace ptola::gui;
using namespace ptola::configuration;
using namespace ptola;
using namespace ptola::network;
using namespace ptola::io;
using namespace ptola::resources;
using namespace ptola::input;
using namespace ptola::math;
using namespace ptola::memory;

#define TOLUA_RELEASE

TOLUA_API int tolua_Cocos2d_open(lua_State* tolua_S);

#endif // __LUACOCOS2D_H_
