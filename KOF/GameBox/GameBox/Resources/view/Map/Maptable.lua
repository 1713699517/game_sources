require "common/PathCheck"


--全局地图数据
_G.mapTable = class()

function mapTable.load( self, _nMapID )
    self.m_nMapID = _nMapID
    local mapPath = "view/Map/Stage_" .. tostring(self.m_nMapID)
    _G.PathCheck : pathExists(mapPath..".lua")
    require (mapPath)
    print("self.m_nMapID",self.m_nMapID)
    self.small = _G["getMapData"..tostring(self.m_nMapID)]()
end

function mapTable.unload( self )
    self.small = nil
end

function mapTable.getSmallMap( self )
    return self.small
end

function mapTable.getClone( self )
    return _G["getMapData"..tostring(self.m_nMapID)]()
end


CBaseMapData = class(function( self, _szMapPath, _nType, _nMapID, _fGridWidth, 
                     _fGridHeight, _nRow, _nColumn, _lpArray, _lpArrMapPiece,
                     _fWidth, _fHeight, _fPieceWidth, _fCanWalkHeight )
    self.m_szMapPath = _szMapPath
    self.m_nType = _nType --地图类型 0 普通  1 战斗 
    self.m_nMapID = _nMapID --  素材ID
    self.m_fGridWidth = _fGridWidth --每一格的宽
    self.m_fGridHeight = _fGridHeight --每一格的高
    self.m_nRow = _nRow --行数（高）
    self.m_nColumn = _nColumn --列数 （宽）
    self.m_lpArray = _lpArray
    self.m_lpArrMapPiece = _lpArrMapPiece
    self.m_fWidth = _fWidth
    self.m_fHeight = _fHeight
    self.m_fMapPieceWidth = _fPieceWidth
    self.m_fCanWalkHeight = _fCanWalkHeight

    --              a星 寻路
    -- self.STRAIGHTCOST = 1.0 --直线价值
    -- self.DIAGCOST = math.sqrt(2.0) --对角价值
    -- self.m_lpPath = {}
    -- self : initWalkCost()
end)

function CBaseMapData.getCanWalkHeight( self )
    return self.m_fCanWalkHeight
end

function CBaseMapData.getPieceWidth( self )
    return self.m_fMapPieceWidth
end

function CBaseMapData.getWidth( self )
    return self.m_fWidth
end

function CBaseMapData.getHeight( self )
    return self.m_fHeight
end

function CBaseMapData.getMapPiece( self )
    return self.m_lpArrMapPiece
end

function CBaseMapData.getMapType( self )
    return self.m_nType
end

function CBaseMapData.getMapPath( self )
    return self.m_szMapPath
end

function CBaseMapData.getGridWidth( self )
    return self.m_fGridWidth * self.m_nColumn
end

function CBaseMapData.getGridHeight( self )
    return self.m_fGridHeight * self.m_nRow
end

function CBaseMapData.getGridIndexByIndex( self, _nIndexX, _nIndexY )
    --以x,y索引 得到格子的索引   _nIndexX x索引   _nIndexY y索引
    _nIndexX = ( _nIndexX > self.m_nColumn and self.m_nColumn ) or _nIndexX
    _nIndexX = ( _nIndexX < 1 and 1 ) or _nIndexX
    _nIndexY = ( _nIndexY > self.m_nRow and self.m_nRow ) or _nIndexY
    _nIndexY = ( _nIndexY < 1 and 1 ) or _nIndexY
    local index = (_nIndexY - 1) * self.m_nColumn +_nIndexX
    return index
end

function CBaseMapData.getxyIndexByGridIndex( self, _nIndex )
    -- 以索引 得到xy 索引
    _nIndex = ( _nIndex > self.m_nRow * self.m_nColumn  and self.m_nRow * self.m_nColumn ) or _nIndex
    _nIndex = ( _nIndex < 1 and 1 ) or _nIndex
    local indexY = math.ceil(_nIndex / self.m_nColumn)
    local indexX = _nIndex - (indexY -1) * self.m_nColumn
    return indexX,indexY
end

function CBaseMapData.getGridStatusByIndex( self, _nIndex )
    --以索引 得到格子的状态
    return self.m_lpArray[_nIndex]
end

function CBaseMapData.getGridIndexByPos( self, _fx, _fy )
    -- 以坐标 得到格子索引
    _fx = ( _fx > self :getGridWidth()  and self :getGridWidth() ) or _fx
    _fx = ( _fx < 0  and 0 ) or _fx
    _fy = ( _fy > self :getGridHeight()  and self :getGridHeight() ) or _fy
    _fy = ( _fy < 0  and 0 ) or _fy

    local x = math.floor( _fx / self.m_fGridWidth + 1 )
    local y = math.floor( _fy / self.m_fGridHeight + 1 )
    local gridIndex = self :getGridIndexByIndex( x , y )
    return gridIndex
end

function CBaseMapData.getGridStatusByXYIndex( self, _nIndexX, _nIndexY )
    -- 以xy 索引 得到格子状态
    local index = self : getGridIndexByIndex( _nIndexX, _nIndexY )
    return self : getGridStatusByIndex(index) 
end


function CBaseMapData.getPosByxyIndex( self, _nIndexX, _nIndexY)
    --以xy索引 得到中间坐标
    _nIndexX = ( _nIndexX > self.m_nColumn and self.m_nColumn ) or _nIndexX
    _nIndexX = ( _nIndexX < 1 and 1 ) or _nIndexX
    _nIndexY = ( _nIndexY > self.m_nRow and self.m_nRow ) or _nIndexY
    _nIndexY = ( _nIndexY < 1 and 1 ) or _nIndexY
    local x = (_nIndexX * self.m_fGridWidth) - (self.m_fGridWidth / 2)
    local y = (_nIndexY * self.m_fGridHeight) - (self.m_fGridHeight / 2)
    return x,y
end

function CBaseMapData.getPosByPos( self, _fx, _fy )
    -- 以坐标 得到中间坐标
    local index = self : getGridIndexByPos(_fx, _fy)
    local indexX,indexY = self : getxyIndexByGridIndex( index )
    return self : getPosByxyIndex(indexX, indexY)
end

function CBaseMapData.getPosByIndex( self, _nIndex )
    -- 以索引 得到中间坐标
    local indexX,indexY = self : getxyIndexByGridIndex(_nIndex)
    return self : getPosByxyIndex(indexX, indexY)
end

function CBaseMapData.getxyIndexByPos( self, _fx, _fy )
    --  以坐标 得到xy 索引
    local index = self : getGridIndexByPos( _fx, _fy )
    return self : getxyIndexByGridIndex( index )
end

function CBaseMapData.countPos( self, _pos )
    _pos.x = _pos.x < 0 and 0 or _pos.x
    _pos.x = _pos.x > self:getWidth() and self:getWidth() or _pos.x

    _pos.y = _pos.y < 0 and 0 or _pos.y
    _pos.y = _pos.y > self:getCanWalkHeight() and self:getCanWalkHeight() or _pos.y
    return _pos
end


--[[  A星
]]

-- function CBaseMapData.__walkableCompare( self, _nIndexX, _nIndexY )
--     --步行比较  <= 0的就不能行
--     tar = self : getGridStatusByXYIndex( _nIndexX, _nIndexY )
--     return tar <= 0
-- end

-- function CBaseMapData.__f_compare_func( _lpNode1, _lpNode2 )
--     --比较f值
--     return _lpNode1.f < _lpNode2.f
-- end

-- function CBaseMapData.createCost( self, _nIndex )
--     --创建 估价值
--     local cost = {g=0,h=0,f=0,index=_nIndex,parent = nil}
--     return cost
-- end

-- function CBaseMapData.initWalkCost( self )
--     --初始化 估价值
--     print("初始化 估价值")
--     self.m_lpGridNodes = {}
--     local len = self.m_nRow * self.m_nColumn
--     for i=1,len do
--         self.m_lpGridNodes[i] = self : createCost(i)
--     end
-- end

-- function CBaseMapData.clearWalkCost( self )
--     --清空被修改过的估价值
--     for i,v in pairs(self.m_lpPath) do
--         self.m_lpGridNodes[v] = self:createCost(v)
--     end
--     self.m_lpPath = {}
-- end

-- function CBaseMapData._heuristic( self, _fIndexX1, _fIndexY1, _fIndexX2, _fIndexY2 )
--     --计算 f值
--     local dx = math.abs( _fIndexX1 - _fIndexX2 )
--     local dy = math.abs( _fIndexY1 - _fIndexY2 )
--     local diag = math.min( dx, dy )
--     local straight = dx + dy
--     return self.DIAGCOST * diag + self.STRAIGHTCOST * ( straight - 2.0 * diag)
-- end

-- function CBaseMapData.finNeighborGrids( self, _nIndex )
--     -- 找出相邻的格子（方向）
--     --[[ 方向
--         7
--       6 | 8  
--      4 --- 5
--       1 | 3
--         2
--     ]]
--     local grids = {} --用 pairs 遍历
--     local indexX,indexY = self : getxyIndexByGridIndex( _nIndex )
--     if indexX == 1 and indexY == 1 then
--         --左下 坐标［1,1］
--         grids[ 5 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX + 1, indexY ) ]
--         grids[ 7 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX , indexY + 1 ) ]
--         grids[ 8 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX + 1, indexY + 1 ) ]
--         --print("左下")
--     elseif indexX == 1 and indexY == self.m_nRow then
--         --左上 坐标［1,self.m_nRow ］
--         grids[ 2 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX , indexY - 1 ) ]
--         grids[ 3 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX + 1, indexY - 1 ) ]
--         grids[ 5 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX + 1, indexY ) ]
--         --print("左上")
--     elseif indexX == self.m_nColumn and indexY == 1 then
--         --右下 坐标［self.m_nColumn ,1］
--         grids[ 4 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX - 1 , indexY  ) ]
--         grids[ 6 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX - 1 , indexY + 1 ) ]
--         grids[ 7 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX , indexY + 1 ) ]
--         --print("右下")
--     elseif indexX == self.m_nColumn and indexY == self.m_nRow then
--         --右上 坐标 [self.m_nColumn,self.m_nRow]
--         grids[ 4 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX - 1 , indexY  ) ]
--         grids[ 1 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX - 1 , indexY - 1  ) ]
--         grids[ 2 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX , indexY - 1 ) ]
--         --print("右上")
--     elseif indexY == 1 then
--         -- 下 坐标 [n , 1]
--         grids[ 4 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX - 1 , indexY  ) ]
--         grids[ 5 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX + 1, indexY ) ]
--         grids[ 6 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX - 1 , indexY + 1 ) ]
--         grids[ 7 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX , indexY + 1 ) ]
--         grids[ 8 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX + 1, indexY + 1 ) ]
--         --print("下")
--     elseif indexX == 1 then
--         -- 左 坐标 [1, n]
--         grids[ 2 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX , indexY - 1 ) ]
--         grids[ 3 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX + 1, indexY - 1 ) ]
--         grids[ 5 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX + 1, indexY ) ]
--         grids[ 7 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX , indexY + 1 ) ]
--         grids[ 8 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX + 1, indexY + 1 ) ]
--         --print("左")
--     elseif indexY == self.m_nRow then
--         --上 坐标 [n , self.m_nRow]
--         grids[ 1 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX - 1 , indexY - 1  ) ]
--         grids[ 2 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX , indexY - 1 ) ]
--         grids[ 3 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX + 1, indexY - 1 ) ]
--         grids[ 4 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX - 1 , indexY  ) ]
--         grids[ 5 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX + 1, indexY ) ]
--         --print("上")
--     elseif indexX == self.m_nColumn then
--         --右 坐标 [n,self.m_nColumn]
--         grids[ 1 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX - 1 , indexY - 1  ) ]
--         grids[ 2 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX , indexY - 1 ) ]
--         grids[ 4 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX - 1 , indexY  ) ]
--         grids[ 6 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX - 1 , indexY + 1 ) ]
--         grids[ 7 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX , indexY + 1 ) ]
--     else
--         grids[ 1 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX - 1 , indexY - 1  ) ]
--         grids[ 2 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX , indexY - 1 ) ]
--         grids[ 3 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX + 1, indexY - 1 ) ]
--         grids[ 4 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX - 1 , indexY  ) ]
--         grids[ 5 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX + 1, indexY ) ]
--         grids[ 6 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX - 1 , indexY + 1 ) ]
--         grids[ 7 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX , indexY + 1 ) ]
--         grids[ 8 ] = self.m_lpGridNodes[ self : getGridIndexByIndex( indexX + 1, indexY + 1 ) ]
--         --print("中间")
--     end
--     return grids
-- end

-- function CBaseMapData.getWalkCost( self, _gridsIndex )
--     -- 得到步行价值
--     if _gridsIndex == 2 or _gridsIndex == 4 or _gridsIndex == 5 or _gridsIndex == 7 then
--         return self.STRAIGHTCOST
--     end
--     return self.DIAGCOST -- 1 3 6 8 对角
-- end

-- function CBaseMapData.isInArray( self, _array, _data )
--     -- 检查是否在数组内
--     for k,v in pairs(_array) do
--         if v == _data then
--             return true
--         end
--     end
--     return false
-- end

-- function CBaseMapData.pathToPos( self, _lpPath )
--     -- 路径转换坐标
--     local posList = class()
--     for k,index in pairs(_lpPath) do
--         table.insert(posList, ccp( self : getPosByIndex( index ) ) )
--     end
--     return posList
-- end

-- function CBaseMapData.findPathByPos( self,_fStartPosX, _fStartPosY, _fEndPosX, _fEndPosY )
--     -- 以坐标 寻路径 
--     local startIndexX , startIndexY  = self : getxyIndexByPos(_fStartPosX, _fStartPosY )
--     local endIndexX , endIndexY = self : getxyIndexByPos(_fEndPosX, _fEndPosY )
--     return self : findPathByIndex( startIndexX, startIndexY, endIndexX, endIndexY )
-- end

-- function CBaseMapData.findPathByIndex(self, _nStartIndexX, _nStartIndexY, _nEndIndexX, _nEndIndexY)
--     -- 以索引 寻路径
--     print("开始寻路" )
--     self : clearWalkCost()
--     if( self : __walkableCompare(_nStartIndexX, _nStartIndexY) or self : __walkableCompare(_nEndIndexX, _nEndIndexY) ) then
--         print("if( self : __walkableCompare(_nStartIndexX, _nStartIndexY) or self : __walkableCompare(_nEndIndexX, _nEndIndexY) ) then")
--         return false,self.m_lpPath
--     end
--     local startIndex = self : getGridIndexByIndex( _nStartIndexX, _nStartIndexY )
--     local endIndex = self : getGridIndexByIndex( _nEndIndexX, _nEndIndexY )

--     local startNode = self.m_lpGridNodes[startIndex]
--     local endNode = self.m_lpGridNodes[endIndex]

--     startNode.g = 0.0;
--     startNode.h = self : _heuristic( _nStartIndexX, _nStartIndexY, _nEndIndexX, _nEndIndexY )
--     startNode.f = startNode.g + startNode.h

--     local currendNode = startNode

--     local openList = {}
--     local closeList = {}

--     while currendNode ~= endNode   do
--         local grids = self : finNeighborGrids( currendNode.index )
--         for i,testNode in pairs(grids) do
--             local walkableCompare = self : __walkableCompare(self : getxyIndexByGridIndex( testNode.index ))
--             if testNode ~= nil  or walkableCompare == false then
--                 local testIndexX, testIndexY = self : getxyIndexByGridIndex( testNode.index )

--                 local _cost = self : getWalkCost(i)
--                 local _g = currendNode.g + _cost
--                 local _h = self : _heuristic( testIndexX, testIndexY, _nEndIndexX, _nEndIndexY  )
--                 local _f = _g +_h
--                 if self : isInArray( openList, testNode ) or self : isInArray( closeList, testNode ) then
--                     if _f < testNode.f then
--                         testNode.parent = currendNode
--                     end
--                 else
--                     testNode.parent = currendNode
--                     table.insert(openList, testNode)                    
--                 end
--                 testNode.g = _g
--                 testNode.h = _h
--                 testNode.f = _f
--             end--if
--         end--for
--         table.insert(closeList, currendNode)
--         if openList[1] == nil then
--             print("openList[1] == nil then")
--             return false, self.m_lpPath
--         end
--         table.sort( openList, self.__f_compare_func )
--         currendNode = openList[1]
--         table.remove(openList,1)

--         --error("111111")
--     end--while





--     currendNode = endNode
--     table.insert(self.m_lpPath,1, currendNode.index)

--     while currendNode ~= startNode do
--         currendNode = currendNode.parent

--         table.insert(self.m_lpPath,1, currendNode.index)

--     end

--     print("寻路结束")
--     return true, self.m_lpPath
-- end