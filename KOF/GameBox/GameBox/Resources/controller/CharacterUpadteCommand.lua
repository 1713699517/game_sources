require "controller/command"

-----------------------------------------------------------------------
--通过属性缓存数据改变发送此命令通知主界面人物部分帮派名改变的UI
-----------------------------------------------------------------------
CClanIdOrNameUpdateCommand = class(command, function( self, REQ )
self.type = "TYPE_CClanIdOrNameUpdateCommand"
self.data = REQ
print("Command name:",self.type)
end)

CClanIdOrNameUpdateCommand.TYPE = "TYPE_CClanIdOrNameUpdateCommand"

-----------------------------------------------------------------------
--通过属性缓存数据改变发送此命令通知人物面板属性部分改变的UI
-----------------------------------------------------------------------
CCharacterInfoUpdataCommand = class(command, function( self, REQ )
self.type = "TYPE_CCharacterInfoUpdataCommand"
self.data = REQ
print("Command name:",self.type)
end)

CCharacterInfoUpdataCommand.TYPE = "TYPE_CCharacterInfoUpdataCommand"

-----------------------------------------------------------------------
--通过背包缓存数据改变发送此命令通知人物面板装备部分改变的UI
-----------------------------------------------------------------------
CCharacterEquipInfoUpdataCommand = class(command, function( self, REQ )
self.type = "TYPE_CCharacterEquipInfoUpdataCommand"
self.data = REQ
print("Command name:",self.type)
end)

CCharacterEquipInfoUpdataCommand.TYPE = "TYPE_CCharacterEquipInfoUpdataCommand"

-----------------------------------------------------------------------
--通过背包缓存数据改变发送此命令通知人物面板道具和神器部分改变的UI
-----------------------------------------------------------------------
CCharacterPropsUpdataCommand = class(command, function( self, REQ )
self.type = "TYPE_CCharacterPropsUpdataCommand"
self.data = REQ
print("Command name:",self.type)
end)

CCharacterPropsUpdataCommand.TYPE = "TYPE_CCharacterPropsUpdataCommand"


-----------------------------------------------------------------------
--通过人物界面人物的切换更新属性面板数据
-----------------------------------------------------------------------
CCharacterCutoverCommand = class(command, function( self, REQ)
self.type = "TYPE_CCharacterCutoverCommand"
self.data = REQ
print("Command name:",self.type)
end)

CCharacterCutoverCommand.TYPE = "TYPE_CCharacterCutoverCommand"

-----------------------------------------------------------------------
--通过人物界面伙伴状态更新属性面板Button状态数据
-----------------------------------------------------------------------
CCharacterButtonStataCommand = class(command, function( self, REQ)
self.type = "TYPE_CCharacterButtonStataCommand"
self.data = REQ
print("Command name:",self.type)
end)

CCharacterButtonStataCommand.TYPE = "TYPE_CCharacterButtonStataCommand"


-----------------------------------------------------------------------
--酒吧内归队，招募成功后更新人物界面下头像列表
-----------------------------------------------------------------------
CCharacterRoleIconCommand = class(command, function( self, REQ)
self.type = "TYPE_CCharacterRoleIconCommand"
self.data = REQ
print("Command name:",self.type)
end)

CCharacterRoleIconCommand.TYPE = "TYPE_CCharacterRoleIconCommand"

-----------------------------------------------------------------------
--人物背包点击物品后通知出售界面更新
-----------------------------------------------------------------------
CCharacterSellCommand = class(command, function( self, REQ, count)
self.type = "TYPE_CCharacterSellCommand"
self.data = REQ
self.otherdata = count
print("Command name:",self.type)
end)

CCharacterSellCommand.TYPE = "TYPE_CCharacterSellCommand"

function CCharacterSellCommand.getOtherData( self)
	return self.otherdata
end

function CCharacterSellCommand.setOtherData( self, _data)
	self.otherdata = _data
end
-----------------------------------------------------------------------
--人物背包出售界面点击物品取消出售通知背包界面更新
-----------------------------------------------------------------------
CCharacterSellCancleCommand = class(command, function( self, REQ)
self.type = "TYPE_CCharacterSellCancleCommand"
self.data = REQ
print("Command name:",self.type)
end)

CCharacterSellCancleCommand.TYPE = "TYPE_CCharacterSellCancleCommand"



