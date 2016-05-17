require "mediator/mediator"
require "common/MessageProtocol"

CBarMediator = class(mediator, function(self, _view)
    self.name = "CBarMediator"
    self.view = _view
    print("Mediator:",self.name)
end)

function CBarMediator.getView(self)
    return self.view
end

function CBarMediator.getName(self)
    return self.name
end

function CBarMediator.processCommand(self, _command)
    --接收服务器下发消息 接收ACK
    if _command :getType() == CNetworkCommand.TYPE then
        local msgID = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()
        if msgID == _G.Protocol.ACK_INN_LIST   then -- (手动) -- [31120]伙伴列表 -- 客栈 
            print("-- (手动) -- [31120]伙伴列表 -- 客栈")
            self :ACK_INN_LIST( ackMsg)
        elseif msgID == _G.Protocol.ACK_INN_RES_PARTNER then  -- (手动) -- [31270]离队/归队结果 -- 客栈  -- {1:归队成功0:离队成功}
            print( "-- (手动) -- [31270]离队/归队结果 -- 客栈 ")
            self :ACK_INN_RES_PARTNER( ackMsg)
        end
    end
    return false
end
-- 
-- (手动) -- [31120]伙伴列表 -- 客栈 
function CBarMediator.ACK_INN_LIST( self, _ackMsg)
    self :getView() :setPartnerStateList( _ackMsg :getRenown() ,_ackMsg :getCount(), _ackMsg :getData())
end
-- (手动) -- [31270]离队/归队结果 -- 客栈  -- {1:归队成功0:离队成功}
function CBarMediator.ACK_INN_RES_PARTNER( self, _ackMsg)
    -- body
    self :getView() :setPartnerStateChange( _ackMsg :getType(), _ackMsg :getPartnerId())
end