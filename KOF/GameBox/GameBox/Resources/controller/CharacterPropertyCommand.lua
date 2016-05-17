require "controller/command"

--发送REQ请求...REQ是协议的_G.Protocol["REQ"]
CCharacterPropertyCommand = class(command, function( self, REQ )
    self.type = "TYPE_CCharacterPropertyCommand"
    self.data = REQ
end)

CCharacterPropertyCommand.TYPE = "TYPE_CCharacterPropertyCommand"

function CCharacterPropertyCommand.setOtherData( self, _data )
    self.otherData = _data
end

function CCharacterPropertyCommand.getOtherData( self )
    return self.otherData
end