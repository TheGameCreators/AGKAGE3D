
//********************* physic : object, world... *******************************//


// SetPhysicToObject(i) see Object.agc


Function OpenWindowObjPhysic()
	
	
	FoldStart // Create the Window
	w = 400
	h = 600
	
	OldAction = action
	Action = C_ACTIONSELECT
	
	x = options.WindowBehavior.X
	y = options.WindowBehavior.Y
	if x = 0
		x = G_width/2-w/2
	endif
	if y = 0 
		y = g_height/2-h/2
	endif
	Lag_OpenWindow(C_WINPhysic,x,y,w,h,"Physic",0)
	
	// then, Add the gadget for the behavior editor
	w1 = 80 : h1 = 30
	
	//LAG_ButtonGadget(C_Gad_BehaviorOk,w-w1-10,h-h1-5,w1,h1,"OK",0)
	x = 10 : yy = 10 : b=3 : h3 = 20
	
	
	StrPhysic = LAG_StringGadget(-1,x,yy,100,h3,"Physic ",str(Object[ObjId].Physic)) : yy=yy+h3+b
	LAg_SetGadgetTooltip(StrPhysic,"Set the physic to object. 0 = no physic, 1 = static, 2 = dynamic, 3 = kinematic.")
	StrShape = LAG_StringGadget(-1,x,yy,100,h3,"Shape ",str(Object[ObjId].Shape)) : yy=yy+h3+b
	LAg_SetGadgetTooltip(StrShape,"Set the physic shape to object. 0 = object, 1 = box, 2 = sphere.")
	StrMass = LAG_StringGadget(-1,x,yy,100,h3,"Mass ",str(Object[ObjId].mass)) : yy=yy+h3+b
	LAg_SetGadgetTooltip(StrMass,"Set the physic mass to object.")

	
	LAG_ButtonGadget(C_Gad_BehaviorOk,xx,yy,w1,h1,"Apply",0) : xx = xx + w1 +5
	LAG_ButtonGadget(C_Gad_BehaviorCancel,xx,yy,w1,h1,"Cancel",0)

	
	
	Foldend
	
	
	repeat // the main loop for the windo. Not necessary if we get the gadget envent in the main program loop
		
		eventwindow = LAG_EventWindow()
		LAG_EventType()
		
		
		
		if eventwindow = LAG_C_CloseWindow or GetRawKeyPressed(Key_escape)
			Quit = 1
			
			options.WindowPhysic.x = LAG_GetWindowX(C_WINPhysic)		
			options.WindowPhysic.Y = LAG_GetWindowY(C_WINPhysic)

		else // if eventwindow = LAG_C_EventGadget
			
			eventgadget = LAg_eventgadget()
			ToolTipsEvent(getpointerX(),getpointerY())		
					
			if EventGadget <> 0 								
				// main window								
				CreateToolTips(getPointerX(),getPointerY(),EventGadget)	
			endif	
					
			If GetPointerReleased() or LAG_Event_Type = LAG_C_EVENTTYPEMOUSERELEASED					
				
				select eventgadget 
					
					case C_Gad_BehaviorOk
						
						For i=0 to object.length
							if object[i].selected = 1 and object[i].Locked = 0
								Object[i].Shape = 1 // val(LAG_GetGadgetText(StrShape)) // test, temporaire, je dois définir le shape
								Object[i].Physic = val(LAG_GetGadgetText(StrPhysic))
								SetPhysicToObject(i,0)
								//n = object[i].obj
								//SetObject3DPhysicsMass(n,val(LAG_GetGadgetText(StrMass)))
							endif
						next
						
						
					endcase
					
					case C_Gad_BehaviorCancel
						
						For i=0 to object.length
							if object[i].selected = 1 and object[i].Locked = 0
								Object[i].Shape = 0
								Object[i].Physic =0
								SetPhysicToObject(i,0)
								n = object[i].obj
								//SetObject3DPhysicsMass(n,0)
							endif
						next
						
						
					endcase
					
				endselect
			endif
		endif
		
		/*
		IF Options.physicOn = 1
			Step3DPhysicsWorld()
		endif
		*/
		
		Sync()
		
	Until Quit >=1
	
	
	FoldStart // close the window, erase its contents (gadgets, sprite, text...)
	 
		// LAg_FreeItemFromList(C_Gad_ListBehavior)
		
		
		// delete the other item
		// for i=0 to BehaviorPreset.length //LAG_D_GadgetItem.length
			// Lag_FreeGadgetItem(C_Gad_ListBehavior,i)
		// next 		
		//Lag_FreeGadgetItem(C_Gad_ListBehavior,BehaviorPreset.length)
		
		
		LAG_CloseWindow(C_WINPhysic)
		Action = oldaction
		
		
	FoldEnd
	
	
EndFunction
