require "controller/command"
--查询是否可充值
CPayCheckCommand = class( command,function( self, vo_data )
    self.type = "TYPE_CPayCheckCommand"
	self.data = vo_data
end)

CPayCheckCommand.TYPE = "TYPE_CPayCheckCommand"
CPayCheckCommand.ASK  = "ASK_CPayCheckCommand"