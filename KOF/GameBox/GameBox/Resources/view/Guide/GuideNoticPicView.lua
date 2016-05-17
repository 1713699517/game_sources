--*********************************
--2013-9-22 by 陈元杰
--操作指引 界面-CGuideNoticPicView
--*********************************

require "view/view"
require "controller/command"
require "mediator/mediator"


CGuideNoticPicView = class(view, function(self)
	self.webView = nil
end)

CGuideNoticPicView.TAG_CLOSE = 101


function CGuideNoticPicView.initView( self, _mainSize )
	self.m_mainContainer = CContainer :create()
    self.m_mainContainer : setControlName( "this CGuideNoticPicView self.m_mainContainer 39 ")
    self.m_viewContainer : addChild( self.m_mainContainer )

    self.m_background = CSprite :createWithSpriteFrameName("general_first_underframe.png")
    self.m_background : setControlName( "this CGuideNoticPicView self.m_background 39 ")
	self.m_background : setPreferredSize( _mainSize )
	self.m_mainContainer : addChild( self.m_background )

	local function local_closeBtnCallback(eventType,obj,x,y)
		return self:closeBtnCallback(eventType,obj,x,y)
	end

	----------------------------
	--关闭 按钮
	----------------------------
	self.m_closeBtn	= CButton :createWithSpriteFrameName( "", "general_close_normal.png")
	self.m_closeBtn : setControlName( "this CGuideNoticPicView self.m_closeBtn 70 ")
    self.m_closeBtn : setTag( CGuideNoticPicView.TAG_CLOSE )
    self.m_closeBtn : registerControlScriptHandler( local_closeBtnCallback, "this CGuideNoticPicView self.m_closeBtn 72 ")
    self.m_mainContainer : addChild( self.m_closeBtn )


    ----------------------------
	--主界面
	----------------------------
    self.m_mainBg = CSprite :createWithSpriteFrameName("general_second_underframe.png")
    self.m_mainBg : setControlName( "this CGuideNoticPicView self.m_mainBg 39 ")
	self.m_mainBg : setPreferredSize( CCSizeMake( 800, 450 ) )
	self.m_mainContainer : addChild( self.m_mainBg )

	self.m_noticImg = CSprite :create("GuideResources/GuidePicResources/guidelines_word_czts.png")
    self.m_noticImg : setControlName( "this CGuideNoticPicView self.m_noticImg 39 ")
	self.m_mainContainer : addChild( self.m_noticImg )

	self.m_imgStr = "GuideResources/GuidePicResources/guidelines_picture.png"
	if LUA_AGENT() == 7 then
		self.m_imgStr = "GuideResources/GuidePicResources/guidelines_picture_mi.png"
	end
	self.m_mainImg = CSprite :create(self.m_imgStr)
    self.m_mainImg : setControlName( "this CGuideNoticPicView self.m_mainImg 39 ")
	self.m_mainContainer : addChild( self.m_mainImg )

	self.m_knowBtn = CButton :createWithSpriteFrameName( "我知道了", "general_button_normal.png")
	self.m_knowBtn : setControlName( "this CGuideNoticPicView self.m_knowBtn 70 ")
	self.m_knowBtn : setFontSize( 24 )
    self.m_knowBtn : setTag( CGuideNoticPicView.TAG_CLOSE )
    self.m_knowBtn : registerControlScriptHandler( local_closeBtnCallback, "this CGuideNoticPicView self.m_knowBtn 72 ")
    self.m_mainContainer : addChild( self.m_knowBtn )

end

function CGuideNoticPicView.layout(self, _mainSize)

	local _winSize = CCDirector:sharedDirector():getVisibleSize()
	self.m_mainContainer : setPosition( ccp( _winSize.width/2-_mainSize.width/2, 0 ) )


	local closeBtnSize  = self.m_closeBtn :getContentSize()
	self.m_background : setPosition( ccp( _mainSize.width/2, _mainSize.height/2 ) )
	self.m_closeBtn   : setPosition(ccp( _mainSize.width-closeBtnSize.width/2,_mainSize.height-closeBtnSize.height/2)) 


	self.m_mainBg   : setPosition( ccp( _mainSize.width/2, _mainSize.height/2 ) )
	self.m_noticImg : setPosition( ccp( _mainSize.width/2, _mainSize.height*0.92 ) )
	self.m_mainImg  : setPosition( ccp( _mainSize.width/2, _mainSize.height/2 ) )
	self.m_knowBtn  : setPosition( ccp( _mainSize.width/2, _mainSize.height*0.08 ) )
end




function CGuideNoticPicView.init(self, _mainSize)

    --初始化界面
	self:initView(_mainSize)
	--布局成员
	self:layout(_mainSize)

end

function CGuideNoticPicView.scene(self)
	local _winSize  = CCDirector:sharedDirector():getVisibleSize()
	local _mainSize = CCSizeMake( 854, _winSize.height )

	local newScene = CCScene : create()
	self.m_viewContainer = CContainer :create()
    self.m_viewContainer : setControlName( "this CGuideNoticPicView self.m_viewContainer 39 ")
    newScene : addChild( self.m_viewContainer )

    self:init(_mainSize)

	return newScene
end




--************************
--按钮回调
--************************
--关闭 单击回调
function CGuideNoticPicView.closeBtnCallback(self, eventType, obj, x, y)
	if eventType == "TouchBegan" then
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then
		if obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y))) then
			CCDirector:sharedDirector():popScene()
			_G.pCGuideManager:GuidePicFinish()
		end
	end
end







