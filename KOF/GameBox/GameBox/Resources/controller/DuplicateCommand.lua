require "controller/command"

CDuplicateCommand = class(command, function(self, VO_data_model)
    self.type = "TYPE_CDuplicateCommand"     --getType
    self.data = VO_data_model               --getData
end)

CDuplicateCommand.TYPE = "TYPE_CDuplicateCommand"


function CDuplicateCommand.getModel(self)
    return self.data
end

--[[
function CBackpackCommand.setOtherData( self, _data )
    self.otherData = _data
end

function CBackpackCommand.getOtherData( self )
    return self.otherData
end
]]

