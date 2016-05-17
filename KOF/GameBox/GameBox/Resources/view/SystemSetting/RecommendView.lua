--*********************************
--2013-9-14 by 陈元杰
--系统设置 子界面-CRecommendView
--*********************************

require "view/view"
require "controller/command"
require "mediator/mediator"

CRecommendView = class(view, function(self)
end)


-- ccColor4B 常量
CRecommendView.RED   = ccc4(255,0,0,255)
CRecommendView.GOLD  = ccc4(255,255,0,255)
CRecommendView.GREEN = ccc4(120,222,66,255)




function CRecommendView.initView( self, _mainSize )


	self.m_mainContainer = CContainer :create()
    self.m_mainContainer : setControlName( "this CRecommendView self.m_mainContainer 39 ")
    self.m_viewContainer : addChild( self.m_mainContainer )

	self.m_mainBg = CSprite :createWithSpriteFrameName("general_second_underframe.png")
    self.m_mainBg : setControlName( "this CRecommendView self.m_mainBg 39 ")
	self.m_mainBg : setPreferredSize( CCSizeMake( 824,554 ) )
	self.m_mainContainer : addChild( self.m_mainBg )

	

end

function CRecommendView.layout(self, _mainSize)

	self.m_mainBg : setPosition( ccp( _mainSize.width/2, 292 ) )


end


--初始化数据成员
function CRecommendView.initParams( self)

end


--释放成员
function CRecommendView.realeaseParams( self)
    --反注册mediator
    -- if _G.pCActivitiesMediator ~= nil then
    --     controller :unregisterMediator(_G.pCActivitiesMediator)
    --     _G.pCActivitiesMediator = nil
    -- end
end




function CRecommendView.init(self, _mainSize)

	--初始化数据
    self:initParams()
    --初始化界面
	self:initView(_mainSize)
	--布局成员
	self:layout(_mainSize)

end

function CRecommendView.layer(self)
	local _winSize  = CCDirector:sharedDirector():getVisibleSize()
	local _mainSize = CCSizeMake( 854, _winSize.height )

	self.m_viewContainer = CContainer :create()
    self.m_viewContainer : setControlName( "this CRecommendView self.m_viewContainer 39 ")

    self:init(_mainSize)

	return self.m_viewContainer
end





