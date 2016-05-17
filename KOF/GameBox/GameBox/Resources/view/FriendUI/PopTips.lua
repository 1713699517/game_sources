require "view/view"

CPopTips = class(view,function (self)
    self.iswindowscheckBoxChecked = 0
                          end)

CPopTips.CHECKBOX_TAG = 100
CPopTips.OK_TAG = 200
CPopTips.CANCEL_TAG = 300


--CPopTips 传入参数说明 (self,确定按钮里的function（发送协议）,弹出框显示的文字,是否显示checkBox按钮（1为显示）)
function CPopTips.create(self,_func,_String,_isCheckBox) --String为说明显示的字符串
    local winSize    = CCDirector:sharedDirector():getVisibleSize()
    self.Scenelayer  = CContainer :create()
    self.Scenelayer : setFullScreenTouchEnabled(true)
    self.Scenelayer : setTouchesPriority( -100 )
    self.Scenelayer : setTouchesEnabled(true)
    self.func        = _func
    self : init (winSize,self.Scenelayer,_String,_isCheckBox)   
    return self.Scenelayer
end

--add“取消按钮”改为"推荐重置vip按钮"
function CPopTips.createNew(self, _func, _String, _isCheckBox) --String为说明显示的字符串
    local winSize    = CCDirector:sharedDirector():getVisibleSize()
    self.Scenelayer  = CContainer :create()
    self.Scenelayer : setFullScreenTouchEnabled(true)
    self.Scenelayer : setTouchesPriority( -100 )
    self.Scenelayer : setTouchesEnabled(true)
    self.func        = _func
    self : init (winSize,self.Scenelayer,_String,_isCheckBox)
    return self.Scenelayer
end

function CPopTips.loadResources(self)
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("EquipmentResources/Equip.plist")
end

function CPopTips.layout(self, _winSize)  --适配布局
    if _winSize.height == 640 then
        self.windowsBackGroundSprite : setPosition(_winSize.width/2,_winSize.height/2)
        self.windowsInfoLabel        : setPosition (_winSize.width/2,_winSize.height/2*1.2187)
        self.windowsCancelBtn        : setPosition(_winSize.width/2*0.854,_winSize.height/2*0.781)
        self.windowsEnsureBtn        : setPosition(_winSize.width/2*1.16,_winSize.height/2*0.781)

    elseif _winSize.height == 768 then
        self.windowsBackGroundSprite : setPosition(_winSize.width/2,_winSize.height/2)
        self.windowsInfoLabel        : setPosition (_winSize.width/2,_winSize.height/2*1.2187)
        self.windowsCancelBtn        : setPosition(_winSize.width/2*0.854,_winSize.height/2*0.781)
        self.windowsEnsureBtn        : setPosition(_winSize.width/2*1.16,_winSize.height/2*0.781)
    end
end

function CPopTips.init(self, _winSize, _layer,_String,_isCheckBox)
    self : loadResources()                        --资源初始化
    self : initView(_winSize,_layer,_isCheckBox)  --界面初始化
    self : layout(_winSize)                       --适配布局初始化
    self : initParameter(_String)                 --参数初始化
end

function CPopTips.initParameter(self,_String)
    self.windowsInfoLabel : setString(_String)
    self.windowsInfoLabel : setDimensions( CCSizeMake(250, 60))
end

function CPopTips.initView(self,_winSize,_layer,_isCheckBox)
    --背景图
    self.windowsBackGroundSprite = CSprite : createWithSpriteFrameName("general_first_underframe.png")       --box底图
    --self.windowsBackGroundSprite : setScaleX(1)
    --self.windowsBackGroundSprite : setScaleY(0.8)
    self.windowsBackGroundSprite :setPreferredSize( CCSizeMake( 410, 278))
    local size = self.windowsBackGroundSprite :getPreferredSize()
    --print("sssssize==", size.width, size.height)
    _layer                       : addChild (self.windowsBackGroundSprite)

    local function callback( eventType, obj, x, y )
        return self : allCallback( eventType, obj, x, y )
    end

    if _isCheckBox == 1 then
        self.windowscheckBox = CCheckBox :create("LuckyResources/general_pages_normal.png", "LuckyResources/general_pages_pressing.png", "不再提示")
        self.windowscheckBox : setPosition (_winSize.width/2*0.895,_winSize.height/2)
        self.windowscheckBox : setTag( self.CHECKBOX_TAG )
        self.windowscheckBox : registerControlScriptHandler( callback, "this CPopTips windowscheckBox 258")
        _layer               : addChild(self.windowscheckBox)    
    end

    --弹出框说明
    self.windowsInfoLabel = CCLabelTTF :create("","Arial",25)
    _layer                : addChild(self.windowsInfoLabel)  

    local szSprName = "general_button_normal.png"
    local nFontSize = 28
    self.windowsEnsureBtn = CButton : createWithSpriteFrameName("确认", szSprName)
    self.windowsEnsureBtn : registerControlScriptHandler( callback, "this CPopTips windowsEnsureBtnCallBack 247")
    self.windowsEnsureBtn : setTouchesPriority( -101 )
    self.windowsEnsureBtn : setTag( self.OK_TAG )
    self.windowsEnsureBtn : setFontSize( nFontSize)
    _layer                : addChild (self.windowsEnsureBtn)


    self.windowsCancelBtn = CButton : createWithSpriteFrameName("取消", szSprName)
    self.windowsCancelBtn : registerControlScriptHandler( callback, "this CPopTips windowsCancelBtnCallBack 255")
    self.windowsCancelBtn : setTouchesPriority( -101 )
    self.windowsCancelBtn : setTag( self.CANCEL_TAG )
    self.windowsCancelBtn : setFontSize( nFontSize)
    _layer                : addChild (self.windowsCancelBtn)
end

function CPopTips.allCallback( self, eventType,obj,x,y )
    if eventType == "TouchBegan" then
        return true
    elseif eventType == "TouchEnded" then
        if obj:containsPoint( obj:convertToNodeSpaceAR( ccp( x, y ) ) ) then
            if obj : getTag() == self.OK_TAG then
                self : windowsEnsureBtn_CallBack()
            elseif obj : getTag() == self.CANCEL_TAG then
                self : windowsCancelBtn_CallBack()
            elseif obj : getTag() == self.CHECKBOX_TAG then
                self : windowscheckBox_CallBack()
            end
        end
    end
end

function CPopTips.windowscheckBox_CallBack( self )  --windowscheckBox回调
    print("windowscheckBox回调")
    self.iswindowscheckBoxChecked = 1
    print("windowscheckBox回调成功")
end

function CPopTips.windowsEnsureBtn_CallBack( self )
    print("windows板面确定按钮回调")
    self.func() --外面传进来的function，一般为发送协议function
    self.Scenelayer : removeFromParentAndCleanup(true)
end

function CPopTips.windowsCancelBtn_CallBack( self )
    print("windows板面取消按钮回调")
    self.Scenelayer : removeFromParentAndCleanup(true)
end















