require "view/view"
require "common/Constant"
require "view/Plot/PlotView"
require "controller/PlotCommand"


CPlotManager = class(view,function ( self )
    self :loadXml()
    self.m_plotList = self :getXMLPlotList()
end)




-- _G.Constant.CONST_DRAMA_GETINTO  --进入场景(副本)
-- _G.Constant.CONST_DRAMA_FINISHE --完成副本
-- _G.Constant.CONST_DRAMA_TRIGGER  --任务触发
-- _G.Constant.CONST_DRAMA_ENCOUNTER --遇到指定BOSS
-- _G.Constant.CONST_DRAMA_DEFEAT    --打死指定BOSS

--检查是否存在剧情   参数: _touchType(触发类型-> 参考上面的常量) _touchId(触发的Id-> bossID或者副本ID或任务Id)
function CPlotManager.checkPlotHas( self, _touchType, _touchId )

	-- local sceneType = _G.g_Stage :getScenesType()

	-- if sceneType == _G.Constant.CONST_MAP_TYPE_CITY then 
	-- 	return
	-- elseif sceneType == _G.Constant.CONST_MAP_TYPE_COPY_NORMAL or sceneType == _G.Constant.CONST_MAP_TYPE_COPY_HERO or sceneType == _G.Constant.CONST_MAP_TYPE_COPY_FIEND then 

	-- elseif sceneType == _G.Constant.CONST_MAP_TYPE_BOSS then 
	-- 	return
	-- end

	if _touchType == nil or _touchId == nil then
		print("_touchType == nil or _touchId == nil")
		return false
	end

	-- local plotList = self :getPlotListByTouch( _touchType )
	-- if plotList == nil then
	-- 	print("plotList == nil")
	-- 	return false
	-- end

	local plotData = self :getPlotDataByListAndArg( _touchType, _touchId )
	if plotData:isEmpty() then 
		print("plotData == nil")
		return false
	end

	if _touchType == _G.Constant.CONST_DRAMA_GETINTO or _touchType == _G.Constant.CONST_DRAMA_FINISHE then
		--刚进入场景 完成副本 判断是否通关
		local duplicateList = _G.g_DuplicateDataProxy :getDuplicateList()
		print( "#duplicateList="..#duplicateList )
		for i,v in ipairs(duplicateList) do
			print( i,v.copy_id,v.is_pass )
			if tonumber(v.copy_id) == tonumber(_touchId) then 
				if tonumber(v.is_pass) == 1 then
					--已通关过 
					print("tonumber(v.is_pass) == 1  已通关过 ")
					return false
				end
			end
		end
	end

	return plotData

end

--播放剧情
function CPlotManager.showPlot( self, _plotData, _fun )

	if _plotData then 
		if _G.g_Stage.m_lpContainer ~= nil then
			
			if self.plotView ~= nil then
                if self.plotView.resetPlotView ~= nil then
                    self.plotView :resetPlotView()
                end
			end

			self.m_goFun = _fun

		    self.plotView = CPlotView() :createPlot( _plotData )
		    _G.g_Stage:getScene() :addChild( self.plotView,1000 )
		    --发送剧情开始 命令
		    self :sendPlotCommand_START( _plotData.id )
		elseif _fun ~= nil then
			_fun()
		end
	else
		print("剧情播放..... _plotData=faslse?   不能播放!!")
		if _fun ~= nil then
			_fun()
		end
	end

	
end

--执行    剧情完成后 执行的方法
function CPlotManager.finishPlot( self, _plotId )
	CCLOG("剧情播放完毕")
	if self.m_goFun ~= nil then
		self.m_goFun()
	end
	self:sendPlotCommand_FINISH( _plotId )
	self.plotView = nil
end


function CPlotManager.loadXml( self )
	_G.Config:load("config/scene_drama.xml")
end

--获取所有剧情列表 并进行分类
function CPlotManager.getXMLPlotList( self )

	local list = {}
	list[1] 	 = {}
	list[1].type = _G.Constant.CONST_DRAMA_GETINTO
	list[1].list = {}

	list[2] 	 = {}
	list[2].type = _G.Constant.CONST_DRAMA_FINISHE
	list[2].list = {}

	list[3] 	 = {}
	list[3].type = _G.Constant.CONST_DRAMA_TRIGGER
	list[3].list = {}

	list[4] 	 = {}
	list[4].type = _G.Constant.CONST_DRAMA_ENCOUNTER
	list[4].list = {}

	list[5] 	 = {}
	list[5].type = _G.Constant.CONST_DRAMA_DEFEAT
	list[5].list = {}

	for i,v in ipairs(_G.Config.scene_dramas.scene_drama) do
		-- print("getXMLPlotList---> "..v.touch)
		if tonumber(v.touch) == _G.Constant.CONST_DRAMA_GETINTO then 
			table.insert(list[1].list,v)
		elseif tonumber(v.touch) == _G.Constant.CONST_DRAMA_FINISHE then 
			table.insert(list[2].list,v)
		elseif tonumber(v.touch) == _G.Constant.CONST_DRAMA_TRIGGER then 
			table.insert(list[3].list,v)
		elseif tonumber(v.touch) == _G.Constant.CONST_DRAMA_ENCOUNTER then 
			table.insert(list[4].list,v)
		elseif tonumber(v.touch) == _G.Constant.CONST_DRAMA_DEFEAT then 
			table.insert(list[5].list,v)
		end
	end

	for i,v in ipairs(list) do
		print(v.type,#v.list)
	end

	return list

end

--根据触发类型 获取剧情列表
function CPlotManager.getPlotListByTouch( self, _touch )

	for i,v in ipairs(self.m_plotList) do
		print(_touch,v.type,#v.list)
		if v.type == tonumber(_touch) then 
			return v.list
		end
	end

	return nil

end

--根据剧情列表与剧情Id 获取剧情信息
function CPlotManager.getPlotDataByListAndId( self, _list, _id )

	for i,v in ipairs( _list ) do
		if tonumber(v.id) == tonumber(_id) then 
			return v
		end
	end
	
	return nil

end

--根据剧情列表与触发Id 获取剧情信息
function CPlotManager.getPlotDataByListAndArg( self, _touchType, _touchId )

	-- for i,v in ipairs( _list ) do
	-- 	if tonumber(v.arg) == tonumber(_arg) then 
	-- 		return v
	-- 	end
	-- end
	if _touchId == nil or _touchType == nil then
		return nil
	end

	local _touch_arg  = tostring( _touchType ).."_"..tostring( _touchId )

	local node = _G.Config.scene_dramas:selectSingleNode( "scene_drama[@touch_arg=".._touch_arg.."]" )
	

	print("getPlotDataByListAndArg---->".._touchType,_touchId,_touch_arg)
	return node

end

function CPlotManager.sendPlotCommand_START( self, _plotId )
	local _plotCommand = CPlotCammand(CPlotCammand.START,_plotId)
	controller:sendCommand(_plotCommand)
end

function CPlotManager.sendPlotCommand_FINISH( self, _plotId )
	local _plotCommand = CPlotCammand(CPlotCammand.FINISH,_plotId)
	controller:sendCommand(_plotCommand)
end


_G.pCPlotManager = CPlotManager()






