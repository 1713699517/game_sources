require "controller/command"

--发送REQ请求...REQ是协议的_G.Protocol["REQ"]
CGameDataProxyCommand = class(command, function( self, REQ )
    self.type = "TYPE_CGameDataProxyCommand"
    self.data = REQ
    print("Command name:",self.type)
end)

CGameDataProxyCommand.TYPE = "TYPE_CGameDataProxyCommand"

function CGameDataProxyCommand.setOtherData( self, _data )
    self.otherData = _data
end

function CGameDataProxyCommand.getOtherData( self )
    return self.otherData
end

--缓存数据改变由此命令通知需要改变的UI
CProxyUpdataCommand = class(command, function( self, REQ )
self.type = "TYPE_CProxyUpdataCommand"
self.data = REQ
print("Command name:",self.type)
end)

CProxyUpdataCommand.TYPE = "TYPE_CProxyUpdataCommand"

function CProxyUpdataCommand.setOtherData( self, _data )
    self.otherData = _data
end

function CProxyUpdataCommand.getOtherData( self )
    return self.otherData
end