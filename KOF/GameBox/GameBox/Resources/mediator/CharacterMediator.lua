require "mediator/mediator"
require "controller/GameDataProxyCommand"
require "controller/CharacterUpadteCommand"
require "controller/OverlappingUseBoxCommand"

require "common/MessageProtocol"

-----------------------------------------------------------------------
--人物面板 属性部分mediator
-----------------------------------------------------------------------
CCharacterPanelMediator = class(mediator, function(self, _view)
    self.name = "CCharacterPanelMediator"
    self.view = _view
    CCLOG("Mediator:",self.name)
end)

function CCharacterPanelMediator.getView(self)
    return self.view
end
function CCharacterPanelMediator.getName(self)
    return self.name
end

function CCharacterPanelMediator.processCommand(self, _command)
    --接收服务器下发消息 接收ACK
    if _command :getType() == CNetworkCommand.TYPE then
        local msgID = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()
        --[[
        if msgID == _G.Protocol.ACK_GOODS_ENLARGE_COST      then  -- (手动) -- [2227]扩充需要的道具数量 -- 物品/背包  
            print("_G.Protocol.ACK_GOODS_ENLARGE_COST-->>>>>",_G.Protocol.ACK_GOODS_ENLARGE_COST)
            self :ACK_GOODS_ENLARGE_COST( ackMsg)
        end
        ]]
    end
    --接收本地界面更新command
    if _command :getType() == CCharacterCutoverCommand.TYPE then
        print("Command.TYPE:",CCharacterCutoverCommand.TYPE)
        local characterID = _command :getData()
        self :getView() :updateViewByPartnerId( characterID.uid, characterID.partner_id)
    end
    return false
end

-----------------------------------------------------------------------
--人物面板 属性部分mediator
-----------------------------------------------------------------------
CCharacterMediator = class(mediator, function(self, _view)
    self.name = "CCharacterMediator"
    self.view = _view
    CCLOG("Mediator:",self.name)
end)

function CCharacterMediator.getView(self)
    return self.view
end
function CCharacterMediator.getName(self)
    return self.name
end

function CCharacterMediator.processCommand(self, _command)
    --接收服务器下发消息 接收ACK
    if _command :getType() == CNetworkCommand.TYPE then
        --print("CBackpackMediator.processCommand\nACK.ACK.ACK.ACK.ACK.ACK:",_command :getProtocolID())
        local msgID = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()
        --[[
        if msgID == _G.Protocol.ACK_GOODS_ENLARGE_COST      then  -- (手动) -- [2227]扩充需要的道具数量 -- 物品/背包  
            print("_G.Protocol.ACK_GOODS_ENLARGE_COST-->>>>>",_G.Protocol.ACK_GOODS_ENLARGE_COST)
            self :ACK_GOODS_ENLARGE_COST( ackMsg)
        elseif msgID == _G.Protocol.ACK_GOODS_ENLARGE           then  -- (手动) -- [2230]容器扩充成功 -- 物品/背包
            print("_G.Protocol.ACK_GOODS_ENLARGE-->>>>>",_G.Protocol.ACK_GOODS_ENLARGE)
            self :ACK_GOODS_ENLARGE( ackMsg)
        end
        ]]
    end
    --接收缓存Proxyupdata的更新command
    if _command:getType() == CCharacterInfoUpdataCommand.TYPE then
        print("CCharacterInfoUpdataCommand.TYPE",CCharacterInfoUpdataCommand.TYPE)
        self :getView() :setLocalList()
    elseif _command :getType() == CCharacterButtonStataCommand.TYPE then
        print("更新属性界面Button",_command :getData())
        local type  = _command :getData()
        self :getView() :setStateChange( type)
    end
    return false
end


-----------------------------------------------------------------------
--人物面板 装备部分mediator
-----------------------------------------------------------------------
CCharacterEquipInfoMediator = class(mediator, function(self, _view)
    self.name = "CCharacterEquipInfoMediator"
    self.view = _view
    print("Mediator:",self.name)
end)

function CCharacterEquipInfoMediator.getView(self)
    return self.view
end
function CCharacterEquipInfoMediator.getName(self)
    return self.name
end

function CCharacterEquipInfoMediator.processCommand(self, _command)
    --接收服务器下发消息 接收ACK
    if _command :getType() == CNetworkCommand.TYPE then
        --print("CBackpackMediator.processCommand\nACK.ACK.ACK.ACK.ACK.ACK:",_command :getProtocolID())
        local msgID = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()
        if msgID == _G.Protocol.ACK_INN_RES_PARTNER then  -- (手动) -- [31270]离队/归队结果 -- 客栈  -- {1:归队成功0:离队成功}
            print( "-- (手动) -- [31270]离队/归队结果 -- 客栈 ")
            self :ACK_INN_RES_PARTNER( ackMsg)
        end
    end
    --接收缓存Proxyupdata的更新command
    if _command:getType() == CCharacterEquipInfoUpdataCommand.TYPE then
        print("CCharacterEquipInfoUpdataCommand.TYPE",CCharacterEquipInfoUpdataCommand.TYPE)
        self :getView() :setEquipContainerList()
    elseif _command:getType() == CCharacterRoleIconCommand.TYPE then
        self :getView() :setRoleIconList()
    end
    return false
end

-- (手动) -- [31270]离队/归队结果 -- 客栈  -- {1:归队成功0:离队成功}
function CCharacterEquipInfoMediator.ACK_INN_RES_PARTNER( self, _ackMsg)
    -- body
    self :getView() :setPartnerStateChange( _ackMsg :getType(), _ackMsg :getPartnerId())
end


-----------------------------------------------------------------------
--人物面板 道具与神器部分mediator
-----------------------------------------------------------------------
CCharacterPropsMediator = class(mediator, function(self, _view)
    self.name = "CCharacterPropsMediator"
    self.view = _view
    print("Mediator:",self.name)
end)

function CCharacterPropsMediator.getView(self)
    return self.view
end
function CCharacterPropsMediator.getName(self)
    return self.name
end

function CCharacterPropsMediator.processCommand(self, _command)
    --接收服务器下发消息 接收ACK
    if _command :getType() == CNetworkCommand.TYPE then
        --print("CBackpackMediator.processCommand\nACK.ACK.ACK.ACK.ACK.ACK:",_command :getProtocolID())
        local msgID = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()
        if msgID == _G.Protocol.ACK_GOODS_P_EXP_OK then  -- [2081]伙伴经验丹使用成功 -- 物品/背包
            print( "-- [2081]伙伴经验丹使用成功 -- 物品/背包")
            --self :ACK_GOODS_P_EXP_OK( ackMsg)
            self :getView() :setUsePExpOK()
        end
    end
    --接收缓存Proxyupdata的更新command
    if _command:getType() == CProxyUpdataCommand.TYPE then
        print("CProxyUpdataCommand.TYPE",CProxyUpdataCommand.TYPE)
        self :getView() :setLocalList()
    elseif _command:getType() == CCharacterSellCommand.TYPE then
        print("Command.TYPE:",CCharacterSellCommand.TYPE)
        self :getView() :setSellGood( _command :getData(), _command :getOtherData())
    elseif _command:getType() == COverlappingUseCommand.TYPE then
        print("Command.TYPE:",COverlappingUseCommand.TYPE)
        print("使用物品:")
        self :getView() :setUseGood( _command :getData(), _command :getOtherData())
    elseif _command :getType() == CCharacterSellCancleCommand.TYPE then
        print( "取消出售物品：", _command :getData())
        local _index = _command :getData()
        self :getView() :setCancleSell( _index)
    elseif  _command :getData() == CMoneyChangedCommand.MONEY then
        self :getView() :setVipView()
    end
    return false
end


-----------------------------------------------------------------------
--人物面板 批量出售部分mediator
-----------------------------------------------------------------------
CCharacterSellMediator = class(mediator, function(self, _view)
    self.name = "CCharacterSellMediator"
    self.view = _view
    print("Mediator:",self.name)
end)

function CCharacterSellMediator.getView(self)
    return self.view
end
function CCharacterSellMediator.getName(self)
    return self.name
end

function CCharacterSellMediator.processCommand(self, _command)
    --接收服务器下发消息 接收ACK
    if _command :getType() == CNetworkCommand.TYPE then
        --print("CBackpackMediator.processCommand\nACK.ACK.ACK.ACK.ACK.ACK:",_command :getProtocolID())
        local msgID = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()
    end
    --接收缓存Proxyupdata的更新command
    if _command:getType() == CCharacterSellCommand.TYPE then
        print("Command.TYPE:",CCharacterSellCommand.TYPE)
        self :getView() :setLocalList( _command :getData(),_command :getOtherData())
    end
    return false
end


-----------------------------------------------------------------------
--人物面板 出售背包部分mediator
-----------------------------------------------------------------------
CCharacterSellBackpackMediator = class(mediator, function(self, _view)
    self.name = "CCharacterSellBackpackMediator"
    self.view = _view
    print("Mediator:",self.name)
end)

function CCharacterSellBackpackMediator.getView(self)
    return self.view
end
function CCharacterSellBackpackMediator.getName(self)
    return self.name
end

function CCharacterSellBackpackMediator.processCommand(self, _command)
    --接收服务器下发消息 接收ACK
    if _command :getType() == CNetworkCommand.TYPE then
        --print("CBackpackMediator.processCommand\nACK.ACK.ACK.ACK.ACK.ACK:",_command :getProtocolID())
        local msgID = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()
    end
    --接收缓存Proxyupdata的更新command
    if _command:getType() == CProxyUpdataCommand.TYPE then
        print("CProxyUpdataCommand.TYPE",CProxyUpdataCommand.TYPE)
        self :getView() :setLocalList()
    elseif _command :getType() == CCharacterSellCancleCommand.TYPE then
        print( "取消出售物品：", _command :getData())
        local _index = _command :getData()
        self :getView() :setCancleSell( _index)
    end
    return false
end