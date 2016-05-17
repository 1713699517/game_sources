
require "common/AcknowledgementMessage"

-- (手动) -- [54810]玩家信息块 -- 格斗之王 

ACK_WRESTLE_PLAYER = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WRESTLE_PLAYER
	self:init()
end)

function ACK_WRESTLE_PLAYER.deserialize(self, reader)
	self.uid        = reader:readInt32Unsigned() -- {玩家的uid}
	self.name       = reader:readString()        -- {玩家姓名}
	self.name_color = reader:readInt8Unsigned()  -- {玩家名字颜色}
	self.lv         = reader:readInt16Unsigned() -- {玩家等级}
	self.powerful   = reader:readInt32Unsigned() -- {玩家战斗力}
	self.score      = reader:readInt32Unsigned() -- {玩家积分}
	self.now_count  = reader:readInt16Unsigned() -- {当前的次数}
	self.all_count  = reader:readInt16Unsigned() -- {当前总次数}
	self.uname      = reader:readString()        -- {下一个对手名字}
	self.success    = reader:readInt16Unsigned() -- {胜场次}
	self.fail       = reader:readInt16Unsigned() -- {输场次}
    print("0--------------->>>>>444555",self.uid,self.name,self.name_color,self.lv,self.powerful,self.score,self.now_count,self.all_count,self.uname,self.success,self.fail)
    
end

-- {玩家的uid}
function ACK_WRESTLE_PLAYER.getUid(self)
	return self.uid
end

-- {玩家姓名}
function ACK_WRESTLE_PLAYER.getName(self)
	return self.name
end

-- {玩家名字颜色}
function ACK_WRESTLE_PLAYER.getNameColor(self)
	return self.name_color
end

-- {玩家等级}
function ACK_WRESTLE_PLAYER.getLv(self)
	return self.lv
end

-- {玩家战斗力}
function ACK_WRESTLE_PLAYER.getPowerful(self)
	return self.powerful
end

-- {玩家积分}
function ACK_WRESTLE_PLAYER.getScore(self)
	return self.score
end

-- {当前的次数}
function ACK_WRESTLE_PLAYER.getNowCount(self)
	return self.now_count
end

-- {当前总次数}
function ACK_WRESTLE_PLAYER.getAllCount(self)
	return self.all_count
end

-- {下一个对手名字}
function ACK_WRESTLE_PLAYER.getUname(self)
	return self.uname
end

-- {胜场次}
function ACK_WRESTLE_PLAYER.getSuccess(self)
	return self.success
end

-- {输场次}
function ACK_WRESTLE_PLAYER.getFail(self)
	return self.fail
end
