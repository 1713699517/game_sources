require "controller/command"

--更新npc图标
CNpcUpdateCommand = class( command, function( self, VO_data )
    self.type = "TYPE_CNpcUpdateCommand"
    self.data = VO_data

end)

CNpcUpdateCommand.TYPE      = "TYPE_CNpcUpdateCommand"
CNpcUpdateCommand.UPDATE    = "UPDATE_CNpcUpdateCommand"
