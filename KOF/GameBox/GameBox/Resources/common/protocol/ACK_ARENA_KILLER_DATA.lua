
require "common/AcknowledgementMessage"

-- [23930]返回高手信息 -- 封神台 

ACK_ARENA_KILLER_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ARENA_KILLER_DATA
	self:init()
end)

function ACK_ARENA_KILLER_DATA.deserialize(self, reader)
    print( "##########################\n高手信息 -- 封神台 返回")
	self.count            = reader:readInt16Unsigned()  -- {数量}    
    print("玩家个数:",self.count)    
	--self.AAA = reader:readXXXGroup()
    self.AAA = {}   -- {[23931]高手信息 -- 封神台  ACK_ARENA_ACE}
    local icount = 1
    while icount <= self.count do
        self.AAA[icount] = {}
        self.AAA[icount].ranking   = reader:readInt16Unsigned() -- {玩家排名}        
        self.AAA[icount].uid       = reader:readInt32Unsigned() -- {玩家UID}
        self.AAA[icount].name      = reader:readUTF()           -- {玩家名字}        
        self.AAA[icount].lv        = reader:readInt16Unsigned() -- {玩家等级}
        self.AAA[icount].clan_name = reader:readString()           --家族名字
        print( "玩家名字：",self.AAA[icount].name, "玩家等级：",self.AAA[icount].lv,"玩家排名",self.AAA[icount].ranking,"家族名字",self.AAA[icount].clan_name)
        icount = icount +1
    end --while
end

-- {数量}
function ACK_ARENA_KILLER_DATA.getCount(self)
	return self.count
end

-- {23931}
function ACK_ARENA_KILLER_DATA.getAAA(self)
	return self.AAA
end
