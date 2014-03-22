@echo off
::
:: deodex tools for Android rom
:: Script created by wuxianlin
:: Version : 1.0
:: File    : deodex.bat
:: Usage   : 1. put app and framework folder into system folder(system\app\*.apk,*.odex;system\framework\*.jar,*.odex)
::           2. deodex.bat [apilevel] [bootclasspath]
title deodex tools
color 0a
set apilevel=%1
set bootclasspatch=%2

set home=%cd%
set app=%home%\system\app
set framework=%home%\system\framework
set temp_framework=%home%\system\temp_framework

setlocal EnableDelayedExpansion
if "%2"=="" for /r %framework% %%a in (*.jar) do set bootclasspatch=!bootclasspatch!:%%~nxa
if "%bootclasspatch:~0,1%"==":" set bootclasspatch=%bootclasspatch:~1%
endlocal

echo.
echo.����Android��ܱ���....
if exist %temp_framework% rd /q /s %temp_framework%
mkdir %temp_framework%
xcopy %framework% %temp_framework% /E/Q >nul
echo.
echo.Android��ܱ������
echo.
echo.��ʼ�ϲ�frameworkĿ¼...
for %%i in (baksmali.jar smali.jar 7z.exe 7z.dll) do copy tools\%%i %framework% >nul
for /r %framework% %%a in (*.odex) do call :deodex %%a jar
echo.�ϲ�frameworkĿ¼���
for %%i in (baksmali.jar smali.jar 7z.exe 7z.dll) do del /f %framework%\%%i 
echo.
echo.��ʼ�ϲ�appĿ¼...
for %%i in (baksmali.jar smali.jar 7z.exe 7z.dll) do copy tools\%%i %app% >nul
for /r %app% %%a in (*.odex) do call :deodex %%a apk
echo.�ϲ�appĿ¼���
for %%i in (baksmali.jar smali.jar 7z.exe 7z.dll) do del /f %app%\%%i 
echo. 
echo ɾ��Android��ܱ���....
rd /q /s %temp_framework%
echo.
echo. 
echo.deodex��ɣ�
pause
goto :eof
:deodex
if %2 equ jar (
cd %framework%
) else if %2 equ apk (
cd %app%
) else (
echo.����
pause
exit
)
echo.---- ��ʼ�ϲ�%~n1.%2 ----
echo.���ڽ� %~n1.odex ת��Ϊ classes.dex ...
if "%apilevel%"=="" (
java -jar baksmali.jar -d %temp_framework% -c %bootclasspatch% -x %1
java -jar smali.jar out -o classes.dex
) else (
java -jar baksmali.jar -a %apilevel% -d %temp_framework% -x %1
java -jar smali.jar -a %apilevel% out -o classes.dex
)
del %1 /Q
rd out /Q /S
echo.���ڽ� %~n1.%2 �� classes.dex �ϲ�...
7z.exe a -tzip %~n1.%2 classes.dex>nul
del classes.dex /Q
cd ..\..\
echo.---- �ϲ�%~n1.%2�ɹ� ----
echo.
goto :eof