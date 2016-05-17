require "controller/command"

CEmailCommand = class( command, function( self, VO_data )
	self.type = "TYPE_CEmailCommand"
	self.data = VO_data

end)

CEmailCommand.TYPE = "TYPE_CEmailCommand"




CEmailUpdataCommand = class( command, function( self, VO_data )
	self.type = "TYPE_CEmailUpdataCommand"
	self.data = VO_data
end)

CEmailUpdataCommand.TYPE 		= "TYPE_CEmailUpdataCommand"		--
CEmailUpdataCommand.OPEN 		= "OPEN_CEmailUpdataCommand"		--打开
CEmailUpdataCommand.ICON        = "ICON_CEmailUpdataCommand"        --邮箱图标
CEmailUpdataCommand.CLEAN       = "CLEAN_CEmailUpdataCommand"       --清楚 主界面图标


CEmailUpdataCommand.INBOX 		= "INBOX_CEmailUpdataCommand"		--收件箱
CEmailUpdataCommand.OUTBOX		= "OUTBOX_CEmailUpdataCommand"		--发件箱
CEmailUpdataCommand.WRITERBOX 	= "WRITEBOX_CEmailUpdataCommand"	--写信件
CEmailUpdataCommand.SAVEBOX		= "SAVEBOX_CEmailUpdataCommand"		--保存箱
CEmailUpdataCommand.CLOSE		= "CLOSE_CEmailUpdataCommand"		--关闭
CEmailUpdataCommand.RECEIVE     = "RECEIVE_CEmailUpdataCommand"     --领取邮件