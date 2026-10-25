![Game Optimizer CLI](banner-game-optimizer.png)
# 🚀 GameOptimizer CLI

Script simples para Windows que ativa o plano de energia de Alto Desempenho e limpa caches de shaders antes de jogar.

---

### ⚡ O que ele faz

- **Plano de energia:** ativa o plano Alto Desempenho e guarda qual plano estava ativo antes.
- **Limpeza de cache de shaders:** apaga o conteúdo das pastas `D3DSCache` (DirectX) e `NVIDIA\DXCache`.
- **Restauração:** volta ao plano de energia que você usava antes (ou ao Equilibrado, se não houver registro).
- **Avisa quando falha:** mostra quantos itens foram apagados e quantos não puderam ser (ex.: jogo aberto).

---

### 🛠️ Como usar

1. Baixe e extraia a pasta.
2. Dê dois cliques em `optimizer.bat` (ele abre o `optimizer.ps1`).
3. Escolha uma opção no menu.

**Não precisa de administrador.** Tudo roda com o seu usuário normal.

---

### ⚠️ Avisos

- Depois de limpar o cache de shaders, os jogos recriam os arquivos e **podem engasgar um pouco na primeira vez**. A limpeza ajuda quando o cache está corrompido; não aumenta FPS por si só.
- Alguns notebooks não têm o plano Alto Desempenho. O script avisa e não altera nada.
- Feche jogos e emuladores antes de limpar o cache.

---

### 👨‍💻 Autor

Criado por **[Xuslima](https://github.com/Xuslima)**
*Entusiasta Tech | IA & Vibe Coding | Hardware & Games*
