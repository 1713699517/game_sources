
require "common/AcknowledgementMessage"

-- [33025]返加社团日志数据3 -- 社团 

ACK_CLAN_CLAN_LOGS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_CLAN_LOGS
	self:init()
end)

function ACK_CLAN_CLAN_LOGS.deserialize(self, reader)
	self.count = reader:readInt16Unsigned() -- {社团日志数量}
    print( "a#########:",self.count)
	--self.logs_data = reader:readXXXGroup() -- {社团日志数据块【33026】}
    local icount = 1
    self.logs_data = {}
    while icount <= self.count do
        self.logs_data[icount] = {}
        self.logs_data[icount].type   = reader:readInt8Unsigned() -- {日志类型| CONST_CLAN_EVENT_XX}
        self.logs_data[icount].time   = reader:readInt32Unsigned() -- {时间戳(s)}
        print( icount.."@#########:",self.logs_data[icount].type,self.logs_data[icount].time)
        self.logs_data[icount].count1 = reader:readInt16Unsigned() -- {string数量}
        print( "b#########:",self.logs_data[icount].count1)
        --self.string_msg = reader:readXXXGroup() -- {string数据块【33027】}
        local icount1 = 1
        self.logs_data[icount].string_msg = {}
        while icount1 <= self.logs_data[icount].count1 do
            self.logs_data[icount].string_msg[icount1] = {}
            self.logs_data[icount].string_msg[icount1].name       = reader:readString() -- {名字}
            self.logs_data[icount].string_msg[icount1].name_color = reader:readInt8Unsigned() -- {名字颜色}
            print( "STRING#########:",self.logs_data[icount].string_msg[icount1].name,self.logs_data[icount].string_msg[icount1].name_color)
            icount1 = icount1 + 1
        end
        self.logs_data[icount].count2 = reader:readInt16Unsigned() -- {int数量}
        --self.int_msg = reader:readXXXGroup() -- {int数据块【33028】}
        print( "b#########:",self.logs_data[icount].count2)
        local icount2 = 1
        self.logs_data[icount].int_msg = {}
        while icount2 <= self.logs_data[icount].count2 do
            self.logs_data[icount].int_msg[icount2] = {}
            self.logs_data[icount].int_msg[icount2].value  = reader:readInt32Unsigned() -- {数值}
            print( "d#########:",self.logs_data[icount].int_msg[icount2].value)
            icount2 = icount2 + 1
        end
        icount = icount + 1
    end
end

-- {社团日志数量}
function ACK_CLAN_CLAN_LOGS.getCount(self)
	return self.count
end

-- {社团日志数据块【33027】}
function ACK_CLAN_CLAN_LOGS.getLogsData(self)
	return self.logs_data
end
