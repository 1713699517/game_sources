//
//  EditBox.h
//  GameBox
//
//  Created by hlc on 13-5-20.
//
//

#ifndef __GameBox__EditBox__
#define __GameBox__EditBox__

#include <iostream>
#include "UserControl.h"
#include "cocos2d.h"
#include "cocos-ext.h"

using namespace std;
using namespace cocos2d;
using namespace cocos2d::extension;

//EditBox ：大小，背景图片，长度，框内的默认内容，是否明文显示输入内容,设置输入模式,设置输入类型
namespace ptola
{
    namespace gui
    {

        using namespace ptola::gui;

        class CEditBox : public CUserControl, CCEditBoxDelegate
        {
        public:

            MEMORY_MANAGE_OBJECT(CEditBox);
            
            CEditBox();
            ~CEditBox();
        
            static CEditBox *create(const CCSize &size,CCScale9Sprite* pNormal9SpriteBg,int nMaxLength,const char *lpcszPlaceHolder,EditBoxInputFlag kEditBoxFlag);
            bool init(const CCSize &size,CCScale9Sprite* pNormal9SpriteBg,int nMaxLength,const char *lpcszPlaceHolder,EditBoxInputFlag kEditBoxFlag);
        
            static CEditBox *create(const CCSize &size,const char* lpcszNormal9SpriteBg,int nMaxLength,const char *lpcszPlaceHolder,EditBoxInputFlag kEditBoxFlag);
        
            bool init(const CCSize &size,const char* lpcszNormal9SpriteBg,int nMaxLength,const char *lpcszPlaceHolder,EditBoxInputFlag kEditBoxFlag);
        
        public:
            void setEditBoxInputMode(EditBoxInputMode kMode);
            EditBoxInputMode getEditBoxInputMode();

            void setEditBoxMaxLength(int nMaxLength);
            int getEditBoxMaxLength();
            
            void setTextString(const char* lpcszLabel);
            const char *getTextString();
            
            void setFont(const char *lpcszFontFamily, float fFontSize);
            void setFontColor(const ccColor3B &_color);

            void setTouchesPriority(int nPriority);
            
            void setPosition(const CCPoint &pos);
        public://CCEditBoxDelegate
            virtual void editBoxReturn(CCEditBox* editBox);
        private:
            CCEditBox *m_pEditBox;
            EditBoxInputMode m_eMode;
            //int m_nMaxLength;
            
        };
    }
}







#endif /* defined(__GameBox__EditBox__) */




//设置输入模式
//box->setInputMode(kEditBoxInputModeAny);

/**
 //      kEditBoxInputModeAny:         开启任何文本的输入键盘,包括换行
 //      kEditBoxInputModeEmailAddr:   开启 邮件地址 输入类型键盘
 //      kEditBoxInputModeNumeric:     开启 数字符号 输入类型键盘
 //      kEditBoxInputModePhoneNumber: 开启 电话号码 输入类型键盘
 //      kEditBoxInputModeUrl:         开启 URL 输入类型键盘
 //      kEditBoxInputModeDecimal:     开启 数字 输入类型键盘，允许小数点
 //      kEditBoxInputModeSingleLine:  开启任何文本的输入键盘,不包括换行
 //
 */

//设置输入类型
//box->setInputFlag(kEditBoxInputFlagSensitive);
/**
 //      kEditBoxInputFlagPassword:  密码形式输入
 //      kEditBoxInputFlagSensitive: 敏感数据输入、存储输入方案且预测自动完成
 //      kEditBoxInputFlagInitialCapsWord: 每个单词首字母大写,并且伴有提示
 //      kEditBoxInputFlagInitialCapsSentence: 第一句首字母大写,并且伴有提示
 //      kEditBoxInputFlagInitialCapsAllCharacters: 所有字符自动大写
 //     */
