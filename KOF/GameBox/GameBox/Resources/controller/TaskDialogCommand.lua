require "controller/command"

CTaskDialogCommand = class( command, function(self, vo_data)
	self.type = "TYPE_CTaskDialogCommand"
	self.data = vo_data
end)

CTaskDialogCommand.TYPE = "TYPE_CTaskDialogCommand"


------更新界面
CTaskDialogUpdateCommand = class( command, function(self, vo_data)
    self.type = "TYPE_CTaskDialogUpdateCommand"
    self.data = vo_data
end)

CTaskDialogUpdateCommand.TYPE = "TYPE_CTaskDialogUpdateCommand"
CTaskDialogUpdateCommand.GOTO_SHOPPING  = "goto_shopping"           --去商城
CTaskDialogUpdateCommand.GOTO_HOUSE     = "goto_house"              --去客栈
CTaskDialogUpdateCommand.GOTO_TASK      = "goto_task"               --去任务

--require "contorller/TaskDialogCommand"