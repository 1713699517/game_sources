require "mediator/mediator"
require "common/MessageProtocol"



CTopListPanelMediator = class(mediator, function(self, _view)
    self.name = "CTopListPanelMediator"
    self.view = _view
    print("Mediator:",self.name)
end)

function CTopListPanelMediator.getView(self)
    return self.view
end

function CTopListPanelMediator.getName(self)
    return self.name
end

function CTopListPanelMediator.processCommand(self, _command)
    --接收服务器下发消息 接收ACK
    if _command :getType() == CNetworkCommand.TYPE then
        local msgID = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()
        print("CCCCCCCCC", msgID)
        if msgID == _G.Protocol.ACK_TOP_DATE   then -- [23820]可以挑战的玩家列表(废除) -- 封神台 
            print("-- [23930]返回高手信息 -- 封神台 ")
            self :ACK_TOP_DATE( ackMsg)
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

-- [23930]返回高手信息 -- 封神台  
function CTopListPanelMediator.ACK_TOP_DATE( self, _ackMsg)
    local myRank          = _ackMsg :getSelfRank()  
    local rankType        = _ackMsg :getType()
    local count           = _ackMsg :getCount()
    local playerlist      = _ackMsg :getData()

    print("«««««««««««««««««««««««««««««««««««")

    for i,v in ipairs(playerlist) do
        print(i,v.rank,v.name)
    end
    print("«««««««««««««««««««««««««««««««««««")
    local function sortfunc( play1, play2)
        if play1.rank < play2.rank then
            return true
        end
        return false
    end

    for i,v in ipairs(playerlist) do
        print(i,v.rank,v.name)
    end
    print("«««««««««««««««««««««««««««««««««««")
    table.sort( playerlist, sortfunc)
    self :getView() :setLocalList( rankType, count, playerlist ,myRank )
end


