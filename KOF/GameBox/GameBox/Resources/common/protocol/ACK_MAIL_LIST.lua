
require "common/AcknowledgementMessage"

-- [8512]请求列表成功 -- 邮件 

ACK_MAIL_LIST = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MAIL_LIST
    print("-- [8512]请求列表成功 -- 邮件", self.MsgID, Protocol.ACK_MAIL_LIST)
	self:init()
end)

function ACK_MAIL_LIST.deserialize(self, reader)
    
	self.boxtype = reader:readInt8Unsigned()    -- {邮箱类型(收件箱:0|发件箱:1|保存箱:2}
	self.count = reader:readInt16Unsigned()     -- {数量}
    
    CCLOG( "{邮箱类型(收件箱:0|发件箱:1|保存箱:2}==%d, {数量}==%d\n", self.boxtype, self.count)
    
    if self.count > 0 then
        self.models = {}                        -- {邮件模块[8513]}
        
        for i=1, self.count do
            self.models[i] = {}
            
            self.models[i].mail_id  = reader:readInt32Unsigned()    --邮件ID
            self.models[i].mtype    = reader:readInt8Unsigned()     --邮件类型(系统:0|私人:1)
            self.models[i].name     = reader:readString()           --名字
            self.models[i].title    = reader:readString()           --标题
            self.models[i].date     = reader:readInt32Unsigned()    --发送日期
            self.models[i].state    = reader:readInt8Unsigned()     --邮件状态(未读:0|已读:1)
            self.models[i].pick     = reader:readInt8Unsigned()     --附件是否提取(无附件:0|未提取:1|已提取:2)
        
        end
    end
    
    
    if self.models then
        print("k标记", "邮件ID", "邮件类型01","名字","标题","发送日期","邮件状态01","附件是否提取012", #self.models )
        for k, v in pairs( self.models) do
           --print(k, v.mail_id, v.mtype, v.name, v.title, v.date, v.state, v.pick)
        end
    else
        CCLOG("没有信件  "..self.count)
        --[[
        if _G.g_Logs ~= nil then
            _G.g_Logs :pushOne("当前没有任何邮件")
        end
         --]]
        local command = CLogsCommand( "当前没有任何邮件" )
        controller :sendCommand( command )
    end
end

-- {邮箱类型(收件箱:0|发件箱:1|保存箱:2)}
function ACK_MAIL_LIST.getBoxtype(self)
	return self.boxtype
end

-- {数量}
function ACK_MAIL_LIST.getCount(self)
	return self.count
end

-- {邮件模块[8513]}
function ACK_MAIL_LIST.getModels(self)
	return self.models
end
