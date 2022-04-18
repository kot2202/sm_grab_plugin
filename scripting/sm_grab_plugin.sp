#include <sourcemod>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = {
    name        = "",
    author      = "",
    description = "",
    version     = "0.0.0",
    url         = ""
};

public void OnPluginStart()
{
    RegAdminCmd("sm_grabtest", Command_Grab, ADMFLAG_ROOT);
}

public Action Command_Grab(int client, int args)
{
    
    return Plugin_Handled;
}