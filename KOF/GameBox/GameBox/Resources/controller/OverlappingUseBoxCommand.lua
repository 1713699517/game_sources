require "controller/command"

COverlappingUseCommand = class(command, function(self, VO_data_model, showType)
    self.type = "TYPE_COverlappingUseCommand"     --getType
    self.data = VO_data_model                     --getData
    self.otherData = showType
end)

COverlappingUseCommand.TYPE = "TYPE_COverlappingUseCommand"


function COverlappingUseCommand.getModel(self)
    return self.data
end

----[[
function COverlappingUseCommand.setOtherData( self, _data )
    self.otherData = _data
end

function COverlappingUseCommand.getOtherData( self )
    return self.otherData
end
--]]

