@echo off
title Game Optimizer CLI - By Xuslima
color 0b

:MENU
cls
echo ==========================================
echo        GAME OPTIMIZER CLI - BY XUSLIMA    
echo ==========================================
echo 1. Ativar Modo Game (Alto Desempenho)
echo 2. Limpar Cache de Shaders (DirectX / GPU)
echo 3. Otimizacao Completa (Plano + Limpeza)
echo 4. Restaurar Plano Equilibrado
echo 5. Sair
echo ==========================================
set /p opcao="Escolha uma opcao [1-5]: "

if "%opcao%"=="1" goto OPCAO1
if "%opcao%"=="2" goto OPCAO2
if "%opcao%"=="3" goto OPCAO3
if "%opcao%"=="4" goto OPCAO4
if "%opcao%"=="5" goto SAIR
goto MENU

:OPCAO1
echo.
echo Ativando plano de Alto Desempenho...
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
echo Plano ativado com sucesso!
pause
goto MENU

:OPCAO2
echo.
echo Limpando caches de shaders e subpastas...
if exist "%LOCALAPPDATA%\D3DSCache" (
    rmdir /s /q "%LOCALAPPDATA%\D3DSCache" >nul 2>&1
    mkdir "%LOCALAPPDATA%\D3DSCache" >nul 2>&1
)
if exist "%LOCALAPPDATA%\NVIDIA\DXCache" (
    del /q /f /s "%LOCALAPPDATA%\NVIDIA\DXCache\*" >nul 2>&1
)
echo Cache de shaders limpo com sucesso!
pause
goto MENU

:OPCAO3
echo.
echo Executando otimizacao completa...
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
if exist "%LOCALAPPDATA%\D3DSCache" (
    rmdir /s /q "%LOCALAPPDATA%\D3DSCache" >nul 2>&1
    mkdir "%LOCALAPPDATA%\D3DSCache" >nul 2>&1
)
if exist "%LOCALAPPDATA%\NVIDIA\DXCache" (
    del /q /f /s "%LOCALAPPDATA%\NVIDIA\DXCache\*" >nul 2>&1
)
echo Sistema otimizado para a sessao de jogo!
pause
goto MENU

:OPCAO4
echo.
echo Restaurando plano Equilibrado...
powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e
echo Plano Equilibrado restaurado!
pause
goto MENU

:SAIR
exit
