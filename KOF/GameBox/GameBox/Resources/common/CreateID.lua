
--[[
此类为生成当前客户端唯一标识ID
不过是从负数开始
]]
CCreateID = class( function ( self )
    self.m_nID = 0
end)


function CCreateID.getNewID( self )
	self.m_nID = self.m_nID -1
	return self.m_nID
end

_G.CreateID = CCreateID()