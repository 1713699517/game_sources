require "mediator/mediator"
require "controller/command"

require "common/MessageProtocol"
require "controller/MoneyCommand"
require "controller/VipViewCommand"
require "common/protocol/auto/ACK_ROLE_OK_ASK_BUYE"

CVipMediator = class( mediator, function( self, _view )
	self.m_name = "CVipMediator"
	self.m_view = _view

	print("CVipMediator注册", self.m_name, " 的view为 ", self.m_view)
end)


function CVipMediator.getView( self )
	-- body
	return self.m_view
end


function CVipMediator.getName( self )
	return self.m_name
end


function CVipMediator.processCommand( self, _command )

	if _command :getType() == CNetworkCommand.TYPE then
		local msgID     = _command :getProtocolID()
        local ackMsg    = _command :getAckMessage()

        if msgID == _G.Protocol["ACK_ROLE_PROPERTY_UPDATE"] then
            self :ACK_ROLE_PROPERTY_UPDATE( ackMsg)
        elseif msgID == _G.Protocol["ACK_ROLE_ENERGY_OK"] then -- [1261]请求体力值成功 -- 角色
        	self : ACK_ROLE_ENERGY_OK( ackMsg )

        elseif msgID == _G.Protocol["ACK_ROLE_OK_ASK_BUYE"] then -- (手动) -- [1264]请求购买面板成功 -- 角色
            self : ACK_ROLE_OK_ASK_BUYE( ackMsg)

        elseif msgID == _G.Protocol["ACK_ROLE_OK_BUY_ENERGY"] then
            self : ACK_ROLE_OK_BUY_ENERGY( ackMsg)
        end
	end

    if _command :getType() == CMoneyChangedCommand.TYPE then
        CCLOG("--->vipMediator--->接收".._command :getData())
        local curScenesType = _G.g_Stage :getScenesType()
        if curScenesType == _G.Constant.CONST_MAP_TYPE_CITY then
            if _command :getData() == CMoneyChangedCommand.ENERGY then
                self :getView() :setEnergyView()

            elseif  _command :getData() == CMoneyChangedCommand.MONEY then
                self :getView() :setVipView( nil )
            end
        end
    end

    --点击其它处  判断是否关闭
    if _command :getType() == CVipViewCommand.TYPE then
        if _command :getData() == CVipViewCommand.CLOSETIPS then
            self :getView() :closeTipsView()
        elseif _command :getData() == CVipViewCommand.UPDATEPOWERFUL then
            self :getView() :setPowerfulView()
        elseif _command :getData() == CVipViewCommand.UPDATEEXP then
            self :getView() :setExpLine()
        end
    end
    return false
	--判断需要处理的type self:getView()
end


function CVipMediator.ACK_ROLE_PROPERTY_UPDATE( self, _ackMsg)
    if _ackMsg then
        if _ackMsg :getType() == _G.Constant.CONST_ATTR_LV then
            print("人物等级改变", _ackMsg :getType(), _ackMsg :getId(), _ackMsg:getValue())
            local curScenesType = _G.g_Stage :getScenesType()
            if curScenesType== _G.Constant.CONST_MAP_TYPE_CITY and _ackMsg :getId() == 0 then
                self :getView() :setLvView( _ackMsg:getValue())
                _G.StageXMLManager : addTransport( _G.g_Stage :getScenesID() )
            end
        end
    end
end

function CVipMediator.ACK_ROLE_ENERGY_OK( self, _ackMsg)
    if _ackMsg then
        print("当前体力值", _ackMsg :getSum(), _ackMsg:getMax())

        local _data = {}
        _data.sum = _ackMsg :getSum()
        _data.max = _ackMsg:getMax()

        local mainProperty  = _G.g_characterProperty : getMainPlay()
        if mainProperty == nil then
            print( "CVipMediator.ACK_ROLE_ENERGY_OK mainProperty==", mainProperty )

        else
            mainProperty :setSum( _ackMsg :getSum() )
            mainProperty :setMax( _ackMsg :getMax() )
        end

        local curScenesType = _G.g_Stage :getScenesType()
        if curScenesType == _G.Constant.CONST_MAP_TYPE_CITY then
            self :getView() :setVipView( _data )
        end
    end

end

function CVipMediator.ACK_ROLE_OK_BUY_ENERGY( self, _ackMsg)
    if _ackMsg ~= nil then
        --CCMessageBox("购买体力成功", "")
        local msg = "购买体力成功"
        self :getView() :createMessageBox( msg)
    end
end

function CVipMediator.ACK_ROLE_OK_ASK_BUYE( self, _ackMsg)
    local _type     = _ackMsg : getType()           -- {购买精力类型-[见常量CONST_ENERGY_购买精力类型]}
    local _num      = _ackMsg : getNum()            -- {第几次购买}
    local _sumnum   = _ackMsg : getSumnum()         -- {可购买总次数}
    local _rmb      = _ackMsg : getRmb()            -- {购买需花费的元宝数}

    print("CVipMediator.ACK_ROLE_OK_ASK_BUYE", _type, "{第几次购买}".._num, "{可购买总次数}".._sumnum, _rmb)

    local _vo_data = {}
    _vo_data.type  = _type
    _vo_data.num   = _num
    _vo_data.sumnum= _sumnum
    _vo_data.rmb   = _rmb

    if  _vo_data.type  ~= nil and _vo_data.type == _G.Constant.CONST_ENERGY_REQUEST_TYPE then
        self :getView() :setBuyEnergyView( _vo_data)

    elseif _vo_data.type  ~= nil and _vo_data.type == _G.Constant.CONST_ENERGY_RETRUN_TYPE then
        --CCMessageBox("你没精力了", "请充值vip")
        local msg = " 你没精力了,请充值vip"
        self :getView() :createMessageBox( msg)
    end
end




