cd  beam/
erl -sname jjxy_s301 +P 1024000 -smp enable -boot start_sasl -config sasl_log -setcookie goodsnetha -s gc_server gc_start
pause