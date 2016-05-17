VO_FriendModel = class( function(self)
    self.m_searchCount  = nil       --4060
    self.m_searchData   = {}
    
    self.fid  = nil                 --4080
    self.fname= nil

    self.delId  = nil               --4040
end)

-- (手动) -- [4060]返回查找好友信息 -- 好友
-- {数量}
function VO_FriendModel.setSearchCount( self, value)
    self.m_searchCount = value
end
function VO_FriendModel.getSearchCount( self)
    return self.m_searchCount
end

---------- {信息块(4025)}
function VO_FriendModel.setSearchData( self, value)
    self.m_searchData = value
end
function VO_FriendModel.getSearchData( self)
    return self.m_searchData
end

-- (手动) -- [4080]发送添加好友通知 -- 好友
-- {好友id}
function VO_FriendModel.setFid(self, value)
	self.fid = value
end
function VO_FriendModel.getFid(self)
	return self.fid
end

-- {好友名字}
function VO_FriendModel.setFname(self, value)
	self.fname = value
end
function VO_FriendModel.getFname(self)
	return self.fname
end

-- (手动) -- [4040]好友删除成功 -- 好友 
-- {好友id}
function VO_FriendModel.getDelFid(self)
	return self.delId
end
function VO_FriendModel.setDelFid( self, value)
    self.delId = value
end
