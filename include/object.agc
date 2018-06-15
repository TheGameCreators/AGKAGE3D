
//*********** The objects & Assets

FoldStart // Types

Type sAsset
	
	Id as integer
	nom$
	
EndType

Type sProfilObj
		
	name$
	Size as integer
	W
	H
	L
	ShadowCast 
	ShadowReceive
	
EndType


Type tStageTexture
	
	// StageId as integer
	ImageId as integer // id of image used
	TextureId as integer // id in texture bank
	UVx as float
	UVy as float
	UVw as integer
	UVh as integer
	ImgName$
	
	// for the saving
	LibImg as integer
	
Endtype

Type tAnim
	
	Speed as float
	FrameSt as float
	FrameEnd as float
	
endtype

Type tVector
	
  x as float
  y as float 
  z as float 
   
EndType

Type tcolor
	r
	g
	b
	a
endtype

Type tLock
	
	Pos as tVector
	Rot as tVector
	Siz as tVector
	
endtype



Type tPhysic
	
	Colision
	Mass
	Restitution
	Damping
	
endtype






Type sObject
	
	name$
	
	Obj as integer
	ObjOutline as integer // the outlined object
	
	Icon as integer // icon for panel select
	
	UniqueId as integer // it's the unique ID, defined at creation (by oBject[i].UniqueId = GameProp.UniqueId : inc GameProp.UniqueId), it's for the behavior
	
	Pivot as tVector
	
	// ingame 
	visibleInGame
	
	// Pour la selection by border 
	Spr as integer // sprite center
	xp_screen# as integer
    yp_screen# as integer
   
	
	ParentId as integer
	Group as String[0]
	Layer as integer[0]
	
	LightMapID as integer
	
	Typ as integer // box,sphere, plane...
	
	
	// Physic
	Physics as tPhysic
	Physic as integer
	OldPhysic as integer
	// PhysicObjId as integer
	Shape as integer
	Mass as integer
	
	// Behavior - comportement
	Behavior as tBehavior[]
	Dir as integer // for the object moving (behavior)
	IsPlayer as integer

	// pos, rot, scale
	x as float
	y as float
	z as float
	
	// rotation
	rx as float
	ry as float
	rz as float
	
	// size
	sx as float
	sy as float
	sz as float	
	Size as Float
	
	// color
	R as integer
	G as integer
	B as integer
	Color as tcolor
	Alpha as integer
	BM as integer
	Tra as integer // transparency 
	
	//proportion for box,sphere,cone, capsule,cylinder, plane
	W as integer
	H as integer
	L as integer // Length
	
	// Anim	
	Animated as integer
	Anim as tAnim


	IdObj3D as integer // si le typ est un model 3D de la banque, alors, je conserve son id pour la sauvegarde
	
	
	// Type
	ObjTyp as integer // (object, action, npc, fx, mob...)
	SubTyp as integer // si action : teleporter, start...
	Param as string[1]
	
	
	// textures
	Stage as tStageTexture[7] // sur quel canal d'image on est ?
	StageId as integer // sur quel canal d'image on est ?
	Shader as integer
	
	Normalmap as integer // we use normalmap ?
	LightMap as integer // we use lightmap as texture ?
	
	
	// SHadow
	Shadow as integer // project shadow for lightmapper
	ShadowCast as integer // cast shadow  RT
	ShadowRec as integer // receive shadow RT
	AO as integer // project ambient occlusion for lightmapper - Not used for the moment
	
	FogMode as integer
	Lightmode as integer 
	

	// editor only
	AssetTyp as integer //  necessary when copy/paste

	Locked as integer
	Hide as integer
	Selected as integer
	
	Lock as tLock
	
	Start as tLock
	StartS as float // size
	
	X1 as float
	Y1 as float
	Z1 as float
	
	
endtype
 


foldend
 
 
FoldStart // Constants 
 
 // constant object
#constant C_SETOBJPROP_GEN = 0
#constant C_SETOBJPROP_COL = 1
#constant C_SETOBJPROP_UV = 3
#constant C_SETOBJPROP_STAGEImg = 4



// constant transformation
#constant C_transform_Hide = 0
#constant C_transform_Lock = 1


//*** ASSETTYP -> ASSET TYPES (work with AssetTyp =)
#Constant C_ASSETOBJ 	= 0
#Constant C_ASSETLIGHT 	= 1
#Constant C_ASSETCAMERA = 2
#Constant C_ASSETFX 	= 3
#Constant C_ASSETMESH 	= 4
#Constant C_ASSETMax 	= 4

#Constant C_ASSETSTART 	= 5
#Constant C_ASSETUI 	= 6 // sprite for UI
#Constant C_ASSETACTION = 7 // teleporter, treasur


//*** OBJTYP -> 3D OBJECT TYPES (if AssetTyp = C_ASSETOBJ) // (work with ObjTyp =)
#Constant C_OBJBOX = 0
#Constant C_OBJSPHERE = 1
#Constant C_OBJCAPSULE = 2
#Constant C_OBJCONE = 3
#Constant C_OBJCYLINDER = 4
#Constant C_OBJPLANE = 5
#Constant C_OBJBANK = 6
#Constant C_OBJWATER = 7
#Constant C_OBJTERRAIN = 8
#Constant C_OBJPARTSYS = 9
#Constant C_OBJLAST 	= 10

Foldend
 
 
 
 
 
// init, add
Function InitObject()
	
	// Global Dim Assets[] as sAsset // the assets = obj3D, light, camera,Fx...
	Global Dim Object[] as sObject // the 3D objects
	
	Global Dim TempObj[] as sObject // the 3D objects
	
	Global dim ProfilObject[10] as sProfilObj
	SetProfilObject(C_OBJBOX,"Box",10,10,10,10,0,0)
	SetProfilObject(C_OBJSPHERE,"Sphere",10,10,10,10,0,0)
	SetProfilObject(C_OBJCAPSULE,"Capsule",10,10,20,10,0,0)
	SetProfilObject(C_OBJCONE,"Cone",10,10,20,10,0,0)
	SetProfilObject(C_OBJCYLINDER,"Cylinder",10,10,10,10,0,0)
	SetProfilObject(C_OBJPLANE,"Plane",10,10,10,10,0,0)
	SetProfilObject(C_OBJBANK,"Model",10,1,1,1,0,0)
	SetProfilObject(C_OBJWATER,"Water",10,10,10,10,0,0)
	
	
EndFunction

Function SetProfilObject(id, name$, size, w, h, l, cast, receive)

	// set the profil for object asset
	
	ProfilObject[id].name$ = name$
	ProfilObject[id].Size = size
	ProfilObject[id].W = w
	ProfilObject[id].h = h
	ProfilObject[id].l = l
	ProfilObject[id].ShadowCast = cast
	ProfilObject[id].ShadowReceive = receive


Endfunction






// ADD object
Function CreateNewObject(mode)
	
	// to add  a new object in the level (clic in 3Dview, A key or menu)
	/*
	u = 5000	
	worldX# = Get3DVectorXFromScreen( GetPointerX(), GetPointerY() ) * u
	worldY# = Get3DVectorYFromScreen( GetPointerX(), GetPointerY() ) * u
	worldZ# = Get3DVectorZFromScreen( GetPointerX(), GetPointerY() ) * u	 
	worldX# = worldX# + GetCameraX(1)
	worldY# = worldY# + GetCameraY(1)
	worldZ# = worldZ# + GetCameraZ(1)
	
	SetObjectCollisionMode(grid,1)
	obj = ObjectRayCast(Grid,getcamerax(1),getcameray(1),getcameraz(1),worldx#,worldy#,worldz#)
	SetObjectCollisionMode(grid,0)
	*/
	
	
	get_mouse_coords(0)
	x = round(Mouse_X)
	z = round(Mouse_Z)
	y = 0
	
		
	if mode = 1 //create from menu 		
		X = 0
		y = 0
		z = 0
	else // A key or clic in view3D
		/*x = GetObjectRayCastX(0)
		y = GetObjectRayCastY(0)										
		z = GetObjectRayCastZ(0)*/
	endif	
									
	// SetObjectPosition(CibleEd,x,y,z)
	// SetObjectLookAt(CibleEd,getcameraX(1),getcameray(1),getcameraz(1),0)
	
	if ObjTyp = C_OBJBANK
		
		If bankModel.length >-1
			if Options.BankModelId >-1										
				AddObjet(x,y,z,"")
			endif
		else
			LAG_Message("Information","You need to import a model first. Clic on the 'import model' button to import a model into the bank model, then clic on the '+' or the A key to add the model in the level.","")
		endif
		
	elseif ObjTyp = C_OBJPARTSYS
		AddObjectPartSyst(x,y,z)
	else
		// un objet geometry :  box, sphere, plane...	
		AddObjet(x,y,z,"")
	endif
		
				

EndFunction


Function AddObjet(x#,y#,z#,option$)
	
	// To add an object in the level
	/*
	pour obj geometry : 
	Option$ = "img,sx,sy,sz,rx,ry,rz"
	
	
	for obj model
	"name$"
	
	For Terrain :
	Option$ = Heightmap$+","img$+",shader,uvscale,w,h,l,smooth,split,"
	img$ ="img0;img1;img2;..."
	*/
	
	/* OBjTyp : the type of object 
	See constant.agc
	*/
				
	if OBjTyp = C_OBJBANK
		
		FoldStart // Bank object
		
			name$ = GetStringToken(option$,",",1)
			
		
			if BankModel.Length >-1
			
				BankId = Options.BankModelId
				if bankId >-1 and BankId <= BankModel.length
				
					if GetObjectExists(BankModel[BankId].id)
					
					FoldStart 
					
					i = Object.length+1			
					Global Dim Object[i] as sObject
					//Object[i].obj = InstanceObject(BankModel[BankId].id)
					// if BankModel[BankId].Animated = 0
						Object[i].obj = CloneObject(BankModel[BankId].id)
					// else
						// message("objet animéd, instance donc ! ")
						// Object[i].obj = instanceObject(BankModel[BankId].id)
					// endif
					
					
					if bankModel[BankId].Animated >=1					
						Object[i].Animated = 1
					endif
					
					Object[i].IdObj3D = BankId
					
					n = Object[i].obj
					ObjId = i	
							
					if name$ = ""
						// Object[i].name$ = Options.BankModeName$ + str(i)
						Object[i].name$ = GetFilePart(BankModel[BankId].name$) + str(i)
						
					else
						Object[i].name$ = name$
					endif
					
					Object[i].Normalmap = BankModel[BankId].normalmap
					Object[i].lightmap = BankModel[BankId].lightmap
					
					SetObjectDefault(x#,y#,z#)
					
					Object[i].Shader = BankModel[BankId].Shader
					
					if bankModel[BankId].Animated >=1						
						// PlayObjectAnimation(n,"",0,-1,0,0)
						// SetObjectAnimationSpeed(n, bankModel[BankId].AnimSpeed)
						Object[i].Animated = 1
					endif
					
					// Object[i].Image.length = BankModel[BankId].Img.length
					length = BankModel[BankId].Img.length
					

					For k = 0 to length
						Object[i].Stage[k].ImageId = BankModel[BankId].Img[k].img
						Object[i].Stage[k].TextureId = BankModel[BankId].Img[k].TextureId
						Object[i].Stage[k].UVw = BankModel[BankId].Img[k].scaleW
						Object[i].Stage[k].UVh = BankModel[BankId].Img[k].scaleH
						Object[i].Stage[k].UVx = BankModel[BankId].Img[k].OffsetX
						Object[i].Stage[k].UVy = BankModel[BankId].Img[k].OffsetY
					next
					
					Option$ = BankModel[BankId].Info$
					
					// img = BankModel[BankId].
					
					/*
					img$ = GetStringToken(option$,",",1)
					Object[i].sx = ValFloat(GetStringToken(option$,",",2))
					Object[i].sz = ValFloat(GetStringToken(option$,",",3))
					Object[i].sy = ValFloat(GetStringToken(option$,",",4))
					Object[i].rx = ValFloat(GetStringToken(option$,",",5))
					Object[i].rz = ValFloat(GetStringToken(option$,",",6))
					Object[i].ry = ValFloat(GetStringToken(option$,",",7))
					*/
					
					SetObjectPosition(n,x#,y#,z#)			
					SetObjectRotation(n,Object[i].rx,Object[i].ry,Object[i].rz)
					SetObjectVisible(n,1)
					
					SetObjectLightMode(n,1)
					
					if Object[i].Normalmap = 1 or Object[i].lightmap = 1
						UpdateObjetMaterial(i)
					endif
					
					Foldend
				
					endif
			
				endif
			
			endif
			
		Foldend
			
	elseIf ObjTyp = C_OBJTERRAIN
		
		FoldStart // terrain 
		
		/*
		For Terrain :
		Option$ = Heightmap$+","img$+",shader,uvscale,w,h,l,smooth,split,"
		img$ ="img0;img1;img2;..."
		*/
		LoadId$ = CreateLoadingWindow("Terrain creation, please wait...")
		u=1
		Heightmap$ = GetStringToken(option$,",",u) : inc u
		
		image$ = GetStringToken(option$,",",u) : inc u
		count = CountStringTokens(image$,";")
		local dim imgter[count] as integer
		For i=0 to imgter.length
			imgter[i] =  val(GetStringToken(image$,";",i+1))
		next
		
		shader = val(GetStringToken(option$,",",u)) : inc u
		uvscale = val(GetStringToken(option$,",",u)) : inc u
		w = val(GetStringToken(option$,",",u)) : inc u 
		h = val(GetStringToken(option$,",",u)) : inc u
		l = val(GetStringToken(option$,",",u)) : inc u
		smooth = val(GetStringToken(option$,",",u)) : inc u
		split = val(GetStringToken(option$,",",u)) : inc u 
		
		//MEssage(Option$)
		
		if Heightmap$ <> "" and GetFileExists(Heightmap$)
			
			i = Object.length+1			
			Global Dim Object[i] as sObject
			
			Object[i].obj = CreateObjectFromHeightMap(Heightmap$, w, h, l, smooth, split )
			n = Object[i].obj
			ObjId = i
			Object[i].IdObj3D = -1
			SetObjectUVScale(n,0,uvscale,uvscale) 
			
			ObjId = i
			
			SetObjectDefault(x#,y#,z#)
				
			Object[i].name$ = "Terrain"+str(i)
			Object[i].W = w
			Object[i].h = h
			Object[i].l = l
			object[i].selected=1
			object[i].locked=0
			
			Object[i].Shader = Shader
			For i=0 to imgter.length
				SetObjectImage(n, imgter[i], i )
			next
			
			if imgter.length<0 and TExtureID> -1 
				img = GetCurrentTexture(1)
				SetObjectImage(n, img, 0 )
			endif
			//SetObjectShader(n, shader)
			
			SetObjectColorEmissive(n,255,0,0)
			GetObjProp()
			
		
		else
			message("Unable to create the terrain")	
		endif
		
			FreeLoadingWindow(LoadId$)
			
		FoldEnd
		
	elseif ObjTyp = C_OBJWATER
				
		FoldsTart  // water 
			// options$ 
			u = 1
			
			sx#  = valfloat(GetStringToken(option$,",",u)) : inc u 
			sy#  = valfloat(GetStringToken(option$,",",u)) : inc u 
			sz#  = valfloat(GetStringToken(option$,",",u)) : inc u 
			
			wat = Options.WaterImageSize								
			AddWater(-2,wat,wat,wat,wat,0)
			if ObjId >-1 and ObjID <= Object.length
				i = ObjId 			
				Object[i].IdObj3D = -1
				n = Object[ObjId].Obj
				SetObjectPosition(n,x#,y#,z#)
				// SetObjectScale(n,sx#,sy#,sz#)
			endif
		FoldEnd
		
	else
		
		FoldStart // Other Object like : box,sphere,plane, cone, cylinder, capsule
						
			i = Object.length+1			
			Global Dim Object[i] as sObject			
			
			ObjId = i
			
			Object[i].IdObj3D = -1
			// u = 20
			// a = 10
			//if LoadDoc = 0
				//a = Options.Asset.W //* Options.Asset.Size
				//b = Options.Asset.H * Options.Asset.Size
				//c = Options.Asset.L * Options.Asset.Size
			//else
			Options.Asset.Size = min2(valfloat(LAG_GetGadgetText(C_Gad_AssetSize)), 0.1)
			Options.Asset.W = min2(valfloat(LAG_GetGadgetText(C_Gad_AssetW)),0.1)
			Options.Asset.H = min2(valfloat(LAG_GetGadgetText(C_Gad_AssetH)),0.1)
			Options.Asset.L = min2(valfloat(LAG_GetGadgetText(C_Gad_AssetL)),0.1)

				a = Options.Asset.W
				b = Options.Asset.H
				c = Options.Asset.L
				
			//endif
			
			name$ = "Object"
			
			w# = a
			h# = b
			p# = c
			
			select OBjTyp
							
				case C_OBJPARTSYS
					a = 50
					Object[ObjId].Obj = CreateObjectBox(a,a,a)
					name$="PartSys"
				endcase
				
				case C_OBJBOX 
					Object[ObjId].Obj = CreateObjectBox(a,b,c)
					name$="box"
				endcase
				
				case C_OBJSPHERE
					
					Object[ObjId].Obj = CreateObjectSphere(a,b,c)
					name$="sphere"
				endcase
				
				case C_OBJCAPSULE
					
					Object[ObjId].Obj = CreateObjectCapsule(a,b,c)
					//Object[ObjId].Obj = CreateObjectCapsule(a,a*2,a)
					name$="capsule"
					//h# = a*2
				endcase
				
				case C_OBJCONE
					
					Object[ObjId].Obj = CreateObjectCone(a,b,c)
					name$="cone"
				endcase
				
				case C_OBJCYLINDER
					
					Object[ObjId].Obj = CreateObjectCylinder(a,b,c)
					name$="cylinder"
					
				endcase
				
				case C_OBJPLANE				
					Object[ObjId].Obj = CreateObjectPlane(a,b)
					Object[ObjId].Rx = 90
					SetObjectRotation(Object[ObjId].Obj,90,0,0)
					name$="plane"
					h#=0
				endcase
				
			endselect
			
			Object[ObjId].name$ = name$ +str(ObjId)
			
			SetObjectDefault(x#,y#,z#)
			SetObjectDimension(w#,h#,p#)
			
			n = Object[ObjId].Obj
			SetObjectPosition(n,x#,y#,z#)
			
			Object[ObjId].Stage[0].ImageId = -1
			
			if TextureId > -1 
				
				img = GetCurrentTexture(1)
				SetObjectImage(n,img,0)
				Object[ObjId].Stage[0].TextureId = CheckTextureId() //TextureId
				Object[ObjId].Stage[0].ImageId = img
				
			endif
			
			SetObjectShader(n,-1)
			SetObjectScreenCulling(n,0)
			
		FoldEnd
		
	endif
	
	if Object.Length >-1 and objId >-1 and ObjId <=Object.Length 
		Object[objId].AssetTyp = C_ASSETOBJ	
		SetPhysicToObject(objId, 0)	
	endif

EndfunCtion i


Function SetObjectDefault(x#,y#,z#)
	
	// set the default parameter for an object, after creation, or to reset it
		
	u = 20
	a = 10
	
	i = ObjId
	
	if objId <= object.length
	
	// icon for panel select
	/*
	select ObjTyp 
		case C_OBJBANK
			img = LAG_getgadgetimage(C_Gad_PreviewModel)
		endcase
	endselect
	*/
	
	if ObjTyp > UiObjImg.length
		ObjTyp = UiObjImg.length
	endif
	
	Object[ObjId].Icon = UiObjImg[ObjTyp]
	 	
	
	// shadows
	Object[ObjId].Shadow = 1 	// shadow on lightmap  - Options.ShadowOn
	Object[ObjId].AO = 1 		// AO on lightmap 
	Object[ObjId].Shadowcast = 0 	
	Object[ObjId].ShadowRec = 0
	
	// image 	
	Object[ObjId].LightMap = 0 	
	Object[ObjId].Normalmap = 0
	 	
	 //fog, light...	
	Object[ObjId].Fogmode = 1	
	Object[ObjId].LightMode = 1	
	Object[ObjId].VisibleInGame = 1	
	
	Object[ObjId].isPlayer = 0	
	
	
	
	// sprite for center (on crée le sprite pour afficher le centre (pour la sélection border))
	n = createsprite(0) 	// Options.ShadowOn
	Object[ObjId].spr = n
	SetSpriteSize(n,10,10)
    SetSpriteColor(n,0,0,255,150)
	SetSpriteDepth(n, 1000)
	SetSpriteVisible(n, Options.ShowCenter)


	// physics
	Col =  Options.Asset.Colision
	Body =  Options.Asset.PhysicsBody
	
	Object[ObjId].Mass = 1
	Object[ObjId].shape = 1 
	
	Object[ObjId].OldPhysic = -1
	
	Object[ObjId].Physics.Colision = Col
	Object[ObjId].Physic = Body
	
	// colors 
	Object[ObjId].R = 0 
	Object[ObjId].G = 0 
	Object[ObjId].B = 0 
	Object[ObjId].Alpha = 255 
	
	// position
	Object[ObjId].X = x# 
	Object[ObjId].Y = y# 
	Object[ObjId].Z = z#
	Object[i].Start.Pos.X = Object[i].x  
	Object[i].Start.Pos.Y = Object[i].y  
	Object[i].Start.Pos.Z = Object[i].z 
	
	// objTyp
	Object[ObjId].Typ = OBjTyp
	
	
	
	// image 
	For k= 0 to Object[ObjId].stage.length
		Object[ObjId].stage[k].TextureId = -1
		Object[ObjId].stage[k].ImageId = -1
		Object[ObjId].stage[k].UVh = 1
		Object[ObjId].stage[k].UVw = 1
		Object[ObjId].stage[k].UVx = 0
		Object[ObjId].stage[k].UVy = 0
	next
	
	if objTyp <> C_OBJBANK
		if TextureID > -1 and TextureId <= texture.length
			Object[ObjId].stage[0].TextureId = TextureId
		endif
	endif
	
	
	Object[ObjId].Shader = -1 // ShaderId 
	
	if LoadDoc = 0
		Object[ObjId].Size = 1 * options.Asset.Size
	else
		Object[ObjId].Size = 1
	endif
	
	s = Object[ObjId].Size
	Object[ObjId].Sx = 1
	Object[ObjId].Sy = 1
	Object[ObjId].Sz = 1
	
	SetObjectScale2(i,0)

	
	SetObjectScreenCulling(Object[ObjId].Obj,1)
	// SetObjectLightMode(Object[ObjId].Obj,1)
 
	UpdateObjectCenterSprite(ObjId)
	
	if assetTyp <> C_ASSETOBJ
		Lag_FreeallGadgetItemByGadget(C_Gad_SelectList)
		Freeall = 1
	endif
	AssetTyp = C_ASSETOBJ
	
	if freeall = 1
		// recreate all gadgetitem for C_Gad_SelectList
		CreateAllGadgetItem()
	else
		Desc$ = Object[ObjId].name$
		LAG_AddGadgetItem(C_Gad_SelectList, objId, Desc$, Object[ObjId].Icon)
	endif


	Endif

endfunction

Function SetObjectDimension(w#,h#,p#)
	
	Object[ObjId].W = w# 
	Object[ObjId].H = h#
	Object[ObjId].L = p# 
	
endFunction






// object part syst
Function AddObjectPartSyst(x,y,z)
	
	s# = 1.6*10
	rand = 40
	speed = 300
	speedmin#= 1
	life = 55
	// test
	// AddPartSystem(typ,nb,img,x#,y#,z#,rand,speed#,speedmin#,life,color,size#)
	id = AddPartSystem(0,45,Particle[0].img,x,y,z,rand,speed,speedmin#,life,MakeColor(150,70,0),s#) // fire
	AddObjet(x,y,z,"")
	// set the parameters for the particle system
	n = Object[objId].Obj
	Object[oBjId].Typ = C_OBJPARTSYS
	Object[oBjId].IdObj3D = id
	Object[ObjId].Shadow = 0
	Object[ObjId].ShadowCast = 0
	Object[ObjId].ShadowRec = 0
	Object[ObjId].AO = 0
	
	Object[ObjId].R = 150
	Object[ObjId].G = 70
	Object[ObjId].B = 0
	Object[ObjId].size = s#
	Object[ObjId].sx = rand
	Object[ObjId].sy = rand
	Object[ObjId].sz = rand
	
	Object[ObjId].rx = speed
	Object[ObjId].ry = speedmin#
	Object[ObjId].rz = life
	
	
	
	SetObjectImage(n,iCube,0)
	SetObjectLightMode(n,0)
	SetObjectTransparency(n,1)
	SetObjectDepthRange(n,0,0)
	SetObjectVisible(n,0)
	
EndFunction id




// delete
Function DeleteTheObject(i)
	
	
	Delete3DPhysicsBody(object[i].obj)
	if Object[i].Animated
		DeleteObjectWithChildren(object[i].obj)
	else
		DeleteObject(object[i].obj)
		
	endif
	DeleteSprite(Object[i].spr)
	
	DeleteObject(object[i].ObjOutline)
	
	LAG_FreeGadgetItem(C_Gad_SelectList,i)
	
	IF Object[i].Typ = C_OBJPARTSYS
		DeletePartSystem(Object[i].IdObj3D)
	endif
	
	ObjID = -1
	GetObjProp()
	
	
endfunction

Function DeleteAsset()
	
	// delete assets
	select AssetTyp 
		
		case C_ASSETOBJ
			For i=0 to Object.length
				
				if Object[i].Selected
					if Object[i].Typ = C_OBJWATER
						dec NbWater
					endif
					DeleteTheObject(i)
					Object.remove(i)
					dec i
				endif
			next
			
		endcase
		
		case  C_ASSETLIGHT
			
		ok=0							
		For j=0 to light.length
			if light[j].selected
				DeleteObject(Light[j].Obj)
				Light.remove(j)	
				dec j
				ok = 1									
			endif
		next j
		
		if ok = 1
			// delete all pointlight
			ClearPointLights()
			
			// recreate all point light
			For i=0 to light.length
				u = Light[i].Intensity
				Light[i].id = i+1
				CreatePointLight(i+1,Light[i].x,Light[i].y,Light[i].z,Light[i].radius,Light[i].r*u,Light[i].g*u,Light[i].b*u)
				SetPointlightmode(i+1,1)								
			next
			
		endif
		
		endcase
		
		case C_ASSETCAMERA
			
			For i=0 to camera.length
				if camera[i].Selected
					DeleteObject(Camera[i].Obj)
					Camera.Remove(i)
					dec i
				endif
			next
			Lag_FreeallGadgetItemByGadget(C_Gad_SelectList)
			CreateAllGadgetItem()
			
		endcase
		
		
	endselect
	
	ObjId = -1	

Endfunction



// Select
Function SelectObject(deselect)
	
	// select or deselect all object, light...
	
	
	// select
	if deselect = 0
		
		Foldstart 
		
		For i=0 to Object.length
			if Object[i].Hide=0
				object[i].selected = 1
				SetObjectColorEmissive(object[i].obj, 255,0,0)
				Object[i].Start.Pos.X = Object[i].x  
				Object[i].Start.Pos.Y = Object[i].y  
				Object[i].Start.Pos.Z = Object[i].z 		
			endif
		next
		
		For i=0 to light.length
			
			if light[i].Hide=0
				light[i].selected = 1
				SetObjectColorEmissive(light[i].obj, 255,0,0)
				light[i].StartX = light[i].x  
				light[i].StartY = light[i].y  
				light[i].StartZ = light[i].z 	
			endif
			
		next 
		
		For i=0 to camera.length
			if Camera[i].Hide=0
				Camera[i].selected = 1
				SetObjectColorEmissive(Camera[i].obj, 255,0,0)
				Camera[i].StartX = Camera[i].x  
				Camera[i].StartY = Camera[i].y  
				Camera[i].StartZ = Camera[i].z 	
			endif
		next 
		
		Foldend
		
	elseif deselect = 1 // deselect all
		
		Foldstart 
		
		For i=0 to Object.length
			if Object[i].Hide=0
				object[i].selected =0
				SetObjectColorEmissive(object[i].obj,object[i].R,object[i].G,object[i].B)
			endif
		next
		
		For i=0 to light.length
			if light[i].Hide=0
				light[i].selected =0
				SetObjectColorEmissive(light[i].obj, light[i].r, light[i].g, light[i].b)
			endif
		next
	
		For i=0 to camera.length
			if Camera[i].Hide=0
				Camera[i].selected =0
				SetObjectColorEmissive(Camera[i].obj, 0,0,0)
			endif
		next 
	
		GetObjProp()
		
		foldend
		
	elseif deselect = -1 // select just one
		
		select AssetTyp 
			
			case C_ASSETOBJ
			
				i = ObjId
				object[i].selected = 1
				SetObjectColorEmissive(object[i].obj, 255,0,0)
				Object[i].Start.Pos.X = Object[i].x  
				Object[i].Start.Pos.Y = Object[i].y  
				Object[i].Start.Pos.Z = Object[i].z 		
				GetObjProp()
			
			endcase
			
			case C_ASSETLIGHT
				
				i = ObjId
				Light[i].selected = 1
				SetObjectColorEmissive(light[i].obj, 255,0,0)
				light[i].StartX = light[i].x  
				light[i].StartY = light[i].y  
				light[i].StartZ = light[i].z
				GetLightProp()
				
			endcase
			
			case C_ASSETCAMERA
				i = ObjId
				Camera[i].selected = 1
				SetObjectColorEmissive(Camera[i].obj, 255,0,0)
				Camera[i].StartX = Camera[i].x  
				Camera[i].StartY = Camera[i].y  
				Camera[i].StartZ = Camera[i].z
				GetObjCameraProp()
			endcase
			
		endselect
			
	endif
		
Endfunction




//Physic
Function SetPhysicToObject(i, auto)
	
	n = Object[i].Obj
	
	// on ajoute ou on change l'objet physique	
	if Get3DPhysicsTotalObjects() = 0
		NoPhysic = 1
	endif
	
	
	//message("physic : "+str( Object[i].Physic)+"|"+str(n))	
	
	if Object[i].Physic <> Object[i].OldPhysic or auto = 1
		Object[i].OldPhysic =  Object[i].Physic
		
		Select Object[i].Physic
			
			case 0	// no physic
				Delete3DPhysicsBody(n)
			endcase
			
			case 1	// static
				//Message("Set static physic to object")
				Create3DPhysicsStaticBody(n)
				inc nophysic				
				//message("ok1_2 1")				
			endcase
			
			case 2  // dynamic
				//message("ok1_1 2")	
				Create3DPhysicsDynamicBody(n)
				inc nophysic				
				//message("ok1_2 2")				
			endcase
			
			case 3 // kinematic
				//message("ok1_1 3")	
				Create3DPhysicsKinematicBody(n)
				inc nophysic				
				//message("ok1_2 3")				
			endcase
			
			case 4 // character
				//Message("ok character ")
				characterOffsetVec = CreateVector3( 0.0, 0, 0.0 )
				objectOrientationVec = CreateVector3( 0.0, 0.0, 0.0 )
				Create3DPhysicsCharacterController( n, 1, characterOffsetVec, objectOrientationVec, 0.75 )
				DeleteVector3( characterOffsetVec)
				DeleteVector3( objectOrientationVec)				
				Debug3DPhysicsCharacterController(n,1)				
			endcase
			
		endselect
		//message("ok2")	
		if Object[i].Typ > C_OBJPLANE
			//SetObjectShapebox(n)		
		endif
		
		//message("ok3 / "+str(Object[i].Shape))
			
		select Object[i].Shape
			case 1
				// SetObjectShapebox(n)
			endcase
			case 2
				// SetObjectShapesphere(n)
			endcase            
		endselect
	
	endif
	
	//message("ok4")	
	
	
	if NoPhysic = 2
		if Options.physicOn =0
			Options.physicOn = 1
			//message("physic "+str(Options.physicOn)+"/"+str(nophysic))
			// Create3DPhysicsWorld()
		endif			
	endif
	//message("ok5")
		
	/*
	if Object[i].Physic = 0 and Object[i].OldPhysic <> 0		
		// on supprime l'objet physic
		if Get3DPhysicsTotalObjects() = 0
			Delete3DPhysicsWorld()
			Options.physicOn = 0			
		endif	
		Object[i].OldPhysic = 0 
		Delete3DPhysicsBody(n)
	endif
	*/
	
EndFunction





// set
Function SetObjProp(mode)
	
	// mode (voir les constant C_SETOBJPROP_...)
	// old = 0 : position, 1 = rot, 2 =scale, 3 =uv, 4 = prop(hide, locked, shadow...)
	
	// to change the properties of an object
	if ObjId >-1 and ObjId <= Object.length
		
		Object[ObjId].Locked = LAG_GetGadgetState(C_Gad_Lock)
		
		if Object[ObjId].Locked = 0
			
			n = Object[objId].Obj
			
			Select mode 
				
				case C_SETOBJPROP_STAGEImg // set stage
				
					StId = Val(LAG_GetGadgetText(C_Gad_SetStage))				
					
					if StId < 0
						StId = 0					
					endif
					if StId >7
						StId = 7					
					endif
					
					LAG_SetGadgetText(C_Gad_SetStage, str(StId))
					Object[ObjId].StageId = StId
					
					GetObjProp()
					
				endcase
				
				case C_SETOBJPROP_UV // UV, image, sahder...
				
					if Object[ObjId].Typ <> C_OBJPARTSYS
											
						Object[ObjId].StageId = Val(LAG_GetGadgetText(C_Gad_SetStage))
						StId = Object[ObjId].StageId
						
						Object[ObjId].stage[StId].UVx = ValFloat(LAG_GetGadgetText(C_Gad_uvx))
						Object[ObjId].stage[StId].UVy = ValFloat(LAG_GetGadgetText(C_Gad_uvy))
						
						Object[ObjId].stage[StId].UVw = ValFloat(LAG_GetGadgetText(C_Gad_uvw))
						Object[ObjId].stage[StId].UVh = ValFloat(LAG_GetGadgetText(C_Gad_uvh))
						
						Object[ObjId].Shader = Val(LAG_GetGadgetText(C_Gad_SetShader))
						if Object[ObjId].shader > ShaderBank.length
							Object[ObjId].shader = ShaderBank.length
							LAG_setGadgetText(C_Gad_SetShader, str(Object[ObjId].shader))
						endif
						
						
						// Object[ObjId].stage[StId].ImageId = val(LAG_GetGadgetText(C_Gad_ObjImg))
						
						
						TextureID = Object[ObjId].stage[StId].TextureId
						ImgId = Object[ObjId].stage[StId].ImageId
						
						if imgID = 0
							if TextureId > -1 and TextureId <= Texture.length		
								//LAG_SetGadgetState(C_Gad_BankImg,Texture[textureId].img)
								ImgId = Texture[textureId].img
							endif
						endif
						//else
						//if ImgId > 0
							LAG_SetGadgetState(C_Gad_BankImg,ImgId)	
						//endif
						
						if Object[ObjId].Shader <=-1
							SetObjectShader(n, 0)
						elseif Object[ObjId].Shader <= ShaderBank.length
							SetObjectShader(n, ShaderBank[Object[ObjId].Shader].Shader)
							// Shader[Object[ObjId].Shader].Used = 1
						endif
						
						SetObjectUVOffset(n,Object[ObjId].StageId,Object[ObjId].stage[StId].UVx,Object[ObjId].stage[StId].UVy)
						SetObjectUVScale(n,Object[ObjId].StageId,Object[ObjId].stage[StId].UVw,Object[ObjId].stage[StId].UVh)
					else
						bm = Val(LAG_GetGadgetText(C_Gad_SetShader))
						SetPartSystemImg(object[ObjId].IdObj3D,-1,bm)
						Object[ObjId].Shader = bm
					endif
				
				endcase
				
				case C_SETOBJPROP_COL // colors
					
					Object[ObjId].alpha = val(LAG_GetGadgetText(C_Gad_Alpha))
					// Object[objId].tra = LAG_GetGadgetText(C_Gad_Tra))
					Object[ObjId].R = LAG_GetGadgetState(C_Gad_R)
					Object[ObjId].G = LAG_GetGadgetState(C_Gad_G)
					Object[ObjId].B = LAG_GetGadgetState(C_Gad_B)
					// Object[ObjId].BM = LAG_GetGadgetState(C_Gad_BM)
					
					//Object[ObjId].BM1 = val(LAG_GetGadgettext(C_Gad_BM))
					//Object[ObjId].BM1 = val(LAG_GetGadgettext(C_Gad_BM))
					
					
					if Object[ObjId].Typ <> C_OBJPARTSYS
						
						SetObjectColorEmissive(n,Object[ObjId].R+255,Object[ObjId].G,Object[ObjId].B)
						
						if Object[ObjId].BM = 0
							
							//if Object[ObjId].alpha <255
								SetObjectTransparency(Object[objId].Obj, Object[objId].tra)
							//else
								//SetObjectTransparency(Object[objId].Obj,0)
							//endif
						
						else
							
							Select Object[ObjId].BM
								case 0 // normal
									SetObjectBlendModes(Object[objId].Obj, 0, 1)
									SetObjectTransparency(Object[objId].Obj, Object[objId].tra)
								endcase
								case 1 // add
									SetObjectBlendModes(Object[objId].Obj, 1, 1)
									SetObjectTransparency(Object[objId].Obj, 3)
								endcase
								case 2 // mult
									SetObjectBlendModes(Object[objId].Obj, 2,3)
									SetObjectTransparency(Object[objId].Obj, 3)
								endcase
								case 3 // sub
									// lock alpha
									SetObjectBlendModes(Object[objId].Obj, 4,5)
									SetObjectTransparency(Object[objId].Obj, 3)
								endcase
								case 4									
									SetObjectBlendModes(Object[objId].Obj, 5,5)
									SetObjectTransparency(Object[objId].Obj, 3)
								endcase
							endselect
						
						endif
						SetObjectColor(n,255,255,255,Object[ObjId].alpha)
						
					else // part system
						id = Object[ObjId].IdObj3D
						SetPartSystemColor(id,Object[ObjId].r,Object[ObjId].g,Object[ObjId].b,Object[ObjId].alpha)
					endif
					
				endcase
					
				case C_SETOBJPROP_GEN
				
					
					Object[ObjId].Hide = LAG_GetGadgetState(C_Gad_Hide)
					SetObjectVisible2(ObjId)
					
					
					Object[ObjId].Shadow = LAG_GetGadgetState(C_Gad_Shado)
					
					Object[ObjId].visibleInGame = LAG_GetGadgetState(C_Gad_ObjVisible)
					
					
					shadowCast = LAG_GetGadgetState(C_Gad_ShadoCAst)
					shadowrec = LAG_GetGadgetState(C_Gad_ShadoREC)
					Object[ObjId].ShadowCast = shadowCast
					Object[ObjId].ShadowRec = shadowrec
					SetObjectCastShadow(n, shadowcast)
					SetObjectReceiveShadow(n, shadowRec)
					
					// fog, light
					Object[ObjId].Fogmode = LAG_GetGadgetState(C_Gad_ObjFog)
					SetObjectFogMode(n, Object[ObjId].Fogmode )
					Object[ObjId].lightmode = LAG_GetGadgetState(C_Gad_ObjLight)
					SetObjectLightMode(n, Object[ObjId].lightmode )



					// type, subtype
					Object[ObjId].Param[0] = LAG_GetGadgetText(C_Gad_Param1)
					Object[ObjId].Param[1] = LAG_GetGadgetTExt(C_Gad_Param2)
					
					
					
					
					Object[ObjId].Name$ = LAG_GetGadgetText(C_Gad_NameObj)
					
					//size
					Object[ObjId].Size = valFloat(LAG_GetGadgetText(C_Gad_Size))
					Object[ObjId].sx = ValFloat(LAG_GetGadgetText(C_Gad_SX))
					Object[ObjId].sy = ValFloat(LAG_GetGadgetText(C_Gad_SY))
					Object[ObjId].sz = ValFloat(LAG_GetGadgetText(C_Gad_SZ))
					
					sx# = Object[ObjId].sx
					sy# = Object[ObjId].sz
					sz# = Object[ObjId].sz
					s# = Object[ObjId].Size
					
					
					//rotation
					Object[ObjId].Rx = ValFloat(LAG_GetGadgetText(C_Gad_Rx))
					Object[ObjId].Ry = ValFloat(LAG_GetGadgetText(C_Gad_Ry))
					Object[ObjId].Rz = ValFloat(LAG_GetGadgetText(C_Gad_RZ))
					
					// position
					Object[ObjId].X = ValFloat(LAG_GetGadgetText(C_Gad_X))
					Object[ObjId].Y = ValFloat(LAG_GetGadgetText(C_Gad_Y))
					Object[ObjId].Z = ValFloat(LAG_GetGadgetText(C_Gad_Z))
						
						
					If 	Object[ObjId].Typ = C_OBJWATER
						GWaterHeight# = Object[ObjId].Y
					endif	
						
					if Object[ObjId].Typ = C_OBJPARTSYS
						id = Object[ObjId].IdObj3D
						sx = Object[ObjId].sx
						sy = Object[ObjId].sy
						sz = Object[ObjId].sz
						speed# = Object[ObjId].Rx
						speedmin# = Object[ObjId].Ry
						life = Object[ObjId].Rz
						SetPartSystemParam(id,sx,sy,sz,-1,Object[ObjId].Size,speed#,speedmin#,life)
					else
						
						
						if object[objId].animated = 0
							SetObjectScale2(ObjId, 0)
						else
							if sx# <> 0 and sy# <> 0 and sz# <> 0 and s# <> 0
								if sx# <> Object[ObjId].sx or sy# <> Object[ObjId].sy or sz# <> Object[ObjId].sz or s# <> Object[ObjId].size
									SetObjectScale2(ObjId, 0)
								endif
							endif
						endif
							
						SetObjectRotation(n, Object[ObjId].rx, Object[ObjId].ry, Object[ObjId].rz)
					endif
					
					MoveObject(objId, Object[ObjId].x, Object[ObjId].y, Object[ObjId].z)
				
				endcase
			
			endselect 
			
		endif
	endif
	
EndFunction

Function SetObjectLock()
	
	if objID > -1 and objId <= object.length
	
		Object[ObjId].Lock.Pos.x = LAG_GetGadgetState(C_Gad_lock_X)
		Object[ObjId].Lock.Pos.y = LAG_GetGadgetState(C_Gad_lock_y)
		Object[ObjId].Lock.Pos.z = LAG_GetGadgetState(C_Gad_lock_z)
		
		Object[ObjId].Lock.Rot.x = LAG_GetGadgetState(C_Gad_lock_RX)
		Object[ObjId].Lock.Rot.y = LAG_GetGadgetState(C_Gad_lock_Ry)
		Object[ObjId].Lock.Rot.z = LAG_GetGadgetState(C_Gad_lock_Rz)
		
		Object[ObjId].Lock.Siz.x = LAG_GetGadgetState(C_Gad_lock_sx)
		Object[ObjId].Lock.Siz.y = LAG_GetGadgetState(C_Gad_lock_sy)
		Object[ObjId].Lock.Siz.z = LAG_GetGadgetState(C_Gad_lock_sz)
	
	endif
	
endFunction

Function SetObjectVisible2(i)
	
	SetObjectVisible(Object[i].Obj,1-Object[i].Hide)
	SetObjectVisible(Object[i].ObjOutline,1-Object[i].Hide)
	
	// center
	SetSpriteVisible(Object[i].spr, Options.ShowCenter)

endfunction

Function SetObjectMesh()
	
	// to change a mesh of an entity
	
	For i=0 to object.length
		
		
		if ObjTyp = C_OBJBANK
			
			Foldstart 
			
				if BankModel.Length >-1
			
					BankId = Options.BankModelId
					
					if bankId >-1 and BankId <= BankModel.length
					
						if GetObjectExists(BankModel[BankId].id)
						
						DeleteObject(Object[i].Obj)
						
						FoldStart 
						
						Object[i].Animated = BankModel[BankId].Animated
						if Object[i].Animated = 0
							Object[i].obj = CloneObject(BankModel[BankId].id)
						else
							Object[i].obj = InstanceObject(BankModel[BankId].id)
						endif
						
						Object[i].IdObj3D = BankId
						
						n = Object[i].obj
						ObjId = i
										
						// SetObjectDefault(x#,y#,z#)
						// Object[i].name$ = Options.BankModeName$+str(i)
						Object[i].Shader = BankModel[BankId].Shader
						
						if bankModel[BankId].Animated >=1						
							//PlayObjectAnimation(n,"",0,-1,0,0)
							//SetObjectAnimationSpeed( n, bankModel[BankId].AnimSpeed)
						endif

						length = BankModel[BankId].Img.length
						For k = 0 to length
							Object[i].stage[k].TextureId = BankModel[BankId].Img[k].TextureId
							Object[i].stage[k].ImageId = BankModel[BankId].Img[k].img
							Object[i].stage[k].UVw = BankModel[BankId].Img[k].scaleW
							Object[i].stage[k].UVh = BankModel[BankId].Img[k].scaleH
							Object[i].stage[k].UVx = BankModel[BankId].Img[k].OffsetX
							Object[i].stage[k].UVy = BankModel[BankId].Img[k].OffsetY
						next
						
						
						
						UpdateObject(i)
						
						foldend
						
						endif
						
					endif
					
				endif
				
			foldend
				
		else
			if ObjTyp <> C_OBJPARTSYS
			
				DeleteObject(Object[i].Obj)
						
				Object[i].IdObj3D = -1
		
				a = Options.Asset.W * Options.Asset.Size
				b = Options.Asset.H * Options.Asset.Size
				c = Options.Asset.L * Options.Asset.Size
			
				w# = a
				h# = b
				p# = c
				
				select ObjTyp
					
					case C_OBJBOX
						
						Object[i].Obj = CreateObjectBox(a,b,c)
						
					endcase
					
					case C_OBJSPHERE
						
						Object[i].Obj = CreateObjectSphere(a,b,c)
						
					endcase
					
					case C_OBJCAPSULE
						
						Object[i].Obj = CreateObjectCapsule(a,b,c)
						
					endcase
					
					case C_OBJCONE
						
						Object[i].Obj = CreateObjectCone(a,b,c)
						
					endcase
					
					case C_OBJCYLINDER
						
						Object[i].Obj = CreateObjectCylinder(a,b,c)
						
					endcase
					
					case C_OBJPLANE	
									
						Object[i].Obj = CreateObjectPlane(a,b)
						
					endcase
					
				
				endselect
				
				SetObjectDimension(w#, h#, p#)
				UpdateObject(i)
			
			endif
			
		endif
		
	next 
		
		
	
EndFunction

Function SetObjectImage2(image, ok)
	
	// set some object image properties
	
	j = objId
	
	if j>-1 and j<= object.length
			
		stId = Object[j].StageId
		n = Object[j].Obj
		
		SetObjectColorEmissive(Object[j].Obj,0,0,0)
		
		if assettyp = C_ASSETMESH
		
		
			if image = 0 // delete stage image
					
				// Object[j].stage[StId].TextureId = -1
				SetObjectMeshImage(n,  meshid, -1, stid)	
				// Object[j].stage[StId].ImageId = -1
				
			elseif image =-1 // normal
				 
				if ok = 1
					SetObjectMeshNormalMap(n, meshid, Object[j].stage[2].ImageId)
				else
					SetObjectMeshNormalMap(n,  meshid, -1)
				endif
				
			elseif image =-2 // lightmap
				if ok = 1
					SetObjectMeshlightMap(n,  meshid, Object[j].stage[1].ImageId)
				else
					SetObjectMeshlightMap(n,  meshid, -1)
				endif
			endif
			
		elseif assettyp = C_ASSETOBJ
		
			
			if image = 0 // delete stage image
					
				Object[j].stage[StId].TextureId = -1
				SetObjectImage(n, -1, stid)	
				Object[j].stage[StId].ImageId = -1
				
			elseif image =-1 // normal
				 
				if ok = 1
					SetObjectNormalMap(n, Object[j].stage[2].ImageId)
				else
					SetObjectNormalMap(n, -1)
				endif
				
			elseif image =-2 // lightmap
				if ok = 1
					SetObjectlightMap(n, Object[j].stage[1].ImageId)
				else
					SetObjectlightMap(n, -1)
				endif
			endif
			
		endif
		
	endif
	
	
	
Endfunction

Function SetObjectScale2(i, a#)
	
	
	n = Object[i].Obj
	
	local s# 
	local ux as float 
	local uy as float 
	local uz as float 
	
	s1# =  Object[i].Size
	s# =  Object[i].Size + a#
	
	lockxyz = Options.LockSX + Options.LockSY + Options.LockSZ 
	
	if lockxyz = 0 
				
		s# = Object[i].Size	+ a#
		ux = Object[i].sx
		uy = Object[i].sy
		uz = Object[i].sz
		
	else
		
		s# = Object[i].Size											
		ux = (a#*(1-Options.LockSX) + Object[i].sx)
		uy = (a#*(1-Options.LockSY) + Object[i].sy)
		uz = (a#*(1-Options.LockSZ) + Object[i].sz)	
		
	endif
	
	
	
	if Object[i].Animated = 0
			
		SetObjectScale(n, ux*s#, uy*s#, uz*s#)
		UpdateScaleOutline(i,ux, uy, uz, s#)
	else
		
		//if s1# <> 0
			
			//SetObjectScalePermanent(n, 1.0/(Object[i].sx * s1#), 1.0/(Object[i].sy * s1#), 1.0/(Object[i].sz * s1#))
		if a# = 0
			
			// AR !!! 
			
			SetObjectScalePermanent(n, Object[i].sx*s#, Object[i].sy*s#, Object[i].sz*s#)
			Updateoutline(i,1,1,0)
		else
			if a#>0
				c# = 1.01
			elseif a# <0
				c# = 0.99
			endif
			
			SetObjectScalePermanent(n, c#, c#, c#)
			Updateoutline(i,1,1,0)
		endif
		
		//endif
		
		
		Print("objet animé, scale permanent")

		/*
		if a# <> 0
			SetObjectScalePermanent(n, 1+a#, 1+a#, 1+a#)
		else
			SetObjectScalePermanent(n, Object[i].sx*s#, Object[i].sy*s#, Object[i].sz*s#)
			Print("objet animé, scale permanent")
		endif
		*/
		
		
	endif
	
	
	Object[i].Start.Siz.X = ux
	Object[i].Start.Siz.Y = uy
	Object[i].Start.Siz.Z = uz
	Object[i].StartS = s#
	
	
	
Endfunction



	
	
// Get 	
Function GetObjProp()
	
	// change the gadget value with the selected object value
	
	if ObjId >-1
		
		Select AssetTyp 
			
			case C_ASSETOBJ
				
				if ObjId <= Object.length
					
					LAG_SetGadgetName(C_Gad_Tra, "Tra")

					// name
					LAG_SetGadgetText(C_Gad_NameObj, Object[ObjId].name$)
					
					// UV  & Stage
					StId = Object[ObjId].StageId // doit être en premier ! 
					LAG_setGadgetText(C_Gad_SetStage, str(Object[ObjId].StageId))

					
					LAG_SetGadgetText(C_Gad_uvx, str(Object[ObjId].stage[StId].UVx,3))
					LAG_SetGadgetText(C_Gad_uvy, str(Object[ObjId].stage[StId].UVy,3))
					LAG_SetGadgetText(C_Gad_uvw, str(Object[ObjId].stage[StId].UVw))
					LAG_SetGadgetText(C_Gad_uvh, str(Object[ObjId].stage[StId].UVh))
					
					
					// texture stage
					if options.UpdateStagelist = 0
						UpdateGadTextureStage()
					endif
					
					// light, fog, visible...
					LAG_SetGadgetstate(C_Gad_ObjFog, Object[ObjId].fogmode)
					LAG_SetGadgetstate(C_Gad_ObjLight, Object[ObjId].lightmode)
					LAG_SetGadgetstate(C_Gad_ObjVisible, Object[ObjId].visibleInGame)
					
					
					// shader
					LAG_SetGadgetText(C_Gad_SetShader, str(Object[ObjId].Shader))
					
					// position
					LAG_SetGadgetText(C_Gad_X, str(Object[ObjId].x,5))
					LAG_SetGadgetText(C_Gad_Y, str(Object[ObjId].Y,5))
					LAG_SetGadgetText(C_Gad_Z, str(Object[ObjId].Z,5))
					
					//rotation
					LAG_SetGadgetText(C_Gad_rx, str(Object[ObjId].rx,3))
					LAG_SetGadgetText(C_Gad_ry, str(Object[ObjId].ry,3))
					LAG_SetGadgetText(C_Gad_rZ, str(Object[ObjId].rZ,3))
					
					// size
					LAG_SetGadgetText(C_Gad_sx, str(Object[ObjId].sx,3))
					LAG_SetGadgetText(C_Gad_sy, str(Object[ObjId].sy,3))
					LAG_SetGadgetText(C_Gad_sZ, str(Object[ObjId].sZ,3))
					
					LAG_SetGadgetText(C_Gad_Size, str(Object[ObjId].size,4))
					
					
					// lock
					LAG_SetGadgetState(C_Gad_lock_X, Object[ObjId].Lock.Pos.x)
					LAG_SetGadgetState(C_Gad_lock_y, Object[ObjId].Lock.Pos.y)
					LAG_SetGadgetState(C_Gad_lock_z, Object[ObjId].Lock.Pos.z)
					
					LAG_SetGadgetState(C_Gad_lock_RX, Object[ObjId].Lock.Rot.x)
					LAG_SetGadgetState(C_Gad_lock_Ry, Object[ObjId].Lock.Rot.y)
					LAG_SetGadgetState(C_Gad_lock_Rz, Object[ObjId].Lock.Rot.z)
					
					
					LAG_SetGadgetState(C_Gad_lock_SX, Object[ObjId].Lock.siz.x)
					LAG_SetGadgetState(C_Gad_lock_Sy, Object[ObjId].Lock.siz.y)
					LAG_SetGadgetState(C_Gad_lock_Sz, Object[ObjId].Lock.siz.z)
				
					
					// Color
					LAG_SetGadgetText(C_Gad_Alpha, str(Object[ObjId].Alpha,0))
					bm$ = "Opaque,Transp,Custom,"
					LAG_SetGadgetText(C_Gad_Tra, GetStringToken(bm$, ",", Object[ObjId].tra+1))
					
					bm$ = "Normal,add,mult,sub,other"
					LAg_SetGadgetText(C_Gad_BM, GetStringToken(bm$, ",", Object[ObjId].BM+1))
					
					LAG_SetGadgetState(C_Gad_R, Object[ObjId].R)
					LAG_SetGadgetState(C_Gad_G, Object[ObjId].G)
					LAG_SetGadgetState(C_Gad_B, Object[ObjId].B)
					
					// editor
					LAG_SetGadgetState(C_Gad_Hide, Object[ObjId].Hide)
					LAG_SetGadgetState(C_Gad_Lock, Object[ObjId].Locked)
					
					// type
					typ$ = GetStringToken( GetObjTypFromFile(""), ",", Object[ObjId].ObjTyp+1)
					LAG_SetGadgetText(C_Gad_Type, typ$)
					
					subtyp$ = GetObjTypFromFile(typ$)
					LAG_SetGadgetText(C_Gad_subtype, GetStringToken(subtyp$, ",", Object[ObjId].subtyp+1))
					
					
					
					LAG_SetGadgetText(C_Gad_Param1, Object[ObjId].param[0])
					LAG_SetGadgetTExt(C_Gad_Param2, Object[ObjId].param[1])
				
					// anim
					if Object[ObjId].Animated >=1
						LAG_SetGadgetState(C_Gad_PlayAnim, Object[ObjId].Animated)
						LAG_SetGadgetTExt(C_Gad_AnimSpeed, str(Object[ObjId].Anim.Speed,3))
						LAG_SetGadgetTExt(C_Gad_AnimStart, str(Object[ObjId].Anim.FrameSt,3))
						LAG_SetGadgetTExt(C_Gad_AnimEnd, str(Object[ObjId].Anim.FrameEnd,3))
					endif
				
					// shadow
					LAG_SetGadgetState(C_Gad_Shado, Object[ObjId].Shadow)
					LAG_SetGadgetState(C_Gad_ShadoCAst, Object[ObjId].ShadowCast)
					LAG_SetGadgetState(C_Gad_ShadoRec, Object[ObjId].ShadowRec)
					
					// physic					
					Txt$ ="No Physic/Static/Dynamic/Kinematic/Character"
					LAG_SetGadgetText(C_Gad_Physic, GetStringToken(Txt$,"/",Object[ObjId].Physic+1))
					
					// images
					if Object[objId].Typ = C_OBJPARTSYS
					
					else
						/*
						TextureID = Object[ObjId].Image[Object[ObjId].StageId]
						if textureId > -1 and textureId <= 	Texture.length			
							LAG_SetGadgetState(C_Gad_BankImg,Texture[textureId].img)
						endif
						*/
						img = Object[ObjId].stage[StId].ImageID
						
						if img > 0
							LAG_SetGadgetState(C_Gad_BankImg, img)
							
							id = Object[ObjId].stage[StId].TextureId
							if id >=0 and id <= texture.length								
								//TextureId = Id
							endif
						else
							id = Object[ObjId].stage[StId].TextureId
							if id >=0 and id <= texture.length
								img = Texture[id].img
								//TextureId = Id
								Object[ObjId].stage[StId].ImageID = img
								LAG_SetGadgetState(C_Gad_BankImg, img)
								// LAG_setGadgetText(C_Gad_ObjImg, str(img))
							endif
						endif
					endif
					
				endif
			endcase
			
			case C_ASSETLIGHT 
				
				if objid <= light.length
					
					GetLightProp()

				endif 
				
			endcase
			
		endselect
		
		SetAssetGadget()
		
	else
		
		FoldStart // no object selected , reset
		

			ResetGadget()
		
		
		Foldend
			
	endif
	
EndFunction

Function GetAssetPos(moveobj)
	
	
	
	select AssetTyp 
											
		case C_ASSETLIGHT	
			
			objX = light[moveobj].x
			objy = light[moveobj].y
			objz = light[moveobj].z	
			
		endcase
		
		case C_ASSETOBJ
			
			objX = Object[moveobj].x
			objy = Object[moveobj].y
			objz = Object[moveobj].z
			
		endcase
		
		case C_ASSETCAMERA
			
			objX = camera[moveobj].x
			objy = camera[moveobj].y
			objz = camera[moveobj].z
			
		endcase	
	endselect
	
	
endfunction


Function GetObjectWidth(i)
	
	n = object[i].Obj
	//sx = - GetObjectSizeMinX(n)
	if GetObjectSizeMinX(n)<0
		sx = GetObjectSizeMinX(n)
	endif
	object[i].pivot.x = sx
	w# = GetObjectSizeMaxX(n) - sx
	
Endfunction w#

Function GetObjectHeight(i)
	
	n = object[i].Obj
	//sy = - GetObjectSizeMinY(n)
	if GetObjectSizeMinY(n)<0
		sy = GetObjectSizeMinY(n)
	endif
	object[i].pivot.y = sy
	h# = GetObjectSizeMaxY(n) - sy 
	
Endfunction h#

Function GetObjectLength(i)
	
	n = object[i].Obj
	sz =  - GetObjectSizeMinZ(n)
	if GetObjectSizeMinZ(n)<0
		sz = GetObjectSizeMinZ(n)
	endif
	object[i].pivot.z = sz
	l# = GetObjectSizeMaxZ(n) - sz
	
Endfunction l#


Function GetObjTypFromFile(index1$)
	
	file0$ = "objectproperties.txt"
	// open the file for the asset type (object, action, fx, npc, mob...) and subtype
	if GetFileExists(file0$)
		
		f= OpenToRead(file0$)
		
		if f<> 0
			
			while FileEOF(f)= 0
				
				line$ = ReadLine(f)
				line$ = replacestring(line$," =","=",1)
				line$ = replacestring(line$,"= ","=",1)
				
				index$ = lower(GetStringToken(line$, "=", 1))
				
				if index1$ = ""
					if index$ ="objecttyp"
						txt$ = GetStringToken(line$, "=", 2)
						exit
					endif
				else
					if index$ = index1$
						txt$ = GetStringToken(line$, "=", 2)
						exit
					endif
				endif
					
			
			endwhile
			
			
			
			CloseFile(f)
		endif
		
	endif
	
	
endFunction txt$






//Gadget object
Function ResetGadget()
	
	// the reset the text and state of propertie gadget
	LAG_setGadgetText(C_Gad_SetStage, "")

	LAG_SetGadgetText(C_Gad_uvx, "")
	LAG_SetGadgetText(C_Gad_uvy, "")
	LAG_SetGadgetText(C_Gad_uvw, "")
	LAG_SetGadgetText(C_Gad_uvh, "")
	
	LAG_SetGadgetText(C_Gad_SetShader, "")
	
	LAG_SetGadgetText(C_Gad_X, "")
	LAG_SetGadgetText(C_Gad_Y, "")
	LAG_SetGadgetText(C_Gad_Z, "")
	
	LAG_SetGadgetText(C_Gad_NameObj, "")
	
	// LAG_SetGadgetText(C_Gad_Physic, "")
	
	LAG_SetGadgetText(C_Gad_sx, "")
	LAG_SetGadgetText(C_Gad_sy, "")
	LAG_SetGadgetText(C_Gad_sZ, "")
	
	LAG_SetGadgetText(C_Gad_rx, "")
	LAG_SetGadgetText(C_Gad_ry, "")
	LAG_SetGadgetText(C_Gad_rZ, "")
	
	LAG_SetGadgetText(C_Gad_Size, "")
	LAG_SetGadgetText(C_Gad_Tra, "")
	LAG_SetGadgetText(C_Gad_Alpha, "")
	LAG_SetGadgetText(C_Gad_BM, "")
	
	LAG_SetGadgetState(C_Gad_R, 0)
	LAG_SetGadgetState(C_Gad_G, 0)
	LAG_SetGadgetState(C_Gad_B, 0)
	
	Lag_FreeallGadgetItemByGadget(C_Gad_ListStage)
	
	// editor
	LAG_SetGadgetState(C_Gad_Hide, 0)
	LAG_SetGadgetState(C_Gad_Lock, 0)
	LAG_SetGadgetState(C_Gad_ObjFog, 0)
	LAG_SetGadgetState(C_Gad_ObjLight, 0)
	LAG_SetGadgetState(C_Gad_ObjVisible, 0)
	
	// shado
	LAG_SetGadgetState(C_Gad_Shado, 0)
	LAG_SetGadgetState(C_Gad_ShadoCAst, 0)
	LAG_SetGadgetState(C_Gad_ShadoRec, 0)
	
	// type
	LAG_SetGadgetState(C_Gad_Type, 0)
	LAG_SetGadgetState(C_Gad_SubType, 0)
	LAG_SetGadgetText(C_Gad_Param1, "")
	LAG_SetGadgetText(C_Gad_Param2, "")
	
	
	// anim
	LAG_SetGadgetState(C_Gad_PlayAnim, 0)
	LAG_SetGadgetText(C_Gad_AnimEnd, "")
	LAG_SetGadgetText(C_Gad_AnimSpeed, "")
	LAG_SetGadgetText(C_Gad_AnimStart, "")
	
	
	
	
Endfunction

Function SetAssetGadget()

	// to change the panel "properties"
	
	//message(str(objID))
	
	// if ObjId >-1
	
	
		FoldStart // Hide some gadgets
		
		
		if PanelL_Id = 2
			SetAssetGadgetVisible(0)
		endif
		
		LAG_SetGadgetName(C_Gad_sx,"Sx ") 
		LAG_SetGadgetName(C_Gad_sy,"Sy ")
		LAG_SetGadgetName(C_Gad_Size,"Siz ") 			
		LAG_SetGadgetName(C_Gad_Sz,"Sz ")
		LAg_SetGadgetTooltip(C_Gad_Sz,"")   			
		Foldend
	
	
	
		// then reveale the gadget necessary by assetTyp
		
		Select AssetTyp 
			
			case C_ASSETOBJ
				
				//if  ObjId <= Object.length
					
					if PanelL_Id = 2						
						SetAssetGadgetVisible(1)
						if objid>-1 and objid <= object.length
							if Object[objId].Animated = 0
								k = 0
								LAG_SetGadgetVisible(C_Gad_PlayAnim, k)
								LAG_SetGadgetVisible(C_Gad_AnimEnd, k)
								LAG_SetGadgetVisible(C_Gad_AnimSpeed, k)
								LAG_SetGadgetVisible(C_Gad_AnimStart, k)							
							endif
						else
							k = 0
							LAG_SetGadgetVisible(C_Gad_PlayAnim, k)
							LAG_SetGadgetVisible(C_Gad_AnimEnd, k)
							LAG_SetGadgetVisible(C_Gad_AnimSpeed, k)
							LAG_SetGadgetVisible(C_Gad_AnimStart, k)	
						endif
					endif
					
				//endif
				
			endcase
			
			case C_ASSETLIGHT 
				
				if objid <= light.length
					
					

				endif 
				
			endcase
			
			case C_ASSETCAMERA
				
				if objid <= camera.length
					
					LAG_SetGadgetName(C_Gad_Size,"Fov ") 
					LAG_SetGadgetName(C_Gad_sx,"Near ") 
					LAG_SetGadgetName(C_Gad_sy,"Far ")
					LAG_SetGadgetName(C_Gad_sz,"W")
					LAg_SetGadgetTooltip(C_Gad_Sz,"Set orthoWidth for camera.")  
					if PanelL_Id = 2	
						LAG_SetGadgetVisible(C_Gad_Size, 1)
						LAG_SetGadgetVisible(C_Gad_sx, 1)
						LAG_SetGadgetVisible(C_Gad_sy, 1)
						LAG_SetGadgetVisible(C_Gad_sz, 1)
						LAG_SetGadgetVisible(C_Gad_rx, 1)
						LAG_SetGadgetVisible(C_Gad_ry, 1)
						LAG_SetGadgetVisible(C_Gad_rz, 1)
						LAG_SetGadgetVisible(C_Gad_lock_RX, 1)
						LAG_SetGadgetVisible(C_Gad_lock_Ry, 1)
						LAG_SetGadgetVisible(C_Gad_lock_Rz, 1)
					endif
				endif 
				
			endcase
			
		endselect
	
	
	//endif


endfunction

Function SetAssetGadgetVisible(visible)
	
	// to change gadget visibility by asset type
	/* 
		LAG_SetGadgetName(C_Gad_Tra, "Tra")
		
		StId = Object[ObjId].StageId
		LAG_setGadgetText(C_Gad_SetStage, str(Object[ObjId].StageId))
		
		

		LAG_SetGadgetText(C_Gad_uvx, str(Object[ObjId].stage[StId].UVx,3))
		LAG_SetGadgetText(C_Gad_uvy, str(Object[ObjId].stage[StId].UVy,3))
		LAG_SetGadgetText(C_Gad_uvw, str(Object[ObjId].stage[StId].UVw))
		LAG_SetGadgetText(C_Gad_uvh, str(Object[ObjId].stage[StId].UVh))
		
		//Txt$ = "No Physic/Static/Dynamic/Kinematic/Character"
		// LAG_SetGadgetText(C_Gad_Physic, GetStringToken(Txt$,"/",Object[ObjId].Physic+1))

		*/
		// Animation
		/*
		LAG_SetGadgetState(C_Gad_PlayAnim, 0)
		LAG_SetGadgetText(C_Gad_AnimEnd, "")
		LAG_SetGadgetText(C_Gad_AnimSpeed, "")
		LAG_SetGadgetText(C_Gad_AnimStart, "")
		*/	
	k = visible
	
	LAG_SetGadgetVisible(C_Gad_Physic, k)
	
	// anim
	LAG_SetGadgetVisible(C_Gad_PlayAnim, k)
	LAG_SetGadgetVisible(C_Gad_AnimEnd, k)
	LAG_SetGadgetVisible(C_Gad_AnimSpeed, k)
	LAG_SetGadgetVisible(C_Gad_AnimStart, k)
	
	// general
	LAG_SetGadgetVisible(C_Gad_ObjFog, k)
	LAG_SetGadgetVisible(C_Gad_Shado, k)
	LAG_SetGadgetVisible(C_Gad_ShadoCast, k)
	LAG_SetGadgetVisible(C_Gad_ShadoREC, k)
		
	// rot
	LAG_SetGadgetVisible(C_Gad_rx, k)
	LAG_SetGadgetVisible(C_Gad_ry, k)
	LAG_SetGadgetVisible(C_Gad_rZ, k)
	
	// size
	LAG_SetGadgetVisible(C_Gad_sx, k)
	LAG_SetGadgetVisible(C_Gad_sy, k)
	LAG_SetGadgetVisible(C_Gad_sZ, k)
	
	// lock
	LAG_SetGadgetVisible(C_Gad_lock_RX, k)
	LAG_SetGadgetVisible(C_Gad_lock_Ry, k)
	LAG_SetGadgetVisible(C_Gad_lock_Rz, k)
	
	LAG_SetGadgetVisible(C_Gad_lock_SX, k)
	LAG_SetGadgetVisible(C_Gad_lock_Sy, k)
	LAG_SetGadgetVisible(C_Gad_lock_Sz, k)
	
	// Color
	LAG_SetGadgetVisible(C_Gad_BM, k)
	LAG_SetGadgetVisible(C_Gad_Tra, k)
	
endfunction

Function UpdateGadTextureStage()

	Lag_FreeallGadgetItemByGadget(C_Gad_ListStage)
	For i = 0 to Object[ObjId].stage.length
		img = Object[ObjId].stage[i].ImageId
		name$ = ""
		if img = -1
			img = LAG_i_Gadget[LAG_c_iChecker]
		else
			tId = Object[ObjId].stage[i].TextureId
			name$ = GetFilePart(Texture[tId].Filename$)
		endif
		
		name$ = str(i)+" : "+name$
		
		LAG_AddGadgetItem(C_Gad_ListStage, i, name$, img)
		// LAG_SetGadgetItemAttribute(C_Gad_ListStage, i, C_ASSETOBJ)
	next
					
Endfunction




/// outline for object
Function CreateOutline(add, j)
	
	
	if add = 1
		
		n = object[j].Obj
		
		w# = GetObjectWidth(j)
		h# = GetObjectHeight(j)
		l# = GetObjectLength(j)
		
		// message(str(w#)+"/"+str(h#)+"/"+str(l#))
		
		
		
		i = CreateObjectBox(w#,h#,l#) //CloneObject(n)
		
		if GetObjectExists(object[j].ObjOutline)
			DeleteObject(object[j].ObjOutline)
		endif
		
		object[j].ObjOutline = i
		//SetObjectCullMode(i, 2)
		//SetObjectScalepermanent(i,1.05,1.05,1.05)
		/*
		For i= 0 to 7
			SetObjectImage(i,-1,i)
		next
		*/
		SetObjectImage(i,iCube,0)
		SetObjectShader(i, -1)
		SetObjectColor(i,0,0,0,255)
		SetObjectTransparency(i,1)
		SetObjectColorEmissive(i,0,0,0)
		SetObjectLightMode(1,0)
		// FixObjectToObject(i, n)
		
		/*
		if object[j].Typ = C_OBJBANK
			x = - GetObjectWidth(j)*0.5
			y = - GetObjectHeight(j)*0.5
			z = - GetObjectLength(j)*0.5
			SetObjectPosition(i, 0, 0, 0)
			SetObjectPosition(i, x, y, z)
			FixObjectPivot(i)
		endif
		*/
		// FixObjectPivot(i)
		
		Updateoutline(j,1,1,1)
	endif
		
	
endfunction

Function Updateoutline(i,pos,scale,rot)
	
	
	n = object[i].Obj
	k = object[i].ObjOutline 
	
		
	sx# = object[i].sx
	sy# = object[i].sy
	sz# = object[i].sz
	s# = object[i].Size * 1.01
	
	if scale=1		
		SetObjectScale(k, s#*sx#, s#*sy#, s#*sz#)
	endif
	
	if rot = 1
		rx = object[i].rx
		ry = object[i].ry
		rz = object[i].rz
		SetObjectRotation(k, rx, ry, rz)
	endif
	
	if pos = 1
		
		if object[i].typ = C_OBJBANK
			x = getobjectx(n) + GetObjectWidth(i)  * 0.5 * s#*sx# + Object[i].pivot.x* s#*sx#
			y = getobjecty(n) + GetObjectHeight(i) * 0.5 * s#*sy# + Object[i].pivot.y* s#*sy#
			z = getobjectz(n) + GetObjectLength(i) * 0.5 * s#*sz# + Object[i].pivot.z* s#*sz#
		else
			x = getobjectx(n) 
			y = getobjecty(n) 
			z = getobjectz(n) 
		endif
		SetObjectPosition(k, x, y, z)
		
	endif
		
Endfunction

Function UpdateScaleOutline(i, sx#, sy#, sz#, s#)
	
	n = object[i].Obj
	k = object[i].ObjOutline 
	
	/*
	sx# = object[i].sx
	sy# = object[i].sx
	sz# = object[i].sx
	s# = object[i].Size*1.05
	*/
	s# = s#*1.01
	SetObjectScale(k, s#*sx#, s#*sy#, s#*sz#)
	
	/*
	rx = object[i].rx
	ry = object[i].ry
	rz = object[i].rz
	SetObjectRotation(k, rx, ry, rz)
	*/
	
	if object[i].typ = C_OBJBANK
		x = getobjectx(n) + GetObjectWidth(i)  * 0.5 * s#*sx# + Object[i].pivot.x* s#*sx#
		y = getobjecty(n) + GetObjectHeight(i) * 0.5 * s#*sy# + Object[i].pivot.y* s#*sy#
		z = getobjectz(n) + GetObjectLength(i) * 0.5 * s#*sz# + Object[i].pivot.z* s#*sz#
	else
		x = getobjectx(n) 
		y = getobjecty(n) 
		z = getobjectz(n) 
	endif
	SetObjectPosition(k, x, y, z)
	
	
Endfunction

Function UpdateRotOutline(i,x#,y#,z#)
	
	n = object[i].Obj
	k = object[i].ObjOutline 
	
	//rx = object[i].rx
	//ry = object[i].ry
	//rz = object[i].rz
	SetObjectRotation(k, x#, y#, z#)
		
		
		
Endfunction








// window
Function OpenWindowObjParam() 
	
	
	
	FoldStart // Create the Window
	
	w = 400
	h = 600
	
	//OldAction = action
	//Action = C_ACTIONSELECT
	x = options.WindowObjParam.X
	y = options.WindowObjParam.Y
	if x = 0
		x = G_width/2-w/2
	endif
	if y = 0 
		y = g_height/2-h/2
	endif
	Lag_OpenWindow(C_WINBehavior,x,y,w,h,"Set Objects parameters",0)
	
	// Add the gadget for the Set object parameters window
	w1 = 80 : h1 = 30 : xx = 10 : yy = 10 : h2 =16 : h3 = 25 : b =3
	
	// id of the gadgets
	u = c_GadForWindow
	GadShadowOn = u
	GadShadowLM = u+1
	GadShadowcast = u+2
	GadShadowRec = u+3
	GadPosOn = u+4
	GadXVar = u+5
	GadYVar = u+6
	GadZVar = u+7
	GadSizeOn = u+8
	GadsXVar = u+9
	GadsYVar = u+10
	GadsZVar = u+11
	GadSnapOn = u+12
	
	LAG_CheckBoxGadget(GadShadowOn,xx,yy,80,h2,"Shadow")   : yy=yy+h3+b 
	LAg_SetGadgetTooltip(GadShadowOn,"Change the shadows parameters for selected objects.")  
	xx= 30
	LAG_CheckBoxGadget(GadShadowLM,xx,yy,80,h2,"Lightmap")  : xx = xx + 90 
	LAg_SetGadgetTooltip(GadShadowLM,"Cast shadow on lightmap.")  
	LAG_CheckBoxGadget(GadShadowcast,xx,yy,80,h2,"Cast")  : xx = xx + 90 
	LAg_SetGadgetTooltip(GadShadowcast,"Cast shadows (realtime).")  
	LAG_CheckBoxGadget(GadShadowRec,xx,yy,80,h2,"Receive")  : yy=yy+h3+b : xx= 10
	LAg_SetGadgetTooltip(GadShadowRec,"Receive shadows (realtime).")  

	//GadPhysicVar = LAG_StringGadget(-1,xx,yy,60,h3,"Physic ","") : yy=yy+h3+b : 
	
	LAG_CheckBoxGadget(GadPosOn,xx,yy,80,h2,"Position")   : yy=yy+h2+b
	LAg_SetGadgetTooltip(GadPosOn,"Change the position of selected objects.")  
	xx= 30
	LAG_StringGadget(GadXVar,xx,yy,60,h3,"X ","")  : xx = xx + 90
	LAG_StringGadget(GadYVar,xx,yy,60,h3,"Y ","")  : xx = xx + 90
	LAG_StringGadget(GadZVar,xx,yy,60,h3,"Z ","") : yy=yy+h3+b : xx= 10

	LAG_CheckBoxGadget(GadSizeOn,xx,yy,80,h2,"Size")   : yy=yy+h2+b
	LAg_SetGadgetTooltip(GadSizeOn,"Change the scale/size of selected objects (multiply by current size).")  
	xx= 30
	LAG_StringGadget(GadsXVar,xx,yy,60,h3,"X ","")  : xx = xx + 90
	LAG_StringGadget(GadsYVar,xx,yy,60,h3,"Y ","")  : xx = xx + 90
	LAG_StringGadget(GadsZVar,xx,yy,60,h3,"Z ","") : yy=yy+h3+b  
	
	xx= 10
	LAG_CheckBoxGadget(GadSnapOn,xx,yy,80,h2,"Snap")   : yy=yy+h3+b
	LAg_SetGadgetTooltip(GadSnapOn,"Snap the selected objects (by snapping defined in option).")  
	
	xx= 10
	GadPhysicOn = u+13
	GadPhysicShape = u+14

	LAG_CheckBoxGadget(GadPhysicOn,xx,yy,80,h2,"Physic")   : yy=yy+h2+b
	LAg_SetGadgetTooltip(GadPhysicOn,"Change the physic shape for selected objects.") 
	xx = 30 
	LAG_ButtonGadget(GadPhysicShape,xx,yy,80,h3,"No Physic",0) : yy=yy+h3+b
	LAg_SetGadgetTooltip(GadPhysicShape,"Set the physic attribute.")
	
	txt$ ="no physic,static,dynamic,kinematic,Character"
	
	
	xx = 10
	yy = h -h1*2-20		
	LAG_ButtonGadget(C_Gad_BehaviorOk,xx,yy,w1,h1,"Ok",0) : xx = xx + w1 +5
	LAG_ButtonGadget(C_Gad_BehaviorCancel,xx,yy,w1,h1,"Cancel",0)
	
	
	Foldend
	
	
	
	repeat // the main loop for the windo. Not necessary if we get the gadget envent in the main program loop
				
		eventwindow = LAG_EventWindow()
		LAG_EventType()
		
		ToolTipsEvent(getpointerX(),getpointerY())	
		
		if eventwindow = LAG_C_CloseWindow or GetRawKeyPressed(Key_escape)
			Quit = 1
		
			options.WindowObjParam.x = LAG_GetWindowX(C_WINBehavior)		
			options.WindowObjParam.Y = LAG_GetWindowY(C_WINBehavior)

		
		else
				
			eventgadget = LAg_eventgadget()
			
			if EventGadget <> 0
				CreateToolTips(getPointerX(),getPointerY(),EventGadget)
			endif
			
			If GetRawMouseLeftPressed() or LAG_Event_Type = LAG_c_EventTypeMousePressed or LAG_Event_Type = LAG_C_EVENTTYPEKEYPRESSED	
				// GetPointerReleased() or LAG_Event_Type = LAG_C_EVENTTYPEMOUSERELEASED					
				
				select eventgadget 
					
					case GadPhysicShape
						inc Physic
						if physic > 4
							physic = 0
						endif
						LAG_SetgadgetText(GadPhysicShape,GetStringToken(txt$, ",",physic+1))
					endcase
												
					case C_Gad_BehaviorOk
												
						For i=0 to object.length
							
							if object[i].selected =1 and object[i].locked = 0
								
								
								if LAG_getgadgetstate(GadPhysicOn)
									object[i].Physic = physic
								endif
								
								
								
								
								if LAG_getgadgetstate(GadPosOn)
									object[i].x = object[i].x+Val(LAG_GetGadgetText(GadXVar))
									object[i].y = object[i].y+Val(LAG_GetGadgetText(GadYVar))
									object[i].z = object[i].z+Val(LAG_GetGadgetText(GadZVar))
									SetObjectPosition(Object[i].Obj,object[i].x,object[i].y,object[i].z)
								endif
								
								if LAG_getgadgetstate(GadSnapOn)
									
									x1 = object[i].x 
									y1 = object[i].y 
									z1 = object[i].z 
															
									x = round(x1 / SNapX)
									x1 = x * SnapX
									
									z = round(z1 / SnapZ)
									z1 = z * SnapZ
									
									y = round(y1 / SnapY)
									y1 = y * SnapY
									
									object[i].x = x1						
									object[i].y = y1						
									object[i].z = z1						
									SetObjectPosition(Object[i].Obj,object[i].x,object[i].y,object[i].z)					
								endif
								
								if LAG_getgadgetstate(GadSizeOn)
									object[i].sx = object[i].sx+ValFloat(LAG_GetGadgetText(GadsXVar))
									object[i].sy = object[i].sy+ValFloat(LAG_GetGadgetText(GadsYVar))
									object[i].sz = object[i].sz+ValFloat(LAG_GetGadgetText(GadsZVar))
									SetObjectScale2(i,0)
								endif
								
								if LAG_getgadgetstate(GadShadowOn)
									object[i].Shadow = LAG_getgadgetstate(GadShadowLM)
									object[i].ShadowCast = LAG_getgadgetstate(GadShadowCast)
									object[i].ShadowRec = LAG_getgadgetstate(GadShadowRec)
									UpdateObjectShadow(i)
								endif
							endif
						next						
					
					endcase
					
					case C_Gad_BehaviorCancel
						Quit = 2	
					endcase
				
				endselect
			
			
			endif
			
		endif
		
		
		EventBehavior()
		SyncShadow()
		
		sync()
	until quit>= 1
	
		
			
	FoldStart // close the window, erase its contents (gadgets, sprite, text...)
	 
		// delete the other item
		LAG_CloseWindow(C_WINBehavior)
		
	FoldEnd
	
	
EndFunction

Function OpenWindowObjPhysics() 

	
	// to set the physics for selected objects
	if assetTyp = C_ASSETOBJ or assettyp = C_ASSETMESH
		
		if ObjId> -1 and ObjId <= object.length
		
			FoldStart // Create the Window
		
		w = 400
		h = 600
		
		//OldAction = action
		//Action = C_ACTIONSELECT
		x = options.WindowPhysic.X
		y = options.WindowPhysic.Y
		if x = 0
			x = G_width/2-w/2
		endif
		if y = 0 
			y = g_height/2-h/2
		endif
		Lag_OpenWindow(C_WINBehavior,x,y,w,h,"Set physics parameters",0)
		
		// Add the gadget for the Set object parameters window
		w1 = 80 : h1 = 30 : xx = 10 : yy = 10 : h2 =16 : h3 = 25 : b =3
		
		// id of the gadgets
		u = c_GadForWindow
		GadColisionOn = u
		
		LAG_CheckBoxGadget(GadColisionOn,xx,yy,80,h2,"Collision")   : yy=yy+h3+b 
		LAg_SetGadgetTooltip(GadColisionOn,"Set collision on object.") 
		Lag_SetGadgetState(GadColisionOn, Object[objId].Physics.Colision)
		xx= 30
		/*
		LAG_CheckBoxGadget(GadShadowLM,xx,yy,80,h2,"Lightmap")  : xx = xx + 90 
		LAg_SetGadgetTooltip(GadShadowLM,"Cast shadow on lightmap.")  
		LAG_CheckBoxGadget(GadShadowcast,xx,yy,80,h2,"Cast")  : xx = xx + 90 
		LAg_SetGadgetTooltip(GadShadowcast,"Cast shadows (realtime).")  
		LAG_CheckBoxGadget(GadShadowRec,xx,yy,80,h2,"Receive")  : yy=yy+h3+b : xx= 10
		LAg_SetGadgetTooltip(GadShadowRec,"Receive shadows (realtime).")  

		//GadPhysicVar = LAG_StringGadget(-1,xx,yy,60,h3,"Physic ","") : yy=yy+h3+b : 
		
		LAG_CheckBoxGadget(GadPosOn,xx,yy,80,h2,"Position")   : yy=yy+h2+b
		LAg_SetGadgetTooltip(GadPosOn,"Change the position of selected objects.")  
		xx= 30
		LAG_StringGadget(GadXVar,xx,yy,60,h3,"X ","")  : xx = xx + 90
		LAG_StringGadget(GadYVar,xx,yy,60,h3,"Y ","")  : xx = xx + 90
		LAG_StringGadget(GadZVar,xx,yy,60,h3,"Z ","") : yy=yy+h3+b : xx= 10

		LAG_CheckBoxGadget(GadSizeOn,xx,yy,80,h2,"Size")   : yy=yy+h2+b
		LAg_SetGadgetTooltip(GadSizeOn,"Change the scale/size of selected objects (multiply by current size).")  
		xx= 30
		LAG_StringGadget(GadsXVar,xx,yy,60,h3,"X ","")  : xx = xx + 90
		LAG_StringGadget(GadsYVar,xx,yy,60,h3,"Y ","")  : xx = xx + 90
		LAG_StringGadget(GadsZVar,xx,yy,60,h3,"Z ","") : yy=yy+h3+b  
		
		xx= 10
		LAG_CheckBoxGadget(GadSnapOn,xx,yy,80,h2,"Snap")   : yy=yy+h3+b
		LAg_SetGadgetTooltip(GadSnapOn,"Snap the selected objects (by snapping defined in option).")  
		*/
		xx= 10
		GadPhysicOn = u+13
		GadPhysicShape = u+14

		//LAG_CheckBoxGadget(GadPhysicOn,xx,yy,80,h2,"Physic")   : yy=yy+h2+b
		//LAg_SetGadgetTooltip(GadPhysicOn,"Change the physic shape for selected objects.") 
		//xx = 30 
		
		txt$ ="no physic,static,dynamic,kinematic,Character"
		
		LAG_ButtonGadget(GadPhysicShape,xx,yy,80,h3,GetStringToken(txt$, ",", object[objid].Physic+1),0) : yy=yy+h3+b
		LAg_SetGadgetTooltip(GadPhysicShape,"Set the physic body.")
				
		
		xx = 10
		yy = h -h1*2-20		
		LAG_ButtonGadget(C_Gad_BehaviorOk,xx,yy,w1,h1,"Ok",0) : xx = xx + w1 +5
		LAG_ButtonGadget(C_Gad_BehaviorCancel,xx,yy,w1,h1,"Cancel",0)
		
		
		Foldend
		
		
		
			repeat // Not necessary if we get the gadget event in the main program loop
					
			eventwindow = LAG_EventWindow()
			LAG_EventType()
			
			ToolTipsEvent(getpointerX(),getpointerY())	
			
			if eventwindow = LAG_C_CloseWindow or GetRawKeyPressed(Key_escape)
				Quit = 1
			
				options.WindowObjParam.x = LAG_GetWindowX(C_WINBehavior)		
				options.WindowObjParam.Y = LAG_GetWindowY(C_WINBehavior)

			
			else
					
				eventgadget = LAg_eventgadget()
				
				if EventGadget <> 0
					CreateToolTips(getPointerX(),getPointerY(),EventGadget)
				endif
				
				If GetRawMouseLeftPressed() or LAG_Event_Type = LAG_c_EventTypeMousePressed or LAG_Event_Type = LAG_C_EVENTTYPEKEYPRESSED	
					// GetPointerReleased() or LAG_Event_Type = LAG_C_EVENTTYPEMOUSERELEASED					
					
					select eventgadget 
						
						case GadPhysicShape
							inc Physic
							if physic > 4
								physic = 0
							endif
							LAG_SetgadgetText(GadPhysicShape,GetStringToken(txt$, ",",physic+1))
						endcase
													
						case C_Gad_BehaviorOk
													
							For i=0 to object.length
								
								if object[i].selected =1 and object[i].locked = 0
									
									object[i].Physic = physic
									object[i].Physics.Colision = LAG_GetgadgetState(GadColisionOn)
									SetPhysicToObject(i,0)
										
								endif
							next						
						
						endcase
						
						case C_Gad_BehaviorCancel
							Quit = 2	
						endcase
					
					endselect
				
				
				endif
				
			endif
			
			
			EventBehavior()
			SyncShadow()
			
			sync()
		until quit>= 1
		
			
				
			FoldStart // close the window, erase its contents (gadgets, sprite, text...)
	 
			// delete the other item
			LAG_CloseWindow(C_WINBehavior)
		
			FoldEnd
	
	
		else
			
			Message("Please select an object before to set the physics parameters")	
	
		endif
	
	else
		
		Message("Please select an object before to set the physics parameters")	
		
	endif
	
EndFunction

Function OpenWindowObjShader() 
	
	
	
	// to set the physics for selected objects
	
	
	if assetTyp = C_ASSETOBJ or assettyp = C_ASSETMESH
		
		if ObjId> -1 and ObjId <= object.length
		
			// to see the sahder
			SetObjectColorEmissive(object[ObjId].Obj,0,0,0)
		
		
			FoldStart // Create the Window
		
			w = 400
			h = 600
			
			//OldAction = action
			//Action = C_ACTIONSELECT
			x = options.WindowPhysic.X
			y = options.WindowPhysic.Y
			if x = 0
				x = G_width/2-w/2
			endif
			if y = 0 
				y = g_height/2-h/2
			endif
			Lag_OpenWindow(C_WINBehavior,x,y,w,h,"Set Shader parameters",0)
			
			// Add the gadget for the Set object parameters window
			w1 = 80 : h1 = 30 : xx = 10 : yy = 10 : h2 =16 : h3 = 25 : b =3
			w2 = w - 40
			
			// id of the gadgets
			u = c_GadForWindow
			hh = 350
			GadShaderlist = u
			LAG_ListIconGadget(GadShaderlist,xx,yy,w2,hh)
			yy=yy+hh+10
			
			// add the shader to the listicon
			LAG_AddGadgetItem(GadShaderlist, 0, "AGK Basic shader", 0)
			For k=0 to ShaderBank.length					
				Desc$ = GetFilePart(ShaderBank[k].Filename$)
				img = 0			
				LAG_AddGadgetItem(GadShaderlist, k+1, Desc$, img)
			next 
			
			//LAG_CheckBoxGadget(GadColisionOn,xx,yy,80,h2,"Collision")   : yy=yy+h3+b 
			//LAg_SetGadgetTooltip(GadColisionOn,"Set collision on object.") 
			//Lag_SetGadgetState(GadColisionOn, Object[objId].Physics.Colision)
			
			xx = 10
			GadShaderDesc = u+1
			LAG_TextGadget(GadShaderDesc,xx,yy,w2,80,"AGK Basic shader","-1|100|1|")
			
			/*
			x = 10
			Gad_ShaderReload = u+2
			LAG_ButtonGadget(Gad_ShaderReload,x,yy,90,h3,"Reload ",0) : yy=yy+h3+b+10
			LAg_SetGadgetTooltip(Gad_ShaderReload,"Reload the shaders.")  
			*/
			
			//LAG_ButtonGadget(GadPhysicShape,xx,yy,80,h3,GetStringToken(txt$, ",", object[objid].Physic+1),0) : yy=yy+h3+b
			//LAg_SetGadgetTooltip(GadPhysicShape,"Set the physic body.")
					
			
			xx = 10
			yy = h -h1*2-20		
			LAG_ButtonGadget(C_Gad_BehaviorOk,xx,yy,w1,h1,"Ok",0) : xx = xx + w1 +5
			LAG_ButtonGadget(C_Gad_BehaviorCancel,xx,yy,w1,h1,"Cancel",0)
			
			
			Foldend
		
		
		
			repeat // Not necessary if we get the gadget event in the main program loop
					
			eventwindow = LAG_EventWindow()
			LAG_EventType()
			
			ToolTipsEvent(getpointerX(),getpointerY())	
			
			
			if eventwindow = LAG_C_CloseWindow or GetRawKeyPressed(Key_escape)
				Quit = 1
			
				options.WindowObjParam.x = LAG_GetWindowX(C_WINBehavior)		
				options.WindowObjParam.Y = LAG_GetWindowY(C_WINBehavior)
			
			else
					
				eventgadget = LAg_eventgadget()
				
				if EventGadget <> 0
					CreateToolTips(getPointerX(),getPointerY(),EventGadget)
				endif
				
				If GetRawMouseLeftPressed() or LAG_Event_Type = LAG_c_EventTypeMousePressed or LAG_Event_Type = LAG_C_EVENTTYPEKEYPRESSED	
					// GetPointerReleased() or LAG_Event_Type = LAG_C_EVENTTYPEMOUSERELEASED					
					
					select eventgadget 
						
						case GadShaderlist
							
							shader = LAG_GetgadgetState(GadShaderlist)-1
							Txt$ = GetShaderInfo(shader)
							info$ =         "Description   : "+GetStringToken(txt$,"|",3)+chr(10)
							info$ = info$ + "Textures used : " + GetStringToken(txt$,"|",4)+chr(10)
							info$ = info$ + "Uv chanels    : " + GetStringToken(txt$,"|",5)+chr(10)
							LAg_SetGadgetText(GadShaderDesc,info$)
							
						endcase
						
						case C_Gad_BehaviorOk
													
							For i=0 to object.length
								
								if object[i].selected =1 and object[i].locked = 0
									
									object[i].Shader = Shader
									n = object[i].Obj
									
									if Object[i].Shader <=-1
										SetObjectShader(n, 0)
									elseif Object[i].Shader <= ShaderBank.length
										SetObjectShader(n, ShaderBank[Object[i].Shader].Shader)
									endif	
									
								endif
							next						
						
						endcase
						
						case C_Gad_BehaviorCancel
							Quit = 2	
						endcase
					
					endselect
				
				
				endif
				
			endif
			
			
			EventBehavior()
			SyncShadow()
			
			sync()
		until quit>= 1
		
			
				
			FoldStart // close the window, erase its contents (gadgets, sprite, text...)
	 
		// delete the other item
		Lag_FreeallGadgetItemByGadget(GadShaderlist)		
		LAG_CloseWindow(C_WINBehavior)
		
	FoldEnd
	
	
		else
			
			Message("Select an object before to open the shader list.")	
	
		endif
	
	else
		
		Message("Select an object before to open the shader list.")	
		
	endif
	
EndFunction

Function OpenWindowAssetCreate() 
	
	// to set some parameters for creation of assets, by default
	FoldStart // Create the Window
		
	w = 400
	h = 600
	
	//OldAction = action
	//Action = C_ACTIONSELECT
	x = options.WindowPhysic.X
	y = options.WindowPhysic.Y
	if x = 0
		x = G_width/2-w/2
	endif
	if y = 0 
		y = g_height/2-h/2
	endif
	Lag_OpenWindow(C_WINBehavior,x,y,w,h,"Set Asset parameters (for creation)",0)
	
	// Add the gadget for the Set object parameters window
	w1 = 80 : h1 = 30 : xx = 10 : yy = 10 : h2 =16 : h3 = 25 : b =3
	w2 = w - 40
	
	// id of the gadgets
	u = c_GadForWindow
	hh = 350
	GadAssetCol = u
	LAG_CheckBoxGadget(GadAssetCol,xx,yy,80,h2,"Collision")   : yy=yy+h3+b 
	LAg_SetGadgetTooltip(GadAssetCol,"Set collision for futur asset create (object).") 
	Lag_SetGadgetState(GadAssetCol, Options.Asset.Colision)
	
	xx = 10
	GadAssetBody = u+1
	txt$ ="no physic,static,dynamic,kinematic,Character"
	LAG_ButtonGadget(GadAssetBody,xx,yy,80,h3,GetStringToken(txt$, ",", options.Asset.PhysicsBody+1),0) : yy=yy+h3+b
	LAg_SetGadgetTooltip(GadAssetBody,"Set the physic body for futur asset (object).")
			
	
	xx = 10
	yy = h -h1*2-20		
	LAG_ButtonGadget(C_Gad_BehaviorOk,xx,yy,w1,h1,"Ok",0) : xx = xx + w1 +5
	LAG_ButtonGadget(C_Gad_BehaviorCancel,xx,yy,w1,h1,"Cancel",0)
	
	
	Foldend
		
		
		
		Repeat // Not necessary if we get the gadget event in the main program loop
					
			eventwindow = LAG_EventWindow()
			LAG_EventType()
			
			ToolTipsEvent(getpointerX(),getpointerY())	
			
			
			if eventwindow = LAG_C_CloseWindow or GetRawKeyPressed(Key_escape)
				Quit = 1
			
				options.WindowObjParam.x = LAG_GetWindowX(C_WINBehavior)		
				options.WindowObjParam.Y = LAG_GetWindowY(C_WINBehavior)
			
			else
					
				eventgadget = LAg_eventgadget()
				
				if EventGadget <> 0
					CreateToolTips(getPointerX(),getPointerY(),EventGadget)
				endif
				
				If GetRawMouseLeftPressed() or LAG_Event_Type = LAG_c_EventTypeMousePressed or LAG_Event_Type = LAG_C_EVENTTYPEKEYPRESSED	
					// GetPointerReleased() or LAG_Event_Type = LAG_C_EVENTTYPEMOUSERELEASED					
					
					select eventgadget 

						case GadAssetBody
							
							inc PhysicBody
							if PhysicBody > 4
								PhysicBody = 0
							endif
							LAG_SetGadgetText(GadAssetBody,GetStringToken(txt$, ",", PhysicBody+1))
						endcase
						
						case C_Gad_BehaviorOk
													
							Options.Asset.Colision = LAg_getgadgetstate(GadAssetCol)					
							Options.Asset.PhysicsBody = PhysicBody				
						
						endcase
						
						case C_Gad_BehaviorCancel
							Quit = 2	
						endcase
					
					endselect
				
				
				endif
				
			endif
			
			
			EventBehavior()
			SyncShadow()
			
			sync()
		until quit>= 1
		
			
				
	FoldStart // close the window, erase its contents (gadgets, sprite, text...)
	 
		// delete the other item
		LAG_CloseWindow(C_WINBehavior)
		
	Foldend
	
	
	
EndFunction






// update
Function UpdateObject(i)
	
	// to update the object
	ObjId = i
	s# = Object[i].Size
	if s#<=0
		s# = 1
	endif
	
	n = Object[i].Obj
	
	StId = Object[i].StageId

	SetObjectUVOffset(n, 0, Object[i].stage[StId].UVx, Object[i].stage[StId].UVy)
	SetObjectUVScale(n, 0, Object[i].stage[StId].UVw, Object[i].stage[StId].UVh)
	
	if Object[i].Animated = 0
		SetObjectScale(n, Object[i].sx*s#, Object[i].sy*s#, Object[i].sz*s#)
	else
		SetObjectScalePermanent(n, Object[i].sx*s#, Object[i].sy*s#, Object[i].sz*s#)
	endif
	
	SetObjectRotation(n, Object[i].rx, Object[i].ry, Object[i].rz)
	SetObjectPosition(n, Object[i].x, Object[i].y, Object[i].z)
	
	UpdateObjectShadow(i)
	
	
EndFunction

Function UpdateObjectShadow(i)
	
	SetObjectCastShadow(Object[i].Obj, Object[i].ShadowCast)
	SetObjectReceiveShadow(Object[i].Obj, Object[i].ShadowRec )
	
Endfunction

Function UpdateObjetMaterial(i)
	
	
	For k =0 to Object[i].Stage.length
		
		img = Object[i].Stage[k].ImageId
		
		if img > 0
			if k = 1 and Object[i].LightMap =1
				SetObjectLightMap(Object[i].Obj, Img)
			elseif k = 2 and Object[i].Normalmap =1
				SetObjectNormalMap(Object[i].Obj, Img)
				// message("normal map sur objet")
			else			
				SetObjectImage(Object[i].Obj, img, k) 
			endif
		endif
	next
	
	
	// SetObjectShader(Object[i].Obj, Object[i].Shader)
	
	if Object[i].Shader <= ShaderBank.length and Object[i].Shader> -1
		SetObjectShader(Object[i].Obj, ShaderBank[Object[i].Shader].Shader)
	else
		SetObjectShader(Object[i].Obj, -1)
	endif
	
endFunction





// Center 
Function UpdateAllCenter()
	
	
	// the center of objects
	If Options.ShowCenter
		For i =0 to object.length
			//if Object[i].Hide = 0
				UpdateObjectCenterSprite(i)
			//endif
		next
	endif
	
	
	//  cible look at camera
	SetObjectLookAt( CibleEd, GetCameraX(1), GetCameraY(1), GetCameraZ(1), 0 ) 
	
	//SetCameraPosition(1,GetObjectX(CubeView),GetObjectY(CubeView),GetObjectZ(CubeView))
	//MoveCameraLocalZ(1, -500+cameraZoom#)	
	SetCubeViewTocamera(0)
	
Endfunction

Function UpdateObjectCenterSprite(i)

	Object[i].xp_screen# = GetScreenXFrom3D(Object[i].x,Object[i].y,Object[i].z)
	Object[i].yp_screen# = GetScreenYFrom3D(Object[i].x,Object[i].y,Object[i].z)
	SetSpritePositionByOffset(Object[i].spr,Object[i].xp_screen#,Object[i].yp_screen#)

endfunction

Function SetAllCenterVisible()
	
	For i = 0 to object.length
		SetSpriteVisible(Object[i].spr,(1-object[i].hide) * Options.ShowCenter)
	next
	
EndFunction






// action for object
Function MoveObject(i, x#,y#,z#)
	
	// move an Object
	
	if i >-1 and i<= Object.length		
		
		n=Object[i].Obj
		
		if Options.Orientation = 0
			
			Object[i].x = x#						
			Object[i].y = y#						
			Object[i].z = z#
				
			SetObjectPosition(n, x#, y#, z#)
			
			if Object[i].Typ = C_OBJPARTSYS
				SetPartSystemPosition(Object[i].IdObj3D,x#,y#,z#)
			endif
			
		elseif Options.Orientation = 1
						
			x1# = x# - Object[i].x 						
			y1# = y# - Object[i].y 					
			z1# = z# - Object[i].z	
							
			MoveObjectLocalX(n,x1#)
			MoveObjectLocaly(n,y1#)
			MoveObjectLocalz(n,z1#)
			
			Object[i].x = Object[i].x + x1#
			Object[i].y = Object[i].y + y1#
			Object[i].z = Object[i].z + z1#
			
			if Object[i].Typ = C_OBJPARTSYS
				SetPartSystemPosition(Object[i].IdObj3D, Object[i].x, Object[i].y, Object[i].z)
			endif
			
		endif
		
		UpdateObjectCenterSprite(i)
		
		updateoutline(i,1,0,0)
		
	endif
	
EndFunction

Function SetObjectAnimation(play, speed#, FrameStart#, FrameEnd#)	
	
	// to set some animation parameters
	if ObjId >- 1 and objID <= object.length
		n = object[ObjId].Obj
		
		object[ObjId].Animated = 1
	
		object[ObjId].Anim.speed = speed#
		object[ObjId].Anim.FrameSt = FrameStart#
		object[ObjId].Anim.FrameEnd = FrameEnd#
		
		SetObjectAnimationSpeed(n, speed#)
		if play = 1
			PlayObjectAnimation(n, "", FrameStart#, FrameEnd# , 1, 0)
			// message("ok, play ! ")
		else
			StopObjectAnimation(n)
		endif
	endif
	
EndFunction	







// Transform : hide, lock...
Function TransformObject(transform, value)
	
	// to change some parameters of objects/light
	
	select transform
		
		case C_transform_Hide
			
			For i=0 to Object.length
				if Object[i].Selected = 1 or value = 0
					Object[i].Hide = value
					SetObjectVisible2(i)
				endif
			next
			
			For i=0 to light.length
				if light[i].selected = 1 or value = 0
					Light[i].hide = value
					SetObjectVisible(Light[i].Obj,1-value)
				endif
			next
			
		endcase
		
		case C_transform_Lock
			
			For i=0 to Object.length
				if Object[i].Selected = 1 or value = 0
					Object[i].Locked = value
				endif
			next
			
			For i=0 to light.length
				if light[i].selected = 1 or value = 0
					light[i].Locked = value
				endif
			next
			
		endcase
		
	endselect
	
	
endfunction





// copy, paste
Function CopyObject()
	
	ok = 0
	
	// Copy des propriétés
	//if AssetTyp = C_ASSETOBJ
				
		// on ajoute les nouveaux objets dans la liste des copies
		For i=0 to object.length
			if object[i].Selected
				
				if ok = 0 // d'abord, j'efface la liste des objets copiés
					dim TempObj[] as sObject
					ok=1
				endif
				// puis, j'ajoute cet objet dans la nouvelle liste d'objets copiés
				j = TempObj.length +1
				dim TempObj[j] as sObject
				TempObj[j] = object[i]
				TempObj[j].AssetTyp = C_ASSETOBJ
				TempObj[j].x = object[i].x
				TempObj[j].y = object[i].y
				TempObj[j].z = object[i].z
					
			endif
		Next
		
	//Elseif AssetTyp = C_ASSETLIGHT
		
		// on ajoute les nouveaux lights dans la liste des copies
		For i=0 to Light.length
			if Light[i].Selected
				
				if ok = 0 // d'abord, j'efface la liste des objets copiés
					dim TempLight[] as tLight
					ok=1
				endif
				// puis, j'ajoute cet objet dans la nouvelle liste d'objets copiés
				j = TempLight.length +1
				dim TempLight[j] as tLight
				TempLight[j] = Light[i]
				TempLight[j].Typ =  Light[i].Typ
			endif
		Next		
	
	//endif
			
	
EndFunction	

Function PasteObject()
		
	// paste properties

	local x1#, y1#, z1#
	
	
	Foldstart // Paste Object

		if TempObj.length > -1
			
			// keep some options param
			listImageTyp = options.listImageTyp			
			options.listImageTyp = 1
			s_a = Options.Asset.Size
			a_a = Options.Asset.W
			b_a = Options.Asset.H
			c_a = Options.Asset.L
			
			
			
			// unselect all the originals objects/lights
			For i =0 to Object.length
				Object[i].Selected = 0
				SetObjectColorEmissive(object[i].Obj,Object[i].R,Object[i].G,Object[i].B)
			next
			
			// paste the new object
			
			
					
			For i =0 to TempObj.length
				
				if TempObj[i].AssetTyp = C_ASSETOBJ	
					
					// position & objtyp
					
					/*
					X# = Get3DVectorXFromScreen( GetPointerX(), GetPointerY() )
					Y# = Get3DVectorYFromScreen( GetPointerX(), GetPointerY() )
					Z# = Get3DVectorZFromScreen( GetPointerX(), GetPointerY() )
					
					u = 5000	
					worldX# = Get3DVectorXFromScreen( GetPointerX(), GetPointerY() ) * u
					worldY# = Get3DVectorYFromScreen( GetPointerX(), GetPointerY() ) * u
					worldZ# = Get3DVectorZFromScreen( GetPointerX(), GetPointerY() ) * u	 
					worldX# = worldX# + GetCameraX(1)
					worldY# = worldY# + GetCameraY(1)
					worldZ# = worldZ# + GetCameraZ(1)	
					
					
					SetObjectCollisionMode(grid,1)
					obj = ObjectRayCast(Grid,getcamerax(1),getcameray(1),getcameraz(1),worldx#,worldy#,worldz#)
					SetObjectCollisionMode(grid,0)
				
					x = GetObjectRayCastX(0)
					y = GetObjectRayCastY(0)										
					z = GetObjectRayCastZ(0)
					*/
					
					get_mouse_coords(0)
					x = round(Mouse_X)
					z = round(Mouse_Z)
					y = 0
					
					/*
					mousex# = GetPointerX()
					mousey# = GetPointerY()
						
					CamX# = GetCameraX(1)
					CamY# = GetCameraY(1)
					CamZ# = GetCameraZ(1)
					
					ObjX = TempObj[i].x 
					ObjY = TempObj[i].y 
					ObjZ = TempObj[i].z 
					
					u = GetDistance3D(camx#, camY#, camZ#, objx, objy, objz) 
					X = Get3DVectorXFromScreen(mousex#, mousey#) * u + camX#
					 
					Y = 0 // Get3DVectorYFromScreen(mousex#, mousey#) * u + camY#
					  
					Z = Get3DVectorZFromScreen(mousex#, mousey#) * u + camZ# 
					*/
					
					// message(str(x#,2)+"/"+str(y#,2)+"/"+str(z#,2))
					if TempObj.length > 0
						x1# = x + TempObj[i].x  
						y1# = y + TempObj[i].y 
						z1# = z + TempObj[i].z 
					else
						x1# = x 
						y1# = y + TempObj[i].y  
						z1# = z 
					endif
						
						
					OBjTyp =  TempObj[i].Typ
					
					
					// Textures
					//dim texture_ID[TempObj[i].stage.length]
					//dim Img_ID[TempObj[i].stage.length]
					/*
					For kk = 0 to Texture_Id.length 
						Texture_Id[kk] = TempObj[i].stage[kk].TextureId
						// Img_Id[kk] = TempObj[i].stage[kk].ImageId
					next 
					*/
					TextureId =  TempObj[i].stage[0].TextureId
					
					
					// object Id 3D if obj = bank model
					if ObjTyp = C_OBJBANK
						Options.BankModelId = TempObj[i].IdObj3D
					endif
					
					
					// ckeep and change asset create param
					
					Options.Asset.W = TempObj[i].W
					Options.Asset.H = TempObj[i].H
					Options.Asset.L = TempObj[i].L
					Options.Asset.Size = TempObj[i].Size
					
					LAG_SetGadgetText(C_Gad_AssetSize, str(Options.Asset.Size))
					LAG_SetGadgetText(C_Gad_AssetW,	str(Options.Asset.W))
					LAG_SetGadgetText(C_Gad_AssetH, str(Options.Asset.H))
					LAG_SetGadgetText(C_Gad_AssetL, str(Options.Asset.L))

					
					
					
					// add object
					if ObjTyp = C_OBJPARTSYS
						AddObjectPartSyst(x1#,y1#,z1#)
					else
						AddObjet(x1#,y1#,z1#,"")
					endif
					
					j = object.length
					
					// je conserve quelques paramètres
					obj = Object[j].Obj
					Name$ = Object[j].name$									
					n = Object[j].Spr
					ObjId = j
					AssetTyp  = C_ASSETOBJ
					
					Object[j].x = GetObjectX(obj)
					Object[j].y = GetObjectY(obj)
					Object[j].z = GetObjectZ(obj)
					
					x1# = Object[j].x 
					y1# = Object[j].y  
					z1# = Object[j].z
					
					
					// copy all parameters to new bject
					Object[j] = TempObj[i]
					
					// puis, je remets les propriétés spéciales
					Object[j].x = x1#
					Object[j].y = y1#
					Object[j].z = z1#
					
					Object[j].Start.Pos.X = Object[j].x  
					Object[j].Start.Pos.Y = Object[j].y  
					Object[j].Start.Pos.Z = Object[j].z 
					
					
					Object[j].Obj = obj 
					Object[j].name$ = Name$
					Object[j].selected = 1
					Object[j].locked = 0
					Object[j].Spr = n
					
					SetObjectColorEmissive(obj, 255, Object[j].G, Object[j].B)
					SetObjectPosition(obj, x1#, y1#, z1#)
					
					UpdateObject(j)
					UpdateObjetMaterial(j)
					
					
					
					GetAssetProp()
					
					
					
					/*
					UpdateObject(j)
					
					GetObjProp()
					SetObjProp(0)
					SetObjProp(1)
					SetObjProp(2)
					SetObjProp(3)
					*/
					
				endif
			next
			
			// change asset param creation
			Options.Asset.Size = s_a
			Options.Asset.W = a_a
			Options.Asset.H = b_a
			Options.Asset.L = c_a
			LAG_SetGadgetText(C_Gad_AssetSize, str(Options.Asset.Size,0))
			LAG_SetGadgetText(C_Gad_AssetW,	str(Options.Asset.W,0))
			LAG_SetGadgetText(C_Gad_AssetH, str(Options.Asset.H,0))
			LAG_SetGadgetText(C_Gad_AssetL, str(Options.Asset.L,0))


			
			options.listImageTyp = listImageTyp
		
		endif
		
	Foldend
	
	
	Foldstart // Paste light 
		
	if TempLight.length > -1
				
		// Unselect all the lights
		For i =0 to light.length
			light[i].selected =0
		NExt		
					
		// paste the new lights
		For i =0 to TempLight.length
				
			// position & objtyp					
			X# = Get3DVectorXFromScreen( GetPointerX(), GetPointerY() )
			Y# = Get3DVectorYFromScreen( GetPointerX(), GetPointerY() )
			Z# = Get3DVectorZFromScreen( GetPointerX(), GetPointerY() )
			
			x# = x# + TempLight[i].x 
			y# = y# + TempLight[i].y 
			z# = z# + TempLight[i].z 
			// OBjTyp = C_ASSETLIGHT // TempLight[i].Typ
			
			r = TempLight[i].r
			g = TempLight[i].g
			b = TempLight[i].b
			s = TempLight[i].Radius
			int = TempLight[i].Intensity
								
			// add light
			AddLight(x#,y#,z#,s,r,g,b,-1,1)
			j = Light.length
			ObjId = j
			Light[j].Intensity = TempLight[i].Intensity
			Light[j].Locked = TempLight[i].Locked
			Light[j].Shadow = TempLight[i].Shadow
			Light[j].Typ = TempLight[i].Typ
							
			SetPointLightColor(j+1,Light[j].R*Light[j].Intensity,Light[j].G*Light[j].Intensity,Light[j].B*Light[j].Intensity)
			SetObjectColorEmissive(Light[j].Obj,Light[j].r*Light[j].Intensity,Light[j].g*Light[j].Intensity,Light[j].b*Light[j].Intensity)
			MoveLight(x#,y#,z#)
			
			/*
			
			
			
			// copyall parameters to new bject
			obj = Light[j].Obj
			lightid = Light[j].Id
			Name$ = Light[j].name$
			
			
			
			Light[j] = TempLight[i]
			// puis, je remets les propriétés spéciales
			Light[j].x = x#
			Light[j].y = y#
			Light[j].z = z#
			
			Light[j].Obj = obj 
			Light[j].name$ = Name$
			Light[j].Id = lightid
			
			// UpdateObject(j)
			MoveLight(x#,y#,z#)
			*/
		next
	
	endif

	Foldend

	
EndFunction	




// screen culling
Function SetAllObjectCulling(on)
	on = 1
	For i =0 to object.length
		SetObjectScreenCulling(Object[i].Obj,on)
	next
	
EndFunction	
	
