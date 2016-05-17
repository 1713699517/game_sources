require "controller/command"

CDailyTaskCommand = class( command, function(self, vo_data)
	self.type = "TYPE_CDailyTaskCommand"
	self.data = vo_data
end)

CDailyTaskCommand.TYPE = "TYPE_CDailyTaskCommand"
CDailyTaskCommand.OPEN = "OPEN_CDailyTaskCommand"

------
CDailyUpdateCommand = class( command, function(self, vo_data)
    self.type = "TYPE_CDailyUpdateCommand"
    self.data = vo_data
end)

CDailyUpdateCommand.TYPE = "TYPE_CDailyUpdateCommand"
CDailyUpdateCommand.UPDATE   = "UPDATE_CDailyUpdateCommand"     --更新活动按钮上的小数字
CDailyUpdateCommand.SHINNING = "SHINNING_CDailyUpdateCommand"   --ccbi高亮
CDailyUpdateCommand.TURN     = "TURN_CDailyUpdateCommand"


