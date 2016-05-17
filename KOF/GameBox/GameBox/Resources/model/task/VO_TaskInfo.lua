VO_TaskInfo = class(function(self)
                    self.taskId = 1
                    self.state = 2 
                    self.type = 1;          --任务类型
                    self.taskName = "[主]任务标题";
                    self.taskDesc = "[任务描述]玉黄大帝与XXX交谈,希望你打开大道.";
                    self.starNpc = 9000
                    self.starNpcName = "开始npc名";
                    self.endNpc = 9001
                    self.endNpcName = "结束npc名";
                    self.moneyAward = 1000      --铜钱奖励
                    self.expAward = 1000;       --经验奖励
                    self.taskStatic = "去消灭怪物\n怪物(0/5)";
                    self.goodAward = {
                        {["name"] = "奖励物品1" , ["url"] = "taskDialog/t_icon1.jpg" },
                        {["name"] = "奖励物品2" , ["url"] = "taskDialog/t_icon2.jpg" },
                        {["name"] = "奖励物品3" , ["url"] = "taskDialog/t_icon3.jpg" }
                    };
                    self.task_s = "接任务npc对白"
                    self.task_sr = "接任务回复内容"
                    self.task_m = "任务进步中NPC对白"
                    self.task_mr = "任务进步中回复"
                    self.task_e = "提交任务NPC对白"
                    self.task_er_d = "提交任务回复内容"
                    self.task_er_id = "1"
end);

--任务id
function VO_TaskInfo.setTaskId( self, value)
    self.taskId = value
end
function VO_TaskInfo.getTaskId( self )
    return self.taskId
end

--任务状态
function VO_TaskInfo.setState(self , value)
    self.state = value
end;
function VO_TaskInfo.getState(self)
    return self.state
end;

--任务类型
function VO_TaskInfo.setType(self,value)
    self.type = value
end
function VO_TaskInfo.getType(self)
    return self.type
end

--任务标题
function VO_TaskInfo.setTaskName( self, value )
    self.taskName = value
end
function VO_TaskInfo.getTaskName( self )
    return self.taskName
end

--任务描述
function VO_TaskInfo.setTaskDesc( self, value )
    self.taskDesc = value
end
function VO_TaskInfo.getTaskDesc( self )
    return self.taskDesc
end

--开始npc
function VO_TaskInfo.setStarNpc( self, value )
    self.starNpc = value
end
function VO_TaskInfo.getStarNpc( self )
    return self.starNpc
end

--开始npc名称
function VO_TaskInfo.setStarNpcName( self, value )
    self.starNpcName = value
end
function VO_TaskInfo.getStarNpcName( self )
    return self.starNpcName
end

--结束npc
function VO_TaskInfo.setEndNpc( self, value )
    self.endNpc = value
end
function VO_TaskInfo.getEndNpc( self )
    return self.endNpc
end

--结束npc名称
function VO_TaskInfo.setEndNpcName( self, value )
    self.endNpcName = value
end
function VO_TaskInfo.getEndNpcName( self )
    return self.endNpcName
end

--铜钱奖励
function VO_TaskInfo.setMoneyAward( self, value )
    self.moneyAward = value
end
function VO_TaskInfo.getMoneyAward( self )
    return self.moneyAward
end

--经验奖励
function VO_TaskInfo.setExpAward( self, value )
    self.expAward = value
end
function VO_TaskInfo.getExpAward( self )
    return self.expAward
end

--任务进度描述
function VO_TaskInfo.setTaskStatic( self, value )
    self.taskStatic = value
end
function VO_TaskInfo.getTaskStatic( self )
    return self.taskStatic
end

--物品奖励列表 
function VO_TaskInfo.setGoodAward( self, value )
    self.goodAward = value
end
function VO_TaskInfo.getGoodAward( self )
    return self.goodAward
end





