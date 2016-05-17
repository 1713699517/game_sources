require "controller/command"

-----------------------------------------------------------------------
--查看其他玩家属性界面打开命令
-----------------------------------------------------------------------
CCharacterPropertyACKCommand = class(command, function( self, REQ)
self.type = "TYPE_CCharacterPropertyACKCommand"
self.data = REQ
print("Command name:",self.type)
end)

CCharacterPropertyACKCommand.TYPE = "TYPE_CCharacterPropertyACKCommand"



