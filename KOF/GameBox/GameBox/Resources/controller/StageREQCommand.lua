require "controller/command"

--发送REQ请求...REQ是协议的_G.Protocol["REQ"]
CStageREQCommand = class(command, function( self, REQ )
    self.type = "TYPE_CStageREQCommand"
    self.data = REQ
end)

CStageREQCommand.TYPE = "TYPE_CStageREQCommand"

function CStageREQCommand.setOtherData( self, _data )
    self.otherData = _data
end

function CStageREQCommand.getOtherData( self )
    return self.otherData
end