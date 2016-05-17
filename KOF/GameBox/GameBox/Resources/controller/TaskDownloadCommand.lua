require "controller/command"

CTaskDownloadCommand = class( command, function( self, vo_data )
    self.type = "TYPE_CTaskDownloadCommand"
    self.data = vo_data
end)

CTaskDownloadCommand.TYPE = "TYPE_CTaskDownloadCommand"