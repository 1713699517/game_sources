CEquipTipsView = class()

function CEquipTipsView.scene(self,m_tableBtn)
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    self.scene = CCScene :create()
    self.scene :addChild(self:layer(m_tableBtn))
    return self.scene
end

function CEquipTipsView.layer(self,obj)
    print(obj :getText())
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    --  static CWindow *create(CCLabelTTF *pLabel, CSprite *pBackground, CSprite *pBarBackground, CButton *pCloseBtn, CContainer *pContainer);

    self.Scenelayer = CContainer :create()
    self.Scenelayer : setControlName( "this is CEquipTipsView self.Scenelayer 16  " )
    self.Scenelayer :setFullScreenTouchEnabled(true)
    self.Scenelayer :setTouchesEnabled(true)
    --self.Window = CWindow : create(CCLabelTTF :create("dfadf","Arial",15),CSprite :create("bbutton.png"),CSprite :create("bbutton.png"),CButton :create("","bbutton.png"),self.Scenelayer)
    self.Scenelayer :setPosition(obj :getPositionX()+obj :getContentSize().width/2-20,obj :getPositionY()+obj :getContentSize().height/2+200)
    --print("self.Window",self.Window)
    self:init(winSize, self.Scenelayer,m_tableBtn)
    
    return self.Scenelayer
end


function CEquipTipsView.initParameter(self,layer,m_tableBtn)
    self.m_layoutNode =CCNode :create()
    self.m_lineLabelWidth = 150
    layer :addChild(self.m_layoutNode)
    self.m_table={[1]="装备",[2]="卸下",[3]="强化"}
    self.m_tableNodeBtn={}
    CCSpriteFrameCache :sharedSpriteFrameCache():addSpriteFramesWithFile("General.plist");
end

function CEquipTipsView.initPosition(self)
    self.m_layoutPosX =0
    self.m_layoutStartPosY =0
    self.m_layoutPosY =0
end
function CEquipTipsView.init(self,winSize,layer)
    --CCDirector :sharedDirector():getTouchDispatcher():addTargetedDelegate(self, -128, true)
    self :initPosition()
    self :initParameter(layer,m_tableBtn)
    self :addLabelAndLine()
    self :addButtonForTips()
    self :initBackGround(layer)
end

function CEquipTipsView.initBackGround(self,layer)
    self.m_node ={}
    self.m_node["background"] = CCScale9Sprite :createWithSpriteFrameName("Word2Btn.png")
    self.m_node["background"] :setAnchorPoint(ccp(0,0))
    self.m_node["background"] :setPreferredSize(CCSizeMake(self.m_lineLabelWidth+300,self.m_layoutStartPosY-self.m_layoutPosY+10))
    self.m_node["background"] :setPosition(ccp(self.m_layoutPosX-10,self.m_layoutPosY-10))
    layer :addChild(self.m_node["background"],-1)
end

function CEquipTipsView.addLabelAndLine(self,layer)
    self :addLabelForTips("射日弓",ccc3(255,0,128),0,false)
    self :addLabelForTips("强化等级 紫装51级",ccc3(128,0,128),0,false)
    self :addLabelForTips("物理攻击 ＋815",ccc3(128,0,255),0,false)
    self :addLabelForTips("技能攻击＋387",ccc3(255,0,255),0,true)
    self :addLabelForTips("射日弓",ccc3(255,0,128),0,false)
    self :addLabelForTips("强化等级 紫装51级",ccc3(128,0,128),0,false)
    self :addLabelForTips("物理攻击 ＋815",ccc3(128,0,255),0,false)
    self :addLabelForTips("技能攻击＋387",ccc3(255,0,255),0,true)
    self :addLabelForTips("射日弓",ccc3(255,0,128),0,false)
    self :addLabelForTips("强化等级 紫装51级",ccc3(128,0,128),0,false)
    self :addLabelForTips("物理攻击 ＋815",ccc3(128,0,255),0,false)
    self :addLabelForTips("技能攻击＋387",ccc3(255,0,255),0,true)
end

function CEquipTipsView.addButtonForTips(self)
    for i=1,#self.m_table do
        if(i==1)then
            self.m_tableNodeBtn[i] = CButton :createWithSpriteFrameName(self.m_table[i],"Word2Btn.png")
            self.m_tableNodeBtn[i] : setControlName( "this CEquipTipsView self.m_tableNodeBtn[i] 80 "..tostring( i ))
            if(#self.m_table==2)then
                self.m_tableNodeBtn[i] :setPosition(ccp(self.m_layoutPosX+100,self.m_layoutPosY-self.m_tableNodeBtn[i] :getContentSize().height/2-5))
            else
                self.m_tableNodeBtn[i] :setPosition(ccp(self.m_layoutPosX+50,self.m_layoutPosY-self.m_tableNodeBtn[i] :getContentSize().height/2-5))
            end
            self.m_layoutPosY = self.m_tableNodeBtn[i] :getPositionY()-self.m_tableNodeBtn[i] :getContentSize().height/2
            self.m_layoutNode :addChild(self.m_tableNodeBtn[i])
            self :registerControl(self.m_tableNodeBtn[i],self.m_table[i])
        else
            self.m_tableNodeBtn[i] = CButton :createWithSpriteFrameName(self.m_table[i],"Word2Btn.png")
            self.m_tableNodeBtn[i] : setControlName( "this CEquipTipsView self.m_tableNodeBtn[i] 91 "..tostring( i ))
            if(#self.m_table==2)then
                self.m_tableNodeBtn[i] :setPosition(ccp(self.m_tableNodeBtn[i] :getContentSize().width*(i-1)+30*(i-1),0))
            else
                self.m_tableNodeBtn[i] :setPosition(ccp(self.m_tableNodeBtn[i] :getContentSize().width*(i-1)+30*(i-1),0))
            end
            self.m_tableNodeBtn[1] :addChild(self.m_tableNodeBtn[i])
            self :registerControl(self.m_tableNodeBtn[i],self.m_table[i])
        end
    end
end

function CEquipTipsView.registerControl(self,m_btnNode,btnStr)
    if(tostring(btnStr)=="装备")then
        m_btnNode :registerControlScriptHandler(CEquipTipsView.equipBtnCallBack, "this CEquipTipsView m_btnNode 105")
        elseif (btnStr=="卸下") then
        m_btnNode :registerControlScriptHandler(CEquipTipsView.unLoadEquipBtnCallBack, "this CEquipTipsView m_btnNode 107")
        elseif (btnStr=="强化") then
        m_btnNode :registerControlScriptHandler(CEquipTipsView.strengthenEquipBtnCallBack, "this CEquipTipsView m_btnNode 109")
        elseif (btnStr=="出售") then
        m_btnNode :registerControlScriptHandler(CEquipTipsView.sellEquipBtnCallBack, "this CEquipTipsView m_btnNode 111")
    end
end


function CEquipTipsView.addLabelForTips(self,labelStr,labelColor,_xLen,isNeedLine)
    local temp = CCLabelTTF :create(labelStr, "Arial", 18,CCSizeMake(self.m_lineLabelWidth, 0),kCCTextAlignmentLeft)
    temp :setAnchorPoint(ccp(0,0))
    temp :setColor(labelColor)
    temp :setPosition(ccp(self.m_layoutPosX+_xLen,self.m_layoutPosY-temp :getContentSize().height))
    self.m_layoutPosY = temp :getPositionY()
    self.m_layoutNode :addChild(temp)

    if(isNeedLine==true) then
        self :addLineForTips(temp)
    end
end

function CEquipTipsView.addLineForTips(self,lableNode)
    local line=CCScale9Sprite :createWithSpriteFrameName("allgoodsbox_bg_line.png")
    line :setPreferredSize(CCSizeMake(400, 10))
    line :setAnchorPoint(ccp(0,0))
    line :setPosition(ccp(self.m_layoutPosX, self.m_layoutPosY-line :getContentSize().height))
    self.m_layoutPosY =line :getPositionY()
    self.m_layoutNode :addChild(line)
end

function CEquipTipsView.equipBtnCallBack()
    print("装备")
end

function CEquipTipsView.unLoadEquipBtnCallBack()
    print("卸下")
end

function CEquipTipsView.sellEquipBtnCallBack()
    print("出售")
end

function CEquipTipsView.strengthenEquipBtnCallBack()
    print("强化")
end