
// ************************ EDITOR ****************************//




//*****  Editor
Function InitEditor()
	
	// To init the Editor
	
	Foldstart // intro
	
	SetAntialiasMode(Options.AntiAlias)
	SetGenerateMipmaps(1)
	
	Create3DPhysicsWorld(40)
	Set3DPhysicsGravity(0,-10,0)

	foldend


	//nb_i=Loading(nb_i)
	
	
	
	// init the elements
	InitImage()
	InitWater()
	InitTerrain()
	InitBehavior()
	InitPartSystem()
	 
	Foldstart // ------ GRID
	
	u = 1000
	setimagewrapU(iGrid,1)
	setimagewrapV(iGrid,1)
	// setimagewrapU(iGridx,1)
	// setimagewrapV(iGridx,1)
	// setimagewrapU(iGridy,1)
	// setimagewrapV(iGridy,1)
	
	Global Grid as integer
	Grid = CreateObjectBox(u,1,u)
	
	SetObjectImage(Grid,iGrid,0)
	//SetObjectImage(Grid,iGridx,1)
	//SetObjectImage(Grid,iGridy,2)
	
	SetObjectTransparency(Grid,1)
	// SetObjectShader(Grid,GridShader)
	SetObjectPosition(Grid,0,0,0)
	// SetObjectcolor(grid, 255,255,255,255)
	// SetObjectColorEmissive(grid, 255,255,255)
	a= u*0.1 // *0.00625 //*0.004
	
	// message(str(a))
	
	SetObjectUVScale(Grid,0, a, a)
	//SetObjectUVScale(Grid,1, a, a)
	// SetObjectUVScale(Grid,2, a, 1)
	
	
	SetObjectCollisionMode(Grid,0)
	SetObjectLightMode(Grid,0)	
	SetObjectFogMode(Grid,0)
	
	// nb_i = Loading(nb_i)
	
		
	
	foldend
	
	
	FoldStart // ------ Arrow, white (for lightmap), Cube (selection)/cubeview, cible, 
	
	// 3D arrows
	Global ArrowX, ArrowY, ArroZ as integer
	/*
	n = LoadObject("ui/arrow.x")
	ArrowX = n
	SetObjectColor(n,0,200,0,255)
	SetObjectFogMode(n,0)
	SetObjectScale(n,5,5,5)
	SetObjectVisible(n,1)
	// SetObjectDepthRange(ArrowX,0,0)
	// SetObjectCullMode(ArrowX,0)
	

	n = CloneObject(ArrowX)
	ArrowY = n
	SetObjectColor(n,200,0,0,255)
	SetObjectFogMode(n,0)
	SetObjectScale(n,5,5,5)
	SetObjectRotation(n, -90,0,0)
	
	n = CloneObject(ArrowX)
	ArrowZ = n
	SetObjectColor(n,0,0,200,255)
	SetObjectFogMode(n,0)
	SetObjectScale(n,5,5,5)
	SetObjectRotation(n, -90, -90, 0)
	*/
	
	
	Global oWhite as integer // un objet tout blanc pour créer l'alpha des ombres dynamic :)
	oWhite = CreateObjectPlane(50,50)
	SetObjectRotation(oWhite,90,0,0)
	SetObjectCollisionMode(oWhite,0)
	SetObjectVisible(oWhite,0)     
	SetObjectColorEmissive(oWhite,255,255,255)
    SetObjectTransparency(oWhite,1)


	//selection (temporary, I wait the drawline/drawcube utilities in 3D with AGK :)
	Global SelCube,iCube as integer
	
		iCube = LoadImage("ui/cube.png")	
		n= CreateObjectBox(2,2,2)
		SelCube = n
		SetObjectColorEmissive(n,255,0,0)
		SetObjectVisible(n,0)
		SetObjectColor(n,255,0,0,255)
		SetObjectCollisionMode(n,0)
		SetObjectImage(n,iCube,0)
		SetObjectLightMode(n,0)
		SetObjectTransparency(n,1)
		SetObjectDepthRange(n,0,0)
			
		UpdateCubeSelection(0,0,0,0,0,0)
	
	
	// Cubeview is used for the pan of the view (cameralookat this cube)
	Global CubeView 
	n= CreateObjectBox(5,5,5)
	CubeView = n
	SetObjectColor(n,0,0,255,255)
	SetObjectVisible(n,0)
	SetObjectCollisionMode(n,0)
	SetObjectLightMode(n,0)
	//SetObjectDepthRange(n,100000,100000)
	SetObjectTransparency(n,1)



	// not used for the moment
	Global CibleEd
	CreateSprite(2,2)
	SetSpritePosition(2,-5000,0)
	CibleEd = CreateObjectPlane(1,1)
	SetObjectImage(CibleEd,2,0)
	SetObjectTransparency(CibleEd,1)
	SetObjectscale(CibleEd,20,20,20)
	SetObjectVisible(CibleEd,0)
	
	
	Foldend
		
		
	foldstart // ------ object 3D necessary	
	Global oCamera
	
	n =LoadObject("ui/camera.obj")
	oCamera = n
	SetObjectVisible(n, 0)
	SetObjectScale(n, 10, 10, 10)
	SetObjectposition(n, -1000000, -1000000, -1000000)
	//SetObjectLightMode(n, 0)
	SetObjectColor(n, 50, 50, 50, 255)
	// SetObjectColorEmissive(n, 50, 50, 50, 255)
	
	
	
	Global oSun
	
	n = LoadObject("ui/sun.obj")
	oSun = n
	SetObjectVisible(n, 1)
	u = 30
	SetObjectScale(n, u, u, u)
	SetObjectposition(n, 0, 150, 0)
	//SetObjectLightMode(n, 0)
	SetObjectColor(n, 150, 250, 50, 255)
	SetObjectColorEmissive(n, 150, 250, 50)
	// SetObjectRotation(n, sun.x, sun.y, sun.z)
	SetObjectVisible(n, 0)
	
	
	
	foldend
	
		
	Foldstart // ------ set some properties


	Action$ ="Play"
	Global a1$ = "" // "Play,create,select,move,scale,rotate,clone,delete"

	Global NewX,NewZ as float
	Global StartX#, StartY#, StartZ#, EndX#, EndY#, EndZ#, WorldX#, WorldY#, WorldZ#
	Global move,rotate,scale,rx,ry,rz,sx,sy,sz,px,py,pz
	Global Shift,Ctrl,Alt
	
	
	
Foldend
	
	
	// Init the Object
	InitObject()
	InitLight()
	InitCamera()
	InitPlayer()
	
	
	Foldstart // help
	Global Help$
	
	Help$ = "Use the toolbar to change Action (Create object, select, move...)"+chr(10)
	Help$ = Help$ + "Left mouse to select the object / Right Mouse to move the view"+ chr(10)
	Help$ = Help$ + "Arrows to navigate in the 3D view / Wheel to zoom the view"+ chr(10)
	Help$ = Help$ + "A to add an object(or action 'create' + clic on the grid)"+ chr(10)
	Help$ = Help$ + "L to add a light(or action 'create' + clic on the grid)"+ chr(10)
	// Help$ = Help$ + "H : hide selected objects / Ctrl+H : unhide all"+ chr(10)
	Help$ = Help$ + "G to Grab/move an object"+ chr(10)
	Help$ = Help$ + "R to Rotate an object"+ chr(10)
	Help$ = Help$ + "S to Scale an object"+ chr(10)
	Help$ = Help$ + "Shift + G, R or S to Reset the transformation (Grab,rotate,scale)"+ chr(10)
	Help$ = Help$ + "7 : view3D Top, 1 : view3D Front, 3 : View3D right"+ chr(10)
	
	foldend
	
	


	//nb_i=Loading(nb_i)

	
	// ------ camera
	global camX, camY, camZ, cameraZoom#, CameraView
	global objX, objY, objZ, MeshId, ActionView
	camx = 0
	camy = 0
	camz = 0

	
	
EndFunction



//***** keyboard action
Function CheckKeyboard(ObjTyp$)
	
	// Obj$ ="Box,Sphere,Capsule,Cone,Cylinder,Plane,Object3D"
	/*
	if GetRawKeyPressed(KEY_T)       
		inc ObjTyp
		if ObjTyp > C_OBJLAST
			ObjTyp = 0
		endif
		ObjTyp$ = GetStringToken(Obj$,",",ObjTyp+1)
	endif
	*/
	/*
	if GetRawKeyPressed(KEY_I)       
		inc TextureID
		if TextureID > texture.length
			TextureID = 0
		endif				
	endif
	*/
				
	if GetRawKeyPressed(KEY_A) // Create an object asset
		ActionView = 0
		CreateNewObject(0)
		
		GetObjProp()
	Endif
	
	if GetRawKeyPressed(KEY_C)
		ActionView = 0
		get_mouse_coords(0)
		x = round(Mouse_X)
		z = round(Mouse_Z)
			
		AddCamera(x,0,z,0,0,0,1,5000,70)
		// AddCamera()
	Endif
	
	if GetRawKeyPressed(KEY_L)
		ActionView = 0
		get_mouse_coords(0)
		x = round(Mouse_X)
		z = round(Mouse_Z)
		AddLight(X,10,Z,50,255,255,255,0,1)
	endif

EndFunction ObjTyp$




FoldStart //********* UI 

//***** actions & toolbar, panel....
Function SetTool(Event_Gadget)

	For i= C_GAD_TBNEW to C_Gad_TBDEL
		LAG_SetGadgetState(i,0)
	next
		
	if Event_Gadget = C_GAD_TBNEW
		NewDoc(0)
	elseif Event_Gadget = C_GAD_TBOpen
		OpenDoc(0)
	elseif Event_Gadget = C_GAD_TBSave
		SaveDoc(0)
	else
		if Event_Gadget >= C_Gad_TBOBJ and Event_Gadget <= C_Gad_TBFX
			
			AssetTyp = Event_Gadget - C_Gad_TBOBJ
			ObjTyp = C_OBJBOX
			TextureID = 0
			
			LAG_SetGadgetState(C_Gad_BankImg,GetCurrentTexture(0))	
					
			if AssetTyp = C_ASSETFX
				ObjTyp = C_OBJPARTSYS				
				LAG_SetGadgetState(C_Gad_BankImg,Particle[0].img)				
			endif
			
			SetPanel("Images",0)
			SetPanel("Properties",0)
			
		elseif Event_Gadget >= C_Gad_TBPLAY and Event_Gadget<= C_Gad_TBDEL
			
			Action = Event_Gadget - C_Gad_TBPLAY
			
		endif
	endif
	
	LAG_SetGadgetState(Action+C_Gad_TBPLAY,1)
	LAG_SetGadgetState(AssetTyp+C_Gad_TBOBJ,1)
	
	action$ = SetAction()
	
EndFunction action$

Function SetAction()

	// to set the action in the editor : move,scale,rot...
	
	a1$ = "Play,create,select,move,scale,rotate,clone,delete"

	Action$ = GetStringToken(a1$,",",action+1)
	move = 0
	rotate = 0
	scale = 0
	SetObjectVisible(Grid,Options.ShowGrid)
	//SetObjectVisible(CibleEd,1)
	select action
		case C_ACTIONPLAY
			SetObjectVisible(Grid,0)
			//SetObjectVisible(CibleEd,0)
		endcase				
		case C_ACTIONMOVE
			move = 1
			LAG_SetGadgetState(C_Gad_LockX,options.LockX)
			LAG_SetGadgetState(C_Gad_LockY,options.Locky)
			LAG_SetGadgetState(C_Gad_LockZ,options.Lockz)			
		endcase
		case C_ACTIONROTATE
			rotate = 1
			LAG_SetGadgetState(C_Gad_LockX,options.LockRX)
			LAG_SetGadgetState(C_Gad_LockY,options.LockRy)
			LAG_SetGadgetState(C_Gad_LockZ,options.LockRz)
		endcase
		case C_ACTIONSCALE
			scale = 1
			LAG_SetGadgetState(C_Gad_LockX,options.LockSX)
			LAG_SetGadgetState(C_Gad_LockY,options.LockSy)
			LAG_SetGadgetState(C_Gad_LockZ,options.LockSz)
		endcase
	endselect
	
EndFunction Action$

Function SetToolContainer(EventGad)
		
	// first, change the buttons	
	For i = C_Gad_Tool1 to C_Gad_Tool4
		LAG_SetGadgetState(i,0)
	next
	
	LAG_SetGadgetState(EventGad,1)
	
	//then, set the panel container far from view :)	
	LAG_SetGadgetVisible(C_Gad_ContLightMap,0)
	LAG_SetGadgetVisible(C_Gad_ContLvl,0)
	
	// Change the panel item by the tool selected (lightmap, level prop...) : test !!
	Select EventGad
		
		case C_Gad_Tool1			
			LAG_SetGadgetVisible(C_Gad_ContLightMap,1)
		endcase	
		
		case C_Gad_Tool2			
			LAG_SetGadgetVisible(C_Gad_ContLvl,1)
		endcase
	
	endselect
	
	
EndFunction

Function SetPropContainer(EventGad)
		
	// first, change the buttons	
/*
	For i = C_Gad_Tool1 to C_Gad_Tool4
		LAG_SetGadgetState(i,0)
	next
	
	LAG_SetGadgetState(EventGad,1)
	
	//then, set the panel container far from view :)	
	LAG_SetGadgetVisible(C_Gad_ContLightMap,0)
	LAG_SetGadgetVisible(C_Gad_ContLvl,0)
	
	// Change the panel item by the tool selected (lightmap, level prop...) : test !!
	Select EventGad
		case C_Gad_Tool1			
			LAG_SetGadgetVisible(C_Gad_ContLightMap,1)
		endcase	
		case C_Gad_Tool2			
			LAG_SetGadgetVisible(C_Gad_ContLvl,1)
		endcase
	endselect
	*/
	
EndFunction

Function SetPanel(Panel$,id)
	
	// voir init.agc pour les noms des panels
	// pour changer certains noms de gadget en fonction de l'objet sélectionné
	pn$ ="Objects,Images,Properties,"
	panel$ = GetStringToken(pn$, ",", id+1)
	
	select panel$
	
		case "Objects"
			PanelL_Id = 0
			SetObjectPanel()
			
		endcase 
		
		case "Images"
			PanelL_Id = 1
			if ObjTyp = C_OBJPARTSYS
				LAG_SetGadgetName(C_Gad_SetShader,"Blend ")
			else
				LAG_SetGadgetName(C_Gad_SetShader,"Shader ")
			endif
				
		endcase
		
		case "Properties"
		
			PanelL_Id  = 2
			
			if ObjTyp = C_OBJPARTSYS
				//LAG_SetGadgetName(C_Gad_SetShader,"Blend ")
			else
				//LAG_SetGadgetName(C_Gad_SetShader,"Shader ")
			endif
			
			SetAssetGadget()	
			GetObjProp()
			
		endcase
		
	endselect
		
	
	
Endfunction

Function SetObjectPanel()
	
	// to change the name of the gadget for asset creation
	
	LAG_SetGadgetVisible(C_Gad_AssetL, 1) 

	Select ObjTyp
		
		case C_OBJBOX, C_OBJBANK 
			
			LAG_SetGadgetName(C_Gad_AssetW,"W ") 
			LAg_SetGadgetTooltip(C_Gad_AssetW,"Width.")  
			LAG_SetGadgetName(C_Gad_AssetH,"H ")
			LAg_SetGadgetTooltip(C_Gad_AssetH,"Height.")  
			LAG_SetGadgetName(C_Gad_AssetL,"L ") 
			LAg_SetGadgetTooltip(C_Gad_AssetL,"Length.")  
		
		endcase
		
		case C_OBJCONE, C_OBJCYLINDER
				
			LAG_SetGadgetName(C_Gad_AssetW,"H ") 
			LAg_SetGadgetTooltip(C_Gad_AssetW,"Height.")  
			LAG_SetGadgetName(C_Gad_AssetH,"D ")
			LAg_SetGadgetTooltip(C_Gad_AssetH,"Diameter.")  
			LAG_SetGadgetName(C_Gad_AssetL,"S ") 
			LAg_SetGadgetTooltip(C_Gad_AssetL,"Segments.")  
		
		endcase
		
		case C_OBJCAPSULE
				
			LAG_SetGadgetName(C_Gad_AssetW,"D ") 
			LAg_SetGadgetTooltip(C_Gad_AssetW,"Diameter.")  
			LAG_SetGadgetName(C_Gad_AssetH,"H ")
			LAg_SetGadgetTooltip(C_Gad_AssetH,"Height.")  
			LAG_SetGadgetName(C_Gad_AssetL,"A ") 
			LAg_SetGadgetTooltip(C_Gad_AssetL,"Axis.")  
		
		endcase
		
		case C_OBJPLANE
			
			LAG_SetGadgetName(C_Gad_AssetW,"D ") 
			LAg_SetGadgetTooltip(C_Gad_AssetW,"Diameter.")  
			LAG_SetGadgetName(C_Gad_AssetH,"H ")
			LAg_SetGadgetTooltip(C_Gad_AssetH,"Height.")  
			LAG_SetGadgetVisible(C_Gad_AssetL,0) 
		
		endcase
		
		case C_OBJSPHERE
			
			LAG_SetGadgetName(C_Gad_AssetW,"D ") 
			LAg_SetGadgetTooltip(C_Gad_AssetW,"Diameter.")  
			LAG_SetGadgetName(C_Gad_AssetH,"R ")
			LAg_SetGadgetTooltip(C_Gad_AssetH,"Rows.")  
			LAG_SetGadgetName(C_Gad_AssetL,"C ") 
			LAg_SetGadgetTooltip(C_Gad_AssetL,"Columns.")  
		
		endcase
		
	endselect
	
Endfunction





//***** Cube for "selection"
Function UpdateSelection()
	
	//*
	Options.MinX = 100000
	Options.MinY = 100000
	Options.MinZ = 100000
	Options.MaxX = -10000
	Options.MaxY = -10000
	Options.MaxZ = -10000
	
	For i= 0 to object.length
	
		if object[i].selected
		
			s#=Object[i].Size
			n = object[i].obj
			w = GetObjectSizeMaxX(n) - GetObjectSizeMinX(n)
			h = GetObjectSizeMaxY(n) - GetObjectSizeMinY(n)
			l = GetObjectSizeMaxZ(n) - GetObjectSizeMinZ(n)
			
			a# = 1
			
			xm1 = (GetObjectSizeMinX(n)*s#*Object[i].sx + getobjectX(n) - w*0.5) * a#
			xm2 = (GetObjectSizeMaxX(n)*s#*Object[i].sx + getobjectX(n) + w*0.5) * a#
			ym1 = (GetObjectSizeMinY(n)*s#*Object[i].sy + getobjectY(n) - h*0.5) * a#
			ym2 = (GetObjectSizeMaxY(n)*s#*Object[i].sy + getobjectY(n) + h*0.5) * a#
			zm1 = (GetObjectSizeMinZ(n)*s#*Object[i].sz + getobjectZ(n) - l*0.5) * a#
			zm2 = (GetObjectSizeMaxZ(n)*s#*Object[i].sz + getobjectZ(n) + l*0.5) * a#
			if Options.MinX>xm1
				Options.MinX = xm1
			endif
			if Options.MaxX<xm2
				Options.MaxX = xm2
			endif
			if Options.MinY>ym1
				Options.MinY = ym1
			endif
			if Options.MaxY< ym2
				Options.MaxY = ym2
			endif
			if Options.MinZ>zm1
				Options.MinZ= zm1
			endif
			if Options.MaxZ<zm2
				Options.MaxZ =zm2
			endif
			
		endif
		
	next
	
	UpdateCubeSelection(Options.minx,Options.miny,Options.minz,Options.maxX-Options.minX,Options.maxY-Options.minY,Options.maxZ-Options.minZ)
	//*/
	
	
EndFunction

Function UpdateCubeSelection(x,y,z,w,h,l)
	
	
	
	// to update the size and position of the cube selection
	n = SelCube
	SetObjectPosition(n,x+w*0.5,y+h*0.5,z+l*0.5)
	// size * 0.5 because initial size = 2
	SetObjectScale(n,w*0.5,h*0.5,l*0.5)

Endfunction


//***** panel select
Function CreateAllGadgetItem()
	
	// to create all the gadgetitem for panel select
	name1$ ="Object,Light,Camera,FX,Mesh"
	
	Select AssetTyp
		
		case C_ASSETOBJ
			
			For i = 0 to object.length
				LAG_AddGadgetItem(C_Gad_SelectList, i, object[i].name$, object[i].icon)
				LAG_SetGadgetItemAttribute(C_Gad_SelectList, i, C_ASSETOBJ)
			next
		
		endcase
		
		case C_ASSETLIGHT
			For i = 0 to light.length
				LAG_AddGadgetItem(C_Gad_SelectList, i, light[i].name$, iLight)
				LAG_SetGadgetItemAttribute(C_Gad_SelectList, i, C_ASSETLIGHT)
			next
		endcase
		
		case C_ASSETCAMERA
			For i = 0 to Camera.length
				LAG_AddGadgetItem(C_Gad_SelectList, i, camera[i].name$, iCamera)
				LAG_SetGadgetItemAttribute(C_Gad_SelectList, i, C_ASSETCAMERA)
			next
		endcase
		
		case C_ASSETMESH
			Lag_FreeallGadgetItemByGadget(C_Gad_SelectList)
			if objid > -1 and objid <= object.length
				nbmesh = GetObjectNumMeshes(object[ObjId].Obj)
				for i=0 to nbmesh-1
					n$ = GetObjectMeshName(object[ObjId].Obj,i+1)
					if n$ = ""
						n$ ="Mesh_"
					endif
					name$ = n$+str(i+1)
					LAG_AddGadgetItem(C_Gad_SelectList, i, name$, object[ObjId].icon)
					LAG_SetGadgetItemAttribute(C_Gad_SelectList, i, C_ASSETMESH)
				next
			endif
		endcase
		
	endselect
	
	Lag_SetGadgetText(C_Gad_BtnSelectTyp,GetStringToken(name1$,",",assettyp+1))

	
	
EndFunction



Foldend



//***** mouse 
Function SetUserProfilMouse()

	// set the profil for mouse 
	/*
	Blender/maya : 
	- rotation = middle
	- pan = shift + mouse
	- zoom : wheel	
	*/
	Select Options.Profil$
	
	
	
	
	EndSelect
	
	
EndFunction

// mouse 
function get_mouse_coords(y)
	
	// By Galelorn, thanks a lot
	cx# = GetCameraX(1)
	cy# = GetCameraY(1)
	cz# = GetCameraZ(1)
	
	pxRaw# = Get3DVectorXFromScreen(GetPointerX(),GetPointerY()) //- Start_oX#
	pyRaw# = Get3DVectorYFromScreen(GetPointerX(),GetPointerY()) // - Start_oY#
	pzRaw# = Get3DVectorZFromScreen(GetPointerX(),GetPointerY()) // - Start_oZ#
	
	if y = 0
		//// get pointer vector y added to camera's y position
		pyRelative# = pyRaw# + cy# 
	 
	 
		//// find distance between camera's y position and pyRelative#
		dist# = cy# - pyRelative# 
	 
		//// calculate scaling value by finding how many times dist# goes into the camera's y position
		s# = cy# / dist#
	 
		//// find the intersection point by multiplying pointer vector by s# and adding it to the camera position. 
		//// ignoring Y in this case since it should be 0 anyway.
		Mouse_X = cx# + pxRaw# * s#
		Mouse_Z = cz# + pzRaw# * s#
		
		
	else
		
		pzRelative# = pzRaw# + cz#
		dist# = cz# - pzRelative#
		s# = cz# / dist#
		
		Mouse_X = cx# + pxRaw# * s#
		Mouse_Z = cz# + pzRaw# * s#

	
	endif
		
	
	//xx = round(Mouse_X)
	//xz = round(Mouse_Z)

Endfunction




//***** 
Function ReloadAllShaders() 
	
	// set all shaders to 0 ? to not crash ? 
	For i= 0 to object.length
		SetObjectShader(Object[i].Obj, 0)
	next 
	
	// reset the shaders
	ResetShaderBank()
	
	message ("ok")
	
	// then reassign the shadoer to object
	For i= 0 to object.length
		
		if Object[i].Shader <=-1
			SetObjectShader(Object[i].Obj, 0)
		elseif Object[i].Shader <= ShaderBank.length
			SetObjectShader(Object[i].Obj, ShaderBank[Object[i].Shader].Shader)
		endif
		
	next
	 
	// SetObjectProp(C_SETOBJPROP_STAGEImg)
	
	message ("ok2")
	
endFunction

Function ReloadImage()
	
	// to reload an image, if we have make change on it
	
	j = textureId
	
	if textureID > -1 
		
		if options.listImageTyp = 0
		
		else
			
			if Texture[j].Filename$ <> ""
				
				if GetImageExists(texture[j].img)
					
					// on enlève la texture
					For i=0 to object.length					
						For k = 0 to 7
							if object[i].Stage[k].ImageId = texture[j].img
								SetObjectImage(object[i].Obj, 0, k)
							endif
						next
					next
					
					DeleteImage(texture[j].img)
					
					// reload the image
					LoadImage(Texture[j].img, Texture[j].Filename$)
					wrap = Texture[j].wrap
					SetImageWrapU(Texture[j].img,wrap)
					SetImageWrapV(Texture[j].img,wrap)

					LAG_SetGadgetState(C_Gad_BankImg,Texture[j].img)
				
				
					// on remet la texture
					For i=0 to object.length					
						For k = 0 to 7
							if object[i].Stage[k].ImageId = texture[j].img
								SetObjectImage(object[i].Obj, texture[j].img, k)
							endif
						next
					next
				
				
				endif
				
			endif
			
		endif
		
	endif
	
	// check all object, if they use this image to update it ?
	/*
	For i=0 to Object.length
		
		for k=0 to  Object[i].stage.length
			if Object[i].stage[k].ImgName$ = file$
				
			endif
		next 
		
	next 
	*/
	
endFunction






//***** RAycast, to know the object selected for example // raycast, pour connaître l'objet cliqué par exemple

Function CheckWorld_()
	
	// to move an object on the "grid" object
	
	u = 1 // 800
	worldX# = Get3DVectorXFromScreen( GetPointerX(), GetPointerY() ) 
	worldY# = Get3DVectorYFromScreen( GetPointerX(), GetPointerY() ) 
	worldZ# = Get3DVectorZFromScreen( GetPointerX(), GetPointerY() ) 	 
	StartX# = worldX# * u + GetCameraX(1)
	StartY# = worldY# * u + GetCameraY(1)
	StartZ# = worldZ# * u + GetCameraZ(1)

	u = 30000 
	EndX# = WorldX# * u + GetCameraX(1)
	EndY# = WorldY# * u + GetCameraY(1)
	EndZ# = WorldZ# * u + GetCameraZ(1)
	obj = ObjectRayCast(0, Startx#, Starty#, Startz#, EndX#, EndY#, EndZ#)	
	
EndFunction obj

function PickObject(start)
	
	
	//if ( GetPointerPressed() )
		
		SetObjectPosition(Grid,-1000000,-1000000,-100000000)
		
		local distance as float
		local directionX as float
		local directionY as float
		local directionZ as float
		
		mousex# = ScreenToWorldX (GetPointerX ( )) // GetPointerX()
		//mousex# = GetPointerX()
		mousey# = ScreenToWorldY ( GetPointerY ( )) // GetPointerY()
        //mousey# = GetPointerY()
		// it's also important to have the screen position of the pointer actually correctly, so use ScreenToWorldX and Y !
		
		if Options.Camera.Ortho = 0 
		
			CamX# = GetCameraX(1)
			CamY# = GetCameraY(1)
			CamZ# = GetCameraZ(1)

			distance =  100000 // GetDistance3D(camx#, camY#, camZ#, 0, 0, 0)  // 100000
			
			directionX = Get3DVectorXFromScreen( mousex#, mousey# ) * distance + GetCameraX(1)
			directionY = Get3DVectorYFromScreen( mousex#, mousey# ) * distance + GetCameraY(1)
			directionZ = Get3DVectorZFromScreen( mousex#, mousey# ) * distance + GetCameraZ(1)
			
			HitObjID =  ObjectRayCast( 0, GetCameraX(1), GetCameraY(1), GetCameraZ(1), directionX, directionY, directionZ )

		else
			
			distance = 100000
			HitObjID  = Object_RayCastOrtho(0, mousex#, mousey#, distance)
			
		endif



		if HitObjID > 0
			
			if start = 1
			
				//Options.Startx# = GetObjectRayCastX(0)
				//Options.Startz# = GetObjectRayCastZ(0)
				//Options.Starty# = GetObjectRayCastY(0)
		
			endif
		
			// PickVec = CreateVector3( GetObjectRayCastX( 0 ), GetObjectRayCastY( 0 ), GetObjectRayCastZ( 0 ) )
			// Add your code here for what you want to do to object.
		endif
	//endif	
		SetObjectPosition(Grid,0,0,0)

endfunction HitObjID
 
Function Object_RayCastOrtho(object_id, mouse_x, mouse_y, dist)
       
    unit_x# = Get3DVectorXFromScreen(mouse_x, mouse_y)
    unit_y# = Get3DVectorYFromScreen(mouse_x, mouse_y)
    unit_z# = Get3DVectorZFromScreen(mouse_x, mouse_y)
    
     
    // get the cameras position
    cam_x# = GetCameraX(1)
    cam_y# = GetCameraY(1)
    cam_z# = GetCameraZ(1)  
     
 
    // get the camera unit vector (this is 1000 long)
    MoveCameraLocalZ(1,dist)
    cam_dx# = GetCameraX(1) - cam_x#
    cam_dy# = GetCameraY(1) - cam_y#
    cam_dz# = GetCameraZ(1) - cam_z#
    MoveCameraLocalZ(1,-dist)
      
     // Create the Ray vector start and end positions
    start_x# = cam_x# + unit_x#
    start_y# = cam_y# + unit_y#
    start_z# = cam_z# + unit_z#
       
    end_x# = start_x# + cam_dx#
    end_y# = start_y# + cam_dy#
    end_z# = start_z# + cam_dz#
   
    hit_object_id = ObjectRayCast(object_id, start_x#, start_y#, start_z#, end_x#, end_y#, end_z#)
   
EndFunction hit_object_id
	
	
	
Function CheckRaycast(moveobj)

	// to see if we have selected an object/light...
	
	//if GetPointerPressed()
		
		moveobj = -1
		AssetTyp = 0 // type of assets : 0 = object, 1 = light, 2 =camera, 3 = fx, 
		ObjId = -1
		
		FoldStart // unselect all assets
		
		if Shift = 0 // GetRawKeyState(key_shift) = 0
								
			For i=0 to Object.length
				n = Object[i].Obj
				Deleteobject(object[i].ObjOutline)

				//SetObjectColorEmissive(n,0,0,0)
				SetObjectColorEmissive(n,Object[i].R,Object[i].G,Object[i].B)
				Object[i].Selected = 0
				
			next
			
			For i=0 to Light.length
				Light[i].Selected = 0
				SetObjectColorEmissive(Light[i].Obj,Light[i].R,Light[i].G,Light[i].B)
			next
		
		endif
		
		Foldend
		
		
		/*
		SetObjectCollisionMode(Grid,1)
		
		u = 80000
		worldX# = Get3DVectorXFromScreen( GetPointerX(), GetPointerY() ) * u 
		worldY# = Get3DVectorYFromScreen( GetPointerX(), GetPointerY() ) * u 
		worldZ# = Get3DVectorZFromScreen( GetPointerX(), GetPointerY() ) * u 									
		
		obj1 = ObjectRayCast(Grid, getcamerax(1), getcameray(1), getcameraz(1), worldx#, worldy#, worldz#)
		
		if obj1 <> 0
			
			Options.Startx# = GetObjectRayCastX(0)
			Options.Startz# = GetObjectRayCastZ(0)
			Options.Starty# = GetObjectRayCastY(0)
			
		endif
		
		SetObjectCollisionMode(Grid,0)
		*/
			
		CreateOutline(0,0)	
		obj = PickObject(0)
				
		// then test if selected						
		if obj <> 0								
			
			For i=0 to Object.length
				
				n = Object[i].Obj
				
				if obj = n or obj = object[i].ObjOutline
					
					if Shift = 0  	
						object[i].Selected = 1
						SetObjectColorEmissive(n,255,0,0)
					else
						object[i].Selected = 1 -object[i].Selected 					
						
						if object[i].Selected = 1
							SetObjectColorEmissive(n,255,0,0)
						else
							Deleteobject(object[i].ObjOutline)
							SetObjectColorEmissive(n,Object[i].R,Object[i].G,Object[i].B)
						endif
						
					endif
					
					if Object[i].Selected 
						
						moveobj = i
						ObjId = i
						
						CreateOutline(1,i)
						
						
						if Action = C_ACTIONMOVE
												
							Object[i].Start.Pos.X = Object[i].x  
							Object[i].Start.Pos.Y = Object[i].y  
							Object[i].Start.Pos.Z = Object[i].z 
						
							Options.Startx# = Object[i].x  
							Options.Starty# = Object[i].y
							Options.Startz# = Object[i].z
			
						
						Elseif action = C_ACTIONROTATE
										
							Object[i].Start.Rot.X = Object[i].rx  
							Object[i].Start.Rot.Y = Object[i].ry  
							Object[i].Start.Rot.Z = Object[i].rz 	
						
						Elseif action = C_ACTIONSCALE
							
							Object[i].Start.Siz.X = Object[i].sx  
							Object[i].Start.Siz.Y = Object[i].sy  
							Object[i].Start.Siz.Z = Object[i].sz 
								
						endif	
						
						
						
					endif
					
					AssetTyp = C_ASSETOBJ	
					
					UpdateSelection()
					
					exit					
				endif
			next
			
		endif
		
		
		// check light
		if moveObj = -1 
			
			For i=0 to Light.length
				
				n = Light[i].Obj
				
				//obj=ObjectRayCast(n,getcamerax(1),getcameray(1),getcameraz(1),worldx#,worldy#,worldz#)
				
				if obj = n	
					
					if Shift = 0  	
						light[i].Selected = 1
						SetObjectColorEmissive(n,255,0,0)						
					else
						light[i].Selected = 1-light[i].Selected 					
						if light[i].Selected = 1
							SetObjectColorEmissive(n,255,0,0)
						else
							SetObjectColorEmissive(n,light[i].R,light[i].G,light[i].B)
						endif
					endif
					
					
					if light[i].Selected  = 1
						
						moveobj = i
						ObjId = i
						AssetTyp = C_ASSETLIGHT		
						
						if Action = C_ACTIONMOVE
												
							light[i].StartX = light[i].x  
							light[i].StartY = light[i].y  
							light[i].StartZ = light[i].z 
						
							Options.Startx# = light[i].x  
							Options.Starty# = light[i].y
							Options.Startz# = light[i].z
			
						
						Elseif action = C_ACTIONROTATE
							/*			
							light[i].StartX = light[i].rx  
							light[i].StartY = light[i].ry  
							light[i].StartZ = light[i].rz 	
							*/
						Elseif action = C_ACTIONSCALE
							/*
							light[i].StartX = light[i].sx  
							light[i].StartY = light[i].sy  
							light[i].StartZ = light[i].sz 
							*/
						endif	
							
						
					endif
					
					
					
					
					exit					
				endif
			next
			
			
		endif
		
		//check camera
		if moveObj = -1 
			
			For i=0 to camera.length
				
				n = camera[i].Obj
				
				//obj=ObjectRayCast(n,getcamerax(1),getcameray(1),getcameraz(1),worldx#,worldy#,worldz#)
				
				if obj = n	
					
					if Shift = 0  	
						camera[i].Selected = 1
						SetObjectColorEmissive(n,255,0,0)						
					else
						camera[i].Selected = 1-camera[i].Selected 					
						if camera[i].Selected = 1
							SetObjectColorEmissive(n,255,0,0)
						else
							SetObjectColorEmissive(n,50,50,50)
						endif
					endif
					
					
					if camera[i].Selected  = 1
						
						moveobj = i
						ObjId = i
						AssetTyp = C_ASSETCAMERA	
						
						if Action = C_ACTIONMOVE
												
							camera[i].StartX = camera[i].x  
							camera[i].StartY = camera[i].y  
							camera[i].StartZ = camera[i].z 
						
							Options.Startx# = camera[i].x  
							Options.Starty# = camera[i].y
							Options.Startz# = camera[i].z
			
						
						Elseif action = C_ACTIONROTATE
							/*			
							light[i].StartX = light[i].rx  
							light[i].StartY = light[i].ry  
							light[i].StartZ = light[i].rz 	
							*/
						Elseif action = C_ACTIONSCALE
							/*
							light[i].StartX = light[i].sx  
							light[i].StartY = light[i].sy  
							light[i].StartZ = light[i].sz 
							*/
						endif	
							
						
					endif
					
					
					
					
					exit					
				endif
			next
		
		endif
		
		
		
		
		GetAssetProp()	
		
		// update panel select if assettyp = c_assetObj
		
		//
			// assetTyp = C_ASSETMESH
			if LAg_GetGadgetText(C_Gad_BtnSelectTyp) = "Mesh"
				if assetTyp = C_ASSETOBJ or assetTyp = C_ASSETMESH
					Lag_FreeallGadgetItemByGadget(C_Gad_SelectList)	
					CreateAllGadgetItem()
					assetTyp = C_ASSETMESH					
				endif
			endif
		
	//endif

EndFunction moveObj


Function GetAssetCanMove(moveobj)
	
	// to knwo if we can move an asset, if asset exists for example
	
	okmove = 0
	
	Select AssetTyp
									
		case C_ASSETOBJ
			if moveobj <= object.length
				okmove = 1
			endif
		endcase
		
		case C_ASSETLIGHT
			if moveobj <= light.length
				okmove = 1
			endif
		endcase
		
		case C_ASSETCAMERA
			if moveobj <= camera.length
				okmove = 1
			endif
		endcase
	endselect 


endfunction okmove








//***** View
Function SetCubeViewTocamera(pos)
	
	if pos = 1
		SetObjectPosition(CubeView, options.GeneralX, options.GeneralY,options.GeneralZ) 
	endif
	SetCameraPosition(1,GetObjectX(CubeView),GetObjectY(CubeView),GetObjectZ(CubeView))
	MoveCameraLocalZ(1, -500+cameraZoom#)

Endfunction

Function SetView(mode)
	
	// To change the view
	select mode
		
		case 0 // center in 0,0,0		
			
			options.GeneralX = 0
			options.GeneralY = 0
			options.GeneralZ = 0

		endcase
		
		case 1 // center on selected
			//SetCameraLookAt(1,GetObjectX(SelCube),GetObjectY(SelCube),GetObjectZ(SelCube),0)
			if objid>-1 and objid <= object.length
				//options.GeneralX = GetObjectX(SelCube)
				//options.GeneralY = GetObjectY(SelCube)
				//options.GeneralZ = GetObjectZ(SelCube)
				n = object[objID].Obj
				options.GeneralX = GetObjectX(n)
				options.GeneralY = GetObjectY(n)
				options.GeneralZ = GetObjectZ(n)
			endif
			
		endcase
		
		case 2 // reset view 
			
			//SetCameraPosition(1,100,500,-500)
			
			//SetCameraLookAt(1,0,0,0,0)
			options.GeneralX = 0
			options.GeneralY = 0
			options.GeneralZ = 0
			cameraZoom# = 0
			
			SetCameraRotation(1,30,0,0)
			SetObjectRotation(CubeView, 0,0,0)
			 

		endcase
	
	endselect
	
	For i=0 to object.length
		UpdateObjectCenterSprite(i)
	next
	
	SetCubeViewTocamera(1)
	
EndFunction





//***** Interface, menu, gadget
Function GetAssetProp()
	
	// to Get the properties of an object from the gadget
	
	Select AssetTyp // object can be an 3Dobject, a light, camera, fx (particle)....
	
		Case C_AssetObj
			GetObjProp()
		endcase 
	
		Case C_AssetLight
			GetLightProp()
		endcase 
		
		case C_ASSETCAMERA
			GetObjCameraProp()
		endcase
			
	EndSelect
	
	
EndFunction

Function SetAssetProp(mode)
	
	// to set the gadget with the properties of the selected object
	Select AssetTyp // object can be an 3Dobject, a light, camera, fx (particle)....
	
		Case C_ASSETOBJ
			SetObjProp(mode)
		endcase 
	
		Case C_ASSETLIGHT
			SetLightProp()
		endcase 
		
		case C_ASSETCAMERA
			SetObjcameraProp()
		endcase
		
	EndSelect
	
	
EndFunction







// Main Camera
Function GetCameraProp()
	
	Options.Camera.X = GetCameraX(1)
	Options.Camera.Y = GetCameraY(1)
	Options.Camera.Z = GetCameraZ(1)
	Options.Camera.RX = GetCameraAngleX(1)
	Options.Camera.RY = GetCameraAngleY(1)
	Options.Camera.RZ = GetCameraAngleZ(1)
	
	
EndFunction

Function SetCamera()
	
	if Options.Camera.Fov = 0
		Options.Camera.Ortho = 1
	endif
	if Options.Camera.OrthoW <=0
		Options.Camera.OrthoW =1000
	endif
	if Options.Camera.Near<=0.01
		Options.Camera.Near = 0.01
	endif
	if Options.Camera.Far <= 200
		Options.Camera.Far = 200
	endif
	if Options.Camera.Speed  <=0
		Options.Camera.Speed  = 4
	endif
	
	SetCameraRotation(1,Options.Camera.RX, Options.Camera.RY, Options.Camera.RZ)
	SetCameraPosition(1,Options.Camera.X, Options.Camera.Y, Options.Camera.Z)
	SetCameraFov(1,Options.Camera.Fov)
	SetCameraRange(1,Options.Camera.Near,Options.Camera.Far)
	
	SetCameraOrthoWidth(1,Options.Camera.Orthow)
	
	//SetCameraFOV(1,Options.Camera.Fov)
	//SetCameraRange(1,Options.Camera.Near,Options.Camera.Far)
	//SetCameraOrthoWidth(1,Options.Camera.OrthoW)
	
Endfunction

Function UpdateCameraUi()
	
	fov = Options.Camera.Fov*(1-Options.Camera.Ortho)
	LAG_SetGadgetText(C_Gad_CamFov,str(fov))
	
	LAG_SetGadgetText(C_Gad_CamFar,str(Options.Camera.Far ))
	LAG_SetGadgetText(C_Gad_CamNear,str(Options.Camera.Near))
	LAG_SetGadgetText(C_Gad_CamOrtW,str(Options.Camera.OrthoW))
	
	// position, rotation
	LAG_SetGadgetText(C_Gad_CamX,str(Options.Camera.X)) 
	LAG_SetGadgetText(C_Gad_CamY,str(Options.Camera.Y)) 
	LAG_SetGadgetText(C_Gad_CamZ,str(Options.Camera.Z)) 
	LAG_SetGadgetText(C_Gad_CamRX,str(Options.Camera.RX)) 
	LAG_SetGadgetText(C_Gad_CamRY,str(Options.Camera.RY)) 
	LAG_SetGadgetText(C_Gad_CamRZ,str(Options.Camera.RZ)) 
	
	// update camera view
	v$="Front,2,Right,Left,Perspective,Bottom,Top,"
	if cameraView = 0
		view = 5
	endif
	LAG_StatusBarText(0,1,"View : "+GetStringToken(v$,",",View))
	
	// need to update the centers of objects
	UpdateAllCenter()
	
EndFunction

Function CameraBehind(obj)
 
	// by markus
    
    local x as float,y as float,z as float
    
    
    
    x = getobjectx(obj)
    y = getobjecty(obj)
    z = getobjectz(obj)
     
    setcameraposition(1,x,y,z)
    camZ1 = 50
    MoveCameraLocalZ(1, -camZ1) //behind

    x = GetObjectAngleX(obj)
    y = GetObjectAngleY(obj)
    z = GetObjectAngleZ(obj)
 
    SetCameraRotation(1,x,y,z)
    
	// SetCameraLookAt(1, options.GeneralX, options.GeneralY, options.GeneralZ,0)
    
    // MoveCameraLocalY(1, 1.5) //move to head
     
EndFunction 

FoldStart // Camera


Function GetScreenBoundEditor()

	FoldStart // to detect if screenwidth/height has changed 
	
	// PRint("BoundLeft : "+str(GetScreenBoundsLeft())+" / Top : "+ str(GetScreenBoundsTop())+" / Botom : "+ str(GetScreenBoundsBottom()) +" / Right : "+ str(GetScreenBoundsRight()))
	
	// PRint("G_width : "+str(GetScreenBoundsLeft())+"/"+ str(GetScreenBoundsRight())+" | "+str(G_Width)+" | "+str(GetDeviceWidth()))
	// PRint(str(GetScreenBoundsTop())+"/"+ str(GetScreenBoundsBottom())+" | "+str(G_height))
	// Print("G_Width / G_height : "+str(G_width)+" | "+str(G_height))

	
	if TimerReso <= 0
		
		TimerReso = 10
		
		//NewG_width = GetDeviceWidth()
		//NewG_height = GetDeviceHeight()
		
		BoundLeft 	= GetScreenBoundsLeft()
		BoundRight 	= GetScreenBoundsRight()
		BoundTop 	= GetScreenBoundsTop()
		BoundBottom = GetScreenBoundsBottom()
		
		if GameProp.BoundLeft <> BoundLeft or GameProp.BoundRight <> BoundRight or GameProp.BoundTop <> BoundTop or GameProp.BoundBottom <> BoundBottom
			
			// set the new window bound
			GameProp.BoundLeft 	= BoundLeft
			GameProp.BoundRight = BoundRight
			GameProp.BoundTop 	= BoundTop
			GameProp.BoundBottom = BoundBottom
			
			u = 30
			
			
			
			old_G_width = G_width
			
			G_width	= BoundRight - BoundLeft
			G_height = BoundBottom -BoundTop
			PanelLx = -BoundLeft
			PanelR = -BoundLeft
			
			
			// set gadget size needed
			//LAG_SetGadgetSize(C_Gad_PanelL,BoundLeft,BoundTop+MenuH+u+ToolBarH,LAG_C_IGNORE,LAG_C_IGNORE,-1)
			LAG_SetGadgetSize(C_Gad_PanelL,BoundLeft,BoundTop+PanelY,LAG_C_IGNORE,G_height+50,-1)
			
			LAG_SetGadgetSize(C_Gad_PanelR,BoundRight-panelW,BoundTop+PanelY,LAG_C_IGNORE,G_height+50,-1)
			//LAG_SetGadgetSize(C_Gad_PanelLayer,BoundRight-PanelW,BoundTop+MenuH+u+Options.ui.PanelRH+30,LAG_C_IGNORE,LAG_C_IGNORE,-1)
			
			//resize menu
			LAG_SetMenuSize(0, BoundRight-BoundLeft, -1)
			LAG_SetMenuPosition(0, BoundLeft, BoundTop)
			
			// resize toolbar width
			LAG_SetGadgetSize(C_Gad_TB, -100+BoundLeft, BoundTop+ToolBarY,BoundRight+150-BoundLeft, LAG_C_IGNORE,-1)
			
			// reisze statusbar
			LAG_SetStatusBarWidth(StatusBarMain, BoundRight-BoundLeft)
			LAG_SetStatusBarPosition(StatusBarMain, BoundLeft, BoundBottom-StatusBarH)
			
			
			// debug info
			SetTextPosition(1, PanelW+GameProp.BoundLeft+20, 65+GameProp.BoundTop)
			SetTextMaxWidth(1,G_width-2*(PaneLW+20))
		endif
		
	else
		dec TimerReso
	endif
	
	// Print(str(GetVirtualWidth())+"/"+str(GetVirtualHeight()))

	Foldend
			
Endfunction



MoveCamera:

	FoldStart 
	// dc as float
	// dc = Options.CameraSpeed
	
	// Move camera
	
	
	FoldStart // move with arrow & wheel
	
	if Options.Camera.Ortho = 0
		
		FoldStart // camera perspective
		if ( GetRawKeyState(37) )
			// MoveCameraLocalX( 1, -dc )
			MoveObjectLocalX( CubeView, -dc )
			UpdateAllCenter()
		endif
		
		if ( GetRawKeyState(39) ) 
			// MoveCameraLocalX( 1, dc)
			MoveObjectLocalX( CubeView, dc )
			UpdateAllCenter()
		endif
		
		if ( GetRawKeyState(38)) 
			cameraZoom# = cameraZoom# + dc
			//MoveCameraLocalZ( 1, dc )
			//MoveObjectLocalZ( CubeView, dc )
			//CameraBehind(CubeView)
			UpdateAllCenter()
		endif
		if ( GetRawKeyState(40))
			cameraZoom# = cameraZoom# - dc 
			//MoveCameraLocalZ( 1, -dc )
			//MoveObjectLocalZ( CubeView, -dc )
			//CameraBehind(CubeView)
			UpdateAllCenter()
		endif
		
		/*
		if GetRawMouseWheelDelta() <> 0					
			MoveCameraLocalZ(1,dc*GetRawMouseWheelDelta())
			UpdateAllCenter()
		endif
		*/
		
		wheel = GetRawMouseWheelDelta() 
		if wheel <> 0
			// MoveObjectLocalZ( CubeView, dc*GetRawMouseWheelDelta() )
			// CameraBehind(CubeView)
			// MoveCameraLocalZ(1,dc*GetRawMouseWheelDelta())
			cameraZoom# = cameraZoom#+ GetRawMouseWheelDelta()*6
					
			UpdateAllCenter()			 
		endif
		
		
		
		foldend		
		
	else
		
		foldstart // mode orthographic
		//print("camera view: "+str(CameraView))
		
		Select CameraView 
			
			case 7
				
				if ( GetRawKeyState(37) )
					MoveObjectLocalX( CubeView, -dc )
					UpdateAllCenter()
				endif
				
				if ( GetRawKeyState(39) ) 
					MoveObjectLocalX( CubeView, dc )
					UpdateAllCenter()
				endif
				if ( GetRawKeyState(38)) 
					MoveObjectLocalZ( CubeView, dc )
					UpdateAllCenter()
				endif
				if ( GetRawKeyState(40)) 
					MoveObjectLocalZ( CubeView, -dc )
					UpdateAllCenter()
				endif
			
			endcase
			
			case 1
				
				if ( GetRawKeyState(37) )
					MoveObjectLocalX( CubeView, dc )
					UpdateAllCenter()
				endif
				
				if ( GetRawKeyState(39) ) 
					MoveObjectLocalX( CubeView, -dc )
					UpdateAllCenter()
				endif
				if ( GetRawKeyState(38)) 
					MoveObjectLocalY( CubeView, -dc )
					UpdateAllCenter()
				endif
				if ( GetRawKeyState(40)) 
					MoveObjectLocalY( CubeView, dc )
					UpdateAllCenter()
				endif
				
			endcase
			
			case 3 
				
				if ( GetRawKeyState(37) )
					MoveObjectLocalZ( CubeView, -dc )
					UpdateAllCenter()
				endif
				
				if ( GetRawKeyState(39) ) 
					MoveObjectLocalZ( CubeView, dc )
					UpdateAllCenter()
				endif
				if ( GetRawKeyState(38)) 
					MoveObjectLocalY( CubeView, -dc )
					UpdateAllCenter()
				endif
				if ( GetRawKeyState(40)) 
					MoveObjectLocalY( CubeView, dc )
					UpdateAllCenter()
				endif
				
			endcase
			
		Endselect
		
		wheel = GetRawMouseWheelDelta() 
		if wheel <> 0
			Options.Camera.OrthoW = Options.Camera.OrthoW - dc*GetRawMouseWheelDelta()
			SetCameraOrthoWidth(1,Options.Camera.OrthoW)
			UpdateAllCenter()
			UpdateCameraUi() 
		endif
		
		Foldend
		
	endif
	
	FoldEnd
			
	//if move = 0 and rotate = 0 and scale = 0
		/*
		oldx#= GetCameraX(1)
		oldy#= GetCameraY(1)-45.0
		oldz#= GetCameraZ(1)			
		*/
	
		
	FoldStart // MOUSE Camera perspective 
	
	
	// Print("camera : "+str(GetCameraAngleX(1),0)+"/"+str(GetCameraAngleY(1),0)+"/"+str(GetCameraAngleZ(1),0))

	
	
	if Options.Profil$ = ""
	
		FoldStart // profil : blender
		
		if Ctrl = 1 or ActionView = 1 
		
			FoldStart // PAN the view (pour bouger la camera (pan))
		
			
			if ( GetRawMouseLeftPressed () )
				
				startx1# = GetPointerX()
				starty1# = GetPointerY()
				angx# = GetCameraAngleX(1)
				angy# = GetCameraAngleY(1)
				
			endif
			
			if ( GetRawMouseLeftState() = 1 )
				
				new_x# = GetPointerX()
				new_y# = GetPointerY()
				
				DiffX# = StartX1# - New_X# //10
				DiffY# = New_Y# - StartY1# //10
				
				if cameraview <> 7
										
					if GetCameraAngleY(1) >=89 and GetCameraAngleY(1)<=91 and  (cameraview <=3)
						MoveObjectLocalZ(CubeView, - DiffX#)
					else
						MoveObjectLocalX(CubeView, DiffX#)
					endif
					
					if GetCameraAngleX(1) < 70
						MoveObjectLocalY(CubeView,DiffY#)
					else
						MoveObjectLocalZ(CubeView,DiffY#)
					endif
					
				else
					
					if GetCameraAngleY(1) >=89 and GetCameraAngleY(1)<=91
						MoveObjectLocalZ(CubeView, -DiffX#)
					else
						MoveObjectLocalX(CubeView, DiffX#)
					endif
					
					if GetCameraAngleX(1) < 70
						MoveObjectLocalY(CubeView, DiffY#)
					else
						MoveObjectLocalZ(CubeView, DiffY#)
					endif

				endif
					
				//reset start point					
				startx1# = new_x#					
				starty1# = new_y#
				
				// Set The ceter position
				options.GeneralY = getObjectY(CubeView) //options.GeneralY + new_y# - starty1#
				options.GeneralX = getObjectX(CubeView) //options.GeneralX - new_x# + startx1#
				options.GeneralZ = getObjectZ(CubeView) // options.GeneralY +  new_y#-starty1#
				
				// update the center of objects 
				UpdateAllCenter()
			endif
				
			Foldend	
				
		
			
		elseif actionview = 3 // zoom
			
			FoldStart // Zoom
			
			if ( GetRawMouseLeftPressed () )
				
				startx1# = GetPointerX()
				starty1# = GetPointerY()
				angx# = GetCameraAngleX(1)
				angy# = GetCameraAngleY(1)
				
			endif

			if ( GetRawMouseLeftState() = 1 )
				
				new_x# = GetPointerX()
				new_y# = GetPointerY()
				
				DiffX# = StartX1# - New_X# //10
				DiffY# = New_Y# - StartY1# //10
				
				cameraZoom# = cameraZoom# - DiffY#
				
				diffy# = 0
				
				// update the center of objects 
				UpdateAllCenter()
			endif
				
			Foldend
			
		else
			
			FoldStart // rotate the view
			
			if ( (Alt=1 or actionview = 2 )and  GetRawMouseLeftPressed () ) or ( GetRawMouseMiddlePressed() )
			
				startx1# = GetPointerX()
				starty1# = GetPointerY()				
				UpdateAllCenter()
				
			endif
		
			if ( (Alt=1 or actionview = 2 ) and  GetRawMouseLeftState () ) or GetRawMouseMiddleState() = 1 
				
		
				new_x# = GetPointerX()
				new_y# = GetPointerY()
				
				DiffX# = (New_X# - StartX1#) 
				DiffY# = (New_Y# - StartY1#) 

				RotateObjectGlobalY(CubeView,DiffX#)
				RotateCameraGlobalY(1,DiffX#)
				RotateCameraLocalX(1,DiffY#)
				
				startx1# = new_x#						
				starty1# = new_y#

				UpdateAllCenter()
				
			endif

			Foldend
			
		endif
		Foldend
		
	else
		
		FoldStart // profil : autre 
		
		if ( GetRawMouseRightPressed() )
			startx1# = GetPointerX()
			starty1# = GetPointerY()
			angx# = GetCameraAngleX(1)
			angy# = GetCameraAngleY(1)
			//pressed = 1
		endif

		if ( GetRawMouseRightState() = 1 )
			fDiffX# = (GetPointerX() - startx1#)/1.0
			fDiffY# = (GetPointerY() - starty1#)/1.0

			newX# = angx# + fDiffY#
			/*
			if ( newX# > 89 ) then newX# = 89
			if ( newX# < -89 ) then newX# = -89
			*/
			SetCameraRotation( 1, newX#, angy# + fDiffX#, 0 )
			UpdateAllCenter()
		endif
		
		foldend
	
	endif
	
	

	FoldEnd


Foldend

Return 

FoldEnd







//********************************* OLD FUNCTIONS  : NOT USED ANYMORE
Function limb(obj1,obj2,xstep#,ystep#,zstep#)
    
    setobjectposition(obj2,getobjectX(obj1),getobjectY(obj1),getobjectZ(obj1))
    setobjectrotation(obj2,getobjectanglex(obj1),getobjectangleY(obj1),getobjectangleZ(obj1))
    moveobjectlocalx(obj2,xstep#)
    moveobjectlocaly(obj2,ystep#)
    moveobjectlocalz(obj2,zstep#)
    
endfunction
