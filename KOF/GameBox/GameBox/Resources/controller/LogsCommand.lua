require "controller/command"
-- 
CLogsCommand = class( command, function( self, VO_data )
                     self.type = "TYPE_CLogsCommand"
                     self.data = VO_data
                     
end)

CLogsCommand.TYPE = "TYPE_CLogsCommand"

--跑马灯消息命令
CMarqueeCommand = class( command, function( self, VO_data )
                     self.type = "TYPE_CMarqueeCommand"
                     self.data = VO_data
                     
end)

CMarqueeCommand.TYPE = "TYPE_CMarqueeCommand"