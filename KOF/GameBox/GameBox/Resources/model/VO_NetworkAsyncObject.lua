VO_NetworkAsyncObject = class(function(self, _delay, _tabProtocol)
	self.m_delay = _delay
	self.m_protocols = _tabProtocol
end)

function VO_NetworkAsyncObject.getDelayTime(self)
	return self.m_delay
end

function VO_NetworkAsyncObject.getProtocolList(self)
	return self.m_protocols
end