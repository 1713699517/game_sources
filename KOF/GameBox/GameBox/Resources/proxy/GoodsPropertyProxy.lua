

require "view/view"
require "mediator/mediator"
require "proxy/GoodsProperty"


CGoodsPropertyProxy = class( view , function( self)
    self.m_bInitialized = false  
    self.m_oneGood      = nil
    self.m_goodsList    = {} --物品列表                    
end)

_G.g_GoodsProperty = CGoodsPropertyProxy()

--缓存存放标识
function CGoodsPropertyProxy.setInitialized(self, bValue)
    self.m_bInitialized = bValue
end

function CGoodsPropertyProxy.getInitialized(self)
    return self.m_bInitialized 
end

--初始化
function CGoodsPropertyProxy.initGoods(self,_goods_id)
	self.m_oneGood =  CGoodsPropertyProxy ()
	self.m_oneGood : setGoods_id( _goods_id )
    self : addOne(self.m_oneGood)
end



-- {添加某一个物品}
function CGoodsPropertyProxy.addOne( self, _goodsProperty )
    self.m_goodsList[ _goodsProperty : getGoods_id() ] = _goodsProperty
end

-- {更新物品,咱不做物品更新}
function CGoodsPropertyProxy.updateSomeOne( self, _goods_id, _type, _value )
    local good = self : getOneByUid( _goods_id ) --拿到某个物品
    if good == nil then
        return
    end
   -- good : updateProperty( _type, _value )  --更新某个物品
end

-- {获取物品}
function CGoodsPropertyProxy.getOneByUid( self, _goods_id )
    return self.m_GoodsList[_goods_id]
end

-- {清空物品内存}
function CGoodsPropertyProxy.cleanUp( self )
    self.m_goodsList = {}
    if self.m_oneGood ~= nil then
        local m_onegoodid = self.m_oneGood : getGoods_id()
        self.m_goodsList[ m_oneGoodid ] = self.m_oneGood
    end
end

-- {移除某一个物品}
function CGoodsPropertyProxy.removeOne( self, _goods_id )
    self.m_goodsList[_goods_id] = nil
end










