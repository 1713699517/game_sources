require "view/view"

CErrorBox = class(view,function (self)

                          end)
CErrorBox.ENSURE_TAG   = 100
CErrorBox.CANCEL_TAG   = 200

CErrorBox.RICHTEXT_W   = 300
CErrorBox.RICHTEXT_H   = 180

CErrorBox.FONT_SIZE    = 18

-- require "view/ErrorBox/ErrorBox"
-- local ErrorBox = CErrorBox()
-- local function func1()
--     print("good1")
-- end
-- local function func2()
--     print("bad2")
-- end
-- local BoxLayer = ErrorBox : create("妥妥的",func1,func2)
-- self.Scenelayer : addChild(BoxLayer)

--                       (self,说明显示的字符串,确定按钮回调,取消按钮回调)
function CErrorBox.create(self,_String,_EnsureFunc,_CancelFunc,_isTrue) --String为说明显示的字符串
    if _isTrue == nil then
        self.isTrue = 0 
    else
        self.isTrue = 1 
    end
    self.Scenelayer = CContainer :create()
    self.Scenelayer : setFullScreenTouchEnabled(true)
    self.Scenelayer : setTouchesPriority( -100 )
    self.Scenelayer : setTouchesEnabled(true)
    self.String     = _String
    self.EnsureFunc = _EnsureFunc
    self.CancelFunc = _CancelFunc

    _G.g_CTaskNewDataProxy :playMusicByName( "point_out" )
    
    self : init (self.Scenelayer) 
    return self.Scenelayer
end

function CErrorBox.loadResources(self)
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("BarResources/BarResources.plist")
end

function CErrorBox.layout(self)  --适配布局
    local winSize     = CCDirector:sharedDirector():getVisibleSize()
    if winSize.height == 640 then
        self.BoxBackGroundSprite : setPosition(winSize.width/2,320)
        self.TiShiInfoLabel : setPosition(winSize.width/2,410)
        self.BoxLineSprite  : setPosition(winSize.width/2,350)
        --self.BoxInfoLabel        : setPosition(winSize.width/2,350)
        if self.isTrue == 0 then
            self.BoxInfoLabel        : setPosition(winSize.width/2,330-20-10)
        elseif self.isTrue == 1 then
            self.m_RichTextBox       : setPosition(ccp(winSize.width/2- CErrorBox.RICHTEXT_W/2, winSize.height/2+CErrorBox.RICHTEXT_H/2-25))
        end 
        -- self.m_RichTextBox       : setPosition(ccp(winSize.width/2- CErrorBox.RICHTEXT_W/2, winSize.height/2+CErrorBox.RICHTEXT_H/2-25))
        self.BoxEnsureBtn        : setPosition(winSize.width/2,250)

        if self.CancelFunc ~= nil then     
            self.BoxEnsureBtn    : setPosition(winSize.width/2+70,250)
            self.BoxCancelBtn    : setPosition(winSize.width/2-70,250)
            self.BoxCancelBtn    : setVisible( true )
        end
    elseif winSize.height == 768 then
        print("768")
    end
end

function CErrorBox.init(self,_layer)
    self : loadResources()               --资源初始化
    self : initView(_layer)              --界面初始化
    self : layout()                      --适配布局初始化
    self : initParameter()               --参数初始化
end

function CErrorBox.initParameter(self)
    if self.String ~= nil then
        --self.BoxInfoLabel : setString(self.String)
        if self.isTrue == 0 then
            self.BoxInfoLabel : setString(self.String)
        elseif self.isTrue == 1 then
            self :addString( self.String)
        end 
    end
end

function CErrorBox.initView(self,_layer)
    --背景图
    self.BoxBackGroundSprite = CSprite : createWithSpriteFrameName("general_thirdly_underframe.png")       --box底图
    self.BoxBackGroundSprite : setPreferredSize(CCSizeMake(425,290))
    _layer                   : addChild (self.BoxBackGroundSprite)

    self.BoxBackGroundSprite : setFullScreenTouchEnabled(true)
    self.BoxBackGroundSprite : setTouchesPriority( -10000 )
    self.BoxBackGroundSprite : setTouchesEnabled(true)

    self.TiShiInfoLabel = CCLabelTTF :create("提示","Arial",24)        
    _layer              : addChild(self.TiShiInfoLabel,100) 

    --横线
    self.BoxLineSprite = CSprite : createWithSpriteFrameName("general_tips_line_4.png")       --box线条图
    self.BoxLineSprite : setScaleY(-1)
    --self.BoxLineSprite : setPreferredSize(CCSizeMake(425,290))
    _layer             : addChild (self.BoxLineSprite,10)

    local function callback( eventType, obj, x, y )
        return self : Callback( eventType, obj, x, y )
    end
    if self.isTrue == 0 then
    --说明显示
        --self.BoxInfoLabel = CCLabelTTF :create("补单时订单数据异常，充值额度和之前的不一致，需人工处理。","Arial",24)    
        self.BoxInfoLabel = CCLabelTTF :create("","Arial",18)    
        self.BoxInfoLabel : setHorizontalAlignment(kCCTextAlignmentCenter) --居中对齐 
        self.BoxInfoLabel : setDimensions( CCSizeMake(350,100))            --设置文字区
        self.BoxInfoLabel : setPosition(0,-80) 
        _layer            : addChild(self.BoxInfoLabel) 
    elseif self.isTrue == 1 then
        --显示RichText
        self.m_RichTextBox = CRichTextBox:create(CCSizeMake( CErrorBox.RICHTEXT_W, CErrorBox.RICHTEXT_H), ccc4(0,0,0,0))
        self.m_RichTextBox:setAutoScrollDown(true)
        self.m_RichTextBox:retain()
        --self.m_RichTextBox:setTouchesPriority(-25)
        self.m_RichTextBox:setTouchesEnabled(true)
        _layer:addChild( self.m_RichTextBox )
    end 

    --确认按钮
    self.BoxEnsureBtn = CButton : createWithSpriteFrameName("确定","general_button_normal.png")
    self.BoxEnsureBtn : setFontSize(24)
    self.BoxEnsureBtn : registerControlScriptHandler( callback, "this CErrorBox windowsEnsureBtnCallBack 247")
    self.BoxEnsureBtn : setTouchesPriority( -10001 )
    self.BoxEnsureBtn : setTag( CErrorBox.ENSURE_TAG )
    _layer            : addChild (self.BoxEnsureBtn)
    --取消按钮
    self.BoxCancelBtn = CButton : createWithSpriteFrameName("取消","general_button_normal.png")
    self.BoxCancelBtn : setVisible( false )
    self.BoxCancelBtn : setFontSize(24)
    self.BoxCancelBtn : registerControlScriptHandler( callback, "this CErrorBox windowsEnsureBtnCallBack 247")
    self.BoxCancelBtn : setTouchesPriority( -10001 )
    self.BoxCancelBtn : setTag( CErrorBox.CANCEL_TAG )
    _layer            : addChild (self.BoxCancelBtn)
end

function CErrorBox.getBoxEnsureBtn(self)
    return self.BoxEnsureBtn
end

function CErrorBox.getBoxCancelBtn(self)
    return self.BoxCancelBtn
end
function CErrorBox.getBoxRichText(self)
    return self.m_RichTextBox
end

function CErrorBox.setCurrentStyle(self, _color, _font, _fontsize)
    self.m_RichTextBox :setCurrentStyle( (_font or "Arial"), (_fontsize or CErrorBox.FONT_SIZE), (_color or (ccc4( 255,255,255,255))) )    
end

function CErrorBox.appendRichText(self, _Str)
    self.m_RichTextBox :appendRichText( _Str or "append string nil")
end

function CErrorBox.addString(self, _String, _color)  
    self.m_RichTextBox :setCurrentStyle( "Arial", CErrorBox.FONT_SIZE,  ( _color or ccc4( 255,255,255,255)) ) 
    self.m_RichTextBox :appendRichText( _String or "append string nil")     

end

function CErrorBox.Callback( self, eventType,obj,x,y )
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        local TAG_value = obj :getTag()
        if TAG_value == CErrorBox.ENSURE_TAG then
            print("确定按钮回调")
            if self.EnsureFunc ~= nil then
                self.EnsureFunc() ----外面传进来取消按钮的的function
            end
            self.Scenelayer : removeFromParentAndCleanup(true)
        elseif TAG_value == CErrorBox.CANCEL_TAG then
            print("取消按钮回调")
            if self.CancelFunc ~= nil then
                self.CancelFunc() ----外面传进来取消按钮的的function
            end
            self.Scenelayer : removeFromParentAndCleanup(true)
        end
    end
end













