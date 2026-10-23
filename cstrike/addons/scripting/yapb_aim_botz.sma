#include <amxmodx> 
#include <amxmisc> 
#include <hamsandwich> 
#include <fakemeta>  
#include <cstrike> 
#include <fun> 

new PLUGIN[] = "AimBotz YaPB"; 
new AUTHOR[] = "https://github.com/kalil-camera/aimbotz-training-cs16"; 
new VERSION[] = "1.4"; 

enum {  
    CurWeapon_IsActive = 1,  
    CurWeapon_WeaponID,  
    CurWeapon_ClipAmmo  
}  

const XO_CBASEPLAYERWEAPON = 4  
const m_iClip = 51  
const m_iClientClip = 52  
const m_pActiveItem = 373  

new const g_iMaxClip[CSW_P90+1] = {  
    -1,  13, -1, 10,  1,  7,    1, 30, 30,  1,  30,   
        20, 25, 30, 35, 25,   12, 20, 10, 30, 100,   
        8 , 30, 30, 20,  2,    7, 30, 30, -1,  50  
}  

new bool:g_bIsValidMap = false; 


new const g_szWeapons[][] = {
    "models/w_ak47.mdl",
    "models/w_sg552.mdl",
    "models/w_m4a1.mdl",
    "models/w_galil.mdl",
    "models/w_famas.mdl",
    "models/w_aug.mdl",
    "models/w_usp.mdl",
    "models/w_deagle.mdl",
    "models/w_elite.mdl",
    "models/w_fiveseven.mdl",
    "models/w_glock18.mdl",
    "models/w_awp.mdl",
    "models/w_g3sg1.mdl",
	"models/w_sg550.mdl",    
    "models/w_scout.mdl",
    "models/w_p228.mdl",
    "models/w_m4a1.mdl"
}

new Float:g_fWeaponsOrigin[][3] = {
    {-659.0, 258.0, -138.0}, // AK47
    {-463.0, 252.0, -137.0}, // SG552
    {-404.0, 257.0, -137.0}, // M4A1
    {-519.0, 258.0, -137.0}, // GALIL
    {-556.0, 260.0, -137.0}, // FAMAS
    {-611.0, 255.0, -139.0}, // AUG
    {-252.0, 140.0, -132.0}, // USP
    {-253.0, 100.0, -131.0}, // DEAGLE
    {-253.0, 60.0, -134.0},  // ELITE
    {-253.0, 21.0, -132.0},  // FIVESEVEN
    {-252.0, -19.0, -131.0}, // GLOCK18
    {-771.0, -119.0, -136.0},// AWP
    {-760.0, -41.0, -135.0}, // G3SG1
    {-770.0, 26.0, -134.0}, // sg550
    {-771.0, 83.0, -134.0},  // SCOUT
    {-252.0, -59.0, -132.0}, // P228
    {-404.0, 257.0, -137.0}  // M4A1-S NOT USED, KEEP HERE FOR NOW!
};

new Float:g_fWeaponsAngles[][3] = {
    {0.0, 180.0, 90.0},
    {0.0, 180.0, 90.0},
    {0.0, 180.0, 90.0},
    {0.0, 180.0, 90.0},
    {0.0, 180.0, 90.0},
    {0.0, 180.0, 90.0},
    {0.0, 90.0, 90.0},
    {0.0, 90.0, 90.0},
    {0.0, 90.0, 90.0},
    {0.0, 90.0, 90.0},
    {0.0, 90.0, 90.0},
    {0.0, 90.0, 90.0},
    {0.0, 90.0, 90.0},
    {0.0, 90.0, 90.0},
    {0.0, 90.0, 90.0},
    {0.0, 180.0, 90.0},
    {0.0, 180.0, 90.0}
};


// Variáveis do Menu 
new bool:g_bInfiniteAmmo = true;  
new g_iBotArmor = 0;
new bool:g_bHeadshotOnly = false;

// Variáveis do Timer
new bool:g_bTimerActive[33];
new Float:g_fStartTime[33];
new g_iKillCount[33];
new g_HudSyncTimer;

public plugin_precache() { 
    new szMapName[32]; 
    get_mapname(szMapName, charsmax(szMapName)); 
     
    if(equali(szMapName, "aimbotz")) { 
        g_bIsValidMap = true; 
        for(new i = 0; i < sizeof(g_szWeapons); i++) {
            precache_model(g_szWeapons[i]);
        }
    } 
} 


public plugin_init() { 
    register_plugin(PLUGIN, VERSION, AUTHOR); 
     
    if(!g_bIsValidMap) { 
        pause("ad"); 
        return; 
    } 
    RegisterHam(Ham_Killed, "player", "PlayerKilled", 1);  
    RegisterHam(Ham_Spawn, "player", "PlayerSpawn_Post", 1);
    RegisterHam(Ham_TraceAttack, "player", "Fwd_TraceAttack");  
     
    register_message(get_user_msgid("CurWeapon"), "Message_CurWeapon"); 
    
    register_clcmd("chooseteam", "Block_ChooseTeam"); 
    register_clcmd("say /menu", "Cmd_ShowMenu"); 
    register_clcmd("say_team /menu", "Cmd_ShowMenu"); 
    
    // Comandos do Timer
    register_clcmd("say /timer", "Cmd_ToggleTimer");
    register_clcmd("say_team /timer", "Cmd_ToggleTimer");
    
    // Sincronizador de HUD e Task infinita para atualizar o cronômetro na tela
    g_HudSyncTimer = CreateHudSyncObj();
	
    set_task(0.1, "Task_SpawnWeaponModels"); 
    set_task(0.1, "Task_UpdateTimerHUD", .flags="b");
} 

public Block_ChooseTeam(id) { 
    return PLUGIN_HANDLED; 
} 

public client_putinserver(id) { 
    if(!g_bIsValidMap) return; 
     
    if(!is_user_bot(id)) { 
        set_task(0.1, "Task_AutoJoinTR", id); 
    } 
} 

public Task_SpawnWeaponModels() {
    for(new i = 0; i < sizeof(g_szWeapons); i++) {
        new ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"));
        if(!ent) continue;
        
        engfunc(EngFunc_SetModel, ent, g_szWeapons[i]);
        engfunc(EngFunc_SetOrigin, ent, g_fWeaponsOrigin[i]);
        
        set_pev(ent, pev_angles, g_fWeaponsAngles[i]);
        set_pev(ent, pev_solid, SOLID_NOT);
        set_pev(ent, pev_movetype, MOVETYPE_NONE);
        
        dllfunc(DLLFunc_Spawn, ent);
    }
}


// Limpa o timer caso o jogador desconecte no meio do treino
public client_disconnected(id) {
    g_bTimerActive[id] = false;
}

public Task_AutoJoinTR(id) { 
    if(is_user_connected(id) && !is_user_bot(id)) { 
        engclient_cmd(id, "jointeam", "1"); 
        engclient_cmd(id, "joinclass", "5"); 
    } 
} 

public plugin_cfg() { 
    if(!g_bIsValidMap) return; 
     
    server_cmd("yb_quota 0"); 
    server_cmd("mp_autoteambalance 0"); 
    server_cmd("mp_limitteams 0"); 
    server_cmd("mp_freezetime 0"); 
    server_cmd("mp_roundtime 500"); 
    server_cmd("mp_startmoney 16000"); 
     
    server_cmd("yb_join_team CT"); 
    server_cmd("yb_botskin_ct 0"); 
    server_cmd("yb_chat 0"); 
    server_cmd("yb_chat_percent 0"); 
    server_cmd("yb_difficulty 0"); 
    server_cmd("yb_display_welcome_text 0"); 
    server_cmd("yb_freeze_bots 1");  
    server_cmd("sv_restartround 1"); 
    server_cmd("yb_quota_mode fill"); 
    set_task(0.2, "Task_AddBots"); 
} 

public Task_AddBots() { 
    server_cmd("yb_quota 16"); 
} 

// ---------------- TIMER ---------------- // 
public Cmd_ToggleTimer(id) {
    if(!g_bTimerActive[id]) {
        // Inicia
        g_bTimerActive[id] = true;
        g_fStartTime[id] = get_gametime();
        g_iKillCount[id] = 0;
        
        client_print_color(id, print_team_default, "^4[AimBotz] ^1Timer ^4ACTIVE^1! Start blasting!");
    } else {
        g_bTimerActive[id] = false;
        new Float:fTime = get_gametime() - g_fStartTime[id];
        
        new Float:fKPM = 0.0;
        if(fTime > 0.0) {
            fKPM = (float(g_iKillCount[id]) / fTime) * 60.0;
        }
        
        client_print_color(id, print_team_default, "^4[AimBotz] ^1Timer ^3FINISHED^1!");
        client_print_color(id, print_team_default, "^4[AimBotz] ^1Kills: ^4%d", g_iKillCount[id]);
        client_print_color(id, print_team_default, "^4[AimBotz] ^1Time: ^3%.1f seg", fTime);
        client_print_color(id, print_team_default, "^4[AimBotz] ^1KPM: ^4%.1f ^1(Kills Per Minute)", fKPM);
        
        // Apaga o HUD da tela instantaneamente
        ClearSyncHud(id, g_HudSyncTimer);
    }
    return PLUGIN_HANDLED;
}

public Task_UpdateTimerHUD() {
    for(new i = 1; i <= get_maxplayers(); i++) {
        if(is_user_connected(i) && g_bTimerActive[i]) {
            set_hudmessage(0, 255, 0, 0.02, 0.20, 0, 0.0, 0.5, 0.0, 0.0, -1);
            ShowSyncHudMsg(i, g_HudSyncTimer, "Time: %.1f seg^nKills: %d", get_gametime() - g_fStartTime[i], g_iKillCount[i]);
        }
    }
}
// --------------------------------------- // 

// ---------------- MENU ---------------- // 
public Cmd_ShowMenu(id) { 
    new menu = menu_create("\yTraining Menu", "Menu_Handler"); 
    new szItem[128], szArmorStatus[32]; 
     
    formatex(szItem, charsmax(szItem), "Infinite Ammo: %s", g_bInfiniteAmmo ? "\yOn" : "\rOff"); 
    menu_additem(menu, szItem, "1"); 
     
    switch(g_iBotArmor) { 
        case 0: copy(szArmorStatus, charsmax(szArmorStatus), "\rNone"); 
        case 1: copy(szArmorStatus, charsmax(szArmorStatus), "\yKevlar"); 
        case 2: copy(szArmorStatus, charsmax(szArmorStatus), "\yKevlar + Helmet"); 
    } 
    formatex(szItem, charsmax(szItem), "Bot Equip: %s", szArmorStatus); 
    menu_additem(menu, szItem, "2"); 
    
    formatex(szItem, charsmax(szItem), "Headshot Only: %s", g_bHeadshotOnly ? "\yOn" : "\rOff");
    menu_additem(menu, szItem, "3");
     
    menu_display(id, menu, 0); 
    return PLUGIN_HANDLED; 
} 

public Menu_Handler(id, menu, item) { 
    if(item == MENU_EXIT) { 
        menu_destroy(menu); 
        return PLUGIN_HANDLED; 
    } 
     
    new data[6], iName[64]; 
    new access, callback; 
    menu_item_getinfo(menu, item, access, data, 5, iName, 63, callback); 
     
    new choice = str_to_num(data); 
     
    switch(choice) { 
        case 1: { 
            g_bInfiniteAmmo = !g_bInfiniteAmmo; 
        } 
        case 2: { 
            g_iBotArmor++;  
            if(g_iBotArmor > 2) g_iBotArmor = 0;  
            UpdateBotsArmor();  
        } 
        case 3: { 
            g_bHeadshotOnly = !g_bHeadshotOnly;
        }
    } 
     
    menu_destroy(menu); 
    Cmd_ShowMenu(id);  
    return PLUGIN_HANDLED; 
} 
// -------------------------------------- // 

public Fwd_TraceAttack(Victim, Attacker, Float:Damage, Float:Direction[3], tracehandle, DamageBits) {
    if(!g_bHeadshotOnly) return HAM_IGNORED;
    
    if(!is_user_alive(Victim) || !is_user_connected(Attacker)) return HAM_IGNORED;
    
    if(is_user_bot(Victim) && Victim != Attacker) {
        new hitgroup = get_tr2(tracehandle, TR_iHitgroup);
        if(hitgroup != HIT_HEAD) {
            return HAM_SUPERCEDE; 
        }
    }
    
    return HAM_IGNORED;
}

public UpdateBotsArmor() { 
    for(new i = 1; i <= get_maxplayers(); i++) { 
        if(is_user_alive(i) && is_user_bot(i)) { 
            if(g_iBotArmor == 1) { 
                cs_set_user_armor(i, 100, CS_ARMOR_KEVLAR); 
            } else if(g_iBotArmor == 2) { 
                cs_set_user_armor(i, 100, CS_ARMOR_VESTHELM); 
            } else { 
                cs_set_user_armor(i, 0, CS_ARMOR_NONE); 
            } 
        } 
    } 
} 

public PlayerSpawn_Post(id) { 
    if(is_user_alive(id)) { 
        if(is_user_bot(id)) { 
            if(g_iBotArmor == 1) { 
                cs_set_user_armor(id, 100, CS_ARMOR_KEVLAR); 
            } else if(g_iBotArmor == 2) { 
                cs_set_user_armor(id, 100, CS_ARMOR_VESTHELM); 
            } else { 
                cs_set_user_armor(id, 0, CS_ARMOR_NONE); 
            } 
        } else { 
            cs_set_user_money(id, 16000); 
             
            new weapons[32], num; 
            get_user_weapons(id, weapons, num); 
            for(new i = 0; i < num; i++) { 
                if(weapons[i] != CSW_KNIFE && weapons[i] != CSW_C4) { 
                    cs_set_user_bpammo(id, weapons[i], 200); 
                } 
            } 
        } 
    } 
} 

public PlayerKilled(Victim, Attacker, ShouldGib) { 
    if (!is_user_alive(Victim)) 
        set_task(1.0, "PlayerRespawn", Victim); 
        
    if (is_user_connected(Attacker) && Victim != Attacker) {
        if (g_bTimerActive[Attacker]) {
            g_iKillCount[Attacker]++;
        }
    }
} 

public PlayerRespawn(id) { 
    if (!is_user_alive(id) && CS_TEAM_T <= cs_get_user_team(id) <= CS_TEAM_CT) { 
        ExecuteHamB(Ham_CS_RoundRespawn, id); 
        set_task(0.1, "UpdateBotsArmor");
    } 
} 

public Message_CurWeapon(iMsgId, iMsgDest, id) {  
    if(!g_bInfiniteAmmo) return;  

    if(get_msg_arg_int(CurWeapon_IsActive)) {  
        new iMaxClip = g_iMaxClip[get_msg_arg_int(CurWeapon_WeaponID)];  
        if(iMaxClip > 2 && get_msg_arg_int(CurWeapon_ClipAmmo) < iMaxClip) {  
            new iWeapon = get_pdata_cbase(id, m_pActiveItem);  
            if(iWeapon > 0) {  
                set_pdata_int(iWeapon, m_iClip, iMaxClip, XO_CBASEPLAYERWEAPON);  
                set_pdata_int(iWeapon, m_iClientClip, iMaxClip, XO_CBASEPLAYERWEAPON);  
                set_msg_arg_int(CurWeapon_ClipAmmo, ARG_BYTE, iMaxClip);  
            }  
        }  
    }  
}