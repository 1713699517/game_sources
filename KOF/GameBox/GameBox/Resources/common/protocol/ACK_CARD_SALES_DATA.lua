
require "common/AcknowledgementMessage"

-- [24932]促销活动状态返回 -- 新手卡 

ACK_CARD_SALES_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CARD_SALES_DATA
	self:init()
    
end)

function ACK_CARD_SALES_DATA.deserialize(self, reader)
	print("24932-ACK_CARD_SALES_DATA ComeIn")
	self.count   = reader:readInt16Unsigned()
	self.id_date = {}
	print("count="..self.count)
	local icount = 1
	while icount <= self.count do 
		self.id_date[icount] = {}
		self.id_date[icount].id = reader:readInt16Unsigned()
		self.id_date[icount].start_time = reader:readInt32Unsigned()
		self.id_date[icount].exit_time  = reader:readInt32Unsigned()
		self.id_date[icount].count      = reader:readInt16Unsigned()
		self.id_date[icount].sub_date   = {}
		print("id="..self.id_date[icount].id,"exit_time="..self.id_date[icount].exit_time,"count="..self.id_date[icount].count)
		local jcount = 1
		while jcount <= self.id_date[icount].count do 
			self.id_date[icount].sub_date[jcount] = {}
			self.id_date[icount].sub_date[jcount].id_sub = reader:readInt16Unsigned()
			print("^id_sub="..self.id_date[icount].sub_date[jcount].id_sub)
            jcount = jcount + 1
		end
        icount = icount + 1
	end
end

-- {数量}
function ACK_CARD_SALES_DATA.getCount(self)
	return self.count
end

-- {信息块(24933)}
function ACK_CARD_SALES_DATA.getIdDate(self)
	return self.id_date
end
