
//********************** CAMERA **********************//

Type tCamera
	
		
	name$
	Obj as integer
	
	UniqueId as integer // it's the unique ID, defined at creation (by oBject[i].UniqueId = GameProp.UniqueId : inc GameProp.UniqueId), it's for the behavior
	
	// parameters
	near
	far
	fov
	speed as float
	ortho
	orthoW
	
	// selection by border 
	Spr as integer // sprite center
	xp_screen# as integer
    yp_screen# as integer
   
	
	ParentId as integer
	Group as String[0]
	Layer as integer[0]
	
	
	// Behavior - comportement
	Behavior as tBehavior[]
	Dir as integer // for the object moving (behavior)
	
	Lock as tLock
	
	x 
	y
	z
	rx
	ry
	rz
	
	// editor
	Selected
	Locked
	Hide
	
	r 
	g
	b
	StartX
	Starty
	StartZ
	
	// for game
	LootAt as string
	IsMainCamera 
	
		
Endtype



Function InitCamera()
	
	Global Dim Camera[] as tCamera // the 3D objects


endfunction




Function AddCamera(x,y,z,rx,ry,rz,near,far,fov)
	
	//to create a new camera
	i = camera.length +1
	camera.length = i
	
	n = CloneObject(oCamera)
	SetObjectPosition(n, x, y, z)
	SetObjectRotation(n, rx, ry, rz)
	// SetObjectLightMode(n, 0)
	SetObjectColor(n, 50,50,50,255)
	SetObjectVisible(n,1)
	SetObjectScale(n, 10,10,10)
	Camera[i].Obj = n
	
	// camera prop
	Camera[i].r = 50
	Camera[i].g = 50
	Camera[i].b = 50
	
	Camera[i].far = far
	Camera[i].fov = fov
	Camera[i].near = near
	Camera[i].name$ = "camera"+str(i)
	Camera[i].x = x
	Camera[i].y = y
	Camera[i].z = z
	Camera[i].rx = rx
	Camera[i].ry = ry
	Camera[i].rz = rz
	AssetTyp = C_ASSETCAMERA
	
	
	// update panel select
	Lag_FreeallGadgetItemByGadget(C_Gad_SelectList)
	CreateAllGadgetItem()
	
Endfunction


Function GetObjCameraProp()
	
	// to set the prop of the selected light on the gadgets
	
	if ObjId >-1 and ObjId <= Camera.length
		
		// LAG_SetGadgetName(C_Gad_Tra,"Int")
		
		LAG_SetGadgetText(C_Gad_NameObj,Camera[ObjId].Name$)
		
		LAG_SetGadgetText(C_Gad_X,str(Camera[ObjId].x))
		LAG_SetGadgetText(C_Gad_Y,str(Camera[ObjId].Y))
		LAG_SetGadgetText(C_Gad_Z,str(Camera[ObjId].Z))
		
		LAG_SetGadgetText(C_Gad_rX,str(Camera[ObjId].rx))
		LAG_SetGadgetText(C_Gad_rY,str(Camera[ObjId].rY))
		LAG_SetGadgetText(C_Gad_rZ,str(Camera[ObjId].rZ))
		
		LAG_SetGadgetState(C_Gad_lock_X,Camera[ObjId].Lock.Pos.x)
		LAG_SetGadgetState(C_Gad_lock_y,Camera[ObjId].Lock.Pos.y)
		LAG_SetGadgetState(C_Gad_lock_z,Camera[ObjId].Lock.Pos.z)
		
		LAG_SetGadgetState(C_Gad_lock_rX,Camera[ObjId].Lock.Rot.x)
		LAG_SetGadgetState(C_Gad_lock_ry,Camera[ObjId].Lock.Rot.y)
		LAG_SetGadgetState(C_Gad_lock_rz,Camera[ObjId].Lock.Rot.z)
		
		LAG_SetGadgetText(C_Gad_Size,str(Camera[ObjId].fov,0))
		LAG_SetGadgetText(C_Gad_Sx,str(Camera[ObjId].near,2))
		LAG_SetGadgetText(C_Gad_Sy,str(Camera[ObjId].far,0))
		LAG_SetGadgetText(C_Gad_Sz,str(Camera[ObjId].orthoW,0))
		
		
		LAG_SetGadgetState(C_Gad_R,Camera[ObjId].R)
		LAG_SetGadgetState(C_Gad_G,Camera[ObjId].G)
		LAG_SetGadgetState(C_Gad_B,Camera[ObjId].B)
		
		LAG_SetGadgetState(C_Gad_Hide,Camera[ObjId].Hide)
		LAG_SetGadgetState(C_Gad_Lock,Camera[ObjId].Locked)
		
		SetAssetGadget()
		
	endif
	
endFunction


Function SetObjcameraProp()
	
	if objid>-1 and objId <= camera.length
		
		n = camera[objID].Obj
		
		Camera[ObjId].Name$ = LAG_GetGadgetText(C_Gad_NameObj)
		
		Camera[ObjId].x = val(LAG_GetGadgetText(C_Gad_X))
		Camera[ObjId].Y = val(LAG_GetGadgetText(C_Gad_Y))
		Camera[ObjId].Z = val(LAG_GetGadgetText(C_Gad_Z))
		
		Camera[ObjId].Rx = val(LAG_GetGadgetText(C_Gad_rx))
		Camera[ObjId].Ry = val(LAG_GetGadgetText(C_Gad_Ry))
		Camera[ObjId].RZ = val(LAG_GetGadgetText(C_Gad_rZ))
		
		SetObjectPosition(n, Camera[ObjId].x, Camera[ObjId].y, Camera[ObjId].z)
		SetObjectRotation(n, Camera[ObjId].rx, Camera[ObjId].ry, Camera[ObjId].rz)
				
		
		Camera[ObjId].Lock.Pos.x = LAG_GetGadgetState(C_Gad_lock_X)
		Camera[ObjId].Lock.Pos.y = LAG_GetGadgetState(C_Gad_lock_y)
		Camera[ObjId].Lock.Pos.z = LAG_GetGadgetState(C_Gad_lock_z)
		
		Camera[ObjId].Lock.Rot.x = LAG_GetGadgetState(C_Gad_lock_RX)
		Camera[ObjId].Lock.Rot.y = LAG_GetGadgetState(C_Gad_lock_ry)
		Camera[ObjId].Lock.Rot.z = LAG_GetGadgetState(C_Gad_lock_rz)
		
		Camera[ObjId].fov = val(LAG_GetGadgetText(C_Gad_Size))
		Camera[ObjId].near = val(LAG_GetGadgetText(C_Gad_Sx))
		Camera[ObjId].far = val(LAG_GetGadgetText(C_Gad_Sy))
		Camera[ObjId].orthoW = val(LAG_GetGadgetText(C_Gad_Sz))
		
		
		/*
		LAG_SetGadgetState(C_Gad_R,Camera[ObjId].R)
		LAG_SetGadgetState(C_Gad_G,Camera[ObjId].G)
		LAG_SetGadgetState(C_Gad_B,Camera[ObjId].B)
		*/
		
		Camera[ObjId].Hide = LAG_GetGadgetState(C_Gad_Hide)
		Camera[ObjId].Locked = LAG_GetGadgetState(C_Gad_Lock)
		
		
	endif
endfunction



Function DeleteCamera(i)
	
	
	if i> -1 and i<=camera.length
		
		DeleteObject(camera[i].obj)
		camera.remove(i)
		
	endif
	
	
	
Endfunction



