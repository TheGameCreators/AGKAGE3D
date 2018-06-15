
//****************** PanelGadget ******************************//

// add panel gadget
Function LAG_PanelGadget(id,x,y,w,h,miror)

	// chech for the id
    i = LAG_CheckIdGadget(id)

    // define some parameters (position, size...)
    LAG_SetGadgetDefault(i,x,y,w,h) // in LAg_gadget.agx

    // define the param for the gadget
    LAG_D_Gadget[i].Typ = LAG_c_typPanel // the typ

    LAG__depth = LAG_D_Gadget[i].depth

    // open the gagdet list
    LAG_OpenGadgetList(i, -1)

    If LAG_CurrGadgetItemId > -1
        LAG_D_Gadget[i].ItemId = LAG_CurrGadgetItemId 
        // -1 : panel is in another gadget like panel, container or scrollarea
    else
        LAG_D_Gadget[i].ItemId = -1
    endif


	// the image for the panel
    lag__img = LAG_i_Gadget[LAG_c_iPanel]
    lag__iw# = getImageWidth(lag__img)
    lag__ih# = getImageHeight(lag__img)


    // the Background of  the panel
    lag__img1 = LAG_i_Gadget[LAG_c_iBg]
   
    lag__h = 25
    LAG_D_Gadget[i].spr1 = LAG_AddSprite(lag__img1,LAG_D_Gadget[i].x-2, LAG_D_Gadget[i].y -lag__h ,LAG_D_Gadget[i].w+4, LAG_D_Gadget[i].h + lag__h + 10 , 1, lag__depth+2)
	LAG_D_Gadget[i].spr1x = -2
	LAG_D_Gadget[i].spr1y = -lag__h
	
	//Sp = LAG_D_Gadget[i].spr1
    //SetSpriteUVscale(sp, iw# / getSpriteWidth(sp), ih# / getSpriteHeight(sp))
    //SetSpriteFlip(sp,1-miror,0)
    
    
   

    // create the main sprite
    LAG_D_Gadget[i].id = LAG_AddSprite(lag__img,LAG_D_Gadget[i].x,LAG_D_Gadget[i].y ,LAG_D_Gadget[i].w,LAG_D_Gadget[i].h ,1,lag__depth)
    lag__Sp = LAG_D_Gadget[i].id
    SetSpriteUVscale(lag__sp, lag__iw# / getSpriteWidth(lag__sp), lag__ih# / getSpriteHeight(lag__sp))
    SetSpriteFlip(lag__sp,1-miror,0)

	// set the scissor for the panel
	LAG_SetGadgetScissor(lag__sp,i,-1,-1)
	
	
EndFunction i


// update a panel item
Function LAG_UpdatePanelGadget(GadgetId, itemId)

	
	// when clic on a panel : hide all panels, reveal the panel clicked
	
	
	// get the position of the current item (onglet panel) selected on the panel
	pos = LAG_D_GadgetItem[itemId].position
	
	For i = 0 to LAG_D_GadgetItem.length
		if LAG_D_GadgetItem[i].position = itemId-1 and LAG_D_GadgetItem[i].ParentID = GadgetId
			//pos = LAG_D_GadgetItem[i].position
			NewitemId = i
			exit
		endif
	NExt
	
	SetSpriteDepth(LAG_D_GadgetItem[ItemId].id, LAG_D_GadgetItem[ItemId].depth)
	LAG_SetGadgetState(GadgetId,pos) // set it active 
	
	
	// je rends invisible les gadgets  n'ayant pas le gadget item sélectionné.
	// then we "hide" all the other gadgets item
	for j = 1 to LAG_D_GadgetItem.length // LAG_V_NbGadgetItem
		if LAG_D_GadgetItem[j].parentId = GadgetId						
			if LAG_D_GadgetItem[j].position <> pos
				LAG_D_GadgetItem[j].depth = LAG_D_GadgetItem[j].depthmax+2
				SetSpriteDepth(LAG_D_GadgetItem[j].id,LAG_D_GadgetItem[j].depth)
			endif			
		endif
	next j



	//message("panel : "+str(LAG_D_GadgetItem[ItemId].ParentID)+"/"+str(GadgetId))
	
	
	

    // hide all the gadgets if they don't have the curritemId
    For i = 0 to LAG_v_NbGadget
		
        if LAG_D_Gadget[i].actif = 1
			
            if i <> GadgetId
               
                if LAG_D_Gadget[i].ParentId = LAG_D_GadgetItem[ItemId].ParentID
					
					//if LAG_D_Gadget[i].Typ = LAG_C_TYPLISTICON
						//message("list icon : "+LAG_D_GadgetItem[ItemId].Text$)
					//endif
					
					
					
                    if LAG_D_Gadget[i].ItemId <> ItemId
						
						// string gadget : inactive the editbox
						Select LAG_D_Gadget[i].Typ 
							case LAG_C_TYPSTRING
								// we need to test if the gadget item is an editbox, to inactived it
								LAG_ActiveStringGadget(i,0)
							endcase
						
							case LAG_C_TYPCONTAINER
								// Verify if this gadget is a container or a panel or another gadget with gadgetlist
								For k = 0 to LAG_D_Gadget.length
									if LAG_D_Gadget[k].ParentId  =i
										LAG_SetGadgetVisible(k,0)
									endif
								next
							endcase
								
						endselect
							
                        
                        if LAG_D_Gadget[i].visible = 1
                            LAG_SetGadgetVisible(i,0)
						
							
                            // hide the gadget item if the panel/listview/combobox... is inside this GadgetId
                            select LAG_D_Gadget[i].Typ
                                case LAG_C_TYPPANEL, LAG_C_TYPCOMBOBOX, LAG_C_TYPLISTICON, LAG_C_TYPLISTVIEW,LAG_C_TYPCONTAINER
                                    for j = 1 to LAG_D_GadgetItem.length // LAG_V_NbGadgetItem
                                         if LAG_D_GadgetItem[j].parentId =i
                                            LAG_SetGadgetItemVisible(j,0)
                                        endif
                                    next j
                                endcase
                            Endselect
                            
                            if LAG_D_Gadget[i].Typ = LAG_C_TYPLISTICON
								//message("update listicon in panel")
								LAG_UpdateDepthGadgetItem(i)
							endif
							
						endif	
                       
                        
                    endif
                    
                endif
                
            endif
            
        endif
        
    next i




    // reveal the gadget with the currItemId
    For i = 0 to LAG_v_NbGadget
       
        if LAG_D_Gadget[i].actif = 1
           
            if LAG_D_Gadget[i].ParentId = LAG_D_GadgetItem[ItemId].ParentID
                
                if LAG_D_Gadget[i].ItemId = ItemId
					
					// string gadget : active the editbox
					select LAG_D_Gadget[i].Typ 
						case  LAG_C_TYPSTRING
							// we need to test if the gadget item is an editbox, to actived it
							LAG_ActiveStringGadget(i,1)
						endcase
						
						case LAG_C_TYPCONTAINER
							// Verify if this gadget is a container or a panel or another gadget with gadgetlist
							For k = 0 to LAG_D_Gadget.length
								if LAG_D_Gadget[k].ParentId  =i
									 LAG_SetGadgetVisible(k,1)
								endif
							next
						endcase
						
					endselect
					
                    if LAG_D_Gadget[i].visible = 1
                        LAG_SetGadgetVisible(i,1)
                        
                        // reveal the gadget item if the panel/listview/combobox... is inside this GadgetId
                        select LAG_D_Gadget[i].Typ
                            case LAG_C_TYPPANEL, LAG_C_TYPCOMBOBOX,LAG_C_TYPLISTICON,LAG_C_TYPLISTVIEW
                                for j = 1 to LAG_V_NbGadgetItem
                                    if LAG_D_GadgetItem[j].parentId =i
                                        LAG_SetGadgetItemVisible(j,1)
                                    endif
                                next j
                            endcase
                        endselect
                        
                        if LAG_D_Gadget[i].Typ = LAG_C_TYPLISTICON
							LAG_UpdateDepthGadgetItem(i)
						endif
                    endif
                endif
            endif
        endif
    next i



EndFunction


Function Lag_ResetPanel(Gad)
	
	
	// To reset all gadgets of the current panel and will be ok to use
	
	state = LAg_GetGadgetState(gad)
	LAg_SetGadgetState(gad,0)
	LAg_SetGadgetState(gad,state)
	
endfunction
