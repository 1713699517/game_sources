--推荐好友
VO_RecommendModel = class( function(self)
    self.count = nil
    self.data  = {}
end)

function VO_RecommendModel.setCount( self, value)
    self.count = value
end

function VO_RecommendModel.getCount( self)
    return self.count
end

function VO_RecommendModel.setData( self, value)
    self.data = value
end

function VO_RecommendModel.getData( self)
    return self.data
end





