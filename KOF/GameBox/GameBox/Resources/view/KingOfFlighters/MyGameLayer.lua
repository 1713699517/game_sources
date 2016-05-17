
require "controller/command"

require "view/view"

require "mediator/MyGameLayerMediator"

CMyGameLayer = class(view,function (self)
                          end)

CMyGameLayer.TAG_CallBtn         = 1
CMyGameLayer.TAG_PracticeBtn     = 2
CMyGameLayer.TAG_HighPracticeBtn = 3

CMyGameLayer.CdTime              = 1

function CMyGameLayer.scene(self)
    local winSize    = CCDirector:sharedDirector():getVisibleSize()
    self.IpadSize    = 854
    self.scene       = CCScene :create()
    self.Scenelayer  = CContainer :create()
    self.scene       : addChild(self.Scenelayer)
    self.scene       : addChild(self : layer(winSize)) --scene的layer层    
    return self.scene
end

function CMyGameLayer.layer(self)
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    self.Scenelayer    = CContainer :create()
    self : init (winSize,self.Scenelayer)   
    return self.Scenelayer
end

function CMyGameLayer.loadResources(self)

    _G.Config:load("config/goods.xml")
end

function CMyGameLayer.layout(self, winSize)  --适配布局
    local IpadSize = 854
    if winSize.height == 640 then

        self.m_leftBackGround     : setPosition(245,295)    --左底图
        self.m_rightBackGround    : setPosition(660,295)    --右底图
    elseif winSize.height == 768 then
        print("768 768")
    end
end

function CMyGameLayer.init(self, _winSize, _layer)
    self : loadResources()                       --资源初始化
    self : initView(_winSize,_layer)             --界面初始化
    self : layout(_winSize)                      --适配布局初始化
    self : initParameter()                       --参数初始化
end

function CMyGameLayer.initParameter(self)
    self : registerMediator()   -- mediator注册
end

function CMyGameLayer.initView(self,_winSize,_layer)

    self.m_leftBackGround     = CSprite : createWithSpriteFrameName("general_second_underframe.png") --左底图
    self.m_rightBackGround    = CSprite : createWithSpriteFrameName("general_second_underframe.png") --右底图

    self.m_leftBackGround     : setPreferredSize(CCSizeMake(405,550)) 
    self.m_rightBackGround    : setPreferredSize(CCSizeMake(405,550)) 

    _layer : addChild(self.m_leftBackGround)
    _layer : addChild(self.m_rightBackGround)

    self.TimeLeftLabel    = CCLabelTTF : create("","Arial",24)
    self.GameLeftLabel    = CCLabelTTF : create("","Arial",24)
    self.TimeLeftLabel    : setColor(ccc3(255,255,0))
    self.GameLeftLabel    : setColor(ccc3(255,255,0))
    self.TimeLeftLabel    : setPosition(-85,220)
    self.GameLeftLabel    : setPosition(85,220)
    self.m_leftBackGround : addChild(self.TimeLeftLabel)
    self.m_leftBackGround : addChild(self.GameLeftLabel)
    --摇摆的猥琐男主角--------------------------------------------------------------------------------
    local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            print( "Enter««««««««««««««««"..eventType )
            arg0 : play("idle")
        end
    end
    self.m_mainProperty = _G.g_characterProperty :getMainPlay()
    local pro = self.m_mainProperty : getPro()   --猪脚职业属性

    self.roleCCBI        = CMovieClip:create( "CharacterMovieClip/1000"..pro.."_normal.ccbi" )
    self.roleCCBI         : setControlName( "this CSelectRoleScene roleCCBI 84")
    self.roleCCBI         : registerControlScriptHandler( animationCallFunc)
    self.roleCCBI         : setPosition(0,-65)
    self.m_leftBackGround : addChild(self.roleCCBI)

    local roleCCBISprite1  = CSprite : createWithSpriteFrameName("login_role_background_click.png")
    local roleCCBISprite2  = CSprite : createWithSpriteFrameName("login_role_background_normal.png")
    roleCCBISprite1        : setPosition(0,43)
    self.roleCCBI          : addChild(roleCCBISprite1,-1)
    self.roleCCBI          : addChild(roleCCBISprite2,-2)
    -------------------------------------------------------------------------------------------------
    self.NextRivalLabel = CCLabelTTF : create("下一对手 : 猥琐男猥琐男","Arial",24)
    self.LvLabel        = CCLabelTTF : create("等级 : 999级","Arial",24)
    self.FightingLabel  = CCLabelTTF : create("战斗力 : 9999999","Arial",24)

    self.NextRivalLabel : setAnchorPoint( ccp( 0,0.5 ) )
    self.LvLabel        : setAnchorPoint( ccp( 0,0.5 ) )
    self.FightingLabel  : setAnchorPoint( ccp( 0,0.5 ) )

    self.m_leftBackGround : addChild(self.NextRivalLabel)
    self.m_leftBackGround : addChild(self.LvLabel)
    self.m_leftBackGround : addChild(self.FightingLabel)

    self.NextRivalLabel : setPosition(-140,-130)
    self.LvLabel        : setPosition(-140,-180)
    self.FightingLabel  : setPosition(-140,-230)

    --右边信息
    self.JioningstatesLabel = CCLabelTTF : create("","Arial",24)
    self.LeftTrunCountLabel = CCLabelTTF : create("剩余轮数 : 7/7","Arial",24)
    self.WinCountLabel      = CCLabelTTF : create("胜场次数 : 5","Arial",24)
    self.LoseCountLabel     = CCLabelTTF : create("输场次数 : 2","Arial",24)
    self.AllFractionLabel   = CCLabelTTF : create("总积分 : 10分","Arial",24)

    self.JioningstatesLabel : setAnchorPoint( ccp( 0,0.5 ) )
    self.LeftTrunCountLabel : setAnchorPoint( ccp( 0,0.5 ) )
    self.WinCountLabel      : setAnchorPoint( ccp( 0,0.5 ) )
    self.LoseCountLabel     : setAnchorPoint( ccp( 0,0.5 ) )
    self.AllFractionLabel   : setAnchorPoint( ccp( 0,0.5 ) )

    self.m_rightBackGround  : addChild(self.JioningstatesLabel)
    self.m_rightBackGround  : addChild(self.LeftTrunCountLabel)
    self.m_rightBackGround  : addChild(self.WinCountLabel)
    self.m_rightBackGround  : addChild(self.LoseCountLabel)
    self.m_rightBackGround  : addChild(self.AllFractionLabel)

    self.JioningstatesLabel : setPosition(-140,130)
    self.LeftTrunCountLabel : setPosition(-140,80)
    self.WinCountLabel      : setPosition(-140,30)
    self.LoseCountLabel     : setPosition(-140,-20)
    self.AllFractionLabel   : setPosition(-140,-70)
    self.AllFractionLabel   : setColor(ccc3(255,255,0))

end

-- function CMyGameLayer.addTime(self)
--     local function HookSend(_addtime)
--         _G.pDateTime : reset()
--         if self.AllTime == nil or self.AllTime < 0 then
--             return
--         end
--         self.AllTime = self.AllTime + _addtime 
--         if self.AllTime > CMyGameLayer.CdTime then
--             if self.leftTime > -1 then
--                 print("》》》》》》》》",self.leftTime)

--                 self.TimeLeftLabel : setString("将在"..self.leftTime.."秒后开始第1/7轮比赛")
--                 self.leftTime = self.leftTime - 1
--                 self.AllTime = 0 
--             else
--                 self.AllTime  = nil
--                 self.leftTime = 0
--             end
--         end
--     end
--     self.Scenelayer : scheduleUpdateWithPriorityLua( HookSend, 0 )
-- end
-- function CMyGameLayer.setTheTimes(self,_time) --设置时间
--     self.AllTime = _time
-- end


function CMyGameLayer.pushData(self,Uid,Name,NameColor,Lv,Powerful,Score,NowCount,AllCount,Uname,Success,Fail) --sever methond
    print("goods，进来了")
    local LeftCount =  AllCount - NowCount + 1
    if Uname ~= nil then
        self.NextRivalLabel : setString("下一对手 : "..Uname)
    else
        self.NextRivalLabel : setString("下一对手 : 轮空")
    end
    self.LvLabel        : setString("等级 : "..Lv.."级")
    self.FightingLabel  : setString("战斗力 : "..Powerful)

    -- if 1 < tonumber(LeftCount) then
    --     LeftCount = LeftCount - 1
    -- end
    if tonumber(AllCount) == 0 then
        LeftCount = 0 
    end
    self.LeftTrunCountLabel : setString("剩余轮数"..LeftCount.."/"..AllCount)

    -- if tonumber(NowCount) < tonumber(AllCount) then
    --     NowCount = NowCount + 1
    -- end
    self.GameLeftLabel      : setString("开始第"..NowCount.."/"..AllCount.."轮比赛")
    self.WinCountLabel      : setString("胜场次数 : "..Success)
    self.LoseCountLabel     : setString("输场次数 : "..Fail)
    self.AllFractionLabel   : setString("总积分 : "..Score.."分")

    self.transNowCount = tonumber(NowCount) 
end

--mediator 注册
function CMyGameLayer.registerMediator(self)
    print("CMyGameLayerMediator.mediatorRegister 75")
    _G.g_MyGameLayerMediator = CMyGameLayerMediator (self)
    controller :registerMediator(  _G.g_MyGameLayerMediator )
end
--协议发送


--协议返回
function CMyGameLayer.NetWorkReturn_WRESTLE_TIME(self,nowtime,endTime,startTime)  --[54805]各种倒计时 -- 格斗之王 
    print("CMyGameLayer [54805]各种倒计时 -- 格斗之王00112233 ",Value)
    local Value = nil 

    local leftTime   = endTime - startTime
    local gotime     = nowtime - startTime
    print("111print the time = ",startTime,nowtime,endTime)
    print("true time ======",leftTime,gotime)
    print("轮次====",self.transNowCount)
    if self.transNowCount ~= nil and self.transNowCount == 1 then
        print("是第一轮的倒计时")
        if startTime < nowtime and  gotime <= _G.Constant.CONST_WRESTLE_BEFORE_TIME then
            Value = _G.Constant.CONST_WRESTLE_BEFORE_TIME - gotime
        end
        if startTime > nowtime then
            Value = startTime -nowtime
        end
    else
        if startTime > nowtime then
            Value = startTime - nowtime + _G.Constant.CONST_WRESTLE_BEFORE_TIME
            print("不是第一轮的倒计时")
            if Value > _G.Constant.CONST_WRESTLE_START_NULL then
                Value = _G.Constant.CONST_WRESTLE_START_NULL
            end
        else
            if gotime <= _G.Constant.CONST_WRESTLE_BEFORE_TIME then
                Value = _G.Constant.CONST_WRESTLE_BEFORE_TIME - gotime
            end
        end
    end

    print("8887799===",Value)

    if Value ~= nil then
        -- self : setTheTimes(0)
        -- self : addTime()
        -- self.leftTime = Value

        self : setReceiveAwardsTime(Value)
        self : registerEnterFrameCallBack()
    end
end

function CMyGameLayer.NetWorkReturn_WRESTLE_STATE(self,State)  -- [54812]活动状态 -- 格斗之王

    print("CMyGameLayer [54812]活动状态 -- 格斗之王1033 ",State)
    local msg = ""
    if State ~= nil then
        if State == _G.Constant.CONST_WRESTLE_YUSAIZHONG then
            msg = "参赛状态 : 预赛进行中"
        elseif State == _G.Constant.CONST_WRESTLE_YUSAIJIESU then
            msg = "参赛状态 : 预赛结束"           
        elseif State == _G.Constant.CONST_WRESTLE_JUESAIJINGXINGZHONG then
            msg = "参赛状态 : 决赛进行中"
        elseif State == _G.Constant.CONST_WRESTLE_JUESAIJIESHU then
            msg = "参赛状态 : 决赛结束"
        elseif State == _G.Constant.CONST_WRESTLE_ZHENGBASAIJINXINGZHONG then
            msg = "参赛状态 : 争霸赛进行中"
        elseif State == 5 then
            msg = "参赛状态 : 预赛未开始"
        else
             msg = ""
        end
        self.JioningstatesLabel : setString(msg)
    end
end

function CMyGameLayer.removeCCBI(self)  
    print("111111111")
    if self.roleCCBI ~= nil then
        print("2222222")
        -- if self.roleCCBI : retainCount() > 1 then
        --     print("3333333")
        --     self.roleCCBI:release()
        -- end
        self.m_leftBackGround : removeChild(self.roleCCBI,false)
        print("--22222222")
    end

    -- self.m_leftBackGround : removeChild(self.roleCCBI,false)
    print("removeCCBIremoveCCBI",self)
    if self.Scenelayer ~= nil then
            print("33333333333",self)
        self.Scenelayer : removeFromParentAndCleanup(true)
            print("55555555555",self)
        self.Scenelayer = nil
            print("6666666666",self)
    end
end

----倒计时
function CMyGameLayer.registerEnterFrameCallBack(self)
    print( "CMyGameLayer.registerEnterFrameCallBack")
    local function onEnterFrame( _duration )
        --_G.pDateTime : reset() 
        self :updataReceiveAwardsTime( _duration)
    end
    self.Scenelayer : scheduleUpdateWithPriorityLua( onEnterFrame, 0 )
end

function CMyGameLayer.updataReceiveAwardsTime( self, _duration)
    if self.m_receiveawardstime == nil or self.m_receiveawardstime <= 0 then
        return
    end
    self.m_receiveawardstime = self.m_receiveawardstime - _duration
    if self.m_receiveawardstime <= 0 then
        print("倒数完了")
    else
        local fomarttime = self :turnTime( self.m_receiveawardstime)
        self.TimeLeftLabel : setString("将在"..fomarttime.."秒后")
    end
end

function CMyGameLayer.setReceiveAwardsTime(self, _time)
    self.m_receiveawardstime = _time
    if self.m_receiveawardstime <= 0 then
        self.m_receiveawardstime = 0
    end
    local fomarttime = self :turnTime( self.m_receiveawardstime)
    self.TimeLeftLabel : setString("将在"..fomarttime.."秒后")
end

function CMyGameLayer.turnTime( self, _time)
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
    --return hor..":"..min..":"..sec
end
--{时间转字符串}
function CMyGameLayer.toTimeString( self, _num )
    _num = _num <=0 and "00" or _num
    if type(_num) ~= "string" then
        _num = _num >=10 and tostring(_num) or ("0"..tostring(_num))
    end
    return _num
end





