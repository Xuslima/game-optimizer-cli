@echo off
rem Este arquivo apenas abre o optimizer.ps1 (a logica fica toda nele).
rem
rem -NoProfile: nao carrega configuracoes pessoais do PowerShell
rem -ExecutionPolicy Bypass: permite rodar este script nesta janela, sem
rem     mudar a configuracao de seguranca do seu Windows
rem -File "%~dp0optimizer.ps1": roda o arquivo que esta na mesma pasta do .bat
title Game Optimizer CLI - By Xuslima
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0optimizer.ps1"
