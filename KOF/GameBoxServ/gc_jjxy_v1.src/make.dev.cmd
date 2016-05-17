del /F/Q Emakefile
del /F/Q include\logger.compile.hrl
copy /L Emakefile.dev Emakefile
copy /L include\logger.dev.hrl include\logger.compile.hrl

del /F/Q ..\bin_v1.jjxy\beam\*.beam
erl -s makecode make
