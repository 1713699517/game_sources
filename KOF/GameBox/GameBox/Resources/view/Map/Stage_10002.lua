-- 南镇
function _G.getMapData10002()
	return CBaseMapData(
			{ "Scene/m10002/m1000201.jpg","Scene/m10002/m1000202.jpg","Scene/m10002/m1000203.jpg","Scene/m10002/m1000204.jpg","Scene/m10002/m1000205.jpg" }, -- 路径
			1, -- 地图类型
			10002, -- 地图id
			10, -- 格子宽度
			10, -- 格子高度
			2560, -- 格子宽数
			640, -- 格子高数
			{

			}, -- 可走
			{ "Scene/m10002/m1000201.jpg","Scene/m10002/m1000202.jpg","Scene/m10002/m1000203.jpg","Scene/m10002/m1000204.jpg","Scene/m10002/m1000205.jpg" } , --地图块 
			2560, -- 地图宽度
			640, -- 地图高度
			512, -- 地图块宽度
			255 -- 可行高度
		) 
end