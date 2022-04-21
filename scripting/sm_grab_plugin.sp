#include <sourcemod>
#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

#define MAX_DISTANCE 200

public Plugin myinfo = {
    name        = "",
    author      = "",
    description = "",
    version     = "0.0.0",
    url         = ""
};

Handle grabTimer[MAXPLAYERS+1];
int grabbed_prop = -1;

public void OnPluginStart()
{
    RegAdminCmd("+grabtest", Command_Grab, ADMFLAG_ROOT);
    RegAdminCmd("-grabtest", Command_Release, ADMFLAG_ROOT);
    RegAdminCmd("sm_indextest", Command_Index, ADMFLAG_ROOT);
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
	float targEntOrigin[3];
	int targEnt = GetClientAimTarget(client, false);
	if (targEnt == -1)
		return Plugin_Handled;

	GetEntPropVector(targEnt, Prop_Send, "m_vecOrigin", targEntOrigin);
	
	grabbed_prop = targEnt;

	PrintToChat(client, "entity id: %i",targEnt);
	PrintToChat(client, "%d", grabbed_prop);
	//////////////////

	DataPack pack;

	float axis[3], clientEyePos[3];
	float distance;
	GetClientEyePosition(client, clientEyePos);
	axis = GetRayEndPoint(client); //X-axis position of traceray hit

	distance = GetVectorDistance(axis, clientEyePos);


	PrintToChat(client, "%f %f %f",axis[0],axis[1],axis[2]);
	PrintToChat(client, "%f",distance);

	grabTimer[client] = CreateDataTimer(0.1, UpdateTraceRay, pack, TIMER_REPEAT);
	pack.WriteCell(client);

	return Plugin_Handled;
}

public Action UpdateTraceRay(Handle timer, DataPack pack)
{
	pack.Reset();
	int client = pack.ReadCell();
	float newPos[3], eyePos[3];
	float dist;
	newPos = GetRayEndPoint(client);
	GetEntPropVector(grabbed_prop, Prop_Send, "m_vecOrigin", newPos);

	TeleportEntity(grabbed_prop, newPos);
}

stock float[] GetRayEndPoint(int client)
{
	float RayEndPoint[3];
	
	float clientEye[3], clientAngle[3], anglesVec[3];
	GetClientEyePosition(client, clientEye);
	GetClientEyeAngles(client, clientAngle);
	GetAngleVectors(clientAngle, anglesVec, NULL_VECTOR, NULL_VECTOR);

	RayEndPoint[0] = clientEye[0] + (anglesVec[0]*MAX_DISTANCE);
	RayEndPoint[1] = clientEye[1] + (anglesVec[1]*MAX_DISTANCE);
	RayEndPoint[2] = clientEye[2] + (anglesVec[2]*MAX_DISTANCE);

	TR_TraceRayFilterEx(clientEye, RayEndPoint, MASK_SOLID, RayType_EndPoint, TraceRayTryToHit);
    
	if (TR_DidHit(INVALID_HANDLE))
	{
		PrintToChat(client, "Hit something");
	}
	else
	{
		PrintToChat(client, "Hit nothing");
	}
	TR_GetEndPosition(RayEndPoint);

	return RayEndPoint;
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