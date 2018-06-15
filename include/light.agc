
// ************* ASSET LIGHT *********************//

// Sun, fog, skybox are in atmospheric.agc

Type tLightmap
	
	Width as integer // image size
	
	SoftShadoSample as integer
	Size as float
	SizeRange as float
	Height as float
	ShadoAlpha as integer
	ShadoR as integer
	ShadoG as integer
	ShadoB as integer
	
	Rx as integer
	Ry as integer
	Rz as integer
	
	UseLighting as integer
	
	ObjID as integer // the object which has the texture
	
endtype
	
Type tLight
	
	Obj as integer // the billboard for light
	Name$
	Id as integer // id of the light
	
	x as float
	y as float
	z as float	
	Radius as integer
	
	ParentId as integer
	Group as String[0]
	Layer as integer[0]

	
	
	R as integer
	G as integer
	B as integer
	Intensity as float
	
	// to move 
	StartX as float
	StartY as float
	StartZ as float
	
	Lock as tLock

	
	// Range as integer
	Shadow as integer
	Typ as integer
	Locked as integer
	Hide as integer
	Selected as integer
	
	
Endtype




// init, add
Function InitLight()
	
	Global dim Light[] as tLight
	GLobal dim TempLight[] as tLight
	Global LightId as integer
	Global Lightmap as tLightmap  	
	InitLigthMap()
	UpdateLightmapUi()
EndFunction

Function AddLight(x,y,z,radius,r,g,b,preset,mode)
	
	// To add a new Light on the level
	
	
	// first, deselect all
	SelectObject(1)
	
	
	//create the new lights
	i = light.length +1
	Global Dim Light[i] as tLight
	
	select preset 
		
		case 0 // white
			r = 255
			g = 255
			b = 255
		endcase
		case 1 // red
			r = 255			
		endcase
		case 2 // blue
			b = 255			
		endcase
		case 3 // green
			g = 255			
		endcase
		case 4 // yellow
			g = 255			
			r = 255			
		endcase
		case 5 // orange
			g = 255			
			r = 128			
		endcase
	
	endselect
	
	Light[i].Name$ = "Light"+str(i)
	
	Light[i].R = r
	Light[i].G = g
	Light[i].B = b
	
	Light[i].x = x
	Light[i].y = y
	Light[i].z = z
	
	Light[i].Id = 1+i	
	Light[i].radius = radius
	
	// create the objet for the light
	//n = CreateObjectSphere(30,2,2)
	n = CreateObjectPlane(30,30)
	Light[i].obj = n
	Light[i].Intensity = 1
	
	SetObjectPosition(n,x,y,z)	
	SetObjectImage(n,iLight,0)
	SetObjectRotation(n,90,0,0)
	SetObjectTransparency(n,1)
	SetObjectColorEmissive(n,r,g,b)
	
	SetObjectFogMode(n, 0)
	SetObjectLightMode(n, 1)
	// SetPointLightMode( 1, 1 )
	
	// Create the light
	CreatePointLight(i+1, x, y, z, radius,r,g,b)
	SetPointlightmode(i+1, 1)
	
	ObjId = i
	if assetTyp <> C_ASSETLIGHT
		Lag_FreeallGadgetItemByGadget(C_Gad_SelectList)
		Freeall = 1
	endif
	AssetTyp = C_ASSETLIGHT
	
	//update panel prop
	SelectObject(-1)
	
	// add light to panel select
	if Freeall = 0
		LAG_AddGadgetItem(C_Gad_SelectList, objId, Light[ObjId].name$, iLight)
		LAG_SetGadgetItemAttribute(C_Gad_SelectList, objId, C_ASSETLIGHT)
	else
		// recreate all gadgetitem for C_Gad_SelectList
		CreateAllGadgetItem()
	endif


Endfunction



// Light transformation
Function MoveLight(x,y,z)
	
	// to move a light + its plane3D
	if ObjId > -1 and ObjId <= Light.length
		
		i = ObjId
		
		SetPointLightPosition(i+1,x,y,z)
		n=Light[i].obj
		Light[i].x = x
		Light[i].y = y
		Light[i].z = z
		SetObjectPosition(n,x,y,z)
		
	endif
	
EndFunction

Function DeleteLight()
	
	// delete a unique light (not for multi selection)
	For i=0 to Light.length
		
		if i >=ObjId // and i < Light.length
			Light[i].Id = i+1
			u = Light[i].Intensity
			SetPointLightColor(i+1,light[i].r*u,light[i].g*u,light[i].b*u)
			SetPointLightRadius(i+1,light[i].Radius)
		endif
	
	next
	
	
EndFunction

Function EventLight()
	
	For i=0 to light.length		
		SetObjectLookAt(Light[i].obj,getcameraX(1),getcameraY(1),getcameraZ(1),0)
	next
	
EndFunction





// Properties
Function GetLightProp()
	// to set the prop of the selected light on the gadgets
	
	if ObjId >-1 and ObjId <= Light.length
		
		LAG_SetGadgetName(C_Gad_Tra,"Int")
		
		LAG_SetGadgetText(C_Gad_NameObj,Light[ObjId].Name$)
		
		LAG_SetGadgetText(C_Gad_X,str(Light[ObjId].x))
		LAG_SetGadgetText(C_Gad_Y,str(Light[ObjId].Y))
		LAG_SetGadgetText(C_Gad_Z,str(Light[ObjId].Z))
		
		LAG_SetGadgetState(C_Gad_lock_X,Light[ObjId].Lock.Pos.x)
		LAG_SetGadgetState(C_Gad_lock_y,Light[ObjId].Lock.Pos.y)
		LAG_SetGadgetState(C_Gad_lock_z,Light[ObjId].Lock.Pos.z)
		
		LAG_SetGadgetText(C_Gad_Size,str(Light[ObjId].Radius,2))
		LAG_SetGadgetText(C_Gad_Tra,str(Light[ObjId].Intensity,4))
		LAG_SetGadgetState(C_Gad_R,Light[ObjId].R)
		LAG_SetGadgetState(C_Gad_G,Light[ObjId].G)
		LAG_SetGadgetState(C_Gad_B,Light[ObjId].B)
		
		LAG_SetGadgetState(C_Gad_Hide,Light[ObjId].Hide)
		LAG_SetGadgetState(C_Gad_Lock,Light[ObjId].Locked)
		
		SetAssetGadget()
		
	endif
	
EndFunction

Function SetLightProp()
	
	// to change the parameters of a light
	if ObjId >-1 and ObjId <= Light.length
		
		Light[ObjId].name$ = LAG_GetGadgetText(C_Gad_NameObj)
		Light[ObjId].Radius = val(LAG_GetGadgetText(C_Gad_Size))
		Light[ObjId].Intensity = valFloat(LAG_GetGadgetText(C_Gad_Tra))
		Light[ObjId].R = LAG_GetGadgetState(C_Gad_R)
		Light[ObjId].G = LAG_GetGadgetState(C_Gad_G)
		Light[ObjId].B = LAG_GetGadgetState(C_Gad_B)
		
		Light[ObjId].X = ValFloat(LAG_GetGadgetText(C_Gad_X))
		Light[ObjId].Y = ValFloat(LAG_GetGadgetText(C_Gad_Y))
		Light[ObjId].Z = ValFloat(LAG_GetGadgetText(C_Gad_Z))
		
		Light[ObjId].Hide = LAG_GetGadgetState(C_Gad_Hide)
		Light[ObjId].Locked = LAG_GetGadgetState(C_Gad_Lock)
	
		SetPointLightColor(ObjId+1,Light[ObjId].R*Light[ObjId].Intensity,Light[ObjId].G*Light[ObjId].Intensity,Light[ObjId].B*Light[ObjId].Intensity)
		SetPointLightRadius(ObjId+1,Light[ObjId].Radius)
		SetObjectColorEmissive(Light[ObjId].Obj,Light[ObjId].r*Light[ObjId].Intensity,Light[ObjId].g*Light[ObjId].Intensity,Light[ObjId].b*Light[ObjId].Intensity)
		MoveLight(Light[ObjId].x,Light[ObjId].y,Light[ObjId].z)
				
	endif
	
	
EndFunction




FoldStart // lightmap


// Init 
Function InitLigthMap()
	
	if options.LightmapImageSize <= 0
		options.LightmapImageSize = 512
	endif
	Lightmap.width = options.LightmapImageSize // 1024
	Lightmap.ShadoAlpha = 200
	Lightmap.SoftShadoSample = 5
	Lightmap.Size = 1.2
	Lightmap.SizeRange = 0.05
	Lightmap.Height=1
		
	CreateRenderImage(iLightMap,Lightmap.width,Lightmap.Width,0,1)
	
	
	
EndFunction



Function SetCameraToLightMapView()

		if objId >-1 and objId<=object.length
			
			For i=0 to object.length
				n = object[i].Obj
				SetObjectScreenCulling(i,0)
			next
			

			SetAmbientColor(0,0,0)
			SetSunActive(0)
			SetFogMode(0)
			 
			// change camera 
			n = Object[ObjId].obj
			w1# = (GetObjectSizeMaxX(n)-GetObjectSizeMinX(n)) * Object[ObjId].sx
			message(str(w1#))
			w1# = 256
			SetCameraRotation(1,90,0,0)
			SetCAmeraPosition(1,0,256,0)	// hauteur pour voir tous les objets	
			SetCameraOrthoWidth(1,w1#/2)		
			SetCameraFov(1,0) 
			SetCameraAspect(1,1)
			  
			
			SetClearColor(255,255,255)       
			SetObjectVisible(n,0)
		
		endif
		
EndFunction




// OLd, ne plus utilisé normalement
Function CreateLightMap_Old()
	
	
	if ObjId >-1 and ObjId <= Object.length
		
		
		For i=0 to object.length
			n = object[i].Obj
			SetObjectScreenCulling(n,0)
		next
		
		
		oldx#=GetCameraX(1)
		oldy#=GetCameraY(1) 
		oldz#=GetCameraZ(1)
		 
		oldrx#=GetCameraAngleX(1)
		oldry#=GetCameraAngleY(1) 
		oldrz#=GetCameraAngleZ(1)
        
		// render to image, for shadow
		if GetImageExists(iLightMap)=0
			CreateRenderImage(iLightMap,512,512,0,1)			
		endif
	
        SetRenderToImage(iLightMap,-1)  
       
		// unactive the Atmopshere fx
       	SetAmbientColor(0,0,0)
		SetSkyBoxVisible(0)
		SetSunActive(0)
		SetFogMode(0)
		 
		// Object which recevie the lightmap
		Object[ObjId].LightMapID = 1
		//n = TheGourndZ // Object[ObjId].obj
		n = Object[ObjId].obj
		TheObjectLightMAp = ObjId
		TheGourndZ = Object[ObjId].obj
		wpl1# = (GetObjectSizeMaxX(n)-GetObjectSizeMinX(n)) // * Object[ObjId].sx
		
		// change camera 
		SetCameraRotation(1,90,0,0)
		SetCAmeraPosition(1,0,500,0)	// hauteur pour voir tous les objets	
		//message(str(wpl1#)+"/"+str(wpl1#*0.5))
		SetCameraOrthoWidth(1,wpl1#*0.5)		
		SetCameraFov(1,0) 
        SetCameraAspect(1,1)
        SetCameraRange(1,1,10000)
		
		
        SetClearColor(255,255,255)       
        SetObjectVisible(n,0)
        
        SetObjectVisible(grid,0)
        
        
        // the shadow color for object  
        //if softshadowSample < 1
		softshadowSample = 8
		//endif     
        alpha as float 
        alpha = 255
        alpha = alpha/softshadowSample
        if alpha <= 0
			alpha = 10
		endif
		sh = 20
		//Message(Str(Alpha)+"/"+str(softshadowSample))
       
        For j = 1 to softshadowSample
			// the shadow color for object = Shadow. Should be SHadowR, ShadowG, ShadowB for colored shadows
		   
			For i=0 to Object.length
				if i <> objId
					n = Object[i].obj
					SetObjectLightMode(n,0)
					//SetObjectColor(n,sh,sh,sh,alpha)
					SetObjectColor(n,0,0,0,255)
					SetObjectTransparency(n,0)
					/*
					SetObjectTransparency(n,1)
					
					h = GetObjectY(n)
					if h>=-25
						if h >=0
							s# = 1.2 - 0.05*j - h*0.001
						else
							s# = 1.2 - 0.05*j // + h*0.01
						endif
						SetObjectScale(n,s#,s#,s#)
					else
						SetObjectScale(n,0,0,0)
					endif
					*/
				endif
				// SetObjectImage(i,0,1)
			next
						 
			Render3D()
        NExt


		// Render shadow finished
		n = TheGourndZ // Object[ObjId].obj
        SetObjectVisible(n,1)
        SetObjectImage(n,iLightMap,0)
		//SetObjectVisible(grid,Options.ShowGrid)
  
		For i=0 to Object.length
			if i <> objID
				n = Object[i].obj
				SetObjectLightMode(n,1)
				SetObjectColor(n,255,255,255,Object[i].alpha)
				s# = object[i].Size
				SetObjectScale(n,object[i].sx*s#,object[i].sy*s#,object[i].sz*s#)
				if Object[i].alpha<255
					SetObjectTransparency(n,1)
				else
					SetObjectTransparency(n,0)
				endif
			endif
		next
  
        SetRenderToScreen()
        
        SetCameraFov(1,70)  
        SetCameraPosition(1,oldx#,oldy#,oldz#)
        SetCameraRotation(1,oldrx#,oldry#,oldrz#)
		aa# = GetDeviceWidth()
        aa# = aa# / GetDeviceHeight()
        SetCameraAspect(1,aa#)
		
		// set the atmosphere
		//UpdateAtmosphere()
		
		SetAmbientColor(150,150,150)
		SetSunActive(1)
		SetClearColor(50,50,50)
		
		ClearScreen()
		Sync()
		/*
		if GetImageExists(iLightMap) = 0
			message("erreur image lightmap")
		else
			//File_$ = "lightmap1.jpg"
			//SaveImage(iLightMap,File_$)
			//AddTextureToBank(file_$,1,0)
		endif
		*/
	
	else
		
		message("Select the ground before create the lightmap")
		
	Endif	
	
EndFunction




// OK lightmap realtime
Function SyncShadow()
	
	
	if TheObjectLightMAp > -1 // or (ObjId >- 1 and ObjId <= Object.length)
	
		oldx# = GetCameraX(1)
		oldy# = GetCameraY(1)
		oldz# = GetCameraZ(1)
		 
		oldrx# = GetCameraAngleX(1)
		oldry# = GetCameraAngleY(1) 
		oldrz# = GetCameraAngleZ(1)
	 
		uuu = TheObjectLightMap
		
		if uuu >-1 and uuu <= object.length
			
			FoldStart //render the image for lightmap
		
			TheGourndZ = Object[uuu].Obj 

		
			// render to image, for shadow
			if GetImageExists(iLightMap)=0
				CreateRenderImage(iLightMap,512,512,0,1)
				SetImageWrapU(iLightMap,1)			
				SetImageWrapV(iLightMap,1)			
			endif
			
			// render to the lightmap
			SetRenderToImage(iLightmap,-1)  
			
			
			
			// prepare the bg and scene for shadow
			if Lightmap.UseLighting = 0
				SetAmbientColor(0,0,0)
				SetSunActive(0)
				SetSunColor(0,0,0)
			endif
			
			print(str(Lightmap.UseLighting))
			
			SetFogMode(0)
			SetSkyBoxVisible(0)
			SetObjectVisible(grid,0)
			
			
			
			
			w1# = (GetObjectSizeMaxX(TheGourndZ)-GetObjectSizeMinX(TheGourndZ)) * Object[uuu].sx * Object[uuu].Size
			xa = getobjectX(TheGourndZ)
			za = getobjectZ(TheGourndZ)
			
			//SetCameraRotation(1, 90+LightMap.rx, lightMap.ry, lightmap.rz)
			
			SetCameraRotation(1,90,0,0)
			
			// print(str(LightMap.rx,0)+"/"+str(LightMap.ry)+"/"+str(LightMap.rz))
			//SetCAmeraPosition(1,xa+cos(LightMap.rx),w1#,za-sin(LightMap.rz))
			SetCameraPosition(1,xa, w1#, za)
			
			SetCameraOrthoWidth(1, w1#/2)		
			SetCameraFov(1,0) 
			SetCameraAspect(1,1)
		   
		   
			// on place le cache pour l'alpha des ombres : plus les ombres sont présentes (noires), moins ce cache blanc est visible
			SetObjectPosition(oWhite,xa,w1#*0.5,za)
			SetObjectColor(oWhite,255,255,255,255-Lightmap.ShadoAlpha)
			SetObjectScale(oWhite,w1#*0.02,w1#*0.02,w1#*0.02)
			SetObjectVisible(oWhite,1)
			
			// clear the screen
			SetClearColor(255,255,255)			
			 
			ClearScreen()
			
			// SetObjectVisible(TheGourndZ,0)
			SetObjectColorEmissive(TheGourndZ,0,0,0)
			
			SoftShadowSample = Lightmap.SoftShadoSample
			local alpha as float 
			alpha = 255 // Lightmap.ShadoAlpha
			alpha = alpha / SoftShadowSample
		   
			For j = 1 to softshadowSample
				// the shadow color for object = Shadow. Should be SHadowR, ShadowG, ShadowB for colored shadows
			   
				For k=0 to object.length
					
					//if uuu <> k 
						
						i = object[k].obj
						// SetObjectCullMode(i, 0)
						
						if Object[k].Shadow=1 and uuu <> k
							
							SetObjectLightMode(i,1)						
							SetObjectColor(i,LightMap.ShadoR, LightMap.shadoG, LightMap.shadoB,255)
							SetObjectColorEmissive(i,LightMap.ShadoR, LightMap.shadoG, LightMap.shadoB)
							SetObjectTransparency(i,1)
							h = GetObjectY(i)
							if h>=-25000
								if h >=0
									s# = LightMap.Size - LightMap.SizeRange*j - h*0.001*lightmap.Height // s# =  - *j - h= lightmap.Height*0.001
								else
									s# = LightMap.Size - LightMap.SizeRange*j // + h*0.01
								endif
								s1# = object[k].Size * s#
								SetObjectScale(i,object[k].sx*s1#,object[k].sy*s1#,object[k].sz*s1#)
								//
								//SetObjectScale(i,s#,s#,s#)
							else
								SetObjectScale(i,0,0,0)
							endif
							if GetObjectAngleX(i)>180
								dir = -1
							else
								dir = 1
							endif 
							SetObjectRotation(i,object[k].rx+ LightMap.rx, object[k].ry+LightMap.ry, object[k].rz+LightMap.rz)
							
							//RotateObjectLocalX(i, LightMap.rx*dir)
						else
							SetObjectVisible(i, 0)
							SetObjectColor(i,255,255,255,0)
							SetObjectColorEmissive(i,0,0,0)
							SetObjectTransparency(i,1)
							SetObjectRotation(i,object[k].rx, object[k].ry, object[k].rz)
						endif
						
					//endif
					
				next
							
				Render3D()
			NExt
			
			
			
			
			
			
			FoldStart // Render is finished, 
			SetObjectVisible(oWhite,0)        
			SetObjectVisible(TheGourndZ,1)        
			SetObjectImage(TheGourndZ, iLightmap, 1)
			
			// SetObjectLightMap(TheGourndZ, iLightmap)
			Object[uuu].stage[1].ImageId = iLightmap
	 
			For j=0 to object.length
				
				i  = object[j].obj
				SetObjectCullMode(i, 1)
				SetObjectLightMode(i,1)
				SetObjectColor(i,255,255,255,Object[j].alpha)
				SetObjectColorEmissive(i,object[j].R,object[j].G,object[j].B)
				s# = object[j].Size
				SetObjectScale(i,object[j].sx*s#,object[j].sy*s#,object[j].sz*s#)
				if Object[j].alpha<255
					SetObjectTransparency(i,1)
				else
					SetObjectTransparency(i,0)
				endif
				RotateObjectLocalX(i, 0)
				SetObjectRotation(i, object[j].rx,object[j].ry,object[j].rz)
				SetObjectVisible(i, 1 - object[j].hide)
				
			next
			
			SetObjectColorEmissive(TheGourndZ,255,0,0)
			
			// then on remet tout comme il faut
			SetRenderToScreen()
			
			// the grid
			SetObjectVisible(grid,options.ShowGrid)
			
			
			
			// reset camera
			
			SetCameraFov(1,70)  
			SetCameraPosition(1,oldx#,oldy#,oldz#)
			SetCameraRotation(1,oldrx#,oldry#,oldrz#)
			aa# = GetDeviceWidth()
			aa# = aa# / GetDeviceHeight()
			
			SetCameraAspect(1,aa#)
			
			
			UpdateAtmosphere()			
			SetClearColor(LAG_ClearColor,LAG_ClearColor,LAG_ClearColor)
			ClearScreen()
		
			Foldend
			
			
			
			
		Foldend
		
		else
			
			// message("no object for lightmap")
			// I need to update the object ID wich receive the lightmap
			For i=0 to Object.Length
				IF Object[i].LightMapID = 1
					TheObjectLightMAp = i
					exit
				endif
			Next
		
		Endif
	else
			
	Endif	
	
	
		
EndFunction






// UI & set lightmap
Function SetLightMapProp()
	
	Lightmap.SoftShadoSample = Lag_GetgadgetState(C_Gad_LM_SoftShSample)
	Lightmap.ShadoAlpha = Lag_GetgadgetState(C_Gad_LM_ShadoAlpha)
	
	Lightmap.Height = valfloat(Lag_GetgadgetText(C_Gad_LM_Height))
	Lightmap.Size = valfloat(Lag_GetgadgetText(C_Gad_LM_SoftShSize))
	Lightmap.SizeRange = valfloat(Lag_GetgadgetText(C_Gad_LM_SizeRange))
	
	Lightmap.ShadoR = Lag_GetgadgetState(C_Gad_LM_ShadoR)
	Lightmap.ShadoG = Lag_GetgadgetState(C_Gad_LM_ShadoG)
	Lightmap.ShadoB = Lag_GetgadgetState(C_Gad_LM_ShadoB)
	
	Lightmap.Rx = val(Lag_GetgadgetText(C_Gad_LM_Rx))
	Lightmap.Ry = val(Lag_GetgadgetText(C_Gad_LM_Ry))
	Lightmap.Rz = val(Lag_GetgadgetText(C_Gad_LM_Rz))
	
	Lightmap.UseLighting = Lag_GetgadgetState(C_Gad_LM_UseLight)
	

EndFunction

Function UpdateLightmapUi()

	Lag_setgadgetState(C_Gad_LM_SoftShSample,Lightmap.SoftShadoSAmple)
	Lag_setgadgetState(C_Gad_LM_ShadoAlpha,Lightmap.ShadoAlpha)
	
	Lag_setgadgetText(C_Gad_LM_SizeRange,str(Lightmap.SizeRange))
	Lag_setgadgetText(C_Gad_LM_SoftShSize,str(Lightmap.Size))
	Lag_setgadgetText(C_Gad_LM_Height,str(Lightmap.height))

EndFunction




Foldend




