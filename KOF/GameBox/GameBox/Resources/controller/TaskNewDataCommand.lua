require "controller/command"

--发送request请求 ..._G.Protocol["msgID"]
CTaskNewDataCommand = class( command, function( self, VO_data )
	self.type 	= "TYPE_CTaskNewDataCommand"
	self.data 	= VO_data
                            print(self.type, "--->", self.data )
end)

function CTaskNewDataCommand.getData( self )
	return self.data
end

CTaskNewDataCommand.TYPE = "TYPE_CTaskNewDataCommand"


---------------------------------------
--缓存数据改变由此命令通知需要改变的UI
CTaskDataUpdataCommand = class( command, function( self, VO_data )
	self.type 	= "TYPE_CTaskDataUpdateCommand"
	self.data   = VO_data
end)

CTaskDataUpdataCommand.TYPE = "TYPE_CTaskDataUpdateCommand"
CTaskDataUpdataCommand.UPDATEGUIDER = "UPDATEGUIDER_CTaskDataUpdataCommand"
function CTaskDataUpdataCommand.getData( self )
	return self.data
end








