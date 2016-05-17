
require "controller/command"


require "mediator/LuckyLayerMediator"

require "model/VO_LuckyModel"



CLuckyLayer = class(view,function (self)
    self.times     = 0.1 --剩余招财次数
    self.is_auto   = 0.1 --是否自动招财1是 0否
    self.auto_gold = 0.1 --自动招财铜钱
    self.next_rmb  = 0.1 --下一级
    self.next_gold = 0.1 --下一级美金
    self.iswindowscheckBoxChecked = 0
                          end)

CLuckyLayer.CloseBtnValue         = 1
CLuckyLayer.checkBoxValue         = 2
CLuckyLayer.luckyButtonValue      = 3
CLuckyLayer.batchLuckyButtonValue = 4

function CLuckyLayer.scene(self)
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    self.scene   = CCScene :create()
    self.m_layer = CContainer :create()
    self.scene   : addChild(self.m_layer)
    self.scene   : addChild(self : layer(winSize)) --scene的layer层    
    return self.scene
end

function CLuckyLayer.layer(self,_winSize)
    local winSize   = CCDirector:sharedDirector():getVisibleSize()
    self.Scenelayer = CContainer :create()
    self : init (winSize,self.Scenelayer)   


    local function local_onEnter(eventType, obj, x, y)
        return self:onEnter(eventType, obj, x, y)
    end
    self.Scenelayer : registerControlScriptHandler(local_onEnter,"CLuckyLayer scene self.Scenelayer 136")
    self.Scenelayer : setFullScreenTouchEnabled(true)
    self.Scenelayer : setTouchesEnabled(true)
    self.Scenelayer : setTouchesPriority(-100)

    return self.Scenelayer
end

function CLuckyLayer.onEnter( self,eventType, obj, x, y )
    if eventType == "Enter" then
        --初始化指引
        print("CLuckyLayer.onEnter  ")
        -- _G.pCGuideManager:initGuide( self.m_scenelayer , _G.Constant.CONST_FUNC_OPEN_ROLE)
    elseif eventType == "Exit" then
        _G.pCGuideManager:exitView( _G.Constant.CONST_FUNC_OPEN_MONEYTREE )
    end
end

function CLuckyLayer.loadResources(self)
    print("CLuckyLayer.loadResources")
    self.m_createResStrList = {}
end

function CLuckyLayer.unloadResources( self )
    -- body

    if _G.g_unLoadIconSources ~= nil then
        _G.g_unLoadIconSources:unLoadAllIconsByNameList( self.m_createResStrList )
        self.m_createResStrList = {}
    end
end

function CLuckyLayer.layout(self, winSize)  --适配布局
    local backBgSize   = self.m_allBackGroundSprite :getPreferredSize()
    local closeBtnSize = self.CloseBtn :getContentSize()
    self.m_allBackGroundSprite      : setPosition(winSize.width/2,winSize.height/2)        --总底图
    self.m_luckyCatSprite           : setPosition(winSize.width/2, 385)   --招财猫图
    self.CloseBtn                   : setPosition(winSize.width/2+backBgSize.width/2 - closeBtnSize.width/2 - 10,winSize.height-closeBtnSize.height/2 - 9) --关闭按钮

    self.m_titleImg       : setPosition ( winSize.width/2, 592)

    self.checkBox         : setPosition ( winSize.width/2 - 135 , 169)
    self.consumeInfoLabel : setPosition ( winSize.width/2, 116)
    self.luckyButton      : setPosition ( winSize.width/2-80, 53)
    self.batchLuckyButton : setPosition ( winSize.width/2+80, 53)
end

function CLuckyLayer.init(self, _winSize, _layer)
    self : loadResources()                        --资源初始化
    self : initView(_winSize,_layer)              --界面初始化
    self : layout(_winSize)                       --适配布局初始化
    self : initParameter()                        --参数初始化

    

    local function runInitGuide()
        --初始化指引
        _G.pCGuideManager:initGuide( self.m_guideButton , _G.Constant.CONST_FUNC_OPEN_MONEYTREE )
    end
    _G.pCGuideManager:lockScene() --initGuide( self.m_scene,self.m_npcId)
    _layer:performSelector(0.08,runInitGuide)
end

function CLuckyLayer.initParameter(self)

    --mediator注册
    print("g_CLuckyLayerMediator.mediatorRegister 69")
     _G.g_CLuckyLayerMediator = CLuckyLayerMediator (self)
    controller :registerMediator(  _G.g_CLuckyLayerMediator )
 
    --向服务器发送页面数据请求
    require "common/protocol/auto/REQ_WEAGOD_REQUEST" --宝石数据协议发送
    local msg = REQ_WEAGOD_REQUEST()
    CNetwork : send(msg)
    print("CLuckyLayer招财页面发送数据请求,完毕 75")


    --获取人物Vip等级
    self.m_mainPlay_Viplv = _G.g_characterProperty : getMainPlay() : getVipLv()
    print("CLuckyLayer.initParameter 85",self.m_mainPlay_Viplv)

    local viplimitedlv =tonumber( _G.Constant.CONST_TREASURE_ONCE_MAKE_VIP )  -- VIP6增加一键制作功能
    if self.m_mainPlay_Viplv >= viplimitedlv then
        print("vIP到达6了，可以显示一键招财")
        if self.checkBox ~= nil then
            self.checkBox : setVisible( true )
        end 
    else
        if self.checkBox ~= nil then
            self.checkBox : setVisible( false )
        end 
    end
end

function CLuckyLayer.initView(self,_winSize,_layer)
    
    self.m_mySize = CCSizeMake(540,_winSize.height)

    self.m_allBackGroundSprite   = CCScale9Sprite :createWithSpriteFrameName("general_thirdly_underframe.png")       --总底图
    self.m_luckyCatSprite        = CCScale9Sprite :create("LuckyResources/luckycat340.png") --招财猫

    self.m_allBackGroundSprite   : setPreferredSize( self.m_mySize ) 

    _layer : addChild(self.m_allBackGroundSprite,-1)    
    _layer : addChild(self.m_luckyCatSprite)        

    table.insert( self.m_createResStrList, "LuckyResources/luckycat340.png" )    

    local function BtnCallBack(eventType, obj, x, y)
       return self : CallBack(eventType,obj,x,y)
    end

    --关闭按钮
    self.CloseBtn               = CButton :createWithSpriteFrameName("","general_close_normal.png")
    self.CloseBtn               : setTag(CLuckyLayer.CloseBtnValue)
    self.CloseBtn               : registerControlScriptHandler(BtnCallBack,"this CLuckyLayer CloseBtn 103")
    self.CloseBtn               : setTouchesEnabled(true)
    self.CloseBtn               : setTouchesPriority(-300)
    self.Scenelayer             : addChild (self.CloseBtn)

    self.m_guideButton = CButton :createWithSpriteFrameName( "", "transparent.png")
    self.m_guideButton : setControlName( "this CLuckyLayer self.m_guideButton 113 " )
    -- self.m_guideButton :registerControlScriptHandler( CallBack, "this CLuckyLayer self.m_guideButton 147")
    self.Scenelayer : addChild(self.m_guideButton, 2000)  

    self.m_titleImg = CSprite :create("LuckyResources/lucky_word_zcm.png")
    self.m_titleImg : setControlName( "this CLuckyLayer self.m_titleImg 39 ")
    self.Scenelayer  : addChild( self.m_titleImg )

    

    --自动招财checkbox
    self.checkBox = CCheckBox :create("LuckyResources/general_pages_normal.png", "LuckyResources/general_pages_pressing.png", "美刀不足30万,自动招财")    
    self.checkBox : setTag(CLuckyLayer.checkBoxValue)
    self.checkBox : setColor( ccc4(255,255,255,255) )
    self.checkBox : setFontSize( 20 )
    self.checkBox : registerControlScriptHandler(BtnCallBack,"this CLuckyLayer checkBox 115")
    self.checkBox : setTouchesEnabled(true)
    self.checkBox : setTouchesPriority(-200)

    table.insert( self.m_createResStrList, "LuckyResources/general_pages_normal.png" )
    table.insert( self.m_createResStrList, "LuckyResources/general_pages_pressing.png" )
    table.insert( self.m_createResStrList, "LuckyResources/lucky_word_zcm.png")
    
    _layer : addChild(self.checkBox)    

    self.consumeInfoLabel = CCLabelTTF :create("消耗X钻石,获得799美金","Arial",20)
    self.consumeInfoLabel : setColor( ccc4(255,255,0,255) )
    self.consumeInfoLabel : setFontSize( 20 )
    
    _layer : addChild(self.consumeInfoLabel)    

    --招财按钮
    self.luckyButton =  CButton : createWithSpriteFrameName("招财","general_button_normal.png")
    self.luckyButton : setTag(CLuckyLayer.luckyButtonValue)
    self.luckyButton : setColor( ccc4(255,255,255,255) )
    self.luckyButton : registerControlScriptHandler(BtnCallBack,"this CLuckyLayer luckyButton 129")
    self.luckyButton : setTouchesPriority(-200)
    --self.luckyButton : setFullScreenTouchEnabled(true)
    self.luckyButton : setFontSize(24)     
    _layer : addChild(self.luckyButton)
    

    --批量招财按钮
    self.batchLuckyButton =  CButton : createWithSpriteFrameName("批量招财","general_button_normal.png")
    self.batchLuckyButton : setTag(CLuckyLayer.batchLuckyButtonValue)
    self.batchLuckyButton : setColor( ccc4(255,255,255,255) )
    self.batchLuckyButton : registerControlScriptHandler(BtnCallBack,"this CLuckyLayer batchLuckyButton 139")
    self.batchLuckyButton : setTouchesPriority(-200)
    self.batchLuckyButton : setFontSize(24)
    _layer  : addChild(self.batchLuckyButton)
    

end

function CLuckyLayer.removeLayer( self )
    if _G.g_CLuckyLayerMediator ~= nil then
        controller :unregisterMediator(_G.g_CLuckyLayerMediator)
        _G.g_CLuckyLayerMediator = nil
        print("CLuckyLayer unregisterMediator.g_CLuckyLayerMediator 149")
    end
   self.Scenelayer : removeFromParentAndCleanup(true)
   _G.pLuckyLayer = nil
end

function CLuckyLayer.CallBack(self,eventType,obj,x,y)  --按钮回调
   if eventType == "TouchBegan" then
        return true
    elseif eventType == "TouchEnded" then

        if obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) ) == true then

            local  value = obj : getTag()
            if value == CLuckyLayer.CloseBtnValue  then --关闭页面按钮回调
                print("关闭按钮回调，181")
                --mediator反注册
                self:removeLayer()

            elseif value == CLuckyLayer.checkBoxValue  then --checkBox回调
                if self.is_auto == 0 then
                    print("is_auto",self.is_auto)
                   self.is_auto = 1
                   self.checkBox : setChecked (true)
                elseif self.is_auto == 1 then
                    print("is_auto2",self.is_auto)
                   self.is_auto = 0
                   self.checkBox : setChecked (false)
                end
                require "common/protocol/auto/REQ_WEAGOD_AUTO_GET" --招财据协议发送 32030
                local msg = REQ_WEAGOD_AUTO_GET()
                CNetwork  : send(msg)
                print("checkBox回调成功 176")

            elseif value == CLuckyLayer.luckyButtonValue  then -- 招财按钮回调
                print("招财按钮回调",self.times)
                if self.times == nil then
                    self.times = 0
                end
                if self.times > 0 then
                    --发送招财请求
                    require "common/protocol/auto/REQ_WEAGOD_GET_MONEY" --招财据协议发送 32030
                    local msg = REQ_WEAGOD_GET_MONEY()
                    CNetwork : send(msg)
                else
                    local msg = "招财次数不足，提升VIP等级可增加次数！"
                    self : createMessageBox(msg)
                end

                _G.pCGuideManager:sendStepFinish()

            elseif value == CLuckyLayer.batchLuckyButtonValue  then --批量招财按钮回调
                print("批量招财按钮回调",self.iswindowscheckBoxChecked)
                if self.times == nil then
                    self.times = 0
                end
                if self.PopBox ~= nil then
                    self.iswindowscheckBoxChecked = self.PopBox.iswindowscheckBoxChecked
                end
                if self.times > 0 then
                    --发送招财请求
                    if self.iswindowscheckBoxChecked ~= 1 then    --判断是否建框 如果建则在里面发协议 不然就直接发
                        -- self.windows = self : createWindowsBox () --创建弹出框
                        -- self.Scenelayer : addChild (self.windows)
                        ------------------------------------------------
                        require "view/LuckyLayer/PopBox"
                        self.PopBox = CPopBox() --初始化
                        local function ensurebtnCallBack( )
                            print("windows板面确定按钮回调")
                            --发送批量招财请求
                            require "common/protocol/auto/REQ_WEAGOD_PL_MONEY" --招财据协议发送 32030
                            local msg = REQ_WEAGOD_PL_MONEY()
                            CNetwork : send(msg)
                        end

                        if tonumber(self.times) <= 20 then
                            self.luckytime     = self.times                                        --招财次数
                        elseif tonumber(self.times) > 20 then
                            self.luckytime     =  20                                                --招财次数
                        end
                        print("createWindowsBox249",self.times,self.luckytime,self.next_rmb)
                        local spend_rmb = nil 
                        if tonumber(self.next_rmb)  == 0 then
                            spend_rmb     = self.next_rmb * self.luckytime + (self.luckytime-2)*(self.luckytime-1) --消耗钻石
                        else
                            spend_rmb     = self.next_rmb * self.luckytime + self.luckytime*(self.luckytime-1) --消耗钻石
                        end
                    

                        local getLucky_gold = self.next_gold * self.luckytime/10000                                   --得到的美金
                        print("createWindowsBox 352",self.luckytime,spend_rmb,getLucky_gold)

                        LuckyPopBox = self.PopBox : create(ensurebtnCallBack,"花费 "..spend_rmb.." 钻石招财 "..self.luckytime.." 次,\n".."获得 "..getLucky_gold.." 万美刀",1)

                        LuckyPopBox : setPosition(0,0)
                        self.Scenelayer : addChild(LuckyPopBox) 
                        print("生出了那个框框了")
                        -------------------------------------------------
                    else
                        --发送批量招财请求
                        require "common/protocol/auto/REQ_WEAGOD_PL_MONEY" --招财据协议发送 32030
                        local msg = REQ_WEAGOD_PL_MONEY()
                        CNetwork : send(msg)
                    end
                else
                    local msg = "招财次数不足，提升VIP等级可增加次数！"
                    self : createMessageBox(msg)
                end
             end

        end
    end
end

function CLuckyLayer.pushData(self,_vo_data)  --mediator传送过来的数据
    local vo_data = _vo_data

    self.times     = vo_data : getLuckyTimes     () --剩余招财次数
    self.is_auto   = vo_data : getLuckyIsauto    () --是否自动招财1是 0否
    self.auto_gold = (vo_data : getLuckyauto_gold ())/10000 --自动招财铜钱
    self.next_rmb  = tonumber(vo_data : getLuckynext_rmb  ())  --下一级
    self.next_gold = vo_data : getLuckynext_gold () --下一级美金

    print("CLuckyLayer.pushData 235",self.times,self.is_auto,self.auto_gold,self.next_rmb,self.next_gold)

    self.consumeInfoLabel : setString("消耗"..self.next_rmb.."钻石,获得"..self.next_gold.."美刀") --消耗6钻石,获得799美金

    self.checkBox         : setText("美刀不足"..self.auto_gold.."万，自动招财")               --美金不足30万，自动招财

    if self.is_auto == 1 then
        print("setChecked (true) 233")
        self.checkBox : setChecked (true)
    elseif self.is_auto == 0 then
        self.checkBox : setChecked (false)
        print("setChecked (false) 237")
    end
    --剩余次数暂未处理
end


function CLuckyLayer.pushSuccess(self,_returntype)
    -- if _returntype ~= nil and _returntype > 0 then
    --     if _returntype == 1 then
    --         local msg = "招财成功！"
    --         self : createMessageBox(msg)
    --     elseif _returntype == 2 then
    --         local msg = "批量招财成功！"
    --         self : createMessageBox(msg)
    --     end
    -- end
    print("播放声音")
    if _G.pCSystemSettingProxy:getStateByType(_G.Constant.CONST_SYS_SET_MUSIC) == 1 then
        SimpleAudioEngine:sharedEngine():playEffect("Sound@mp3/wealth_money.mp3", false)
    end
end

function CLuckyLayer.createMessageBox(self,_msg)
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg)
    self.Scenelayer : addChild(BoxLayer,1000)
end






