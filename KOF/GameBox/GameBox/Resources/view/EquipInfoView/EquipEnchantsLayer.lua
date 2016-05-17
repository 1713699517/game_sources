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
    self.Scenelayer = CContainer :create()
    self.Scenelayer : setControlName( "this is CEquipTipsView self.Scenelayer 14" )
    self.Scenelayer :setPosition(obj :getPositionX()+obj :getContentSize().width/2-20,obj :getPositionY()+obj :getContentSize().height/2+200)
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

function CEquipTipsView.strengthenEquipBtnCallBack()
    print("强化")
end