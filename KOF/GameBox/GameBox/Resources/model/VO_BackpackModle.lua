

VO_BackpackModel = class(function(self)
self.AT = "AT_Defaut"
self.m_maxcapacity = 0  --背包容量
self.m_backpackinfo = {}

end)

--_G.BackpackModel = VO_BackpackModel()

function VO_BackpackModel.setAT( self, data)
    print("VO_BackpackModel.setBackpackInfo")
    print(self.m_backpackinfo)
    self.AT = data
end

function VO_BackpackModel.getAT( self)
    return self.AT
end

function VO_BackpackModel.setMaxCapacity( self, data)
    -- body
    self.m_maxcapacity = data
end

function VO_BackpackModel.getMaxCapacity( self)
    -- body
    return self.m_maxcapacity
end

--背包内goods
function VO_BackpackModel.setBackpackInfo( self, data)
    print("VO_BackpackModel.setBackpackInfo")
    print(self.m_backpackinfo)
    self.m_backpackinfo = data
end

function VO_BackpackModel.getBackpackInfo( self)
    return self.m_backpackinfo
end


