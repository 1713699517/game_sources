
require "common/AcknowledgementMessage"

-- [33034]社团列表返回 -- 社团 

ACK_CLAN_OK_CLANLIST = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_OK_CLANLIST
	self:init()
end)

function ACK_CLAN_OK_CLANLIST.deserialize(self, reader)
	self.page      = reader:readInt16Unsigned() -- {当前页数}
	self.all_pages = reader:readInt16Unsigned() -- {总计页数}
	self.count     = reader:readInt16Unsigned() -- {数量}
    print( "ACK_CLAN_OK_CLANLIST:"..self.page..":"..self.all_pages..":"..self.count)
	--self.clandata_msg = reader:readXXXGroup() -- {社团数据信息块【33020】}
    local icount = 1
    self.clandata_msg = {}
    while icount <= self.count do
        self.clandata_msg[icount] = {}
        self.clandata_msg[icount].clan_id          = reader:readInt32Unsigned() -- {社团ID}
        print( icount.."#########",self.clandata_msg[icount].clan_id)
        self.clandata_msg[icount].clan_name        = reader:readString()        -- {社团名字}
        print( icount.."#########",self.clandata_msg[icount].clan_name)
        self.clandata_msg[icount].clan_lv          = reader:readInt8Unsigned()  -- {社团等级}
        print( icount.."#########",self.clandata_msg[icount].clan_lv)
        self.clandata_msg[icount].clan_rank        = reader:readInt16Unsigned() -- {社团排名}
        print( icount.."#########",self.clandata_msg[icount].clan_rank)
        self.clandata_msg[icount].clan_members     = reader:readInt16Unsigned() -- {社团当前成员数}
        self.clandata_msg[icount].clan_all_members = reader:readInt16Unsigned() -- {社团成员上限数}
        print( icount.."#########",self.clandata_msg[icount].clan_members.."/"..self.clandata_msg[icount].clan_all_members)
        icount = icount + 1
    end
end

-- {当前页数}
function ACK_CLAN_OK_CLANLIST.getPage(self)
	return self.page
end

-- {总计页数}
function ACK_CLAN_OK_CLANLIST.getAllPages(self)
	return self.all_pages
end

-- {数量}
function ACK_CLAN_OK_CLANLIST.getCount(self)
	return self.count
end

-- {社团数据信息块【33020】}
function ACK_CLAN_OK_CLANLIST.getClandataMsg(self)
	return self.clandata_msg
end
