@REM Copyright (c) 2020 James J. Cook
@echo off

rem echo Compiling for 32-bit
rem set CPATH=C:\strawberry-perl-5.30.0.1-32bit-portable\c\lib\gcc\i686-w64-mingw32\8.3.0\include
rem set PATH=C:\strawberry-perl-5.30.0.1-32bit-portable\c\bin;%PATH%

rem echo Compiling for 64-bit
rem set CPATH=C:\strawberry-perl-5.30.0.1-64bit-portable\c\lib\gcc\x86_64-w64-mingw32\8.3.0\include
rem set PATH=C:\strawberry-perl-5.30.0.1-64bit-portable\c\bin;%PATH%

echo Compiling for 32-bit WINBUILDS
set CPATH=C:\winbuilds32\lib\gcc\i686-w64-mingw32\4.8.3\include
set PATH=C:\winbuilds32\bin;%PATH%

rem echo Compiling for 64-bit WINBUILDS
rem set CPATH=C:\winbuilds64\lib64\gcc\x86_64-w64-mingw32\4.8.3\include
rem set PATH=C:\winbuilds64\bin;%PATH%

rem echo Compiling for 32-bit Cygwin
rem set CPATH=C:\cygwin\lib\gcc\i686-pc-cygwin\7.4.0\include
rem set PATH=C:\cygwin\bin;%PATH%

rem echo Compiling for 64-bit Cygwin
rem set CPATH=C:\cygwin64\lib\gcc\x86_64-pc-cygwin\7.4.0\include
rem set PATH=C:\cygwin64\bin;%PATH%

echo on
