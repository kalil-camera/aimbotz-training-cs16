# Aim Botz Training (CS 1.6) - YaPB Edition

[![Language: English](https://img.shields.io/badge/Language-English-blue)](#english) [![Language: Português](https://img.shields.io/badge/Idioma-Portugu%C3%AAs-green)](#português)

---

<a name="english"></a>
## 🇬🇧 English

An adaptation of the popular **Aim Botz** training map for Counter-Strike 1.6, optimized and restructured to work natively with **YaPB** (Yet Another PB) through a single clean, lightweight, and clutter-free AMXX plugin.

Based on the original map created by **Cha** ([GameBanana Mod 39942](https://gamebanana.com/mods/39942)).

---

### 🎯 About the Project

The original release on GameBanana bundled multiple legacy plugins, redundant configurations, and messy scripts that where required by zbot.

This version preserves the original map and assets (`aimbotzbycha`), but replaces the entire legacy plugin clutter with **a single streamlined AMX Mod X plugin** (`yapb_aim_botz`), specifically designed to manage bots through **YaPB**.

### ✨ Features

-  Automatically populates and configures bots on the Counter-Terrorist (CT) team.
- Bots spawn frozen in place and do not shoot (`yb_freeze_bots 1` and `yb_dont_shoot 1`), functioning as ideal training targets.
-  Human players automatically join the Terrorist (TR) team with auto-assigned skins. The team selection menu (`chooseteam`) is blocked to avoid disruptions.
-  When killed, bots respawn within 1 second via HamSandwich.
-  Firing automatically restores the weapon's magazine, allowing continuous spray and tap-shooting practice without manual reloading.
-  Bots always spawn with full armor (100 Vest & Helm) for authentic rifle (AK/M4/Deagle/AWP) headshot feedback.
-  The plugin checks for the map `aimbotzbycha` on precache and automatically pauses itself on any other map without impacting server operations.

---

### 📋 Prerequisites

To run this map and plugin, your Counter-Strike 1.6 installation requires:

1. **[Metamod-R](https://github.com/rehlds/Metamod-R/releases/)** 
2. **[AMX Mod X](https://www.amxmodx.org/)** (it was made on v1.10 but might work on v1.8)
3. **[YaPB (Yet Another PB)](https://github.com/yapb/yapb)** installed and running under Metamod

---

### 🚀 Installation

1. Make sure **Metamod**, **AMX Mod X**, and **YaPB** are properly installed in your Counter-Strike 1.6 directory.
2. Copy the contents of the `cstrike/` folder from this repository into your game's `cstrike/` folder (e.g., `C:\Program Files (x86)\Steam\steamapps\common\Half-Life\cstrike`).
3. Open `cstrike/addons/amxmodx/configs/plugins.ini` with a text editor and add the following line at the end:
   ```ini
   yapb_aim_botz.amxx
   ```
4. Launch the game and choose the map aimbotzbycha on New Game.
   
Observation: the plugin source is included in scripting folder, you can delete the .amxx and compile yourself if you don't trust the compiled version!

---

### ⚙️ Auto-Configured Settings

The plugin automatically applies the following CVars when the map starts:

| Command | Value | Description |
| :--- | :--- | :--- |
| `yb_quota` | `16` | Number of bots spawned (more won't work, they will spawn dead) |
| `yb_join_team` | `CT` | Forces bots into the CT team |
| `yb_dont_shoot` | `1` | Disables bot weapon firing |
| `yb_freeze_bots` | `1` | Freezes bots at spawn points |
| `mp_roundtime` | `30000` | Extended round duration to avoid end game |
| `mp_freezetime` | `0` | No round startup freeze time |
| `mp_autoteambalance` | `0` | Disables team autobalance |
| `mp_limitteams` | `0` | Disables team size limit checks |

> **Tip:** You can still adjust bot parameters on the fly via the console (e.g. `yb_quota <count>`, make they run around with `yb_freeze_bots 0/1`).

---


### 👤 Credits

- **Cha:** Original creator of the `aimbotzbycha` map ([GameBanana Mod 39942](https://gamebanana.com/mods/39942)).
- **Kalil:** Adaptation, cleanup, and development of the YaPB AMXX integration plugin.
- **YaPB Team / YaPB Project:** Modern, intelligent bot system for CS 1.6 / GoldSrc ([GitHub Repository](https://github.com/yapb/yapb)).

---
---

<a name="português"></a>
## 🇧🇷 Português

Adaptação do famoso mapa de treino de mira **Aim Botz** para Counter-Strike 1.6, otimizado e reestruturado para funcionar nativamente com o **YaPB** (Yet Another PB) através de um plugin AMXX limpo, leve e sem dependências desnecessárias.

Baseado no mapa original criado por **Cha** ([GameBanana Mod 39942](https://gamebanana.com/mods/39942)).

---

### 🎯 Sobre o Projeto

A versão original disponibilizada no GameBanana continha uma grande quantidade de plugins legados e configurações confusas para o zbot. 

Esta versão mantém os assets e o mapa original (`aimbotzbycha`), mas substitui toda a bagunça antiga por **um único plugin AMX Mod X moderno e enxuto** (`yapb_aim_botz`), projetado especificamente para gerenciar os bots **YaPB**.

### ✨ Principais Recursos

-  Adiciona e configura os bots automaticamente no time de Contra-Terroristas (CT).
-  Os bots nascem congelados e sem atirar (`yb_freeze_bots 1` e `yb_dont_shoot 1`), simulando os alvos do Aim Botz clássico.
-  O jogador humano é alocado diretamente no time Terrorista (TR) com seleção automática de skin, bloqueando a troca acidental de time.
- Ao morrer, o bot renasce em 1 segundo via HamSandwich.
-  Disparos recarregam o pente automaticamente, permitindo treino contínuo de spray e tap shooting sem pausas para reload.
-  Bots sempre nascem equipados com Kevlar + Helmet (100 de armor), garantindo treino preciso de headshots com rifles (AK/M4/Deagle/AWP).
-  O plugin verifica o mapa (`aimbotzbycha`) e só entra em ação nele; caso outro mapa seja carregado, o plugin pausa automaticamente sem afetar o servidor.

---

### 📋 Requisitos

Para que o mapa e o plugin funcionem corretamente, seu Counter-Strike 1.6 precisa ter instalado:

1. **[Metamod-R](https://github.com/rehlds/Metamod-R/releases/)** 
2. **[AMX Mod X](https://www.amxmodx.org/)** (eu usei a 1.10 mas acho que funciona na 1.8).
3. **[YaPB (Yet Another PB)](https://github.com/yapb/yapb)** instalado e rodando via Metamod.

---


### 🚀 Instalação

1. Certifique-se de que o **Metamod**, **AMX Mod X** e **YaPB** já estejam instalados no seu Counter-Strike 1.6.
2. Copie o conteúdo da pasta `cstrike/` deste repositório para o diretório raiz da sua pasta `cstrike` do jogo (ex.: `C:\Program Files (x86)\Steam\steamapps\common\Half-Life\cstrike`).
3. Abra o arquivo `cstrike/addons/amxmodx/configs/plugins.ini` em um editor de texto e adicione ao final da lista:
   ```ini
   yapb_aim_botz.amxx
   ```
4. Inicie o jogo ou servidor e escolha o mapa aimbotzbycha

---

### ⚙️ Configurações Aplicadas Automaticamente

O plugin já executa as seguintes variáveis e comandos de console na inicialização do mapa:

| Comando | Valor | Descrição |
| :--- | :--- | :--- |
| `yb_quota` | `16` | Quantidade de bots no mapa |
| `yb_join_team` | `CT` | Força os bots a entrarem como CT |
| `yb_dont_shoot` | `1` | Bots não disparam contra o jogador |
| `yb_freeze_bots` | `1` | Bots ficam estáticos nos pontos de spawn |
| `mp_roundtime` | `30000` | Round praticamente infinito (sem interrupções) |
| `mp_freezetime` | `0` | Sem contagem inicial ao reiniciar o round |
| `mp_autoteambalance` | `0` | Desativa o balanceamento automático de times |
| `mp_limitteams` | `0` | Desativa o limite de diferença de jogadores por time |
| `mp_startmoney` | `16000` | Dinheiro inicial máximo |

> **Nota:** Caso deseje alterar o número de bots ou o comportamento, você pode digitar os comandos do YaPB (`yb_quota <quantidade>`, `yb_freeze_bots 0/1`, etc.) diretamente no console do jogo.

---


### 👤 Créditos

- **Cha:** Criador do mapa original `aimbotzbycha` ([GameBanana Mod 39942](https://gamebanana.com/mods/39942)).
- **Kalil:** Adaptação, limpeza e criação do plugin AMXX para integração com o YaPB.
- **Equipe YaPB / Projeto YaPB:** Sistema de bots inteligente e de alto desempenho para CS 1.6 / GoldSrc ([Repositório no GitHub](https://github.com/yapb/yapb)).
