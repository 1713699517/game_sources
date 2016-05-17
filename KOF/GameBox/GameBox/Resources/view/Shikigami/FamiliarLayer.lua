
require "controller/command"

require "view/view"

require "mediator/FamiliarLayerMediator"

CFamiliarLayer = class(view,function (self)
                          end)

CFamiliarLayer.TAG_CallBtn         = 1
CFamiliarLayer.TAG_PracticeBtn     = 2
CFamiliarLayer.TAG_HighPracticeBtn = 3

CFamiliarLayer.TYPE_Practice     = 1
CFamiliarLayer.TYPE_HighPractice = 2

CFamiliarLayer.PETID   = 50001

function CFamiliarLayer.scene(self)
    local winSize    = CCDirector:sharedDirector():getVisibleSize()
    self.IpadSize    = 854
    self.scene       = CCScene :create()
    self.Scenelayer  = CContainer :create()
    self.scene       : addChild(self.Scenelayer)
    self.scene       : addChild(self : layer(winSize)) --scene的layer层    
    return self.scene
end

function CFamiliarLayer.layer(self)
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    self.Scenelayer    = CContainer :create()
    self : init (winSize,self.Scenelayer)   
    return self.Scenelayer
end

function CFamiliarLayer.loadResources(self)

    
end

function CFamiliarLayer.layout(self, winSize)  --适配布局
    local IpadSize = 854
    if winSize.height == 640 then

        self.m_leftBackGround     : setPosition(270,358)    --左底图
        self.m_leftdownBackGround : setPosition(270,80)     --左底图
        self.m_rightBackGround    : setPosition(680,290)    --右底图
    elseif winSize.height == 768 then
        print("768 768")
    end
end

function CFamiliarLayer.init(self, _winSize, _layer)
    -- self : loadResources()                       --资源初始化
    self : initView(_winSize,_layer)             --界面初始化
    self : layout(_winSize)                      --适配布局初始化
    self : initParameter()                       --参数初始化
end

function CFamiliarLayer.initParameter(self)
    self : registerMediator()  ----mediator注册
    self : REQ_PET_REQUEST () --宠物列表 
end

function CFamiliarLayer.initView(self,_winSize,_layer)

    self.m_leftBackGround     = CCScale9Sprite : createWithSpriteFrameName("general_second_underframe.png") --左底图
    self.m_leftdownBackGround = CCScale9Sprite : createWithSpriteFrameName("general_second_underframe.png") --左底图
    self.m_rightBackGround    = CCScale9Sprite : createWithSpriteFrameName("general_second_underframe.png") --右底图

    self.m_leftBackGround     : setPreferredSize(CCSizeMake(440,410)) 
    self.m_leftdownBackGround : setPreferredSize(CCSizeMake(440,130)) 
    self.m_rightBackGround    : setPreferredSize(CCSizeMake(370,550)) 

    _layer : addChild(self.m_leftBackGround)
    _layer : addChild(self.m_leftdownBackGround)
    _layer : addChild(self.m_rightBackGround)

    local function CallBack(eventType, obj, x, y)
       return self : CallBack(eventType,obj,x,y)
    end
    ----头像框
    self.PeopleImageBox = CSprite : createWithSpriteFrameName("pet_frame.png")
    self.PeopleImageBox : setPosition(150,395)
    _layer              : addChild(self.PeopleImageBox)
    --描述
    self.PeopleNameLabel   = CCLabelTTF : create("式神名称 : 天地会陈进南","Arial",18)
    self.PeopleSkillLabel  = CCLabelTTF : create("技能名称 : 动感光波哔哔","Arial",18)   
    self.SkillDescripLabel = CCLabelTTF : create("技能效果 :\n拥有毁天灭地的让人内裤小时的超级无敌技能拥有毁天灭地的让人内裤小时的超级无敌技能拥有毁天灭地的让人内裤小时的超级无敌技能","Arial",18)  

    self.PeopleNameLabel    : setAnchorPoint( ccp( 0, 0.5 ) )
    self.PeopleSkillLabel   : setAnchorPoint( ccp( 0, 0.5 ) )
    self.SkillDescripLabel  : setAnchorPoint( ccp( 0, 0.5 ) )
    self.SkillDescripLabel  : setHorizontalAlignment(kCCTextAlignmentLeft) --左对齐 
    self.SkillDescripLabel  : setDimensions( CCSizeMake(210,210))          --设置文字区域
    self.PeopleNameLabel    : setColor(ccc3(255,255,0))
    self.PeopleSkillLabel   : setColor(ccc3(255,255,0))

    self.PeopleNameLabel    : setPosition(110,130) 
    self.PeopleSkillLabel   : setPosition(110,100)  
    self.SkillDescripLabel  : setPosition(110,-25)  

    self.PeopleImageBox : addChild(self.PeopleNameLabel)
    self.PeopleImageBox : addChild(self.PeopleSkillLabel)
    self.PeopleImageBox : addChild(self.SkillDescripLabel)
    --召唤按钮
    self.CallBtn = CButton : createWithSpriteFrameName("召唤","general_button_normal.png")
    self.CallBtn : setTag(CFamiliarLayer.TAG_CallBtn)
    self.CallBtn : registerControlScriptHandler(CallBack,"this CFamiliarLayer CallBtn CallBack ")
    self.CallBtn : setPosition(150,200) 
    self.CallBtn : setFontSize(24)
    _layer : addChild (self.CallBtn) 
    ---小伙伴----------------------------------------------
    -- local m_ViewSize      = CCSizeMake(410,120)
    -- self.m_pScrollView    = CPageScrollView :create(1,m_ViewSize)
    -- self.m_pScrollView    : setTouchesPriority(1)
    -- self.m_pScrollView    : setPosition(65,20)
    -- _layer                : addChild(self.m_pScrollView)

    -- self.teamerlayout     = {}
    -- self.TeamerBox        = {} --小伙伴按钮
    -- for i=1,2 do
    --     local pageContiner = CContainer : create()
    --     pageContiner       : setControlName( "this is CEquipComposeLayer pageContiner 183" )
    --     self.m_pScrollView : addPage(pageContiner)
       
    --     self.teamerlayout[i] = CHorizontalLayout : create()
    --     self.teamerlayout[i] : setPosition(-200,0)
    --     self.teamerlayout[i] : setLineNodeSum(4)
    --     self.teamerlayout[i] : setCellSize(CCSizeMake(100,100))
    --     self.teamerlayout[i] : setVerticalDirection(false)
    --     pageContiner      : addChild(self.teamerlayout[i],10)

    --     for w=1,4 do
    --         self.TeamerBox[w]    = CSprite : createWithSpriteFrameName("general_role_head_frame_normal.png")
    --         self.teamerlayout[i] : addChild( self.TeamerBox[w] )    
    --     end
    -- end
    -------------------------------------------------
    self.FamiliarLvLabel   = CCLabelTTF : create("魔宠等级 : 9999","Arial",18)
    self.FamiliarLvSprite  = CSprite : createWithSpriteFrameName("pet_line.png")
    self.FamiliarLvLabel   : setPosition(75,520)
    self.FamiliarLvSprite  : setPosition(180,520)    
    self.m_rightBackGround : addChild(self.FamiliarLvLabel)
    self.m_rightBackGround : addChild(self.FamiliarLvSprite)
    --进度条
    self.frameExpLabel     = CCLabelTTF : create("经验 :                   100/2000","Arial",18)
    self.frameExpLabel     : setAnchorPoint( ccp( 0,0.5 ) )
    self.frameExpLabel     : setPosition(25,470) 
    self.m_rightBackGround : addChild(self.frameExpLabel,5) 

    -- if  self.frame == nil then
    --     print("self.frame建立了了")
    --     self.frame      = CSprite : createWithSpriteFrameName("equip_exp_frame_short.png")
    --     self.frame      : setPosition(210,470)  
    --     self.m_rightBackGround : addChild(self.frame)

    --     local frameSize = self.frame : getPreferredSize()
    --     local exp       = CSprite : createWithSpriteFrameName( "role_exp.png",CCRectMake( 11, 0, 1 , 21)) 
    --     self.frame      : addChild(exp,10) 
    --     local value  =236
    --     --local value  = math.floor(fumoz/nextstep_value*(236-18)) + 18
    --     exp             : setPreferredSize( CCSizeMake(value , 21)) --18 ～236
    --     local sprSize   = exp : getPreferredSize()
    --     exp             : setPosition(-(frameSize.width/2 - sprSize.width/2)+4,0)
    -- end
    --当前属性
    self.NowPropeBtn     = CButton : createWithSpriteFrameName("","pet_word_dqsx.png")
    self.NowPropeSprite  = CSprite : createWithSpriteFrameName("equip_strengthen_underframe.png")
    self.NowBloodLabel   = CCLabelTTF : create("","Arial",18)
    self.NowBloodLabel   : setColor(ccc3(255,0,0))

    self.NowPropelayout = CHorizontalLayout : create()
    self.NowPropelayout : setLineNodeSum(2)
    self.NowPropelayout : setCellSize(CCSizeMake(180,30))
    self.NowPropelayout : setVerticalDirection(false)

    self.NowPropeBtn     : setPosition(185,435)
    self.NowPropeSprite  : setPosition(0,5)
    self.NowPropelayout  : setPosition(-180,-40)
    self.NowBloodLabel   : setPosition(0,-100)

    self.m_rightBackGround : addChild(self.NowPropeBtn)
    self.NowPropeBtn       : addChild(self.NowPropeSprite,-1)
    self.NowPropeBtn       : addChild(self.NowPropelayout)
    self.NowPropeBtn       : addChild(self.NowBloodLabel)

    self.NowPropeLabel = {}
    for i=1,4 do
        self.NowPropeLabel[i] = CCLabelTTF : create("","Arial",18)
        self.NowPropelayout : addChild(self.NowPropeLabel[i])
    end

    --升级属性
    self.UpgradePropeBtn     = CButton : createWithSpriteFrameName("","pet_word_sjsx.png")
    self.UpgradePropeSprite  = CSprite : createWithSpriteFrameName("equip_strengthen_underframe.png")
    self.ArrowSprite         = CSprite : createWithSpriteFrameName("equip_arrow_down.png")
    self.UpgradeBloodLabel   = CCLabelTTF : create("","Arial",18)
    self.UpgradeBloodLabel   : setColor(ccc3(255,0,0))

    self.UpgradePropelayout = CHorizontalLayout : create()
    self.UpgradePropelayout : setLineNodeSum(2)
    self.UpgradePropelayout : setCellSize(CCSizeMake(180,30))
    self.UpgradePropelayout : setVerticalDirection(false)

    self.UpgradePropeBtn     : setPosition(185,235)
    self.UpgradePropeSprite  : setPosition(0,5)
    self.ArrowSprite         : setPosition(0,55)
    self.UpgradePropelayout  : setPosition(-180,-40)
    self.UpgradeBloodLabel   : setPosition(0,-100)

    self.m_rightBackGround : addChild(self.UpgradePropeBtn)
    self.UpgradePropeBtn   : addChild(self.UpgradePropeSprite,-1)
    self.UpgradePropeBtn   : addChild(self.ArrowSprite)
    self.UpgradePropeBtn   : addChild(self.UpgradePropelayout)
    self.UpgradePropeBtn   : addChild(self.UpgradeBloodLabel)

    self.UpgradePropeLabel = {}
    for i=1,4 do
        self.UpgradePropeLabel[i] = CCLabelTTF : create("","Arial",18)
        self.UpgradePropelayout : addChild(self.UpgradePropeLabel[i])
    end

    self.PracticeBtn     = CButton : createWithSpriteFrameName("修炼","general_button_normal.png")
    self.HighPracticeBtn = CButton : createWithSpriteFrameName("高级修炼","general_button_normal.png")
    self.SoulStoneLabel  = CCLabelTTF : create("当前拥有灵魂石 : 9999999","Arial",18)

    self.PracticeBtn     : setTag(CFamiliarLayer.TAG_PracticeBtn)
    self.HighPracticeBtn : setTag(CFamiliarLayer.TAG_HighPracticeBtn)
    self.PracticeBtn     : registerControlScriptHandler(CallBack,"this CFamiliarLayer CallBtn CallBack ") 
    self.HighPracticeBtn : registerControlScriptHandler(CallBack,"this CFamiliarLayer CallBtn CallBack ") 

    self.PracticeBtn     : setPosition(100,50)
    self.HighPracticeBtn : setPosition(270,50)
    self.SoulStoneLabel  : setPosition(185,100)    

    self.PracticeBtn     : setFontSize(24)
    self.HighPracticeBtn : setFontSize(24)
    self.SoulStoneLabel  : setColor(ccc3(255,255,0))  

    self.m_rightBackGround : addChild(self.PracticeBtn)
    self.m_rightBackGround : addChild(self.HighPracticeBtn)
    self.m_rightBackGround : addChild(self.SoulStoneLabel)
end

function CFamiliarLayer.CallBack(self,eventType,obj,x,y)   --Page页面按钮回调
   if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        local TagValue = obj : getTag()
        if TagValue == CFamiliarLayer.TAG_CallBtn then
            print("召唤按钮回调")
            if self.CallTransId ~= nil then
                local id = self.CallTransId
                self : REQ_PET_CALL(id)
            end
        elseif TagValue == CFamiliarLayer.TAG_PracticeBtn then
            print("修炼按钮回调")
            self.NowBtnType = CFamiliarLayer.TYPE_Practice
            self : REQ_PET_NEED_RMB(CFamiliarLayer.TYPE_Practice)       -- (手动) -- [22870]修炼还需要的钻石数 -- 宠物 
        elseif TagValue == CFamiliarLayer.TAG_HighPracticeBtn then
            print("高级修炼按钮回调")
            self.NowBtnType = CFamiliarLayer.TYPE_HighPractice
            self : REQ_PET_NEED_RMB(CFamiliarLayer.TYPE_HighPractice)   -- (手动) -- [22870]修炼还需要的钻石数 -- 宠物 
        end
    end
end
--多点触控
function CFamiliarLayer.TeamCallBack(self, eventType, obj, touches)
    print("viewTouchesCallback eventType",eventType, obj :getTag(), touches,self.touchID,"obj==",obj)

    if eventType == "TouchesBegan" then
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
            if obj:getTag() > 0 then
                local touchPoint = touch :getLocation()
                if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                    self.touchID = touch :getID()
                    self.TeamTransId = tonumber(obj:getTag()) 
                    print( "XXXXXXXXSs"..self.touchID,obj:getTag(),obj)
                    break
                end
            end
        end
    elseif eventType == "TouchesEnded" then
        if self.touchID == nil then
           return
        end
 
        local touchesCount2 = touches:count()
        for i=1, touchesCount2 do
            local touch2 = touches :at(i - 1)
            if touch2:getID() == self.touchID and self.TeamTransId == obj:getTag() then
                local touch2Point = touch2 :getLocation()
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10  then
                  
                    local value = obj:getTag()
                    self : createPeopleImageAndSetData(value)
                    self : changeBoxSprite(value) --改变box框框
                    print("小伙伴的回调",value)

                    self.TeamTransId = nil
                    self.touchID     = nil
                end
            end
        end
    end
end


function CFamiliarLayer.changeBoxSprite(self,TAG_value)
    if self.oldTAG_value ~= nil then
       self.TeamerBox[self.oldTAG_value] : setImageWithSpriteFrameName("general_role_head_frame_normal.png" )
    end
    if self.TeamerBox[TAG_value] ~= nil then
        self.TeamerBox[TAG_value] : setImageWithSpriteFrameName( "general_role_head_frame_click.png" )
        self.oldTAG_value         = TAG_value
    end
end

function CFamiliarLayer.createPeopleImageAndSetData(self,TAG_value)
    local no = tonumber(TAG_value)
    if self.PeopleImage ~= nil then
        self.PeopleImage : removeFromParentAndCleanup(true)
        self.PeopleImage = nil  
    end

    if  self.PeopleImageBox ~= nil and no ~= nil and  no > 0 then

        local icon_url   = "HeadIconResources/worldBoss_boss_picture_0"..no..".png"
        self.PeopleImage = CSprite : create(icon_url)   
        self.PeopleImageBox : addChild(self.PeopleImage,-1)  
    end
    if self.teamData ~= nil and no ~= nil and  no > 0  then
        local data = self.teamData[no]
        self.PeopleNameLabel   : setString("式神名称 : "..data.pet_name)
        if data.name == nil then
            self.PeopleSkillLabel  : setString("无技能")
        else
            self.PeopleSkillLabel  : setString("技能名称 : "..data.name)
        end
        if data.remark == nil then
            self.SkillDescripLabel : setString("")
        else
            self.SkillDescripLabel : setString("技能效果 : \n"..data.remark)
        end
        if data.skill_id ~= nil then
            self.CallTransId = data.skill_id
            self.CallTransNo = no
        end
    end 

end


function CFamiliarLayer.pushData(self,Lv,SkinId,SkillId,Exp,Count,MsgSkill,Count2,MsgSkin) --sever methond
    self.petData  = {}
    self.petData  = self : getPetDataFromXml(Lv,Count2,MsgSkin)         --获取宠物信息数据
    self.teamData = self : getm_pScrollViewDataFromXml (Count2,MsgSkin) --获取式神数据

    if self.teamData ~= nil then
        local count = tonumber(self.teamData.count) 
        if  count > 4 then
            self : initm_pScrollView(count)
        else
            self : initm_pScrollView(4)
        end
    end

    self : initm_pScrollViewData()         --初始化ScrollView 数据

    self : initViewData (Exp,Lv)           --填充魔宠属性数据

    self : DefultFirstOne(SkinId,SkillId) --默认第一个
end

function CFamiliarLayer.DefultFirstOne(self,SkinId,SkillId) --默认第一个
    local value = nil 
    if self.teamData ~= nil then
        local data  = self.teamData 
        local count = tonumber(self.teamData.count)
        for i=1,count do
            if tonumber(data[i].skill_id) == tonumber(SkillId) then
                value = i 
            end 
        end 
    end
    if value ~= nil then
        self : createPeopleImageAndSetData(value)
        self : changeBoxSprite(value) --改变box框框
        print ("默认 value",value)
        self.TeamerBtn[value] : setDefault()
    end
end

function CFamiliarLayer.initm_pScrollViewData( self )

    local function TeamCallBack(eventType, obj, touches)
        return self : TeamCallBack(eventType, obj, touches)
    end   
    self.TeamerBtn = {}
    if self.teamData ~= nil then
        local data  = self.teamData
        local count = tonumber(self.teamData.count)  
        if self.TeamerBox ~= nil then
            for i=1,count do
                local icon_url    = "HeadIconResources/role_head_0"..i..".jpg" 
                self.TeamerBtn[i] = CButton : create("",icon_url)
                self.TeamerBtn[i] : setTag(i)
                self.TeamerBtn[i] : setTouchesMode( kCCTouchesAllAtOnce )
                self.TeamerBtn[i] : setGray(true)                 
                self.TeamerBtn[i] : registerControlScriptHandler(TeamCallBack,"this CFamiliarLayer TeamCallBack CallBack ") 
                self.TeamerBox[i] : addChild (self.TeamerBtn[i],-1)
            end
        end
    end
end

function CFamiliarLayer.initm_pScrollView(self,_allcount)
    self.m_pageCount, self.m_lastPageCount = self : getPageAndLastCount(_allcount,4)

    local m_ViewSize      = CCSizeMake(410,120)
    self.m_pScrollView    = CPageScrollView :create(1,m_ViewSize)
    self.m_pScrollView    : setTouchesPriority(1)
    self.m_pScrollView    : setPosition(65,20)
    self.Scenelayer       : addChild(self.m_pScrollView)

    --self.teamerlayout     = {}
    self.TeamerBox        = {} --小伙伴按钮
    local pageContiner    = {}
    for i = tonumber(self.m_pageCount),1,-1 do
        pageContiner[i]    = CContainer : create()
        pageContiner[i]    : setControlName( "this is CEquipComposeLayer pageContiner 183" )
        --self.m_pScrollView : addPage(pageContiner[i])
       
        self.teamerlayout = CHorizontalLayout : create()
        self.teamerlayout : setPosition(-200,0)
        self.teamerlayout : setLineNodeSum(4)
        self.teamerlayout : setCellSize(CCSizeMake(100,100))
        self.teamerlayout : setVerticalDirection(false)
        pageContiner[i]   : addChild(self.teamerlayout,10)

        if i == tonumber(self.m_pageCount) then
            local  tempnum = tonumber(self.m_lastPageCount)
            for j=1,tempnum do
                num = (i-1)*4 +j 
                self.TeamerBox[num] = CSprite : createWithSpriteFrameName("general_role_head_frame_normal.png")
                self.teamerlayout   : addChild( self.TeamerBox[num] )  
            end
        else
            local  tempnum = 4
            num = (i-1)*4 +j
            self.TeamerBox[num] = CSprite : createWithSpriteFrameName("general_role_head_frame_normal.png")
            self.teamerlayout   : addChild( self.TeamerBox[num] )             
        end
    end
    for k = tonumber(self.m_pageCount),1,-1 do
        self.m_pScrollView : addPage(pageContiner[k])  
    end
end

function CFamiliarLayer.getPageAndLastCount( self, _allcount, _PER_PAGE_COUNT)

    local pageCount     = math.floor( _allcount/_PER_PAGE_COUNT)+1         --页数
    if math.mod( _allcount,_PER_PAGE_COUNT) == 0 and _allcount ~= 0 then
         pageCount = pageCount -1
    end
    local lastPageCount = math.mod( _allcount-1,_PER_PAGE_COUNT)+1         --最后一页个数

    return pageCount,lastPageCount
end

function CFamiliarLayer.getm_pScrollViewDataFromXml(self,Count2,MsgSkin)
    print("getm_pScrollViewDataFromXml===",Count2)
    local count    = tonumber(Count2)
    local teamData = {} 
    if count ~= nil and count > 0 then
        teamData.count = count
        for i=1,count do
            teamData[i]   = {}
            local skin_id = nil 
            local Node    = nil 
            if MsgSkin ~= nil then
                skin_id = MsgSkin[i]
                print("skin_id=====",skin_id)
            end
            if skin_id ~= nil then 
                print("3333")
                teamData[i].skin_id = skin_id
                --local Node  =  _G.Config.pet_skills : selectNode("pet_skill","unreal_skin",tostring(skin_id)) --宠物技能表 通过皮肤ID拿技能id
                local Node  =  _G.Config.pet_skills : selectSingleNode("pet_skill[@unreal_skin="..tostring(skin_id).."]") --宠物技能表 通过皮肤ID拿技能id
                
                if Node : isEmpty() == false then
                    --print("444Node.pet_name",Node.pet_name)
                    local skill          = tonumber(Node : getAttribute("skill")) 
                    local skill_lv       = tonumber(Node : getAttribute("lv"))  --技能等级 此字段能在拿技能的等级描述中起作用 
                    teamData[i].skill_lv = Node : getAttribute("lv")
                    teamData[i].pet_name = Node : getAttribute("pet_name")
                    if skill == 0 then
                        teamData[i].skill_id = 0
                        teamData[i].name     = nil
                        teamData[i].remark   = nil
                    else
                        print("555",skill,skill_lv)
                        --local SkillNode = _G.Config.skills : selectNode("skill","id",tostring(skill)) --技能id 拿技能信息
                        local SkillNode = _G.Config.skills : selectSingleNode("skill[@id="..tostring(skill).."]") --技能id 拿技能信息
                        local SkillNode_lvs = SkillNode : children() : get(0,"lvs")
                        local SkillNode_lvsCount = SkillNode_lvs : children() : getCount("lv")
                        --print("---->>>>",SkillNode.id,SkillNode.name,i,SkillNode.lvs[1].lv)
                        teamData[i].skill_id = SkillNode : getAttribute("id")
                        teamData[i].name     = SkillNode : getAttribute("name")
                        
                        if tonumber(SkillNode_lvsCount) > 0 then
                            for k=0,SkillNode_lvsCount-1 do
                                local SkillNode_lvs_lv = SkillNode_lvs : children() : get(k,"lv")
                                if tonumber(SkillNode_lvs_lv : getAttribute("lv")) == skill_lv then
                                     teamData[i].remark = SkillNode_lvs_lv : getAttribute("remark") 
                                     print("技能描述  ==",teamData[i].remark)
                                     break 
                                end
                            end
                        end

                        -- skillDescr       = SkillNode.lvs[1].lv --技能中的等级节点
                        -- if skillDescr ~= nil then
                        --     for k,v in pairs(skillDescr) do
                        --         if tonumber(v.lv)  == skill_lv then
                        --             teamData[i].remark = v.remark 
                        --              print("技能描述  ==",v.remark)
                        --         end
                        --     end
                        -- end

                    end
                end
            end 
        end   
    end
    return teamData
end

function CFamiliarLayer.initViewData(self,Exp,Lv)  --填充View数据
    if self.petData ~= nil then
        local data  = self.petData
        self.FamiliarLvLabel : setString("魔宠等级 : "..data.lv.."级")   
        if Exp ~= nil then
            self.frameExpLabel : setString("经验 :                   "..Exp.."/"..data.next_exp)
            self : createframe(Exp,data.next_exp)  --创建进度条
        end
        self : initNowPropeData(data)     --初始化当前属性
        self : initUpgradePropeData(Lv)   --初始化升级属性
        self : initGemCount()             --初始化道具数量
    end
end

function CFamiliarLayer.initGemCount(self)
    local PropsList  = _G.g_GameDataProxy : getPropsList()
    local count = 0 
    if PropsList ~= nil then
        for k,v in pairs(PropsList) do
            if tonumber(v.goods_id) == _G.Constant.CONST_PET_GOODS_ID then  -- id = 54001
                count =count + v.goods_num
            end
        end
    end

    --local GoodNode =  _G.Config.goodss : selectNode("goods","id",tostring(_G.Constant.CONST_PET_GOODS_ID)) --物品节点
    local GoodNode = _G.Config.goodss : selectSingleNode("goods[@id="..tostring(_G.Constant.CONST_PET_GOODS_ID).."]") --物品节点
    local Goodname = GoodNode : getAttribute("name") 

    self.SoulStoneLabel : setString("当前拥有"..Goodname.."数量 : "..count.."个")
end

function CFamiliarLayer.initUpgradePropeData(self,Lv)
    local Lv   = tonumber(Lv)
    local data = {}
    if Lv > 0 then
        local next_Lv  = Lv + 1 
        if _G.Constant.CONST_PET_MAX_LV >= next_Lv then
            print("为什么会进来===",next_Lv)
        --local nextNode =  _G.Config.pets : selectNode("pet","lv",tostring(next_Lv)) --章节节点
            local nextNode = _G.Config.pets : selectSingleNode("pet[@lv="..tostring(next_Lv).."]")
            if nextNode : isEmpty() == false then
                data = self : getPetDataFromXml(next_Lv,nil,nil)  --获取宠物下一级信息数据
            end
        end
    end

    if data ~= nil then
        print("为什么空了还进来")
        local strong_att = tonumber(data.strong_att)
        local strong_def = tonumber(data.strong_def)
        local skill_att  = tonumber(data.skill_att)
        local skill_def  = tonumber(data.skill_def)   
        local hp         = tonumber(data.hp)  

        if strong_att ~= nil and  strong_att > 0 then
            self.UpgradePropeLabel[1] : setString("物理攻击+"..strong_att)
        end 
        if strong_def ~= nil and strong_def > 0 then
            self.UpgradePropeLabel[2] : setString("物理防御+"..strong_def)
        end  
        if skill_att ~= nil and skill_att > 0 then
            self.UpgradePropeLabel[3] : setString("技能攻击+"..skill_att)
        end  
        if skill_def ~= nil and  skill_def > 0 then
            self.UpgradePropeLabel[4] : setString("技能防御+"..skill_def)
        end   
        if  hp ~= nil and hp > 0 then
            self.UpgradeBloodLabel    : setString("气血+"..hp)
        else
            self.UpgradeBloodLabel    : setString("魔宠已为最高级")
        end 
    else
        for i = 1 , 4 do
            self.UpgradePropeLabel[i] : setString("")
        end
        self.UpgradeBloodLabel        : setString("")
    end
end

function CFamiliarLayer.initNowPropeData(self,data)
    local strong_att = tonumber(data.strong_att)
    local strong_def = tonumber(data.strong_def)
    local skill_att  = tonumber(data.skill_att)
    local skill_def  = tonumber(data.skill_def)   
    local hp         = tonumber(data.hp)  
    if strong_att > 0 then
        self.NowPropeLabel[1] : setString("物理攻击+"..strong_att)
    end 
    if strong_def > 0 then
        self.NowPropeLabel[2] : setString("物理防御+"..strong_def)
    end  
    if skill_att > 0 then
        self.NowPropeLabel[3] : setString("技能攻击+"..skill_att)
    end  
    if skill_def > 0 then
        self.NowPropeLabel[4] : setString("技能防御+"..skill_def)
    end   
    if hp > 0 then
        self.NowBloodLabel    : setString("气血+"..hp)
    end  
end

function CFamiliarLayer.createframe(self,expvalue,next_exp)
    if self.frame ~= nil then
        self.frame : removeFromParentAndCleanup( true )
        self.frame  = nil
    end

    local expvalue       = tonumber(expvalue)
    local nextstep_value = tonumber(next_exp)
    if  self.frame == nil then
        print("self.frame建立了了")
        self.frame      = CSprite : createWithSpriteFrameName("equip_exp_frame_short.png")
        self.frame      : setPosition(210,470)  
        self.m_rightBackGround : addChild(self.frame)

        local frameSize = self.frame : getPreferredSize()
        if expvalue > 0 then
            local exp       = CSprite : createWithSpriteFrameName( "role_exp.png",CCRectMake( 11, 0, 1 , 21)) 
            self.frame      : addChild(exp,10) 
            local value     = math.floor(expvalue/nextstep_value*(236-18)) + 18
            exp             : setPreferredSize( CCSizeMake(value , 21)) --18 ～236
            local sprSize   = exp : getPreferredSize()
            exp             : setPosition(-(frameSize.width/2 - sprSize.width/2)+4,0)
        end
    end
end

function CFamiliarLayer.getPetDataFromXml(self,Lv,Count2,MsgSkin) --获取宠物信息数据
    local  data = {}
    if tonumber(Lv) > 0 then
        --local Node        = _G.Config.pets : selectNode("pet","lv",tostring(Lv)) --章节节点
        local Node        = _G.Config.pets : selectSingleNode("pet[@lv="..tostring(Lv).."]")

        data.name         = Node : getAttribute("name") 
        data.next_exp     = Node : getAttribute("next_exp")
        data.lv           = Node : getAttribute("lv")
        data.gold_exp     = Node : getAttribute("gold_exp")
        data.gold_ten_opp = Node : getAttribute("gold_ten_opp")
        data.good_exp     = Node : getAttribute("good_exp")

        data.strong_att   = Node : getAttribute("strong_att")  
        data.strong_def   = Node : getAttribute("strong_def")  
        data.skill_att    = Node : getAttribute("skill_att")   
        data.skill_def    = Node : getAttribute("skill_def")   
        data.hp           = Node : getAttribute("hp")                
    end
    if Count2 ~= nil and  tonumber(Count2) > 0 and MsgSkin ~=nil then
        data.skinCount = Count2
        data.skindata  = {}
        for i=1,Count2 do
            data.skindata[i] =  MsgSkin[i]
        end
    end
    return data 
end



--mediator 注册
function CFamiliarLayer.registerMediator(self)
    print("CKofCareerLayer.mediatorRegister 75")
    _G.g_FamiliarLayerMediator = CFamiliarLayerMediator (self)
    controller :registerMediator(  _G.g_FamiliarLayerMediator )
end
--协议发送
function CFamiliarLayer.REQ_PET_REQUEST(self)   --请求宠物列表
    require "common/protocol/auto/REQ_PET_REQUEST" 
    local msg = REQ_PET_REQUEST()
    CNetwork  : send(msg)
    print("REQ_PET_REQUEST 22810 发送完毕 ")
end
function CFamiliarLayer.REQ_PET_OPEN(self)   -- (手动) -- [22830]开启式神 -- 宠物
    require "common/protocol/auto/REQ_PET_OPEN" 
    local msg = REQ_PET_OPEN()
    CNetwork  : send(msg)
    print("REQ_PET_OPEN 22830 发送完毕 ")
end
function CFamiliarLayer.REQ_PET_CALL(self,_id)   -- (手动) -- [22850]召唤式神 -- 宠物 
    require "common/protocol/auto/REQ_PET_CALL" 
    local msg = REQ_PET_CALL()
    msg       : setId(_id) ---- {式神id}
    CNetwork  : send(msg)
    print("REQ_PET_CALL 22850 发送完毕 ")
end
function CFamiliarLayer.REQ_PET_NEED_RMB(self,_type)   -- (手动) -- [22870]修炼还需要的钻石数 -- 宠物 
    require "common/protocol/auto/REQ_PET_NEED_RMB" 
    local msg = REQ_PET_NEED_RMB()
    msg       : setType(_type) ---- {式神id}
    CNetwork  : send(msg)
    print("REQ_PET_NEED_RMB 22870 发送完毕 ")
end
function CFamiliarLayer.REQ_PET_XIULIAN(self,_type)  -- (手动) -- [22880]魔宠修炼 -- 宠物
    require "common/protocol/auto/REQ_PET_XIULIAN" 
    local msg = REQ_PET_XIULIAN()
    msg       : setType(_type) ---- {1，修炼；2，高级修炼}
    CNetwork  : send(msg)
    print("REQ_PET_XIULIAN 22880 发送完毕 ")
end
--协议返回


function CFamiliarLayer.NetWorkReturn_CALL_OK(self)   --式神召唤成功返回
 
    local msg  = "式神召唤成功"
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(msg)
    self.Scenelayer : addChild(BoxLayer,1000)

    if self.teamData ~= nil then
        local count = tonumber(self.teamData.count)
        for i=1,count do
            self.TeamerBtn[i] :  setGray(true)
        end
    end
    if self.CallTransNo ~= nil then
        local no = self.CallTransNo
        print("式神召唤成功3301",no)
        self.TeamerBtn[no] :  setDefault()
    end 
end
function CFamiliarLayer.NetWorkReturn_NEED_RMB(self,rmb)   --请求宠物列表
    local msg        = ""
    local rmb        = tonumber(rmb)
    --local GoodNode   =  _G.Config.goodss : selectNode("goods","id",tostring(_G.Constant.CONST_PET_GOODS_ID)) --物品节点
    local GoodNode   = _G.Config.goodss : selectSingleNode("goods[@id="..tostring(_G.Constant.CONST_PET_GOODS_ID).."]")
    local Goodname   = GoodNode : getAttribute("name") 
    local PropsList  = _G.g_GameDataProxy : getPropsList()
    local Gemcount   = 0 
    if PropsList ~= nil then
        for k,v in pairs(PropsList) do
            if tonumber(v.goods_id) == _G.Constant.CONST_PET_GOODS_ID then  -- id = 54001
                Gemcount = v.goods_num
            end
        end
    end

    if rmb == 0 then
        if self.NowBtnType ~= nil and self.NowBtnType == CFamiliarLayer.TYPE_Practice then
            msg = "是否消耗1个"..Goodname.."进行1次修炼"
        elseif self.NowBtnType ~= nil and self.NowBtnType == CFamiliarLayer.TYPE_HighPractice then
            msg = "是否消耗50个"..Goodname.."进行".._G.Constant.CONST_PET_SENIOR_TIMES.."次修炼"
        end
    else
        if self.NowBtnType ~= nil and self.NowBtnType == CFamiliarLayer.TYPE_Practice then
            msg = "是否消耗".._G.Constant.CONST_PET_RMB.."个钻石进行1次修炼"
        elseif self.NowBtnType ~= nil and self.NowBtnType == CFamiliarLayer.TYPE_HighPractice then
            local count = (_G.Constant.CONST_PET_SENIOR_TIMES - Gemcount) * _G.Constant.CONST_PET_RMB
            msg = "是否消耗"..count.."个钻石进行".._G.Constant.CONST_PET_SENIOR_TIMES.."次修炼"            
        end
    end

    if self.NowBtnType ~= nil and self.NowBtnType == CFamiliarLayer.TYPE_Practice then
        local function fun1()
            print("确定")
            self : REQ_PET_XIULIAN(CFamiliarLayer.TYPE_Practice)
        end
        local function fun2()
            print("取消")
        end
        self : createMessageBox(msg,fun1,fun2)

    elseif self.NowBtnType ~= nil and self.NowBtnType == CFamiliarLayer.TYPE_HighPractice then
        local function fun1()
            print("确定")
            self : REQ_PET_XIULIAN(CFamiliarLayer.TYPE_HighPractice)
        end
        local function fun2()
            print("取消")
        end
        self : createMessageBox(msg,fun1,fun2)
    end
end

function CFamiliarLayer.createMessageBox(self,_msg,_fun1,_fun2)
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg,_fun1,_fun2)
    self.Scenelayer : addChild(BoxLayer)
end







