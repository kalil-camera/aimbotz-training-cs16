# Aim Botz Training (CS 1.6) - YaPB Edition

[![Language: English](https://img.shields.io/badge/Language-English-blue)](#english) [![Language: Português](https://img.shields.io/badge/Idioma-Portugu%C3%AAs-green)](#português)

[![YouTube Video](https://img.youtube.com/vi/zb1rMaefaAk/maxresdefault.jpg)](https://www.youtube.com/watch?v=zb1rMaefaAk)
---

<a name="english"></a>
## EN English

An adaptation of the popular CSGO/CS2 **Aim Botz** training map, made for Counter-Strike 1.6, optimized and restructured to work natively with **YaPB**, through a single lightweight AMXX plugin.
Based on the original map created by **Cha** ([GameBanana Mod 39942](https://gamebanana.com/mods/39942)).

---

###  About the Project

The original release bundled multiple legacy plugins, redundant configurations, and messy scripts, besides that where required by zbot.
This version preserves the original map and assets (`aimbotzbycha`), but replaces the entire legacy plugin clutter with a single  AMX  plugin (`yapb_aim_botz`), specifically designed to manage **YaPB** bots.

###  Features

-  Automatically populates and configures bots on the Counter-Terrorist (CT) team.
-  Bots spawn frozen in place and do not shoot, functioning as ideal training targets.
-  Human players automatically join the Terrorist (TR) team. The team selection menu is blocked to avoid disruptions.
-  When killed, bots respawn within 1 second.
-  Type /menu in game chat to configure options (currently infinite ammo and bots kevlar/helmet)
-  The plugin checks for the map `aimbotzbycha` and automatically pauses itself on any other map.

---

### Prerequisites

To run this map and plugin, your Counter-Strike 1.6 installation requires:

1. **[Metamod-R](https://github.com/rehlds/Metamod-R/) or [Metamod-P] (https://github.com/Bots-United/metamod-p/)** 
2. **[AMX Mod X](https://www.amxmodx.org/)** 
3. **[YaPB](https://github.com/yapb/yapb)** installed and running under Metamod

---

### Installation

1. Make sure **Metamod**, **AMX Mod X**, and **YaPB** are properly installed in your Counter-Strike 1.6 directory.
2. Copy the contents of the `cstrike/` folder from this repository into your game's `cstrike/` folder.
3. Open `cstrike/addons/amxmodx/configs/plugins.ini` with a text editor and add the following line at the end:
   ```ini
   yapb_aim_botz.amxx
   ```
4. Launch the game and choose the map aimbotzbycha on New Game.
   
Observation: the plugin source is included in scripting folder, you can delete the .amxx and compile it yourself if you don't trust the compiled version!

---


### 👤 Credits

- **Cha:** Original creator of the `aimbotzbycha` map ([GameBanana Mod 39942](https://gamebanana.com/mods/39942)).
- **Kalil:** Adaptation, cleanup, and development of the YaPB AMXX integration plugin.
- **YaPB Team / YaPB Project:** Modern, intelligent bot system for CS 1.6 / GoldSrc ([GitHub Repository](https://github.com/yapb/yapb)).

---
---

<a name="portugues"></a>
## 🇧🇷 Português (Brasil)

Uma adaptação do popular mapa de treino **Aim Botz** para Counter-Strike 1.6, otimizado e reestruturado para funcionar nativamente com o **YaPB**  através de um único plugin AMXX leve.
Baseado no mapa original criado por **Cha** ([GameBanana Mod 39942](https://gamebanana.com/mods/39942)).

---

###  Sobre o Projeto

O lançamento original na GameBanana incluía vários plugins antigos, configurações redundantes e scripts confusos, além de só funcionar com zbot.
Esta versão preserva o mapa e os arquivos originais (`aimbotzbycha`), mas substitui toda a desordem de plugins antigos por um único plugin AMX otimizado (`yapb_aim_botz`), projetado especificamente para gerenciar os bots através do **YaPB**.

###  Funcionalidades

-  Adiciona e configura os bots automaticamente na equipe dos CTs.
-  Os bots nascem congelados no lugar e não atiram, funcionando como alvos ideais para treino.
-  Jogadores humanos entram automaticamente na equipe dos TRs. O menu de seleção de equipe é bloqueado para evitar interrupções.
-  Ao serem mortos, os bots renascem em 1 segundo.
-  Digite /menu no chat do jogo para configurar as opções (atualmente, munição infinita e colete/capacete dos bots).
-  O plugin verifica se o mapa é o `aimbotzbycha` e pausa automaticamente em qualquer outro mapa.

---

### Pré-requisitos

Para rodar este mapa e plugin, a sua instalação do Counter-Strike 1.6 precisa de:

1. **[Metamod-R](https://github.com/rehlds/Metamod-R/) ou [Metamod-P] (https://github.com/Bots-United/metamod-p/)** 
2. **[AMX Mod X](https://www.amxmodx.org/)** 
3. **[YaPB (Yet Another PB)](https://github.com/yapb/yapb)** instalado e rodando sob o Metamod

---

### Instalação

1. Certifique-se de que o **Metamod**, o **AMX Mod X** e o **YaPB** estão instalados corretamente no diretório do seu Counter-Strike 1.6.

2. Copie o conteúdo da pasta `cstrike/` deste repositório para a pasta `cstrike/` do seu jogo.
3. Abra o arquivo `cstrike/addons/amxmodx/configs/plugins.ini` com um editor de texto e adicione a seguinte linha no final:
   ```ini
   yapb_aim_botz.amxx

Observação: O código-fonte do plugin está na pasta scripting, para os mais desconfiados, podem compilar e rodar a sua própria versão!

---

### 👤 Créditos

- **Cha:** Criador do mapa original `aimbotzbycha` ([GameBanana Mod 39942](https://gamebanana.com/mods/39942)).
- **Kalil:** Adaptação, limpeza e criação do plugin AMXX para integração com o YaPB.
- **Equipe YaPB / Projeto YaPB:** Sistema de bots inteligente e de alto desempenho para CS 1.6 / GoldSrc ([Repositório no GitHub](https://github.com/yapb/yapb)).
