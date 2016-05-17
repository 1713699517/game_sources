require "mediator/mediator"
require "controller/command"

require "common/MessageProtocol"
require "controller/DailyTaskCommand"
CDailyTaskMediator = class( mediator, function( self, _view )
  self.m_name = "CDailyTaskMediator"
  self.m_view = _view
  
  print("CDailyTaskMediator注册", self.m_name, " 的view为 ", self.m_view)
end)

function CDailyTaskMediator.getView( self )
	-- body
	return self.m_view
end

function CDailyTaskMediator.getName( self )
	return self.m_name
end

function CDailyTaskMediator.processCommand( self, _command )
    
	if _command :getType() == CNetworkCommand.TYPE then
		local msgID     = _command :getProtocolID()
        local ackMsg    = _command :getAckMessage()
        
        --if msgID == _G.Protocol["ACK_DAILY_TASK_DATA"] then
            --self :ACK_DAILY_TASK_DATA( ackMsg)
        --end
    
	end
        
    if _command :getType() == CDailyUpdateCommand.TYPE then
        if _command :getData() == CDailyUpdateCommand.UPDATE then
            local _dailyInfo = _G.pCDailyTaskProxy :getDailyTaskData(  )
            self :getView() :setUpdate( _dailyInfo )
        end
        
        if _command :getData() == CDailyUpdateCommand.TURN then
            local _dailyInfo = _G.pCDailyTaskProxy :getDailyTaskData(  )
            self :getView() :setUpdate( _dailyInfo )
        end
    end
    
    return false
end

function CDailyTaskMediator.ACK_DAILY_TASK_DATA( self, _ackMsg)
    print("日常任务系统", _ackMsg)
    
    if _ackMsg then
        local _dailyInfo = {}
        
        _dailyInfo.node     = _ackMsg :getNode()
        _dailyInfo.left     = _ackMsg :getLeft()
        _dailyInfo.value    = _ackMsg :getValue()
        _dailyInfo.state    = _ackMsg :getState()
        _dailyInfo.count    = _ackMsg :getCount()
        print("日常任务界面数据＝＝", _dailyInfo.node, _dailyInfo.left, _dailyInfo.value, _dailyInfo.state, _dailyInfo.count)
      
        --显示ccbi

        local command = CDailyUpdateCommand( CDailyUpdateCommand.SHINNING )
        controller :sendCommand( command )
        
        _G.pCDailyTaskProxy :setInited( true )
        _G.pCDailyTaskProxy :setDailyTaskData( _dailyInfo )
        self :getView() :setUpdate( _dailyInfo)

        
    end
end
