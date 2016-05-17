require "view/view"
require "common/Constant"


CFunNoticView = class(view,function ( self )

end)



CFunNoticView.TAG_CLOSE = 101
CFunNoticView.Priority  = -10000


function CFunNoticView.initView( self )
	self.m_mainContainer = CContainer :create()
    self.m_mainContainer : setControlName( "this CFunNoticView self.m_mainContainer 39 ")
    self.m_viewContainer : addChild( self.m_mainContainer )

    local bgSize = CCSizeMake( 320,170 )
    self.m_background = CSprite :createWithSpriteFrameName("NPC_talk_underframe.png",CCRectMake( 82, 20, 1, 2 ) )
    self.m_background : setControlName( "this CFunNoticView self.m_background 39 ")
	self.m_background : setPreferredSize( bgSize )
	self.m_mainContainer : addChild( self.m_background )

	local function local_closeBtnCallback(eventType,obj,x,y)
		return self:closeBtnCallback(eventType,obj,x,y)
	end

	----------------------------
	--主界面
	----------------------------
	self.m_closeBtn	= CButton :createWithSpriteFrameName( "", "general_close_normal.png")
	self.m_closeBtn : setControlName( "this CFunNoticView self.m_closeBtn 70 ")
    self.m_closeBtn : setTag( CFunNoticView.TAG_CLOSE )
    self.m_closeBtn : setTouchesPriority( CFunNoticView.Priority - 10 )
    self.m_closeBtn : registerControlScriptHandler( local_closeBtnCallback, "this CFunNoticView self.m_closeBtn 72 ")
    self.m_mainContainer : addChild( self.m_closeBtn )


end

function CFunNoticView.layout(self)

	local _winSize 		= CCDirector:sharedDirector():getVisibleSize()
	local closeBtnSize  = self.m_closeBtn :getContentSize()
	local bgSize        = self.m_background :getPreferredSize()

	local _relX = _winSize.width-bgSize.width
	local _relY = 0

	--背景
	self.m_background : setPosition( ccp( _relX + bgSize.width/2, _relY + bgSize.height/2 ) )
	--关闭按钮
	self.m_closeBtn   : setPosition(ccp( _relX + bgSize.width-closeBtnSize.width/2, _relY + bgSize.height - closeBtnSize.height/2)) 
	--pageScrollView
	-- self.m_pageScrollView : setPosition( _relX +5 , 5 )

end

function CFunNoticView.addOneNotic( self, _info )

	if _info == nil then 
		return false
	end

	local _node = _info.node
	local _msg  = _info.msg


	local function local_btnTouchesCallBack( eventType, obj, x, y )
		return self:btnTouchesCallBack( eventType, obj, x, y )
	end


	local _winSize = CCDirector:sharedDirector():getVisibleSize()
	local _bgSize  = self.m_background :getPreferredSize()
	local _relX = _winSize.width - _bgSize.width
	local _relY = 0


	local controlStr = "(点击查看)"
	if tonumber(_node:getAttribute("open")) == 0 then
		controlStr = "(我知道了)"
	end


	print("  CFunNoticView.addOneNotic     |  ",_node:getAttribute("title"))


	local pageContainer = CContainer:create()
	pageContainer : setPosition( ccp( _relX + 5, 5 ) )
	pageContainer : setControlName("this CFunNoticView pageContainer 110")

	local titleLabel = CCLabelTTF:create(_node:getAttribute("title"),"Arial", 26)
	titleLabel : setPosition(ccp( _bgSize.width/2,_relY+_bgSize.height-35))
    titleLabel : setColor( ccc4(255,255,0,255) )
    

    local noticLabel = self:createRichText( _node:getAttribute("describe"), _msg.str_module, _msg.int_module, CCSizeMake( _bgSize.width-20, 500 ) )
	-- local noticLabel = CCLabelTTF:create( _node:getAttribute("describe"), "Arial", 20 )
	noticLabel : setPosition(ccp( 10,_relY+_bgSize.height-65))
	-- noticLabel : setHorizontalAlignment( kCCTextAlignmentLeft )
	-- noticLabel : setAnchorPoint( ccp( 0,1 ) )

	local controlLabel = CCLabelTTF:create( controlStr, "Arial", 20 )
	controlLabel : setColor( ccc4(0,0,255,255) )
	controlLabel : setPosition(ccp( _bgSize.width/2, _relY+23))


	local button = CButton:createWithSpriteFrameName( "","transparent.png" )
	button : setTag( tonumber( _node:getAttribute("open") ) )
	button : registerControlScriptHandler( local_btnTouchesCallBack, "this CFunNoticView self.m_closeBtn 72 ")
	button : setControlName("this CFunNoticView self.m_pageScrollView 63")
	button : setTouchesPriority( CFunNoticView.Priority -1 )
	button : setPreferredSize( CCSizeMake( _bgSize.width-10,_bgSize.height-10 ) )
	button : setPosition( ccp( _bgSize.width/2, _relY + _bgSize.height/2) )

	pageContainer : addChild( titleLabel )
	pageContainer : addChild( noticLabel )
	pageContainer : addChild( controlLabel )
	pageContainer : addChild( button )

	self.m_mainContainer : addChild( pageContainer, 100 )




	return true
end


function CFunNoticView.init(self)

    --初始化界面
	self:initView()
	--布局成员
	self:layout()

end

function CFunNoticView.create(self)
	local _winSize  = CCDirector:sharedDirector():getVisibleSize()

	self.m_viewContainer = CContainer :create()
    self.m_viewContainer : setControlName( "this CFunNoticView self.m_viewContainer 39 ")

    self:init()

	return self.m_viewContainer
end

function CFunNoticView.closeView( self )
	_G.g_CFunOpenManager : resetNoticView()
	if self.m_viewContainer ~= nil then
		self.m_viewContainer : removeFromParentAndCleanup( true )
		self.m_viewContainer = nil
	end
end




--************************
--按钮回调
--************************
--关闭 单击回调
function CFunNoticView.closeBtnCallback(self, eventType, obj, x, y)
	if eventType == "TouchBegan" then
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then
		if obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y))) then

			print("closeBtnCallback -->  ",self.m_viewContainer)
			self:closeView()
			_G.g_CFunOpenManager : delNowNoticAndGoNext()
		end
	elseif eventType == "Enter" then
		print("closeBtnCallback -->  Enter")
		if self.m_viewContainer == nil then
			print("closeBtnCallback -->  copy")
			self.m_viewContainer = self.m_copyContainer
		end
	elseif eventType == "Exit" then
		print("closeBtnCallback -->  Exit")
		self.m_copyContainer = self.m_viewContainer
		self.m_viewContainer = nil
	end
end


function CFunNoticView.btnTouchesCallBack(self, eventType, obj, x, y)
	if eventType == "TouchBegan" then
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then
		if obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y))) then
			local tag = obj : getTag()
			print("点击啦...ID-->"..tag)

            _G.g_CFunOpenManager : openActivityById( tag )
        	_G.g_CFunOpenManager : delNowNoticAndGoNext()
        	

        	-- local msg = "在竞技场{$}挑战你成功你的排名下降到第{#}名"
        	-- local strList = {}
        	-- strList[1] = {}
        	-- strList[1].type1 = "你妹->"
        	-- strList[1].colour = ccc4( 200,100,50,255 )

        	-- local intList = {}
        	-- intList[1] = {}
        	-- intList[1].type2 = 33

        	-- self:createRichText( msg, strList, intList )
		end
	end
end


--************************
--拼接字符串
--************************
function CFunNoticView.createRichText( self, _msgStr, _strList, _numList, _size )
	if _msgStr == nil then 
		return nil
	end

	print( "createRichText   11",_msgStr )


	for i,v in ipairs(_strList) do
		print("createRichText->>>>>>>>>_strList: ",v.type1,v.colour,i)
	end

	for i,v in ipairs(_numList) do
		print("createRichText->>>>>>>>>_numList: ",v.type2)
	end

    local newStrList   = {}
    local newColorList = {}
    local nodeList     = {}
    local whiteColor   = ccc4( 255,255,255,255 )
    local posStart = 1
    local iCount   = 1


    for i=1,#_strList do
    	
    	local strStart,strEnd = string.find(_msgStr,"{$}", posStart)
    	print( "«««««««««««««««    111")

    	if strStart ~= nil then
    		local list = {}
    		list.pos = strStart
    		list.str = _strList[iCount].type1
    		list.color = _G.g_CFunOpenManager:getColorByType( _strList[iCount].colour )
    		list.size  = strEnd - strStart + 1
    		table.insert( nodeList, list )
    		iCount = iCount + 1
    	else
    		break
    	end

    	posStart = strEnd + 1

    end

    iCount   = 1
    posStart = 1
    for i=1,#_numList do
    	
    	local strStart,strEnd = string.find(_msgStr,"{#}", posStart)
    	print( "«««««««««««««««    222")

    	if strStart ~= nil then
    		local list = {}
    		list.pos = strStart
    		list.str = _numList[iCount].type2
    		list.color = whiteColor
    		list.size  = strEnd - strStart + 1
    		table.insert( nodeList, list )
    		iCount = iCount + 1
    	else
    		break
    	end

    	posStart = strEnd + 1

    end

    
    iCount   = 1
    posStart = 1
    for i=1,10 do

    	local strStart,strEnd = string.find(_msgStr,"{nn}", posStart)
    	print( "«««««««««««««««    333  i="..i)

    	if strStart ~= nil then
    		local list = {}
    		list.pos = strStart
    		list.str = "\n"
    		list.color = whiteColor
    		list.size  = strEnd - strStart + 1
    		table.insert( nodeList, list )
    		iCount = iCount + 1
    	else
    		break
    	end

    	posStart = strEnd + 1
    end
    

    print( "createRichText   22  ",#nodeList )

    if #nodeList >1 then
	    local function sortfunc( list1, list2)

	        if list1.pos < list2.pos then
	            return true
	        end
	        return false
	    end
	    table.sort( nodeList, sortfunc)
	end

    local pre_Pos  = 0
    local pre_size = 0
    for i,v in ipairs(nodeList) do
    	print("createRichText   33   i="..i)
    	local p_pos = pre_Pos+1  -- 开始位置
    	if i == 1 then
    		-- 补充 最前面的
    		if v.pos ~= 1 then
    			print("ææææææææææ0---->",string.sub( _msgStr, 1, v.pos-1 ) )
    			table.insert( newStrList, string.sub( _msgStr, 1, v.pos-1 ) )
    			table.insert( newColorList, whiteColor )
    		end
    	elseif p_pos ~= v.pos then
    		--补充 与上个字符之前漏掉的字符
    		print("ææææææææææ1---->",string.sub( _msgStr, pre_Pos+pre_size, v.pos-1 ).."    i="..i)
    		table.insert( newStrList, string.sub( _msgStr, pre_Pos+pre_size, v.pos-1 ) )
    		table.insert( newColorList, whiteColor )
    	end

    	print("ææææææææææ3---->", v.str)
    	table.insert( newStrList, v.str )
    	table.insert( newColorList, v.color )

    	if i == #nodeList then
    		--添加到最后一个  补充最后的
    		if v.pos+pre_size-1 ~= #_msgStr then
    			print("ææææææææææ2---->",string.sub( _msgStr, v.pos+v.size, #_msgStr ))
    			table.insert( newStrList, string.sub( _msgStr, v.pos+v.size, #_msgStr ) )
    			table.insert( newColorList, whiteColor )
    		end
    	end

    	pre_Pos  = v.pos
    	pre_size = v.size

    end

    print("createRichText   44   #newStrList="..tostring(#newStrList)) 

	if #newStrList == 0 then
		table.insert( newStrList, _msgStr )
	    table.insert( newColorList, whiteColor )
	end

	print("createRichText   55   #newStrList="..tostring(#newStrList)) 


    --显示RichText
    local defaultFontFamily = "Arial"
    local defaultFontSize   = 20
    local RichTextBox = CRichTextBox:create( _size, ccc4(0,0,0,0))
    RichTextBox:setAutoScrollDown(false)
    RichTextBox:retain()
    --RichTextBox:setTouchesPriority(-25)
    -- RichTextBox:setTouchesEnabled(true)
    -- _layer:addChild( RichTextBox )

 --    RichTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, whiteColor)
	-- RichTextBox:appendRichText( "dasdadasda" )
	-- RichTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, whiteColor)
	-- RichTextBox:appendRichText( "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwww\nasdwasda" )

	-- RichTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, whiteColor)
	-- RichTextBox:appendRichText( "tttttttttt&#13;zda" )

    for i,v in ipairs(newStrList) do
    	local color 
    	if newColorList[i] ~= nil then
    		color = newColorList[i]
    	else
    		color = ccc4( 255,255,255,255 )
    	end

    	print( "    appendRichText -->"..v )

		RichTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, color)
		RichTextBox:appendRichText( v )

    end
    

    return RichTextBox

    
end



