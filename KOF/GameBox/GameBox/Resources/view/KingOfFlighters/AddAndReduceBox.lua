require "view/view"

CAddAndReduceBox = class(view,function (self)

                          end)

CAddAndReduceBox.OK_TAG       = 2
CAddAndReduceBox.CANCEL_TAG   = 3
CAddAndReduceBox.ADD_TAG      = 4
CAddAndReduceBox.REDUCE_TAG   = 5
CAddAndReduceBox.EDITBOX_TAG  = 6



function CAddAndReduceBox.create(self,_func,_Canc,_uid1,_uid2) --String为说明显示的字符串
    local winSize    = CCDirector:sharedDirector():getVisibleSize()
    self.Scenelayer  = CContainer :create()

    self.Scenelayer : setFullScreenTouchEnabled(true)
    self.Scenelayer : setTouchesPriority( -100 )
    self.Scenelayer : setTouchesEnabled(true)

    self.func        = _func
    self.Cancelfunc  = _Cancelfunc
    self.uid1        = _uid1
    self.uid2        = _uid2
    print("CAddAndReduceBox.create ")

    self : init (winSize,self.Scenelayer) 

    return self.Scenelayer
end

function CAddAndReduceBox.loadResources(self)

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("Shop/ShopReSources.plist")
end

function CAddAndReduceBox.unloadResources(self)
    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("Shop/ShopReSources.plist")
    
    CCTextureCache:sharedTextureCache():removeUnusedTextures()
end

function CAddAndReduceBox.layout(self, _winSize)  --适配布局
    self.windowsBackGroundSprite : setPosition(480,320)
    self.windowsEnsureBtn        : setPosition(555,240)
    self.windowsCancelBtn        : setPosition(410,240)

    self.m_editbox               : setPosition (480,330)
    self.m_editboxLabel          : setPosition (365,330) 
    self.m_AddBtn                : setPosition (625,330)
    self.m_ReduceBtn             : setPosition (576,330)
end

function CAddAndReduceBox.init(self, _winSize, _layer)
    self : loadResources()                        --资源初始化
    self : initView(_winSize,_layer)  --界面初始化
    self : layout(_winSize)                       --适配布局初始化
    self : initParameter()                        --参数初始化
end

function CAddAndReduceBox.initParameter(self)
    self.initnum        = 1
    self.isaddorreduce  = 0
    self.isbuycountOne  = 0
    self.theGoodsSprite = nil
end

function CAddAndReduceBox.initView(self,_winSize,_layer)
    --背景图
    self.windowsBackGroundSprite = CSprite : createWithSpriteFrameName("general_thirdly_underframe.png")       --box底图

    self.windowsBackGroundSprite : setPreferredSize(CCSizeMake(420,280))

    _layer                       : addChild (self.windowsBackGroundSprite)

    local function callback( eventType, obj, x, y )
        return self : allCallback( eventType, obj, x, y )
    end

    --+按钮
    self.m_AddBtn     = CButton :createWithSpriteFrameName("+","shop_button_add_normal.png")
    self.m_AddBtn     : setControlName( "this CAddAndReduceBox self.m_AddBtn 59 ")
    self.m_AddBtn     : setTouchesPriority( -110 )
    self.m_AddBtn     : setTag(CAddAndReduceBox.ADD_TAG)
    self.m_AddBtn     : setFontSize(30)
    self.m_AddBtn     : registerControlScriptHandler(callback, "this CEquipTipsBox self.m_AddBtn 62")
    _layer            : addChild (self.m_AddBtn)

    -- -按钮
    self.m_ReduceBtn  = CButton :createWithSpriteFrameName("-","shop_button_subtract_normal.png")
    self.m_ReduceBtn  : setControlName( "this CAddAndReduceBox self.m_ReduceBtn 70 ")
    self.m_ReduceBtn  : setTouchesPriority( -110 )
    self.m_ReduceBtn  : setTag(CAddAndReduceBox.REDUCE_TAG)
    self.m_ReduceBtn  : setFontSize(30)
    self.m_ReduceBtn  : registerControlScriptHandler(callback, "this CEquipTipsBox self.m_ReduceBtn 73")
    _layer            : addChild (self.m_ReduceBtn)

    --数量输入显示
    local m_bgEditBox = CCScale9Sprite : createWithSpriteFrameName("general_second_underframe.png")       --box底图
    self.m_editbox    = CEditBox :create( CCSizeMake( 100, 50),m_bgEditBox, 5, tostring(1), kEditBoxInputFlagSensitive)
    self.m_editbox    : setEditBoxInputMode( kEditBoxInputModePhoneNumber)
    self.m_editbox    : registerControlScriptHandler( callback, "this CAddAndReduceBox windowsEnsureBtnCallBack 247")
    self.m_editbox    : setTouchesPriority( -120 )  
    self.m_editbox    : setTag( CAddAndReduceBox.EDITBOX_TAG  )
    _layer            : addChild (self.m_editbox)

    self.m_editboxLabel = CCLabelTTF :create("下注钻石数量 : ","Arial",18)
    _layer              : addChild(self.m_editboxLabel)  

    --确认按钮
    self.windowsEnsureBtn = CButton : createWithSpriteFrameName("确定","general_button_normal.png")
    self.windowsEnsureBtn : setFontSize(24)
    self.windowsEnsureBtn : registerControlScriptHandler( callback, "this CAddAndReduceBox windowsEnsureBtnCallBack 247")
    self.windowsEnsureBtn : setTouchesPriority( -101 )
    self.windowsEnsureBtn : setTag( CAddAndReduceBox.OK_TAG )
    _layer                : addChild (self.windowsEnsureBtn)

    --取消按钮
    self.windowsCancelBtn = CButton : createWithSpriteFrameName("取消","general_button_normal.png")
    self.windowsCancelBtn : setFontSize(24)
    self.windowsCancelBtn : registerControlScriptHandler( callback, "this CAddAndReduceBox windowsCancelBtnCallBack 255")
    self.windowsCancelBtn : setTouchesPriority( -101 )
    self.windowsCancelBtn : setTag( CAddAndReduceBox.CANCEL_TAG )
    _layer                : addChild (self.windowsCancelBtn)
end

function CAddAndReduceBox.allCallback( self, eventType,obj,x,y )
    if eventType == "TouchBegan" then
        return true
    elseif eventType == "TouchEnded" then
        if obj:containsPoint( obj:convertToNodeSpaceAR( ccp( x, y ) ) ) then
            print("allCallback obj: tag==",obj : getTag())
            if obj : getTag() == CAddAndReduceBox.OK_TAG then
                    print("windows板面确定按钮回调")
                    local buycount    = nil
                    if self.thebuycount ~= nil and self.isbuycountOne == 0 then
                        buycount = self.thebuycount
                        self.isbuycountOne = 1
                    else
                        buycount = self.initnum
                    end
                    if self.isaddorreduce == 0 then
                        buycount = 1 
                    end
                    local isEnoughMoney = self : CompareMoney(buycount) 
                    if isEnoughMoney == 1 then  --金额判断 
                        if self.func ~= nil then
                            self.func() --外面传进来的function，一般为发送协议function
                        end
                        print("rmb---------------->",buycount)
                        self : REQ_WRESTLE_GUESS(self.uid1,self.uid2,buycount)
                        self.Scenelayer : removeFromParentAndCleanup(true)
                        self:unloadResources()
                    elseif isEnoughMoney == 0 then
                        CCMessageBox("您的金额不够不能下注","CAddAndReduceBox.allCallback")
                    end

            elseif obj : getTag() == CAddAndReduceBox.CANCEL_TAG then
                    print("windows板面取消按钮回调")

                    if self.Cancelfunc ~= nil then
                        self.Cancelfunc() --外面传进来取消按钮的的function，一般为关闭function
                    end
                    self.Scenelayer : removeFromParentAndCleanup(true)
                    self:unloadResources()

            elseif obj : getTag() == CAddAndReduceBox.ADD_TAG then
                    self.isaddorreduce = 1

                    self.initnum = self.initnum + 1 
                    print ("ADD_TAG--->>",self.initnum)
                    self.m_editbox : setTextString(self.initnum)

            elseif obj : getTag() == CAddAndReduceBox.REDUCE_TAG then
                    self.isaddorreduce = 1
                    if self.initnum > 1 then
                        self.initnum = self.initnum - 1 
                    end

                    print ("REDUCE--->>",self.initnum)
                    self.m_editbox : setTextString(self.initnum)
            end
        end
    elseif eventType == "EditBoxReturn" then
        print("Editbox输入回调")
        self.isaddorreduce = 1
        self.isstring = string.match(x , "%d+")

        if self.isstring ==nil then
            CCMessageBox("输入数值为非数字，请从新输入","Editbox输入回调")
            self.windowsEnsureBtn : setTouchesEnabled (false)
        else
            -- self.initnum     = self.m_editbox : getTextString()
            -- self.thebuycount = self.m_editbox : getTextString()
            -- self.windowsEnsureBtn : setTouchesEnabled (true)
            local thebuycount = self.m_editbox : getTextString()
            self.initnum      = tonumber(thebuycount)
            self.windowsEnsureBtn : setTouchesEnabled (true)
        end  
        print("thebuycount--->",self.thebuycount)
    end

end

--商城购买发送请求
--协议发送
function CAddAndReduceBox.REQ_WRESTLE_GUESS(self,uid1,uid2,rmb) -- [54890]欢乐竞猜 -- 格斗之王
    require "common/protocol/auto/REQ_WRESTLE_GUESS" 
    local msg = REQ_WRESTLE_GUESS()
    msg : setUid1(uid1)   -- {玩家的uid}
    msg : setUid2(uid2)   -- {玩家的uid}
    msg : setRmb(rmb)  -- {竞技水晶}
    CNetwork  : send(msg)
    print("REQ_WRESTLE_GUESS 54890 欢乐竞猜 -- 格斗之王   发送完毕 ")
end


function CAddAndReduceBox.CompareMoney(self,_buycount)
    local mainProperty = _G.g_characterProperty : getMainPlay()

    --获取钻石
    self.m_RmbNum     = tonumber(mainProperty :getBindRmb()) 
    print("self.m_RmbNum",self.m_RmbNum)
    if self.m_RmbNum  == nil then
        self.m_RmbNum = 0
    end
    if self.m_RmbNum > tonumber(_buycount) then
        return 1 
    else
        return 0 
    end  
end





