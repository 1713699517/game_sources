require "view/view"

CAdditionAndsubtractionPopBox = class(view,function (self)

                          end)

CAdditionAndsubtractionPopBox.OK_TAG       = 2
CAdditionAndsubtractionPopBox.CANCEL_TAG   = 3
CAdditionAndsubtractionPopBox.ADD_TAG      = 4
CAdditionAndsubtractionPopBox.REDUCE_TAG   = 5
CAdditionAndsubtractionPopBox.EDITBOX_TAG  = 6


--CAdditionAndsubtractionPopBox 传入参数说明 (self,确定按钮里的function（发送协议）,弹出框显示的文字,是否显示checkBox按钮（1为显示）,取消按钮里面的function,剩余数量最大值)
function CAdditionAndsubtractionPopBox.create(self,_func,_Cancelfunc,_theGoodData) --String为说明显示的字符串
    local winSize    = CCDirector:sharedDirector():getVisibleSize()
    self.Scenelayer  = CContainer :create()

    self.Scenelayer : setFullScreenTouchEnabled(true)
    self.Scenelayer : setTouchesPriority( -100 )
    self.Scenelayer : setTouchesEnabled(true)

    self.func        = _func
    self.Cancelfunc  = _Cancelfunc
    self.theGoodData = _theGoodData
    print("CAdditionAndsubtractionPopBox.create ",_theGoodData.total_remaider_Num)
    if _theGoodData.total_remaider_Num == _G.Constant.CONST_MALL_LIMIT then
        self.maxleftnum  = 1
    else
        self.maxleftnum  = _theGoodData.total_remaider_Num --剩余物品总数量 -1为无限
    end

    self : init (winSize,self.Scenelayer) 

    return self.Scenelayer
end

function CAdditionAndsubtractionPopBox.loadResources(self)
    -- CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("EquipmentResources/Equip.plist")
    --CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist")

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("Shop/ShopReSources.plist")
end

function CAdditionAndsubtractionPopBox.layout(self, _winSize)  --适配布局
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

function CAdditionAndsubtractionPopBox.init(self, _winSize, _layer)
    self : loadResources()                        --资源初始化
    self : initView(_winSize,_layer)  --界面初始化
    self : layout(_winSize)                       --适配布局初始化
    self : initParameter()                        --参数初始化
end

function CAdditionAndsubtractionPopBox.initParameter(self)
    self.initnum        = 1
    self.isaddorreduce  = 0
    self.theGoodsSprite = nil

    local name  =  self.theGoodData.name 
    local icon  =  self.theGoodData.icon 

    local icon_url       = "Icon/i"..icon..".jpg"
    self.theGoodsSprite  = CSprite : create(icon_url)            
    self.TheGoodBtn      : addChild(self.theGoodsSprite,-1)

    self.TheGoodBtnLabel : setString (name)
    --物品价格 判断VIP等级
    local s_price  = self.theGoodData.s_price                 --物品现价
    local v_price  = self.theGoodData.v_price                 --物品VIP价格 
    local CurrencyType = CLanguageManager:sharedLanguageManager():getString(tostring("Currency_Type_"..self.theGoodData.price_type))
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
    print("CAdditionAndsubtractionPopBox.initParameter 90",m_mainPlay_Viplv,_G.Constant.CONST_MALL_VIP_EFFECT)
    local viplimitedlv =tonumber( _G.Constant.CONST_MALL_VIP_EFFECT )  -- VIP6增加一键制作功能
    if m_mainPlay_Viplv >= viplimitedlv then
        self.isok_viplv = 1
    else
        self.isok_viplv = 0 
    end
end

function CAdditionAndsubtractionPopBox.initView(self,_winSize,_layer)
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
    self.TheGoodBtnLabel : setPosition(0,-70) 
    self.TheGoodBtn      : addChild(self.TheGoodBtnLabel)  

    self.TheGoodPriceLabel = CCLabelTTF :create("物品价格","Arial",24)
    self.TheGoodPriceLabel : setColor(ccc3(255,255,0))
    self.TheGoodPriceLabel : setPosition(0,-110) 
    self.TheGoodBtn      : addChild(self.TheGoodPriceLabel)  

    --+按钮
    self.m_AddBtn     = CButton :createWithSpriteFrameName("","shop_button_add_normal.png")
    self.m_AddBtn     : setControlName( "this CAdditionAndsubtractionPopBox self.m_AddBtn 59 ")
    self.m_AddBtn     : setTouchesPriority( -110 )
    self.m_AddBtn     : setTag(CAdditionAndsubtractionPopBox.ADD_TAG)
    self.m_AddBtn     : registerControlScriptHandler(callback, "this CEquipTipsBox self.m_AddBtn 62")
    _layer            : addChild (self.m_AddBtn)

    -- -按钮
    self.m_ReduceBtn  = CButton :createWithSpriteFrameName("","shop_button_subtract_normal.png")
    self.m_ReduceBtn  : setControlName( "this CAdditionAndsubtractionPopBox self.m_ReduceBtn 70 ")
    self.m_ReduceBtn  : setTouchesPriority( -110 )
    self.m_ReduceBtn  : setTag(CAdditionAndsubtractionPopBox.REDUCE_TAG)
    self.m_ReduceBtn  : registerControlScriptHandler(callback, "this CEquipTipsBox self.m_ReduceBtn 73")
    _layer            : addChild (self.m_ReduceBtn)

    --数量输入显示
    local m_bgEditBox = CCScale9Sprite : createWithSpriteFrameName("general_second_underframe.png")       --box底图
    self.m_editbox    = CEditBox :create( CCSizeMake( 100, 50),m_bgEditBox, 5, tostring(self.maxleftnum), kEditBoxInputFlagSensitive)
    self.m_editbox    : setEditBoxInputMode( kEditBoxInputModePhoneNumber)
    self.m_editbox    : registerControlScriptHandler( callback, "this CAdditionAndsubtractionPopBox windowsEnsureBtnCallBack 247")
    self.m_editbox    : setTouchesPriority( -120 )  
    self.m_editbox    : setTag( CAdditionAndsubtractionPopBox.EDITBOX_TAG  )
    _layer            : addChild (self.m_editbox)

    self.m_editboxLabel = CCLabelTTF :create("购买数量: ","Arial",24)
    _layer              : addChild(self.m_editboxLabel)  

    --确认按钮
    self.windowsEnsureBtn = CButton : createWithSpriteFrameName("确认","general_button_normal.png")
    self.windowsEnsureBtn : setFontSize(24)
    self.windowsEnsureBtn : registerControlScriptHandler( callback, "this CAdditionAndsubtractionPopBox windowsEnsureBtnCallBack 247")
    self.windowsEnsureBtn : setTouchesPriority( -101 )
    self.windowsEnsureBtn : setTag( CAdditionAndsubtractionPopBox.OK_TAG )
    _layer                : addChild (self.windowsEnsureBtn)

    --取消按钮
    self.windowsCancelBtn = CButton : createWithSpriteFrameName("取消","general_button_normal.png")
    self.windowsCancelBtn : setFontSize(24)
    self.windowsCancelBtn : registerControlScriptHandler( callback, "this CAdditionAndsubtractionPopBox windowsCancelBtnCallBack 255")
    self.windowsCancelBtn : setTouchesPriority( -101 )
    self.windowsCancelBtn : setTag( CAdditionAndsubtractionPopBox.CANCEL_TAG )
    _layer                : addChild (self.windowsCancelBtn)
end

function CAdditionAndsubtractionPopBox.allCallback( self, eventType,obj,x,y )
    if eventType == "TouchBegan" then
        return true
    elseif eventType == "TouchEnded" then
        if obj:containsPoint( obj:convertToNodeSpaceAR( ccp( x, y ) ) ) then
            print("allCallback obj: tag==",obj : getTag())
            if obj : getTag() == CAdditionAndsubtractionPopBox.OK_TAG then
                    print("windows板面确定按钮回调")
                    local buycount    = nil
                    if self.thebuycount ~= nil then
                        buycount = self.thebuycount
                    else
                        buycount = self.initnum
                    end
                    if self.isaddorreduce == 0 then
                        buycount = 1 
                    end
                    local isEnoughMoney = 1--self : CompareMoney(buycount) 
                    if isEnoughMoney == 1 then  --金额判断
                        if self.func ~= nil then
                            self.func() --外面传进来的function，一般为发送协议function
                        else
                            local mall_type   = self.theGoodData.mall_type
                            local mall_typebb = self.theGoodData.mall_typebb
                            local idx         = self.theGoodData.idx
                            local id          = self.theGoodData.id
                            local ctype       = self.theGoodData.price_type
                            -- local buycount    = nil

                            -- if self.thebuycount ~= nil then
                            --     buycount = self.thebuycount
                            -- else
                            --     buycount = self.initnum
                            -- end
                            -- if self.isaddorreduce == 0 then
                            --     buycount = 1 
                            -- end
                            self : NetWorkSend(mall_type,mall_typebb,idx,id,buycount,ctype)     
                        end
                    elseif isEnoughMoney == 0 then

                        local msg = "金额不足"
                        self : createMessageBox(msg)
                    end
                    self.Scenelayer : removeFromParentAndCleanup(true)

            elseif obj : getTag() == CAdditionAndsubtractionPopBox.CANCEL_TAG then
                    print("windows板面取消按钮回调")
                    self.Scenelayer : removeFromParentAndCleanup(true)
                    if self.Cancelfunc ~= nil then
                        self.Cancelfunc() --外面传进来取消按钮的的function，一般为关闭function
                    end

            elseif obj : getTag() == CAdditionAndsubtractionPopBox.ADD_TAG then
                    self.isaddorreduce = 1
                    -- if self.initnum == 0 then
                    --     self.initnum = self.maxleftnum
                    -- end

                    if self.theGoodData.total_remaider_Num ~= _G.Constant.CONST_MALL_LIMIT then
                        if self.maxleftnum > self.initnum then 
                            self.initnum =self.initnum + 1
                        end
                    else
                        self.initnum =self.initnum + 1
                    end
                    print ("ADD_TAG--->>",self.initnum)
                    self.m_editbox : setTextString(self.initnum)

            elseif obj : getTag() == CAdditionAndsubtractionPopBox.REDUCE_TAG then
                    self.isaddorreduce = 1
                    if self.initnum == 0 then
                        self.initnum = self.maxleftnum
                    end
                    self.initnum =self.initnum - 1
                    print ("REDUCE--->>",self.initnum)
                    self.m_editbox : setTextString(self.initnum)
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
            self.windowsEnsureBtn : setTouchesEnabled (true)
        end  
        print("thebuycount--->",self.thebuycount)
    end

end

--商城购买发送请求
function CAdditionAndsubtractionPopBox.NetWorkSend(self,_type,_type_bb,_idx,_goodsId,_Count,_ctype)
    print("---商城购买发送请求--->",_type,_type_bb,_idx,_goodsId,_Count,_ctype)
    --向服务器发送页面数据请求
    require "common/protocol/auto/REQ_SHOP_BUY"
    local msg = REQ_SHOP_BUY()
    msg :setType    (_type)    --商店类型
    msg :setTypeBb  (_type_bb) --商店子类型 
    msg :setIdx     (_idx)     --物品数据索引
    msg :setGoodsId (_goodsId) --{物品id 
    msg :setCount   (_Count)   --购买数量
    msg :setCtype   (_ctype)   --货币类型
    CNetwork : send(msg)
    print("CAdditionAndsubtractionPopBox NetWorkSend页面发送数据请求,完毕 203")
end

function CAdditionAndsubtractionPopBox.CompareMoney(self,_buycount)
    local mainProperty = _G.g_characterProperty : getMainPlay()

    --获取美刀
    self.m_GoldNum     = tonumber(mainProperty :getGold()) 
    if self.m_GoldNum  == nil then
        self.m_GoldNum = 0
    end
    --获取钻石
    self.m_RmbNum     = tonumber(mainProperty :getBindRmb()) 
    if self.m_RmbNum  == nil then
        self.m_RmbNum = 0
    end
    --VIP就价格优惠判断
    local allmoney = nil 
    if self.isok_viplv == 1 then
        allmoney  = self.theGoodData.v_price * _buycount
    elseif self.isok_viplv == 0 then
        allmoney  = self.theGoodData.s_price * _buycount
    end

    local moneytype = self.theGoodData.price_type
    print("CAdditionAndsubtractionPopBox.CompareMoney--->",self.isok_viplv,moneytype,allmoney,self.m_GoldNum,self.m_RmbNum)
    if moneytype == 1 then --美刀
        if self.m_GoldNum > allmoney then
            return 1 
        else
            return 0
        end

    elseif moneytype == 2 then --钻石
        if self.m_RmbNum > allmoney then
            return 1 
        else
             return 0
        end
    end
end
--vip 等级暂未做限制

function CAdditionAndsubtractionPopBox.createMessageBox(self,_msg)
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg)
    self.Scenelayer : addChild(BoxLayer,1000)
end





