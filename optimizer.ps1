<#
    .SYNOPSIS
    GameOptimizer CLI - Otimizador rapido para jogos e emuladores.
    .AUTHOR
    Xuslima
#>

Clear-Host
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "       GAME OPTIMIZER CLI - BY XUSLIMA    " -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "1. Ativar Modo Game (Alto Desempenho)"
Write-Host "2. Limpar Cache de Shaders (DirectX / GPU)"
Write-Host "3. Otimizacao Completa (Plano + Limpeza)"
Write-Host "4. Restaurar Plano Equilibrado"
Write-Host "5. Sair"
Write-Host "==========================================" -ForegroundColor Cyan

$opcao = Read-Host "Escolha uma opcao [1-5]"

$directXCache = "$env:LOCALAPPDATA\D3DSCache"
$nvidiaCache = "$env:LOCALAPPDATA\NVIDIA\DXCache"

switch ($opcao) {
    "1" {
        Write-Host "`nAtivando plano de Alto Desempenho..." -ForegroundColor Yellow
        powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
        Write-Host "Plano de energia ativado com sucesso!" -ForegroundColor Green
    }
    "2" {
        Write-Host "`nLimpando caches de shaders e subpastas..." -ForegroundColor Yellow
        
        if (Test-Path $directXCache) {
            Remove-Item "$directXCache\*" -Recurse -Force -ErrorAction SilentlyContinue
        }
        if (Test-Path $nvidiaCache) {
            Remove-Item "$nvidiaCache\*" -Recurse -Force -ErrorAction SilentlyContinue
        }
        Write-Host "Cache de shaders limpo com sucesso!" -ForegroundColor Green
    }
    "3" {
        Write-Host "`nExecutando otimizacao completa..." -ForegroundColor Yellow
        powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
        
        if (Test-Path $directXCache) {
            Remove-Item "$directXCache\*" -Recurse -Force -ErrorAction SilentlyContinue
        }
        if (Test-Path $nvidiaCache) {
            Remove-Item "$nvidiaCache\*" -Recurse -Force -ErrorAction SilentlyContinue
        }
        Write-Host "Sistema otimizado para a sessao de jogo!" -ForegroundColor Green
    }
    "4" {
        Write-Host "`nRestaurando plano Equilibrado..." -ForegroundColor Yellow
        powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e
        Write-Host "Plano Equilibrado restaurado!" -ForegroundColor Green
    }
    "5" {
        Write-Host "`nSaindo..." -ForegroundColor DarkGray
        exit
    }
    Default {
        Write-Host "`nOpcao invalida." -ForegroundColor Red
    }
}

Write-Host "`nPressione qualquer tecla para continuar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
