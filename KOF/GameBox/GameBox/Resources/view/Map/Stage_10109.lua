-- 美国赛场（6张）
function _G.getMapData10109()
	return CBaseMapData(
			{ "Scene/m10105/m1001008.jpg","Scene/m10105/m1001009.jpg" }, -- 路径
			1, -- 地图类型
			10109, -- 地图id
			10, -- 格子宽度
			10, -- 格子高度
			3070, -- 格子宽数
			640, -- 格子高数
			{

			}, -- 可走
			{ "Scene/m10105/m1001008.jpg","Scene/m10105/m1001009.jpg","Scene/m10105/m1001008.jpg","Scene/m10105/m1001009.jpg","Scene/m10105/m1001008.jpg","Scene/m10105/m1001009.jpg" } , --地图块 
			3070, -- 地图宽度
			640, -- 地图高度
			512, -- 地图块宽度
			255 -- 可行高度
		) 
end