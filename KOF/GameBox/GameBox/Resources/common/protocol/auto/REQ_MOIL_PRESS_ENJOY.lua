
require "common/RequestMessage"

-- [35063]进入压榨界面 -- 苦工 

REQ_MOIL_PRESS_ENJOY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MOIL_PRESS_ENJOY
	self:init(0, nil)
end)

function REQ_MOIL_PRESS_ENJOY.serialize(self, writer)
	writer:writeInt32Unsigned(self.moil_uid)  -- {uid}
end

function REQ_MOIL_PRESS_ENJOY.setArguments(self,moil_uid)
	self.moil_uid = moil_uid  -- {uid}
end

-- {uid}
function REQ_MOIL_PRESS_ENJOY.setMoilUid(self, moil_uid)
	self.moil_uid = moil_uid
end
function REQ_MOIL_PRESS_ENJOY.getMoilUid(self)
	return self.moil_uid
end
