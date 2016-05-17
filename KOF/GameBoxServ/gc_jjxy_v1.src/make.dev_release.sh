#!/bin/sh
rm -rf Emakefile
rm -rf include/logger.compile.hrl
cp Emakefile.release Emakefile
cp include/logger.dev.hrl include/logger.compile.hrl

rm -rf ../bin_v1.jjxy/beam.release/*.beam
erl -s makecode make

