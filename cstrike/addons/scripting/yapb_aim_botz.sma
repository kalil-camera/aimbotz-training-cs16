#include <amxmodx>
#include <amxmisc>
#include <hamsandwich>
#include <fakemeta> 
#include <cstrike>
#include <fun>

new PLUGIN[] = "AimBotz YaPB";
new AUTHOR[] = "Map by Cha. Adapted by Kalil";
new VERSION[] = "1.6";

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

public plugin_precache() {
    new szMapName[32];
    get_mapname(szMapName, charsmax(szMapName));
    
    // Ativa o plugin SOMENTE neste mapa
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
    
    register_message(get_user_msgid("CurWeapon"), "Message_CurWeapon");
    
    // Bloqueia a tecla 'M' para o jogador não abrir o menu de times
    register_clcmd("chooseteam", "Block_ChooseTeam");
}

public Block_ChooseTeam(id) {
    return PLUGIN_HANDLED;
}

// Quando o jogador conectar, agenda a entrada no TR
public client_putinserver(id) {
    if(!g_bIsValidMap) return;
    
    if(!is_user_bot(id)) {
        set_task(1.0, "Task_AutoJoinTR", id);
    }
}

// Força a entrada silenciosa no time Terrorista
public Task_AutoJoinTR(id) {
    if(is_user_connected(id) && !is_user_bot(id)) {
        // jointeam 1 = TR | joinclass 5 = Auto-Select Skin
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
    server_cmd("mp_roundtime 30000");
    server_cmd("mp_startmoney 16000");
    
    server_cmd("yb_join_team CT");
    server_cmd("yb_dont_shoot 1"); 
    server_cmd("yb_freeze_bots 1");
    
    server_cmd("sv_restartround 1");
    set_task(1.0, "Task_AddBots");
}

public Task_AddBots() {
    server_cmd("yb_quota 16");
}

public PlayerSpawn_Post(id) {
    if(is_user_alive(id)) {
        if(is_user_bot(id)) {
            cs_set_user_armor(id, 100, CS_ARMOR_VESTHELM);
        } else {
            cs_set_user_money(id, 16000);
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