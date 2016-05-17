//
//  RadioBox.h
//  GameBox
//
//  Created by Caspar on 13-5-8.
//
//

#ifndef __GameBox__RadioBox__
#define __GameBox__RadioBox__

#include "CheckBox.h"
#include <map>

using namespace std;


namespace ptola
{
namespace gui
{

    class CRadioBox : public CCheckBox
    {
    public:

        MEMORY_MANAGE_OBJECT(CRadioBox);
        
        CRadioBox();
        ~CRadioBox();

        
        virtual void setChecked(bool bChecked);

        //执行组状态改变
        virtual void performGroupStateChanged();
        
    private:
        bool m_bChecked;
        map<CCheckBox *, string> m_mapRadioBox;
    };

}
}

#endif /* defined(__GameBox__RadioBox__) */
