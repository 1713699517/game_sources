require "mediator/mediator"
require "common/MessageProtocol"

require "controller/CharacterPorpertyACKCommand"

-----------------------------------------------------------------------
--创建社团面板 
-----------------------------------------------------------------------
CFactionCreateMediator = class(mediator, function(self, _view)
    self.name = "CFactionCreateMediator"
    self.view = _view
    CCLOG("Mediator:",self.name)
end)

function CFactionCreateMediator.getView(self)
    return self.view
end
function CFactionCreateMediator.getName(self)
    return self.name
end

function CFactionCreateMediator.processCommand(self, _command)
    --接收服务器下发消息 接收ACK
    if _command :getType() == CNetworkCommand.TYPE then
        local msgID = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()
        ----[[
        if msgID == _G.Protocol.ACK_CLAN_OK_REBUILD_CLAN      then  -- (手动) -- [33060]创建成功 -- 社团   
            print("_G.Protocol.ACK_CLAN_OK_REBUILD_CLAN-->>>>>",_G.Protocol.ACK_CLAN_OK_REBUILD_CLAN)
            self :ACK_CLAN_OK_REBUILD_CLAN( ackMsg)
        end
        --]]
    end
    return false
end

function CFactionCreateMediator.ACK_CLAN_OK_REBUILD_CLAN( self, _ackmsg)
    print( "创建社团成功")
    self :getView() :createClanSuccess()
end


-----------------------------------------------------------------------
--社团列表和申请社团面板 
-----------------------------------------------------------------------
CFactionApplyMediator = class(mediator, function(self, _view)
    self.name = "CFactionApplyMediator"
    self.view = _view
    CCLOG("Mediator:",self.name)
end)

function CFactionApplyMediator.getView(self)
    return self.view
end
function CFactionApplyMediator.getName(self)
    return self.name
end

function CFactionApplyMediator.processCommand(self, _command)
    --接收服务器下发消息 接收ACK
    if _command :getType() == CNetworkCommand.TYPE then
        local msgID = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()
        ----[[
        if msgID == _G.Protocol.ACK_CLAN_OK_CLANLIST      then  -- (手动) -- [33030]请求社团列表 -- 社团   
            print("_G.Protocol.ACK_CLAN_OK_CLANLIST-->>>>>",_G.Protocol.ACK_CLAN_OK_CLANLIST)
            self :ACK_CLAN_OK_CLANLIST( ackMsg)
        elseif msgID == _G.Protocol.ACK_CLAN_APPLIED_CLANLIST   then -- [ 33036]已申请社团列表 -- 社团 
            print("_G.Protocol.ACK_CLAN_APPLIED_CLANLIST-->>>>>",_G.Protocol.ACK_CLAN_APPLIED_CLANLIST)
            self :ACK_CLAN_APPLIED_CLANLIST( ackMsg)
        elseif msgID == _G.Protocol.ACK_CLAN_OK_JOIN_CLAN then -- (手动) -- [33040]申请/取消成功 -- 社团 
            print("_G.Protocol.ACK_CLAN_OK_JOIN_CLAN-->>>>>",_G.Protocol.ACK_CLAN_OK_JOIN_CLAN)
            self :ACK_CLAN_OK_JOIN_CLAN( ackMsg)
        end
        --]]
    end
    return false
end

function CFactionApplyMediator.ACK_CLAN_OK_CLANLIST( self, _ackmsg)
    print( "请求社团列表成功")
    local curpage = _ackmsg :getPage()
    local allpage = _ackmsg :getAllPages()
    print( "当前页:"..curpage.."总页数:"..allpage)
    self :getView() :setFactionList( _ackmsg :getCount(), _ackmsg :getClandataMsg())
end

function CFactionApplyMediator.ACK_CLAN_APPLIED_CLANLIST( self, _ackmsg)
    print( "已申请社团列表")
    self :getView() :setApplyList( _ackmsg :getIs(), _ackmsg :getCount(), _ackmsg :getClanList())
end

function CFactionApplyMediator.ACK_CLAN_OK_JOIN_CLAN( self, _ackmsg)
    print( "申请/取消社团成功", _ackmsg :getType(), _ackmsg :getClanId())
    self :getView() :setApplyOrCancle( _ackmsg :getType(), _ackmsg :getClanId())
end

-----------------------------------------------------------------------
--社团基本信息面板 
-----------------------------------------------------------------------
CFactionInfomationMediator = class(mediator, function(self, _view)
    self.name = "CFactionInfomationMediator"
    self.view = _view
    CCLOG("Mediator:",self.name)
end)

function CFactionInfomationMediator.getView(self)
    return self.view
end
function CFactionInfomationMediator.getName(self)
    return self.name
end

function CFactionInfomationMediator.processCommand(self, _command)
    --接收服务器下发消息 接收ACK
    if _command :getType() == CNetworkCommand.TYPE then
        local msgID = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()
        ----[[
        if msgID == _G.Protocol.ACK_CLAN_OK_CLAN_DATA      then  -- (手动) -- [33020]返加社团基础数据1 -- 社团   
            print("_G.Protocol.ACK_CLAN_OK_CLAN_DATA-->>>>>",_G.Protocol.ACK_CLAN_OK_CLAN_DATA)
            self :ACK_CLAN_OK_CLAN_DATA( ackMsg)
        elseif msgID == _G.Protocol.ACK_CLAN_OK_OTHER_DATA then  -- (手动) -- [33023]返加社团基础数据2 -- 社团 
            print("_G.Protocol.ACK_CLAN_OK_OTHER_DATA-->>>>>",_G.Protocol.ACK_CLAN_OK_OTHER_DATA)
            self :ACK_CLAN_OK_OTHER_DATA( ackMsg)
        elseif msgID == _G.Protocol.ACK_CLAN_CLAN_LOGS then    -- [33025]返加社团日志数据3 -- 社团 
            print("_G.Protocol.ACK_CLAN_CLAN_LOGS-->>>>>",_G.Protocol.ACK_CLAN_CLAN_LOGS)
            self :ACK_CLAN_CLAN_LOGS( ackMsg)
        elseif msgID == _G.Protocol.ACK_CLAN_OK_RESET_CAST then    -- (手动) -- [33120]返回修改公告结果 -- 社团
            print("_G.Protocol.ACK_CLAN_OK_RESET_CAST-->>>>>",_G.Protocol.ACK_CLAN_OK_RESET_CAST)
            self :ACK_CLAN_OK_RESET_CAST( ackMsg)
        elseif msgID == _G.Protocol.ACK_CLAN_OK_OUT_CLAN then    -- (手动) -- [33160]退出社团成功 -- 社团 
            print("_G.Protocol.ACK_CLAN_OK_OUT_CLAN-->>>>>",_G.Protocol.ACK_CLAN_OK_OUT_CLAN)
            self :ACK_CLAN_OK_OUT_CLAN( ackMsg)
        end
        --]]
    end
    return false
end

function CFactionInfomationMediator.ACK_CLAN_OK_RESET_CAST( self, _ackmsg)
    print( "-- (手动) -- [33120]返回修改公告结果 -- 社团")
    self :getView() :setChangeBulletinOK()
end

function CFactionInfomationMediator.ACK_CLAN_OK_OUT_CLAN( self, _ackmsg)
    print( "-- (手动) -- [33160]退出社团成功 -- 社团")
    self :getView() :setOutClanOK()
end

function CFactionInfomationMediator.ACK_CLAN_OK_CLAN_DATA( self, _ackmsg)
    print( "-- (手动) -- [33020]返加社团基础数据1 -- 社团 ")
    local factiondata = {}
    factiondata.clan_id          = _ackmsg :getClanId()          -- {社团ID}
    factiondata.clan_name        = _ackmsg :getClanName()        -- {社团名字}
    factiondata.clan_lv          = _ackmsg :getClanLv()          -- {社团等级}
    factiondata.clan_rank        = _ackmsg :getClanRank()        -- {社团排名}
    factiondata.clan_members     = _ackmsg :getClanMembers()     -- {社团当前成员数}
    factiondata.clan_all_members = _ackmsg :getClanAllMembers()  -- {社团成员上限数}
    self :getView() :setFactionInfo( factiondata)
end


function CFactionInfomationMediator.ACK_CLAN_OK_OTHER_DATA( self, _ackmsg)
    print( " -- (手动) -- [33023]返加社团基础数据2 -- 社团")
    local presidentdata = {}
    presidentdata.master_uid          = _ackmsg :getMasterUid() -- {社长uid}
    presidentdata.master_name         = _ackmsg :getMasterName() -- {社长名字}
    presidentdata.master_name_color   = _ackmsg :getMasterNameColor() -- {社长名字颜色}
    presidentdata.master_lv           = _ackmsg :getMasterLv() -- {社长等级}
    presidentdata.member_contribute   = _ackmsg :getMemberContribute() -- {个人贡献值}
    presidentdata.member_power        = _ackmsg :getMemberPower() -- {个人权限等级}
    presidentdata.clan_all_contribute = _ackmsg :getClanAllContribute() -- {社团总贡献值}
    presidentdata.clan_contribute     = _ackmsg :getClanContribute() -- {升级所需贡献}
    presidentdata.clan_broadcast      = _ackmsg :getClanBroadcast() -- {社团公告}  我是你哥哥

    local mainProperty = _G.g_characterProperty : getMainPlay()
    mainProperty : setClanPost( _ackmsg :getMemberPower())
    self :getView() :setPresidentInfo( presidentdata)
end



function CFactionInfomationMediator.ACK_CLAN_CLAN_LOGS( self, _ackmsg)
    print( "-- [33025]返加社团日志数据3 -- 社团")
    local logscount = _ackmsg :getCount()
    local logsmsg   = _ackmsg :getLogsData()
    local logsmsgdata = {}
    for k=1, logscount do
        local value = CLanguageManager:sharedLanguageManager():getString("faction_logs_"..tostring(logsmsg[k].type) )
        if value == nil then
            return
        end
        local times = os.date("%x",logsmsg[k].time).." "..os.date("%H",logsmsg[k].time)..":"..os.date("%S",logsmsg[k].time)
        local tempstring = logsmsg[k].string_msg
        print( k,"@@@@@@@:",times,value,tempstring,logsmsg[k].count1)
        for i=1, logsmsg[k].count1 do
            value =  self : gsub( value, "$", tempstring[i].name, tempstring[i].name_color)
        end
        local tempint = logsmsg[k].int_msg
        for i=1, logsmsg[k].count2 do
            value =  self : gsub( value, "#", tempint[i].value)
        end
        logsmsgdata[k] = times.."\n\t"..value
    end
    self :getView() :setLogsIngo( logscount, logsmsgdata)
end

function CFactionInfomationMediator.gsub( self, _str ,_taget, _source, _color)
    local result=""
    local isfind = false
    for i=1,string.len(_str) do
        local tmpStr = string.sub(_str,i,i)
        if tmpStr == _taget and isfind == false then
            result = result.._source
            isfind = true
        else
            result = result..tmpStr
        end
    end
    return result
end


-----------------------------------------------------------------------
--社团审核面板 
-----------------------------------------------------------------------
CFactionVerifyListMediator = class(mediator, function(self, _view)
    self.name = "CFactionVerifyListMediator"
    self.view = _view
    CCLOG("Mediator:",self.name)
end)

_G.g_CFactionVerifyListMediator = CFactionVerifyListMediator()


function CFactionVerifyListMediator.getView(self)
    return self.view
end
function CFactionVerifyListMediator.getName(self)
    return self.name
end

function CFactionVerifyListMediator.processCommand(self, _command)
    --接收服务器下发消息 接收ACK
    if _command :getType() == CNetworkCommand.TYPE then
        local msgID = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()
        ----[[
        if msgID == _G.Protocol.ACK_CLAN_OK_JOIN_LIST      then  -- [33080]返回入帮申请列表 -- 社团   
            print("_G.Protocol.ACK_CLAN_OK_JOIN_LIST-->>>>>",_G.Protocol.ACK_CLAN_OK_JOIN_LIST)
            self :ACK_CLAN_OK_JOIN_LIST( ackMsg)
        end
        --]]
    end
    return false
end

function CFactionVerifyListMediator.ACK_CLAN_OK_JOIN_LIST( self, _ackmsg)
    print( "-- [33080]返回入帮申请列表 -- 社团")
    self :getView() :setVerifyList( _ackmsg :getCount(), _ackmsg :getUserData())
end

-----------------------------------------------------------------------
--创建社团面板 
-----------------------------------------------------------------------
CFactionMemberListMediator = class(mediator, function(self, _view)
    self.name = "CFactionMemberListMediator"
    self.view = _view
    CCLOG("Mediator:",self.name)
end)

function CFactionMemberListMediator.getView(self)
    return self.view
end
function CFactionMemberListMediator.getName(self)
    return self.name
end

function CFactionMemberListMediator.processCommand(self, _command)
    --接收服务器下发消息 接收ACK
    if _command :getType() == CNetworkCommand.TYPE then
        local msgID = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()
        ----[[
        if msgID == _G.Protocol.ACK_CLAN_OK_MEMBER_LIST      then  -- [33140]返回社团成员列表 -- 社团    
            print("_G.Protocol.ACK_CLAN_OK_MEMBER_LIST-->>>>>",_G.Protocol.ACK_CLAN_OK_MEMBER_LIST)
            self :ACK_CLAN_OK_MEMBER_LIST( ackMsg)
        end
        --]]
    end
    return false
end

function CFactionMemberListMediator.ACK_CLAN_OK_MEMBER_LIST( self, _ackmsg)
    print( "-- [33140]返回社团成员列表 -- 社团 ")
    self :getView() :setMembersData( _ackmsg :getCount(), _ackmsg :getMemberMsg())
end

-----------------------------------------------------------------------
--社团技能面板 
-----------------------------------------------------------------------
CFactionSkillMediator = class(mediator, function(self, _view)
    self.name = "CFactionSkillMediator"
    self.view = _view
    CCLOG("Mediator:",self.name)
end)

function CFactionSkillMediator.getView(self)
    return self.view
end
function CFactionSkillMediator.getName(self)
    return self.name
end

function CFactionSkillMediator.processCommand(self, _command)
    --接收服务器下发消息 接收ACK
    if _command :getType() == CNetworkCommand.TYPE then
        local msgID = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()
        ----[[
        if msgID == _G.Protocol.ACK_CLAN_OK_CLAN_SKILL      then  -- [33210]返回社团技能面板数据 -- 社团    
            print("_G.Protocol.ACK_CLAN_OK_CLAN_SKILL-->>>>>",_G.Protocol.ACK_CLAN_OK_CLAN_SKILL)
            self :ACK_CLAN_OK_CLAN_SKILL( ackMsg)
        elseif msgID == _G.Protocol.ACK_CLAN_CLAN_ATTR_DATA then -- (手动) -- [33215]社团技能属性数据块【33215】 -- 社团 
            print("_G.Protocol.ACK_CLAN_CLAN_ATTR_DATA-->>>>>",_G.Protocol.ACK_CLAN_CLAN_ATTR_DATA)
            self :ACK_CLAN_CLAN_ATTR_DATA( ackMsg)
        elseif msgID == _G.Protocol.ACK_CLAN_NOW_STAMINA then -- (手动) -- [33215]社团技能属性数据块【33215】 -- 社团 
            print("_G.Protocol.ACK_CLAN_NOW_STAMINA-->>>>>",_G.Protocol.ACK_CLAN_NOW_STAMINA)
            self :ACK_CLAN_NOW_STAMINA( ackMsg)
        end
    end
    return false
end

function CFactionSkillMediator.ACK_CLAN_OK_CLAN_SKILL( self, _ackmsg)
    print( "-- [33210]返回社团技能面板数据 -- 社团 ")
    self :getView() :setLocalList( _ackmsg :getStamina(), _ackmsg :getCount(), _ackmsg :getAttrMsg())
end

function CFactionSkillMediator.ACK_CLAN_CLAN_ATTR_DATA( self, _ackmsg)
    print( "-- (手动) -- [33215]社团技能属性数据块【33215】 -- 社团 ")
    print(" 1:".._ackmsg :getType().." 2:".._ackmsg :getSkillLv().." 3:".._ackmsg :getValue().." 4:".._ackmsg :getAddValue().." 5:".._ackmsg :getCast())
    self :getView() :setLVChange( _ackmsg :getType(), _ackmsg :getSkillLv(), _ackmsg :getValue(), _ackmsg :getAddValue(), _ackmsg :getCast())
end

function CFactionSkillMediator.ACK_CLAN_NOW_STAMINA( self, _ackmsg)
    print( "-- (手动) -- [33305]玩家现有体能值 -- 社团")
    self :getView() :setStamina( _ackmsg :getStamina())
end



-----------------------------------------------------------------------
--社团活动面板 
-----------------------------------------------------------------------
CFactionActiveMediator = class(mediator, function(self, _view)
    self.name = "CFactionActiveMediator"
    self.view = _view
    CCLOG("Mediator:",self.name)
end)

function CFactionActiveMediator.getView(self)
    return self.view
end
function CFactionActiveMediator.getName(self)
    return self.name
end

function CFactionActiveMediator.processCommand(self, _command)
    --接收服务器下发消息 接收ACK
    if _command :getType() == CNetworkCommand.TYPE then
        local msgID = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()
        ----[[
        if msgID == _G.Protocol.ACK_CLAN_OK_ACTIVE_DATA      then  -- [33210]返回社团技能面板数据 -- 社团    
            print("_G.Protocol.ACK_CLAN_OK_ACTIVE_DATA-->>>>>",_G.Protocol.ACK_CLAN_OK_ACTIVE_DATA)
            self :ACK_CLAN_OK_ACTIVE_DATA( ackMsg)
        elseif msgID == _G.Protocol.ACK_CLAN_NOW_STAMINA then -- (手动) -- [33215]社团技能属性数据块【33215】 -- 社团 
            print("_G.Protocol.ACK_CLAN_NOW_STAMINA-->>>>>",_G.Protocol.ACK_CLAN_NOW_STAMINA)
            self :ACK_CLAN_NOW_STAMINA( ackMsg)
        end
        --]]
    elseif _command :getType() == CFactionLuckCatCommand.TYPE then
        self :setLuckyCatInfo( _command :getData())
    end
    return false
end

function CFactionActiveMediator.ACK_CLAN_OK_ACTIVE_DATA( self, _ackmsg)
    print( "-- [33210]返回社团技能面板数据 -- 社团 ")
    self :getView() :setLocalList( _ackmsg :getCount(), _ackmsg :getActiveData())
end

function CFactionActiveMediator.ACK_CLAN_NOW_STAMINA( self, _ackmsg)
    print( "-- (手动) -- [33305]玩家现有体能值 -- 社团")
    self :getView() :setStamina( _ackmsg :getStamina())
end

function CFactionActiveMediator.setLuckyCatInfo( self, _data)
    print( "修改招财猫活动次数:",_data.water_times,"/",_data.all_times)
    local times     = _data.water_times
    local all_times = _data.all_times
    local activeid  = _data.active_id
    self :getView() :setLuckyCatInfo( activeid, times, all_times)
end


-----------------------------------------------------------------------
--社团技能面板 
-----------------------------------------------------------------------
CFactionLuckyCatMediator = class(mediator, function(self, _view)
    self.name = "CFactionLuckyCatMediator"
    self.view = _view
    CCLOG("Mediator:",self.name)
end)

function CFactionLuckyCatMediator.getView(self)
    return self.view
end
function CFactionLuckyCatMediator.getName(self)
    return self.name
end

function CFactionLuckyCatMediator.processCommand(self, _command)
    --接收服务器下发消息 接收ACK
    if _command :getType() == CNetworkCommand.TYPE then
        local msgID = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()
        ----[[
        if msgID == _G.Protocol.ACK_CLAN_OK_WATER_DATA      then -- (手动) -- [33330]返回浇水面板数据 -- 社团    
            print("_G.Protocol.ACK_CLAN_OK_WATER_DATA-->>>>>",_G.Protocol.ACK_CLAN_OK_WATER_DATA)
            self :ACK_CLAN_OK_WATER_DATA( ackMsg)
        end
        --]]
    end
    return false
end

function CFactionLuckyCatMediator.ACK_CLAN_OK_WATER_DATA( self, _ackmsg)
    print( "-- (手动) -- [33330]返回浇水面板数据 -- 社团")
    local date = {}
    date.stamina     = _ackmsg :getStamina()   
    date.water_times = _ackmsg :getWaterTimes()
    date.all_times   = _ackmsg :getAllTimes()
    date.yqs_exp     = _ackmsg :getYqsExp()
    date.up_exp      = _ackmsg :getUpExp()
    date.yq_times    = _ackmsg :getYqTimes()
    date.water_logs  = _ackmsg :getWaterLogs()
    self :getView() :setLocalList( date)
end

