-- --*********************************
-- --2013-8-17 by 陈元杰
-- --购买pup-CArtifactTipsBuyView
-- --*********************************
require "view/view"

CArtifactTipsBuyView = class(view,function (self)

end)

CArtifactTipsBuyView.OK_TAG       = 2
CArtifactTipsBuyView.CANCEL_TAG   = 3
CArtifactTipsBuyView.ADD_TAG      = 4
CArtifactTipsBuyView.REDUCE_TAG   = 5
CArtifactTipsBuyView.EDITBOX_TAG  = 6
CArtifactTipsBuyView.MAX_TAG      = 7


--CArtifactTipsBuyView 传入参数说明 (self,确定按钮里的function,取消按钮里面的function,单价)
function CArtifactTipsBuyView.create(self,_priceType,_price,_func,_Cancelfunc) 
    local winSize    = CCDirector:sharedDirector():getVisibleSize()
    self.Scenelayer  = CContainer :create()

    self.Scenelayer : setFullScreenTouchEnabled(true)
    self.Scenelayer : setTouchesPriority( -100 )
    self.Scenelayer : setTouchesEnabled(true)

    self.Yesfunc     = _func
    self.Cancelfunc  = _Cancelfunc
    self.m_priceType = _priceType
    self.m_price     = _price

    self : init (winSize,self.Scenelayer) 

    return self.Scenelayer
end

function CArtifactTipsBuyView.loadResources(self)
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("EquipmentResources/Equip.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist")
end

function CArtifactTipsBuyView.layout(self, _winSize)  --适配布局
    if _winSize.height == 640 then
        self.windowsBackGroundSprite : setPosition(_winSize.width/2,_winSize.height/2)
        self.windowsEnsureBtn        : setPosition(_winSize.width/2*0.854,_winSize.height/2*0.65)
        self.windowsCancelBtn        : setPosition(_winSize.width/2*1.16,_winSize.height/2*0.65)

        local editboxSize            = CCSizeMake( 100, 50)
        local maxbtnSize             = self.m_maxBtn    :getContentSize()
        local addbtnSize             = self.m_AddBtn    :getContentSize()
        local reducebtnSize          = self.m_ReduceBtn :getContentSize()
        local height                 = _winSize.height*0.6
        local width                  = _winSize.width/2
        self.m_editbox               : setPosition (width, height)
        self.m_maxBtn				 : setPosition (width, height - editboxSize.height/2 - maxbtnSize.height/2 - 5)
        self.m_AddBtn                : setPosition (width + editboxSize.width/2 + addbtnSize.width/2 + 5, height)
        self.m_ReduceBtn             : setPosition (width - editboxSize.width/2 - reducebtnSize.width/2 - 5, height)
        self.m_noticLabel            : setPosition (width,_winSize.height/2*0.85) 

    elseif _winSize.height == 768 then
        
    end
end

function CArtifactTipsBuyView.init(self, _winSize, _layer)
    self : loadResources()                        --资源初始化
    self : initParameter()                        --参数初始化
    self : initView(_winSize,_layer)  --界面初始化
    self : layout(_winSize)                       --适配布局初始化
end

function CArtifactTipsBuyView.initParameter(self)
    self.initnum        = 1 --记录editBox输入的数字
    self.maxCount       = 99 --记录能购买的最大次数
    self.priceName      = "未定义"

    local hasPrice = 0
    local mainProperty = _G.g_characterProperty : getMainPlay()
    if self.m_priceType == _G.Constant.CONST_CURRENCY_GOLD then 
        self.priceName = "美刀"
        hasPrice = mainProperty :getGold()
    elseif self.m_priceType == _G.Constant.CONST_CURRENCY_RMB or self.m_priceType == _G.Constant.CONST_CURRENCY_RMB_BIND then 
        self.priceName = "钻石"
        hasPrice = mainProperty :getRmb() + mainProperty :getBindRmb()
    elseif self.m_priceType > 1000 then
        -- hasPrice = 1000
    end  

    local maxCount = math.modf(hasPrice/self.m_price )
    if maxCount == 0 then 
        self.initnum        = 0
        self.maxCount       = 0
    elseif maxCount > 99 then 
        self.initnum        = 1
        self.maxCount       = 99
    else
        self.initnum        = 1
        self.maxCount       = maxCount
    end
end

function CArtifactTipsBuyView.initView(self,_winSize,_layer)
    --背景图
    self.windowsBackGroundSprite = CSprite : createWithSpriteFrameName("Equip_BackBox.png")       --box底图
    self.windowsBackGroundSprite : setScaleX(1)
    self.windowsBackGroundSprite : setScaleY(0.8)
    _layer                       : addChild (self.windowsBackGroundSprite)

    local function callback( eventType, obj, x, y )
        return self : allCallback( eventType, obj, x, y )
    end

    --max按钮
    self.m_maxBtn     = CButton :createWithSpriteFrameName("max","general_two_label_normal.png")
    self.m_maxBtn     : setControlName( "this CArtifactTipsBuyView self.m_maxBtn 59 ")
    self.m_maxBtn     : setTouchesPriority( -110 )
    self.m_maxBtn     : setTag(CArtifactTipsBuyView.MAX_TAG)
    self.m_maxBtn     : setScale(0.5)
    self.m_maxBtn     : setFontSize(45)
    self.m_maxBtn     : registerControlScriptHandler(callback, "this CArtifactTipsBuyView self.m_maxBtn 62")
    _layer            : addChild (self.m_maxBtn)

    --+按钮
    self.m_AddBtn     = CButton :createWithSpriteFrameName("","general_add_normal.png")
    self.m_AddBtn     : setControlName( "this CArtifactTipsBuyView self.m_AddBtn 59 ")
    self.m_AddBtn     : setTouchesPriority( -110 )
    self.m_AddBtn     : setTag(CArtifactTipsBuyView.ADD_TAG)
    self.m_AddBtn     : setFontSize(30)
    self.m_AddBtn     : registerControlScriptHandler(callback, "this CArtifactTipsBuyView self.m_AddBtn 62")
    _layer            : addChild (self.m_AddBtn)

    -- -按钮
    self.m_ReduceBtn  = CButton :createWithSpriteFrameName("","general_reduce_normal.png")
    self.m_ReduceBtn  : setControlName( "this CArtifactTipsBuyView self.m_ReduceBtn 70 ")
    self.m_ReduceBtn  : setTouchesPriority( -110 )
    self.m_ReduceBtn  : setTag(CArtifactTipsBuyView.REDUCE_TAG)
    self.m_ReduceBtn  : setFontSize(30)
    self.m_ReduceBtn  : registerControlScriptHandler(callback, "this CArtifactTipsBuyView self.m_ReduceBtn 73")
    _layer            : addChild (self.m_ReduceBtn)

    --数量输入显示
    local m_bgEditBox = CCScale9Sprite : createWithSpriteFrameName("general_two_label_normal.png")       --box底图
    self.m_editbox    = CEditBox :create( CCSizeMake( 100, 50),m_bgEditBox, 3, tostring(self.maxleftnum), kEditBoxInputFlagSensitive)
    self.m_editbox    : registerControlScriptHandler( callback, "this CArtifactTipsBuyView windowsEnsureBtnCallBack 247")
    self.m_editbox    : setTouchesPriority( -120 )  
    self.m_editbox    : setTextString(self.initnum)
    self.m_editbox    : setTag( CArtifactTipsBuyView.EDITBOX_TAG  )
    _layer            : addChild (self.m_editbox)

    self.m_noticLabel = CCLabelTTF :create("","Arial",25)
    _layer            : addChild(self.m_noticLabel)  

    --确认按钮
    self.windowsEnsureBtn = CButton : createWithSpriteFrameName("确认","general_two_button_normal.png")
    self.windowsEnsureBtn : registerControlScriptHandler( callback, "this CArtifactTipsBuyView windowsEnsureBtnCallBack 247")
    self.windowsEnsureBtn : setTouchesPriority( -101 )
    self.windowsEnsureBtn : setFontSize( 26 )
    self.windowsEnsureBtn : setTag( CArtifactTipsBuyView.OK_TAG )
    _layer                : addChild (self.windowsEnsureBtn)

    --取消按钮
    self.windowsCancelBtn = CButton : createWithSpriteFrameName("取消","general_two_button_normal.png")
    self.windowsCancelBtn : registerControlScriptHandler( callback, "this CArtifactTipsBuyView windowsCancelBtnCallBack 255")
    self.windowsCancelBtn : setTouchesPriority( -101 )
    self.windowsCancelBtn : setFontSize( 26 )
    self.windowsCancelBtn : setTag( CArtifactTipsBuyView.CANCEL_TAG )
    _layer                : addChild (self.windowsCancelBtn)

    if self.initnum == 0 then 
        self.windowsEnsureBtn :setTouchesEnabled( false )
    end

    self :refreshView()
end

function CArtifactTipsBuyView.allCallback( self, eventType,obj,x,y )
    if eventType == "TouchBegan" then
        return true
    elseif eventType == "TouchEnded" then
        if obj:containsPoint( obj:convertToNodeSpaceAR( ccp( x, y ) ) ) then
            print("allCallback obj: tag==",obj : getTag())
            if obj : getTag() == CArtifactTipsBuyView.OK_TAG then

                print("windows板面确定按钮回调")
                if self.Yesfunc ~= nil  then 
                    self.Yesfunc( self.initnum )
                end
                self.Scenelayer : removeFromParentAndCleanup(true)

            elseif obj : getTag() == CArtifactTipsBuyView.CANCEL_TAG then

                print("windows板面取消按钮回调")
                self.Scenelayer : removeFromParentAndCleanup(true)
                if self.Cancelfunc ~= nil then
                    self.Cancelfunc() --外面传进来取消按钮的的function，一般为关闭function
                end

            elseif obj : getTag() == CArtifactTipsBuyView.ADD_TAG then

                self.initnum = self.initnum + 1
                if self.initnum > self.maxCount then
                    self.initnum = self.maxCount
                end
                self :refreshView()

            elseif obj : getTag() == CArtifactTipsBuyView.REDUCE_TAG then

                self.initnum = self.initnum - 1
                if self.maxCount == 0 then
                    self.initnum = 0
                elseif self.initnum <= 0 then 
                    self.initnum = 1
                end
                self :refreshView()

            elseif obj : getTag() == CArtifactTipsBuyView.MAX_TAG then 
                self.initnum = self.maxCount
                self :refreshView()
            end
        end
    elseif eventType == "EditBoxReturn" then
        print("Editbox输入回调")

        self.isstring = string.match(x , "%d+")

        if self.isstring ~=nil then
            self.initnum = tonumber( self.isstring )
        end  
        self :refreshView()

    end

end


function CArtifactTipsBuyView.refreshView( self )

    local useRmb = tonumber(self.m_price)*self.initnum
    self.m_noticLabel : setString( "需要"..self.priceName..":"..useRmb )
    self.m_editbox    : setTextString(self.initnum)

    if self.initnum > 0 then 
        self.windowsEnsureBtn :setTouchesEnabled( true )
    else 
        self.windowsEnsureBtn :setTouchesEnabled( false )
    end

end




