require "controller/command"

CVipViewCommand = class( command, function( self, vo_data)
    self.type = "TYPE_CVipViewCommand"
    self.data = vo_data
end)

CVipViewCommand.TYPE = "TYPE_CVipViewCommand"
CVipViewCommand.CLOSETIPS = "CLOSETIPS_CVipViewCommand"
CVipViewCommand.UPDATEPOWERFUL = "UPDATEPOWERFUL_CVipViewCommand"
CVipViewCommand.UPDATEEXP  = "UPDATEEXP_CVipViewCommand"

