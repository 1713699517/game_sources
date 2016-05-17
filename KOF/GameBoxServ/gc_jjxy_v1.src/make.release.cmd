del /F/Q Emakefile
del /F/Q include\logger.compile.hrl
copy /L Emakefile.release Emakefile
copy /L include\logger.release.hrl include\logger.compile.hrl

del /F/Q ..\bin_v1.jjxy\beam.release\*.beam
erl -s makecode make

del /F/Q include\logger.compile.hrl
copy /L include\logger.dev.hrl include\logger.compile.hrl
del /F/Q Emakefile
copy /L Emakefile.dev Emakefile



