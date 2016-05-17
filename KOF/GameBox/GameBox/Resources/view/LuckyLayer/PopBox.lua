require "view/view"

CPopBox = class(view,function (self)
    self.iswindowscheckBoxChecked = 0
                          end)

CPopBox.CHECKBOX_TAG = 100
CPopBox.OK_TAG       = 200
CPopBox.CANCEL_TAG   = 300


--CPopBox 传入参数说明 (self,确定按钮里的function（发送协议）,弹出框显示的文字,是否显示checkBox按钮（1为显示）,取消按钮里面的function)
function CPopBox.create(self,_func,_String,_isCheckBox,_Cancelfunc) --String为说明显示的字符串
    local winSize    = CCDirector:sharedDirector():getVisibleSize()
    self.Scenelayer  = CContainer :create()
    self.Scenelayer : setFullScreenTouchEnabled(true)
    self.Scenelayer : setTouchesPriority( -10000 )
    self.Scenelayer : setTouchesEnabled(true)
    self.func        = _func
    self.Cancelfunc  = _Cancelfunc
    self : init (winSize,self.Scenelayer,_String,_isCheckBox)
    
    _G.g_CTaskNewDataProxy :playMusicByName( "point_out" )
    return self.Scenelayer
end

function CPopBox.loadResources(self)
    --CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist") 
end

function CPopBox.layout(self, _winSize)  --适配布局
    self.windowsBackGroundSprite : setPosition( _winSize.width/2, _winSize.height/2)
    self.windowsInfoLabel        : setPosition( _winSize.width/2, 403)
    self.windowsEnsureBtn        : setPosition( _winSize.width/2 + 76 , 230)
    self.windowsCancelBtn        : setPosition( _winSize.width/2 - 76 , 230)
end

function CPopBox.init(self, _winSize, _layer,_String,_isCheckBox)
    self : loadResources()                        --资源初始化
    self : initView(_winSize,_layer,_isCheckBox)  --界面初始化
    self : layout(_winSize)                       --适配布局初始化
    self : initParameter(_String)                 --参数初始化
end

function CPopBox.initParameter(self,_String)
    self.windowsInfoLabel : setString(_String)
    self.windowsInfoLabel : setDimensions( CCSizeMake( self.windowsBackGroundSpriteSize.width * 0.8, self.windowsBackGroundSpriteSize.height * 0.4))
end

function CPopBox.initView(self,_winSize,_layer,_isCheckBox)
    --背景图
    self.windowsBackGroundSprite = CCScale9Sprite : createWithSpriteFrameName("general_thirdly_underframe.png")       --box底图
    self.windowsBackGroundSpriteSize = CCSizeMake( 420, 280 )
    self.windowsBackGroundSprite : setPreferredSize( self.windowsBackGroundSpriteSize )
    _layer                       : addChild (self.windowsBackGroundSprite)

    local function callback( eventType, obj, x, y )
        return self : allCallback( eventType, obj, x, y )
    end

    if _isCheckBox == 1 then
        self.windowscheckBox = CCheckBox :create("LuckyResources/general_pages_normal.png", "LuckyResources/general_pages_pressing.png", "")
        self.windowscheckBox : setPosition (_winSize.width/2 - 50, 302)
        self.windowscheckBox : setTouchesPriority( -10001 )
        self.windowscheckBox : setTag( self.CHECKBOX_TAG )
        self.windowscheckBox : setFontSize( 20 )
        self.windowscheckBox : setColor( ccc4(255,255,255,255) )
        self.windowscheckBox : registerControlScriptHandler( callback, "this CPopBox windowscheckBox 258")
        _layer               : addChild(self.windowscheckBox)    

        --不再提示
        self.noNoticLabel = CCLabelTTF :create("不再提示","Arial",25)
        self.noNoticLabel : setFontSize( 20 )
        self.noNoticLabel : setColor( ccc4(255,255,255,255) )
        _layer            : addChild(self.noNoticLabel)  
        self.noNoticLabel : setPosition( _winSize.width/2+20, 302)
    end

    --弹出框说明
    self.windowsInfoLabel = CCLabelTTF :create("","Arial",25)
    self.windowsInfoLabel : setAnchorPoint( ccp( 0.5,1 ) )
    self.windowsInfoLabel : setFontSize( 21 )
    self.windowsInfoLabel : setColor( ccc4(255,255,255,255) )
    _layer                : addChild(self.windowsInfoLabel)  

    self.windowsEnsureBtn = CButton : createWithSpriteFrameName("确认","general_button_normal.png")
    self.windowsEnsureBtn : setTouchesEnabled(true)
    self.windowsEnsureBtn : setTouchesPriority(-10001)
    self.windowsEnsureBtn : registerControlScriptHandler( callback, "this CPopBox windowsEnsureBtnCallBack 247")
    self.windowsEnsureBtn : setFontSize( 24 )
    self.windowsEnsureBtn : setColor( ccc4(255,255,255,255) )
    -- self.windowsEnsureBtn : setTouchesPriority( -101 )
    self.windowsEnsureBtn : setTag( self.OK_TAG )
    _layer                : addChild (self.windowsEnsureBtn)


    self.windowsCancelBtn = CButton : createWithSpriteFrameName("取消","general_button_normal.png")
    self.windowsCancelBtn : setTouchesEnabled(true)
    self.windowsCancelBtn : setTouchesPriority(-10001)
    self.windowsCancelBtn : registerControlScriptHandler( callback, "this CPopBox windowsCancelBtnCallBack 255")
    self.windowsCancelBtn : setFontSize( 24 )
    self.windowsCancelBtn : setColor( ccc4(255,255,255,255) )
    -- self.windowsCancelBtn : setTouchesPriority( -101 )
    self.windowsCancelBtn : setTag( self.CANCEL_TAG )
    _layer                : addChild (self.windowsCancelBtn)
end

function CPopBox.allCallback( self, eventType,obj,x,y )
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

function CPopBox.windowscheckBox_CallBack( self )  --windowscheckBox回调
    -- print("windowscheckBox回调.....self.windowscheckBox:getChecked() "..self.windowscheckBox:getChecked() )
    if self.iswindowscheckBoxChecked == 1 then 
        self.iswindowscheckBoxChecked = 0
    else
        self.iswindowscheckBoxChecked = 1
    end
    print("windowscheckBox回调成功")
end

function CPopBox.windowsEnsureBtn_CallBack( self )
    print("windows板面确定按钮回调")
    self.func() --外面传进来的function，一般为发送协议function
    self.Scenelayer : removeFromParentAndCleanup(true)
end

function CPopBox.windowsCancelBtn_CallBack( self )
    print("windows板面取消按钮回调")
    self.iswindowscheckBoxChecked = 0
    self.Scenelayer : removeFromParentAndCleanup(true)
    if self.Cancelfunc ~= nil then
        self.Cancelfunc() --外面传进来取消按钮的的function，一般为关闭function
    end
end
function CPopBox.setFontSize( self )
    print("setFontSize---")
    self.windowsInfoLabel : setFontSize(30)
end

function CPopBox.getIsChecked( self)
    return self.iswindowscheckBoxChecked
end

function CPopBox.setButtonName( self, _szBtnName)
    if _szBtnName == nil then
        return
    end
    self.windowsEnsureBtn :setText( tostring( _szBtnName))
end












