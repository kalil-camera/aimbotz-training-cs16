#include <amxmodx>
#include <amxmisc>
#include <hamsandwich>
#include <fakemeta> 
#include <cstrike>
#include <fun>

new PLUGIN[] = "AimBotz YaPB";
new AUTHOR[] = "Map by Cha. Adapted by Kalil";
new VERSION[] = "1.1";

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

// Variáveis do Menu
new bool:g_bInfiniteAmmo = true; 
new g_iBotArmor = 2;             

public plugin_precache() {
    new szMapName[32];
    get_mapname(szMapName, charsmax(szMapName));
    
    if(equali(szMapName, "aimbotzbycha")) {
        g_bIsValidMap = true;
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
    RegisterHam(Ham_CS_Player_ResetMaxSpeed, "player", "Fwd_ResetMaxSpeed_Post", 1);
    
    register_message(get_user_msgid("CurWeapon"), "Message_CurWeapon");
   
	register_clcmd("chooseteam", "Block_ChooseTeam");
    register_clcmd("say /menu", "Cmd_ShowMenu");
    register_clcmd("say_team /menu", "Cmd_ShowMenu");
}

public Block_ChooseTeam(id) {
    return PLUGIN_HANDLED;
}

public client_putinserver(id) {
    if(!g_bIsValidMap) return;
    
    if(!is_user_bot(id)) {
        set_task(1.0, "Task_AutoJoinTR", id);
    }
}

public Task_AutoJoinTR(id) {
    if(is_user_connected(id) && !is_user_bot(id)) {
        engclient_cmd(id, "jointeam", "1");
        engclient_cmd(id, "joinclass", "5");
    }
}

// Congela o bot pela velocidade física do jogo (mantendo a engine de animação rodando)
public Fwd_ResetMaxSpeed_Post(id) {
    if(is_user_alive(id) && is_user_bot(id)) {
        // 0.001 é o suficiente para travar ele no lugar sem congelar os frames
        set_pev(id, pev_maxspeed, 0.001);
    }
}

public plugin_cfg() {
    if(!g_bIsValidMap) return;
    
    server_cmd("yb_quota 0");
    server_cmd("mp_autoteambalance 0");
    server_cmd("mp_limitteams 0");
    server_cmd("mp_freezetime 0");
    server_cmd("mp_roundtime 30000");
    server_cmd("mp_startmoney 16000");
    
    server_cmd("yb_join_team CT");
    server_cmd("yb_dont_shoot 1"); 
    server_cmd("yb_weapon_mode 4"); 
    server_cmd("yb_stop 1"); 
    server_cmd("sv_restartround 1");
    set_task(1.0, "Task_AddBots");
}

public Task_AddBots() {
    server_cmd("yb_quota 16");
}

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
    }
    
    menu_destroy(menu);
    Cmd_ShowMenu(id); 
    return PLUGIN_HANDLED;
}
// -------------------------------------- //

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

public PlayerKilled(Victim) {
    if (!is_user_alive(Victim))
        set_task(1.0, "PlayerRespawn", Victim);
}

public PlayerRespawn(id) {
    if (!is_user_alive(id) && CS_TEAM_T <= cs_get_user_team(id) <= CS_TEAM_CT) {
        ExecuteHamB(Ham_CS_RoundRespawn, id);
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