<#
    GameOptimizer CLI v1.1.0
    Autor: Xuslima

    O que este script faz:
      1. Troca o plano de energia do Windows para Alto Desempenho
         (e guarda qual era o plano antes, para voltar depois).
      2. Limpa os caches de shaders (DirectX e NVIDIA).
      3. Restaura o plano de energia que voce usava antes.

    NAO precisa de administrador: tudo aqui roda com o seu usuario normal.
#>

# ------------------------------------------------------------
# PARTE 1: CONFIGURACOES (valores que o script usa em varios lugares)
# Deixar tudo aqui no topo facilita mudar depois.
# ------------------------------------------------------------

# Seguranca: este script apaga arquivos. Se o Windows nao informar a pasta
# LOCALAPPDATA (muito raro), paramos aqui para nao apagar o lugar errado.
if (-not $env:LOCALAPPDATA) {
    Write-Host "Erro: nao encontrei a pasta LOCALAPPDATA. Saindo por seguranca." -ForegroundColor Red
    exit 1
}

# Os "codigos" (GUIDs) dos planos de energia do Windows.
# Sao iguais em todos os PCs com Windows.
$GuidAltoDesempenho = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
$GuidEquilibrado    = "381b4222-f694-41f0-9685-ff5bb260df2e"

# Onde guardamos o plano que estava ativo antes de trocar.
# Join-Path junta pedacos de caminho com a barra certa (\).
$PastaDados           = Join-Path $env:LOCALAPPDATA "GameOptimizer"
$ArquivoPlanoAnterior = Join-Path $PastaDados "plano_anterior.txt"

# Lista das pastas de cache que vamos limpar.
# Se um dia quiser limpar outra, basta adicionar uma linha aqui.
$PastasCache = @(
    (Join-Path $env:LOCALAPPDATA "D3DSCache"),
    (Join-Path $env:LOCALAPPDATA "NVIDIA\DXCache")
)

# "Formato" de um GUID, usado para achar o codigo dentro do texto do powercfg.
# Ex.: 381b4222-f694-41f0-9685-ff5bb260df2e
$PadraoGuid = '[0-9a-fA-F]{8}(-[0-9a-fA-F]{4}){3}-[0-9a-fA-F]{12}'


# ------------------------------------------------------------
# PARTE 2: FUNCOES (cada uma faz uma tarefa e pode ser reutilizada)
# ------------------------------------------------------------

# Descobre qual plano de energia esta ativo agora.
function Obter-PlanoAtivo {
    # "powercfg /getactivescheme" escreve algo como:
    # "GUID do Esquema de Energia: 381b4222-... (Equilibrado)"
    $saida = powercfg /getactivescheme

    # Procuramos o GUID dentro desse texto.
    $achou = [regex]::Match("$saida", $PadraoGuid)
    if ($achou.Success) { return $achou.Value }
    return $null   # nao achou nada
}

# Opcao 1: ativa o plano de Alto Desempenho.
function Ativar-ModoGame {
    Write-Host "`nAtivando plano de Alto Desempenho..." -ForegroundColor Yellow

    # Em alguns PCs (principalmente notebooks) esse plano nao existe.
    # Antes de tentar, conferimos a lista de planos.
    $lista = powercfg /list | Out-String
    if ($lista -notmatch $GuidAltoDesempenho) {
        Write-Host "Este PC nao tem o plano Alto Desempenho. Nada foi alterado." -ForegroundColor Red
        return   # sai da funcao
    }

    $atual = Obter-PlanoAtivo

    # Se ja esta no Alto Desempenho, nao precisa fazer nada.
    # (Tambem evita sobrescrever o plano original que ja foi guardado.)
    if ($atual -eq $GuidAltoDesempenho) {
        Write-Host "O plano Alto Desempenho ja esta ativo." -ForegroundColor Green
        return
    }

    # Guarda o plano atual num arquivo, para a opcao 4 poder voltar a ele.
    if ($atual) {
        New-Item -ItemType Directory -Path $PastaDados -Force | Out-Null
        Set-Content -Path $ArquivoPlanoAnterior -Value $atual
    }

    powercfg /setactive $GuidAltoDesempenho

    # $LASTEXITCODE guarda o resultado do ultimo programa externo:
    # 0 = deu certo, qualquer outro numero = deu erro.
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Plano de Alto Desempenho ativado!" -ForegroundColor Green
    } else {
        Write-Host "Nao consegui ativar o plano (codigo $LASTEXITCODE)." -ForegroundColor Red
    }
}

# Opcao 2: limpa os caches de shaders.
function Limpar-Cache {
    Write-Host "`nLimpando caches de shaders..." -ForegroundColor Yellow

    $removidos = 0   # contador de itens apagados
    $falhas    = 0   # contador de itens que nao foi possivel apagar

    foreach ($pasta in $PastasCache) {

        # Se a pasta nao existe (ex.: PC sem placa NVIDIA), so avisamos e seguimos.
        if (-not (Test-Path $pasta)) {
            Write-Host "Pasta nao encontrada (tudo bem): $pasta" -ForegroundColor DarkGray
            continue   # pula para a proxima pasta da lista
        }

        # Lista tudo que existe DENTRO da pasta (a pasta em si nao sera apagada).
        $itens = Get-ChildItem -Path $pasta -Force -ErrorAction SilentlyContinue

        foreach ($item in $itens) {
            try {
                # -ErrorAction Stop faz o erro cair no "catch" abaixo,
                # assim conseguimos contar as falhas em vez de esconde-las.
                Remove-Item -LiteralPath $item.FullName -Recurse -Force -ErrorAction Stop
                $removidos++
            }
            catch {
                # Normalmente acontece quando o arquivo esta em uso (jogo aberto).
                $falhas++
            }
        }
    }

    Write-Host "Itens removidos: $removidos" -ForegroundColor Green
    if ($falhas -gt 0) {
        Write-Host "Itens que nao deu para apagar: $falhas (feche jogos e emuladores e tente de novo)." -ForegroundColor Red
    }
}

# Opcao 4: volta ao plano que estava ativo antes da opcao 1.
function Restaurar-Plano {
    Write-Host "`nRestaurando plano de energia..." -ForegroundColor Yellow

    # Se nao houver plano guardado, usamos o Equilibrado como padrao.
    $destino = $GuidEquilibrado

    if (Test-Path $ArquivoPlanoAnterior) {
        $salvo = (Get-Content $ArquivoPlanoAnterior -Raw).Trim()
        # So aceitamos o que foi lido se realmente parecer um GUID.
        if ($salvo -match ('^' + $PadraoGuid + '$')) {
            $destino = $salvo
        }
    }

    powercfg /setactive $destino

    # Se o plano guardado nao existe mais (foi apagado), tentamos o Equilibrado.
    if ($LASTEXITCODE -ne 0 -and $destino -ne $GuidEquilibrado) {
        Write-Host "O plano anterior nao existe mais. Usando o Equilibrado." -ForegroundColor DarkYellow
        $destino = $GuidEquilibrado
        powercfg /setactive $destino
    }

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Plano de energia restaurado!" -ForegroundColor Green
    } else {
        Write-Host "Nao consegui restaurar o plano (codigo $LASTEXITCODE)." -ForegroundColor Red
    }
}


# ------------------------------------------------------------
# PARTE 3: MENU (repete ate voce escolher Sair)
# ------------------------------------------------------------

while ($true) {   # "while ($true)" = repete para sempre, ate chamarmos "exit"
    Clear-Host
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "       GAME OPTIMIZER CLI - BY XUSLIMA    " -ForegroundColor Green
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "1. Ativar Modo Game (Alto Desempenho)"
    Write-Host "2. Limpar Cache de Shaders (DirectX / GPU)"
    Write-Host "3. Otimizacao Completa (Plano + Limpeza)"
    Write-Host "4. Restaurar plano de energia anterior"
    Write-Host "5. Sair"
    Write-Host "==========================================" -ForegroundColor Cyan

    $opcao = Read-Host "Escolha uma opcao [1-5]"

    # "switch" escolhe o que fazer conforme o valor digitado.
    switch ($opcao) {
        "1" { Ativar-ModoGame }
        "2" { Limpar-Cache }
        "3" { Ativar-ModoGame; Limpar-Cache }
        "4" { Restaurar-Plano }
        "5" { Write-Host "`nSaindo..." -ForegroundColor DarkGray; exit 0 }
        default { Write-Host "`nOpcao invalida." -ForegroundColor Red }
    }

    # Espera 3 segundos para voce conseguir ler o resultado e volta ao menu sozinho.
    # Para mais tempo, aumente o numero (ex.: -Seconds 5).
    Start-Sleep -Seconds 3
}
