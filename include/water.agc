
Type tWater
	
	WaterHeight as float
	PlaneWidth as integer
	PlaneHeight as integer
	ImageWidth as integer
	ImageHeight as integer
	ReflectionImageID as integer
	RefractionImageID as integer
	DepthImageID as integer
	
EndType

Type tWaterImg
	
	D as integer // diffuse
	N as integer // normal
	
EndType



// init
Function InitWater()
	
	// To have several water plan !	 
	//Global dim Water[] as tWater // not used for the moment
	
	global WaterShaderID
	WaterShaderID=LoadShader("water\Water.vs","water\Water.ps")
	
	Global dim iWater[0] as tWaterImg
	iWater[0].D = LoadImage("water\waterDUDV.png")
	iWater[0].N = LoadImage("water\waterNormal.png")
	
	Global NbWater = -1
	
EndFunction


// add water object
function AddWater(WaterHeight#,PlaneWidth,PlaneHeight,ImageWidth,ImageHeight,img)
	
	If NbWater = -1
		
		Inc NbWater
		
		if img<0 or img > iWater.Length
			img =0
		endif
		
			
		// By Janbo, modified by blendman a little
		global GWaterHeight#	
		GWaterHeight#=WaterHeight#
		
		global ReflectionImageID
		ReflectionImageID = CreateRenderImage(ImageWidth,ImageHeight,0,0)
		
		global RefractionImageID
		RefractionImageID = CreateRenderImage(ImageWidth,ImageHeight,0,0)
		
		global DepthImageID
		DepthImageID = CreateRenderImage(ImageWidth,ImageHeight,1,0)
		
			
		SetImageWrapU(iWater[img].D,1)
		SetImageWrapV(iWater[img].D,1)
			
		SetImageWrapU(iWater[img].N,1)
		SetImageWrapV(iWater[img].N,1)
		
		global WaterObjectID
		WaterObjectID=CreateObjectPlane(PlaneWidth,PlaneHeight)
		
		i = Object.length+1			
		Global Dim Object[i] as sObject			
		ObjId = i
		Object[i].Obj = WaterObjectID
		OldTyp = ObjTyp
		OBjTyp = C_OBJWATER
		
		
		x# = -PlaneWidth*0.5
		y# = WaterHeight#
		z# = -PlaneHeight*0.5
		
		SetObjectDefault(x#,y#,z#)	
		Object[i].Rx = 90
		Object[i].Typ = C_OBJWATER
		
		SetObjectRotation(WaterObjectID,90,0,0)
		SetObjectTransparency(WaterObjectID,1)
		
		// >---  Image Id A revoir !!!!!!
		Object[ObjId].Stage[0].Imageid = -2 // reflectionID
		Object[ObjId].Stage[1].Imageid = -3 // RefractionID
		Object[ObjId].Stage[2].Imageid = img // dif
		Object[ObjId].Stage[3].Imageid = img // normal
		Object[ObjId].Stage[4].Imageid = -4 // DepthID
				
		SetObjectImage(WaterObjectID,ReflectionImageID,0)
		SetObjectImage(WaterObjectID,RefractionImageID,1)
		SetObjectImage(WaterObjectID,iWater[img].D,2)
		SetObjectImage(WaterObjectID,iWater[img].N,3)
		SetObjectImage(WaterObjectID,DepthImageID,4) 
		
		
		
		a = (50 * PlaneWidth )/1024
		SetObjectUVScale(WaterObjectID,0,a,a)
		//~ SetObjectColor(WaterObjectID,0.0,0.4,0.5,1.0) //To DO:  insert standard agk atribute into shader to mix it with the result
		SetObjectShader(WaterObjectID,WaterShaderID)
		
		StId = Object[ObjId].StageId
		Object[ObjId].Stage[StId].uvw = a
		Object[ObjId].Stage[StId].uvh = a
		Object[ObjId].name$ = "Water"
		Object[ObjId].shader = C_SHADERWATER 
		
		
		//Set Shader constant
		SetShaderConstantByName(WaterShaderID,"cameraRange",0.1,2000,0,0)
		
		Shiny as float
		Refl as float
		Shiny = 300
		Refl = 0.2
		SetShaderConstantByName(WaterShaderID,"shineDamper",Shiny,0,0,0)
		SetShaderConstantByName(WaterShaderID,"reflectivity",Refl,0,0,0)

		OBjTyp = OldTyp
	endif
	
endfunction



// sync the water shader 
function SyncWater()
	
	// SyncWater(TerrainShaderID,SunDirX#,SunDirY#,SunDirZ#,SunRed#,SunGreen#,SunBlue#)
	
	
	//Update3D(0)
	Render2DBack()
	ClearDepthBuffer()
	
	CameraX# = GetCameraX(1)
	CameraY# = GetCameraY(1)
	CameraZ# = GetCameraZ(1)
	CameraAngleX# = GetCameraAngleX(1)
	CameraAngleY# = GetCameraAngleY(1)
	CameraAngleZ# = GetCameraAngleZ(1)
	
	SetObjectVisible(WaterObjectID,0)
	SetObjectVisible(Grid,0)
	
	// To Do: make functions to add new objects to the system so you must not think about clipping planes and so on... just add it
	
	
	// 1* for every new object you must setup a shader with the clipping plane or you will get strange reflections in the water
	// render the refraction
	/*
	
	SetShaderConstantByName(5,"clippingPlane",0,1,0,-10)
	SetShaderConstantByName(TerrainShaderID,"clippingPlane",0,1,0,-2)
	SetRenderToImage(RefractionImageID,DepthImageID)
	ClearScreen()
	Render3D()
	
	SetCameraPosition(1,CameraX#,GWaterHeight#-(CameraY#-GWaterHeight#),CameraZ#)
	SetCameraRotation(1,-CameraAngleX#,CameraAngleY#,CameraAngleZ#)
	
	// 1* here too
	// render the reflection
	SetShaderConstantByName(5,"clippingPlane",0,1,0,GWaterHeight#)
	SetRenderToImage(ReflectionImageID,-1)
	ClearScreen()	
	*/

	// SetShaderConstantByName(5,"clippingPlane",0,1,0,-GWaterHeight#-1)
	SetRenderToImage(RefractionImageID,DepthImageID)
	ClearScreen()
	Render3D()

	SetCameraPosition(1,CameraX#,GWaterHeight#-(CameraY#-GWaterHeight#),CameraZ#)
	SetCameraRotation(1,-CameraAngleX#,CameraAngleY#,CameraAngleZ#)

	// 1* here too
	// render the reflection

	// SetShaderConstantByName(5,"clippingPlane",0,-1,0,GWaterHeight#)
	SetRenderToImage(ReflectionImageID,-1)
	ClearScreen()
	Update(0)
	Render3D() 



	Update(0)
	Render3D()
	
	SetCameraPosition(1, CameraX#, CameraY#, CameraZ#)
	SetCameraRotation(1, CameraAngleX#, CameraAngleY#, CameraAngleZ#)
	
	SetObjectVisible(WaterObjectID,1)
	SetObjectVisible(Grid,Options.ShowGrid)
	
	SetShaderConstantByName(5, "clippingPlane",0,-1,0,0)
	SetShaderConstantByName(WaterShaderID, "cameraPosition", CameraX#, CameraY#, CameraZ#, 0)
	
	SetShaderConstantByName(WaterShaderID, "lightVector", Sun.X, Sun.Y, Sun.Z, 0)
	SetShaderConstantByName(WaterShaderID, "lightColor", Sun.R, Sun.G, Sun.B, 0)
	
	// render the scene as normal
	SetRenderToScreen()
	Update(0)
	Render3D()
	ClearDepthBuffer()
	Render2DFront()
	Swap()
	
endfunction
