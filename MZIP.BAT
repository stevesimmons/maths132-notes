@echo off
if "%2."=="." goto nodeldisk

del %2\mn*.zip

:nodeldisk
pkzip -es -a -P %1 @mzip.lst
if "%2."=="." goto end
copy %1.zip %2
:end

