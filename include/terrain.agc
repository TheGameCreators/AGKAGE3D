//**************** terrain **********************//


Type tTerrain
	
	// issu du fichier
	Desc$
	Detail$
	ReceiveShadow as integer
	Heightmap$ 
	ShaderFile$
	ShaderName$
	
	W as integer
	H as integer
	L as integer
	UvScale as integer
	Split as integer
	Smooth as integer
	
	// id : shader, image
	ShaderId
	Image as integer[4]
	
EndType



Function InitTerrain()
	
	Global dim Terrain[0] as tTerrain // les presets des terrains, j'en mets un de base
	Global TerrainId as integer
	TerrainId = 0
	
Endfunction



Function OpenWindowTerrain()
	
	
	FoldStart // Create the Window
	w = 400
	h = 600
	OldAction = action
	Action = C_ACTIONSELECT
	Lag_OpenWindow(C_WINBehavior,G_width/2-w/2,g_height/2-h/2,w,h,"Terrain generation",0)
	
	// then, Add the gadget for the behavior editor
	w1 = 80 : h1 = 30
	
	//LAG_ButtonGadget(C_Gad_BehaviorOk,w-w1-10,h-h1-5,w1,h1,"OK",0)
	xx = 10 : yy = 10
	//LAG_ListIconGadget(C_Gad_ListBehavior,xx,yy,250,300) : yy=yy +310 
	LAG_ButtonGadget(C_Gad_BehaviorOk,xx,yy,w1,h1,"Ok",0) : xx = xx + w1 +5
	LAG_ButtonGadget(C_Gad_BehaviorCancel,xx,yy,w1,h1,"Cancel",0)
	
	

	Foldend
	
	
	repeat
				
	
		eventwindow = LAG_EventWindow()
		LAG_EventType()
		
		if eventwindow = LAG_C_CloseWindow or GetRawKeyPressed(Key_escape)
			Quit = 1
		
		else // if eventwindow = LAG_C_EventGadget
			
			eventgadget = LAg_eventgadget()
					
			If GetPointerReleased() or LAG_Event_Type = LAG_C_EVENTTYPEMOUSERELEASED					
				
				select eventgadget 
					case C_Gad_BehaviorOk
						//if AssetTyp = C_ASSETOBJ						
							//if ObjId >-1 and ObjId<= object.length
								// AddBehavior(0)
								quit = 2
							//endif
						//endif
					endcase
					case C_Gad_BehaviorCancel
						quit = 1
						/*
						if AssetTyp = C_ASSETOBJ						
							if ObjId >-1 and ObjId<= object.length
								//DeleteBehavior(0)
							endif
						endif
						*/
					endcase
				endselect
			endif
			
		endif
		
		EventBehavior()
					
		sync()
		
	until quit>= 1
		
	FoldStart 
		
		LAG_CloseWindow(C_WINBehavior)
		//action = OldAction
		
	FoldEnd
	
	
	if quit = 2
	
	CreateTerrain(Options.TerrainFile$)
	ObjTyp =C_OBJBox
	
	
	endif
	
	
	
EndFunction




//Terrain construction 
Function Addterrain(x,y,z,option$)

	/*
	For Terrain :
	Option$ = Heightmap$+","img$+",shader,uvscale,w,h,l,smooth,split,"
	img$ ="img0;img1;img2;..."
	*/
	ObjTyp = C_OBJTERRAIN
	AddObjet(x,y,z,option$)
	
	/*
	CreateObjectFromHeightMap("Mexico.png", 768, 50, 768, 1, 16 )
	SetObjectImage(n, img, 0 )
	SetObjectUVScale(n, 0, uvscale ) // scale the detail texture so it repeats
	SetObjectShader(n, shader)
	*/

Endfunction
	
Function CreateTerrain(file$)
	
	
	// d'abord, on charge les informations du terrain
	LoadTerrain(file$)
	
	ok = 0
	
	// puis, on crée la texture si elle n'existe pas
	SetGenerateMipmaps(1)
	For i=0 to Texture.length
		if Texture[i].Filename$ = Terrain[TerrainId].detail$
			ok = 1
			Terrain[TerrainId].Image[0] = Texture[i].img
			Texture[i].used = 1
			exit
		endif
	next
	if ok = 0
		id = AddTextureToBank(Terrain[TerrainId].Detail$,1,1)
		Terrain[TerrainId].Image[0] = texture[id].img
	endif
	

	// load the terrain shader to give the terrain color based on height
	ok = 0
	For i=0 to ShaderBank.length
		if ShaderBank[i].Filename$ = Terrain[TerrainId].ShaderFile$
			Terrain[TerrainId].ShaderId = ShaderBank[i].Shader
			ShaderBank[i].used = 1
			ok = 1
			exit
		endif
	next
	if ok =0
		Terrain[TerrainId].ShaderId = AddShaderToBank(Terrain[TerrainId].ShaderFile$,1,Terrain[TerrainId].ShaderName$)
	endif
	
	// create the terrain object from a height map
	/*
	For Terrain :
	Option$ = Heightmap$+","img$+",shader,uvscale,w,h,l,smooth,split,"
	img$ ="img0;img1;img2;..."
	*/
	d$ =","
	if Terrain[TerrainId].Heightmap$ <> ""
		option$ = Terrain[TerrainId].Heightmap$+d$
		img$ = str(Terrain[TerrainId].Image[0])+";" // pour le moment, une seule image !!
		option$ = option$ + img$+d$
		option$ = option$ + str(Terrain[TerrainId].ShaderId)+d$
		option$ = option$ + str(Terrain[TerrainId].UvScale)+d$
		option$ = option$ + str(Terrain[TerrainId].W)+d$
		option$ = option$ + str(Terrain[TerrainId].H)+d$
		option$ = option$ + str(Terrain[TerrainId].L)+d$
		option$ = option$ + str(Terrain[TerrainId].Smooth)+d$
		option$ = option$ + str(Terrain[TerrainId].Split)+d$
		AddTerrain(0,0,0,option$)
	endif
	/*
	CreateObjectFromHeightMap( 1, "Mexico.png", 768, 50, 768, 1, )
	SetObjectImage( 1, 1, 0 )
	SetObjectUVScale( 1, 0, 128, 128 ) // scale the detail texture so it repeats
*/
	
	
EndFunction

Function LoadTerrain(file$)


	if GetFileExists(file$)
		
		f = OpenToread(file$)
		Path$ = GetPathPart(file$)
		
		while FileEOF(f)=0
			
			line$ = ReplaceString(ReadLine(f)," ","",-1)
			
			Index1$ = GetStringToken(line$,"=",1)
			Index2$ = GetStringToken(line$,"=",2)
			
			Select index1$
				case "detail"
					Terrain[TerrainId].detail$ = Path$+index2$
				endcase
				case "heightmap"
					Terrain[TerrainId].Heightmap$ = Path$+index2$
				endcase
				case "shader"
					Terrain[TerrainId].ShaderFile$ = Path$+index2$
					Terrain[TerrainId].ShaderName$ = index2$
				endcase
				
				case "uvscale"
					Terrain[TerrainId].uvscale = val(index2$)
				endcase
				case "width"
					Terrain[TerrainId].w = val(index2$)
				endcase
				case "height"
					Terrain[TerrainId].h = val(index2$)
				endcase
				case "length"
					Terrain[TerrainId].l = val(index2$)
				endcase
				case "smooth"
					Terrain[TerrainId].Smooth = val(index2$)
				endcase
				case "split"
					Terrain[TerrainId].Split = val(index2$)
				endcase
				case "receiveshadow"
					Terrain[TerrainId].ReceiveShadow = val(index2$)
				endcase
				
				
			endselect
			
		endwhile
		
		Closefile(f)
		
	endif


EndFunction 


