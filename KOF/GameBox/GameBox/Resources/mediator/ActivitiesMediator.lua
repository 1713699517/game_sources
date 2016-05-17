--------------------------
--精彩活动 Mediator
--------------------------
require "mediator/mediator"
require "common/MessageProtocol"

CActivitiesMediator = class(mediator, function(self, _view)
    self.name = "CActivitiesMediator"
    self.view = _view
    print("Mediator:",self.name)
end)

function CActivitiesMediator.getView(self)
    return self.view
end

function CActivitiesMediator.getName(self)
    return self.name
end

function CActivitiesMediator.processCommand(self, _command)
    --接收服务器下发消息 接收ACK
    if _command :getType() == CNetworkCommand.TYPE then
        local msgID = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()
        if msgID == _G.Protocol.ACK_CARD_SALES_DATA   then -- 24932     促销活动状态返回
            self :ACK_CARD_SALES_DATA( ackMsg)
        elseif msgID == _G.Protocol.ACK_CARD_GET_OK then  -- 24950   领取成功
            self :ACK_CARD_GET_OK( ackMsg)
            -- CCMessageBox("领取成功","提示")
            local msg = "领取成功"
            self : getView() : createMessageBox(msg)
        elseif msgID == _G.Protocol.ACK_CARD_SUCCEED then --24920    新手卡领取成功
            -- CCMessageBox("领取成功","提示")
            local msg = "领取成功"
            self : getView() : createMessageBox(msg)
        end
    end
    return false
end
-- 
-- 24932     促销活动状态返回
function CActivitiesMediator.ACK_CARD_SALES_DATA( self, _ackMsg)
    local data = _ackMsg : getIdDate()
    local list = {}

    for i,v in ipairs(data) do
        if v.id ~= _G.Constant.CONST_SALES_ID_PAY_ONCE then
            table.insert( list, v )
        end
    end

    

    self : getView() : loadMainView(list)
    -- self :getView() :setRewardView( _ackMsg :getVitality(), _ackMsg:getCount2(), _ackMsg :getRewards())
    -- self :getView() :setActivityListView( _ackMsg :getActiveData() )
end
-- 24950     领取成功
function CActivitiesMediator.ACK_CARD_GET_OK( self, _ackMsg)
    -- body
    self :getView() :geRewardCallBack( )
end