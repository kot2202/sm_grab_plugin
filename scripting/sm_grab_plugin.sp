#include <sourcemod>
#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

#define MAX_DISTANCE 450
float maxDistance[MAXPLAYERS];

public Plugin myinfo = {
    name        = "Grab props plugin",
    author      = "kot",
    description = "Plugin that adds grab command",
    version     = "0.85",
};
ConVar g_hGrabAdminOnly;

Handle grabTimer[MAXPLAYERS+1];
int grabbed_prop = -1;

public void OnPluginStart()
{
	g_hGrabAdminOnly = CreateConVar("grab_admin_only", "1", "Is the grab plugin enabled for admins only", 0, true, 0.0, true, 1.0);
	RegConsoleCmd("+grab", Command_Grab);
	RegConsoleCmd("-grab", Command_Release);
}

public Action Command_Index(int client, int args)
{
	float pos[3];
	GetClientEyePosition(client, pos);
	PrintToChat(client,"%f", pos);
	return Plugin_Handled;
}

public Action Command_Grab(int client, int args)
{
	bool isAdmin = IsAdmin(client);
	if(g_hGrabAdminOnly.IntValue == 1)
	{
		if (!isAdmin)
		{
			PrintToChat(client, "[SM] You do not have access to this command.");
			return Plugin_Handled;
		}
	}

	int targEnt = GetClientAimTarget(client, false);
	if (targEnt == -1)
		return Plugin_Handled;
	if (targEnt < MaxClients && IsClientInGame(targEnt))
	{
		if(!isAdmin)
		{
			PrintToChat(client, "You cannot grab players!");
			return Plugin_Handled;
		}
	}

	float targEntOrigin[3];
	GetEntPropVector(targEnt, Prop_Send, "m_vecOrigin", targEntOrigin);
	grabbed_prop = targEnt;

	//PrintToChat(client, "entity id: %i",targEnt);
	//PrintToChat(client, "%d", grabbed_prop);

	DataPack pack;
	float clientEyePos[3];
	GetClientEyePosition(client, clientEyePos);

	maxDistance[client] = GetVectorDistance(targEntOrigin, clientEyePos);
	//PrintToChat(client, "%f %f %f",axis[0],axis[1],axis[2]);
	//PrintToChat(client, "%f",distance);
	grabTimer[client] = CreateDataTimer(0.1, UpdateTraceRay, pack, TIMER_REPEAT);
	pack.WriteCell(client);

	return Plugin_Handled;
}

public Action UpdateTraceRay(Handle timer, DataPack pack)
{
	pack.Reset();

	int client = pack.ReadCell();
	float newPos[3];
	newPos = GetRayEndPoint(client);
	TeleportEntity(grabbed_prop, newPos);

	return Plugin_Continue;
}

stock float[] GetRayEndPoint(int client)
{
	float RayEndPoint[3], clientEye[3], clientAngle[3], anglesVec[3], pos[3];
	GetClientEyePosition(client, clientEye);
	GetClientEyeAngles(client, clientAngle);
	GetAngleVectors(clientAngle, anglesVec, NULL_VECTOR, NULL_VECTOR);

	RayEndPoint[0] = clientEye[0] + (anglesVec[0]*maxDistance[client]);
	RayEndPoint[1] = clientEye[1] + (anglesVec[1]*maxDistance[client]);
	RayEndPoint[2] = clientEye[2] + (anglesVec[2]*maxDistance[client]);

	Handle trace = TR_TraceRayFilterEx(clientEye, RayEndPoint, MASK_SOLID, RayType_EndPoint, TraceRayTryToHit);
    
	TR_GetEndPosition(pos, trace);

	return pos;
}

public Action Command_Release(int client, int args)
{
	CloseHandle(grabTimer[client]);
	grabTimer[client] = null;
	return Plugin_Handled;
}

public bool TraceRayTryToHit(int entity, int mask)
{
	if((entity > 0 && entity <= MaxClients) || entity == grabbed_prop)
		return false;
	return true;
}

public bool IsAdmin(int client)
{
	if ( !GetAdminFlag( GetUserAdmin( client ), Admin_Generic, Access_Effective ) )
	{
		return false;
	}
	else return true;
}