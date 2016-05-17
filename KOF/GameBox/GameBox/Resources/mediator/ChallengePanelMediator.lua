require "mediator/mediator"
require "common/MessageProtocol"



CChallengePanelMediator = class(mediator, function(self, _view)
    self.name = "CChallengePanelMediator"
    self.view = _view
    print("Mediator:",self.name)
end)

function CChallengePanelMediator.getView(self)
    return self.view
end

function CChallengePanelMediator.getName(self)
    return self.name
end

function CChallengePanelMediator.processCommand(self, _command)
    --接收服务器下发消息 接收ACK
    if _command :getType() == CNetworkCommand.TYPE then
        local msgID = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()
        print("CCCCCCCCC", msgID)
        if msgID == _G.Protocol.ACK_ARENA_DEKARON   then -- [23820]可以挑战的玩家列表(废除) -- 封神台
            print("-- [23820]可以挑战的玩家列表(废除) -- 封神台 ")
            self :ACK_ARENA_DEKARON( ackMsg)
        elseif msgID == _G.Protocol.ACK_ARENA_REWARD_TIMES   then -- (手动) -- [24000]领取倒计时 -- 逐鹿台
            print("-- (手动) -- [24000]领取倒计时 -- 逐鹿台 ")
            self :ACK_ARENA_REWARD_TIMES( ackMsg)
        elseif msgID == _G.Protocol.ACK_ARENA_GET_REWARD then
            self :ACK_ARENA_GET_REWARD( ackMsg)
        elseif msgID == _G.Protocol.ACK_ARENA_CLEAN_OK then --清除CD时间
            self :ACK_ARENA_CLEAN_OK( ackMsg)
        elseif msgID == _G.Protocol.ACK_ARENA_RESULT2 then --购买次数 返回当前购买次数
            self :ACK_ARENA_RESULT2( ackMsg)
        elseif msgID == _G.Protocol.ACK_ARENA_BUY_OK then --购买次数 成功
            self :ACK_ARENA_BUY_OK( ackMsg)


        end


    end

    --接收自己客户端
    --[[
    if _command:getType() == CDuplicateCommand.TYPE then
        print("Mediator name------>",self: getName())
        print("Mediator view------>",self: getView())
        print("_command:getType--->",_command: getType())
        print("_command:getModel-->",_command: getModel())

        self :getView() :setLocalList()

        if _command :getModel() :getAT() == "AT_setGoodsRemove" then
            self :getView() :setGoodsRemove( _command :getModel() :getGoodsRemove())
        end

    end
    ]]
    return false
end

--[[
            A......C......K
--]]

-- [23820]可以挑战的玩家列表(废除) -- 封神台
function CChallengePanelMediator.ACK_ARENA_DEKARON( self, _ackMsg)
    self :getView() :setArenaLv( _ackMsg :getArenaLv())
    self :getView() :setTime( _ackMsg :getTime())
    self :getView() :setCount( _ackMsg :getCount())
    print("---------------------")
    local m_challengeplayerlist = _ackMsg :getChallageplayerdata()
    local m_myinfo = nil
    local function sortfuncdown( play1, play2)
        if play1.ranking > play2.ranking then
            return true
        end
        return false
    end
    table.sort( m_challengeplayerlist, sortfuncdown)
    local mainplay = _G.g_characterProperty :getMainPlay()
    local myuid    = mainplay :getUid()      --玩家Uid
    print( "BBBBBBBBBBBB:"..myuid)
    for k,v in pairs( m_challengeplayerlist) do
        
        if k == 1 then
            if v.uid == myuid then
                --5名之后
                m_myinfo = v
            end
            if _ackMsg :getCount() > 5 then --<==>#self.m_challengeplayerlist >5 then
                --总人数少于5人不移出
                table.remove( m_challengeplayerlist, 1)
            end
            break
        end
         
    end
    local function sortfuncup( play1, play2)
        if play1.ranking < play2.ranking then
            return true
        end
        return false
    end
    table.sort( m_challengeplayerlist, sortfuncup)
    for k,v in pairs(m_challengeplayerlist) do
        if v.uid == myuid then
            --5名之内
            m_myinfo = v
            table.remove( m_challengeplayerlist, k)
        end
    end
    
    local myRenown = _ackMsg:getRenown()
    self :getView() :setChallengeplayerlist( m_myinfo, m_challengeplayerlist, myRenown)
end

function CChallengePanelMediator.ACK_ARENA_REWARD_TIMES( self, _ackMsg)
    _G.pDateTime : reset()
    local nowTime1 = _G.pDateTime : getTotalSeconds() --秒
    local receiveawardstime1 = _ackMsg :getTimes()--3600-60*5
    local nowTime = 60*60*os.date("%H",nowTime1)+60*os.date("%M",nowTime1)+os.date("%S",nowTime1)
    local receiveawardstime = 60*60*os.date("%H",receiveawardstime1)+60*os.date("%M",receiveawardstime1)+os.date("%S",receiveawardstime1)
    print("ACK:"..self :turnTime( receiveawardstime))
    print("LOC:"..self :turnTime( nowTime))
    print( receiveawardstime,"XXXXXX",nowTime,"YYYYYY",receiveawardstime-nowTime)
    local IsReceive = _ackMsg :getType()
    print("IsReceive",IsReceive)
    if IsReceive == 0 then
        print("不可领取")
        local temptime = 0
        if nowTime < receiveawardstime then  --当天
            temptime = receiveawardstime-nowTime
        else                                 --隔天
            temptime = receiveawardstime+24*60*60-nowTime
        end
        self :getView() :setReceiveAwardsTime( temptime, false)
    elseif IsReceive == 1 then
        print("可领取")
        self :getView() :setReceiveAwardsTime( 0, true)
    else
        print("服务端数据下发有误")
        self :getView() :setReceiveAwardsTime( 0, false)
    end
    self :getView() :setAwards( _ackMsg :getGold(), _ackMsg :getRenoe())
end

function CChallengePanelMediator.ACK_ARENA_GET_REWARD( self, _ackMsg)
    self :getView() :setNewRenown(_ackMsg:getRenown())
end

--清除CD
function CChallengePanelMediator.ACK_ARENA_CLEAN_OK( self, _ackMsg)
    local viewTemp = self :getView()
    if viewTemp == nil then
        return
    end
    viewTemp : setTime(0)
end

--购买次数 返回当前购买次数
function CChallengePanelMediator.ACK_ARENA_RESULT2( self, _ackMsg)
    local viewTemp = self :getView()
    if viewTemp == nil then
        return
    end
    local count = _ackMsg : getBuyCount()
    viewTemp : buyCountMediatorCallBack( count )
end

--购买成功,刷新次数
function CChallengePanelMediator.ACK_ARENA_BUY_OK( self, _ackMsg)
    local viewTemp = self :getView()
    if viewTemp == nil then
        return
    end
    local count = _ackMsg : getScount()
    viewTemp : setSurplus( count )
    --print( "购买成功,刷新次数",count )
end

----------------------
--test
--{时间拆分为 00:00:00}
function CChallengePanelMediator.turnTime( self, _time)
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
    return hor..":"..min..":"..sec
end
--{时间转字符串}
function CChallengePanelMediator.toTimeString( self, _num )
    _num = _num <=0 and "00" or _num
    if type(_num) ~= "string" then
        _num = _num >=10 and tostring(_num) or ("0"..tostring(_num))
    end
    return _num
end
-------------------

