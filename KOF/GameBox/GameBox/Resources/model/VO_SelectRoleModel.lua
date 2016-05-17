VO_SelectRoleModel = class(function(self, _historyList, _recommendServerList, _allList, _roleList)
	self.m_RecommendServerList = _recommendServerList
	self.m_RoleList = _roleList
	self.m_AllList = _allList
	self.m_HistoryList = _historyList
    self.m_pModelSelectedServerID = nil
    self.m_pSelectedServerName = nil
end)

function VO_SelectRoleModel.setSelectedServerID(self,_Value)
    self.m_pModelSelectedServerID = _Value 
end

function VO_SelectRoleModel.getSelectedServerID(self)
   return self.m_pModelSelectedServerID
end

function VO_SelectRoleModel.setSelectedServerName(self,_Value)
    self.m_pSelectedServerName = _Value
end

function VO_SelectRoleModel.getSelectedServerName(self)
    return self.m_pSelectedServerName
end

function VO_SelectRoleModel.getRecommendServerList(self)
	return self.m_RecommendServerList
end

function VO_SelectRoleModel.getRoleList(self)
	return self.m_RoleList
end

function VO_SelectRoleModel.getHistoryList(self)
	return self.m_HistoryList
end

function VO_SelectRoleModel.getAllList(self)
	return self.m_AllList
end