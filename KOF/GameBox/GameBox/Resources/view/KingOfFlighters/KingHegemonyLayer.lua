
require "controller/command"

require "view/view"

require "mediator/KingHegemonyLayerMediator"

CKingHegemonyLayer = class(view,function (self)
                          end)

CKingHegemonyLayer.TAG_HappyBtn = 500

function CKingHegemonyLayer.scene(self)
    local winSize    = CCDirector:sharedDirector():getVisibleSize()
    self.IpadSize    = 854
    self.scene       = CCScene :create()
    self.Scenelayer  = CContainer :create()
    self.scene       : addChild(self.Scenelayer)
    self.scene       : addChild(self : layer(winSize)) --scene的layer层
    return self.scene
end

function CKingHegemonyLayer.layer(self)
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    self.m_Scenelayer    = CContainer :create()
    self : init (winSize,self.m_Scenelayer)
    return self.m_Scenelayer
end

function CKingHegemonyLayer.loadResources(self)
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist")
    --CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("KingOfFlightersResource/KingOfFlighters.plist")
    _G.Config:load("config/goods.xml")
end

function CKingHegemonyLayer.layout(self, winSize)  --适配布局
    local IpadSize = 854
    if winSize.height == 640 then
        self.m_BackGround  : setPreferredSize(CCSizeMake(820,550))

        self.m_BackGround       : setPosition(455,295)    --底图
        self.m_combatBackGround : setPosition(455,295)    --底图
    elseif winSize.height == 768 then
        print("768 768")
    end
end

function CKingHegemonyLayer.init(self, _winSize, _layer)
    self : loadResources()                       --资源初始化
    self : initView(_winSize,_layer)             --界面初始化
    self : layout(_winSize)                      --适配布局初始化
    self : initParameter()                       --参数初始化
end

function CKingHegemonyLayer.initParameter(self)
    self : registerMediator()   --mediator注册
    -- self : REQ_WRESTLE_ZHENGBA () --争霸数据

    self.PlayerData  = {}
    self.PlayerCount = 0
end

function CKingHegemonyLayer.initView(self,_winSize,_layer)
    local function CallBack(eventType, obj, x, y)
        return self : CallBack(eventType,obj,x,y)
    end
    self.m_BackGround        = CSprite : createWithSpriteFrameName("general_second_underframe.png")    --底图
    self.m_combatBackGround  = CSprite : createWithSpriteFrameName("combat_background_underframe.png") --底图

    _layer             : addChild(self.m_BackGround,-2)
    _layer             : addChild(self.m_combatBackGround,-1)

    ----摇摆的猥琐左男主角-----------------------------------------------------------------------------------
    -- local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
    --     if eventType == "Enter" then
    --         print( "Enter««««««««««««««««"..eventType )
    --         arg0 : play("idle")
    --     end
    -- end
    -- self.m_mainProperty = _G.g_characterProperty :getMainPlay()
    -- local pro = self.m_mainProperty : getPro()   --猪脚职业属性

    -- self.LeftRoleCCBI        = CMovieClip:create( "CharacterMovieClip/1000"..pro.."_normal.ccbi" )
    -- self.LeftRoleCCBI         : setControlName( "this CKingHegemonyLayer roleCCBI 84")
    -- self.LeftRoleCCBI         : registerControlScriptHandler( animationCallFunc)
    -- self.LeftRoleCCBI         : setPosition(210,290)
    -- self.m_Scenelayer         : addChild(self.LeftRoleCCBI)

    -- local LeftRoleCCBISprite1  = CSprite : createWithSpriteFrameName("login_role_background_click.png")
    -- local LeftRoleCCBISprite2  = CSprite : createWithSpriteFrameName("login_role_background_normal.png")
    -- LeftRoleCCBISprite1        : setPosition(0,43)
    -- self.LeftRoleCCBI          : addChild(LeftRoleCCBISprite1,-1)
    -- self.LeftRoleCCBI          : addChild(LeftRoleCCBISprite2,-2)

    --信息背景图
    self.LeftRoleInfoSprite  = CSprite : createWithSpriteFrameName("combat_word_underframe.png")
    self.LeftRoleInfoSprite  : setPosition(210,160)
    _layer                   : addChild(self.LeftRoleInfoSprite)

    self.LeftNameLabel      = CCLabelTTF : create("","Arial",24)
    self.LeftLvLabel        = CCLabelTTF : create("","Arial",24)
    self.LeftFightingLabel  = CCLabelTTF : create("","Arial",24)

    self.LeftNameLabel      : setAnchorPoint( ccp( 0,0.5 ) )
    self.LeftLvLabel        : setAnchorPoint( ccp( 0,0.5 ) )
    self.LeftFightingLabel  : setAnchorPoint( ccp( 0,0.5 ) )

    self.LeftRoleInfoSprite : addChild(self.LeftNameLabel)
    self.LeftRoleInfoSprite : addChild(self.LeftLvLabel)
    self.LeftRoleInfoSprite : addChild(self.LeftFightingLabel)

    self.LeftNameLabel      : setPosition(-120,40)
    self.LeftLvLabel        : setPosition(-120,0)
    self.LeftFightingLabel  : setPosition(-120,-40)


    ----摇摆的猥琐右男主角-----------------------------------------------------------------------------------

    -- self.RightRoleCCBI         = CMovieClip:create( "CharacterMovieClip/1000"..pro.."_normal.ccbi" )
    -- self.RightRoleCCBI         : setControlName( "this CKingHegemonyLayer roleCCBI 84")
    -- self.RightRoleCCBI         : registerControlScriptHandler( animationCallFunc)
    -- self.RightRoleCCBI         : setPosition(700,290)
    -- self.m_Scenelayer          : addChild(self.RightRoleCCBI)

    -- self.RightRoleCCBISprite2  = CSprite : createWithSpriteFrameName("combat_role_underframe.png")
    -- self.RightRoleCCBISprite2  : setPosition(0,43)
    -- self.RightRoleCCBI         : addChild(self.RightRoleCCBISprite2,-2)

    --信息背景图
    self.RightRoleInfoSprite = CSprite : createWithSpriteFrameName("combat_word_underframe.png")
    self.RightRoleInfoSprite  : setScaleX(-1)
    self.RightRoleInfoSprite  : setPosition(700,160)
    _layer                    : addChild(self.RightRoleInfoSprite)

    self.RightNameLabel      = CCLabelTTF : create("","Arial",24)
    self.RightLvLabel        = CCLabelTTF : create("","Arial",24)
    self.RightFightingLabel  = CCLabelTTF : create("","Arial",24)

    self.RightNameLabel      : setAnchorPoint( ccp( 0,0.5 ) )
    self.RightLvLabel        : setAnchorPoint( ccp( 0,0.5 ) )
    self.RightFightingLabel  : setAnchorPoint( ccp( 0,0.5 ) )

    self.RightNameLabel      : setScaleX(-1)
    self.RightLvLabel        : setScaleX(-1)
    self.RightFightingLabel  : setScaleX(-1)

    self.RightRoleInfoSprite : addChild(self.RightNameLabel)
    self.RightRoleInfoSprite : addChild(self.RightLvLabel)
    self.RightRoleInfoSprite : addChild(self.RightFightingLabel)

    self.RightNameLabel      : setPosition(120,40)
    self.RightLvLabel        : setPosition(120,0)
    self.RightFightingLabel  : setPosition(120,-40)
    ----------------------------------------------------------------------------------
    --格斗之王总冠军logo
    self.KingHegemonySprite = CSprite : createWithSpriteFrameName("combat_word_gdzwzgj.png")
    self.KingHegemonySprite : setPosition(450,500)
    _layer         : addChild( self.KingHegemonySprite)

    --VS
    self.VSSprite     = CSprite : createWithSpriteFrameName("combat_word_vs.png")
    self.VSSprite     : setPosition(450,320)
    _layer            : addChild( self.VSSprite)

    self.VSLabel      = CCLabelTTF : create("总决赛暂未开始","Arial",24)
    self.VSLabel      : setColor(ccc3(255,255,0))
    self.VSLabel      : setVisible( false )
    self.VSLabel      : setPosition(450,320)
    _layer            : addChild( self.VSLabel)

    --对决倒计时
    self.TimeLeftLabel = CCLabelTTF : create("","Arial",18)
    self.TimeLeftLabel : setColor(ccc3(255,255,0))
    self.TimeLeftLabel : setPosition(450,140)
    _layer                 : addChild( self.TimeLeftLabel)

end

function CKingHegemonyLayer.CallBack(self,eventType,obj,x,y)
   if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        local  TAG_value  = obj : getTag()
        if     TAG_value == CKingHegemonyLayer.TAG_HappyBtn then
            print("欢乐小竞猜")
        end
        for i=1,8 do
            if TAG_value == i then
                print("左边队伍回调")
                self : changeLeftBoxSprite(i)
            end

            if TAG_value == i*10 then
                print("右边队伍回调")
                self : changeRightBoxSprite(i)
            end
        end
    end
end

function CKingHegemonyLayer.changeLeftBoxSprite(self,TAG_value)
    self : changeSprite() --消除之前痕迹
    if self.LeftDividingSprite[TAG_value] ~= nil then
        self.LeftDividingSprite[TAG_value] : setImageWithSpriteFrameName( "combat_frame_click.png" )
        self.oldLeftTAG_value              = TAG_value
    end
end
function CKingHegemonyLayer.changeRightBoxSprite(self,TAG_value)
    self : changeSprite() --消除之前痕迹
    if self.RightDividingSprite[TAG_value] ~= nil then
        self.RightDividingSprite[TAG_value] : setImageWithSpriteFrameName( "combat_frame_click.png" )
        self.oldRightTAG_value              = TAG_value
    end
end
function CKingHegemonyLayer.changeSprite(self)
    if self.oldLeftTAG_value ~= nil then
       self.LeftDividingSprite[self.oldLeftTAG_value] : setImageWithSpriteFrameName("combat_frame_normal.png" )
    end
    if self.oldRightTAG_value ~= nil then
       self.RightDividingSprite[self.oldRightTAG_value] : setImageWithSpriteFrameName("combat_frame_normal.png" )
    end
end


function CKingHegemonyLayer.pushData(self,Name,Lv,Power,Pro) --sever methond
    self.PlayerCount = self.PlayerCount + 1
    self.PlayerData[self.PlayerCount]  = {}
    self.PlayerData[self.PlayerCount].Name  = Name
    self.PlayerData[self.PlayerCount].Lv    = Lv
    self.PlayerData[self.PlayerCount].Power = Power
    self.PlayerData[self.PlayerCount].Pro   = Pro
    print("self.PlayerCount==",self.PlayerCount,Name,Pro)

    self : initViewData(self.PlayerCount)
end

function CKingHegemonyLayer.initViewData(self,count)
    local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            print( "Enter««««««««««««««««"..eventType )
            arg0 : play("idle")
        end
    end

    if count == 1 then
        if self.PlayerData ~= nil then
            self.RightNameLabel      : setString("参赛者 : "..self.PlayerData[count].Name)
            self.RightLvLabel        : setString("等级 : "..self.PlayerData[count].Lv.."级")
            self.RightFightingLabel  : setString("战斗力 : "..self.PlayerData[count].Power)

            local pro                 = "1000"..self.m_partnerProNo[_value].pro 
            self.LeftRoleCCBI         = CMovieClip:create( "CharacterMovieClip/1000"..pro.."_normal.ccbi" )
            self.LeftRoleCCBI         : setControlName( "this CKingHegemonyLayer roleCCBI 84")
            self.LeftRoleCCBI         : registerControlScriptHandler( animationCallFunc)
            self.LeftRoleCCBI         : setPosition(210,290)
            self.m_Scenelayer         : addChild(self.LeftRoleCCBI)

            local LeftRoleCCBISprite1 = CSprite : createWithSpriteFrameName("login_role_background_click.png")
            local LeftRoleCCBISprite2 = CSprite : createWithSpriteFrameName("login_role_background_normal.png")
            LeftRoleCCBISprite1       : setPosition(0,43)
            self.LeftRoleCCBI         : addChild(LeftRoleCCBISprite1,-1)
            self.LeftRoleCCBI         : addChild(LeftRoleCCBISprite2,-2)

        end
    elseif count == 2 then
        if self.PlayerData ~= nil then
            self.LeftNameLabel      : setString("参赛者 : "..self.PlayerData[count].Name)
            self.LeftLvLabel        : setString("等级 : "..self.PlayerData[count].Lv.."级")
            self.LeftFightingLabel  : setString("战斗力 : "..self.PlayerData[count].Power)

            local pro                 = "1000"..self.m_partnerProNo[_value].pro 
            self.RightRoleCCBI        = CMovieClip:create( "CharacterMovieClip/1000"..pro.."_normal.ccbi" )
            self.RightRoleCCBI        : setControlName( "this CKingHegemonyLayer roleCCBI 84")
            self.RightRoleCCBI        : registerControlScriptHandler( animationCallFunc)
            self.RightRoleCCBI        : setPosition(700,290)
            self.m_Scenelayer         : addChild(self.RightRoleCCBI)

            self.RightRoleCCBISprite2 = CSprite : createWithSpriteFrameName("combat_role_underframe.png")
            self.RightRoleCCBISprite2 : setPosition(0,43)
            self.RightRoleCCBI        : addChild(self.RightRoleCCBISprite2,-2)
        end
    end
end

--mediator 注册
function CKingHegemonyLayer.registerMediator(self)
    print("CKingHegemonyLayer.mediatorRegister 75")
    _G.g_KingHegemonyLayerMediator = CKingHegemonyLayerMediator (self)
    controller :registerMediator(  _G.g_KingHegemonyLayerMediator )
end
--协议发送
-- function CKingHegemonyLayer.REQ_WRESTLE_ZHENGBA(self) -- [54815]请求积分榜数据 -- 格斗之王  积分榜页面接收
--     require "common/protocol/auto/REQ_WRESTLE_ZHENGBA"
--     local msg = REQ_WRESTLE_ZHENGBA()
--     CNetwork  : send(msg)
--     print("REQ_WRESTLE_ZHENGBA -- [54910]王者争霸入口 -- 格斗之王 发送完毕 ")
-- end

--协议返回
function CKingHegemonyLayer.NetWorkReturn_WRESTLE_STATE(self,State)
    print("设你不见。。。。",State)
    print("11a")
    if State ~= nil then
        if State == _G.Constant.CONST_WRESTLE_ZHENGBASAIJINXINGZHONG then  --争霸赛进行中
           self : setViewVisible(1)
        else
           self : setViewVisible(0)
        end
        print("22a")
    end
end

function CKingHegemonyLayer.setViewVisible(self,_is)
    if _is == 0 then
        --self.LeftRoleCCBI        : setVisible( false )
        self.LeftRoleInfoSprite  : setVisible( false )
        --self.RightRoleCCBI       : setVisible( false )
        self.RightRoleInfoSprite : setVisible( false )
        self.VSSprite            : setVisible( false )
        self.VSLabel             : setVisible( true )
    elseif _is == 1 then
        --self.LeftRoleCCBI        : setVisible( true )
        self.LeftRoleInfoSprite  : setVisible( true )
        --self.RightRoleCCBI       : setVisible( true )
        self.RightRoleInfoSprite : setVisible( true )
        self.VSSprite            : setVisible( true )
        self.VSLabel             : setVisible( false )
    end
end

function CKingHegemonyLayer.removeCCBI(self)

    -- if self.LeftRoleCCBI ~= nil then
    --     if self.LeftRoleCCBI : retainCount() >= 1 then
    --         self.LeftRoleCCBI:release()
    --     end
    -- end
    -- if self.RightRoleCCBI ~= nil then
    --     if self.RightRoleCCBI : retainCount() >= 1 then
    --         self.RightRoleCCBI : release()
    --     end
    -- end

    --print("self.LeftRoleCCBI : retainCount(),",self.LeftRoleCCBI : retainCount())
    if self.LeftRoleCCBI ~= nil then
        if self.LeftRoleCCBI : retainCount() >= 1 then
            self.m_Scenelayer : removeChild(self.LeftRoleCCBI,false)
            --self.LeftRoleCCBI:release()
        end
    end
    if self.RightRoleCCBI ~= nil then
        if self.LeftRoleCCBI : retainCount() >= 1 then
            self.m_Scenelayer : removeChild(self.RightRoleCCBI,false)
        end
    end

    -- self.m_Scenelayer : removeChild(self.LeftRoleCCBI,false)
    -- self.m_Scenelayer : removeChild(self.RightRoleCCBI,false)

    print("removeCCBIremoveCCBI",self)
    if self.m_Scenelayer ~= nil then
            print("33333333333",self)
        self.m_Scenelayer : removeFromParentAndCleanup(true)
            print("55555555555",self)
        self.m_Scenelayer = nil
            print("6666666666",self)
    end
end

function CKingHegemonyLayer.NetWorkReturn_WRESTLE_TIME(self,nowtime,endTime,startTime) --sever methond

    local Value      = nil 

    local leftTime   = endTime - startTime
    local gotime     = nowtime - startTime
    print("print the time = ",startTime,nowtime,endTime)
    print("true time ======",leftTime,gotime)

    if startTime < nowtime and gotime <= _G.Constant.CONST_WRESTLE_BEFORE_TIME then
        Value = _G.Constant.CONST_WRESTLE_BEFORE_TIME - gotime
    end

    if Value ~= nil and Value > 0 then
        --倒计时
        self : setReceiveAwardsTime(Value)
        self : registerEnterFrameCallBack()
    end
end

----倒计时
function CKingHegemonyLayer.registerEnterFrameCallBack(self)
    print( "CUpperHalfLayer.registerEnterFrameCallBack")
    local function onEnterFrame( _duration )
        --_G.pDateTime : reset()
        self :updataReceiveAwardsTime( _duration)
    end
    self.Scenelayer : scheduleUpdateWithPriorityLua( onEnterFrame, 0 )
end

function CKingHegemonyLayer.updataReceiveAwardsTime( self, _duration)
    if self.m_receiveawardstime == nil or self.m_receiveawardstime <= 0 then
        return
    end
    self.m_receiveawardstime = self.m_receiveawardstime - _duration
    if self.m_receiveawardstime <= 0 then
        print("倒数完了")
    else
        local fomarttime = self :turnTime( self.m_receiveawardstime)
        self.TimeLeftLabel :setString("争霸倒计时 : "..fomarttime)
    end
end

function CKingHegemonyLayer.setReceiveAwardsTime(self, _time)
    self.m_receiveawardstime = _time
    if self.m_receiveawardstime <= 0 then
        self.m_receiveawardstime = 0
    end
    local fomarttime = self :turnTime( self.m_receiveawardstime)
    self.TimeLeftLabel :setString("争霸倒计时 : "..fomarttime)
end

function CKingHegemonyLayer.turnTime( self, _time)
    _time = _time < 0 and 0 or _time
    local hor  = math.floor( _time/(60*60))
    hor = hor < 0 and 0 or hor
    local min  = math.floor( _time/60-hor*60)
    min = min < 0 and 0 or min
    local sec  = math.floor( _time-hor*60*60-min*60)
    sec = sec < 0 and 0 or sec
    hor = self :toTimeString( hor)
    min = self :toTimeString( min )
    sec = self :toTimeString( sec )
    return min..":"..sec
end
--{时间转字符串}
function CKingHegemonyLayer.toTimeString( self, _num )
    _num = _num <=0 and "00" or _num
    if type(_num) ~= "string" then
        _num = _num >=10 and tostring(_num) or ("0"..tostring(_num))
    end
    return _num
end







