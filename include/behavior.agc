

//*********************** behavior // comportement *************************//

/*

Behavior are for futur gameplay. They are behavior for object, for example :
- rotate object in axis
- scale object in axis
- move object in axis, with speed, loop, start-end...

other object would be more complicated :
- follow a path (platformer obstacle)
- bonus object (destroyobject, increase variable (life, money, stronge...))
- enemy ai 
- NPC Ai
- scripts ?

*/


type tBehaviorAxis
	//Axis as integer[2] // 0 =x,1=y,2=, if =0 no movvement
	x as float
	y as float
	z as float

Endtype

Type tBehaviorPreset
	
	Name$
	ScriptFileName$ // if I use LUA script as name ?
	Typ as integer // 0 = automatic move, 1= automatic rotate, 2= automatic scale,20 = info on txt file
	
	// Looping as integer
	Delay as integer 
	Loopz as integer
	
	From#
	To#
	Event as integer // the event hthat start the behavior -1 : no event
	Orient as integer // the orientation (global, local)
	
	// transformations
	Speed as float	
	Pos as tBehaviorAxis
	Rot as tBehaviorAxis
	Scale as tBehaviorAxis
	
EndType

Type tBehavior

	Preset as tBehaviorPreset
	Typ as integer
	ObjId as integer[] // the id of the objects using this behavior (several objects can use the same behavior)
	AssetTyp as integer // the typ of asset for this behavior
	Active as integer
	
Endtype



// init
Function InitBehavior()
	
	
	Global dim BehaviorPreset[15] as tBehaviorPreset
	SetBehaviorPreset(0,"Rotation on X")
	SetBehaviorPreset(1,"Rotation on Y")
	SetBehaviorPreset(2,"Rotation on Z")
	SetBehaviorPreset(3,"Scale on X")
	SetBehaviorPreset(4,"Scale on Y")
	SetBehaviorPreset(5,"Scale on Z")
	SetBehaviorPreset(6,"Motion on X")
	SetBehaviorPreset(7,"Motion on Y")
	SetBehaviorPreset(8,"Motion on Z")
	
	// Player behavior only
	SetBehaviorPreset(9,"Player Keyboard")
	SetBehaviorPreset(10,"Player Mouse")
	SetBehaviorPreset(11,"Player Joystick")
	
	
	Global dim Behavior[] as tBehavior // the behavior copy the behavior from object in this list to execute them.

EndFunction

Function SetBehaviorPreset(i,name$)
	
	//to setup a behavior preset : that's a behavior pre-made, to use it immediatly
	if i>BehaviorPreset.length
		BehaviorPreset.length = i
	endif
	
	BehaviorPreset[i].Name$ =name$
	BehaviorPreset[i].typ = i
	
EndFunction


//open window
Function OpenWindowBehavior()
	
	
	FoldStart // Create the Window
	w = 700
	h = 500
	OldAction = action
	Action = C_ACTIONSELECT
	x = options.WindowBehavior.X
	y = options.WindowBehavior.Y
	/*
	if x = 0
		x = G_width/2-w/2
	endif
	if y = 0 
		y = g_height/2-h/2
	endif
	*/
	
	if x = 0
		x = G_width/2-w/2 +GetScreenBoundsLeft()
	endif
	if y = 0 
		y = G_height/2-h/2 +GetScreenBoundsTop()
	endif
	
	Lag_OpenWindow(C_WINBehavior,x,y,w,h,"Behavior",0)
	

	
	
	// then, Add the gadget for the behavior editor
	w1 = 80 : h1 = 30
	
	//LAG_ButtonGadget(C_Gad_BehaviorOk,w-w1-10,h-h1-5,w1,h1,"OK",0)
	xx = 10 : yy = 10
	LAG_ListIconGadget(C_Gad_ListBehavior,xx,yy,250,300) : yy=yy +310 
	
	
	xx = xx + 260 : yy = 10
	LAG_ListIconGadget(C_Gad_BehaviorObj,xx,yy,250,300) : yy=yy +310 

	
	LAG_ButtonGadget(C_Gad_BehaviorOk,xx,yy,w1,h1,"Add",0) : xx = xx + w1 +5
	LAG_ButtonGadget(C_Gad_BehaviorCancel,xx,yy,w1,h1,"Delete",0)
	
	

	
	
	//  add the gadgetitem for preset behavior
	For i=0 to BehaviorPreset.length
		//message(BehaviorPreset[i].Name$)
		LAG_AddgadgetItem(C_Gad_ListBehavior, i, BehaviorPreset[i].Name$,0)
	next
	
	//then add the other gadget item , from the presets list (txt)
	// LAg_AddItemToListIcon("behavior","txt",C_Gad_ListBehavior) // not finished :)
	
	LAG_UpdateDepthGadgetItem(C_Gad_ListBehavior)
	
	
	// I add the gadgetitem for preset behavior
	UpdateBehaviorObj()
	
	
	Foldend
	
	
	repeat // the main loop for the windo. Not necessary if we get the gadget envent in the main program loop
				
		eventwindow = LAG_EventWindow()
		LAG_EventType()
		
		
		
		if eventwindow = LAG_C_CloseWindow or GetRawKeyPressed(Key_escape)
			Quit = 1
			
			options.WindowBehavior.X = LAG_GetWindowX(C_WINBehavior)		
			options.WindowBehavior.Y = LAG_GetWindowY(C_WINBehavior)

		else // if eventwindow = LAG_C_EventGadget
			
			eventgadget = LAg_eventgadget()
					
			If GetPointerReleased() or LAG_Event_Type = LAG_C_EVENTTYPEMOUSERELEASED					
				
				select eventgadget 
					
					case C_Gad_BehaviorOk
						//if AssetTyp = C_ASSETOBJ				
							if pos <= BehaviorPreset.length
								AddBehaviorToAsset(Pos,"")
							else
								For i=0 to object.length
									if object[i].selected =1 and object[i].locked = 0
										
										// objID = i										
										// AddBehavior(pos,"") 
																			
										info$=LoadBehaviorInfo(BehaviorFile$)								
										AddBehaviorToAssets2(info$)
										
									endif
								next
							endif
						//endif
					endcase
					
					case C_Gad_BehaviorCancel
						if pos <= BehaviorPreset.length
							DelBehaviorFromAsset(Pos)
						else
							if AssetTyp = C_ASSETOBJ						
								//if ObjId >-1 and ObjId<= object.length
									// DeleteBehavior()
								For i=0 to object.length
									if object[i].selected =1 and object[i].locked = 0
										if pos <= BehaviorPreset.length
											// on supprime le behavior pour cet objet
											For k =0 to Behavior.length
												if Behavior[k].Typ = pos
													for j=0 to Behavior[k].ObjId.length
														if Behavior[k].ObjId[j] = i
															Behavior[k].ObjId.remove(j)
															if j >0
																j=j-1
															endif
														endif
													next
												endif
											next
											//for j =0 to Object[i].Behavior.length
												//if Object[i].Behavior[j].Typ = BehaviorPreset[pos].Typ
													//Object[i].Behavior[j].active
													//exit
												//endif
											//next
										endif
									endif
								next	
								//endif
							endif
						endif
					endcase
				endselect
			
			elseif GetRawMouseLeftPressed() or LAG_Event_Type = LAG_c_EventTypeMousePressed 	
				
				if eventgadget = C_Gad_ListBehavior
					pos = LAG_getgadgetstate(C_Gad_ListBehavior)
					BehaviorFile$ = LAg_GetGadgetItemText(C_Gad_ListBehavior,pos)
				endif
			
			endif
			
		endif
		
		EventBehavior()
					
		sync()
		
	until quit>= 1
	
			
	FoldStart // close the window, erase its contents (gadgets, sprite, text...)
	 
		// LAg_FreeItemFromList(C_Gad_ListBehavior)
		
		/*
		// delete the other item
		for i=0 to BehaviorPreset.length //LAG_D_GadgetItem.length
			Lag_FreeGadgetItem(C_Gad_ListBehavior,i)
		next 		
		//Lag_FreeGadgetItem(C_Gad_ListBehavior,BehaviorPreset.length)
		*/
		
		
		Lag_FreeAllGadgetItemByGadget(C_Gad_ListBehavior)
		Lag_FreeAllGadgetItemByGadget(C_Gad_BehaviorObj)


		LAG_CloseWindow(C_WINBehavior)
		action = OldAction
		
		
		
	FoldEnd
	
	
	// LAG_ActiveWindowId =-1
	
EndFunction


// update
Function UpdateBehaviorObj()
	
	For i=0 to Behavior.length // Scene[sceneId].Object[objID].Behavior.length
		for j=0 to Behavior[i].ObjId.length
			if Behavior[i].ObjId[j] = objID
				//id = Scene[sceneId].Object[objID].Behavior[i].Preset.
				k = Behavior[i].Typ
				Name$ = BehaviorPreset[k].Name$
				LAG_AddgadgetItem(C_Gad_BehaviorObj,i,Name$,0)
				exit
			endif
		next
	next
	LAG_UpdateDepthGadgetItem(C_Gad_BehaviorObj)
	
endfunction







// Add
Function SetObjectBehaviorPAram(i,transform,axis,active,speed#,from#,to#,loopz,delay,typ,orient,event)

	// transform = 0 : move, = 1 rot, 2 = scale

	// set the behavior parmeters to object
	n = object[i].Behavior.length + 1
	object[i].Behavior.length = n
					
	// set the parameters
	object[i].Behavior[n].Active = active
	object[i].Behavior[n].Typ = typ
	
	Select Transform
		case 0
			if axis = 0
				object[i].Behavior[n].Preset.Pos.x = 1
			elseif axis = 1	
				object[i].Behavior[n].Preset.Pos.y = 1
			elseif axis = 2		
				object[i].Behavior[n].Preset.Pos.z = 1
			endif
		endcase
		case 1 // rotation
			if axis = 0
				object[i].Behavior[n].Preset.rot.x = 1
			elseif axis = 1	
				object[i].Behavior[n].Preset.rot.y = 1
			elseif axis = 2		
				object[i].Behavior[n].Preset.rot.z = 1
			endif
		endcase
		case 2
			if axis = 0
				object[i].Behavior[n].Preset.Scale.x = 1
			elseif axis = 1	
				object[i].Behavior[n].Preset.Scale.y = 1
			elseif axis = 2		
				object[i].Behavior[n].Preset.Scale.z = 1
			endif
		endcase
	endselect
	
	object[i].Behavior[n].Preset.Delay = delay				
	object[i].Behavior[n].Preset.Speed = speed#				
	object[i].Behavior[n].Preset.Loopz = loopz				
	object[i].Behavior[n].Preset.Typ = typ				
	object[i].Behavior[n].Preset.from# = from#				
	object[i].Behavior[n].Preset.To# = to#				
	object[i].Behavior[n].Preset.orient = orient			
	object[i].Behavior[n].Preset.event = event			
	
	
	
	// then the bahavior to behavior list
	/*
	option$ = "objid,asset,axis,active,speed#,from#,to#,loopz,delay,typ,orient,event)
	*/
	option$= str(i)+","+str(C_ASSETOBJ)+","+str(axis)+","+str(active)+","+str(speed#,4)+","+str(from#,2)+","+str(to#,2)+","+str(loopz)
	option$ =option$ +","+str(delay)+","+str(typ)+","+str(orient)+","+str(event)
	AddBehavior(typ,option$)
 
EndFunction
	
Function AddBehaviorToAssets2(file$)
	
	info$ = LoadBehaviorInfo(file$)
	/*
	; rot=axis,active,speed,from-to,loop,delay,typ,orientation,event,
	; axis : 0=x,1=y,2=z / speed of the rotation (float)
	; from-to : angle start, angle end / loop : number of repeat (0=infinite) / delay : between each rotation / typ : ping-pong, linear.../ orientation : local(0)/global(1), event : the event which start the rot_y : -1 (no event).
	*/
					
	// set the behavior to the selected objects
	For i=0 to object.length
		if object[i].Selected
			
			
			index$ = getstringtoken(info$,"=",1)
			Select index$
				case "rot","rotation","position","pos","scale"
					
					u=2
					axis 	=  val(getstringtoken(info$,"=",u)) : inc u
					active 	=  val(getstringtoken(info$,"=",u)) : inc u
					speed# 	=  valfloat(getstringtoken(info$,"=",u)) : inc u
					fromto$ =  getstringtoken(info$,"=",u) : inc u
					from# 	=  valfloat(getstringtoken(fromto$,"-",1))
					to# 	=  valfloat(getstringtoken(fromto$,"-",2))
					loopz 	=  val(getstringtoken(info$,"=",u)) : inc u
					delay 	=  val(getstringtoken(info$,"=",u)) : inc u
					typ 	=  val(getstringtoken(info$,"=",u)) : inc u
					orient  =  val(getstringtoken(info$,"=",u)) : inc u
					event   =  val(getstringtoken(info$,"=",u)) : inc u
					
					if index$ = "rot" or index$ = "rotation"
						transform = 1
					elseif index$ = "pos" or index$ = "position"
						transform = 0
					elseif index$ = "scale"
						transform = 2
					endif
					SetObjectBehaviorParam(i,transform,axis,active,speed#,from#,to#,loopz,delay,typ,orient,event)
				endcase
										
			endselect
			
		endif
	next
	
	// set the behavior to the selected objects
	for i=0 to light.length
	
	next
	
Endfunction

Function AddBehaviorToAsset(typ,option$)
	
	// to add a behavior to an asset (object, light...)
	
	/*
	option$ = "active,axis,speed#,from#,to#,loop_,delay,orient,event)
	*/
	// add a behavior to an asset (object, light)
	For i=0 to object.length
		
		if object[i].selected
			
			// on vérifie si on n'a pas un behavior de libre
			ok = 0
			For j=0 to Object[i].Behavior.length
				if Object[i].Behavior[j].Active = 0
					ok =1
					n=j
					exit
				endif
			next
			
			if ok = 0
				n = object[i].Behavior.length + 1
				object[i].Behavior.length = n
			endif
			
			if option$ <> ""
				u=1
				//obj 	= val(GetStringToken(option$,",",u)) : inc u 
				// Asset 	= val(GetStringToken(option$,",",u)) : inc u 
				// typ 	= val(GetStringToken(option$,",",u)) : inc u 
				Object[i].Behavior[n].Active = val(GetStringToken(option$,",",u)) : inc u 
				axis = val(GetStringToken(option$,",",u)) : inc u 
				Select axis
					//Object[i].Behavior[n].Preset.Pos.x 
				endselect
			else
				Object[i].Behavior[n].Active = 1
			endif
			
			Object[i].Behavior[n].Typ = Typ
			
			
			if Typ >= 9 and typ<=11
				For j=0 to object.length
					Object[j].IsPlayer=0
				next
				
				Object[i].IsPlayer=1
			endif
			
			
		endif
	next
	
	// set the behavior to the selected lights
	for i=0 to light.length
	
	next
	
	
EndFunction

Function DelBehaviorFromAsset(typ)
	
	For i=0 to object.length
		
		if object[i].selected
			
			For j=0 to Object[i].Behavior.length
				if Object[i].Behavior[j].Typ = typ
					Object[i].Behavior.remove(j) // [j].Active = 0
				endif
			next
			
		endif
	next
	
	// set the behavior to the selected lights
	for i=0 to light.length
	
		
	
	next
	

	
EndFunction

Function AddBehavior(typ,option$)
	
	
	// to add a behavior (in the game)
	
	/*
	option$ = "obj,asset,axis,active,speed#,from#,to#,loop_,delay,typ,orient,event)
	*/
	
	
	// check if we have a free behavior
	For i=0 to Behavior.length
		if Behavior[i].active =0
			Behavior[i].ObjId.length = -1 // on supprime les objets du behavior
			ok =1	
			exit		
		endif
	next
	
	// no behavior free
	if ok=0
		i = Behavior.length+1
		Global dim Behavior[i] as tBehavior
	endif
	
	Obj = ObjId
	Asset = AssetTyp
	active = 1
	
	if option$ <> ""
		u=1
		obj 	= val(GetStringToken(option$,",",u)) : inc u 
		// Asset 	= val(GetStringToken(option$,",",u)) : inc u 
		typ 	= val(GetStringToken(option$,",",u)) : inc u 
		active 	= val(GetStringToken(option$,",",u)) : inc u 
	endif
	
	n = Behavior[i].ObjId.length+1
	Behavior[i].ObjId.length = n
	Behavior[i].ObjId[n] = Obj
	Behavior[i].AssetTyp = Asset
	Behavior[i].Typ = Typ
	Behavior[i].active = active
	
EndFunction

Function LoadBehaviorInfo(file$)

	fil=OpenToRead("behavior/"+file$)
	if fil
		
		while FileEOF(fil)=0
			
			line$ = readline(fil)
			index$ = replacestring(getstringtoken(line$,"=",1)," ","",-1)
			Select index$
				case "rot","rotation"
					info$ = info$ + line$ + chr(13)
				endcase
				case "position","pos"
					info$ = info$ + line$ + chr(13)
				endcase
				case "scale"
					info$ = info$ + line$ + chr(13)
				endcase
				
			endselect
			
		endwhile
			
		closefile(fil)
	else	
		
	endif

EndFunction info$










// delete
Function DeleteBehaviorFromAssets()
	
Endfunction

Function DeleteBehavior(i)
	
	if i <= Behavior.length
		Behavior[i].active =0
	endif
	
EndFunction

Function DeleteAllbehavior()
	
	Global dim Behavior[] as tBehavior
	
EndFunction
	


// Event in the editor or game
Function EventBehavior()

	// the event for the behaviors, only if a behavior is active
	
	if object.length >=0 or light.length>-1
		
		For i =0 to behavior.length
			
			if behavior[i].active = 1
				
				if Behavior[i].typ <=20	
					
					Select Behavior[i].typ
						// rotation
						case 0						 
							if Behavior[i].AssetTyp = C_ASSETOBJ
								for j=0 to Behavior[i].ObjId.length
									n = Object[Behavior[i].ObjId[j]].obj
									RotateObjectLocalX(n,1)
								next
							else
								
							endif
						endcase
						case 1
							if Behavior[i].AssetTyp = C_ASSETOBJ
								for j=0 to Behavior[i].ObjId.length
									n=Object[Behavior[i].ObjId[j]].obj
									RotateObjectLocalY(n,1)
								next
							else
								
							endif
						endcase
						case 2
							if Behavior[i].AssetTyp = C_ASSETOBJ
								for j=0 to Behavior[i].ObjId.length
									n=Object[Behavior[i].ObjId[j]].obj
									RotateObjectLocalZ(n,1)
								next
							else
								
							endif
						endcase
						// scale
						case 3,4,5 // need from - to scale
							if Behavior[i].AssetTyp = C_ASSETOBJ
								for j=0 to Behavior[i].ObjId.length
									id = Behavior[i].ObjId[j]
									n = Object[id].obj
									s# = Object[id].Size								
									sx# = Object[id].sx	* s#							
									sy# = Object[id].Sy	* s#						
									sz# = Object[id].Sz	* s#							
									
									if Behavior[i].typ = 3
										Object[id].sx = Object[id].sx + 1
										
									elseif Behavior[i].typ = 4
										Object[id].sy = Object[id].sy + 1
									else
										Object[id].sz = Object[id].sz + 1
									endif
									SetObjectScale(n,sx#,sy#,sz#)
								next
							else
								
							endif
						endcase
						
						// position
						case 6,7,8
							/*
							if Behavior[i].AssetTyp = C_ASSETOBJ
								for j=0 to Behavior[i].ObjId.length
									id = Behavior[i].ObjId[j]
									n = Object[id].obj
									
									if Behavior[i].typ = 6
										if Object[id].x >Behavior[i].Preset.To#
											//Object[id].dir											
										endif
										//Object[id].x = Object[id].x +Object[id].dir
									elseif Behavior[i].typ = 7
										//Object[id].y = Object[id].y + dir 
									else
										//Object[id].z = Object[id].z + dir 
									endif
									px# = Object[id].x								
									py# = Object[id].y							
									pz# = Object[id].z								
									//SetObjectPosition(n,px#,py#,pz#)
									
								next
							else
								
							endif
							*/
						endcase
						
						
					endselect
						
				endif
				
			endif
			
		next
	
	endif
	
EndFunction


