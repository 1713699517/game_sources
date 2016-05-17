-module(data_pearl_com).
-include("../include/comm.hrl").

-export([get/1]).

% get();
% 宝石合成数据;
% 
get(20021)->
	#d_pearl{
		goods_id     = 20021,           %% 合成宝石ID
		goods_make   = [{20001,3,0},{33001,1,2}]%% 宝石合成
	};
get(20041)->
	#d_pearl{
		goods_id     = 20041,           %% 合成宝石ID
		goods_make   = [{20021,3,0},{33011,1,5}]%% 宝石合成
	};
get(20061)->
	#d_pearl{
		goods_id     = 20061,           %% 合成宝石ID
		goods_make   = [{20041,3,0},{33021,1,10}]%% 宝石合成
	};
get(20081)->
	#d_pearl{
		goods_id     = 20081,           %% 合成宝石ID
		goods_make   = [{20061,3,0},{33031,1,50}]%% 宝石合成
	};
get(20101)->
	#d_pearl{
		goods_id     = 20101,           %% 合成宝石ID
		goods_make   = [{20081,3,0},{33041,1,100}]%% 宝石合成
	};
get(20121)->
	#d_pearl{
		goods_id     = 20121,           %% 合成宝石ID
		goods_make   = [{20101,3,0},{33051,1,200}]%% 宝石合成
	};
get(20141)->
	#d_pearl{
		goods_id     = 20141,           %% 合成宝石ID
		goods_make   = [{20121,3,0},{33061,1,300}]%% 宝石合成
	};
get(20161)->
	#d_pearl{
		goods_id     = 20161,           %% 合成宝石ID
		goods_make   = [{20141,3,0},{33071,1,400}]%% 宝石合成
	};
get(20181)->
	#d_pearl{
		goods_id     = 20181,           %% 合成宝石ID
		goods_make   = [{20161,3,0},{33081,1,800}]%% 宝石合成
	};
get(20201)->
	#d_pearl{
		goods_id     = 20201,           %% 合成宝石ID
		goods_make   = [{20181,3,0},{33091,1,1200}]%% 宝石合成
	};
get(20221)->
	#d_pearl{
		goods_id     = 20221,           %% 合成宝石ID
		goods_make   = [{20201,3,0},{33101,1,1600}]%% 宝石合成
	};
get(21021)->
	#d_pearl{
		goods_id     = 21021,           %% 合成宝石ID
		goods_make   = [{21001,3,0},{33111,1,2}]%% 宝石合成
	};
get(21041)->
	#d_pearl{
		goods_id     = 21041,           %% 合成宝石ID
		goods_make   = [{21021,3,0},{33121,1,5}]%% 宝石合成
	};
get(21061)->
	#d_pearl{
		goods_id     = 21061,           %% 合成宝石ID
		goods_make   = [{21041,3,0},{33131,1,10}]%% 宝石合成
	};
get(21081)->
	#d_pearl{
		goods_id     = 21081,           %% 合成宝石ID
		goods_make   = [{21061,3,0},{33141,1,50}]%% 宝石合成
	};
get(21101)->
	#d_pearl{
		goods_id     = 21101,           %% 合成宝石ID
		goods_make   = [{21081,3,0},{33151,1,100}]%% 宝石合成
	};
get(21121)->
	#d_pearl{
		goods_id     = 21121,           %% 合成宝石ID
		goods_make   = [{21101,3,0},{33161,1,200}]%% 宝石合成
	};
get(21141)->
	#d_pearl{
		goods_id     = 21141,           %% 合成宝石ID
		goods_make   = [{21121,3,0},{33171,1,300}]%% 宝石合成
	};
get(21161)->
	#d_pearl{
		goods_id     = 21161,           %% 合成宝石ID
		goods_make   = [{21141,3,0},{33181,1,400}]%% 宝石合成
	};
get(21181)->
	#d_pearl{
		goods_id     = 21181,           %% 合成宝石ID
		goods_make   = [{21161,3,0},{33191,1,800}]%% 宝石合成
	};
get(21201)->
	#d_pearl{
		goods_id     = 21201,           %% 合成宝石ID
		goods_make   = [{21181,3,0},{33201,1,1200}]%% 宝石合成
	};
get(21221)->
	#d_pearl{
		goods_id     = 21221,           %% 合成宝石ID
		goods_make   = [{21201,3,0},{33211,1,1600}]%% 宝石合成
	};
get(22021)->
	#d_pearl{
		goods_id     = 22021,           %% 合成宝石ID
		goods_make   = [{22001,3,0},{33221,1,2}]%% 宝石合成
	};
get(22041)->
	#d_pearl{
		goods_id     = 22041,           %% 合成宝石ID
		goods_make   = [{22021,3,0},{33231,1,5}]%% 宝石合成
	};
get(22061)->
	#d_pearl{
		goods_id     = 22061,           %% 合成宝石ID
		goods_make   = [{22041,3,0},{33241,1,10}]%% 宝石合成
	};
get(22081)->
	#d_pearl{
		goods_id     = 22081,           %% 合成宝石ID
		goods_make   = [{22061,3,0},{33251,1,50}]%% 宝石合成
	};
get(22101)->
	#d_pearl{
		goods_id     = 22101,           %% 合成宝石ID
		goods_make   = [{22081,3,0},{33261,1,100}]%% 宝石合成
	};
get(22121)->
	#d_pearl{
		goods_id     = 22121,           %% 合成宝石ID
		goods_make   = [{22101,3,0},{33271,1,200}]%% 宝石合成
	};
get(22141)->
	#d_pearl{
		goods_id     = 22141,           %% 合成宝石ID
		goods_make   = [{22121,3,0},{33281,1,300}]%% 宝石合成
	};
get(22161)->
	#d_pearl{
		goods_id     = 22161,           %% 合成宝石ID
		goods_make   = [{22141,3,0},{33291,1,400}]%% 宝石合成
	};
get(22181)->
	#d_pearl{
		goods_id     = 22181,           %% 合成宝石ID
		goods_make   = [{22161,3,0},{33301,1,800}]%% 宝石合成
	};
get(22201)->
	#d_pearl{
		goods_id     = 22201,           %% 合成宝石ID
		goods_make   = [{22181,3,0},{33311,1,1200}]%% 宝石合成
	};
get(22221)->
	#d_pearl{
		goods_id     = 22221,           %% 合成宝石ID
		goods_make   = [{22201,3,0},{33321,1,1600}]%% 宝石合成
	};
get(23021)->
	#d_pearl{
		goods_id     = 23021,           %% 合成宝石ID
		goods_make   = [{23001,3,0},{33331,1,2}]%% 宝石合成
	};
get(23041)->
	#d_pearl{
		goods_id     = 23041,           %% 合成宝石ID
		goods_make   = [{23021,3,0},{33341,1,5}]%% 宝石合成
	};
get(23061)->
	#d_pearl{
		goods_id     = 23061,           %% 合成宝石ID
		goods_make   = [{23041,3,0},{33351,1,10}]%% 宝石合成
	};
get(23081)->
	#d_pearl{
		goods_id     = 23081,           %% 合成宝石ID
		goods_make   = [{23061,3,0},{33361,1,50}]%% 宝石合成
	};
get(23101)->
	#d_pearl{
		goods_id     = 23101,           %% 合成宝石ID
		goods_make   = [{23081,3,0},{33371,1,100}]%% 宝石合成
	};
get(23121)->
	#d_pearl{
		goods_id     = 23121,           %% 合成宝石ID
		goods_make   = [{23101,3,0},{33381,1,200}]%% 宝石合成
	};
get(23141)->
	#d_pearl{
		goods_id     = 23141,           %% 合成宝石ID
		goods_make   = [{23121,3,0},{33391,1,300}]%% 宝石合成
	};
get(23161)->
	#d_pearl{
		goods_id     = 23161,           %% 合成宝石ID
		goods_make   = [{23141,3,0},{33401,1,400}]%% 宝石合成
	};
get(23181)->
	#d_pearl{
		goods_id     = 23181,           %% 合成宝石ID
		goods_make   = [{23161,3,0},{33411,1,800}]%% 宝石合成
	};
get(23201)->
	#d_pearl{
		goods_id     = 23201,           %% 合成宝石ID
		goods_make   = [{23181,3,0},{33421,1,1200}]%% 宝石合成
	};
get(23221)->
	#d_pearl{
		goods_id     = 23221,           %% 合成宝石ID
		goods_make   = [{23201,3,0},{33431,1,1600}]%% 宝石合成
	};
get(24021)->
	#d_pearl{
		goods_id     = 24021,           %% 合成宝石ID
		goods_make   = [{24001,3,0},{33436,1,2}]%% 宝石合成
	};
get(24041)->
	#d_pearl{
		goods_id     = 24041,           %% 合成宝石ID
		goods_make   = [{24021,3,0},{33441,1,5}]%% 宝石合成
	};
get(24061)->
	#d_pearl{
		goods_id     = 24061,           %% 合成宝石ID
		goods_make   = [{24041,3,0},{33446,1,10}]%% 宝石合成
	};
get(24081)->
	#d_pearl{
		goods_id     = 24081,           %% 合成宝石ID
		goods_make   = [{24061,3,0},{33451,1,50}]%% 宝石合成
	};
get(24101)->
	#d_pearl{
		goods_id     = 24101,           %% 合成宝石ID
		goods_make   = [{24081,3,0},{33456,1,100}]%% 宝石合成
	};
get(24121)->
	#d_pearl{
		goods_id     = 24121,           %% 合成宝石ID
		goods_make   = [{24101,3,0},{33461,1,200}]%% 宝石合成
	};
get(24141)->
	#d_pearl{
		goods_id     = 24141,           %% 合成宝石ID
		goods_make   = [{24121,3,0},{33466,1,300}]%% 宝石合成
	};
get(24161)->
	#d_pearl{
		goods_id     = 24161,           %% 合成宝石ID
		goods_make   = [{24141,3,0},{33471,1,400}]%% 宝石合成
	};
get(24181)->
	#d_pearl{
		goods_id     = 24181,           %% 合成宝石ID
		goods_make   = [{24161,3,0},{33476,1,800}]%% 宝石合成
	};
get(24201)->
	#d_pearl{
		goods_id     = 24201,           %% 合成宝石ID
		goods_make   = [{24181,3,0},{33481,1,1200}]%% 宝石合成
	};
get(24221)->
	#d_pearl{
		goods_id     = 24221,           %% 合成宝石ID
		goods_make   = [{24201,3,0},{33486,1,1600}]%% 宝石合成
	};
get(25021)->
	#d_pearl{
		goods_id     = 25021,           %% 合成宝石ID
		goods_make   = [{25001,3,0},{33491,1,2}]%% 宝石合成
	};
get(25041)->
	#d_pearl{
		goods_id     = 25041,           %% 合成宝石ID
		goods_make   = [{25021,3,0},{33496,1,5}]%% 宝石合成
	};
get(25061)->
	#d_pearl{
		goods_id     = 25061,           %% 合成宝石ID
		goods_make   = [{25041,3,0},{33501,1,10}]%% 宝石合成
	};
get(25081)->
	#d_pearl{
		goods_id     = 25081,           %% 合成宝石ID
		goods_make   = [{25061,3,0},{33506,1,50}]%% 宝石合成
	};
get(25101)->
	#d_pearl{
		goods_id     = 25101,           %% 合成宝石ID
		goods_make   = [{25081,3,0},{33511,1,100}]%% 宝石合成
	};
get(25121)->
	#d_pearl{
		goods_id     = 25121,           %% 合成宝石ID
		goods_make   = [{25101,3,0},{33516,1,200}]%% 宝石合成
	};
get(25141)->
	#d_pearl{
		goods_id     = 25141,           %% 合成宝石ID
		goods_make   = [{25121,3,0},{33521,1,300}]%% 宝石合成
	};
get(25161)->
	#d_pearl{
		goods_id     = 25161,           %% 合成宝石ID
		goods_make   = [{25141,3,0},{33526,1,400}]%% 宝石合成
	};
get(25181)->
	#d_pearl{
		goods_id     = 25181,           %% 合成宝石ID
		goods_make   = [{25161,3,0},{33531,1,800}]%% 宝石合成
	};
get(25201)->
	#d_pearl{
		goods_id     = 25201,           %% 合成宝石ID
		goods_make   = [{25181,3,0},{33536,1,1200}]%% 宝石合成
	};
get(25221)->
	#d_pearl{
		goods_id     = 25221,           %% 合成宝石ID
		goods_make   = [{25201,3,0},{33541,1,1600}]%% 宝石合成
	};
get(26021)->
	#d_pearl{
		goods_id     = 26021,           %% 合成宝石ID
		goods_make   = [{26001,3,0},{33546,1,2}]%% 宝石合成
	};
get(26041)->
	#d_pearl{
		goods_id     = 26041,           %% 合成宝石ID
		goods_make   = [{26021,3,0},{33551,1,5}]%% 宝石合成
	};
get(26061)->
	#d_pearl{
		goods_id     = 26061,           %% 合成宝石ID
		goods_make   = [{26041,3,0},{33556,1,10}]%% 宝石合成
	};
get(26081)->
	#d_pearl{
		goods_id     = 26081,           %% 合成宝石ID
		goods_make   = [{26061,3,0},{33561,1,50}]%% 宝石合成
	};
get(26101)->
	#d_pearl{
		goods_id     = 26101,           %% 合成宝石ID
		goods_make   = [{26081,3,0},{33566,1,100}]%% 宝石合成
	};
get(26121)->
	#d_pearl{
		goods_id     = 26121,           %% 合成宝石ID
		goods_make   = [{26101,3,0},{33571,1,200}]%% 宝石合成
	};
get(26141)->
	#d_pearl{
		goods_id     = 26141,           %% 合成宝石ID
		goods_make   = [{26121,3,0},{33576,1,300}]%% 宝石合成
	};
get(26161)->
	#d_pearl{
		goods_id     = 26161,           %% 合成宝石ID
		goods_make   = [{26141,3,0},{33581,1,400}]%% 宝石合成
	};
get(26181)->
	#d_pearl{
		goods_id     = 26181,           %% 合成宝石ID
		goods_make   = [{26161,3,0},{33586,1,800}]%% 宝石合成
	};
get(26201)->
	#d_pearl{
		goods_id     = 26201,           %% 合成宝石ID
		goods_make   = [{26181,3,0},{33591,1,1200}]%% 宝石合成
	};
get(26221)->
	#d_pearl{
		goods_id     = 26221,           %% 合成宝石ID
		goods_make   = [{26201,3,0},{33596,1,1600}]%% 宝石合成
	};
get(27021)->
	#d_pearl{
		goods_id     = 27021,           %% 合成宝石ID
		goods_make   = [{27001,3,0},{33601,1,2}]%% 宝石合成
	};
get(27041)->
	#d_pearl{
		goods_id     = 27041,           %% 合成宝石ID
		goods_make   = [{27021,3,0},{33606,1,5}]%% 宝石合成
	};
get(27061)->
	#d_pearl{
		goods_id     = 27061,           %% 合成宝石ID
		goods_make   = [{27041,3,0},{33611,1,10}]%% 宝石合成
	};
get(27081)->
	#d_pearl{
		goods_id     = 27081,           %% 合成宝石ID
		goods_make   = [{27061,3,0},{33616,1,50}]%% 宝石合成
	};
get(27101)->
	#d_pearl{
		goods_id     = 27101,           %% 合成宝石ID
		goods_make   = [{27081,3,0},{33621,1,100}]%% 宝石合成
	};
get(27121)->
	#d_pearl{
		goods_id     = 27121,           %% 合成宝石ID
		goods_make   = [{27101,3,0},{33626,1,200}]%% 宝石合成
	};
get(27141)->
	#d_pearl{
		goods_id     = 27141,           %% 合成宝石ID
		goods_make   = [{27121,3,0},{33631,1,300}]%% 宝石合成
	};
get(27161)->
	#d_pearl{
		goods_id     = 27161,           %% 合成宝石ID
		goods_make   = [{27141,3,0},{33636,1,400}]%% 宝石合成
	};
get(27181)->
	#d_pearl{
		goods_id     = 27181,           %% 合成宝石ID
		goods_make   = [{27161,3,0},{33641,1,800}]%% 宝石合成
	};
get(27201)->
	#d_pearl{
		goods_id     = 27201,           %% 合成宝石ID
		goods_make   = [{27181,3,0},{33646,1,1200}]%% 宝石合成
	};
get(27221)->
	#d_pearl{
		goods_id     = 27221,           %% 合成宝石ID
		goods_make   = [{27201,3,0},{33651,1,1600}]%% 宝石合成
	};
get(28021)->
	#d_pearl{
		goods_id     = 28021,           %% 合成宝石ID
		goods_make   = [{28001,3,0},{33656,1,2}]%% 宝石合成
	};
get(28041)->
	#d_pearl{
		goods_id     = 28041,           %% 合成宝石ID
		goods_make   = [{28021,3,0},{33661,1,5}]%% 宝石合成
	};
get(28061)->
	#d_pearl{
		goods_id     = 28061,           %% 合成宝石ID
		goods_make   = [{28041,3,0},{33666,1,10}]%% 宝石合成
	};
get(28081)->
	#d_pearl{
		goods_id     = 28081,           %% 合成宝石ID
		goods_make   = [{28061,3,0},{33671,1,50}]%% 宝石合成
	};
get(28101)->
	#d_pearl{
		goods_id     = 28101,           %% 合成宝石ID
		goods_make   = [{28081,3,0},{33676,1,100}]%% 宝石合成
	};
get(28121)->
	#d_pearl{
		goods_id     = 28121,           %% 合成宝石ID
		goods_make   = [{28101,3,0},{33681,1,200}]%% 宝石合成
	};
get(28141)->
	#d_pearl{
		goods_id     = 28141,           %% 合成宝石ID
		goods_make   = [{28121,3,0},{33686,1,300}]%% 宝石合成
	};
get(28161)->
	#d_pearl{
		goods_id     = 28161,           %% 合成宝石ID
		goods_make   = [{28141,3,0},{33691,1,400}]%% 宝石合成
	};
get(28181)->
	#d_pearl{
		goods_id     = 28181,           %% 合成宝石ID
		goods_make   = [{28161,3,0},{33696,1,800}]%% 宝石合成
	};
get(28201)->
	#d_pearl{
		goods_id     = 28201,           %% 合成宝石ID
		goods_make   = [{28181,3,0},{33701,1,1200}]%% 宝石合成
	};
get(28221)->
	#d_pearl{
		goods_id     = 28221,           %% 合成宝石ID
		goods_make   = [{28201,3,0},{33706,1,1600}]%% 宝石合成
	};
get(29021)->
	#d_pearl{
		goods_id     = 29021,           %% 合成宝石ID
		goods_make   = [{29001,3,0},{33711,1,2}]%% 宝石合成
	};
get(29041)->
	#d_pearl{
		goods_id     = 29041,           %% 合成宝石ID
		goods_make   = [{29021,3,0},{33716,1,5}]%% 宝石合成
	};
get(29061)->
	#d_pearl{
		goods_id     = 29061,           %% 合成宝石ID
		goods_make   = [{29041,3,0},{33721,1,10}]%% 宝石合成
	};
get(29081)->
	#d_pearl{
		goods_id     = 29081,           %% 合成宝石ID
		goods_make   = [{29061,3,0},{33726,1,50}]%% 宝石合成
	};
get(29101)->
	#d_pearl{
		goods_id     = 29101,           %% 合成宝石ID
		goods_make   = [{29081,3,0},{33731,1,100}]%% 宝石合成
	};
get(29121)->
	#d_pearl{
		goods_id     = 29121,           %% 合成宝石ID
		goods_make   = [{29101,3,0},{33736,1,200}]%% 宝石合成
	};
get(29141)->
	#d_pearl{
		goods_id     = 29141,           %% 合成宝石ID
		goods_make   = [{29121,3,0},{33741,1,300}]%% 宝石合成
	};
get(29161)->
	#d_pearl{
		goods_id     = 29161,           %% 合成宝石ID
		goods_make   = [{29141,3,0},{33746,1,400}]%% 宝石合成
	};
get(29181)->
	#d_pearl{
		goods_id     = 29181,           %% 合成宝石ID
		goods_make   = [{29161,3,0},{33751,1,800}]%% 宝石合成
	};
get(29201)->
	#d_pearl{
		goods_id     = 29201,           %% 合成宝石ID
		goods_make   = [{29181,3,0},{33756,1,1200}]%% 宝石合成
	};
get(29221)->
	#d_pearl{
		goods_id     = 29221,           %% 合成宝石ID
		goods_make   = [{29201,3,0},{33761,1,1600}]%% 宝石合成
	};
get(30021)->
	#d_pearl{
		goods_id     = 30021,           %% 合成宝石ID
		goods_make   = [{30001,3,0},{33766,1,2}]%% 宝石合成
	};
get(30041)->
	#d_pearl{
		goods_id     = 30041,           %% 合成宝石ID
		goods_make   = [{30021,3,0},{33771,1,5}]%% 宝石合成
	};
get(30061)->
	#d_pearl{
		goods_id     = 30061,           %% 合成宝石ID
		goods_make   = [{30041,3,0},{33776,1,10}]%% 宝石合成
	};
get(30081)->
	#d_pearl{
		goods_id     = 30081,           %% 合成宝石ID
		goods_make   = [{30061,3,0},{33781,1,50}]%% 宝石合成
	};
get(30101)->
	#d_pearl{
		goods_id     = 30101,           %% 合成宝石ID
		goods_make   = [{30081,3,0},{33786,1,100}]%% 宝石合成
	};
get(30121)->
	#d_pearl{
		goods_id     = 30121,           %% 合成宝石ID
		goods_make   = [{30101,3,0},{33791,1,200}]%% 宝石合成
	};
get(30141)->
	#d_pearl{
		goods_id     = 30141,           %% 合成宝石ID
		goods_make   = [{30121,3,0},{33796,1,300}]%% 宝石合成
	};
get(30161)->
	#d_pearl{
		goods_id     = 30161,           %% 合成宝石ID
		goods_make   = [{30141,3,0},{33801,1,400}]%% 宝石合成
	};
get(30181)->
	#d_pearl{
		goods_id     = 30181,           %% 合成宝石ID
		goods_make   = [{30161,3,0},{33806,1,800}]%% 宝石合成
	};
get(30201)->
	#d_pearl{
		goods_id     = 30201,           %% 合成宝石ID
		goods_make   = [{30181,3,0},{33811,1,1200}]%% 宝石合成
	};
get(30221)->
	#d_pearl{
		goods_id     = 30221,           %% 合成宝石ID
		goods_make   = [{30201,3,0},{33816,1,1600}]%% 宝石合成
	};
get(31021)->
	#d_pearl{
		goods_id     = 31021,           %% 合成宝石ID
		goods_make   = [{31001,3,0},{33821,1,2}]%% 宝石合成
	};
get(31041)->
	#d_pearl{
		goods_id     = 31041,           %% 合成宝石ID
		goods_make   = [{31021,3,0},{33826,1,5}]%% 宝石合成
	};
get(31061)->
	#d_pearl{
		goods_id     = 31061,           %% 合成宝石ID
		goods_make   = [{31041,3,0},{33831,1,10}]%% 宝石合成
	};
get(31081)->
	#d_pearl{
		goods_id     = 31081,           %% 合成宝石ID
		goods_make   = [{31061,3,0},{33836,1,50}]%% 宝石合成
	};
get(31101)->
	#d_pearl{
		goods_id     = 31101,           %% 合成宝石ID
		goods_make   = [{31081,3,0},{33841,1,100}]%% 宝石合成
	};
get(31121)->
	#d_pearl{
		goods_id     = 31121,           %% 合成宝石ID
		goods_make   = [{31101,3,0},{33846,1,200}]%% 宝石合成
	};
get(31141)->
	#d_pearl{
		goods_id     = 31141,           %% 合成宝石ID
		goods_make   = [{31121,3,0},{33851,1,300}]%% 宝石合成
	};
get(31161)->
	#d_pearl{
		goods_id     = 31161,           %% 合成宝石ID
		goods_make   = [{31141,3,0},{33856,1,400}]%% 宝石合成
	};
get(31181)->
	#d_pearl{
		goods_id     = 31181,           %% 合成宝石ID
		goods_make   = [{31161,3,0},{33861,1,800}]%% 宝石合成
	};
get(31201)->
	#d_pearl{
		goods_id     = 31201,           %% 合成宝石ID
		goods_make   = [{31181,3,0},{33866,1,1200}]%% 宝石合成
	};
get(31221)->
	#d_pearl{
		goods_id     = 31221,           %% 合成宝石ID
		goods_make   = [{31201,3,0},{33871,1,1600}]%% 宝石合成
	};
get(32021)->
	#d_pearl{
		goods_id     = 32021,           %% 合成宝石ID
		goods_make   = [{32001,3,0},{33876,1,2}]%% 宝石合成
	};
get(32041)->
	#d_pearl{
		goods_id     = 32041,           %% 合成宝石ID
		goods_make   = [{32021,3,0},{33881,1,5}]%% 宝石合成
	};
get(32061)->
	#d_pearl{
		goods_id     = 32061,           %% 合成宝石ID
		goods_make   = [{32041,3,0},{33886,1,10}]%% 宝石合成
	};
get(32081)->
	#d_pearl{
		goods_id     = 32081,           %% 合成宝石ID
		goods_make   = [{32061,3,0},{33891,1,50}]%% 宝石合成
	};
get(32101)->
	#d_pearl{
		goods_id     = 32101,           %% 合成宝石ID
		goods_make   = [{32081,3,0},{33896,1,100}]%% 宝石合成
	};
get(32121)->
	#d_pearl{
		goods_id     = 32121,           %% 合成宝石ID
		goods_make   = [{32101,3,0},{33901,1,200}]%% 宝石合成
	};
get(32141)->
	#d_pearl{
		goods_id     = 32141,           %% 合成宝石ID
		goods_make   = [{32121,3,0},{33906,1,300}]%% 宝石合成
	};
get(32161)->
	#d_pearl{
		goods_id     = 32161,           %% 合成宝石ID
		goods_make   = [{32141,3,0},{33911,1,400}]%% 宝石合成
	};
get(32181)->
	#d_pearl{
		goods_id     = 32181,           %% 合成宝石ID
		goods_make   = [{32161,3,0},{33916,1,800}]%% 宝石合成
	};
get(32201)->
	#d_pearl{
		goods_id     = 32201,           %% 合成宝石ID
		goods_make   = [{32181,3,0},{33921,1,1200}]%% 宝石合成
	};
get(32221)->
	#d_pearl{
		goods_id     = 32221,           %% 合成宝石ID
		goods_make   = [{32201,3,0},{33926,1,1600}]%% 宝石合成
	};
get(_)->?null.
