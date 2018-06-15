
//************************ EventType ***************************//


Function LAG_EventType()

    LAG_Event_Type = -1

	Vx = GetViewOffsetX()
	Vy = GetViewOffsetY()	
	z# = GetViewZoom()
	
	Lag_pause(0,0,1) // dans lag_window.agc
	
    Lag_X = getPointerX() // -GetScreenBoundsRight()
    Lag_Y = getPointerY() // -GetScreenBoundsTop()

	// print(str(Lag_X)+"/"+str(Lag_y)+" : "+str(LAG_NumSpId))
	
   
    
	
	If Lag_MousePressed = 0
		
		if LAG_OldX <> Lag_X or LAG_OldY <> Lag_Y		
			LAG_OldX = Lag_X
			LAG_OldY = Lag_Y
			LAG_Event_Type = LAG_c_EventTypeMouseMove
		endif
		
		if getPointerPressed()
			Lag_MousePressed = 1
		//if LAG_Event_Type = -1 or LAG_Event_Type = LAG_c_EventTypeMouseReleased
			LAG_Event_Type = LAG_c_EventTypeMousePressed
		//endif
		endif
		
	elseif Lag_MousePressed = 1		
		if getPointerState()		
			LAG_Event_Type = LAG_c_EventTypeMouse
		endif	
    endif
    
    //if LAG_Event_Type =-1
		if getPointerReleased()
			LAG_Event_Type = LAG_c_EventTypeMouseReleased
			Lag_MousePressed = 0			
		endif
   // endif
    
    if LAG_Event_Type =-1
		for i = KEY_0 to KEY_9
			if GetRawKeystate(i)		
				LAG_Event_Type = LAG_C_EVENTTYPEKEYPRESSED
			endif	
			if GetRawKeyReleased(i)		
				LAG_Event_Type = LAG_C_EVENTTYPEKEYRELEASED
			endif
		NExt
	endif 
	
	if LAG_Event_Type =-1
		if GetRawKeystate(Key_enter) or GetRawKeystate(KEY_BACK) or GetRawKeystate(KEY_DELETE)		
			LAG_Event_Type = LAG_C_EVENTTYPEKEYPRESSED
		endif	
		if GetRawKeyReleased(Key_enter) or GetRawKeystate(KEY_BACK) or GetRawKeystate(KEY_DELETE)				
			LAG_Event_Type = LAG_C_EVENTTYPEKEYRELEASED
		endif	
	endif

    if LAG_Event_Type >-1
		
		// je dois cacher le sprite de selection du menu, pour ne pas qu'on clique dessus
		if LAG_MenuOpen >= 1
			sp = LAG_d_menu[LAG_v_CurrMenuId].SpSelect
			if GetSpriteExists(sp)
				SetSpriteDepth(sp, 10000)
			endif
		endif
		
        //LAG_NumSpId = GetSpriteHitGroup(LAG_group,Lag_X, Lag_Y)
        LAG_NumSpId = GetSpriteHit(Lag_X, Lag_Y)
        
        // puis, je décache le sprite 
        if LAG_MenuOpen >= 1
			if GetSpriteExists(sp)
				if GetSpriteExists(sp)
					SetSpriteDepth(sp, 0)
				endif
			endif
		endif
		
		// on n'a pas cliqué sur un sprite, on vérifie les editbox
        if LAG_NumSpId = 0
			//LAG_NumSpId = GetCurrentEditBox()
		endif
		if LAG_NumSpId = 0
			LAG_NumSpId = -1
		endif
    endif

	Lag_pause(vx,vy,z#)
	
	
	
EndFunction


