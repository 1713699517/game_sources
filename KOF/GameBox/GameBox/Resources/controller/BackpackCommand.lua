require "controller/command"



CBackpackCommand = class(command, function(self, VO_data_model)
    self.type = "TYPE_CBackpackCommand"     --getType
    self.data = VO_data_model               --getData
end)

CBackpackCommand.TYPE = "TYPE_CBackpackCommand"


function CBackpackCommand.getModel(self)
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

