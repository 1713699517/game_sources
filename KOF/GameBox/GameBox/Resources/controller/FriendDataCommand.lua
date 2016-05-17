
require "controller/command"

CFriendDataCommand = class( command, function( self, VO_data )
	self.type = "TYPE_CFriendDataCommand"
	self.data = VO_data

end)
CFriendDataCommand.TYPE = "TYPE_CFriendDataCommand"




CFriendUpdataCommand = class( command, function( self, VO_data )
	self.type = "TYPE_CFriendUpdataCommand"
	self.data = VO_data
end)

CFriendUpdataCommand.TYPE = "TYPE_CFriendUpdataCommand"		--
CFriendUpdataCommand.TYPE_RECENTLY  = "RECENTLY_CFriendUpdataCommand"
CFriendUpdataCommand.TYPE_FRIEND    = "FRIEND_CFriendUpdataCommand"

--打开聊天界面
CFriendOpenChatCommand = class( command, function( self, VO_data)
    self.type = "TYPE_CFriendOpenChatCommand"
    self.data = VO_data
end)
CFriendOpenChatCommand.TYPE = "TYPE_CFriendOpenChatCommand"


--打开聊天界面
CShowGoodOpenChatCommand = class( command, function( self, VO_data)
    self.type = "TYPE_CShowGoodOpenChatCommand"
    self.data = VO_data
end)
CShowGoodOpenChatCommand.TYPE = "TYPE_CShowGoodOpenChatCommand"



CFriendRecommendCommand = class( command, function( self, VO_data)
    self.type = "TYPE_CFriendRecommendCommand"
    self.data = VO_data
end)
CFriendRecommendCommand.TYPE = "TYPE_CFriendRecommendCommand"
