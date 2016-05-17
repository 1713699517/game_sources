require "view/view"

CEquipTipsBox = class(view,function (self)

                          end)

CEquipTipsBox.OK_TAG       = 2
CEquipTipsBox.CANCEL_TAG   = 3
CEquipTipsBox.ADD_TAG      = 4
CEquipTipsBox.REDUCE_TAG   = 5
CEquipTipsBox.EDITBOX_TAG  = 6


--CEquipTipsBox 传入参数说明 (self,确定按钮里的function（发送协议）,弹出框显示的文字,是否显示checkBox按钮（1为显示）,取消按钮里面的function,剩余数量最大值)
function CEquipTipsBox.create(self,_func,_Cancelfunc,_theGoodData,_maxnum) --String为说明显示的字符串
    local winSize    = CCDirector:sharedDirector():getVisibleSize()
    self.Scenelayer  = CContainer :create()

    self.Scenelayer : setFullScreenTouchEnabled(true)
    self.Scenelayer : setTouchesPriority( -100 )
    self.Scenelayer : setTouchesEnabled(true)

    self.func        = _func
    self.Cancelfunc  = _Cancelfunc
    self.theGoodData = _theGoodData

    if _maxnum ~= nil then
        self.maxleftnum  = _maxnum
        self.initnum     = _maxnum
    end

    self : init (winSize,self.Scenelayer) 

    return self.Scenelayer
end

function CEquipTipsBox.loadResources(self)
    -- CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("EquipmentResources/Equip.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist")

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("Shop/ShopReSources.plist")
end

function CEquipTipsBox.layout(self, _winSize)  --适配布局
    if _winSize.height == 640 then
        self.windowsBackGroundSprite : setPosition(480,320)
        self.windowsEnsureBtn        : setPosition(555,180)
        self.windowsCancelBtn        : setPosition(410,180)

        self.TheGoodBtn              : setPosition (480,460-10)
        self.m_editbox               : setPosition (480,270)
        self.m_editboxLabel          : setPosition (370,270) 
        self.m_AddBtn                : setPosition (576,270)
        self.m_ReduceBtn             : setPosition (625,270)

    elseif _winSize.height == 768 then
        self.windowsBackGroundSprite : setPosition(480,320)
        self.windowsEnsureBtn        : setPosition(410,180)
        self.windowsCancelBtn        : setPosition(555,180)

        self.TheGoodBtn              : setPosition (480,460)
        self.m_editbox               : setPosition (480,270)
        self.m_editboxLabel          : setPosition (370,270) 
        self.m_AddBtn                : setPosition (576,270)
        self.m_ReduceBtn             : setPosition (625,270)
    end
end

function CEquipTipsBox.init(self, _winSize, _layer)
    self : loadResources()                        --资源初始化
    self : initView(_winSize,_layer)              --界面初始化
    self : layout(_winSize)                       --适配布局初始化
    self : initParameter()                        --参数初始化
end

function CEquipTipsBox.initParameter(self)
    --self.initnum        = 0
    self.isaddorreduce  = 0
    self.theGoodsSprite = nil

    local name  =  self.theGoodData : getAttribute("name") 
    local icon  =  self.theGoodData : getAttribute("icon") 

    local icon_url       = "Icon/i"..icon..".jpg"
    self.theGoodsSprite  = CSprite : create(icon_url)            
    self.TheGoodBtn      : addChild(self.theGoodsSprite,-1)

    self.TheGoodBtnLabel : setString (name)
    --物品价格 判断VIP等级
    local s_price  = self.theGoodData : getAttribute("price")                    --物品现价
    local v_price  = self.theGoodData : getAttribute("price")                    --物品VIP价格 
    local CurrencyType = CLanguageManager:sharedLanguageManager():getString(tostring("Currency_Type_"..self.theGoodData : getAttribute("price_type")))
    --[[
    if self.theGoodData.price_type == 1 then
        CurrencyType = "美刀"
    elseif self.theGoodData.price_type == 2 then
        CurrencyType = "钻石"
    end
    ]]
    local m_mainPlay_Viplv = tonumber( _G.g_characterProperty : getMainPlay() : getVipLv() ) 
    if m_mainPlay_Viplv >= 6 then
        self.TheGoodPriceLabel : setString("价格 : "..v_price..CurrencyType,"Arial",20)
    else
        self.TheGoodPriceLabel : setString("价格 : "..s_price..CurrencyType,"Arial",20)
    end
    --获取人物Vip等级
    self.isok_viplv = nil
    local m_mainPlay_Viplv = tonumber( _G.g_characterProperty : getMainPlay() : getVipLv() ) 
    print("CEquipTipsBox.initParameter 90",m_mainPlay_Viplv,_G.Constant.CONST_MALL_VIP_EFFECT)
    local viplimitedlv =tonumber( _G.Constant.CONST_MALL_VIP_EFFECT )  -- VIP6增加一键制作功能
    if m_mainPlay_Viplv >= viplimitedlv then
        self.isok_viplv = 1
    else
        self.isok_viplv = 0 
    end
end

function CEquipTipsBox.initView(self,_winSize,_layer)
    --背景图
    self.windowsBackGroundSprite = CSprite : createWithSpriteFrameName("general_thirdly_underframe.png")       --box底图

    self.windowsBackGroundSprite : setPreferredSize(CCSizeMake(370,400))

    _layer                       : addChild (self.windowsBackGroundSprite)

    local function callback( eventType, obj, x, y )
        return self : allCallback( eventType, obj, x, y )
    end
    --物品
    self.TheGoodBtn = CButton :createWithSpriteFrameName("","general_props_frame_normal.png")
    self.TheGoodBtn : setTouchesPriority(-110)   
    _layer          : addChild(self.TheGoodBtn)

    self.TheGoodBtnLabel = CCLabelTTF :create("物品名称","Arial",24)
    self.TheGoodBtnLabel : setPosition(0,-70-10) 
    self.TheGoodBtn      : addChild(self.TheGoodBtnLabel)  

    self.TheGoodPriceLabel = CCLabelTTF :create("物品价格","Arial",24)
    self.TheGoodPriceLabel : setColor(ccc3(255,255,0))
    self.TheGoodPriceLabel : setPosition(0,-110-10) 
    self.TheGoodBtn      : addChild(self.TheGoodPriceLabel)  

    --+按钮
    self.m_AddBtn     = CButton :createWithSpriteFrameName("","shop_button_add_normal.png")
    self.m_AddBtn     : setControlName( "this CEquipTipsBox self.m_AddBtn 59 ")
    self.m_AddBtn     : setTouchesPriority( -110 )
    self.m_AddBtn     : setTag(CEquipTipsBox.ADD_TAG)
    self.m_AddBtn     : registerControlScriptHandler(callback, "this CEquipTipsBox self.m_AddBtn 62")
    _layer            : addChild (self.m_AddBtn)

    -- -按钮
    self.m_ReduceBtn  = CButton :createWithSpriteFrameName("","shop_button_subtract_normal.png")
    self.m_ReduceBtn  : setControlName( "this CEquipTipsBox self.m_ReduceBtn 70 ")
    self.m_ReduceBtn  : setTouchesPriority( -110 )
    self.m_ReduceBtn  : setTag(CEquipTipsBox.REDUCE_TAG)
    self.m_ReduceBtn  : registerControlScriptHandler(callback, "this CEquipTipsBox self.m_ReduceBtn 73")
    _layer            : addChild (self.m_ReduceBtn)

    --数量输入显示
    local m_bgEditBox = CCScale9Sprite : createWithSpriteFrameName("general_second_underframe.png")       --box底图
    self.m_editbox    = CEditBox :create( CCSizeMake( 100, 50),m_bgEditBox, 5, tostring(self.maxleftnum), kEditBoxInputFlagSensitive)
    self.m_editbox    : setEditBoxInputMode( kEditBoxInputModePhoneNumber)
    self.m_editbox    : registerControlScriptHandler( callback, "this CEquipTipsBox windowsEnsureBtnCallBack 247")
    self.m_editbox    : setTouchesPriority( -120 )  
    self.m_editbox    : setTag( CEquipTipsBox.EDITBOX_TAG  )
    _layer            : addChild (self.m_editbox)

    self.m_editboxLabel = CCLabelTTF :create("合成数量 : ","Arial",24)
    _layer              : addChild(self.m_editboxLabel)  

    --确认按钮
    self.windowsEnsureBtn = CButton : createWithSpriteFrameName("确认","general_button_normal.png")
    self.windowsEnsureBtn : setFontSize(24)
    self.windowsEnsureBtn : registerControlScriptHandler( callback, "this CEquipTipsBox windowsEnsureBtnCallBack 247")
    self.windowsEnsureBtn : setTouchesPriority( -101 )
    self.windowsEnsureBtn : setTag( CEquipTipsBox.OK_TAG )
    _layer                : addChild (self.windowsEnsureBtn)

    --取消按钮
    self.windowsCancelBtn = CButton : createWithSpriteFrameName("取消","general_button_normal.png")
    self.windowsCancelBtn : setFontSize(24)
    self.windowsCancelBtn : registerControlScriptHandler( callback, "this CEquipTipsBox windowsCancelBtnCallBack 255")
    self.windowsCancelBtn : setTouchesPriority( -101 )
    self.windowsCancelBtn : setTag( CEquipTipsBox.CANCEL_TAG )
    _layer                : addChild (self.windowsCancelBtn)
end

function CEquipTipsBox.allCallback( self, eventType,obj,x,y )
    if eventType == "TouchBegan" then
        return true
    elseif eventType == "TouchEnded" then
        if obj:containsPoint( obj:convertToNodeSpaceAR( ccp( x, y ) ) ) then
            print("allCallback obj: tag==",obj : getTag())
            if obj : getTag() == CEquipTipsBox.OK_TAG then
                    print("windows板面确定按钮回调")
                    local buycount    = nil
                    buycount = self.initnum

                    if self.isaddorreduce == 0 then
                        buycount = 1 
                    end
  
                    if self.func ~= nil then
                        self.func() --外面传进来的function，一般为发送协议function
                    else
                        print("我要合成的个数大概有这么多===",self.initnum)
                        self : setinitnumCommand(self.initnum)   
                    end

                    self.Scenelayer : removeFromParentAndCleanup(true)

            elseif obj : getTag() == CEquipTipsBox.CANCEL_TAG then
                    print("windows板面取消按钮回调")
                    self.Scenelayer : removeFromParentAndCleanup(true)
                    if self.Cancelfunc ~= nil then
                        self.Cancelfunc() --外面传进来取消按钮的的function，一般为关闭function
                    end

            elseif obj : getTag() == CEquipTipsBox.ADD_TAG then
                    self.isaddorreduce = 1
                    if  self.initnum <= self.maxleftnum then
                        self.windowsEnsureBtn : setTouchesEnabled (true)
                    else
                        self.windowsEnsureBtn : setTouchesEnabled (false)
                    end

                    if self.theGoodData.total_remaider_Num ~= _G.Constant.CONST_MALL_LIMIT then
                        if self.maxleftnum > self.initnum then 
                            self.initnum =self.initnum + 1
                        end
                    else
                        self.initnum =self.initnum + 1
                    end
                    print ("ADD_TAG--->>",self.initnum)
                    self.m_editbox : setTextString(self.initnum)

            elseif obj : getTag() == CEquipTipsBox.REDUCE_TAG then
                    self.isaddorreduce = 1
                    print("----e343434",self.initnum,self.maxleftnum)
                    -- if self.initnum == 0 then
                    --     self.initnum = self.maxleftnum
                    -- end
                    if self.initnum > 0 then
                        self.initnum =self.initnum - 1
                        print ("REDUCE--->>",self.initnum)
                        self.m_editbox : setTextString(self.initnum)
                    end
                    if  self.initnum <= self.maxleftnum then
                        self.windowsEnsureBtn : setTouchesEnabled (true)
                    else
                        self.windowsEnsureBtn : setTouchesEnabled (false)
                    end
            end
        end
    elseif eventType == "EditBoxReturn" then
        print("Editbox输入回调")
        self.isaddorreduce = 1
        self.isstring = string.match(x , "%d+")

        if self.isstring ==nil then
            local msg = "输入数值为非数字，请从新输入"
            self : createMessageBox(msg)
            self.windowsEnsureBtn : setTouchesEnabled (false)
        else
            -- self.thebuycount = self.m_editbox : getTextString()
            local thebuycount = self.m_editbox : getTextString()
            self.initnum      = tonumber(thebuycount)
            if  self.initnum <= self.maxleftnum then
                self.windowsEnsureBtn : setTouchesEnabled (true)
            else
                self.windowsEnsureBtn : setTouchesEnabled (false)
            end
        end  
        print("thebuycount--->",self.thebuycount)
    end

end

function CEquipTipsBox.setinitnumCommand(self,value)
    require "model/VO_EquipComposeModel"
    require "controller/EquipComposeCommand"
    local model = VO_EquipComposeModel ()
    model      : setEquipinitnum(value)
    local equipComposeCommand = CEquipComposeCommand(model)
    controller:sendCommand(equipComposeCommand)  
end

function CEquipTipsBox.createMessageBox(self,_msg)
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg)
    self.Scenelayer : addChild(BoxLayer,1000)
end





