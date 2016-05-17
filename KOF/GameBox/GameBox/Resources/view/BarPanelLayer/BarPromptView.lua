--[[
 --CBarPromptView
 --酒吧伙伴弹窗主界面
 --]]


require "view/view"
require "mediator/mediator"
require "controller/command"
require "view/DuplicateLayer/DuplicateView"

CBarPromptView = class(view, function( self)
    print("CBarPromptView:角色信息主界面")
    self.m_tagLayout              = nil   --3种Tag按钮的水平布局
    self.m_barPromptContainer     = nil  --人物面板的容器层
end)

_G.pBarPromptView = CBarPromptView()
--Constant:

CBarPromptView.FONT_SIZE      = 20
CBarPromptView.TAG_ROLE_ICON  = 200

--加载资源
function CBarPromptView.loadResource( self)
    -- CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist") 
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("BarResources/BarResources.plist")
end
--释放资源
function CBarPromptView.unLoadResource( self)
end
--初始化数据成员
function CBarPromptView.initParams( self, layer)
    print("CBarPromptView.initParams")
end
--释放成员
function CBarPromptView.realeaseParams( self)
end

function CBarPromptView.reset( self)
    -- body
    if self.m_scenelayer ~= nil then
        print("XXXXXX删除Tips")
        self.m_scenelayer : removeFromParentAndCleanup( true)--removeFromParentAndCleanup( true )
        self.m_scenelayer = nil
    end   
end

--布局成员
function CBarPromptView.layout( self, winSize)
    --640
    if winSize.height == 640 then
        print("640--副本Tips界面5")
        local barpromptbackground    = self.m_barPromptContainer :getChildByTag( 100)
        local promptviewSize         = CCSizeMake( winSize.width*0.4, winSize.height*0.8) 
        local iconSize               = self.m_roleIconContainer :getChildByTag( CBarPromptView.TAG_ROLE_ICON) :getPreferredSize() 
        barpromptbackground :setPreferredSize( promptviewSize)        
        barpromptbackground :setPosition( ccp( winSize.width/2, winSize.height/2))

        self.m_roleIconContainer :setPosition( ccp( winSize.width/2-promptviewSize.width/2+iconSize.width/2+30, winSize.height/2+promptviewSize.height/2-iconSize.height/2-30))
        self.m_partnernameLabel :setPosition( ccp( winSize.width/2-30, winSize.height/2+promptviewSize.height/2-50))
        self.m_partnerlvLabel :setPosition( ccp( winSize.width/2-30, winSize.height/2+promptviewSize.height/2-90))
        self.m_lineSprite :setPosition( ccp( winSize.width/2, winSize.height/2-45))
        self.m_tagLayout :setPosition( winSize.width/2-promptviewSize.width/2-30, winSize.height/2+promptviewSize.height/2-iconSize.height-60)
        local cellLabelSize  = CCSizeMake( (promptviewSize.width-70)/2, (promptviewSize.height-iconSize.height-50)/11)
        self.m_tagLayout :setCellHorizontalSpace( 10)
        self.m_tagLayout :setCellVerticalSpace( 2)
        self.m_tagLayout :setCellSize( cellLabelSize)

    elseif winSize.height == 768 then
        CCLOG("768--角色信息主界面")
        
    end
end

--主界面初始化
function CBarPromptView.init(self, winSize, layer)
    print("viewID:",self._viewID)
    --加载资源
    self.loadResource(self)
    --初始化数据
    self.initParams(self,layer)
    --初始化界面
    self.initView(self, layer)
    --布局成员
    self.layout(self, winSize)  
end

function CBarPromptView.scene(self)
    print("create scene")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    --local _scene = CCScene :create()
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CBarPromptView self.m_scenelayer 94 ")
    self :init(winSize, self.m_scenelayer)
    print("scene--->",self._scene, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CBarPromptView.layer( self, _partnerid, _isrecruit)
    print("create m_scenelayer",_partnerid)
    self.m_uid       = _G.g_LoginInfoProxy :getUid()
    self.m_partnerid = _partnerid
    self.m_isrecruit = _isrecruit
    --根据是否招募，选择从XML拿属性还是缓存拿数据
    --add:
    self :getPartnerInfo( self.m_partnerid)
    ---------------------------------------
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    --self.m_scenelayer :setFullScreenTouchEnabled( true)
    --self.m_scenelayer :setTouchesEnabled(true)
    self.m_scenelayer : setControlName("this is CBarPromptView self.m_scenelayer 105 ")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

function CBarPromptView.getPartnerInfo( self, _partnerid)
    local _partnerid = tostring( _partnerid)
    local partner_inits_temp = _G.Config.partner_init_temp : selectSingleNode("partner_inits[0]")
    local partnerinfo = partner_inits_temp : selectSingleNode("partner_init[@id=".._partnerid.."]")    
    print( "partnerinfo",partnerinfo)
    local child = partnerinfo : children()
    self.m_skillname   = {}
    self.m_partnerinfo = {}
    self.m_partnerinfo.partner_name = partnerinfo : getAttribute("partner_name")
    self.m_partnerinfo.head = "01"
    if partnerinfo : getAttribute("head") ~= "10001" then
        self.m_partnerinfo.head = partnerinfo : getAttribute("head") 
    end

    self.m_lv          = "LV 1级"
    if self.m_isrecruit == true then --已招募取缓存数据local nextnode = child : get(0,"attr")
        print("DDDDDDD:",  self.m_partnerid, self.m_uid)
        local index = tostring( self.m_uid)..tostring( self.m_partnerid)
        print("index:",index)
        mainplay = _G.g_characterProperty :getOneByUid( index, _G.Constant.CONST_PARTNER)
        local mainplaypvp = mainplay :getAttr()
        self.m_lv                            = "LV "..mainplay :getLv().."级"
        self.m_partnerinfo.hp           = mainplaypvp :getHp()
        self.m_partnerinfo.shinwakan    = mainplaypvp :getStrong() --
        self.m_partnerinfo.strong_att   = mainplaypvp :getStrongAtt()
        self.m_partnerinfo.strong_def   = mainplaypvp :getStrongDef()
        self.m_partnerinfo.skill_att    = mainplaypvp :getSkillAtt()
        self.m_partnerinfo.skill_def    = mainplaypvp :getSkillDef()
        self.m_partnerinfo.hp_gro       = mainplaypvp :getMagic() --
    else
        self.m_partnerinfo.hp           = child : get(0, "a") : getAttribute("hp")
        self.m_partnerinfo.shinwakan    = partnerinfo : getAttribute("shinwakan") --
        self.m_partnerinfo.strong_att   = child : get(0, "a") : getAttribute("strong_att")
        self.m_partnerinfo.strong_def   = child : get(0, "a") : getAttribute("strong_def")
        self.m_partnerinfo.skill_att    = child : get(0, "a") : getAttribute("skill_att")
        self.m_partnerinfo.skill_def    = child : get(0, "a") : getAttribute("skill_def")
        self.m_partnerinfo.hp_gro       = child : get(0, "a") : getAttribute("hp_gro")
    end
    
    local temp = child : get(0, "skill_idss")
    _G.Config:load("config/skill.xml")
    --local skill_list = partnerinfo.skill_idss[1].skill_ids
    self.m_skillnumber = temp : children() : getCount("skill_ids") --#partnerinfo.skill_idss[1].skill_ids
    for i=1,self.m_skillnumber do
        print("+++++++++++++===========")
        local skillnode =  temp : children() : get(i-1,"skill_ids")
        local skill_id   = skillnode : getAttribute("skill_id") --skill_list[i].skill_id
        local skill_lv   = skillnode : getAttribute("lv") --skill_list[i].lv
        print( "skill_id: "..skill_id)

        local skillinfo = _G.Config.skills :selectSingleNode( "skill[@id="..skill_id.."]")
        if skillinfo : isEmpty()  then
            self.m_skillname[i] = "error：没有找到技能"
        else
            self.m_skillname[i]  = skillinfo : getAttribute("name") 
        end
        --print(i, skill_id, skill_lv, partnerinfo.partner_name,skillinfo.name)
    end
    print("+++++++++++++===========")
    --return partnerinfo
end

--_string   字段名   默认 ""
--_value    字段值   默认 ""
--_color    颜色值   默认 白色
--_fontsize 字体大小 默认 CBarPromptView.FONT_SZIE
function CBarPromptView.createPartnerInfo( self, _string, _value, _color, _fontsize)
    --print( _string.." ".._value)
    if _string == nil then
        _string = ""
    end
    if _value == nil then
        _value = ""
    end
    if _fontsize == nil then
        _fontsize = CBarPromptView.FONT_SIZE
    end
    local rewardLabel = CCLabelTTF :create( _string.." ".._value, "Arial", _fontsize)
    if _color ~= nil then
        rewardLabel :setColor( _color)
    end
    rewardLabel :setAnchorPoint( ccp(0,0.5))
    return rewardLabel
end

function CBarPromptView.createSprite( self, _image, _controlname, _flag)
    local spriteimage = nil
    if _flag == true then
        spriteimage = CSprite :create( _image)
    else
        spriteimage = CSprite :createWithSpriteFrameName( _image)
    end
    spriteimage : setControlName( "this CBarPromptView createSprite ".._controlname)
    --spriteimage :setAnchorPoint( ccp( 0,1))
    return spriteimage
end

function CBarPromptView.createRoleIcon( self )
    print("CGoodsInfoView.createRoleIcon")
    --加载装备图片，背景图，边框
    local rolecontainer = CContainer :create()
    rolecontainer : setControlName("this is CBarPromptView rolecontainer 158 ")
    --角色头像背景
    local background    = CSprite :createWithSpriteFrameName( "general_role_head_underframe.png")
    background : setControlName( "this CBarPromptView background 160 ")
    rolecontainer :addChild( background)  
    --角色头像
    local backgroundsize = background :getPreferredSize()
    local imgname            = "HeadIconResources/role_head_"..self.m_partnerinfo.head..".jpg"--tostring(math.mod( _role : getAttribute("id,4") id,4)+1)
    print("imgnamea:",imgname)
    local roleIconSprite = self :createSprite( imgname, "roleIconSprite", true)
    roleIconSprite :setTag( CBarPromptView.TAG_ROLE_ICON)
    rolecontainer :addChild( roleIconSprite)        
    --角色头像外框
    local roleframe = CSprite :createWithSpriteFrameName( "general_role_head_frame_click.png")
    roleframe : setControlName( "this CBarPromptView roleframe 160 ")
    rolecontainer :addChild( roleframe) 
    return rolecontainer
end


--初始化背包界面
function CBarPromptView.initView(self, layer)
    print("CBarPromptView.initView")
    --副本界面容器
    self.m_barPromptContainer = CContainer :create()
    self.m_barPromptContainer : setControlName("this is CBarPromptView self.m_barPromptContainer 94 ")
    layer :addChild( self.m_barPromptContainer)
    
    local barpromptbackground   = self :createSprite( "general_tips_underframe.png", "barpromptbackground") 
    self.m_lineSprite           = self :createSprite( "general_tips_line.png", "self.m_lineSprite")
    self.m_roleIconContainer    = self :createRoleIcon( ) 

    self.m_partnerlvLabel       = self :createPartnerInfo( self.m_lv, nil, ccc3(255,0,0), CBarPromptView.FONT_SIZE+5)
    self.m_partnernameLabel     = self :createPartnerInfo( self.m_partnerinfo.partner_name, nil, ccc3(255,0,0), CBarPromptView.FONT_SIZE+5)

    self.m_tagLayout     = CHorizontalLayout :create()
    self.m_tagLayout :setVerticalDirection(false)
    self.m_tagLayout :setLineNodeSum(2)

    self.m_tagLayout :addChild( self :createPartnerInfo( "气血: ", self.m_partnerinfo.hp)) 
    self.m_tagLayout :addChild( self :createPartnerInfo( "敏捷: ", self.m_partnerinfo.shinwakan))
    self.m_tagLayout :addChild( self :createPartnerInfo( "物攻: ", self.m_partnerinfo.strong_att)) 
    self.m_tagLayout :addChild( self :createPartnerInfo( "物防: ", self.m_partnerinfo.strong_def))
    self.m_tagLayout :addChild( self :createPartnerInfo( "技攻: ", self.m_partnerinfo.skill_att)) 
    self.m_tagLayout :addChild( self :createPartnerInfo( "技防: ", self.m_partnerinfo.skill_def))
    self.m_tagLayout :addChild( self :createPartnerInfo( "成长: ", self.m_partnerinfo.hp_gro)) 
    self.m_tagLayout :addChild( self :createPartnerInfo())
    self.m_tagLayout :addChild( self :createPartnerInfo())
    self.m_tagLayout :addChild( self :createPartnerInfo())
    self.m_tagLayout :addChild( self :createPartnerInfo( "技能: "))--self.m_partnerinfo.skill_ids
    for i=1,self.m_skillnumber do
        self.m_tagLayout :addChild( self :createPartnerInfo())
        self.m_tagLayout :addChild( self :createPartnerInfo( "           "..self.m_skillname[i]))         
    end     

    self.m_barPromptContainer :addChild( self.m_tagLayout)
    self.m_barPromptContainer :addChild( self.m_roleIconContainer)
    self.m_barPromptContainer :addChild( self.m_partnernameLabel)
    self.m_barPromptContainer :addChild( self.m_partnerlvLabel) 
    self.m_barPromptContainer :addChild( self.m_lineSprite)
    self.m_barPromptContainer :addChild( barpromptbackground, -1, 100)
        
end

--更新本地list数据
function CBarPromptView.setLocalList( self)
    print("CBarPromptView.setLocalList")
end

-----------------------------------------------------
--回调函数
----------------------------------------------------
--BUTTON类型切换buttonCallBack
--单击回调
function CBarPromptView.clickCellCallBack(self,eventType, obj, x, y)   
    if eventType == "TouchBegan" then
        return true
    elseif eventType == "TouchEnded" then
        if obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) ) == true then
            print("obj: getTag()", obj: getTag())
            if obj :getTag() == CBarPromptView.TAG_CLOSED then
                print("关闭")
                if _G.pBarPromptView ~= nil then
                    _G.pBarPromptView :reset()
                    --_G.pDuplicatePromptView = nil
                else
                    print("objSelf = nil", self)
                end
            end 
        end
    end
end





















