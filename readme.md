# Aim Botz Training (CS 1.6) - YaPB Edition

[![YouTube Video](https://img.youtube.com/vi/zb1rMaefaAk/maxresdefault.jpg)](https://www.youtube.com/watch?v=zb1rMaefaAk)

---
An adaptation of the popular CSGO/CS2 **Aim Botz** training map, made for Counter-Strike 1.6, optimized and restructured to work natively with **YaPB**.

The original release bundled multiple redundant configurations and messy scripts, external files to display the weapons on the wall and external WAD files.

This version, the plugin handles weapon display without using custom models, everything is compressed inside the map file (bsp), a single file.

One amxx plugin and one map, and you are ready to practice your aim.

The YAPB map waypoints are also included, in case some people are on low end PCs that take too much time to create them.

Several YaPB cvars are set on map start, I've tried to predict and avoid most bugs by setting the optimal settings. This is only applied when loading aimbotz map.

Made for YaPB bots, will not work with zbot.

###  Features

-  Automatically populates and configures bots on the CT team.
-  Bots spawn frozen in place and do not shoot.
-  Human players automatically join the TR team. The team selection menu is blocked to avoid disruptions.
-  Shoot the weapons on the wall (the bottom part) to recieve it. You can hold all weapons at once.
-  When killed, bots respawn within 1 second.
-  Type /menu in game chat to tweak options (infinite ammo, bots kevlar/helmet, headshot only...)
-  Type /timer to start a timer with kill count, type /timer again to stop.
-  The plugin checks for the map `aimbotz` and will not load on other maps.

---

### Prerequisites

To run this map and plugin, your Counter-Strike 1.6 installation requires:

1. **[Metamod-R](https://github.com/rehlds/Metamod-R/) or [Metamod-P](https://github.com/Bots-United/metamod-p/)** 
2. **[AMX Mod X](https://www.amxmodx.org/)** 
3. **[YaPB](https://github.com/yapb/yapb)** installed and running under Metamod

---

### Installation

1. Make sure **Metamod**, **AMX Mod X**, and **YaPB** are properly installed in your Counter-Strike 1.6 directory.
2. Download the [latest release (click here)](https://github.com/kalil-camera/aimbotz-training-cs16/releases/latest)
2. Extract the `cstrike/` folder into your game main folder, (where your cstrike is located).
3. Open `cstrike/addons/amxmodx/configs/plugins.ini` with a text editor and add the following line at the end:
   ```ini
   yapb_aim_botz.amxx
   ```
   Save and close the file. 
4. Launch the game and choose the map aimbotz on New Game.
   
   
Observation: the plugin source is in the repository, if you want to edit/compile it yourself. It is not required to play.

---


### Credits

- **uLLeticaL and Cha:** Original creator of the `aimbotz` map.
- **Kalil:** Adaptation, cleanup, and development of the YaPB AMXX integration plugin.
- **YaPB Team / YaPB Project:** Modern, intelligent bot system for CS 1.6 / GoldSrc ([GitHub Repository](https://github.com/yapb/yapb)).

---