REM Copyright (c) 2020 James J. Cook
call setenv_gcc64.bat
gcc -c -Wall -Werror -fpic ..\myquadmath_dll.c
rem gcc -c -Werror ..\myquadmath_dll.c
pause
gcc -shared -o libmyquadmath.dll myquadmath_dll.o -lquadmath
pause
gcc -L. -Wall -o myquadmath_test.exe ..\myquadmath_test.c -lmyquadmath
pause
myquadmath_test.exe
pause
