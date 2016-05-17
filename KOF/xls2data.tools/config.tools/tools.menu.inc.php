<?php
/**
 * 目录
 */
$menu = array
(
	array
	(
		'group_name' => '系统',
 		array
 		(
 			'tag_name'  										=> '游戏',
 	
 			
 			'/tools/l2u.html' 									=> array('_blank','大小写互转'),
 			'/tools/c.php' 										=> array('_blank','binary_to_string'),
 			'/tools/color.php' 									=> array('_blank','color'),
 			'http://jjpm.gamecore.cn:89' 						=> array('_blank','<b style="color:#93F">项目管理 Bug提交</b>'),
 			'/tools/update_logs.php'  							=> array('_self','<b style="color:#F00">更新日志</b>'),
 		),

		array
		(
			'tag_name'  							=> '日志',
			'http://jj.gamecore.cn:89/xml/'			=> array('_self','前端XML'),
		),
		
		array
		(
			'tag_name'  								=> 'SDK接口',
			'http://jjapi.gamecore.cn:89/doc/Phone/'  	=> array('_blank','<b>手端接口</b>'),
			'http://jjapi.gamecore.cn:89/doc/Web/'		=> array('_blank','WEB接口SDK'),
		),
		
		
	),
	array(
			'group_name' => '地图/采集/怪物/NPC/任务',
			array(
					'tag_name'  					=> '地图',
					'/xls2data/?f=scene_door.xlsx&type=scene_door'  					=> array('_self','传送门scene_door.xlsx'),
			),
			array(
					'tag_name'  			=> '副本',
					'/xls2data/?f=copy_reward.xlsx&type=copy_reward'  						=> array('_self','副本评分奖励copy_reward.xlsx'),
					'/xls2data/?f=copy_score.xlsx&type=copy_score'  						=> array('_self','副本评分copy_score.xlsx'),
					'/xls2data/?f=copy_chap.xlsx&type=copy_chap'  							=> array('_self','各种副本章节copy_chap.xlsx'),
					'/xls2data/?f=pilshow.xlsx&type=pilshow'  								=> array('_self','取经掉落显示pilshow.xlsx'),
					'/xls2data/?f=keycopy.xlsx&type=keycopy'  								=> array('_self','等级查找精英副本keycopy.xlsx'),
					'/xls2data/?f=pilroad_collect.xlsx&type=pilroad_collect'  				=> array('_self','取经之路采集怪pilroad_collect.xlsx'),
					'/xls2data/?f=copy_times_pay.xlsx&type=copy_times_pay'  				=> array('_self','副本购买次数消耗钻石copy_times_pay.xlsx'),
			),
			array(
					'tag_name'  				=> '任务',
					'/xls2data/?f=target.xlsx&type=target'  								=> array('_self','目标任务target.xlsx'),
					'/xls2data/?f=guide.xlsx&type=guide'  									=> array('_self','新手指导guide.xlsx'),
					'/xls2data/?f=/daily_task/daily_task.xlsx&type=daily_task'  			=> array('_self','日常任务daily_task.xlsx'),
					'/xls2data/?f=/daily_task/task_daily_lv.xlsx&type=task_daily_lv'  		=> array('_self','日常任务task_daily_lv.xlsx'),
					'/xls2data/?f=/task/task_loop.xlsx&type=task_loop'  					=> array('_self','环式任务task_loop.xlsx'),
			),
			array(
					'tag_name'  				=> '伙伴',
					'/xls2data/?f=partner_lv.xlsx&type=partner_lv'  					=> array('_self','伙伴等级partner_lv.xlsx'),
			),
			array(
					'tag_name'  				=> '平台渠道',
					'/xls2data/?f=platform.xlsx&type=platform'  		=> array('_self','<b>平台渠道</b>'),
			),
			
			
			array(
					'tag_name'  				=> 'APP内购',
					'/xls2data/?f=app_product.xlsx&type=app_product'  		=> array('_self','<b>APP内购_物品</b>'),
			),
			

			
	),
	array(
			'group_name' => '数值成长',
			array(
					'tag_name'					=> '人物角色',
					'/xls2data/?f=player_init.xlsx&type=player_init'  					=> array('_self','主角初始化player_init.xlsx'),
					'/xls2data/?f=player_init_source.xlsx&type=player_init_source'		=> array('_self','主角初始化渠道奖励player_init_source.xlsx'),
					'/xls2data/?f=player/player_up_exp.xlsx&type=player_up_exp'  				=> array('_self','升级经验player_up_exp.xlsx'),
					'/xls2data/?f=player/player_grow.xlsx&type=player_grow'  					=> array('_self','成长对应player_grow.xlsx'),
					'/xls2data/?f=player/player_grow_table.xlsx&type=player_grow_table'  		=> array('_self','成长数据player_grow_table.xlsx'),
					'/xls2data/?f=player/player_talent.xlsx&type=player_talent'  				=> array('_self','天赋影响数据player_talent.xlsx'),
					'/xls2data/?f=player_name.xlsx&type=player_name'  					=> array('_self','随机取名库player_name.xlsx'),
					'/xls2data/?f=sys_open.xlsx&type=sys_open'  						=> array('_self','系统开放sys_open.xlsx'),
                    '/xls2data/?f=sys_set.xlsx&type=sys_set'  						=> array('_self','系统设置默认sys_set.xlsx'),
					'/xls2data/?f=power_colcor.xlsx&type=power_colcor'  				=> array('_self','战斗力颜色power_colcor.xlsx'),
					'/xls2data/?f=war/battle_speed.xlsx&type=battle_speed'  			=> array('_self','皮肤速度battle_speed.xlsx'),
					'/xls2data/?f=player_part.xlsx&type=player_part'  				=> array('_self','职业属性表player_part.xlsx'),
					'/xls2data/?f=player_initial.xlsx&type=player_initial'  			=> array('_self','创建角色进副本player_initial.xlsx'),
			),
			array(
 					'tag_name'					=> '斗气',
					'/xls2data/?f=fight_gas/fight_gas_grasp.xlsx&type=fight_gas_grasp'		 => array('_self','领悟fight_gas_grasp.xlsx'),
					'/xls2data/?f=fight_gas/fight_gas_open.xlsx&type=fight_gas_open'	 	 => array('_self','等级开放fight_gas_open.xlsx'),
					'/xls2data/?f=fight_gas/fight_gas_total.xlsx&type=fight_gas_total'	 	 => array('_self','斗气fight_gas_total.xlsx'),
 			),	
			array(
					'tag_name'					=> '防沉迷',
					'/xls2data/?f=fcm.xlsx&type=fcm'  									=> array('_self','防沉迷fcm.xlsx'),
			),
			array(
					'tag_name'  				=> '功能开放控制',
					'/xls2data/?f=is_funs.xlsx&type=is_funs'	 	 					=> array('_self','功能开放is_funs.xlsx'),
					'/xls2data/?f=sys_remind.xlsx&type=sys_remind'	 	 				=> array('_self','功能提示sys_remind.xlsx'),
			),
			array(
					'tag_name'  				=> '招财',
					'/xls2data/?f=weagod.xlsx&type=weagod'  							=> array('_self','招财美金weagod.xlsx'),
					'/xls2data/?f=getgod.xlsx&type=getgod'  							=> array('_self','财神升级和财神符getgod.xlsx'),
					'/xls2data/?f=weavipvip.xlsx&type=weavip'  							=> array('_self','财神每天招财次数weavip.xlsx'),
					'/xls2data/?f=god_times.xlsx&type=god_times'  						=> array('_self','财神招财次数和元宝god_times.xlsx'),
			),
			array(
					'tag_name'  				=> '精力',
					'/xls2data/?f=energy_buy.xlsx&type=energy_buy'  					=> array('_self','精力energy_buy.xlsx'),
					'/xls2data/?f=energy_vip.xlsx&type=energy_vip'  					=> array('_self','精力energy_vip.xlsx'),
			),
			array(
					'tag_name'  				=> '藏宝阁',
					'/xls2data/?f=/hidden/hidden_treasure.xlsx&type=hidden_treasure'  							=> array('_self','藏宝阁属性表hidden_treasure.xlsx'),
					'/xls2data/?f=/hidden/hidden_store.xlsx&type=hidden_store'  							=> array('_self','藏宝阁商店hidden_store.xlsx'),
					'/xls2data/?f=/hidden/hidden_make.xlsx&type=hidden_make'  							=> array('_self','藏宝阁物品打造表hidden_make.xlsx'),
					'/xls2data/?f=/hidden/hidden_describe.xlsx&type=hidden_describe'  							=> array('_self','藏宝阁物品描述表hidden_describe.xlsx'),
					'/xls2data/?f=/hidden/hidden_line.xlsx&type=hidden_line'  							=> array('_self','藏宝阁物品hidden_line.xlsx'),
			),
	),
	
	array(
		'group_name' => '装备打造equip_forge/',
		array(
			'tag_name'  				=> '装备打造',
			'/xls2data/?f=equip_forge/equip_make.xlsx&type=equip_make'  				=> array('_self','装备打造equip_make.xlsx'),
			'/xls2data/?f=equip_forge/equip_stren.xlsx&type=equip_stren'  				=> array('_self','强化equip_stren.xlsx'),
			'/xls2data/?f=equip_forge/pearl_com.xlsx&type=pearl_com'  					=> array('_self','宝石合成pearl_com.xlsx'),
			'/xls2data/?f=equip_forge/equip_enchant.xlsx&type=equip_enchant'  			=> array('_self','装备附魔equip_enchant.xlsx'),
		),

		array(
				'tag_name'  				=> '强化(装备/法宝/首饰)',
				'/xls2data/?f=equip_forge/stren_equip.xlsx&type=stren_equip'			=> array('_self','强化武器/装备stren_equip.xlsx'),
				'/xls2data/?f=equip_forge/stren_magic.xlsx&type=stren_magic'  			=> array('_self','强化法宝stren_magic.xlsx'),
				'/xls2data/?f=equip_forge/stren_jewelry.xlsx&type=stren_jewelry'			=> array('_self','强化首饰stren_jewelry.xlsx'),
		),
	),
	array(
		'group_name' => '社会',
		array(
			'tag_name'  					=> '帮派',
			'/xls2data/?f=/clan/clan_level.xlsx&type=clan_level'  				=> array('_self','帮派升级成员上限clan_level.xlsx'),
			'/xls2data/?f=/clan/clan_skill.xlsx&type=clan_skill'  				=> array('_self','帮派技能数据clan_skill.xlsx'),
			'/xls2data/?f=/clan/clan_active_cast.xlsx&type=clan_active_cast'  	=> array('_self','帮派活动消费clan_active_cast.xlsx'),
			'/xls2data/?f=/clan/clan_yqs_lv.xlsx&type=clan_yqs_lv'  			=> array('_self','帮派摇钱树升级配置clan_yqs_lv.xlsx'),
			),
		array(
			'tag_name'  					=> '帮派Boss',	
			'/xls2data/?f=/clan_boss/clan_boss_reward.xlsx&type=clan_boss_reward'  	=> array('_self','帮派Boss伤害奖励clan_boss_reward.xlsx'),
			'/xls2data/?f=/clan_boss/clan_boss_relive.xlsx&type=clan_boss_relive'  	=> array('_self','帮派Boss复活花费clan_boss_relive.xlsx'),
			'/xls2data/?f=/clan_boss/clan_boss_lv.xlsx&type=clan_boss_lv'  			=> array('_self','帮派Boss开启属性clan_boss_lv.xlsx'),
			'/xls2data/?f=/clan_boss/clan_boss_attr.xlsx&type=clan_boss_attr'  		=> array('_self','帮派Boss活动Buff clan_boss_attr.xlsx'),
			
		),
		array(
				'tag_name'					=> '苦工',
				'/xls2data/?f=/arena/moil.xlsx&type=moil'  				=> array('_self','苦工moil.xlsx'),
				'/xls2data/?f=/arena/moil_exp.xlsx&type=moil_exp'  		=> array('_self','苦工moil_exp.xlsx'),
				'/xls2data/?f=/arena/moil_inter.xlsx&type=moil_inter'  		=> array('_self','苦工互动moil_inter.xlsx'),
		),
		array(
		        'tag_name'				=> '聊天',
		        '/xls2data/?f=broadcast.xlsx&type=broadcast'					=> array('_self','公告broadcast.xlsx'),
		        '/xls2data/?f=update_notice.xlsx&type=update_notice'					=> array('_self','更新公告update_notice.xlsx'),
                '/xls2data/?f=w.xlsx&type=w'					=> array('_self','屏蔽字w.xlsx'),
		),

	),
	array(
	        'group_name' => '活动',
	        array(
	                'tag_name'					=> '活动面板',
					'/xls2data/?f=/active/active_mail.xlsx&type=active_mail'				=> array('_self','活动奖励邮件active_mail.xlsx'),
	                '/xls2data/?f=/active/active.xlsx&type=active'							=> array('_self','面板active.xlsx'),
	                '/xls2data/?f=/active/active_link.xlsx&type=active_link'				=> array('_self','活跃度active_link.xlsx'),
	                '/xls2data/?f=/active/active_link_rewards.xlsx&type=active_link_rewards' => array('_self','活跃度奖励active_link_rewards.xlsx'),
	                '/xls2data/?f=guide.xlsx&type=guide'									=> array('_self','小助手数据 guide.xlsx'),
					
	                
	        ),
			array(
					'tag_name'					=> '日期活动',
					'/xls2data/?f=activity/acty_date.xlsx&type=acty_date'							=> array('_self','打开界面对应表 acty_date.xlsx'),
					 
			),
			array(
					'tag_name'					=> '掉落活动',
					'/xls2data/?f=activity/activity_flop_config.xlsx&type=activity_flop_config'	=> array('_self','掉落配制activity_flop_config.xlsx'),
					'/xls2data/?f=activity/activity_use_config.xlsx&type=activity_use_config'   => array('_self','物品使用activity_use_config.xlsx'),
					'/xls2data/?f=activity/activity_state.xlsx&type=activity_state'   			=> array('_self','活动时间activity_state.xlsx'),
					 
			),
			array(
					'tag_name'					=> '促销活动',
					'/xls2data/?f=sales_active/sales_total.xlsx&type=sales_total'					=> array('_self','促销活动汇总sales_total.xlsx'),
					'/xls2data/?f=sales_active/sales_sub.xlsx&type=sales_sub'					=> array('_self','促销活动阶段sales_sub.xlsx'),
					),
			
	        array(
	                'tag_name'					=> '日常Boss',
	               	'/xls2data/?f=world_boss_lv.xlsx&type=world_boss_lv'  					=> array('_self','世界Boss world_boss_lv.xlsx'),
	               	'/xls2data/?f=world_boss_rank.xlsx&type=world_boss_rank'  			=> array('_self','世界Boss排行奖励  world_boss_rank.xlsx'),
	               	'/xls2data/?f=world_boss_relive.xlsx&type=world_boss_relive'  	    => array('_self','世界Boss复活消耗 world_boss_relive.xlsx'),
	               	'/xls2data/?f=world_boss_reward.xlsx&type=world_boss_reward'  		=> array('_self','伤害击杀奖励  world_boss_reward.xlsx'),
	        		'/xls2data/?f=world_boss_attr.xlsx&type=world_boss_attr'  			=> array('_self','金元鼓舞  world_boss_attr.xlsx'),
	        ),

             array(
                    'tag_name'					=> '格斗之王',
                    '/xls2data/?f=/wrestle/wrestle_final.xlsx&type=wrestle_final'  				=> array('_self','格斗之王决赛 wrestle_final.xlsx'),
                    '/xls2data/?f=/wrestle/wrestle_preliminary.xlsx&type=wrestle_preliminary'  	=> array('_self','格斗之王预赛 wrestle_preliminary.xlsx'),
                    '/xls2data/?f=/wrestle/wrestle_rank.xlsx&type=wrestle_rank'  	            => array('_self','格斗之王争霸赛 wrestle_rank.xlsx'),

            ),
	        array(
	        		'tag_name'					=> '每日一箭',
	        		'/xls2data/?f=arrow_daily/arrow_daily_items.xlsx&type=arrow_daily_items'	=> array('_self','每日一箭道具描述arrow_daily_items.xlsx'),
	        		'/xls2data/?f=arrow_daily/arrow_daily_odds.xlsx&type=arrow_daily_odds'		=> array('_self','每日一箭抽取奖励arrow_daily_odds.xlsx'),
	        ),
	        
	),
	array(
	        'group_name' => '战斗',
	        array(
	                'tag_name'					=> 'AI',
	              '/xls2data/?f=war/battle_ai.xlsx&type=battle_ai'  				=> array('_self','AI battle_ai.xlsx'),
	              '/xls2data/?f=character.xlsx&type=character'  				=> array('_self','碰撞面积 character.xlsx'),
	        ),
	        array(
	                'tag_name'					=> '宠物/伙伴',
	               '/xls2data/?f=pet/pet.xlsx&type=pet'								=> array('_self','宠物 pet.xlsx'),
	        		'/xls2data/?f=pet/pet_skill.xlsx&type=pet_skill'				=> array('_self','宠物技能 pet_skill.xlsx'),
	        ),
	        array(
	                'tag_name'					=> '竞技场',
	                '/xls2data/?f=arena/arena.xlsx&type=arena'  							=> array('_self','竞技场数据arena.xlsx'),
	                '/xls2data/?f=arena/arena_ai.xlsx&type=arena_ai'  						=> array('_self','竞技场Aiarena_ai.xlsx'),
	               	'/xls2data/?f=arena/arena_reward.xlsx&type=arena_reward'  				=> array('_self','竞技场数据arena_reward.xlsx'),
	        ),
	        array(
	                'tag_name'					=> '<a>技能</a>',
	                '/mod/skill/skill.php'  	=> array('_self','技能'),
	              	'/xls2data/?f=/skill/skill_start.xlsx&type=skill_start'  						=> array('_self','技能初始化skill_start.xlsx'),
	        ),
	),
	array(
		'group_name' 							=> '其它数据',		
		array(
		        'tag_name'						=> '<a>商城</a>',
		        '/xls2data/?f=/mall/mall_name.xlsx&type=mall_name'  							=> array('_self','商城属性表mall_name.xlsx'),
		        '/xls2data/?f=/mall/mall_class.xlsx&type=mall_class'  							=> array('_self','商城分类属性表mall_class.xlsx'),
		       
		),
		array(
		        'tag_name'						=> '签到',
		        '/xls2data/?f=sign.xlsx&type=sign'  					=> array('_self','签到sign.xlsx'),
		        '/xls2data/?f=sign_vip.xlsx&type=sign_vip'  			=> array('_self','VIP签到sign_vip.xlsx'),
				'/xls2data/?f=logs.xlsx&type=logs'  					=> array('_self','系统日志logs.xlsx'),
				'/xls2data/?f=gift/login_gift.xlsx&type=login_gift'  	=> array('_self','连续登陆login_gift.xlsx'),
				'/xls2data/?f=gift/time_gift.xlsx&type=time_gift'  		=> array('_self','在线时间time_gift.xlsx'),
				'/xls2data/?f=gift/level_gift.xlsx&type=level_gift'  	=> array('_self','在线等级level_gift.xlsx'),
		),
		array(
				'tag_name'						=> '投资理财',
				'/xls2data/?f=privilege.xlsx&type=privilege'  					=> array('_self','投资理财 privilege.xlsx'),
		),
		array(
			'tag_name'							=> '背包',
			'/xls2data/?f=bag.xlsx&type=bag'  	=> array('_self','扩展背包数据bag.xlsx'),	
		),
		array(
				'tag_name'							=> '风林山火',
				'/xls2data/?f=flsh_reward.xlsx&type=flsh_reward'  	=> array('_self','风林山火奖励数据flsh_reward.xlsx'),
		),
		array(
		        'tag_name'					=> 'VIP',
		        '/xls2data/?f=vip.xlsx&type=vip'  							=> array('_self','VIP数据vip.xlsx'),
		        '/xls2data/?f=vip_show.xlsx&type=vip_show'  				=> array('_self','VIP等级开放描述vip_show.xlsx'),
		),
		array (
				'tag_name' 					=> '文字描述表现配置',
				'/xls2data/?f=word.xlsx&type=word'						    => array ('_self','文字描述表现配置word.xlsx'),
		),
		array (
				'tag_name' 					=> '策略描述配置',
				'/xls2data/?f=strategy.xlsx&type=strategy'					=> array ('_self','策略描述配置strategy.xlsx'),
		),
		array (
				'tag_name' 					=> '等级条件宝箱数据',
				'/xls2data/?f=lv_goods.xlsx&type=lv_goods' 					=> array ('_self','等级条件宝箱数据lv_goods.xlsx'),
				'/xls2data/?f=times_goods.xlsx&type=times_goods' 			=> array ('_self','使用次数宝箱数据times_goods.xlsx' )
		),		
	),
);