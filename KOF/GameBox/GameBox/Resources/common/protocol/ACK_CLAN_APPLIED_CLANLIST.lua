
require "common/AcknowledgementMessage"

-- [ 33036]已申请社团列表 -- 社团 

ACK_CLAN_APPLIED_CLANLIST = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_APPLIED_CLANLIST
	self:init()
end)

function ACK_CLAN_APPLIED_CLANLIST.deserialize(self, reader)
    self.is    = reader:readInt8Unsigned()  -- {是否可创建帮派}
	self.count = reader:readInt16Unsigned() -- {数量}
    print( "已申请社团列表：", self.count)
	--self.clan_list = reader:readXXXGroup() -- {int数据块【33028】}
    local icount = 1
    self.clan_list = {}
    while icount <= self.count do
        self.clan_list[icount] = {}
        self.clan_list[icount].value       = reader:readInt32Unsigned() -- {数值}
        print( icount..">>>>>"..self.clan_list[icount].value)
        icount = icount + 1
    end
end

-- {数量}
function ACK_CLAN_APPLIED_CLANLIST.getIs(self)
	return self.is
end

-- {数量}
function ACK_CLAN_APPLIED_CLANLIST.getCount(self)
	return self.count
end

-- {int数据块【33028】}
function ACK_CLAN_APPLIED_CLANLIST.getClanList(self)
	return self.clan_list
end
