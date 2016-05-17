require "view/view"
require "common/Constant"

CArenaFinishView = class( view, function ( self , _res, _gold, _exp, _advSkill, _goods )
    CCLOG("竞技场结束界面")
    self.m_nRes = _res
    self.m_nGold = _gold --金钱
    self.m_nExp = _exp --经验
    self.m_nAdvSkill = _advSkill or 0 --潜能
    self.m_nPro = _G.Constant.CONST_PRO_SUNMAN
    self.m_lpGoods = _goods
    local property = _G.g_characterProperty : getMainPlay()
    self.m_nPro = property : getPro()
    self.m_nPro = self.m_nPro <= 0 and _G.Constant.CONST_PRO_SUNMAN or self.m_nPro

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("ChallengeResources/ChallengeResources.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("HeadIconResources/HeadIconResources.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("DuplicateResources/DuplicateResources.plist")


    self.m_backgroundMain = nil --底图 680*360
    self.m_background = nil --底图2

    self.m_sprite = nil --人物图

    if self.m_nRes == 0 then
        require "controller/GuideCommand"
        local _guideCommand = CGuideNoticCammand( CGuideNoticCammand.ADD, _G.Constant.CONST_LOGS_7000 )
        _G.controller:sendCommand(_guideCommand)

        if _G.pCSystemSettingProxy:getStateByType(_G.Constant.CONST_SYS_SET_MUSIC) == 1 then
            SimpleAudioEngine:sharedEngine():playEffect("Sound@mp3/match_lose.mp3", false)
        end
    else
        if _G.pCSystemSettingProxy:getStateByType(_G.Constant.CONST_SYS_SET_MUSIC) == 1 then
            SimpleAudioEngine:sharedEngine():playEffect("Sound@mp3/match_win.mp3", false)
        end
    end
end)

CArenaFinishView.FONT_NAME = "Marker Felt"
CArenaFinishView.FONT_SIZE24 = 24
CArenaFinishView.FONT_SIZE48 = 48
CArenaFinishView.BUTTON_OK = 100

function CArenaFinishView.scene( self )
    self.m_lpContainer = CCScene : create() -- 总层
    self : initView()
    self : layoutView()
    return self.m_lpContainer
end

--{返回一个层}
function CArenaFinishView.container( self )
    self.m_lpContainer = CContainer :create() -- 总层
    self.m_lpContainer : setControlName( "this is CArenaFinishView self.m_lpContainer 34" )
    self : initView()
    self : layoutView()
    return self.m_lpContainer
end

--初始化 成员
function CArenaFinishView.initView( self )
    local function CellCallBack( eventType, obj, x, y)
       return self : clickCellCallBack( eventType, obj, x, y)
    end
    --底图
    self.m_backgroundMain  = CSprite :createWithSpriteFrameName( "arena_underframe.png")

    self.m_backgroundMain : setControlName( "this CArenaFinishView self.m_backgroundMain 52 ")
    self.m_backgroundMain : setFullScreenTouchEnabled( true )

    --按钮
    self.m_button = CButton :createWithSpriteFrameName( "确认", "general_button_normal.png")
    self.m_button : setControlName( "this CArenaFinishView self.m_button 58 " )
    self.m_button : setTag( self.BUTTON_OK )
    self.m_button : registerControlScriptHandler( CellCallBack, "this CArenaFinishView self.m_button 59")
    self.m_button : setTouchesEnabled( true )
    self.m_backgroundMain : addChild( self.m_button )

    --人物图片
    self.m_sprite = CSprite : createWithSpriteFrameName("role_body_0"..tostring(self.m_nPro)..".png")
    self.m_sprite : setControlName( "this CArenaFinishView self.m_sprite 67 " )
    self.m_backgroundMain : addChild( self.m_sprite )

    -- --文字
    -- local str = ""
    -- if self.m_nRes == 1 then
    --     str = "恭喜您，获得决斗胜利！\n获得奖励:\n声望 +"..tostring(self.m_nRenown).."   美刀 +"..tostring(self.m_nGold)
    -- else
    --     str = "很抱歉，您的挑战失败了！\n获得奖励:\n声望 +"..tostring(self.m_nRenown).."   美刀 +"..tostring(self.m_nGold)
    -- end
    -- self.m_nString = CCLabelTTF : create( str , self.FONT_NAME , self.FONT_SIZE24 )
    -- self.m_backgroundMain : addChild( self.m_nString )
    --获得奖励文字下面的图片
    self.m_rewardSprite = CSprite : createWithSpriteFrameName("copy_dividing.png")
    self.m_backgroundMain : addChild( self.m_rewardSprite )

    --获得奖励文字
    self.m_rewardString = CCLabelTTF : create( "获得奖励" , self.FONT_NAME , self.FONT_SIZE24 )
    self.m_rewardSprite : addChild( self.m_rewardString )

    --美刀文字
    local goldstring = ""
    if self.m_nGold > 0 then
        goldstring = tostring(self.m_nGold).." 美刀"
    end
    self.m_goldString = CCLabelTTF : create( goldstring , self.FONT_NAME , self.FONT_SIZE24 )
    self.m_backgroundMain : addChild( self.m_goldString )

    --经验文字
    local expstring = ""
    if self.m_nExp > 0 then
        expstring = tostring(self.m_nExp).." 声望"
    end
    self.m_expString = CCLabelTTF : create( expstring , self.FONT_NAME , self.FONT_SIZE24 )
    self.m_backgroundMain : addChild( self.m_expString )

    --潜能文字
    local advSkillstring = ""
    if self.m_nAdvSkill > 0 then
        advSkillstring = tostring(self.m_nAdvSkill).." 潜能"
    end
    self.m_advSkillString = CCLabelTTF : create( advSkillstring , self.FONT_NAME , self.FONT_SIZE24 )
    self.m_backgroundMain : addChild( self.m_advSkillString )

    --物品1
    if self.m_lpGoods ~= nil and self.m_lpGoods[1] ~= nil then
        self.m_goodsBackgroundSprite1 = CSprite : createWithSpriteFrameName("general_props_underframe.png")
        local goodsSprite = self : getGoodsSprite(self.m_lpGoods[1].goodsID)
        self.m_goodsFrontSprite1 = CSprite : createWithSpriteFrameName("general_props_frame_normal.png")
        self.m_goodsBackgroundSprite1 : addChild( self.m_goodsFrontSprite1 )
        self.m_backgroundMain : addChild( self.m_goodsBackgroundSprite1 )
        if goodsSprite ~= nil then
            self.m_backgroundMain : addChild( goodsSprite )
        end
    end

    --物品2
    if self.m_lpGoods ~= nil and self.m_lpGoods[2] ~= nil then
        self.m_goodsBackgroundSprite2 = CSprite : createWithSpriteFrameName("general_props_underframe.png")
        local goodsSprite = self : getGoodsSprite(self.m_lpGoods[2].goodsID)
        self.m_goodsFrontSprite2 = CSprite : createWithSpriteFrameName("general_props_frame_normal.png")
        self.m_goodsBackgroundSprite2 : addChild( self.m_goodsFrontSprite2 )
        self.m_backgroundMain : addChild( self.m_goodsBackgroundSprite2 )
        if goodsSprite ~= nil then
            self.m_backgroundMain : addChild( goodsSprite )
        end
    end

    --物品3
    if self.m_lpGoods ~= nil and self.m_lpGoods[3] ~= nil then
        self.m_goodsBackgroundSprite3 = CSprite : createWithSpriteFrameName("general_props_underframe.png")
        local goodsSprite = self : getGoodsSprite(self.m_lpGoods[3].goodsID)
        self.m_goodsFrontSprite3 = CSprite : createWithSpriteFrameName("general_props_frame_normal.png")
        self.m_goodsBackgroundSprite3 : addChild( self.m_goodsFrontSprite3 )
        self.m_backgroundMain : addChild( self.m_goodsBackgroundSprite3 )
        if goodsSprite ~= nil then
            self.m_backgroundMain : addChild( goodsSprite )
        end
    end
    --标题
    local szWinSpritePath = "arena_title_win.png"
    if self.m_nRes ~= 1 then
        szWinSpritePath = "arena_title_lost.png"
    end
    self.m_winSprite = CSprite : createWithSpriteFrameName( szWinSpritePath )
    self.m_backgroundMain : addChild( self.m_winSprite )

    --标题2
    local path = "arena_word01.png"
    if self.m_nRes ~= 1 then
        path = "arena_word02.png"
    end
    self.m_winSprite2 = CSprite : createWithSpriteFrameName( path )
    self.m_backgroundMain : addChild( self.m_winSprite2 )


    self.m_lpContainer : addChild( self.m_backgroundMain )
end

--传入物品ID..返回Sprite
function CArenaFinishView.getGoodsSprite( self, _goodsID, _goodsNum )
    local goodnode = _G.g_GameDataProxy :getGoodById( _goodsID )
    local goodsSprite = nil
    if goodnode ~= nil then
        goodsSprite = CButton: create("Icon/i"..goodnode : getAttribute("icon")..".jpg")
    else
        goodsSprite = CButton: create("Icon/i1001.jpg")
    end
    return goodsSprite
end


--布局
function CArenaFinishView.layoutView( self )
--该界面不需要根据屏幕大小来调整
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    --主底图位置 和大小
    local mainBackgroundSize = CCSizeMake( 680, 360 )
    self.m_backgroundMain       : setPreferredSize( mainBackgroundSize )
    self.m_backgroundMain       : setPosition(  winSize.width/2, winSize.height/2 )

    --按钮位置
    local buttonSize = self.m_button : getPreferredSize()
    self.m_button               : setPosition( 0,0-mainBackgroundSize.height / 4 - 40)

    --人物图片
    local spriteSize = self.m_sprite : getPreferredSize()
    self.m_sprite : setPosition( 0 - mainBackgroundSize.width / 2, 0 )

    --获得奖励文字下面的图片
    local rewardSpriteSize = self.m_rewardSprite : getPreferredSize()
    self.m_rewardSprite : setPosition( -53, mainBackgroundSize.height / 4 )

    --获得奖励文字
    self.m_rewardString : setAnchorPoint( ccp(0,0.5) )
    self.m_rewardString : setPosition(0-rewardSpriteSize.width/2 + 25, 0)

    --美刀文字
    self.m_goldString : setAnchorPoint( ccp(0,0) )
    self.m_goldString : setPosition( -218,  mainBackgroundSize.height / 4 - 48 )
    --经验文字
    self.m_expString : setAnchorPoint( ccp(0,0) )
    self.m_expString : setPosition( -50,  mainBackgroundSize.height / 4 - 48 )
    --潜能
    self.m_advSkillString : setAnchorPoint( ccp(0,0) )
    self.m_advSkillString : setPosition( 120,  mainBackgroundSize.height / 4 - 48 )

    --物品
    if self.m_lpGoods ~= nil and self.m_lpGoods[1] ~= nil then
        self.m_goodsBackgroundSprite1 : setPosition( 0-mainBackgroundSize.width/4, 0 )
    end
    if self.m_lpGoods ~= nil and self.m_lpGoods[2] ~= nil then
        self.m_goodsBackgroundSprite2 : setPosition( 0 , 0)
    end
    if self.m_lpGoods ~= nil and self.m_lpGoods[3] ~= nil then
        self.m_goodsBackgroundSprite3 : setPosition( mainBackgroundSize.width/4, 0)
    end

    --标题
    local winSpriteSize = self.m_winSprite : getPreferredSize()
    self.m_winSprite : setPosition( 0, mainBackgroundSize.height/2 + winSpriteSize.height/2 - 3 )
    --胜负描述
    local winSprite2Size = self.m_winSprite2 : getPreferredSize()
    self.m_winSprite2 : setPosition( 0, mainBackgroundSize.height/2 - winSprite2Size.height / 2 -10 )

end

--事件响应
function CArenaFinishView.clickCellCallBack( self, eventType, obj, x, y )
    if eventType == "TouchBegan" then
        return true
    elseif eventType == "TouchEnded" then
        if obj:containsPoint( obj:convertToNodeSpaceAR( ccp( x, y ) ) ) then
            if obj : getTag() == self.BUTTON_OK then
                --确认
                self : clickOkButton()
            end
        end
    end
end


function CArenaFinishView.clickOkButton( self )
    _G.g_Stage : exitCopy()
end

