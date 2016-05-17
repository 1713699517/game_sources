require "mediator/mediator"
require "common/MessageProtocol"

CVindictiveSavvyMediator = class(mediator, function(self, _view)
    self.name = "CVindictiveSavvyMediator"
    self.view = _view
    print("Mediator:",self.name)
end)

function CVindictiveSavvyMediator.getView(self)
    return self.view
end

function CVindictiveSavvyMediator.getName(self)
    return self.name
end

function CVindictiveSavvyMediator.processCommand(self, _command)
    --接收服务器下发消息 接收ACK
    if _command :getType() == CNetworkCommand.TYPE then
        local msgID = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()
        if msgID == _G.Protocol.ACK_SYS_DOUQI_OK_GRASP_DATA   then -- (手动) -- [48220]领悟界面信息返回 -- 斗气系统 
            print("-- (手动) -- [48220]领悟界面信息返回 -- 斗气系统")
            self :ACK_SYS_DOUQI_OK_GRASP_DATA( ackMsg)
        elseif msgID == _G.Protocol.ACK_SYS_DOUQI_MORE_GRASP then -- [48223]一键领悟数据返回 -- 斗气系统 
            print( "-- [48223]一键领悟数据返回 -- 斗气系统  ")
            self :ACK_SYS_DOUQI_MORE_GRASP( ackMsg)
        elseif msgID == _G.Protocol.ACK_SYS_DOUQI_STORAGE_DATA then  -- [48290]仓库数据 -- 斗气系统
            print( "YYYYYYYY-- [48290]仓库数据 -- 斗气系统")
            self :ACK_SYS_DOUQI_STORAGE_DATA( ackMsg)
        elseif msgID == _G.Protocol.ACK_SYS_DOUQI_OK_USE_DOUQI then  -- (手动) -- [48290]移动斗气成功 -- 斗气系统
            print( "YYYYYYYY-- (手动) -- [48290]移动斗气成功 -- 斗气系统")
            self :ACK_SYS_DOUQI_OK_USE_DOUQI( ackMsg)
        elseif msgID == _G.Protocol.ACK_SYS_DOUQI_EAT_STATE then-- [48285]吞噬结果 -- 斗气系统 
            print( "YYYYYYYY-- [48285]吞噬结果 -- 斗气系统 ")
            self :ACK_SYS_DOUQI_EAT_STATE( ackMsg)
        elseif msgID == _G.Protocol.ACK_SYS_DOUQI_OK_GET_DQ then  -- (手动) -- [48310]拾取成功 -- 斗气系统 
            print( "-- (手动) -- [48310]拾取成功 -- 斗气系统 ")
            self :ACK_SYS_DOUQI_OK_GET_DQ( ackMsg)
        elseif msgID == _G.Protocol.ACK_SYS_DOUQI_OK_DQ_SPLIT  then -- (手动) -- [48330]分解斗气成功 -- 斗气系统 
            print(" -- (手动) -- [48330]分解斗气成功 -- 斗气系统 ")
            self :ACK_SYS_DOUQI_OK_DQ_SPLIT( ackMsg)
        end 
    end
    return false  
end
-- [48223]一键领悟数据返回 -- 斗气系统  
function CVindictiveSavvyMediator.ACK_SYS_DOUQI_MORE_GRASP( self, _ackMsg)
    print( "================ 一键领悟数据返回: ",_ackMsg :getCount())
    local count   = _ackMsg :getCount()
    local msgdata = _ackMsg :getMsgMore()
    self :getView() :setOneKeySavvy( _ackMsg :getCount(), _ackMsg :getMsgMore())
end
-- (手动) -- [48230]界面返回1--基础信息 -- 斗气系统 
function CVindictiveSavvyMediator.ACK_SYS_DOUQI_OK_GRASP_DATA( self, _ackMsg)
    local typegrasp    = _ackMsg :getTypeGrasp()  --当前领悟等级
    local oktimes      = _ackMsg :getOkTimes()    --已使用钻石领悟次数
    local alltimes     = _ackMsg :getAllTimes()   --总共钻石领悟次数
    local adamwar      = _ackMsg :getAdamWar()    --战魂值
    self :getView() :setSavvyState( typegrasp, oktimes, alltimes, adamwar)
end
-- [48290]仓库数据 -- 斗气系统
function CVindictiveSavvyMediator.ACK_SYS_DOUQI_STORAGE_DATA( self, _ackMsg)
    local type         = _ackMsg :getType()   --仓库类型
    local count        = _ackMsg :getCount()  --斗气装备数量
    local dqmsglist    = _ackMsg :getDqMsg()
    print("XXXXXXXX:",type,count,#dqmsglist)
    if type == _G.Constant.CONST_DOUQI_TYPE_STORAGE then  --领悟仓库
        self :getView() :setVindictiveBackpackChange( count, dqmsglist)
    elseif type == _G.Constant.CONST_DOUQI_TYPE_BAG then  --装备仓库
    end
end
-- [48285]吞噬结果 -- 斗气系统 
function CVindictiveSavvyMediator.ACK_SYS_DOUQI_EAT_STATE( self, _ackMsg)
    local count     = _ackMsg :getCount()
    local alldata   = _ackMsg :getEatData()
    self :getView() :setOneKeySwallow( count, alldata)
end
-- (手动) -- [48290]移动斗气成功 -- 斗气系统
function CVindictiveSavvyMediator.ACK_SYS_DOUQI_OK_USE_DOUQI( self, _ackMsg)
    local roleid    = _ackMsg :getRoleId()
    local dqid      = _ackMsg :getDqId()
    local startid   = _ackMsg :getLanidStart()
    local endid     = _ackMsg :getLanidEnd()
    local count     = _ackMsg :getCount()
    local newdata   = _ackMsg :getDqMsg()
    self :getView() :setMoveVindictiveOK( startid, endid, count, newdata)
end

-- (手动) -- [48310]拾取成功 -- 斗气系统
function CVindictiveSavvyMediator.ACK_SYS_DOUQI_OK_GET_DQ( self, _ackMsg)
    -- {0 一键拾取| ID 唯一ID}
    local count  = _ackMsg :getCount()
    local lanmsg = _ackMsg :getLanMsg()
    self :getView() :setGetVindictiveOK( count, lanmsg)
end

-- (手动) -- [48330]分解斗气成功 -- 斗气系统
function CVindictiveSavvyMediator.ACK_SYS_DOUQI_OK_DQ_SPLIT( self, _ackMsg)
    local roleid    = _ackMsg :getRoleId()
    local lanid     = _ackMsg :getLanId()
    local adamwar  = _ackMsg :getGetAdams()
    print("分解斗气:",roleid, "/", lanid,"/:", adamwar)
    self :getView() :setDecomposeVindictiveOK( lanid, adamwar)
end



CVindictiveRoleEquipMediator = class(mediator, function(self, _view)
    self.name = "CVindictiveRoleEquipMediator"
    self.view = _view
    print("Mediator:",self.name)
end)

function CVindictiveRoleEquipMediator.getView(self)
    return self.view
end

function CVindictiveRoleEquipMediator.getName(self)
    return self.name
end

function CVindictiveRoleEquipMediator.processCommand(self, _command)
    --接收服务器下发消息 接收ACK
    if _command :getType() == CNetworkCommand.TYPE then
        local msgID = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()
        if msgID == _G.Protocol.ACK_SYS_DOUQI_OK_DOUQI_ROLE then  -- [48260]装备界面信息返回 -- 斗气系统 
            print( "-- [48260]装备界面信息返回 -- 斗气系统 ")
            self :ACK_SYS_DOUQI_OK_DOUQI_ROLE( ackMsg)
        elseif msgID == _G.Protocol.ACK_SYS_DOUQI_STORAGE_DATA then  -- [48290]仓库数据 -- 斗气系统
            print( "XXXXXXXX-- [48290]仓库数据 -- 斗气系统")
            self :ACK_SYS_DOUQI_STORAGE_DATA( ackMsg)
        elseif msgID == _G.Protocol.ACK_SYS_DOUQI_OK_USE_DOUQI then  -- (手动) -- [48290]移动斗气成功 -- 斗气系统
            print( "XXXXXXXX-- (手动) -- [48290]移动斗气成功 -- 斗气系统")
            self :ACK_SYS_DOUQI_OK_USE_DOUQI( ackMsg)
        elseif msgID == _G.Protocol.ACK_SYS_DOUQI_EAT_STATE then-- [48285]吞噬结果 -- 斗气系统 
            print( "XXXXXXXX-- [48285]吞噬结果 -- 斗气系统 ")
            self :ACK_SYS_DOUQI_EAT_STATE( ackMsg)
        elseif msgID == _G.Protocol.ACK_SYS_DOUQI_OK_DQ_SPLIT  then -- (手动) -- [48330]分解斗气成功 -- 斗气系统 
            print(" -- (手动) -- [48330]分解斗气成功 -- 斗气系统 ")
            self :ACK_SYS_DOUQI_OK_DQ_SPLIT( ackMsg)
        end
    end
    return false
end

-- [48290]仓库数据 -- 斗气系统
function CVindictiveRoleEquipMediator.ACK_SYS_DOUQI_STORAGE_DATA( self, _ackMsg)
    local type         = _ackMsg :getType()   --仓库类型
    local count        = _ackMsg :getCount()  --斗气装备数量
    local dqmsglist    = _ackMsg :getDqMsg()
    if type == _G.Constant.CONST_DOUQI_TYPE_STORAGE then  --领悟仓库
    elseif type == _G.Constant.CONST_DOUQI_TYPE_BAG then  --装备仓库
        self :getView() :setVindictiveBackpackChange( count, dqmsglist)
    end
end
-- [48260]装备界面信息返回 -- 斗气系统 
function CVindictiveRoleEquipMediator.ACK_SYS_DOUQI_OK_DOUQI_ROLE( self, _ackMsg)
    local opencount = _ackMsg :getLanCount()
    local rolecount = _ackMsg :getCount()
    local roledata  = _ackMsg :getRoleMsg()
    self :getView() :setPartnerInfomation( opencount, rolecount, roledata)
end
-- (手动) -- [48290]移动斗气成功 -- 斗气系统
function CVindictiveRoleEquipMediator.ACK_SYS_DOUQI_OK_USE_DOUQI( self, _ackMsg)
    local roleid    = _ackMsg :getRoleId()
    local dqid      = _ackMsg :getDqId()
    local startid   = _ackMsg :getLanidStart()
    local endid     = _ackMsg :getLanidEnd()
    local count     = _ackMsg :getCount()
    local newdata   = _ackMsg :getDqMsg()
    self :getView() :setMoveVindictiveOK( startid, endid, count, newdata)
    --self :getView() :setPartnerStateChange( _ackMsg :getType(), _ackMsg :getPartnerId())
end

-- [48285]吞噬结果 -- 斗气系统 
function CVindictiveRoleEquipMediator.ACK_SYS_DOUQI_EAT_STATE( self, _ackMsg)
    local count     = _ackMsg :getCount()
    local alldata   = _ackMsg :getEatData()
    --self :getView() :setOneKeySwallow( count, alldata)
end

-- (手动) -- [48330]分解斗气成功 -- 斗气系统
function CVindictiveRoleEquipMediator.ACK_SYS_DOUQI_OK_DQ_SPLIT( self, _ackMsg)
    local roleid    = _ackMsg :getRoleId()
    local lanid     = _ackMsg :getLanId()
    local adamwar  = _ackMsg :getGetAdams()
    print("分解斗气:",roleid, "/", lanid,"/:", adamwar)
    self :getView() :setDecomposeVindictiveOK( lanid, adamwar)
end

