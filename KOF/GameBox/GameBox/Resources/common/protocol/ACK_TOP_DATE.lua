
require "common/AcknowledgementMessage"

-- [24820]排行榜信息 -- 排行榜 

ACK_TOP_DATE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TOP_DATE
	self:init()
end)

function ACK_TOP_DATE.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {排行类型(见常量?CONST_TOP_TYPE_)}
    self.self_rank = reader:readInt16Unsigned() --{自己的排名}
	self.count = reader:readInt16Unsigned() -- {数量}
    
    print("……………………………ACK_TOP_DATE.deserialize……………………………")
    print(self.type,self.self_rank,self.count)
	self.data = {} -- {信息块（24830）}
    
    local iCount = 1
    while iCount <= self.count do
        self.data[iCount] = {}
        self.data[iCount].rank       = reader:readInt16Unsigned()
        self.data[iCount].uid        = reader:readInt32Unsigned()
        self.data[iCount].name       = reader:readString()
        self.data[iCount].name_color = reader:readInt8Unsigned()
        self.data[iCount].clan_id    = reader:readInt16Unsigned()
        self.data[iCount].clan_name  = reader:readString()
        self.data[iCount].lv         = reader:readInt16Unsigned()
        self.data[iCount].power      = reader:readInt32Unsigned()
        
        print("  排名",self.data[iCount].rank,"	玩家UID",self.data[iCount].uid,"	玩家名字",self.data[iCount].name,"	名字颜色",self.data[iCount].name_color,"	家族ID",self.data[iCount].clan_id,"	家族名字",self.data[iCount].clan_name,"	玩家等级",self.data[iCount].lv,"  玩家战斗力",self.data[iCount].power)
        iCount = iCount + 1
    end
end

-- {排行类型(见常量?CONST_TOP_TYPE_)}
function ACK_TOP_DATE.getType(self)
	return self.type
end

-- {数量}
function ACK_TOP_DATE.getSelfRank(self)
	return self.self_rank
end

-- {数量}
function ACK_TOP_DATE.getCount(self)
	return self.count
end

-- {信息块（24830）}
function ACK_TOP_DATE.getData(self)
	return self.data
end
