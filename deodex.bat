@echo off
::
:: deodex tools for mt6592
:: Script created by wuxianlin
:: Version : 1.0
:: File    : deodex.bat
:: Usage   : 1. put app and framework folder into system folder(system\app\*.apk,*.odex;system\framework\*.jar,*.odex)
::           2. start by double click deodex.bat
title deodex tools
color 0a
echo.+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
echo.I                                                                             I
echo.I                           MT6592 deodex������                               I
echo.I                                                    Made by  wuxianlin       I
echo.+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
echo.                                                         
if not exist system\app (
echo.����û�з���system\appĿ¼
pause
exit )
if not exist system\framework (
echo.����û�з���system\frameworkĿ¼
pause
exit )
if not exist tools (
echo.���󣺹����䲻����,toolsĿ¼����ɾ��
pause
exit )
echo.����Android��ܱ���....
if exist system\temp_framework rd /q /s system\temp_framework
mkdir system\temp_framework
xcopy system\framework system\temp_framework /E/Q >nul
echo.
echo.Android��ܱ������
echo.
echo.��ʼ�ϲ�frameworkĿ¼...
for %%i in (baksmali.jar smali.jar 7z.exe 7z.dll) do copy tools\%%i system\framework\ >nul
for /r system\framework\ %%a in (*.odex) do call :deodex %%a jar
echo.�ϲ�frameworkĿ¼���
for %%i in (baksmali.jar smali.jar 7z.exe 7z.dll) do del /f system\framework\%%i 
echo.
echo.��ʼ�ϲ�appĿ¼...
for %%i in (baksmali.jar smali.jar 7z.exe 7z.dll) do copy tools\%%i system\app\ >nul
for /r system\app\ %%a in (*.odex) do call :deodex %%a apk
echo.�ϲ�appĿ¼���
for %%i in (baksmali.jar smali.jar 7z.exe 7z.dll) do del /f system\app\%%i 
echo. 
echo ɾ��Android��ܱ���....
rd /q /s system\temp_framework
echo.
echo. 
echo.����ȫ��������
pause
goto :eof
:deodex
if %2 equ jar (
cd system\framework
) else if %2 equ apk (
cd system\app
) else (
echo.����
pause
exit
)
echo.---- ��ʼ�ϲ�%~n1.%2 ----
echo.���ڽ� %~n1.odex ת��Ϊ classes.dex ...
java -jar baksmali.jar -a 17 -T ../../tools/inline.txt -d ../temp_framework -x %1
java -jar smali.jar -a 17 out -o classes.dex
del %1 /Q
rd out /Q /S
echo.���ڽ� %~n1.%2 �� classes.dex �ϲ�...
7z.exe a -tzip %~n1.%2 classes.dex>nul
del classes.dex /Q
cd ..\..\
echo.---- �ϲ�%~n1.%2�ɹ� ----
echo.
goto :eof