
require "common/AcknowledgementMessage"

-- [23820]可以挑战的玩家列表(废除) -- 封神台 

ACK_ARENA_DEKARON = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ARENA_DEKARON
	self:init()
end)


function ACK_ARENA_DEKARON.deserialize(self, reader)
    print( "##########################\n逐鹿台协议返回")
	self.arena_lv     = reader:readInt16Unsigned()  -- {世界封神等级}
	self.time         = reader:readInt32Unsigned()   -- {冷却剩余时间}
    self.renown       = reader:readInt32Unsigned()  -- {声望}
	self.count        = reader:readInt16Unsigned()  -- {玩家个数}
    print( "世界封神等级:",self.arena_lv,"\n冷却剩余时间:",self.time,"\n我的声望:",self.renown,"\n玩家个数:",self.count)

	--self.challageplayerdata = reader:readXXXGroup()
    self.challageplayerdata = {}   -- {[23821]可以挑战的玩家 -- 逐鹿台  ACK_ARENA_CANBECHALLAGE }
    local icount = 1
    while icount <= self.count do
        self.challageplayerdata[icount] = {}
        self.challageplayerdata[icount].sid       = reader:readInt16Unsigned() -- {服务器ID}
        self.challageplayerdata[icount].pro       = reader:readInt8Unsigned() -- {玩家职业}
        self.challageplayerdata[icount].sex       = reader:readInt8Unsigned() -- {玩家性别}
        self.challageplayerdata[icount].lv        = reader:readInt16Unsigned() -- {玩家等级}
        self.challageplayerdata[icount].uid       = reader:readInt32Unsigned() -- {玩家UID}
        self.challageplayerdata[icount].name      = reader:readUTF() -- {玩家名字}
        self.challageplayerdata[icount].ranking   = reader:readInt16Unsigned() -- {玩家排名}
        self.challageplayerdata[icount].win_count = reader:readInt8Unsigned() -- {连胜次数}
        self.challageplayerdata[icount].surplus   = reader:readInt8Unsigned() -- {剩余挑战次数}
        self.challageplayerdata[icount].power   = reader:readInt32Unsigned() -- {战斗力}
        print( "玩家名字：",self.challageplayerdata[icount].name, "玩家等级：",self.challageplayerdata[icount].lv,"玩家排名",self.challageplayerdata[icount].ranking,"连胜次数",self.challageplayerdata[icount].win_count,"战斗力",self.challageplayerdata[icount].power)
        icount = icount +1
    end --while    
    
end

-- {世界封神等级}
function ACK_ARENA_DEKARON.getArenaLv(self)
	return self.arena_lv
end

-- {冷却剩余时间}
function ACK_ARENA_DEKARON.getTime(self)
    return self.time
end

function ACK_ARENA_DEKARON.getRenown(self)
    return self.renown
end

-- {玩家个数}
function ACK_ARENA_DEKARON.getCount(self)
	return self.count
end

-- {23821}
function ACK_ARENA_DEKARON.getChallageplayerdata(self)
	return self.challageplayerdata
end
