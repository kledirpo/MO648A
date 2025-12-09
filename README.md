# MO648A — Emulação 5G com switches P4

## 📄 Visão Geral  
Este repositório contém a implementação de um protótipo experimental que busca integrar emulação de rede 5G (usando Open5GS, UERANSIM e Mininet) com switches programáveis P4 (bmv2 + simple_switch). O objetivo inicial era permitir experimentos com encaminhamento customizado e telemetria em banda (INT), para avaliar impacto na latência e permitir monitoramento detalhado. Contudo, embora a pipeline P4 e os switches tenham sido corretamente configurados, a comunicação entre nós da topologia falhou, impossibilitando a realização dos testes planejados.  

Este trabalho documenta a estrutura do ambiente, os ajustes realizados, as dificuldades encontradas e as lições aprendidas — servindo como base para continuidade futura.  

## 🔧 Estrutura do Projeto  

/ ← raiz do repositório
├── topo/ ← modificações da topologia Mininet / Emu5gNet
├── p4/ ← código P4, JSON compilados e scripts de setup do bmv2
├── docs/ ← relatórios, resultados, logs de debug e anotações
├── figuras/ ← imagens documentadas durante os testes
└── README.md


## 🧪 Tecnologias e Ferramentas Utilizadas  

- Emulação 5G: **Open5GS**, **UERANSIM**  
- Emulação de rede: **Mininet** (via ambiente original de Emu5gNet)  
- Switch programável: **bmv2 + simple_switch + P4Runtime**  
- Linguagem de programação / configuração: P4 + Python / scripts de automação  

## 🚀 Como Executar / Experimentar  

> ⚠️ Observação: devido à falha no encaminhamento detectada originalmente, este projeto serve como protótipo e base de estudo — e não como solução final ou funcional.  

Para testar ou continuar o desenvolvimento:

```bash
# 1. Clone o repositório
git clone https://github.com/kledirpo/MO648A.git
cd MO648A

# 2. Instalar dependências (p4c, bmv2, P4Runtime, Mininet e demais componentes)
# — seguir instruções nos scripts de setup ou README na pasta /p4

# 3. Compilar o programa P4
cd p4
p4c --target bmv2 --arch v1model --output ./build <seu_programa>.p4

# 4. Configurar a topologia modificada
cd ..
# atualizar configs/ conforme necessário

# 5. Executar o ambiente de emulação  
# (Ex: script que inicia Mininet + bmv2 switches + Open5GS + UERANSIM)

# 6. Testes diagnóstico (ping, tcpdump, etc.) para verificar encaminhamento
