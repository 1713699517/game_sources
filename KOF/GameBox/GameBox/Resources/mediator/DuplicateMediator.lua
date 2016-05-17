require "mediator/mediator"
require "controller/DuplicateCommand"
require "model/VO_DuplicateModel"
require "proxy/DuplicateDataProxy"

require "common/MessageProtocol"

require "view/DuplicateLayer/RewardCopyView"

CDuplicateMediator = class(mediator, function(self, _view)
    self.name = "DuplicateMediator"
    self.view = _view
    print("Mediator:",self.name)
end)

function CDuplicateMediator.getView(self)
    return self.view
end

function CDuplicateMediator.getName(self)
    return self.name
end



function CDuplicateMediator.processCommand(self, _command)
    --接收服务器下发消息 接收ACK
    if _command :getType() == CNetworkCommand.TYPE then
        local msgID = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()
        if msgID == _G.Protocol.ACK_COPY_REVERSE_OLD   then -- [7002]副本信息返回 -- 副本
            CCLOG("-- [7002]副本信息返回 -- 副本 ")
            self :ACK_COPY_REVERSE_OLD( ackMsg)
        elseif msgID == _G.Protocol.ACK_COPY_CHAP_DATA   then -- [7015]当前章节信息 -- 副本
            CCLOG("-- [7015]当前章节信息 -- 副本 ")
            --self :ACK_COPY_CHAP_DATA( ackMsg)
        elseif msgID == _G.Protocol.ACK_COPY_CHAP_DATA_NEW   then -- (手动) -- [7022]当前章节信息(new) -- 副本
            CCLOG("-- (手动) -- [7022]当前章节信息(new) -- 副本 ")
            self :ACK_COPY_CHAP_DATA_NEW( ackMsg)
        elseif msgID == _G.Protocol.ACK_HERO_CHAP_DATA   then -- [39010]当前章节信息 -- 英雄副本
            CCLOG("-- [39010]当前章节信息 -- 英雄副本 ")
            --self :ACK_HERO_CHAP_DATA( ackMsg)
        elseif msgID == _G.Protocol.ACK_HERO_CHAP_DATA_NEW   then -- (手动) -- [39070]当前章节信息(new) -- 英雄副本 
            CCLOG("-- (手动) -- [39070]当前章节信息(new) -- 英雄副本  ")
            self :ACK_HERO_CHAP_DATA_NEW( ackMsg)
        elseif msgID == _G.Protocol.ACK_FIEND_CHAP_DATA   then -- [46220]当前章节信息 -- 魔王副本
            CCLOG("-- [46220]当前章节信息 -- 魔王副本 ")
            --self :ACK_FIEND_CHAP_DATA( ackMsg)
        elseif msgID == _G.Protocol.ACK_FIEND_CHAP_DATA_NEW   then -- (手动) -- [46270]当前章节信息(new) -- 魔王副本 
            CCLOG("-- (手动) -- [46270]当前章节信息(new) -- 魔王副本  ")
            self :ACK_FIEND_CHAP_DATA_NEW( ackMsg)
        elseif msgID == _G.Protocol.ACK_HERO_BACK_TIMES then -- [39060]购买次数返回 -- 英雄副本
            CCLOG("-- [39060]购买次数返回 -- 英雄副本")
            self :ACK_HERO_BACK_TIMES( ackMsg)
        elseif msgID == _G.Protocol.ACK_COPY_CHAP_RE_REP then -- [7900]查询章节奖励返回 -- 副本
            CCLOG("-- [7900]查询章节奖励返回 -- 副本")
            self :ACK_COPY_CHAP_RE_REP( ackMsg)
        elseif msgID == _G.Protocol.ACK_FIEND_FRESH_BACK then -- (手动) -- [46260]刷新魔王副本返回 -- 魔王副本
            CCLOG("-- (手动) -- [46260]刷新魔王副本返回 -- 魔王副本")
            self :ACK_FIEND_FRESH_BACK( ackMsg)
        end
    end


 
    --接收自己客户端
    if _command:getType() == CDuplicateCommand.TYPE then
        print("Mediator name------>",self: getName())
        print("Mediator view------>",self: getView())
        print("_command:getType--->",_command: getType())
        print("_command:getModel-->",_command: getModel())

        self :getView() :setLocalList()

        --[[
        if _command :getModel() :getAT() == "AT_setGoodsRemove" then
            self :getView() :setGoodsRemove( _command :getModel() :getGoodsRemove())
        end
         ]]
    end
    return false
end
 
--[[
            A......C......K
--]]


function CDuplicateMediator.ACK_COPY_CHAP_RE_REP( self, _ackMsg)
    _G.g_DuplicateDataProxy :setChapterReward( _ackMsg :getResult())
end

--
-- [7002]副本信息返回 -- 副本
function CDuplicateMediator.ACK_COPY_REVERSE_OLD( self, _ackMsg)
    -- body
    local count = _ackMsg :getCount()
    local data  = _ackMsg :getData()
    print("*****************************************")
    --副本缓存更新
    -------------------------------------------------------------------
    --_G.g_DuplicateDataProxy :setDuplicateCount( _ackMsg :getCount())
    --_G.g_DuplicateDataProxy :setDuplicateList( _ackMsg :getData())
    --------------------------------------------------------------------
    print( "副本数量：", count)
    for k,v in pairs( data) do
        print( v.copy_id,v.is_pass)
    end
    local model = VO_DuplicateModel()
    model :setDuplicateCount( _ackMsg :getCount())
    model :setDuplicateList( _ackMsg :getData())
    local command = CDuplicateCommand( model)
    controller :sendCommand(command)

end

-- [7015]当前章节信息 -- 副本
function CDuplicateMediator.ACK_COPY_CHAP_DATA( self, _ackMsg )
    local chap        = _ackMsg :getChap()
    local next_chap   = _ackMsg :getNextChap()
    local count       = _ackMsg :getCount()
    local data        = _ackMsg :getData()
    _G.g_DuplicateDataProxy :setCurrentChapter( _ackMsg :getChap(), 101)
    _G.g_DuplicateDataProxy :setNextChapterIsGoing( _ackMsg :getNextChap())
    _G.g_DuplicateDataProxy :setDuplicateCount( _ackMsg :getCount())
    _G.g_DuplicateDataProxy :setDuplicateList( _ackMsg :getData())

    local model = VO_DuplicateModel()
    local command = CDuplicateCommand( model)
    controller :sendCommand(command)
    
    self:getView():initGuideView()
end

-- (手动) -- [7022]当前章节信息(new) -- 副本
function CDuplicateMediator.ACK_COPY_CHAP_DATA_NEW( self, _ackMsg )
    local chap        = _ackMsg :getChap()
    local next_chap   = _ackMsg :getNextChap()
    local count       = _ackMsg :getCount()
    local data        = _ackMsg :getData()
    _G.g_DuplicateDataProxy :setCurrentChapter( _ackMsg :getChap(), 101)
    _G.g_DuplicateDataProxy :setNextChapterIsGoing( _ackMsg :getNextChap())
    _G.g_DuplicateDataProxy :setDuplicateCount( _ackMsg :getCount())
    _G.g_DuplicateDataProxy :setDuplicateList( _ackMsg :getData())

    local model = VO_DuplicateModel()
    local command = CDuplicateCommand( model)
    controller :sendCommand(command)
    
    self:getView():initGuideView()
end

-- [39010]当前章节信息 -- 英雄副本
function CDuplicateMediator.ACK_HERO_CHAP_DATA( self, _ackMsg)
    local chap         = _ackMsg :getChap()
    local next_chap    = _ackMsg :getNextChap()
    local times        = _ackMsg :getTimes()
    local count        = _ackMsg :getCount()
    local battle_data  = _ackMsg :getBattleData()
    _G.g_DuplicateDataProxy :setCurrentChapter( _ackMsg :getChap(), 102)
    _G.g_DuplicateDataProxy :setNextChapterIsGoing( _ackMsg :getNextChap())
    _G.g_DuplicateDataProxy :setTimes( _ackMsg :getTimes())
    _G.g_DuplicateDataProxy :setDuplicateCount( _ackMsg :getCount())
    _G.g_DuplicateDataProxy :setDuplicateList( _ackMsg :getBattleData())
    _G.g_DuplicateDataProxy :setBuyAndFreeTimes( _ackMsg :getBuyTimes(), _ackMsg :getFreeTimes())

    local model = VO_DuplicateModel()
    local command = CDuplicateCommand( model)
    controller :sendCommand(command)
    
    self:getView():initGuideView()
end

-- (手动) -- [39070]当前章节信息(new) -- 英雄副本 
function CDuplicateMediator.ACK_HERO_CHAP_DATA_NEW( self, _ackMsg)
    local chap         = _ackMsg :getChap()
    local next_chap    = _ackMsg :getNextChap()
    local times        = _ackMsg :getTimes()
    local count        = _ackMsg :getCount()
    local battle_data  = _ackMsg :getData()
    _G.g_DuplicateDataProxy :setCurrentChapter( _ackMsg :getChap(), 102)
    _G.g_DuplicateDataProxy :setNextChapterIsGoing( _ackMsg :getNextChap())
    _G.g_DuplicateDataProxy :setTimes( _ackMsg :getTimes())
    _G.g_DuplicateDataProxy :setDuplicateCount( _ackMsg :getCount())
    _G.g_DuplicateDataProxy :setDuplicateList( _ackMsg :getData())
    _G.g_DuplicateDataProxy :setBuyAndFreeTimes( _ackMsg :getBuyTimes(), _ackMsg :getFreeTimes())

    local model = VO_DuplicateModel()
    local command = CDuplicateCommand( model)
    controller :sendCommand(command)
    
    self:getView():initGuideView()
end

-- [39060]购买次数返回 -- 英雄副本
function CDuplicateMediator.ACK_HERO_BACK_TIMES( self, _ackMsg)
    local times        = _ackMsg :getTimes()
    print( "英雄副本次数返回:",times)
    _G.g_DuplicateDataProxy : setTimes( times)
    self :getView() :setBuyHeroTimes( times)  
end

function CDuplicateMediator.ACK_FIEND_FRESH_BACK( self, _ackMsg)
    local copy_id  = _ackMsg :getCopyId()
    local times    = _ackMsg :getTimes()
    print("魔王副本刷新返回:", type(copy_id), times)
    local duplicatelist       = _G.g_DuplicateDataProxy : getDuplicateList()   --副本信息  copy_id  is_pass
    for k,v in pairs(duplicatelist) do
        print(k,(v.copy_id),(copy_id))
        if tonumber(copy_id) == v.copy_id then
            print( "XXXX:"..v.copy_id..v.is_pass..v.times)
            v.times = times
        end
    end
    _G.g_DuplicateDataProxy :setTimes(  _G.g_DuplicateDataProxy :getTimes()-1)
    self :getView() :setFiendTimes( copy_id, _G.g_DuplicateDataProxy :getTimes())
end


-- [46220]当前章节信息 -- 魔王副本
function CDuplicateMediator.ACK_FIEND_CHAP_DATA( self, _ackMsg)
    local chap         = _ackMsg :getChap()
    local next_chap    = _ackMsg :getNextChap()
    local times        = _ackMsg :getTimes()
    local count        = _ackMsg :getCount()
    local data         = _ackMsg :getData()
    _G.g_DuplicateDataProxy :setCurrentChapter( _ackMsg :getChap(), 103)
    _G.g_DuplicateDataProxy :setNextChapterIsGoing( _ackMsg :getNextChap())
    _G.g_DuplicateDataProxy :setTimes( _ackMsg :getTimes())
    _G.g_DuplicateDataProxy :setDuplicateCount( _ackMsg :getCount())
    _G.g_DuplicateDataProxy :setDuplicateList( _ackMsg :getData())

    local model = VO_DuplicateModel()
    local command = CDuplicateCommand( model)
    controller :sendCommand(command)
    
    self:getView():initGuideView()
end

-- (手动) -- [46270]当前章节信息(new) -- 魔王副本 
function CDuplicateMediator.ACK_FIEND_CHAP_DATA_NEW( self, _ackMsg)
    local chap         = _ackMsg :getChap()
    local next_chap    = _ackMsg :getNextChap()
    local times        = _ackMsg :getTimes()
    local count        = _ackMsg :getCount()
    local data         = _ackMsg :getData()
    _G.g_DuplicateDataProxy :setCurrentChapter( _ackMsg :getChap(), 103)
    _G.g_DuplicateDataProxy :setNextChapterIsGoing( _ackMsg :getNextChap())
    _G.g_DuplicateDataProxy :setTimes( _ackMsg :getTimes())
    _G.g_DuplicateDataProxy :setDuplicateCount( _ackMsg :getCount())
    _G.g_DuplicateDataProxy :setDuplicateList( _ackMsg :getData())

    local model = VO_DuplicateModel()
    local command = CDuplicateCommand( model)
    controller :sendCommand(command)
    
    self:getView():initGuideView()
end
