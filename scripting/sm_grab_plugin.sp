#include <sourcemod>
#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

<<<<<<< Updated upstream
#define MAX_DISTANCE 200
=======
<<<<<<< HEAD
#define MAX_DISTANCE 450
float maxDistance[MAXPLAYERS];
=======
#define MAX_DISTANCE 200
>>>>>>> main
>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
    RegAdminCmd("sm_indextest", Command_Index, ADMFLAG_ROOT);
=======
<<<<<<< HEAD
=======
    RegAdminCmd("sm_indextest", Command_Index, ADMFLAG_ROOT);
>>>>>>> main
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
	float targEntOrigin[3];
=======
<<<<<<< HEAD
=======
	float targEntOrigin[3];
>>>>>>> main
>>>>>>> Stashed changes
	int targEnt = GetClientAimTarget(client, false);
	if (targEnt == -1)
		return Plugin_Handled;

<<<<<<< Updated upstream
=======
<<<<<<< HEAD
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
=======
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
=======
>>>>>>> main
>>>>>>> Stashed changes
	grabTimer[client] = CreateDataTimer(0.1, UpdateTraceRay, pack, TIMER_REPEAT);
	pack.WriteCell(client);

	return Plugin_Handled;
}

public Action UpdateTraceRay(Handle timer, DataPack pack)
{
	pack.Reset();
<<<<<<< Updated upstream
=======
<<<<<<< HEAD

	int client = pack.ReadCell();
	float newPos[3];
	newPos = GetRayEndPoint(client);
	TeleportEntity(grabbed_prop, newPos);

	return Plugin_Continue;
=======
>>>>>>> Stashed changes
	int client = pack.ReadCell();
	float newPos[3], eyePos[3];
	float dist;
	newPos = GetRayEndPoint(client);
	GetEntPropVector(grabbed_prop, Prop_Send, "m_vecOrigin", newPos);

	TeleportEntity(grabbed_prop, newPos);
<<<<<<< Updated upstream
=======
>>>>>>> main
>>>>>>> Stashed changes
}

stock float[] GetRayEndPoint(int client)
{
<<<<<<< Updated upstream
	float RayEndPoint[3];
	
	float clientEye[3], clientAngle[3], anglesVec[3];
=======
<<<<<<< HEAD
	float RayEndPoint[3], clientEye[3], clientAngle[3], anglesVec[3], pos[3];
=======
	float RayEndPoint[3];
	
	float clientEye[3], clientAngle[3], anglesVec[3];
>>>>>>> main
>>>>>>> Stashed changes
	GetClientEyePosition(client, clientEye);
	GetClientEyeAngles(client, clientAngle);
	GetAngleVectors(clientAngle, anglesVec, NULL_VECTOR, NULL_VECTOR);

<<<<<<< Updated upstream
	RayEndPoint[0] = clientEye[0] + (anglesVec[0]*MAX_DISTANCE);
	RayEndPoint[1] = clientEye[1] + (anglesVec[1]*MAX_DISTANCE);
	RayEndPoint[2] = clientEye[2] + (anglesVec[2]*MAX_DISTANCE);

	TR_TraceRayFilterEx(clientEye, RayEndPoint, MASK_SOLID, RayType_EndPoint, TraceRayTryToHit);
    
=======
<<<<<<< HEAD
	RayEndPoint[0] = clientEye[0] + (anglesVec[0]*maxDistance[client]);
	RayEndPoint[1] = clientEye[1] + (anglesVec[1]*maxDistance[client]);
	RayEndPoint[2] = clientEye[2] + (anglesVec[2]*maxDistance[client]);

	Handle trace = TR_TraceRayFilterEx(clientEye, RayEndPoint, MASK_SOLID, RayType_EndPoint, TraceRayTryToHit);
    
	TR_GetEndPosition(pos, trace);

	return pos;
=======
	RayEndPoint[0] = clientEye[0] + (anglesVec[0]*MAX_DISTANCE);
	RayEndPoint[1] = clientEye[1] + (anglesVec[1]*MAX_DISTANCE);
	RayEndPoint[2] = clientEye[2] + (anglesVec[2]*MAX_DISTANCE);

	TR_TraceRayFilterEx(clientEye, RayEndPoint, MASK_SOLID, RayType_EndPoint, TraceRayTryToHit);
    
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
=======
>>>>>>> main
>>>>>>> Stashed changes
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