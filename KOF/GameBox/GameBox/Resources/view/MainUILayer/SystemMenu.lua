--CSystemMenu  右下角系统按钮
require "view/FactionPanelLayer/FactionApplyView"
require "view/view"
require "proxy/FunctionOpenProxy"
---------------------------------------------
-----require 添加到此 按添加时间排序
require "view/BackpackLayer/BackpackView"       
require "view/EquipInfoView/EquipInfoView"
require "view/CharacterPanelLayer/CharacterPanelView"
require "view/TaskUI/TaskNewView"
require "view/FriendUI/FriendListView"
require "mediator/DuplicateMediator"
require "proxy/DuplicateDataProxy"
require "view/DuplicateLayer/BuildTeamView"
require "view/EmailUI/EmailView"
require "view/FactionPanelLayer/FactionPanelView"
require "view/VindictivePanelLayer/VindictivePanelView"
require "view/TreasureHouse/TreasureHouseScene"
require "view/TreasureHouse/TreasureHouseInfoView"
require "view/Artifact/ArtifactView"
require "view/SystemSetting/SystemSettingScene"
---------------------------------------------



----------------------

CSystemMenu = class( view, function( self )
    -- body
    self.isInited = _G.pCFunctionOpenProxy :getInited()                
    if self.isInited then
        --print("FunctionOpenProxy is ", self.isInited)
    end
end)

function CSystemMenu.layout( self, winSize, layer )
    if winSize.height == 640 then
         local nX = (winSize.width+605)
         
         self.m_menuContainer :show(layer, ccp( nX +( 100 * ( self.m_nCount-self.m_nCount)), 60), 3)
         self.m_menuVerContainer :show(layer, ccp( winSize.width - 12, -35), 5)
        
    elseif winSize.height == 768 then
        
    end
end

function CSystemMenu.addMediator( self )
    self :removeMediator()
    
    require "mediator/SystemMenuMediator"
    _G.pCSystemMenuMediator = CSystemMenuMediator( self)
    controller :registerMediator( _G.pCSystemMenuMediator)
end

function CSystemMenu.removeMediator( self)
    --print("注销并清空", self.m_menuContainer, self.m_menuVerContainer, _G.pCSystemMenuMediator)
    if self.m_menuContainer ~= nil then
        self.m_menuContainer :removeFromParentAndCleanup( true)
        self.m_menuContainer = nil
    end
    if self.m_menuVerContainer ~= nil then
        self.m_menuVerContainer :removeFromParentAndCleanup( true)
        self.m_menuVerContainer = nil 
    end
    if _G.pCSystemMenuMediator then
        controller :unregisterMediator( _G.pCSystemMenuMediator)
        _G.pCSystemMenuMediator = nil
    end
    --print("注销并清空222", self.m_menuContainer, self.m_menuVerContainer, _G.pCSystemMenuMediator)
end

function CSystemMenu.realeaseParams( self )
    -- body
    self.m_btnRole = nil
    self.m_btnBag = nil
    self.m_btnStrength      = nil
    self.m_btnHunt      = nil
    self.m_btnTask      = nil
    self.m_btnEmail       = nil
    self.m_btnHelp      = nil
    self.m_sprImage     =   nil
    self.m_menuContainer=   nil

    self.m_btnSystem    =   nil
    self.m_btnWeapons   =   nil
    self.m_btnFriend     =   nil
    self.m_sprVer       =   nil
    self.m_menuVerContainer = nil

end


function CSystemMenu.init( self, winSize, layer )
    self :addMediator()
    self :initView( layer)
    self :initFunctionParams( )
    self :openFunctionBySysId()
    self :layout( winSize, layer)
end

function CSystemMenu.initFunctionParams( self)  --根据功能按钮参数初始化
    if _G.pCFunctionOpenProxy :getInited() then
        self.m_count = _G.pCFunctionOpenProxy :getCount()
        
        if self.m_count ~= nil and self.m_count > 0 then                                    --功能按钮个数
            self.m_sysId = _G.pCFunctionOpenProxy :getSysId()       --功能按钮id
           
            --[[
            for k, v in pairs( self.m_sysId) do
                print( "功能开放按钮ID--->", k, v)
            end
             --]]
        end
    end
end

-- 7个 人物 强化 任务 斗气 珍宝 神器 社团     3个 组队 邮件 好友
function CSystemMenu.openFunctionBySysId( self)
    if self.m_count~=nil then
        if self.m_sortInfo ~= nil then
            table.remove( self.m_sortInfo )
            self.m_sortInfo = nil
        end

        if self.m_sysId~=nil then
            for key, value in pairs( self.m_sysId) do
                local nId   = tonumber( value.id )        --功能id
                local bUse  = tonumber( value.use )      --是否使用(1:使用过           0:没使用)
                print("苍天笑",bUse)
                
                print("nId===", nId)
                local _szSprName = nil
                local _szBtnName = nil
                local _isDownOrUp  = false      --false为7个功能按钮    true 为3个功能按钮
                
                if nId == _G.Constant.CONST_FUNC_OPEN_ROLE then                       --开放功能-人物     10012
                    _szSprName = "menu_function_player_icon.png"
                    _szBtnName = "人物"
                    
                elseif nId == _G.Constant.CONST_FUNC_OPEN_STRENGTHEN then             --强化      10080
                    _szSprName = "menu_function_strengthen_icon.png"
                    _szBtnName = "强化"
                    
                elseif nId == _G.Constant.CONST_FUNC_OPEN_MAIN_TASK  then             --任务      10013
                    _szSprName = "menu_function_task_icon.png"
                    _szBtnName = "任务"
                    
                elseif nId == _G.Constant.CONST_FUNC_OPEN_STAR then                   --斗气      10300
                    _szSprName = "menu_function_star_icon.png"
                    _szBtnName = "斗气"
                    
                elseif nId == _G.Constant.CONST_FUNC_OPEN_JEWELLERY then              --珍宝      10360
                    _szSprName = "menu_function_jew_icon.png"
                    _szBtnName = "珍宝"
                    
                elseif nId == _G.Constant.CONST_FUNC_OPEN_ARTIFACT then               --神器      10390
                    _szSprName = "menu_function_artifact_icon.png"
                    _szBtnName = "神器"
                    
                elseif nId == _G.Constant.CONST_FUNC_OPEN_GUILD then                  --社团(社团) 10190
                    _szSprName = "menu_function_organization_icon.png"
                    _szBtnName = "社团"
                
                elseif nId == 10040 then                                              --背包      10040
                    _szSprName = "menu_function_backpack_icon.png"
                    _szBtnName = "背包"
                    
                ------------------------------
                elseif nId == _G.Constant.CONST_FUNC_OPEN_DEVIL then                   --宠物      10200
                    _isDownOrUp = false
                    _szSprName = "menu_function_pet_icon.png"
                    _szBtnName = "宠物"
                    
                elseif nId == _G.Constant.CONST_FUNC_OPEN_MAIL then                   --邮件      10050
                    _isDownOrUp = true
                    _szSprName = "menu_function_mail_icon.png"
                    _szBtnName = "邮件"
                    
                elseif nId == _G.Constant.CONST_FUNC_OPEN_FRIEND then                 --好友      10110
                    _isDownOrUp = true
                    _szSprName = "menu_function_friend_icon.png"
                    _szBtnName = "好友"

                elseif nId == _G.Constant.CONST_FUNC_OPEN_SYSTEM then                 --系统设置      11010
                    _isDownOrUp = true
                    _szSprName = "menu_function_system_icon.png"
                    _szBtnName = "设置"
                    
                end
                
                --_szBtnName = ""
                --进行排序
                if _szSprName ~= nil then
                    if self.m_sortInfo == nil then
                        self.m_sortInfo = {}
                    end
                    
                    local nCount = #self.m_sortInfo + 1
                    self.m_sortInfo[ nCount ] = {}
                    --print("self.m_sortInfo[ #self.m_sortInfo + 1 ]", self.m_sortInfo[ nCount ], self.m_sortInfo, #self.m_sortInfo)
                    self.m_sortInfo[ nCount ].nFuncId     = nId
                    self.m_sortInfo[ nCount ].szSprName   = _szSprName
                    self.m_sortInfo[ nCount ].szBtnName   = _szBtnName
                    self.m_sortInfo[ nCount ].isDownOrUp  = _isDownOrUp       --bool值
                    self.m_sortInfo[ nCount ].bUse        = bUse              --是否使用(1:使用过           0:没使用)
                end
            end
        end
    end
    
    --
    if self.m_sortInfo ~= nil then
        --[[
        for key, value in pairs( self.m_sortInfo ) do
            print( " 排序前sortInfo--> ", value.nFuncId, value.szSprName, value.szBtnName, value.isDownOrUp )
        end
         --]]
        self :sortData( self.m_sortInfo )
        
        --print("\n")
        for key, value in pairs( self.m_sortInfo ) do
            --print( " 排序后sortInfo--> ", value.nFuncId, value.szSprName, value.szBtnName, value.isDownOrUp )
            self :createFuncBtnByIndex( value.nFuncId, value.szSprName, value.szBtnName, value.isDownOrUp,value.bUse)
        end

        for k, v in pairs( self.m_sortInfo ) do
            print( "sssssddddd-->", k, v.id )
        end
    end
     --]]
end

function CSystemMenu.sortData( self, _data )
    if _data ~= nil then
        local func = function( lValue, rValue )
        if lValue.nFuncId > rValue.nFuncId then
            return true
        else
            return false
        end
    end
    table.sort( _data, func )
end

end

--{创建按钮}
function CSystemMenu.createFuncBtnByIndex( self, _index, _szSprName,  _szBtnName, _isDownOrUp,_bUse)
    if _index == nil or _szSprName == nil or self.m_menuContainer == nil or _isDownOrUp == nil  then
        return
    end
    
    _index      = tonumber( _index)             --id
    _szSprName  = tostring( _szSprName)         --资源图片
    _szBtnName  = tostring( _szBtnName)         --按钮名字
    _bUse       = tonumber(_bUse)

    print("_bUse==",_bUse,_index)
    --print("初始的按钮－－》", _index, _szSprName,  _szBtnName, _isDownOrUp, self["m_funcBtn".._index], self, self.m_nCount)
    -- CCLOG(debug.traceback())
    if self["m_funcBtn".._index] ~= nil and self["effectsCCBI" .. _index] ~= nil then
        print("aa",self)
       -- self["m_funcBtn".._index] :removeChild( self["effectsCCBI" .. _index])
       self["effectsCCBI" .. _index] : removeFromParentAndCleanup()
        print("bb")
        self["effectsCCBI" .. _index] = nil 
    end

    
    if self["m_funcBtn".._index] ~= nil and _isDownOrUp == false then
        self.m_menuContainer :getLayout() :removeChild( self["m_funcBtn".._index])
    elseif self["m_funcBtn".._index] ~= nil and _isDownOrUp == true then
        self.m_menuVerContainer :getLayout() :removeChild( self["m_funcBtn".._index])
    end
    self["m_funcBtn".._index] = nil
    --print("self[m_funcBtn.._index]", self["m_funcBtn".._index])
    
    
    local function funcBtnCallback( eventType, obj, x, y)
        return self :onFuncBtnCallback( eventType, obj, x, y)
    end
    
    self["m_funcBtn".._index] = CButton :createWithSpriteFrameName( "", tostring( _szSprName ) )
    --self["m_funcBtn".._index] :setFontSize( 25)
    self["m_funcBtn".._index] :setTag( _index )
    self["m_funcBtn".._index] :setControlName("this CSystemMenu self[m_funcBtn.._index]]".. _szBtnName .." 169")
    self["m_funcBtn".._index] :setTouchesPriority( -25 )
    self["m_funcBtn".._index] :registerControlScriptHandler( funcBtnCallback, "this CSystemMenu self[m_funcBtn.._index] 169")
    
    if self["m_funcBtn".._index] ~= nil then
        --local _func_spr     = CSprite :createWithSpriteFrameName( _szSprName )
        --self["m_funcBtn".._index]        : addChild( _func_spr, 20 )
        
        --local _func_label   = CCLabelTTF :create( _szBtnName, "Arial", 18 )
        --self["m_funcBtn".._index]        : addChild( _func_label, 20 )
        
        --local _btnSize = self["m_funcBtn".._index] :getPreferredSize()
        --_func_label :setPosition( ccp( 0, -_btnSize.height / 3) )
    end
    
    if _isDownOrUp == false and self.m_menuContainer ~= nil and self["m_funcBtn".._index] ~= nil then
        self.m_menuContainer :getLayout() :addChild( self["m_funcBtn".._index] )
        --计数
        self.m_nCount = self.m_nCount + 1
        
    elseif _isDownOrUp == true and self.m_menuVerContainer ~= nil and self["m_funcBtn".._index] ~= nil then
        self.m_menuVerContainer :getLayout() :addChild( self["m_funcBtn".._index] )
    end
    print("创建成功》", _index, _szSprName,  _szBtnName, _isDownOrUp, self["m_funcBtn".._index], self.m_nCount)

    if _bUse ==  0  then       -- 1:使用过  0:未使用
        print("看看你进来了没")
        self : Create_effects_activity(self["m_funcBtn".._index],_index,1) --ICON图标特效
    end
end

function CSystemMenu.getFuncBtnByIndex( self, _index )
    if self.m_menuContainer ~= nil then
        if self.m_menuContainer :getLayout() :getChildByTag( _index ) then
            return self.m_menuContainer :getLayout() :getChildByTag( _index )
        elseif self.m_menuVerContainer :getLayout() :getChildByTag( _index ) then 
            return self.m_menuVerContainer :getLayout() :getChildByTag( _index )
        end
    else
        return nil
    end
end

function CSystemMenu.getClickId( self )
    return self.m_nClickId
end

--回调
function CSystemMenu.onFuncBtnCallback( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        local _nId = obj :getTag()
        CCLOG( "点击了   ".._nId)
        
        local closeCommand = CVipViewCommand( CVipViewCommand.CLOSETIPS )
        controller :sendCommand( closeCommand )
        
        self :openFunctionViewByTag( tonumber( _nId))
        
        return true
    end
end

--{根据id打开相应面板}
function CSystemMenu.openFunctionViewByTag( self, _nId, _noClear)
    --print("_nId", _nId)
    
    if _nId == _G.Constant.CONST_FUNC_OPEN_ROLE then                       --人物      10012
        CCLOG("人物")
        self :pushLuaScene( _G.g_CharacterPanelView :scene() )
    -----------------------------------------------------------------------------------------
    elseif _nId == _G.Constant.CONST_FUNC_OPEN_STRENGTHEN then             --强化      10080
        CCLOG("强化")
        _G.g_CEquipInfoView = CEquipInfoView()
        self :pushLuaScene( _G.g_CEquipInfoView :scene() )
    -----------------------------------------------------------------------------------------    
    elseif _nId == _G.Constant.CONST_FUNC_OPEN_MAIN_TASK  then             --任务      10013
        CCLOG("任务")
        local taskScene = CTaskNewView()
        self :pushLuaScene( taskScene:scene() )
    -----------------------------------------------------------------------------------------    
    elseif _nId == _G.Constant.CONST_FUNC_OPEN_STAR then                   --斗气      10300
        CCLOG("斗气")
        _G.pCVindictivePanelView = CVindictivePanelView()
        self :pushLuaScene( _G.pCVindictivePanelView :scene() )
    -----------------------------------------------------------------------------------------   
    elseif _nId == _G.Constant.CONST_FUNC_OPEN_JEWELLERY then              --珍宝      10360
        CCLOG("珍宝")
        _G.g_CTreasureHouseInfoView = CTreasureHouseInfoView()
        self :pushLuaScene( _G.g_CTreasureHouseInfoView :scene() )
    -----------------------------------------------------------------------------------------    
    elseif _nId == _G.Constant.CONST_FUNC_OPEN_ARTIFACT then               --神器      10390
        CCLOG("神器")
        _G.g_CArtifactView = CArtifactView()
        self :pushLuaScene(  _G.g_CArtifactView :scene() )
    -----------------------------------------------------------------------------------------    
    elseif _nId == _G.Constant.CONST_FUNC_OPEN_GUILD then                  --社团(社团) 10190
        CCLOG("社团")
        local mainplay = _G.g_characterProperty :getMainPlay()
        local myclan   = mainplay :getClan()      --玩家家族ID  无 ：0  有 ：ID
        if myclan == 0 then
            --print( "玩家当前没有加入社团", myclan)
            
            _G.pFactionApplyView = CFactionApplyView()
            self :pushLuaScene(  _G.pFactionApplyView :scene()  )
        else
            --print( "玩家已经加入社团", myclan)            
            _G.pFactionPanelView = CFactionPanelView()
            self :pushLuaScene( _G.pFactionPanelView :scene()  )
        end
        
    elseif _nId == 10040 then                                              --背包     10040
        CCLOG("临时的背包界面")
        --[[
        require "view/BackpackLayer/BackpackView"
        _G.pBackpackView = CBackpackView :scene()
        CCDirector :sharedDirector() :pushScene( _G.pBackpackView)
         --]]
        require "view/BackpackPanelLayer/BackpackPanelView"
        self :pushLuaScene(  _G.g_CBackpackPanelView :scene()  )
        
    -----------------------------------------------------------------------------------------
    elseif _nId == _G.Constant.CONST_FUNC_OPEN_DEVIL then                   --宠物     10200
        ----[[
        CCLOG("魔宠")
        local lv =tonumber(_G.g_characterProperty:getMainPlay():getLv())
        if lv >= _G.Constant.CONST_PET_OPEN_LV then
            self :pushLuaScene(  CShikigamiInfoView () :scene()  )
        else
            local msg = "此功能".._G.Constant.CONST_PET_OPEN_LV.."级才开放"
            require "view/ErrorBox/ErrorBox"
            local ErrorBox  = CErrorBox()
            local BoxLayer  = ErrorBox : create(msg)
            _G.pmainView :getMainLayer() : addChild(BoxLayer,100000)
        end
        ----]]
        --[[
        CCLOG("组队")
        if _G.g_DuplicateMediator ~= nil then
            _G.controller : unregisterMediator( _G.g_DuplicateMediator )
            _G.g_DuplicateMediator = nil
        end
        _G.g_DuplicateMediator = CDuplicateMediator( self)
        _G.controller : registerMediator( _G.g_DuplicateMediator)
        
        CCDirector : sharedDirector () : pushScene ( CBuildTeamView : scene( nil,1,1) ) --将要组队的场景id传进去
        --]]
    -----------------------------------------------------------------------------------------    
    elseif _nId == _G.Constant.CONST_FUNC_OPEN_MAIL then                   --邮件      10050
        CCLOG("邮件")
        local emailView = CEmailView()
        self :pushLuaScene(  emailView :scene()  )
    -----------------------------------------------------------------------------------------    
    elseif _nId == _G.Constant.CONST_FUNC_OPEN_FRIEND then                 --好友      10110
        CCLOG("好友")
        local friendView = CFriendListView()
        self :pushLuaScene(  CFriendListView:scene() )
    -----------------------------------------------------------------------------------------
    elseif _nId == _G.Constant.CONST_FUNC_OPEN_SYSTEM then                 --系统设置      11010
        CCLOG("系统设置")
        _G.pSystemScene = CSystemSettingScene()
        self :pushLuaScene( _G.pSystemScene:scene() )
    -----------------------------------------------------------------------------------------
    end

    if _noClear == nil then
        print("asdadjaodjajdkjslkjdadjaldjalk")
        self : removeFirstClickCCBI( _nId ) --先判断是不是多人活动 然后在判断是不是第一次 如果是第一次按的就删了你
        self : NetWorkSend_REQ_ROLE_USE_SYS(_nId)
    end

    --关闭功能按钮
    _G.pCFunctionMenuView :setMenuStatus( false )
end

function CSystemMenu.setHorizBtn( self, _lpcszSprName, _pFuncName  )
    -- body
end

function CSystemMenu.setHorizNumber( self, _nCount )
    self.m_nCount = _nCount
end

function CSystemMenu.scene( self )
    
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    local scene = CContainer :create()
    scene : setControlName( "this is CSystemMenu scene 266  " )
    
    self.m_layer = CCLayer :create()
    self :init( winSize, self.m_layer)
    
    scene :addChild( self.m_layer)
    return scene
    
end

function CSystemMenu.initView( self, layer )
    self.m_sprImage = CCScale9Sprite :create()
    self.m_menuContainer = CMenu :create( CCSizeMake( 90, 90 ), eLD_Horizontal, self.m_sprImage)
    self.m_menuContainer :getLayout() :setHorizontalDirection( false)
    self.m_menuContainer :getLayout() :setCellHorizontalSpace( 5 )
    self.m_menuContainer :getLayout() :setCellVerticalSpace( 5 )
    
    self.m_nlineSum = 7
    self.m_menuContainer :getLayout() :setLineNodeSum( self.m_nlineSum)
    self.m_nCount = 1
    
    ----------
    self.m_srpVer = CCScale9Sprite :create()
    self.m_menuVerContainer = CMenu :create( CCSizeMake( 90, 90 ), eLD_Vertical, self.m_srpVer)
    self.m_menuVerContainer :getLayout() :setCellVerticalSpace( 5 )
end
   
--jun 2013-10-23
---特效CCBI
function CSystemMenu.Create_effects_activity( self,obj,value,types)

    local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            print( "Enter««««««««««««««««"..eventType )
            arg0 : play("run")
        end
    end
    if obj ~= nil then
        if obj ~= nil and self["effectsCCBI" .. value] ~= nil then
            obj :removeChild( self["effectsCCBI" .. value] )
            self["effectsCCBI" .. value] = nil 
        end

        if value == _G.Constant.CONST_FUNC_OPEN_BOSS then
            print("为什么你又呗创建了")
        end

        if types == 1 then
            self["effectsCCBI" .. value] = CMovieClip:create( "CharacterMovieClip/effects_activity.ccbi" )
            self["effectsCCBI" .. value]       : setControlName( "this CCBI Create_effects_activity CCBI")
            self["effectsCCBI" .. value]       : registerControlScriptHandler( animationCallFunc)
            self["effectsCCBI" .. value]       : setPosition(3,15)
            obj               : addChild( self["effectsCCBI" .. value],1000)  
        else
            self["effectsCCBI" .. value] = CMovieClip:create( "CharacterMovieClip/effects_activity.ccbi" )
            self["effectsCCBI" .. value]       : setControlName( "this CCBI Create_effects_activity CCBI")
            self["effectsCCBI" .. value]       : registerControlScriptHandler( animationCallFunc)
            self["effectsCCBI" .. value]       : setPosition(3,15)

            if value == _G.Constant.CONST_FUNC_OPEN_BOSS then
                print("创建多人的ccbi进来了")
               -- return effectsCCBI
                obj               : addChild( self["effectsCCBI" .. value],1000) 
            else
                obj               : addChild( self["effectsCCBI" .. value],1000)  
            end
        end

    end
end

function CSystemMenu.NetWorkSend_REQ_ROLE_USE_SYS( self,sys_id) --使用功能协议发送
    print("发没有",sys_id)
    if tonumber(sys_id)  ~= nil then
        require "common/protocol/auto/REQ_ROLE_USE_SYS"
        local msg = REQ_ROLE_USE_SYS()
        msg :setSysId(sys_id)  -- {功能ID}
        CNetwork :send(msg)
        print("发了")
    end
end
    
function CSystemMenu.removeFirstClickCCBI( self, _nId ) --如果是第一次按的就删了你

    if  self["m_funcBtn".._nId] ~= nil and self["effectsCCBI" .. _nId] ~= nil then
        self["m_funcBtn".._nId]  :  removeChild( self["effectsCCBI" .. _nId] )
        self["effectsCCBI" .. _nId]= nil 
    end

    if self.m_sysId ~= nil then
        for key, value in pairs( self.m_sysId  )  do
            if value.id == _nId then
                print("不能都是这样的好不好??",value.use)
                value.use = 1
                print("不能都是这样的好不好",value.use)
                table.remove( self.m_sysId, key)
                table.insert( self.m_sysId, key, value )
                break
            end
        end
    end
    _G.pCFunctionOpenProxy :setSysId( self.m_sysId )
end 

function CSystemMenu.removeAllIconCCBI( self) --干掉所有的CCBI
    print("CSystemMenu准备干掉所有的CCBI")

    if self.m_sysId ~= nil then
        for key, value in pairs( self.m_sysId  )  do
           local  nFuncId =  value.id 
            print("ooxx",nFuncId)
            if  self["m_funcBtn"..nFuncId] ~= nil and self["effectsCCBI" .. nFuncId] ~= nil then
                self["effectsCCBI" .. nFuncId] : removeFromParentAndCleanup()
                self["effectsCCBI" .. nFuncId] = nil 
                print("killing----")
            end
        end
    end
end

function CSystemMenu.pushLuaScene( self, _scene )
    if _scene ~= nil and _G.pCFunctionOpenProxy ~= nil then
        
        local pScene = CCTransitionCrossFade :create( 0.5, _scene) 
        _G.pCFunctionOpenProxy :pushEffectScene( pScene, 0.5 )
        
    else
        CCLOG("CSystemMenu肿么了，有个东西空了，查查看！！！！")
    end
end



