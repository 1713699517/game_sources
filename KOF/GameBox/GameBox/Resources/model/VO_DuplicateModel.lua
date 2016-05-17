

VO_DuplicateModel = class(function(self)
self.m_duplicatecount = 0  --副本个数
self.m_duplicatelist  = {}

end)

function VO_DuplicateModel.setDuplicateCount( self, _data)
    -- body
    self.m_duplicatecount = _data
end

function VO_DuplicateModel.getDuplicateCount( self)
    -- body
    return self.m_duplicatecount
end

--副本链表
function VO_DuplicateModel.setDuplicateList( self, _data)
    print("VO_DuplicateModel.setDuplicateList")
    print(self.m_duplicatelist)
    self.m_duplicatelist = _data
end

function VO_DuplicateModel.getDuplicateList( self)
    return self.m_duplicatelist
end

function VO_DuplicateModel.setDuplicateName( self, _data)
	-- body
	self.m_duplicatename = _data
end
function VO_DuplicateModel.getDuplicateName( self)
	-- body
	return self.m_duplicatename
end






