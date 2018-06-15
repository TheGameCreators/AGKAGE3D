


//******************* Set the gadgets informations

function LAG_SetGadgetFont(id,fontId,size,color,alpha)

    // color can be rgb(r,g,b)
    // fontId must be a loaded image

    SetTextSize(LAG_D_Gadget[id].TextId, size)
    LAG_D_Gadget[id].TextSize = size
    r=Red(color)
    g=Green(color)
    b=Blue(color)
    SetTextColor(LAG_D_Gadget[id].TextId,r,g,b,alpha)
    SetTextPosition(LAG_D_Gadget[id].TextId, LAG_D_Gadget[id].x+LAG_D_Gadget[id].w/2,LAG_D_Gadget[id].y+LAG_D_Gadget[id].h/2-size/2)

EndFunction



// State
function LAG_SetGadgetState(id,state)

    LAG_D_Gadget[id].state = state
	
    Select LAG_D_Gadget[id].Typ

        case LAG_c_typPanel

            for i = 0 to LAG_V_NbGadgetItem

                if LAG_D_GadgetItem[i].ParentID = id
					
					lag__x1 = LAG_D_GadgetItem[i].x1
					
					
                    if LAG_D_GadgetItem[i].position = LAG_D_Gadget[id].state                        
                        lag__y = LAG_D_Gadget[id].y - 21
                    else						
                        lag__y = LAG_D_Gadget[id].y - 18
                    endif
                    lag__x = LAG_D_GadgetItem[i].x + lag__x1
                    lag__Spr = LAG_D_GadgetItem[i].id
                    SetSpritePosition(lag__spr,lag__x,lag__y)
                    
                    lag__w = GetSpriteWidth(lag__spr)                    
                    lag__H = GetSpriteHeight(lag__spr)                    
                    lag__spr = LAG_D_GadgetItem[i].Textid                    
                    SetTextPosition(lag__spr,lag__x+lag__w*0.5,lag__y)
					SetTextScissor(lag__spr,lag__x ,lag__y,lag__x+lag__w,lag__y+lag__h)
                endif
            next i

        endcase

        case LAG_c_typCheckbox
			
			if state >1
				state= 1
			elseif state<0
				state=0
			endif
			
			SetSpriteImage(LAG_D_Gadget[id].id, LAG_i_Gadget[LAG_c_iCheckbox+state])
			
        endcase

        case LAG_c_typButton
			if GetSpriteExists(LAG_D_Gadget[id].id) = 0
				// message(LAG_D_Gadget[id].Name$+"/"+LAG_D_Gadget[id].Text$+"/"+str(id))
				// message(LAG_D_Gadget[id].TextBox$+"/"+LAG_D_Gadget[id].Text$+"/"+str(id))
			endif
            SetSpriteImage(LAG_D_Gadget[id].id, LAG_D_Gadget[id].image[state])
            
            //SetSpritePosition(LAG_D_Gadget[id].id,LAG_D_Gadget[id].x,LAG_D_Gadget[id].y)            //SetTextPosition(LAG_D_Gadget[id].textid,LAG_D_Gadget[id].x+state+LAG_D_Gadget[id].w/2,LAG_D_Gadget[id].y+state+LAG_D_Gadget[id].h/2-GetTextSize(LAG_D_Gadget[id].textid)/2)
        endcase

        case LAG_c_typButtonImage
            //SetSpriteImage(LAG_D_Gadget[id].id, LAG_i_Gadget[LAG_c_iButton+state])
            SetSpriteImage(LAG_D_Gadget[id].id, LAG_D_Gadget[id].image[state])
            //SetSpritePosition(LAG_D_Gadget[id].spr1,LAG_D_Gadget[id].spr1X+state,LAG_D_Gadget[id].spr1y+state)
        endcase

        case LAG_c_typButtonCustom
            if state = 0
                SetSpriteImage(LAG_D_Gadget[id].id, LAG_D_Gadget[id].image1)
            else
                SetSpriteImage(LAG_D_Gadget[id].id, LAG_D_Gadget[id].image2)
            endif
        Endcase

        case LAG_c_typImage
            SetSpriteImage(LAG_D_Gadget[id].id,state)
        endcase

        case LAG_c_typTrackbar
			
            ech = LAG_d_Gadget[id].maxi - LAG_d_Gadget[id].mini
            pos# = state 
            pos# = pos# / ech 
            w1 = GetImageWidth(LAG_i_Gadget[LAG_c_iTrackbar2])          
            posx = getspriteX(LAG_D_Gadget[id].id) -(w1*0.5)
            x# = posx + (pos#*LAG_d_Gadget[id].w) 
            
            if x# > getspriteX(LAG_D_Gadget[id].id) + LAG_d_Gadget[id].w + w1*0.5
				x# = getspriteX(LAG_D_Gadget[id].id) + LAG_d_Gadget[id].w + w1*0.5
			endif
			
            LAG_D_Gadget[id].CurX = (pos#*LAG_d_Gadget[id].w) 
            LAG_D_Gadget[id].Spr1X = x#
            
            SetSpriteposition(LAG_D_Gadget[id].spr1,x#,LAG_D_Gadget[id].spr1Y)
            
            if LAG_d_Gadget[id].option1 = 1 // if we draw the info the new value of the slider
				LAG_SetGadgetText(id, "("+str(LAG_d_Gadget[id].state)+")")
			endif
			
        Endcase
		 
    endselect

EndFunction



// Attribute
/*
Voir LAg_GadgetItem.Agc
function Lag_SetGadgetAttribute(id, value)
	
	// to set an attribute to the gadget, for example, change the list icon form (large, middle, small icon list, or array)
	
	oldvalue = LAG_D_Gadget[id].attribute 
	LAG_D_Gadget[id].attribute = value
	 
	Select  LAG_D_Gadget[id].typ 
		
		case LAG_C_TYPLISTICON
			if value <> oldvalue
				
				
			endif
		endcase 
		
	endselect
	 
Endfunction
*/



// text & images
function LAG_SetGadgetText(id,txt$)

    LAG_D_Gadget[id].text$ = txt$
	
    Select  LAG_D_Gadget[id].typ

        case LAG_c_typString
			//message(str(LAG_D_Gadget[id].EditBoxId)+"/"+str(id)+"/"+txt$)
            SetEditBoxText(LAG_D_Gadget[id].EditBoxId,txt$)
        endcase
        
        case LAG_c_typeditor
			if LAG_d_Gadget[id].option1 = 1 // readonly = 1
				SetTextString(LAG_D_Gadget[id].TextId,txt$)
			else
				SetEditBoxText(LAG_D_Gadget[id].EditBoxId,txt$)
			endif
        endcase

        case default
            SetTextString(LAG_D_Gadget[id].TextId,txt$)
        endcase

    endselect

EndFunction

function LAG_SetGadgetName(id,txt$)

    LAG_D_Gadget[id].Name$ = txt$
    SetTextString(LAG_D_Gadget[id].NameId,txt$)

EndFunction



// Size 
Function LAG_SetGadgetSize(id, x, y, w, h, Textsize)


    // Textsize = the textsize
    
    
    FoldStart //***************** stock the old position & verify the new position
	LAG__oldx 	= LAG_D_Gadget[id].x
	LAG__oldy 	= LAG_D_Gadget[id].y
	LAg__Typ 	= LAG_D_Gadget[id].Typ 
	
	
	// Set the new position and size
    LAG_D_Gadget[id].x = LAG_Ignore(LAG_D_Gadget[id].x, x)
    LAG_D_Gadget[id].y = LAG_Ignore(LAG_D_Gadget[id].y, y)
	LAG_D_Gadget[id].w = LAG_Ignore(LAG_D_Gadget[id].w, w)
    LAG_D_Gadget[id].h = LAG_Ignore(LAG_D_Gadget[id].h, h)
   
	if LAG_D_Gadget[id].ParentID> -1		
		//lag_id = LAG_D_Gadget[id].ParentID
		//lag_x0 = LAG_D_Gadget[lag_id].x //+ LAG_D_Gadget[id].ParentX 
		//lag_x0 = LAG_D_Gadget[id].ParentX 
		//lag_y0 = LAG_D_Gadget[lag_id].y //+ LAG_D_Gadget[id].ParentY 
		//lag_y0 = LAG_D_Gadget[id].ParentY 
		//message("change size gad (parent) : "+str(LAG_D_Gadget[id].ParentID)+"/"+str(LAG_D_Gadget[lag_id].x)+"/"+str(LAG_D_Gadget[lag_id].Y))
	endif
	FoldEnd
	
	
	
	Foldstart //***************** d'abord, je bouge tous les sprites et text du gadgets
	
	x = LAG_D_Gadget[id].x //+ lag_x0
	y = LAG_D_Gadget[id].y //+ lag_y0
   
	// new position of main sprite
    SetSpriteSize(LAG_D_Gadget[id].id, LAG_D_Gadget[id].w,LAG_D_Gadget[id].h)    
    SetSpritePosition(LAG_D_Gadget[id].id,x,y)
    
    //  SetTextSize(LAG_D_Gadget[id].textid,LAG_D_Gadget[id].w,LAG_D_Gadget[id].h)
    
    
    n = LAG_D_Gadget[id].spr1
	if GetSpriteExists(n)
		//w2 = GetSpriteWidth(n)*0.5
		SetSpritePosition(n,LAG_D_Gadget[id].spr1x+x,LAG_D_Gadget[id].spr1y+y)
		
		select LAG_D_Gadget[id].Typ 
			//case  LAG_C_TYPCONTAINER
			//endcase
			case  LAG_C_TYPPanel
				SetSpriteSize(n, LAG_D_Gadget[id].w+4,LAG_D_Gadget[id].h+31)
				SetSpritePosition(n,x-2,y-25)
			endcase
			
		endselect
		
	endif
		
	// puis je bouge les autres sprites	
	for k=0 to Lag_D_gadget[id].Spr.length
		n = LAG_D_Gadget[id].spr[k].id
		x1 = LAG_D_Gadget[id].spr[k].x -LAg__oldx + x
		y1 = LAG_D_Gadget[id].spr[k].y -LAg__oldy + y
		SetSpritePosition(n,x1,y1)
	NExt
	
	Foldstart // text  & name
	n = LAG_D_Gadget[id].TextId
	if GetTextExists(n)		   
		LAG_D_Gadget[id].TextSize = LAG_Ignore(LAG_D_Gadget[id].TextSize,Textsize)
		textsize = LAG_D_Gadget[id].TextSize 
		SetTextPosition(n,LAG_D_Gadget[id].x+LAG_D_Gadget[id].w*0.5,LAG_D_Gadget[id].y+LAG_D_Gadget[id].h*0.5-Textsize*0.5)
		LAG_D_Gadget[id].TextX = LAG_D_Gadget[id].x+LAG_D_Gadget[id].w*0.5
		LAG_D_Gadget[id].TextY = LAG_D_Gadget[id].y+LAG_D_Gadget[id].h*0.5-Textsize*0.5
	endif

	n = LAG_D_Gadget[id].NameId
	if GetTextExists(n)		   
		//LAG_D_Gadget[id].TextSize = LAG_Ignore(LAG_D_Gadget[id].TextSize,Textsize)
		//textsize = LAG_D_Gadget[id].TextSize 
		SetTextPosition(n,LAG_D_Gadget[id].x+LAG_D_Gadget[id].w*0.5,LAG_D_Gadget[id].y+LAG_D_Gadget[id].h*0.5-Textsize*0.5)
		//LAG_D_Gadget[id].TextX = LAG_D_Gadget[id].x+LAG_D_Gadget[id].w*0.5
		//LAG_D_Gadget[id].TextY = LAG_D_Gadget[id].y+LAG_D_Gadget[id].h*0.5-Textsize*0.5
	endif
	
	foldend
	
	Foldend
	
	
	
	FOldStart //***************** puis je bouge les autres gadgets contenu dans ce gadgets
	
	// move the gadgets with this gadget as parentId (example : move the gadgets in a panel gadget) 
	select LAG_D_Gadget[id].Typ 
		
		case  LAG_C_TYPCONTAINER, LAG_C_TYPPANEL
			
			For i =0 to LAG_D_Gadget.length
				
				If LAG_D_Gadget[i].ParentID = id
					
					x1 = x - LAG_D_Gadget[i].ParentX 
					y1 = y - LAG_D_Gadget[i].ParentY 
					
					w = LAG_D_Gadget[id].w
					h = LAG_D_Gadget[id].h
					
					
					FoldStart //trackbar
					if LAG_D_Gadget[i].typ = LAG_C_TYPTRACKBAR
						
						// barre
						n = LAG_D_Gadget[i].id
						xa = LAG_D_Gadget[i].NameX + x1 + LAG_D_Gadget[i].OriginX 
						ya = LAG_D_Gadget[i].y + y1
						SetSpritePosition(n,xa,ya)
						SetSpriteScissor(n,x,y,x+w,y+h)
						
						// slider
						n = LAG_D_Gadget[i].spr1
						//nx = gettextx(LAG_D_Gadget[i].nameid)
						w2 = GetSpriteWidth(n)*0.5
						xa = LAG_D_Gadget[i].NAmeX-w2+x1+LAG_D_Gadget[i].OriginX+LAG_D_Gadget[i].CurX 		
						SetSpritePosition(n,xa,LAG_D_Gadget[i].spr1y + y1)						
						SetSpriteScissor(n,x,y,x+w,y+h)
							
						n = LAG_D_Gadget[i].TextId
						if GetTextExists(n)
							SetTExtPosition(n,LAG_D_Gadget[i].TextX+x1+10,LAG_D_Gadget[i].TextY+y1)
							SetTExtScissor(n,x,y,x+w,y+h)
						endif
					foldend
					
					else
						
						n = LAG_D_Gadget[i].id						
						xa = LAG_D_Gadget[i].x + x1					
						ya = LAG_D_Gadget[i].y + y1
						wa = LAG_D_Gadget[i].w						
						ha = LAG_D_Gadget[i].h						
						SetSpritePosition(n,xa,ya)
						SetSpriteScissor(n,x,y,x+w,y+h)
							
						n = LAG_D_Gadget[i].spr1
						if GetSpriteExists(n)
							// SetSpriteSize(n, LAG_D_Gadget[id].w+4,LAG_D_Gadget[id].h+31)							
							SetSpritePosition(n,LAG_D_Gadget[i].spr1x+x1,LAG_D_Gadget[i].spr1y+y1)
							SetSpriteScissor(n,x,y,x+w,y+h)
						endif
						
						n = LAG_D_Gadget[i].TextId
						if GetTextExists(n)
							SetTExtPosition(n,LAG_D_Gadget[i].TextX+x1,LAG_D_Gadget[i].TextY+y1)
							//SetTExtScissor(n,x,y,x+w,y+h)
							SetTExtScissor(n,xa,ya,xa+wa,ya+ha)
						endif
					endif
					
					
					n = LAG_D_Gadget[i].nameid
					if GetTextExists(n)
						SetTExtPosition(n,LAG_D_Gadget[i].NameX+x1,LAG_D_Gadget[i].NameY+y1)
						SetTExtScissor(n,x,y,x+w,y+h)
					endif
					
					n = LAG_D_Gadget[i].EditBoxId
					if GetTextExists(n)
						SetEditBoxPosition(n,LAG_D_Gadget[i].TextX+x1+4,LAG_D_Gadget[i].TextY+y1)
						SetEditBoxScissor(n,x,y,x+w,y+h)
					endif
					
					// then we stock the new position of the parent gadget
					//LAG_D_Gadget[i].ParentX =x
					//LAG_D_Gadget[i].ParentY =y 
					
					// puis je bouge les autres sprites	
					for k=0 to Lag_D_gadget[i].Spr.length
						n = LAG_D_Gadget[i].spr[k].id
						x2=LAG_D_Gadget[i].spr[k].x + x1 //-oldx+x
						y2=LAG_D_Gadget[i].spr[k].y + y1 //-oldy+y
						SetSpritePosition(n,x2,y2)
						SetSpriteScissor(n,x,y,x+w,ya+h)
					NExt

					// puis, j'update les items si c'est le gadget contenu dans le gadget est une listicon/container
					Select Lag_D_gadget[i].Typ
						 
						case LAG_C_TYPLISTICON // , LAG_C_TYPPANEL, LAG_C_TYPCOMBOBOX
							LAG_UpdatePositionItem(i,xa,ya)	
							LAG_UpdateDepthGadgetItem(i)
						Endcase
						  
						case LAG_C_TYPCONTAINER
							// LAG_SetGadgetSize(i, x, y, w, h, Textsize)
							// ok for gadget not for container AR !! 
						endcase
						
					endselect
					
				endif
				
			next
		
		endcase
		
		case LAG_C_TYPLISTICON
			
			LAG_UpdatePositionItem(id,x,y)
			/*
			For i=0 to Lag_D_Gadget.Length
			
				If LAG_D_Gadget[i].ParentID = id
					
					
					//x1 = x - LAG_D_Gadget[i].ParentX 
					//y1 = y - LAG_D_Gadget[i].ParentY 
					
					//w = LAG_D_Gadget[id].w
					//h = LAG_D_Gadget[id].h 
					
					//ox = LAG_D_Gadget[id].x
					//oy = LAG_D_Gadget[id].y
					//LAG_UpdatePositionItem(i,x,y)
					
				
				endif
			
			Next
			*/
		Endcase
		
	endselect
	
	FoldEnd
	

	
	FoldStart //then update the position of gadgetitem (for panel, listIcon)
	
	if LAg_D_gadget[id].typ = LAG_C_TYPPANEL or  LAg_D_gadget[id].typ = LAG_C_TYPLISTICON
		
		For i=0 to LAG_D_GadgetITem.length
			
			if  LAG_D_GadgetItem[i].ParentID = id
				
				
				//If LAG_D_GadgetItem[i].Typ = LAG_C_TYPCONTAINER
				
					
				
				//else
					
					FoldStart 	
					
				LAg__x1 = X - LAg__oldX
				LAg__y1 = Y - LAg__oldy 
				
				LAg__w = LAG_D_Gadget[id].w
				LAg__h = LAG_D_Gadget[id].h
				
				// main sprite
				LAg__x2 = LAG_D_GadgetItem[i].x  + LAg__x1
				LAg__y2 = LAG_D_GadgetItem[i].y  + LAg__y1
				n = LAG_D_GadgetItem[i].id
				SetSpritePosition(n, LAg__x2, LAg__y2)
				//SetSpriteScissor(n,x,y,x+w,y+h)
					
				// panel
				/*
				lag__x1 = LAG_D_GadgetItem[i].x1
				
				// 
				
				if LAG_D_GadgetItem[i].position = LAG_D_Gadget[id].state                        
					lag__y = LAG_D_Gadget[id].y - 21
				else						
					lag__y = LAG_D_Gadget[id].y - 18
				endif
				// 
				lag__x = LAG_D_GadgetItem[i].x + lag__x1
				lag__Spr = LAG_D_GadgetItem[i].id
				SetSpritePosition(lag__spr,lag__x,lag__y)
				
				lag__w = GetSpriteWidth(lag__spr)                    
				lag__H = GetSpriteHeight(lag__spr)                    
				lag__spr = LAG_D_GadgetItem[i].Textid                    
				SetTextPosition(lag__spr,lag__x+lag__w*0.5,lag__y)
				SetTextScissor(lag__spr,lag__x ,lag__y,lag__x+lag__w,lag__y+lag__h)	
				*/
				
					
					
				LAG_D_GadgetItem[i].x = LAG_D_GadgetItem[i].x + x - LAg__oldX
				LAG_D_GadgetItem[i].y = LAG_D_GadgetItem[i].y + y - LAg__oldy	
					
					
				//other sprites
				n = LAG_D_GadgetItem[i].spr1
				if GetSpriteExists(n)
					LAg__x2 = LAG_D_GadgetItem[i].spr1x +x1
					LAg__y2 = LAG_D_GadgetItem[i].spr1y +y1
					SetSpritePosition(n,LAg__x2,LAg__y2)						
					SetSpriteScissor(n,x,y,x+LAg__w,y+LAg__h)
					LAG_D_GadgetItem[i].spr1x = LAg__x2
					LAG_D_GadgetItem[i].spr1y = LAg__y2
				endif
					
				// text	
				n = LAG_D_GadgetItem[i].TextId
				if GetTextExists(n)
					LAg__x2 = LAG_D_GadgetItem[i].TextX + LAg__x1
					LAg__y2 = LAG_D_GadgetItem[i].TextY + LAg__y1
					SetTExtPosition(n,LAg__x2,LAg__y2)
					LAG_D_GadgetItem[i].TextX  = LAG_D_GadgetItem[i].TextX +LAg__x1
					// à revoir pour les panels !
					//SetTExtScissor(n,x,y,x+w,y+h)
					
				endif
				
				
				// name of gadget	
				n = LAG_D_GadgetItem[i].nameid
				if GetTextExists(n)
					LAg__x2 = LAG_D_GadgetItem[i].NameX + LAg__x1
					LAg__y2 = LAG_D_GadgetItem[i].NameY + LAg__y1
					SetTExtPosition(n,x2,y2)
					SetTExtScissor(n,x,y,x+LAg__w,y+LAg__h)
					LAG_D_GadgetItem[i].NameX = LAg__x2
					LAG_D_GadgetItem[i].NameY = LAg__y2
				endif
				
				// editbox of gadgetitem	
				n = LAG_D_GadgetItem[i].EditBoxId
				if GetTextExists(n)
					SetEditBoxPosition(n,LAG_D_GadgetItem[i].TextX+x1+4,LAG_D_GadgetItem[i].TextY+y1)
					SetEditBoxScissor(n,x,y,x+LAg__w,y+LAg__h)
				endif
					
					
				// puis je bouge les autres sprites	
				
				for k=0 to LAG_D_GadgetItem[i].Spr.length
					n = LAG_D_GadgetItem[i].spr[k].id
					LAg__x2 = LAG_D_GadgetItem[i].spr[k].x + LAg__x1 //-oldx+x
					LAg__y2 = LAG_D_GadgetItem[i].spr[k].y + LAg__y1 //-oldy+y
					SetSpritePosition(n,LAg__x2,LAg__y2)
					//LAG_D_GadgetItem[i].spr[k].x = LAG_D_GadgetItem[i].spr[k].x + LAg__x1					
					//LAG_D_GadgetItem[i].spr[k].y = LAG_D_GadgetItem[i].spr[k].y + LAg__y1
					SetSpriteScissor(n,x,y,x+LAg__w,y+LAg__h)					
				NExt
					
					Foldend
					
				//endif
			endif
		next
	
	endif
	
	FoldEnd
	
	LAG_UpdateDepthGadgetItem(id)




EndFunction


Function LAG_SetGadgetPosition(id,x,y)
	
	
	
endfunction




// Color
Function Lag_SetGadgetColor(id,r,g,b,alpha)

	SetSpritecolor(LAG_D_Gadget[id].Id,r,g,b,alpha)

endfunction






// Set position or depth of some element of gadget
Function LAG_SetPositionSpriteOfGadget(id,sprite,x,y)

	spr = LAG_D_Gadget[id].spr[sprite].id
	SetSpritePosition(spr,x,y)
	LAG_D_Gadget[id].spr[sprite].x = x
	LAG_D_Gadget[id].spr[sprite].y = y
	
EndFunction

Function LAG_SetImageSpriteOfGadget(id,sprite,image)
		
	/* To change the sprite : 
	
	LAG_D_Gadget[id].id -> sprite =-1
	
	LAG_D_Gadget[id].spr1 -> sprite = -2
	
	else : 
	sprite >= 0 we change the sprite in the array LAG_D_Gadget[id].spr[]
	*/
	
	if Sprite = -1
		spr = LAG_D_Gadget[id].id
	elseif sprite = -2
		spr = LAG_D_Gadget[id].spr1
	else
		spr = LAG_D_Gadget[id].spr[sprite].id
	endif
	
	SetSpriteImage(spr,image)
	
EndFunction

Function LAG_SetSizeImageSpriteOfGadget(id,sprite,w,h)
	
	/* To change the sprite size : 
	
	LAG_D_Gadget[id].id -> sprite =-1
	
	LAG_D_Gadget[id].spr1 -> sprite = -2
	
	else : 
	sprite >= 0 we change the sprite in the array LAG_D_Gadget[id].spr[]
	*/
	
	if Sprite = -1
		spr = LAG_D_Gadget[id].id
	elseif sprite = -2
		spr = LAG_D_Gadget[id].spr1
	else
		spr = LAG_D_Gadget[id].spr[sprite].id
	endif
	// spr = LAG_D_Gadget[id].spr[sprite].id
	SetSpriteSize(spr,w,h)
	
EndFunction



// Color
Function Lag_SetSpriteColorOfGadget(id,sprite, r,g,b,alpha)
	/* To change the sprite size : 
	
	LAG_D_Gadget[id].id -> sprite =-1
	
	LAG_D_Gadget[id].spr1 -> sprite = -2
	
	else : 
	sprite >= 0 we change the sprite in the array LAG_D_Gadget[id].spr[]
	*/
	
	if Sprite = -1
		spr = LAG_D_Gadget[id].id
	elseif sprite = -2
		spr = LAG_D_Gadget[id].spr1
	else
		spr = LAG_D_Gadget[id].spr[sprite].id
	endif
	
	SetSpritecolor(spr,r,g,b,alpha)

endfunction


Function LAG_SetDepthSpriteOfGadget(id,sprite,depth)

	spr = LAG_D_Gadget[id].spr[sprite].id
	SetSpriteDepth(spr,depth)

EndFunction







//************ hide/ unhide

Function LAG_HideGadget(id,visible) // <-------------- WIP

    LAG_d_gadget[id].visible = visible
    LAG_SetGadgetVisible(id,visible)

    // need to add the visibility of gadget child or gadgetitem :  if the gadget is a panel, container, combobox, listicon...

EndFunction


Function LAG_SetGadgetVisible(id,visible)

/*
	if id = C_Gad_LvlDayNight or id = C_Gad_LM_SoftShSample
		message(str(LAG_D_Gadget[id].x)+"/"+str(LAG_D_Gadget[id].y))
	endif
*/

    // sprite
    if GetSpriteExists(LAG_D_Gadget[id].id) and LAG_D_Gadget[id].id > 10000
        SetSpriteDepth(LAG_D_Gadget[id].id,LAG_D_Gadget[id].depth*visible+(1-visible)*2000)
    Endif
    if GetSpriteExists(LAG_D_Gadget[id].spr1) and LAG_D_Gadget[id].spr1 > 10000
        SetSpriteDepth(LAG_D_Gadget[id].spr1,LAG_D_Gadget[id].depth*visible+(1-visible)*2000)
    Endif
    
    For i=0 to LAG_D_Gadget[id].spr.length
		//if GetSpriteExists(LAG_D_Gadget[id].spr[i]) and LAG_D_Gadget[id].spr1 > 10000
			SetSpriteDepth(LAG_D_Gadget[id].spr[i].id,LAG_D_Gadget[id].depth*visible+(1-visible)*2000)
		//Endif
	next
	



    // texts
    if GetTextExists(LAG_D_Gadget[id].textid) and LAG_D_Gadget[id].textid > 10000
        SetTextDepth(LAG_D_Gadget[id].textid,LAG_D_Gadget[id].depth*visible+(1-visible)*2000)
    Endif
    if GetTextExists(LAG_D_Gadget[id].Nameid) and LAG_D_Gadget[id].nameid > 10000
        SetTextDepth(LAG_D_Gadget[id].Nameid,LAG_D_Gadget[id].depth*visible+(1-visible)*2000)
    Endif

    if GetEditBoxExists(LAG_D_Gadget[id].EditBoxId) and LAG_D_Gadget[id].EditBoxId > 10000
        SetEditBoxDepth(LAG_D_Gadget[id].EditBoxId,LAG_D_Gadget[id].depth*visible+(1-visible)*2000)
        SetEditBoxActive(LAG_D_Gadget[id].EditBoxId,visible)
    Endif


	// move the gadget with this gadget as parentId 
	select LAG_D_Gadget[id].Typ 
		
		case  LAG_C_TYPCONTAINER, LAG_C_TYPPANEL
			For i =0 to LAG_D_Gadget.length
				
				If LAG_D_Gadget[i].ParentID = id
					
					// if id = C_Gad_ContLvl
						//message("child, son parent est le : "+str(LAG_D_Gadget[i].ParentID ))
					// endif
					LAG_SetGadgetVisible(i,Visible)
					
				endif
				
			next
		endcase
		
	endselect


EndFunction




//*********** gadgettooltip
Function LAg_SetGadgetTooltip(id,txt$)
	
	LAG_D_Gadget[id].ToolTip$ = txt$
	
Endfunction




//*********** scissor, group (spritegroup)

Function LAG_SetGadgetScissor(sp,i,txt,sp1)
	
	// verify if the gadget is created on a container/panel, scrollarea
	if (LAG_D_Gadget[i].ItemId <> -2 and LAG_D_Gadget[i].ParentId <> -2) // or LAG_D_Gadget[i].WindowId > 0
        
        if LAG_D_Gadget[i].ParentId <> -2
			u = LAG_D_Gadget[i].ParentId
			x = LAG_D_Gadget[i].ParentX
			y = LAG_D_Gadget[i].ParentY
			w = LAG_D_Gadget[u].w
			h = LAG_D_Gadget[u].h
        else
			u = LAG_D_Gadget[i].WindowId
			x = Lag_Window[u].x
			y = Lag_Window[u].y
			w = Lag_Window[u].w
			h = Lag_Window[u].h
		endif
		
		// for text (string, text editor...), I use the scissor of the main sprite ID
		
		w1 = LAG_D_Gadget[i].w
		h1 = LAG_D_Gadget[i].h
        
        typ =  LAG_D_Gadget[i].Typ
        
        if sp > -1
			sp = LAG_D_Gadget[i].id	
			if GetSpriteExists(sp)		
				SetSpriteScissor(Sp,x,y,x+w,y+h)
			endif
		endif
		
		x1 = GetspriteX(sp) //LAG_D_Gadget[i].x
		y1 = GetspriteY(sp) //LAG_D_Gadget[i].y
		
		if txt <> -1

			txt = LAG_D_Gadget[i].NameId
			if GetTextExists(txt)
				SetTextScissor(txt,x,y,x+w,y+h)
			endif
			
			
			txt = LAG_D_Gadget[i].TextId
			if GetTextExists(txt)
				SetTextScissor(txt,x1,y1,x1+w1,y1+h1)			
			endif
			
			//txt = LAG_D_Gadget[i].EditBoxId
			//if LAg_D_Gadget[i].Typ = LAG_C_TYPSTRING	
				//if GetEditBoxExists(txt)
					//SetEditBoxScissor(txt,x,y,x+w,y+h)
				//endif
			//endif
			
		endif
		
		if sp1 <> -1
			sp1 = LAG_D_Gadget[i].spr1
			if GetSpriteExists(sp1)
				SetSpriteScissor(Sp1,x,y,x+w,y+h)
			endif
		endif
		
		for j=0 to LAG_D_Gadget[i].spr.length
			sp1 = LAG_D_Gadget[i].spr[j].id
			SetSpriteScissor(Sp1,x,y,x+w,y+h)
		next
		
	endif
	
	
	LAG_SetGadgetGroup(i,0,0)
	
EndFunction

Function LAG_SetGadgetGroup(i,id,sp1)
	
	g = LAG_group
	if sp1 <> -1
		sp1 = LAG_D_Gadget[i].spr1
		if GetSpriteExists(sp1)
			SetSpriteGroup(Sp1,g)		
		endif
	endif
	
	if id <> -1
		id = LAG_D_Gadget[i].id
		if GetSpriteExists(id)
			SetSpriteGroup(id,g)
		endif
	endif
	
	for j=0 to LAG_D_Gadget[i].spr.length
		sp = LAG_D_Gadget[i].spr[j].id
		if GetSpriteExists(sp)
			SetSpriteGroup(Sp,g)
		endif
	next
	
	
EndFunction

