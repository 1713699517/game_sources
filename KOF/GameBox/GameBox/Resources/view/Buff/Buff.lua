require "common/Constant"

CBuff = class()

function CBuff.init( self, _data, _skillId )
	for k,v in pairs(_data) do
		local t = tonumber(v)
		if t ~= nil then
			self[k] = t
			local function get( self )
				return self[k]
			end
			self["get"..k] = get

			local function set( self, _setData )
				self[k] = _setData
			end
			self["set"..k] = set
		end
	end
	if self.duration == nil then -- 删除函数 CBuff.update
		self.update = nil
	else
		self.m_fDuration = 0
	end
	self.m_nSkillId = _skillId
end

function CBuff.update( self, _duration )
	if self.duration == nil then
		return
	end
	self.m_fDuration = self.m_fDuration + _duration
end
function CBuff.isTimeOut( self )
	if self.duration == nil then
		return false
	end
	if self.m_fDuration >= self.duration then
		return true
	end
	return false
end

function CBuff.getSkillId(self)
	return self.m_nSkillId
end

_G.buffManager = class()

function buffManager.init( self )
	if self.m_buffList ~= nil then
		return true
	end

	_G.Config:load("config/buff_effect.xml")


	self.m_buffList = {}
	local node = _G.Config.buff_effects:selectSingleNode("buff_effect[@id=1]")
	local nextChild = node:children()
	local childCount = nextChild:getCount("buff")
	for i=0,childCount-1 do
		local nextNode = nextChild:get(i,"buff")
		if nextNode ~= nil then
			local obj = self:copyXml( nextNode )
			if obj ~= nil then
				self.m_buffList[obj.id] = obj
			end
		end
	end
	for k,v in pairs( _G.Config.buff_effect.buff ) do
		self.m_buffList[v.id] = v
	end
	_G.Config:unload("config/buff_effect.xml")
	return true
end

function buffManager.copyXml( self, _node )
	local id = _node:getAttribute("id")
	if id == nil then
		return
	end
	local tb  = {}
	tb.id = id
	tb.type = _node:getAttribute("type")
	tb.duration = _node:getAttribute("duration")
	tb.hp = _node:getAttribute("hp")
	tb.speed = _node:getAttribute("speed")
	tb.pushAngle = _node:getAttribute("pushAngle")
	tb.acceleration = _node:getAttribute("acceleration")
	tb.speedX = _node:getAttribute("speedX")
	tb.speedY = _node:getAttribute("speedY")
	return tb
end

function buffManager.getBuffNewObject( self, _buffID, _skillId )
	_buffID = tostring(_buffID)
	local isInit = self : init()
	if isInit ~= true then
		return nil
	end
	if self.m_buffList == nil or self.m_buffList[_buffID] == nil then
		return nil
	end
	local newObject = CBuff()
	newObject : init( self.m_buffList[_buffID], _skillId )
	return newObject
end



--:selectNode( "buff", "id", tostring( _nColliderID ) )

