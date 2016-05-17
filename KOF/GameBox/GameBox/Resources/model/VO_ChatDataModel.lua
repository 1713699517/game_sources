
VO_ChatDataModel = class(function(self, _msgId, _msgType, _msgTable)
	self.m_msgID   = _msgId
	self.m_msgType = _msgType or 0  --区分协议 9530 聊天消息 与  810 游戏广播   --未使用

    --11.21 new add
    self.m_msgTable = _msgTable     --传入的消息table
    self.m_goodsMsgNo   = nil       --物品信息

	self.m_channel_id = 0
	self.m_sid = 0
	self.m_uid = 0
	self.m_uname = ""
	self.m_sex = 0
	self.m_pro = 0
	self.m_lv = 0
	self.m_country_id = 0
	self.m_r_uid = 0
	self.m_r_name = ""
	self.m_title_id = {}
	self.m_goods_msg_no = {}
	self.m_msg = ""

	self.m_arg_type = 0
	self.m_team_id  = 0 
	self.m_copy_id  = 0 		
end)

function VO_ChatDataModel.setGoodsMsgNo( self, _value )
    self.m_goodsMsgNo = _value
end

function VO_ChatDataModel.getGoodsMsgNo( self )
    return self.m_goodsMsgNo
end

function VO_ChatDataModel.getMsgTable( self )
    return self.m_msgTable
end

function VO_ChatDataModel.getMsgType(self)
	return self.m_msgType
end

function VO_ChatDataModel.getId(self)
	return self.m_msgID
end

function VO_ChatDataModel.getChannelId(self)
	return self.m_channel_id
end

function VO_ChatDataModel.setChannelId(self, _nChannelId)
	self.m_channel_id = _nChannelId
end

function VO_ChatDataModel.getSid( self )
	return self.m_sid
end

function VO_ChatDataModel.setSid( self, _nSid )
	self.m_sid = _nSid
end

function VO_ChatDataModel.getUid( self )
	return self.m_uid
end

function VO_ChatDataModel.setUid( self, _nUid )
	self.m_uid = _nUid
end

function VO_ChatDataModel.getUserName(self)
	if self.m_uname == nil then
		return ""
	else
		return self.m_uname
	end
end

function VO_ChatDataModel.setUserName(self, _szName)
	self.m_uname = _szName
end


function VO_ChatDataModel.getReceiverUserName(self)
	if self.m_r_name == nil then
		return ""
	else
		return self.m_r_name
	end
end

function VO_ChatDataModel.setReceiverUserName(self, _szName)
	self.m_r_name = _szName
end

function VO_ChatDataModel.getReceiverPro( self )
	return self.m_r_pro
end

function VO_ChatDataModel.setReceiverPro( self , _nPro)
	self.m_r_pro = _nPro
end

function VO_ChatDataModel.getReceiverLv( self )
	return self.m_r_lv
end

function VO_ChatDataModel.setReceiverLv(self, _nLevel)
	self.m_r_lv = _nLevel
end


function VO_ChatDataModel.getSex( self )
	return self.m_sex
end

function VO_ChatDataModel.setSex( self, _nSex )
	self.m_sex = _nSex
end

function VO_ChatDataModel.getPro( self )
	return self.m_pro
end

function VO_ChatDataModel.setPro( self , _nPro)
	self.m_pro = _nPro
end

function VO_ChatDataModel.getLevel( self )
	return self.m_lv
end

function VO_ChatDataModel.setLevel(self, _nLevel)
	self.m_lv = _nLevel
end

function VO_ChatDataModel.getCountryId(self)
	return self.m_country_id
end

function VO_ChatDataModel.setCountryId(self, _nCountryId)
	self.m_country_id = _nCountryId
end

function VO_ChatDataModel.getReceiverId(self)
	return self.m_r_uid
end

function VO_ChatDataModel.setReceiverId(self, _nReceiverId)
	self.m_r_uid = _nReceiverId
end

function VO_ChatDataModel.getTitleList(self)
	return self.m_title_id
end

function VO_ChatDataModel.setTitleList(self, _tabTitle)
	self.m_title_id = _tabTitle
end

function VO_ChatDataModel.getItemList(self)
	return self.m_goods_msg_no
end

function VO_ChatDataModel.setItemList(self, _tabItem)
	self.m_goods_msg_no = _tabItem
end

function VO_ChatDataModel.getMsg( self )
	if self.m_msg == nil then
		return ""
	else
		return self.m_msg
	end
end

function VO_ChatDataModel.setMsg(self, _szMsg)
	self.m_msg = _szMsg
end

function VO_ChatDataModel.setArg_type(self, _arg_type)
	self.m_arg_type = _arg_type
end

function VO_ChatDataModel.getArg_type(self)
	return self.m_arg_type
end

function VO_ChatDataModel.setTeam_id(self, _team_id)
	self.m_team_id = _team_id
end

function VO_ChatDataModel.getTeam_id(self)
	return self.m_team_id
end

function VO_ChatDataModel.setCopy_id(self, _copy_id)
	self.m_copy_id = _copy_id
end

function VO_ChatDataModel.getCopy_id(self)
	return self.m_copy_id
end















