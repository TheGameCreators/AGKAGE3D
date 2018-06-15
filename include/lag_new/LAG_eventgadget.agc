

//******************* Event Gadgets / update

Function LAG_EventGadget()
	
	
	
	// verify the eventtype (mouse clic, pressed, released...)
    if LAG_Event_Type > -1 // and LAG_Event_Menu = -1
		
		ok = 0
        // first, verify the gadgetItem
        if LAG_Event_Type = LAG_c_EventTypeMousePressed
			
            for j = 1 to LAG_D_GadgetItem.length 
				
                if LAG_NumSpId = LAG_D_GadgetItem[j].id or LAG_NumSpId = LAG_D_GadgetItem[j].spr1
                   
                    EventGadget = LAG_D_GadgetItem[j].ParentID
                    GadgetItem = j 
                   
                    exit
                    
                else
					
					// check if we click on another image of this gadget
					for kk=0 to LAG_D_GadgetItem[j].spr.length
						
						if LAG_NumSpId = LAG_D_GadgetItem[j].spr[kk].id
							EventGadget = LAG_D_GadgetItem[j].ParentID
							GadgetItem = j 
							GadgetItemImg = kk // for layers for example
							ok = 1
							exit
						endif
						
					next
					
					// we have clicked on an image extra, we exit the loop
					if ok=1
						exit
					endif
					
                endif
                
            next j
       
        endif


       FoldStart  // verify if we move outside any gadget, for button/buton image/buton custom
        
        //if LAG_Event_Type = LAG_c_EventTypeMouseMove or LAG_Event_Type = LAG_c_EventTypeMouseReleased
        if LAG_Event_Type = LAG_c_EventTypeMouseReleased
            
            For i = 1 to LAG_D_Gadget.length 
				
				if LAG_D_Gadget[i].actif = 1
					
					Select LAG_D_Gadget[i].Typ
						
						case LAG_c_typButton, LAG_c_typButtonImage, LAG_c_typButtonCustom                        
							
							if LAG_d_Gadget[i].option1 = 0
								LAG_d_Gadget[i].state = 0
								LAG_SetGadgetState(i,LAG_d_Gadget[i].state)
							endif
							
						endcase
						
					endselect
					
                endif
                
            next i
        endif
        
		Foldend
		

        // and verify the gadget, if event on gadgetitem = 0
        if EventGadget = 0
			
			// verify the eventtype : keypressed (stringgadget for exemple)
			//if LAG_Event_Type = LAG_C_EVENTTYPEKEYPRESSED or LAG_Event_Type = LAG_C_EVENTTYPEKEYRELEASED
				
			//endif
			
            For i = 1 to LAg_d_Gadget.length 
				
				if LAG_D_Gadget[i].actif = 1
					
					FoldStart //verify if we have touch slider/ element of slider for listicon
					
					// on touche un bouton pour l'ascenceur haut ou bas
					othersp = -1
					if LAG_D_Gadget[i].Typ = LAG_C_TYPLISTICON or LAG_D_Gadget[i].Typ = LAG_C_TYPEDITOR
						
						if LAG_d_Gadget[i].IsPressed = 0
							
							if LAG_event_Type = LAG_C_EVENTTYPEMOUSEPRESSED							
								for j= 0 to LAG_d_Gadget[i].spr.length
									if LAG_NumSpId = LAG_d_Gadget[i].spr[j].id
										otherSp = j
										LAG_d_Gadget[i].IsPressed = 1									
										exit
									endif
								next								
							endif
							
						elseif LAG_d_Gadget[i].IsPressed = 1
								
							for j= 0 to LAG_d_Gadget[i].spr.length
								if LAG_NumSpId = LAG_d_Gadget[i].spr[j].id
									otherSp = j								
									exit
								endif
							next								
						
						endif
						
					endif
					
					Foldend
					
					
					// to test the gadget, we test if the sprite has been touched or clicked
					if LAG_NumSpId = LAG_d_Gadget[i].id or LAG_NumSpId = LAG_d_Gadget[i].spr1 or LAG_NumSpId = LAG_d_Gadget[i].EditBoxId or otherSp >= 0

						EventGadget = i

						// then we do an action by the typ of gadget				
						Select LAG_D_Gadget[i].Typ

							case LAG_c_typTrackbar
								// trackbar (slider) event
								if LAG_Event_Type <> LAG_c_EventTypeMouseMove and LAG_Event_Type <> LAG_C_EVENTTYPEKEYPRESSED and LAG_Event_Type <> LAG_C_EVENTTYPEKEYRELEASED
									
									x = GetpointerX()
									//x1 = GetspriteX(LAG_d_Gadget[i].id) // LAG_d_Gadget[i].x 
									x1 = GEtTextX(LAG_d_Gadget[i].NameId)
									
									if x >= x1 + len(LAG_d_Gadget[i].name$)*7  and x <= x1+LAG_d_Gadget[i].w+ len(LAG_d_Gadget[i].name$)*7
										// the new position of the cursor (of slider)
										newxst = x - x1
										ech = LAG_d_Gadget[i].maxi - LAG_d_Gadget[i].mini
										unit# = ech/LAG_d_Gadget[i].w
										// unit2# = 
										// update the state of the trackbar ( = position of the cursor)
										LAG_d_Gadget[i].state = (newxst- len(LAG_d_Gadget[i].name$)*7)*unit#
										if LAG_d_Gadget[i].state < LAG_d_Gadget[i].mini
											LAG_d_Gadget[i].state = LAG_d_Gadget[i].mini
										endif
										if LAG_d_Gadget[i].state > LAG_d_Gadget[i].maxi
											LAG_d_Gadget[i].state = LAG_d_Gadget[i].maxi
										endif
										
										y =getspritey(LAG_d_Gadget[i].id)
										
										SetSPritePosition(LAG_d_Gadget[i].spr1,newxst+x1-4,y-LAG_d_Gadget[i].h2/2+LAG_d_Gadget[i].h/2)
										
										
										//SetSPritePosition(LAG_d_Gadget[i].spr1,newxst+x1-4,LAG_d_Gadget[i].y- LAG_d_Gadget[i].h/2)
										
										LAG_D_Gadget[i].Spr1X = newxst // +x1-4 
										
										LAG_D_Gadget[i].CurX = (newxst- len(LAG_d_Gadget[i].name$)*7)
										// if we draw the info the new value of the slider
										if LAG_d_Gadget[i].option1 = 1 
											LAG_SetGadgetText(i, "("+str(LAG_d_Gadget[i].state)+")")
										endif
										
									endif
									
								endif
								
							endcase

							case LAG_c_typImage
								// if LAG_Event_Type = LAG_c_EventTypeMousePressed
									// here a code for imagegadget
								// endif
							endcase
							
							case LAG_C_TYPLISTICON, LAG_C_TYPEDITOR
								
								//print("OtherSp   : "+str(OtherSp))
								Select OtherSp // c'est le bouton slider haut ou bas ?
									
									case  0 // slider central
										
										if LAG_event_Type = LAG_C_EVENTTYPEMOUSEPRESSED 
											if LAG_d_Gadget[i].IsPressed = 0
												LAG_d_Gadget[i].StartY = GetpointerY() - LAG_d_Gadget[i].y +LAG_d_Gadget[i].CurY + LAG_d_Gadget[i].WinY
												LAG_d_Gadget[i].IsPressed = 2
											endif									
										endif 
							
										if LAG_d_Gadget[i].IsPressed = 2										
											LAG_d_Gadget[i].CurY = (GetpointerY() - LAG_d_Gadget[i].y +LAG_d_Gadget[i].CurY + LAG_d_Gadget[i].WinY )- LAG_d_Gadget[i].StartY
										endif
										
									endcase
									
									case 1	// haut							
										LAG_d_Gadget[i].CurY = LAG_d_Gadget[i].CurY - LAG_C_SPEEDLISTICONY
									endcase
									
									case 2	//bas									
										LAG_d_Gadget[i].CurY  = LAG_d_Gadget[i].CurY + LAG_C_SPEEDLISTICONY
									endcase
									
								endselect
									
								if LAG_d_Gadget[i].IsPressed >= 1
										
									if LAG_D_Gadget[i].typ = LAG_C_TYPLISTICON
										
										LAg__H = LAG_D_Gadget[i].h2 // LAG_d_Gadget[i].ItemH 
										
										if LAG_d_Gadget[i].CurY < 0
											LAG_d_Gadget[i].CurY = 0
											
										elseif LAG_d_Gadget[i].CurY > (LAG_d_Gadget[i].NbGadgetItem-1)*(LAg__H-1)
											LAG_d_Gadget[i].CurY = (LAG_d_Gadget[i].NbGadgetItem-1)*(LAg__H-1) 
											
										endif
									
										For g = 0 to LAG_D_GadgetItem.length
											
											if LAG_D_GadgetItem[g].ParentID = i
												
												h = LAG_D_GadgetItem[g].h
												n = LAG_D_GadgetItem[g].spr1
												ny = LAG_D_GadgetItem[g].Y - LAG_d_Gadget[i].CurY
												nx = GetSpriteX(n)
												SetSpritePosition(n,GetSpriteX(n),ny)
												
												n = LAG_D_GadgetItem[g].id
												SetSpritePosition(n,getspriteX(n),ny)
												
												hh = h/4
												
												if LAG_D_GadgetItem[g].attribute = LAg_ListIcon_DisplayMode
													if LAG_D_GadgetItem[g].attributeValue >= LAg_ListIcon_SmallIcon	
														hh = 0
													endif
												endif	
												
												n = LAG_D_GadgetItem[g].Textid
												ny = LAG_D_GadgetItem[g].textY - LAG_d_Gadget[i].CurY
												SetTextPosition(n,GetTExtX(n),ny)
												
												For kk=0 to LAG_D_GadgetItem[g].spr.length
													n1 = LAG_D_GadgetItem[g].spr[kk].id
													SetSpritePosition(n1, GetSpriteX(n1), ny + hh)
												next
												
											endif
										next
									
									else 
										
										FoldStart // editor
										n= LAG_D_Gadget[i].Textid
										
										if LAG_d_Gadget[i].CurY < 0
											LAG_d_Gadget[i].CurY = 0 											
										else
											hh = GetTextTotalHeight(n)- LAG_d_Gadget[i].h
											if hh > 0						
												if LAG_d_Gadget[i].CurY > hh					
													LAG_d_Gadget[i].CurY = hh
												endif
											else
												LAG_d_Gadget[i].CurY  = 0
												/*
												if LAG_d_Gadget[i].CurY > GetTextTotalHeight(n)/2
													LAG_d_Gadget[i].CurY = GetTextTotalHeight(n)/2
												endif
												*/
											endif
										endif
										
										SetTextPOsition(n,GetTExtX(n),LAG_D_Gadget[i].Y-LAG_d_Gadget[i].CurY)
										
										foldend
										
									endif		
								endif
									
								if LAG_event_Type = LAG_C_EVENTTYPEMOUSERELEASED
									
									LAG_d_Gadget[i].IsPressed = 0
									
								endif
								
							endcase
							
							case LAG_c_typCombobox
								// combobox event
							endcase

							case LAG_c_typCheckBox
								if LAG_Event_Type = LAG_c_EventTypeMousePressed
									LAG_d_Gadget[i].state = 1-LAG_d_Gadget[i].state
									LAG_SetGadgetState(i,LAG_d_Gadget[i].state)
								endif
							endcase

							case LAG_c_typButton, LAG_c_typButtonImage, LAG_c_typButtonCustom
								if  LAG_d_Gadget[i].option1 = 1 // a toggle button
									if LAG_Event_Type = LAG_c_EventTypeMousePressed
										LAG_d_Gadget[i].state = 1 - LAG_d_Gadget[i].state
										LAG_SetGadgetState(i,LAG_d_Gadget[i].state)
									endif
								else // a normal button
									if LAG_Event_Type = LAG_c_EventTypeMousePressed
										LAG_d_Gadget[i].state = 1
										LAG_SetGadgetState(i,LAG_d_Gadget[i].state)
									//elseif LAG_Event_Type = LAG_c_EventTypeMouseReleased
										//LAG_d_Gadget[i].state = 0
										//LAG_SetGadgetState(i,LAG_d_Gadget[i].state)
										//Sync()
									endif
								endif

							endcase

							case LAG_C_TYPSTRING
								
							endcase 
							
							case LAG_C_TYPPANEL
								// je dois annuler car les seuls event sur le panel sont les clics sur les onglets :)
								EventGadget = -1
							endcase 
							
						endselect

						exit
					endif
					
                endif
                
            next i
			
			if LAG_Event_Type = LAG_C_EVENTTYPEmouseReleased
				For i=0 to LAG_d_Gadget.length
					LAG_d_Gadget[i].IsPressed =0
				next
			endif
			
        else
			
            i = EventGadget // we have touch a GadgetItem
            k = GadgetItem
            
			// en fonction du type
			if LAG_D_Gadget[i].Actif = 1
				
				Select LAG_D_Gadget[i].Typ

                case LAG_c_typPanel
                    if LAG_D_GadgetItem[k].parentId = i                        
                        LAG_UpdatePanelGadget(i, k)
                    endif
                endcase
                
                case LAG_C_TYPLISTICON
					
					// we touch an item of the list, so the color of the sprite should be changed 	
					For g= 0 to LAG_D_GadgetItem.length
						if LAG_D_GadgetItem[g].ParentID = i
							n = LAG_D_GadgetItem[g].id
							IF GetSpriteExists(n) and n > 10000
								SetSpriteColor(n,30,30,30,150)
							endif
						endif
					next
					
					// si c'est une list-icon, je récupère l'item sur lequel on a cliqué		
					if LAG_D_GadgetItem[k].parentId = i
						g = LAG_D_GadgetItem[k].position    
						LAG_SetGadgetState(i,g)
						
						n = LAG_D_GadgetItem[k].id
						IF GetSpriteExists(n) and n > 10000
							u=80
							SetSpriteColor(n,u,u,u,150)
						endif						
					endif	
				endcase
				
            Endselect
			
			endif
			
        endif
        



    endif


EndFunction EventGadget
