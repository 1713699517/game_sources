require "view/view"
require "controller/EmailCommand"

require "model/VO_EmailModel"

CReadEmailView = class( view, function(self, _nEmailId, _data)
    if _nEmailId == nil and _data == nil then
        error("_nEmailId==nil", _nEmailId, #_data)
    else
        self.m_mailId   = _nEmailId
        self.models     = _data             --当前id
    end

    print("CReadEmailView构造,传过来的邮件id==", _nEmailId)
    self.m_winSize = CCSizeMake( 854.0, 640.0)

    self.CreateEffectsList = {} -- 存放创建ccbi的数据
end)

function CReadEmailView.scene( self)
    local winSize	= CCDirector :sharedDirector() :getVisibleSize()
    local scene		= CCScene :create()
    
    self :init( winSize, scene)
    if self.m_pContainer :getParent() ~= nil then
        self.m_pContainer :removeFromParentAndCleanup(false)
    end
    
    scene :addChild( self.m_pContainer)
    return scene
end

function CReadEmailView.init( self, _winSize, _layer)
    -- self :loadResources()
    self :initParams()
    self :initBgAndCloseBtn( _layer)
    self :initView( _winSize, _layer )
    
    self :registerMyMediator()
    self :layout( _winSize)
end

function CReadEmailView.registerMyMediator( self)
    self :unregisterMyMediator()
    require "mediator/ReadEmailMediator"
    _G.pCReadEmailMediator = CReadEmailMediator( self)
    controller :registerMediator( _G.pCReadEmailMediator)
    
    if self.m_mailId then
        print(" CReadEmailView请求读取邮件id  ", self.m_mailId)
        if self.m_mailId > 0 then
            require "common/protocol/auto/REQ_MAIL_READ"
            local msg = REQ_MAIL_READ()
            msg :setMailId( self.m_mailId)
            CNetwork :send( msg)
            print("请求了的", msg :getMailId())
        end
    end
    
end

function CReadEmailView.getColor( self)
    local color = ccc3( 0, 180, 255)
    return color
end
    
function CReadEmailView.unregisterMyMediator( self)
    if _G.pCReadEmailMediator then
        print("_G.pCReadEmailMediator", _G.pCReadEmailMediator)
        controller :unregisterMediator( _G.pCReadEmailMediator)
        _G.pCReadEmailMediator = nil
    end
end

function CReadEmailView.initBgAndCloseBtn( self, _layer )
    --底图
    self.m_sprBottem  = CSprite :createWithSpriteFrameName( "peneral_background.jpg")
    self.m_sprBottem  :setControlName("this CEmailView. sprBottem 40")
    self.m_pContainer :addChild( self.m_sprBottem, -100)
    
	--背景
    self.m_pBackground  = CSprite :createWithSpriteFrameName("general_first_underframe.png")
    self.m_pBackground  :setControlName("this CReadEmailView. self.m_pBackground 68")
    self.m_pContainer   :addChild( self.m_pBackground, -100 )
    
    self.m_pEmailLabel = CCLabelTTF :create( "邮件", "Arial", 24 )
    self.m_pBackground  :addChild( self.m_pEmailLabel, 10 )
    
    --邮件的第二背景图(上)
    self.m_emailBgUp  = CSprite :createWithSpriteFrameName("general_second_underframe.png", CCRectMake(13,13,9,9))
    self.m_emailBgUp  :setControlName("this CReadEmailView. self.m_emailBgUp 73")
    self.m_pContainer      :addChild( self.m_emailBgUp, -99)
    
    
    local function closeCallBack( eventType, obj, x, y )
    	return self :onCloseCallBack( eventType, obj, x, y)
    end
    --关闭按钮
    self.m_pCloseBtn    = CButton :createWithSpriteFrameName("","general_close_normal.png")
    self.m_pCloseBtn    :setControlName("this CReadEmailView. self.m_pCloseBtn 82")
    self.m_pCloseBtn    :registerControlScriptHandler( closeCallBack, "this CReadEmailView. self.m_pCloseBtn 43" )
    self.m_pBackground   :addChild( self.m_pCloseBtn, 10)
end

function CReadEmailView.initParams( self )
    local function closeTipsCallback( eventType, obj, touches )
        return self :onCloseTipsCallback( eventType, obj, touches )
    end
    
	self.m_pContainer = CContainer :create()
	self.m_pContainer :setControlName("this CReadEmailView. self.m_pContainer 102")
    self.m_pContainer :setTouchesMode( kCCTouchesAllAtOnce )
    self.m_pContainer :setTouchesEnabled( true)
    self.m_pContainer :registerControlScriptHandler( closeTipsCallback, "this CReadEmailView. self.m_pContainer 103")
    
end



function CReadEmailView.initView( self, _winSize, _layer )
    local l_container = CContainer :create()
    l_container :setControlName("this CReadEmailView. l_container 95")
    self.m_pContainer :addChild( l_container)
    --container :setControlName()
    
	-- body
    local winSize	    = CCDirector:sharedDirector():getVisibleSize()
    local winX = winSize.width
    local winY = winSize.height
    local szLabelName   = "Arial"
    local nFontSize     = 20
    local nCloseBtnSize = self.m_pCloseBtn :getPreferredSize()
    local nLabelY       = winSize.height - nCloseBtnSize.height - 50
    
    --标题
    local pTileFont  = CCLabelTTF :create("标题:", szLabelName, nFontSize)
    --发件人
    local pSendLabel  = CCLabelTTF :create("发件人:", szLabelName, nFontSize)
                                                    
    --标题内容
    self.pTitleContent  = CCLabelTTF :create("(邮件标题)", szLabelName, nFontSize)
    --发件人姓名
    self.pSendUser      = CCLabelTTF :create("(系统)", szLabelName, nFontSize)
    --邮件文本内容
    self.pEmailContent  = CCLabelTTF :create("", szLabelName, nFontSize)
    self.pEmailContent :setHorizontalAlignment( kCCTextAlignmentLeft)
    self.pEmailContent :setDimensions( CCSizeMake( self.m_winSize.width - 100, self.m_winSize.height / 4))
    self.pEmailContent :setAnchorPoint( ccp( 0.0, 0.5))       --左对齐
    
    pTileFont :setColor( self :getColor())
    pSendLabel :setColor( self :getColor())
    self.pTitleContent :setColor( self :getColor())
    self.pSendUser      :setColor( self :getColor())
    
    --总奖励
    self.pReward = CCLabelTTF :create("", szLabelName, nFontSize)
    self.pReward :setHorizontalAlignment( kCCTextAlignmentLeft)
    --附件奖励      --如果有的话
    self.pAffixLabel = CCLabelTTF :create("", szLabelName, nFontSize)
                                        
                        
    --self.pReward :setColor( ccc3())
    
    l_container :addChild( pTileFont, -98)
    l_container :addChild( self.pTitleContent, -98)
    l_container :addChild( pSendLabel, -98)
    l_container :addChild( self.pSendUser, -98)
    l_container :addChild( self.pEmailContent, -98)
    l_container :addChild( self.pReward, -98)
    l_container :addChild( self.pAffixLabel, -98)
    
    pTileFont :setPosition( (winX - self.m_winSize.width) /2 + self.m_winSize.width * 0.08274, nLabelY )
    pSendLabel :setPosition( winSize.width * 3 / 5, nLabelY )
                                                    
    
    local pLineSprUp = CSprite :createWithSpriteFrameName( "general_dividing_line.png")
    pLineSprUp :setControlName("this CReadEmailView. pLineSprUp 139")
    l_container    :addChild( pLineSprUp, -98)
    pLineSprUp :setPreferredSize( CCSizeMake( self.m_winSize.width-30, 1 ))
    pLineSprUp :setPosition( winSize.width/2, nLabelY-18)
    
    --[[
    local pLineSprDown = CSprite :createWithSpriteFrameName( "general_dividing_line.png")
    pLineSprDown :setControlName("this CReadEmailView. pLineSprDown 145")
    l_container    :addChild( pLineSprDown, -98)
    pLineSprDown :setPreferredSize( CCSizeMake( self.m_winSize.width, 1 ))
    pLineSprDown :setPosition( winSize.width/2, nLabelY/2)
     --]]
    
    local function btnCallback( eventType, obj, x, y )
        return self :onBtnCallback( eventType, obj, x, y)
    end
    --领取按钮  --删除按钮 --保存按钮
    local szBtnName = "general_button_normal.png"
    self.m_pReceiveBtn = CButton :createWithSpriteFrameName("领取", szBtnName)
    self.m_pDeleteBtn = CButton :createWithSpriteFrameName("返回", szBtnName)
    
    self.m_pReceiveBtn :setControlName("this CReadEmailView. self.m_pReceiveBtn 157")
    self.m_pDeleteBtn :setControlName("this CReadEmailView. self.m_pDeleteBtn 158")

    
    l_container   :addChild( self.m_pReceiveBtn, -99, 10 )
    l_container   :addChild( self.m_pDeleteBtn, -99, 20 )
    --l_container   :addChild( self.m_pSaveBtn, -99, 30 )
    
    local isView = false
    if self.models then
        if self.models.pick then
            if self.models.pick == _G.Constant.CONST_MAIL_ACCESSORY_NO then
                isView = true
            end
        end
    end
    self.m_pReceiveBtn :setVisible( isView)
    
    self.m_pReceiveBtn :registerControlScriptHandler( btnCallback, "this CReadEmailView self.m_pReceiveBtn 165")
    self.m_pReceiveBtn :setFontSize( nFontSize )
    
    self.m_pDeleteBtn :registerControlScriptHandler( btnCallback, "this CReadEmailView self.m_pDeleteBtn 168")
    self.m_pDeleteBtn :setFontSize( nFontSize )
    
    --self.m_pSaveBtn :registerControlScriptHandler( btnCallback, "this CReadEmailView self.m_pStudyBtn 545")
    --self.m_pSaveBtn :setFontSize( nFontSize )
    
    --设置背景图的大小
    local nReceiveBtnSize = self.m_pReceiveBtn :getPreferredSize()
    self.m_emailBgUpSize = CCSizeMake( self.m_winSize.width - 30,  self.m_winSize.height * 0.3797+35)
    self.m_emailBgUp  :setPreferredSize( self.m_emailBgUpSize)  --self.m_winSize.height - 180) )
                                                    
    local nTest = 0
    self :setGoodsContainer( nTest)

    if  self.models then
        if self.models.pick == _G.Constant.CONST_MAIL_ACCESSORY_NULL or self.models.pick == _G.Constant.CONST_MAIL_ACCESSORY_YES then
                if self.m_emailBgDown ~= nil then
                    self.m_emailBgDown :removeFromParentAndCleanup( true)
                    self.m_emailBgDown = nil
                end
                                                    
            self.m_emailBgUpSize = CCSizeMake( self.m_winSize.width - 30,  self.m_winSize.height * 0.7234)
            self.m_emailBgUp  :setPreferredSize( self.m_emailBgUpSize)
            self.m_emailBgUp    :setPosition( _winSize.width / 2, _winSize.height / 2)
            return true
        end
    end
                                                  
    --邮件的第二背景图(下)
    self.m_emailBgDown  = CSprite :createWithSpriteFrameName("general_second_underframe.png", CCRectMake(13,13,9,9))
    self.m_emailBgDown  :setControlName("this CReadEmailView. self.m_emailBgUp 73")
    self.m_pContainer   :addChild( self.m_emailBgDown, -99)
    self.m_emailBgDownSize = CCSizeMake( self.m_winSize.width - 30, 200)
    self.m_emailBgDown  :setPreferredSize( self.m_emailBgDownSize)
    self.m_emailBgDown  :setPosition( _winSize.width / 2, _winSize.height / 2 - self.m_emailBgDownSize.height * 0.68 )
    self.m_emailBgUp    :setPosition( _winSize.width / 2, _winSize.height / 2 + self.m_emailBgUpSize.height * 0.4 )
  
end

function CReadEmailView.setGoodsContainer( self, _data)
    if self.l_container then
        self.l_container :removeFromParentAndCleanup( true)
        self.l_container = nil
    end
    
    self.l_container = CContainer :create()
    self.m_pContainer :addChild( self.l_container)
    
    ---------奖励物品
    local function goodsBtnCallback( eventType, obj, x, y)
        return self :onGoodsBtnCallback( eventType, obj, x, y)
    end
    local cellSize = CCSizeMake( 96, 96)
    
    self.m_hLayout = CHorizontalLayout :create()
    self.l_container :addChild( self.m_hLayout)
    self.m_hLayout :setVerticalDirection( false)
    self.m_hLayout :setCellSize( cellSize)
    
    self.m_bgLayout = CHorizontalLayout :create()
    self.l_container :addChild( self.m_bgLayout)
    self.m_bgLayout :setVerticalDirection( false)
    self.m_bgLayout :setCellSize( cellSize)
    
    local nLine = tonumber( _data)
    self.m_hLayout  :setLineNodeSum( nLine)
    self.m_bgLayout :setLineNodeSum( nLine)
    
    self.m_goodBtn = {}
    
    for k=1, nLine do
        local sprBg = CSprite :createWithSpriteFrameName("general_props_frame_normal.png")
        sprBg :setControlName( "this CReadEmailView sprBg 215 "..k)
        sprBg :setPreferredSize( cellSize)
        self.m_hLayout :addChild( sprBg, -97)
        
        local iconImageName = "Icon/i1011.png"
        
        self.m_goodBtn[k]     = {}
        
        self.m_goodBtn[k] = CButton :create( "奖励物品", tostring( iconImageName))
        self.m_goodBtn[k] : setControlName( "this CReadEmailView self.m_goodBtn[k] 224 ")
        --self.m_leftSkillBtn[_nNameCount] = CButton :create( "技能名字", tostring(iconImageName))
        --print("-------id==",  iconImageName)
        self.m_goodBtn[k] :setFontSize(20)
        self.m_goodBtn[k] :setTag( k)
        self.m_goodBtn[k] :setPreferredSize( CCSizeMake(cellSize.width-16, cellSize.height-16))
        self.m_goodBtn[k] :registerControlScriptHandler( goodsBtnCallback, "this CReadEmailView self.m_goodBtn[k] 230")
        
        self.m_goodBtn[k] :setTouchesPriority( self.m_goodBtn[k] :getTouchesPriority()-1)
        self.m_bgLayout :addChild( self.m_goodBtn[k], -97)
        
    end
    
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    if winSize.height == 640 then
        local nLayoutX = (winSize.width - self.m_winSize.width) * 0.5 + self.m_winSize.width * 0.09853
        self.m_hLayout      :setPosition( nLayoutX, winSize.height/4)
        self.m_bgLayout     :setPosition( nLayoutX, winSize.height/4)
    elseif winSize.height == 768 then
        
    end
    
    print("CReadEmailView.ssetddGoodsContainer")
end

function CReadEmailView.loadResources( self)

end

function CReadEmailView.layout( self, _winSize )
	-- body
    local sizeCloseBtn  = self.m_pCloseBtn :getPreferredSize()
    local winX          = _winSize.width
    local winY          = _winSize.height
    local nCloseBtnSize = self.m_pCloseBtn :getPreferredSize()
    local nLabelY       = winY - nCloseBtnSize.height * 4.0
                                                    
    local nReceiveBtnSize = self.m_pReceiveBtn :getPreferredSize()
    
    if winY == 640 then
        self.m_sprBottem        :setPosition( ccp( winX / 2, winY / 2))
        self.m_pBackground      :setPreferredSize( CCSizeMake( self.m_winSize.width, self.m_winSize.height))
        self.m_pCloseBtn        :setPosition( ccp( self.m_winSize.width / 2-sizeCloseBtn.width / 2, self.m_winSize.height / 2-sizeCloseBtn.height/2))
        self.m_pBackground      :setPosition( ccp( winX / 2, winY / 2 ))
        self.m_pEmailLabel      :setPosition( ccp( 0, self.m_winSize.height / 2 - 35) )
        
        --self.m_emailBgUp  :setPosition( winX/2, (winY+nReceiveBtnSize.height+10)/2 )
        
        
        
        --self.m_pReceiveBtn :setPosition( winX/2+nReceiveBtnSize.width, nReceiveBtnSize.height/2+10 )
        --self.m_pDeleteBtn :setPosition( winX/2+2*nReceiveBtnSize.width, nReceiveBtnSize.height/2+10 )
        self.m_pReceiveBtn  :setPosition( (_winSize.width + self.m_winSize.width) / 2 - 1.80 * nReceiveBtnSize.width, nReceiveBtnSize.height * 0.8 )
        self.m_pDeleteBtn   :setPosition( (_winSize.width + self.m_winSize.width) / 2 - 0.70 * nReceiveBtnSize.width, nReceiveBtnSize.height * 0.8 )
        --self.m_pSaveBtn   :setPosition( winX/2+3*nReceiveBtnSize.width, nReceiveBtnSize.height/2+10 )
        
        local nYY = 18.0
        self.pTitleContent :setPosition( (winX - self.m_winSize.width) /2 + self.m_winSize.width * 0.29274,   winY - nCloseBtnSize.height * 2.0 + nYY  )
        self.pSendUser     :setPosition( (winX ) /2 + self.m_winSize.width * 0.28103206, winY - nCloseBtnSize.height * 2.0 + nYY )
        self.pEmailContent :setPosition( (winX - self.m_winSize.width) /2 + self.m_winSize.width * 0.1,  nLabelY )
        
        self.pReward :setAnchorPoint(ccp(0.0, 0.5))
        self.pReward :setDimensions( CCSizeMake( winX-270, 60))
        self.pReward :setPosition( (winX - self.m_winSize.width) /2 + 30,  winY / 3 + 20)

        self.pAffixLabel    :setAnchorPoint(ccp(0.0, 0.5))
        self.pAffixLabel    :setPosition( (winX - self.m_winSize.width) /2 + 30,  winY / 3 - 10)
        
        
        self.m_hLayout      :setPosition( (winX - self.m_winSize.width) /2 + 84.1428, winY/4)
        self.m_bgLayout     :setPosition( (winX - self.m_winSize.width) /2 + 84.1428, winY/4)
        --CCMessageBox( "坐标", winX/7)
        --
    elseif winY==768 then
    
	end
    print("layoutlayout")
end



function CReadEmailView.pushData( self, vo_data)
    print("\n CReadEmailView.pushData , id ==", vo_data :getMailId())


    --if vo_data :getInited() then
        self.m_nMailId = vo_data :getMailId( )
        self.m_nUid = vo_data :getSendUid( )
        self.m_nState = vo_data :getState( )
        self.m_nPick = vo_data :getPick( )
        self.m_szContent = vo_data :getContent( )
        
        self.m_nCountV = vo_data :getCountV( )
        self.m_vgoodsMsg= vo_data :getVgoodsMsg( )
        
        self.m_nCountU = vo_data :getCountU( )
        self.m_ugoodsMsg = vo_data :getUgoodsMsg( )
    
    
    --------
    
    
        local szTitleContent = "标题名字"
        local szSendUserName = "法人"
        szTitleContent = tostring( self.models.title)
        szSendUserName = tostring( self.models.name)
        
        self.pEmailContent :setString( self.m_szContent)        --内容
        self.pTitleContent :setString( szTitleContent)
       
        --发件人姓名
        self.pSendUser :setString( szSendUserName)
    
        if self.m_nCountV > 0 then 
            for i, v in pairs( self.m_vgoodsMsg) do       --虚拟物品
                print("虚拟物品", i, v.type, v.count)
            end
                
            local szAllReward = "总奖励: "  --总奖励字符串拼接
            for i, v in pairs( self.m_vgoodsMsg) do
                local nMoneyType = tonumber(v.type)
                if  nMoneyType == _G.Constant.CONST_CURRENCY_GOLD then  --1银币
                    szAllReward = szAllReward.."银币"..v.count.."  "
                elseif nMoneyType == _G.Constant.CONST_CURRENCY_RMB then    --货币-元宝(人民
                    szAllReward = szAllReward.."元宝"..v.count.."  "
                elseif nMoneyType == _G.Constant.CONST_CURRENCY_RMB_BIND then--币-元宝(绑定元宝
                    szAllReward = szAllReward.."绑定元宝"..v.count.."  "
                elseif nMoneyType == _G.Constant.CONST_CURRENCY_ENERGY then--币-体力
                    szAllReward = szAllReward.."银体力"..v.count.."  "
                elseif nMoneyType == _G.Constant.CONST_CURRENCY_EXP then---经验 (
                    szAllReward = szAllReward.."经验"..v.count.."  "
                elseif nMoneyType == _G.Constant.CONST_CURRENCY_DEVOTE then--社团贡献
                    szAllReward = szAllReward.."社团贡献"..v.count.."  "
                end
            end
        
            self.pReward :setString( szAllReward)
        end
    
    if self.m_nCountU > 0 then       --如果附件实体物品数量大于0
        self.pAffixLabel :setString("附件奖励")
        --self.m_hLayout   :setLineNodeSum( self.m_nCountU)
        --self.m_bgLayout  :setLineNodeSum( self.m_nCountU)
        
        for k, v in pairs( self.m_ugoodsMsg) do
            print("实体物品", k, v.goods_id, v.goods_num)
        end
        
        --------------
        if self.l_container then
            self.l_container :removeFromParentAndCleanup( true)
            self.l_container = nil
        end
        
        self.l_container = CContainer :create()
        self.l_container : setControlName( "this CReadEmailView self.l_container 368 ")
        self.m_pContainer :addChild( self.l_container)
        
        ---------奖励物品
        local function goodsBtnCallback( eventType, obj, x, y)
        return self :onGoodsBtnCallback( eventType, obj, x, y)
    end
    local cellSize = CCSizeMake( 96, 96)
    
    self.m_hLayout = CHorizontalLayout :create()
    self.m_hLayout : setControlName( "this CReadEmailView self.m_hLayout 378 ")
    self.l_container :addChild( self.m_hLayout)
    self.m_hLayout :setVerticalDirection( false)
    self.m_hLayout :setCellSize( cellSize)
    
    self.m_bgLayout = CHorizontalLayout :create()
    self.m_bgLayout : setControlName( "this CReadEmailView self.m_bgLayout 384 ")
    self.l_container :addChild( self.m_bgLayout)
    self.m_bgLayout :setVerticalDirection( false)
    self.m_bgLayout :setCellSize( cellSize)
    
    local nLine = tonumber( #self.m_ugoodsMsg)
    self.m_hLayout  :setCellHorizontalSpace( 20)
    self.m_bgLayout :setCellHorizontalSpace( 20)

    self.m_hLayout  :setLineNodeSum( nLine)
    self.m_bgLayout :setLineNodeSum( nLine)
    
    self.m_goodBtn = {}
    
    for k=1, nLine do
        local sprBg = CSprite :createWithSpriteFrameName("general_props_frame_normal.png") --""general_the_props.png")
        
        sprBg :setControlName( "this CReadEmailView sprBg 397 "..k)
        sprBg :setPreferredSize( cellSize)
        self.m_hLayout :addChild( sprBg, -97)
        
        local iconImageName = "Icon/i1011.jpg"
        
        local goodnode = _G.g_GameDataProxy :getGoodById( self.m_ugoodsMsg[k].goods_id )
        if goodnode == nil then
            
        elseif goodnode :isEmpty() == false then
            iconImageName =  ("Icon/i".. (goodnode :getAttribute("icon") or "28061") ..".jpg")
        end
        
        self.m_goodBtn[k]     = {}
        
        self.m_goodBtn[k] = CButton :create( tostring( self.m_ugoodsMsg[k].goods_num), tostring( iconImageName))
        self.m_goodBtn[k] : setControlName( "this CReadEmailView self.m_goodBtn[k] 414 ")
        --self.m_leftSkillBtn[_nNameCount] = CButton :create( "技能名字", tostring(iconImageName))
        --print("-------id==",  iconImageName)
        self.m_goodBtn[k] :setFontSize(20)
        self.m_goodBtn[k] :setTag( k or 0 )
        self.m_goodBtn[k] :setPreferredSize( CCSizeMake(cellSize.width-16, cellSize.height-16))
        self.m_goodBtn[k] :registerControlScriptHandler( goodsBtnCallback, "this CReadEmailView self.m_goodBtn[k] 420")
        
        self.m_goodBtn[k] :setTouchesPriority( self.m_goodBtn[k] :getTouchesPriority()-1)
        self.m_bgLayout :addChild( self.m_goodBtn[k], -97)

        --特效特效
        if self.m_ugoodsMsg ~= nil and  self.m_ugoodsMsg[k] ~= nil then
           
            local theType  = tonumber(goodnode.type)
            if theType == 1 or theType == 2 then
                self : Create_effects_equip(self.m_goodBtn[k],goodnode.name_color,self.m_ugoodsMsg[k].goods_id,self.m_ugoodsMsg[k].index)
            end
        end
    end
    
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    if winSize.height == 640 then
        self.m_hLayout      :setPosition( (winSize.width - self.m_winSize.width) * 0.5 + 139, winSize.height / 4)
        self.m_bgLayout     :setPosition( (winSize.width - self.m_winSize.width) * 0.5 + 139, winSize.height / 4)
    elseif winSize.height == 768 then
        
    end
    
    end

    
end

--多点触摸 关闭tips
function CReadEmailView.onCloseTipsCallback( self, eventType, obj, touches )
    if eventType == "TouchesBegan" then
        _G.g_PopupView :reset()
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
            local touchPoint = touch :getLocation()
            if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                self.touchID     = touch :getID()
                self.touchEmailId = obj :getTag()
                break
            end
        end
        elseif eventType == "TouchesEnded" then
        if self.touchID == nil then
            return
        end
        local touchesCount2 = touches:count()
        for i=1, touchesCount2 do
            local touch2 = touches :at(i - 1)
            if touch2:getID() == self.touchID and self.touchEmailId == obj :getTag() then
                local touch2Point = touch2 :getLocation()
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then
                    
                    self.touchID     = nil
                    self.touchEmailId = nil
                    break
                end
            end
        end
    end
end

-------按钮
function CReadEmailView.onBtnCallback( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        _G.g_PopupView :reset()
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        
    elseif eventType == "TouchEnded" then
        local nTag = tonumber( obj:getTag())
        print("领取10 删除20 保存30＝＝", nTag)
        
        if nTag == 20 then
            self :unregisterMyMediator()
            CCLOG("关闭读取邮箱界面", nTag)

            self : removeAllCCBI () --删除所有的CCBI 

            CCDirector :sharedDirector() :popScene()
        elseif nTag == 10 then
            self : removeAllCCBI () --删除所有的CCBI 
            
            if self.models.pick == _G.Constant.CONST_MAIL_ACCESSORY_NULL then
                CCMessageBox("无附件", self.models.pick)
                CCLOG("无附件"..self.models.pick)
                
            elseif self.models.pick == _G.Constant.CONST_MAIL_ACCESSORY_NO then
            
                if self.m_mailId then
                    local sendId = {}
                    sendId[1] = self.m_mailId
                    
                    require "common/protocol/REQ_MAIL_PICK"
                    local msg = REQ_MAIL_PICK()
                    msg :setcount( 1 )
                    msg :setmailids( sendId)
                    print( "提取邮件物品==", sendId[1])
                    CNetwork :send( msg)
                end
                
                
            elseif self.models.pick == _G.Constant.CONST_MAIL_ACCESSORY_YES then
                --CCMessageBox("已提取", self.models.pick)
                CCLOG("已提取"..self.models.pick)
            end
        end
        return true
    end
end

function CReadEmailView.onCloseCallBack( self, eventType, obj, x, y )
	if eventType == "TouchBegan" then
        _G.g_PopupView :reset()
		return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        
    elseif eventType == "TouchEnded" then
        
        self :unregisterMyMediator()
        CCLOG("关闭读取邮箱界面")
        CCDirector :sharedDirector() :popScene()
		return true
	end
end

function CReadEmailView.onGoodsBtnCallback( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        _G.g_PopupView :reset()
		return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        
    elseif eventType == "TouchEnded" then
        print( "goodsIdgoodsId", obj:getTag(), x )
        local _position = {}
        _position.x = x
        _position.y = y
        local nTag   = obj:getTag()
        print("self.m_ugoodsMsg", self.m_ugoodsMsg[nTag].goods_id, nTag)
        local temp = _G.g_PopupView :create( self.m_ugoodsMsg[nTag], _G.Constant.CONST_GOODS_SITE_OTHERROLE, _position )
        self.m_pContainer :addChild( temp )
		return true
	end
end

function CReadEmailView.setReceiveView( self, _nPick)
    print("_nPick", _nPick)
    if  _nPick then
        if _nPick == _G.Constant.CONST_MAIL_ACCESSORY_NULL or _nPick == _G.Constant.CONST_MAIL_ACCESSORY_YES then
            if self.m_emailBgDown ~= nil then
                self.m_emailBgDown :removeFromParentAndCleanup( true)
                self.m_emailBgDown = nil
            end
            if self.m_hLayout ~= nil then
                self.m_hLayout :removeFromParentAndCleanup( true)
                self.m_hLayout = nil
            end
            if self.m_bgLayout ~= nil then
                self.m_bgLayout :removeFromParentAndCleanup( true)
                self.m_bgLayout = nil
            end
            
            self.m_pReceiveBtn :setVisible( false)
            --CCMessageBox("提取成功", self.models.pick)
            local msg = "提取成功"
            self : createMessageBox(msg)
            local _winSize = CCDirector :sharedDirector() :getVisibleSize()
            self.pAffixLabel :setString( "")
            self.pReward :setString( "")
            self.m_emailBgUpSize = CCSizeMake( self.m_winSize.width - 30,  self.m_winSize.height * 0.7234)
            self.m_emailBgUp    :setPreferredSize( self.m_emailBgUpSize)
            self.m_emailBgUp    :setPosition( _winSize.width / 2, _winSize.height / 2)
            return
        end
    end
end

function CReadEmailView.createMessageBox(self,_msg)
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg)
    self.m_pContainer : addChild(BoxLayer,1000)
end


function CReadEmailView.Create_effects_equip ( self,obj,name_color,id,index) 
    name_color = tonumber(name_color)
    if name_color > 0 and name_color < 8 then 
        if name_color ~= 1 then
            name_color = name_color - 1
        end
        local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
            if eventType == "Enter" then
                print( "Enter««««««««««««««««"..eventType )
                arg0 : play("run")
            end
        end
  
        if obj ~= nil and index ~= nil  then
            self["effect_ccbi"..index] = CMovieClip:create( "CharacterMovieClip/effects_equip_0"..name_color..".ccbi" )
            self["effect_ccbi"..index] : setControlName( "this CCBI Create_effects_activity CCBI")
            self["effect_ccbi"..index] : registerControlScriptHandler( animationCallFunc)
            obj  : addChild(self["effect_ccbi"..index],1000)

            self : setSaveCreateEffectCCBIList(index,id)
        end
    end
end

function CReadEmailView.setSaveCreateEffectCCBIList ( self,index,id) 
    print("CReadEmailView 存表----",index,id)
    local data = {}
    data.index = index 
    data.id    = id 
    table.insert(self.CreateEffectsList,data)
    print("CReadEmailView 村表后的个数",#self.CreateEffectsList,self.CreateEffectsList)
end
function CReadEmailView.getSaveCreateEffectCCBIList ( self) 
    print("返回存储的ccbi数据",self.CreateEffectsList,#self.CreateEffectsList)
    return self.CreateEffectsList
end

function CReadEmailView.removeAllCCBI ( self) 
    print("CReadEmailView 开始调用删除CCBI")
    -- local data = self :getShowList() 
    local data = self :getSaveCreateEffectCCBIList() 
    print("1")
    if  data ~= nil then
        print("2")
        for k,goods in pairs(data) do
            print("3")
            --if tonumber(goods.goods_type) == 1 or tonumber(goods.goods_type)  == 2 then
                --local id = goods.goods_id
                local index = goods.index
                if  self["effect_ccbi"..index] ~= nil then
                    print("4")
                    self["effect_ccbi"..index] : removeFromParentAndCleanup(true)
                    self["effect_ccbi"..index] = nil 
                    print("CReadEmailView 删除了CCBI,其名为=========",index)
                end 
            --end
        end
    end
    self.CreateEffectsList = {} --删除后从新重置 存放创建ccbi的数据
end

