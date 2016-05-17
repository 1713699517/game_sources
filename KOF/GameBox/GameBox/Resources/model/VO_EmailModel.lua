VO_EmailModel = class( function( self)
    self.m_bInited = false
                      
    self.boxtype = 0
    self.count	 = 0
    self.models	 = {}			-- {邮件模块[8513]}
                      
      self.mail_id  = nil
      self.send_uid = nil
      self.state    = nil
      self.pick     = nil
      self.content  = nil
      self.count_v  = nil
      self.vgoods_msg  = {}
      
      self.count_u  = nil
      self.ugoods_msg  = {}
                      
                      
    --8562
    self.m_nDelCount  = 0
    self.m_data       = {}
end)

function VO_EmailModel.set8562Count( self, value)
    self.m_nDelCount = tonumber( value)
end
function VO_EmailModel.get8562Count( self)
    return self.m_nDelCount
end
--------

function VO_EmailModel.set8562Data( self, value)
    self.m_data = value
end
function VO_EmailModel.get8562Data( self)
    return self.m_data
end

function VO_EmailModel.setInited( self, value)
    self.m_bInited = value
end

function VO_EmailModel.getInited( self)
    return self.m_bInited
end

function VO_EmailModel.setBoxtype( self, value )
	self.boxtype = value
end

function VO_EmailModel.getBoxtype( self )
	return self.boxtype
end


function VO_EmailModel.setCount( self, value )
	self.count = value	
end

function VO_EmailModel.getCount( self )
	return self.count
end


function VO_EmailModel.setModels( self, value )
	self.models = value	
end

function VO_EmailModel.getModels( self )
	return self.models
end

-- {邮件Id}
function VO_EmailModel.setMailId(self, value)
	self.mail_id = value
end
function VO_EmailModel.getMailId(self)
	return self.mail_id
end

-- {发件人Uid}
function VO_EmailModel.setSendUid(self, value)
	self.send_uid = value
end
function VO_EmailModel.getSendUid(self)
	return self.send_uid
end

-- {邮件状态(未读:0|已读:1)}
function VO_EmailModel.setState( self, value)
	self.state = value
end
function VO_EmailModel.getState(self)
	return self.state
end

-- {附件是否提取(无附件:0|未提取:1|已提取:2)}
function VO_EmailModel.setPick( self, value)
	self.pick = value
end
function VO_EmailModel.getPick(self)
	return self.pick
end

-- {内容}
function VO_EmailModel.setContent( self, value)
	self.content = value
end
function VO_EmailModel.getContent(self)
	return self.content
end

-- {附件虚拟物品数}
function VO_EmailModel.setCountV( self, value)
	self.count_v = value
end
function VO_EmailModel.getCountV(self)
	return self.count_v
end

-- {虚拟物品信息块[8543]}
function VO_EmailModel.setVgoodsMsg( self, value)
	self.vgoods_msg = value
end
function VO_EmailModel.getVgoodsMsg(self)
	return self.vgoods_msg
end

-- {附件实体物品数}
function VO_EmailModel.setCountU( self, value)
	self.count_u = value
end
function VO_EmailModel.getCountU(self)
	return self.count_u
end

-- {实体物品信息块2001}
function VO_EmailModel.setUgoodsMsg( self, value)
	self.ugoods_msg = value
end
function VO_EmailModel.getUgoodsMsg(self)
	return self.ugoods_msg
end
