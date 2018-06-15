


//****************** Gadgets ******************************//


// utilities for the gadgets
Function LAG_SetGadgetDefault(i,x,y,w,h)
	
	LAG_ResetGadget(i,0)

	LAG_D_Gadget[i].ItemId = -2
    LAG_D_Gadget[i].ParentId = -2
    LAG_D_Gadget[i].WindowId = -2
    
	LAG_D_Gadget[i].originX  = x 
    LAG_D_Gadget[i].originy  = y 
    
    
    if LAG_CurrGadgetId > 0 // we have a gadgetlist opened

        LAG_D_Gadget[i].ItemId = LAG_CurrGadgetItemId // the gadget keep the gadgetitem
        LAG_D_Gadget[i].ParentId = LAG_CurrGadgetId // the gadget keep the gadgetid of this gadgetitem (a panel for example)
        
        // LAG_D_Gadget[i].ParentId =LAG_D_GadgetItem[LAG_CurrGadgetItemId].ParentID  // same as before
        
        LAG_D_Gadget[i].originX  = x +5
        LAG_D_Gadget[i].originy  = y +5
        
        GadgetListId = LAG_CurrGadgetId // the current gadget id because a gadgetlist is opened
        x = x + LAG_D_Gadget[GadgetListId].x + 5 // x and y are relative to the gadget of the gadgetlist
        y = y + LAG_D_Gadget[GadgetListId].y + 5
        depth = 1 //LAG_D_Gadget[GadgetListId].depth
        
        //keep the parent Pos X & Y; it's needed if we move the parentgadget for example
        LAG_D_Gadget[i].ParentX = LAG_D_Gadget[GadgetListId].x //+ 5
		LAG_D_Gadget[i].ParentY = LAG_D_Gadget[GadgetListId].y //+ 5 
        
    else
        LAG_D_Gadget[i].ItemId  = -2
        LAG_D_Gadget[i].ParentId = -2
    endif
   
    
    LAG_D_Gadget[i].WindowId = LAG_CurrentWindow
    // if we are creating the gadgets in a window
    if LAG_CurrentWindow > 0
		
		LAG_D_Gadget[i].winX = Lag_Window[LAG_CurrentWindow].x + 5
		LAG_D_Gadget[i].WinY = Lag_Window[LAG_CurrentWindow].Y + Lag_Window[LAG_CurrentWindow].h1 
		x = x + Lag_Window[LAG_CurrentWindow].x + 5
		y = y + Lag_Window[LAG_CurrentWindow].y + Lag_Window[LAG_CurrentWindow].h1 	
		Depth = 99	
		
	endif
	
    LAG_D_Gadget[i].x = x 
    LAG_D_Gadget[i].y = y   
    
    LAG_D_Gadget[i].w = w
    LAG_D_Gadget[i].h = h
    LAG_D_Gadget[i].actif = 1
    LAG_D_Gadget[i].visible = 1
    LAG_D_Gadget[i].depth = 100 - depth


	// message("LAG_CurrGadgetId/LAG_CurrentWindow (LAG_SetGadgetDefault) : "+str(LAG_CurrGadgetId)+"/"+str(LAG_CurrentWindow))



EndFunction


Function LAG_CheckIdGadget(id)
	
	LAG_V_NbGadget = LAG_D_Gadget.length

	// to verify if the gadget is created dynamically or not
    if id > -1 // not dynamic

        if LAG_D_Gadget.length <= id
            LAG_V_NbGadget = id
            Global dim LAG_D_Gadget[LAG_V_NbGadget] as LAG_t_Gadget // add a new element in the array of gadgets
        endif
        //we have to erase all the gadget parameters
        LAG_FreeGadget(id) // reset the gadget
        GadgetID = id

    else // partially dynamic, don't use this method for the moment, it's not finished
        
        inc LAG_V_NbGadget // increment the number of gadgets
        
        //LAG_D_Gadget.length = LAG_D_Gadget.length + 1
        //LAG_V_NbGadget = LAG_D_Gadget.length
        GadgetID = LAG_V_NbGadget // the new id of the gadget created
        Global dim LAG_D_Gadget[LAG_V_NbGadget] as LAG_t_Gadget // add  a new element in the array of gadgets
    endif

EndFunction GadgetID

