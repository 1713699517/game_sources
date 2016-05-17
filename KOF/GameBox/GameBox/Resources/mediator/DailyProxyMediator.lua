require "mediator/mediator"
require "controller/command"
require "controller/DailyTaskCommand"
require "common/MessageProtocol"
require "common/protocol/ACK_DAILY_TASK_DATA"

CDailyProxyMediator = class( mediator, function( self, _view )
  self.m_name = "CDailyProxyMediator"
  self.m_view = _view
  
  print("CDailyProxyMediator注册", self.m_name, " 的view为 ", self.m_view)
end)


function CDailyProxyMediator.getView( self )
	-- body
	return self.m_view
end


function CDailyProxyMediator.getName( self )
	return self.m_name
end


function CDailyProxyMediator.processCommand( self, _command )
    
	if _command :getType() == CNetworkCommand.TYPE then
		local msgID     = _command :getProtocolID()
        local ackMsg    = _command :getAckMessage()
        
        if msgID == _G.Protocol["ACK_DAILY_TASK_DATA"] then
            self :ACK_DAILY_TASK_DATA( ackMsg)
        elseif msgID == _G.Protocol["ACK_DAILY_TASK_TURN"] then
            print( " msgId->", msgID )
            self :ACK_DAILY_TASK_TURN( ackMsg )
        end
	end
    return false
end

function CDailyProxyMediator.ACK_DAILY_TASK_DATA( self, _ackMsg)
    print("CDailyProxyMediator.ACK_DAILY_TASK_DATA", _ackMsg)
    
    if _ackMsg then
        local _dailyInfo = {}
        
        _dailyInfo.node     = _ackMsg :getNode()            -- {当前所在节点位置}
        _dailyInfo.left     = _ackMsg :getLeft()           -- {今天剩余次数}
        _dailyInfo.value    = _ackMsg :getValue()           -- {当前进度}
        _dailyInfo.state    = _ackMsg :getState()           -- {任务状态}
        _dailyInfo.count    = _ackMsg :getCount() or 0          -- {可以刷新次数}
        
        self :getView() :setInited( true )
        self :getView() :setDailyTaskData( _dailyInfo )
        
        print( "日常任务信息＝＝", _dailyInfo.node, _dailyInfo.left, _dailyInfo.value, _dailyInfo.state, _dailyInfo.count )
        
        if tonumber( _dailyInfo.count ) >= 0 then
            local upCommand = CDailyUpdateCommand( CDailyUpdateCommand.UPDATE )
            controller :sendCommand( upCommand )
        end
        
        --显示ccbi
        local command = CDailyUpdateCommand( CDailyUpdateCommand.SHINNING )
        controller :sendCommand( command )
   
        
        --通知更新图标上的小数字
        --local upCommand = CDailyUpdateCommand( _dailyInfo)
        --controller :sendCommand( upCommand)
    end
end

function CDailyProxyMediator.ACK_DAILY_TASK_TURN( self, _ackMsg )
    print( "ACK_DAILY_TASK_TURN}", _ackMsg :getTurn() )
    self :getView() :setInited( true )
    self :getView() :setTurn( _ackMsg :getTurn() )
    
    local command = CDailyUpdateCommand( CDailyUpdateCommand.TURN )
    controller :sendCommand( command )
end

