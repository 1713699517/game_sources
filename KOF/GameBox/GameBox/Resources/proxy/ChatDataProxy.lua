require "view/view"
require "controller/command"
require "mediator/ChatDataMediator"

CChatDataProxy = class(view,function(self)
	self.m_cachedSize = 50
	self.m_cachedTab = {}
end)

_G.g_ChatDataProxy = CChatDataProxy()
--[[
require "proxy/ChatDataProxy"
require "mediator/ChatDataMediator"
_G.pChatDataMediator = CChatDataMediator( _G.g_ChatDataProxy )
controller:registerMediator(_G.pChatDataMediator)
 --]]
--清空数据
function CChatDataProxy.clearData(self)
	self.m_cachedTab = {}
end

function CChatDataProxy.getListReverse( self, _size )
	local ret = {}
	local _count = 0
	local _tabCount = #self.m_cachedTab + 1
	local _startCount = _tabCount - _size
	if _startCount < 1 then
		_startCount = 1
	end
	for i = _startCount, _tabCount do
		table.insert(ret, self.m_cachedTab[i] )
	end
	return ret
	--[[
	print("getReverse", _tabCount, _startCount)
	for i=_tabCount - 1, 1, -1 do
		table.insert( ret, self.m_cachedTab[i] )
		_count = _count + 1
		if _size ~= nil and _size > 0 and _count >= _size then
			break
		end
	end
	return ret]]
end

function CChatDataProxy.getList(self, _nChannelId, _size)
	if (_nChannelId == nil or _nChannelId == 0) and (_size == nil or _size == 0) then
		return self.m_cachedTab
	end
	local ret = {}
	local _count = 0
	for i,v in ipairs(self.m_cachedTab) do
		if _nChannelId ~= nil and _nChannelId ~= 0 and _nChannelId == v:getChannelId() and _size ~= nil and _size > 0 and _count < _size then
			table.insert(ret, v)
			_count = _count + 1
		elseif _nChannelId ~= nil and _nChannelId ~= 0 and _nChannelId == v:getChannelId() and (_size == nil or _size == 0) then
			table.insert(ret, v)
			_count = _count + 1
		elseif (_nChannelId == nil or _nChannelId == 0) and _size ~= nil and _size > 0 and _count < _size then
			table.insert(ret, v)
			_count = _count + 1
		end
		if _size ~= nil and _size > 0 and _count >= _size then
			break
		end
	end
	return ret
end

function CChatDataProxy.pushData(self, _vo_Data)
	if #self.m_cachedTab >= self.m_cachedSize then
		self:popData()
	end
	table.insert(self.m_cachedTab, _vo_Data)
end

function CChatDataProxy.popData(self)	
	if #self.m_cachedTab == 0 then
		return nil
	end
	return table.remove(self.m_cachedTab, 1)
end

function CChatDataProxy.setCachedSize(self, _size)
	self.m_cachedSize = _size
end

function CChatDataProxy.getCachedSize(self)
	return self.m_cachedSize
end


function CChatDataProxy.getColorByType( self, _type )
    local _retColor = nil
    
    print( " CChatView.getTypeColor 颜色类型为 00-> ", _type )
    if _type == nil then
        _retColor = ccc4( 255, 255, 255, 255 )
        elseif _type == _G.Constant.CONST_COLOR_GRAY then           -- 颜色-灰
        _retColor = ccc4( 150, 150, 150, 255 )
        elseif _type == _G.Constant.CONST_COLOR_WHITE then          -- 颜色-白
        _retColor = ccc4( 255, 255, 255, 255 )
        elseif _type == _G.Constant.CONST_COLOR_GREEN then          -- 颜色-绿
        _retColor = ccc4( 30, 227, 10, 255 )
        
        elseif _type == _G.Constant.CONST_COLOR_BLUE then           -- 颜色-蓝
        _retColor = ccc4( 0, 150, 255, 255 )
        elseif _type == _G.Constant.CONST_COLOR_VIOLET then         -- 颜色-紫
        _retColor = ccc4( 138, 0, 255, 255 )
        elseif _type == _G.Constant.CONST_COLOR_GOLD then           -- 颜色-金
        _retColor = ccc4( 255, 240, 0, 255 )
        
        elseif _type == _G.Constant.CONST_COLOR_ORANGE then         -- 颜色-橙
        _retColor = ccc4( 255, 96, 0, 255 )
        elseif _type == _G.Constant.CONST_COLOR_RED then            -- 颜色-红
        _retColor = ccc4( 255, 0, 0, 255 )
        elseif _type == _G.Constant.CONST_COLOR_CYANBLUE then       -- 颜色-青
        _retColor = ccc4( 0, 255, 162, 255 )
        
        elseif _type == _G.Constant.CONST_COLOR_MOONLIGHT then      -- 颜色-月光
        _retColor = ccc4( 0, 234, 255, 255 )
        elseif _type == _G.Constant.CONST_COLOR_AMBER then          -- 颜色-琥珀
        _retColor = ccc4( 252, 0, 255, 255 )
        
    end
    
    return _retColor
end

function CChatDataProxy.gsub( self, _str, _target )
	local retFirst  = ""
    local retSecond = ""
    
    --print( ")____str ", _str )
    local isFind = false
    if _str ~= nil then
        local nCount = 1        --计数，去除第二个 _target
        for i=1, string.len( _str ) do
            local tmpStr = string.sub( _str, i, i )
            if tmpStr == _target then
                if nCount == 1 then
                    nCount = nCount + 1
                    else
                    isFind = true
                end
                tmpStr = ""
            end
            
            if isFind == false then
                retFirst = retFirst .. tmpStr
                else
                retSecond = retSecond .. tmpStr
            end
            
        end
    end
    
    print( "返回的最终sss-->", retFirst, " -->   ", retSecond )
    return retFirst or "", retSecond or ""
    
end
