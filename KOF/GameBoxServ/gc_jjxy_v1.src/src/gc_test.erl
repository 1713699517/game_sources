%% @author dreamxyp
%% @doc @todo Add description to gc_test.


-module(gc_test).

%% ====================================================================
%% API functions
%% ====================================================================
-export([btc/4]).

%% gc_test:btc(0.8,0.30,12, 4).
btc(O,U,D,C) ->
	btc2(0,O,U,D,C).

btc2(R,_O,_U,_D, 0) -> R;
btc2(R, O, U, D, C) ->
	R2 = R + O * D,
	btc2(R2, O * ( 1 / (1 + U ) ) , U, D, C-1).
	
	