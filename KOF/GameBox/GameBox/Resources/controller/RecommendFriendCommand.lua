--推荐好友
require "controller/command"

CRecommendDataCommand = class( command, function( self, VO_data )
   self.type = "TYPE_CRecommendDataCommand"
   self.data = VO_data
end)
CRecommendDataCommand.TYPE   = "TYPE_CRecommendDataCommand"
CRecommendDataCommand.OPEN   = "OPEN_CRecommendDataCommand"
CRecommendDataCommand.INVITE = "INVITE_CRecommendDataCommand"
---------------------------------------------------------------------

CRecommendUpdataCommand = class( command, function( self, VO_data )
    self.type = "TYPE_CRecommendUpdataCommand"
    self.data = VO_data
end)
CRecommendUpdataCommand.TYPE = "TYPE_CRecommendUpdataCommand"		





