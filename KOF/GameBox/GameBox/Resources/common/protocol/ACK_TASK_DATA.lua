
require "common/AcknowledgementMessage"

-- [3220]返回任务数据 -- 任务 

ACK_TASK_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TASK_DATA
    print("[3220]返回任务数据 -- 任务", self.MsgID)
	self:init()
end)

--对话 副本
function ACK_TASK_DATA.deserialize(self, reader)
    
    self.count       = reader :readInt16Unsigned()    --任务数量(要弃用)
    
    self.id          = reader :readInt32Unsigned()    --任务id
    self.state       = reader :readInt8Unsigned()     --任务状态 2:可接受 3:进行中 4:已完成
    self.target_type = reader :readInt8Unsigned()     --任务目标类型1:对话 2:收集怪物3:击杀怪物 4:击杀玩家 5:问答 6:其它7:副本
    
    print("[3220]任务id->", self.id, " 任务状态->", self.state, " 任务目标类型->", self.target_type)
    
    if self.target_type == 1 then                     --对话任务
        CCLOG("1:完成对话任务解析")
        
    elseif self.target_type == 2 then
        CCLOG("2:收集怪物")
        
    elseif self.target_type == 3 then                 --击杀怪物
        CCLOG("3:击杀怪物")
        self.monster_count = reader :readInt16Unsigned()        --击杀怪物种数
        if self.monster_count ~= nil and self.monster_count > 0 then
            self.monster_detail = {}                  --3223
            
            for i=1, self.monster_count do
                self.monster_detail.monster_id   = reader :readInt16Unsigned()          --怪物ID
                self.monster_detail.monster_nums = reader :readInt8Unsigned()           --怪物数量
                self.monster_detail.monster_max  = reader :readInt8Unsigned()           --达成所需数量
            end
        end
    elseif self.target_type == 4 then
        CCLOG("4:击杀玩家")
        
    elseif self.target_type == 5 then
        CCLOG("5:问答")
        
    elseif self.target_type == 6 then                 --其他任务
        CCLOG("6:其他任务")
        
    elseif self.target_type == 7 then                 --副本任务
        CCLOG("7;副本任务")
        self.copy    = reader :readInt16Unsigned()
        self.current = reader :readInt16Unsigned()
        self.max     = reader :readInt16Unsigned()
        
        print( "副本id=", self.copy, "当前次数=", self.current, "最大次数=", self.max)
    end

    
    
    ------------------------------------------------------------------------------
    --[[
    print("\n========[3220]返回任务数据 begin========")
    self.count    = reader:readInt16Unsigned()    --数量
    
    print("任务数量" , self.count)
    
    self.m_taskDataList = {}
    
    for m = 1, self.count do
        
        self.m_taskDataList[m] = {}
        
        self.id             = reader:readInt32Unsigned()        --任务id   
        self.state          = reader:readInt8Unsigned()         --1-5
        self.target_type    = reader:readInt8Unsigned()         --1-7
        
        --格式化
        self.m_taskDataList[m].id           = self.id
        self.m_taskDataList[m].state        = self.state
        self.m_taskDataList[m].target_type  = self.target_type
        
        print( "id=", self.id, "state=", self.state, "type=", self.target_type)
        
        if self.target_type == 1 then                   --对话任务
            print("完成对话任务解析")
            
        elseif self.target_type == 3 then               --击杀怪物
            --怪物数循环
            self.monster_count = reader:readInt16Unsigned();
            
            --怪物信息块 3223
            self.monster_detail = {}                    
            for i = 1 , self.monster_count do
                --格式化的怪物信息数据
                self.monster_detail[i] = {}
                
                --怪物id
                self.monster_detail[i].monster_id   = reader:readInt16Unsigned()
                --怪物数量
                self.monster_detail[i].monster_nums = reader:readInt8Unsigned()
                --达成所需数量
                self.monster_detail[i].monster_max  = reader:readInt8Unsigned()
                
            end
            print("完成击杀怪物解析")
            
        elseif self.target_type == 6 then               --其他任务
            print("其他任务")
            
        elseif self.target_type == 7 then               --副本任务
            print("副本任务")
            self.copy   = reader:readInt16Unsigned()
            self.current= reader:readInt16Unsigned()
            self.max    = reader:readInt16Unsigned()
            
            print( "副本id=", self.copy, "当前次数=", self.current, "最大次数=", self.max)
        end
        
    end    
     --]]
    print("========[3220]返回任务数据 end========")
    
end

-- {任务格式化数据}
function ACK_TASK_DATA.getTaskList(self)
    return self.m_taskDataList
end

-- {任务数量}
function ACK_TASK_DATA.getCount(self)
    return self.count
end

-- {任务id}
function ACK_TASK_DATA.getId(self)
	return self.id
end

-- {任务状态(可接,未完成,已完成)}
function ACK_TASK_DATA.getState(self)
	return self.state
end

-- {任务目标类型(对话则后面无数据)}
function ACK_TASK_DATA.getTargetType(self)
	return self.target_type
end

-- {副本ID}
function ACK_TASK_DATA.getCopy(self)
	return self.copy
end

-- {当前次数}
function ACK_TASK_DATA.getCurrent(self)
	return self.current
end

-- {最大次数}
function ACK_TASK_DATA.getMax(self)
	return self.max
end

-- {怪物种数}
function ACK_TASK_DATA.getMonsterCount(self)
	return self.monster_count
end

-- {怪物信息}
function ACK_TASK_DATA.getMonsterDetail(self)
	return self.monster_detail
end

-- {其他类型ID}
function ACK_TASK_DATA.getOtherId(self)
	return self.other_id
end

-- {参数1}
function ACK_TASK_DATA.getValue1(self)
	return self.value1
end

-- {参数2}
function ACK_TASK_DATA.getValue2(self)
	return self.value2
end

-- {参数3}
function ACK_TASK_DATA.getValue3(self)
	return self.value3
end

-- {参数4}
function ACK_TASK_DATA.getValue4(self)
	return self.value4
end

-- {参数5}
function ACK_TASK_DATA.getValue5(self)
	return self.value5
end
