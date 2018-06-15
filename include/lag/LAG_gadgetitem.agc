
//******************* gadget items


//*** add, update
Function LAG_AddGadgetItem(GadgetId, Position, txt$, imgId)


	local i,h2,x,y,h,w,y1,n,w9,g
	
	g = 500 // group sprite
	
    /*

    if listgadget is opened :

    Add agadgetItem works only on :
    - panel : add gadgets on the panel item
    - listicon : add an element in the list
     
    not available for the moment
    - containter : add gadgets on the container
    - scrollarea : add gadgets on the scrollarea
    - listview : add an element in the list
    - combobox : add an element   
    - treegadget : add an element in the tree

    */
	
    if LAG_D_Gadget[GadgetId].Typ =  LAG_C_TYPPANEL or LAG_D_Gadget[GadgetId].Typ =  LAG_C_TYPLISTICON

		
        inc LAG_V_NbGadgetItem // increment the number of gadgetItem
        Global dim LAG_D_GadgetItem[LAG_V_NbGadgetItem] as LAG_t_Gadget // add  a new item in the array of gadgetItem
        i = LAG_V_NbGadgetItem

        LAG_D_GadgetItem[i].ParentID = GadgetId // the gadget parent = the panelgagdet
        LAG_D_GadgetItem[i].ItemId = LAG_CurrGadgetItemId // set the parentitem
		
		LAG_D_GadgetItem[i].CurY = 0


		depth = LAG_D_Gadget[GadgetId].depth-1 // the gadgetitem depth is under the panel
		if depth < 0
			depth = 0
		endif

		// if position =-1, we create the next dynamically
		inc LAG_D_Gadget[GadgetId].NbGadgetItem // increment the number of item, for the panel/list icon...
		// !!!!  Always inc, never dec to keep a unique id !
		if position = -1
			position = LAG_D_Gadget[GadgetId].NbGadgetItem
		endif


		select LAG_D_Gadget[GadgetId].Typ 
			
			case LAG_C_TYPPANEL
				
				LAG_CurrGadgetItemId = i // And now, the currGadgetItem  = this new item

				// create the element of the gadgetitem (sprite, text)
				img = LAG_i_Gadget[LAG_c_iPanel]

				spr = CreateSprite(img)
				iw# = getImageWidth(img)
				ih# = getImageHeight(img)

				SetSpriteDepth(spr,7)
				SetSpriteGroup(spr,g)

				// position and size
				w = len(txt$)*6 +10
				w1 = LAG_D_Gadget[GadgetId].totalW
				w2 = w1 + w
				if w > 100 or w2>LAG_D_Gadget[GadgetId].w
					w = LAG_D_Gadget[GadgetId].w -w1
				elseif w < 60
					w = 60
				endif

				x =  LAG_D_Gadget[GadgetId].x + LAG_D_Gadget[GadgetId].totalW // position*w //+ LAG_D_Gadget[id].NbGadgetItem

				nh = 23
				
				if position = LAG_D_Gadget[GadgetId].state
					h = nh
					y = LAG_D_Gadget[GadgetId].y - nh
				else
					h = nh
					y = LAG_D_Gadget[GadgetId].y - nh
				endif
				yy = LAG_D_Gadget[GadgetId].y - nh
				
				// To knwo the position in X for this item
				LAG_D_GadgetItem[i].totalW = LAG_D_Gadget[GadgetId].totalW
				
				// on ajoute la width du gadget item dans le total du paren
				LAG_D_Gadget[GadgetId].totalW = LAG_D_Gadget[GadgetId].totalW +w
			
			endcase
			
			case LAG_C_TYPLISTICON, LAG_C_TYPCOMBOBOX
				
				// define the depth 
				d = LAG_D_Gadget[GadgetId].depth-1 // the gadgetitem depth is behind the panel
				if d <0
					d = 0
				endif
				
				// d = LAG_D_Gadget[GadgetId].depth-1 
				
				LAG_D_GadgetItem[i].Position = Position

				// create the element of the gadgetitem (sprite, text)
				img = 0 // LAG_i_Gadget[LAG_c_iPanel]
				
				h2 = 32 // la taille du gadget item
				
				// pour connaître la taille de la listicon
				y1 = LAG_D_Gadget[GadgetId].y
				w1 = LAG_D_Gadget[GadgetId].w
				h1 = LAG_D_Gadget[GadgetId].h
				LAG_D_Gadget[GadgetId].h2 = h2
				LAG_D_Gadget[GadgetId].w2 = w1-10
				w9 = 32 // de la place à droite pour gadget, c'est pour l'ascenceur !
				
				// position du gadget parent 
				LAG_D_GadgetItem[i].Parentx = GEtspriteX(LAG_D_Gadget[GadgetId].id) 
				LAG_D_GadgetItem[i].ParentY = GEtspriteY(LAG_D_Gadget[GadgetId].id)

				
				// le sprite si l'item est sélectionné
				spr = CreateSprite(img)
				iw# = w1 - 10   // getImageWidth(img)
				ih# = h2 - 3 // getImageHeight(img)
				SetSpriteSize(spr,iw#,ih#)
				SetSpriteDepth(spr,d)
				SetSpriteColor(spr,30,30,30,150)
				SetSpriteOffset(spr,0,0)
				
				 
				// change the pos of the sprite 
				LAG_D_GadgetItem[i].id = spr
				x = 5 + LAG_D_GadgetItem[i].Parentx // LAG_D_Gadget[GadgetId].x 
				y = 5 + LAG_D_GadgetItem[i].Parenty + LAG_D_GadgetItem[i].Position*(ih#+2) 
				// LAG_D_Gadget[GadgetId].y + LAG_D_GadgetItem[i].Position*(ih#+2) 
				LAG_D_GadgetItem[i].originX = 5   			
				LAG_D_GadgetItem[i].originy = 5 + LAG_D_GadgetItem[i].Position*(ih#+2) 				
								
				w =  iw#
				h =  ih#
				SetSpritePosition(spr,x,y)
				SetSpriteScissor(spr,x,y1+5,x+w1-w9,y1+h1-5)
				SetSpriteGroup(spr,g)
					
				FoldStart // on crée l'icone avec l'image
				if imgID > 0				
					n = CreateSprite(imgId)
				else
					n = CreateSprite(0)
				endif
				LAG_D_GadgetItem[i].spr1=n				
				SetSpriteSize(n,h2,h2-3)
				SetSpriteDepth(n,d)				
				FixSpriteToScreen(n,1)
				SetSpriteOffset(n,0,0)				
				SetSpritePosition(n,x,y)
				SetSpriteScissor(n,x,y1+5,x+w1-w9,y1+h1-5)
				SetSpriteGroup(n,g)
				
				SetSpriteVisible(n,LAG_D_Gadget[GadgetId].visible)        
								
				LAG_D_GadgetItem[i].spr1x = 5
				LAG_D_GadgetItem[i].spr1y = 5 // + LAG_D_GadgetItem[i].Position*(ih#+2)
				Foldend
				
			endcase
			
			
			
		endselect

        // set the parameters for the item
        LAG_D_GadgetItem[i].id = Spr
        SetSpriteVisible(spr,LAG_D_Gadget[GadgetId].visible)        
        LAG_D_GadgetItem[i].x = x
        LAG_D_GadgetItem[i].y = y
        LAG_D_GadgetItem[i].h = h
        LAG_D_GadgetItem[i].w = w
        
        // LAG_D_GadgetItem[i].AllVisible = LAG_D_Gadget[GadgetId].allvisible
       
        
        LAG_D_GadgetItem[i].depth = depth
        LAG_D_GadgetItem[i].depthMax = depth
        // LAG_D_GadgetItem[i].visible = 1
		LAG_D_GadgetItem[i].Position = Position


        SetSpritePosition(spr,x,y)
        SetSpriteDepth(spr,depth)
        FixSpriteToScreen(spr,1)

        // text
        if LAG_D_Gadget[GadgetId].Typ =  LAG_C_TYPPANEL
			
			SetSpriteSize(spr,w,h)   	
			SetSpriteUVscale(spr, iw# / getSpriteWidth(spr), ih# / getSpriteHeight(spr))
			SetSpriteFlip(spr,1,0)
			LAG_D_Gadget[GadgetId].h2 = h
			
			// the name of the panel item
			LAG_D_GadgetItem[i].Text$ = txt$
			LAG_D_GadgetItem[i].TextId =  LAG_CreateText(txt$,x+w/2,1+y+h/2-8,depth,1,18)
			LAG_D_GadgetItem[i].TextX = x+w/2
			LAG_D_GadgetItem[i].Texty = 1+y+h/2-8
			
			n = LAG_D_GadgetItem[i].TextId
			SetTextAlignment(n,1)
			SetTextScissor(n,x,y,x+w,y+h)
			SetTextColor(n,LAG_TextColorR,LAG_TextColorG,LAG_TextColorB,255)
		
		elseif LAG_D_Gadget[GadgetId].Typ =  LAG_C_TYPLISTICON

			LAG_D_GadgetItem[i].Text$ = txt$
			
			y7 = y+h2/2-5
			
			LAG_D_GadgetItem[i].TextId =  LAG_CreateText(txt$,x+10+h2,y7,depth,1,16)
			// SetTextAlignment(LAG_D_GadgetItem[i].TextId,1)
			LAG_D_GadgetItem[i].TextX = LAG_D_GadgetItem[i].spr1x + 10 + h2 + LAG_D_GadgetItem[i].Parentx  // x+10+h2
			LAG_D_GadgetItem[i].TextY = y7
			n = LAG_D_GadgetItem[i].TextId
			SetTextColor(n,LAG_TextColorR,LAG_TextColorG,LAG_TextColorB,255)
			
			SetTextScissor(n,x,y1+5,x+w1-w9,y1+h1-5)
			
		endif
		
		SetTextVisible(n,LAG_D_Gadget[GadgetId].visible)      
		
        //update the gadgetItem list and set the state
        // needed to change the depth of the other imte of the panel
        // Instead of this method, I could change SetSpriteUVscale() and SetSpriteSize() of each item, except for the item selected of the panel
        // it should be the same result
        if LAG_D_Gadget[GadgetId].Typ  = LAG_C_TYPPANEL
			for j = 0 to LAG_V_NbGadgetItem				
				LAG_D_GadgetItem[j].state=0
				if LAG_D_GadgetItem[j].parentId = GadgetId
					LAG_D_GadgetItem[j].depth = LAG_D_GadgetItem[j].depthmax+2
					SetSpriteDepth(LAG_D_GadgetItem[j].id,LAG_D_GadgetItem[j].depth)
				endif
			next j
			 
			LAG_D_GadgetItem[i].state=1
			
		elseif LAG_D_Gadget[gadgetId].Typ = LAG_C_TYPLISTICON
			
			LAG_UpdateDepthGadgetItem(GadgetId)
				
		endif
		
		
    else
        //SetSpriteDepth(spr,5) // need to be tested with other gadget and gadgetitem (combobox, listview)
    endif


	// add the group for gadgetitem
	if LAG_D_Gadget[gadgetId].Typ = LAG_C_TYPLISTICON
		sp1 = LAG_D_Gadget[gadgetId].spr1
		SetSpriteGroup(Sp1,g)
		for j=0 to LAG_D_Gadget[gadgetId].spr.length
			sp = LAG_D_Gadget[gadgetId].spr[j].id
			SetSpriteGroup(Sp,g)
		next
	endif
	
	id = LAG_D_Gadget[gadgetId].id
	SetSpriteGroup(id,g)


EndFunction spr



// update Depth
Function LAG_UpdateDepthGadgetItem(gadgetId)
	
	// update the depth and the position of sprite & text
	i = gadgetId
	/*
	if LAG_D_Gadget[i].typ =LAG_C_TYPLISTICON	
		d1 =  GetSpriteDepth(LAG_D_Gadget[i].id) 
		d2 =  GetSpriteDepth(LAG_D_Gadget[i].Spr1)
	//message(str(d1)+"/"+str(d2))	
	endif
	*/	
		
	For g = 0 to LAG_D_GadgetItem.length
		
		if LAG_D_GadgetItem[g].ParentID = i
			
			lag__x1 = LAG_D_Gadget[i].x
			lag__y1 = LAG_D_Gadget[i].y
			lag__h1 = LAG_D_Gadget[i].h
			lag__w1 = LAG_D_Gadget[i].w
			
			lag__h2 = LAG_D_Gadget[i].h2
			
			lag__h = LAG_D_GadgetItem[g].h
			lag__w = LAG_D_GadgetItem[g].w
			lag__x = LAG_D_GadgetItem[g].x + LAG_D_GadgetItem[g].x1
			lag__y = LAG_D_GadgetItem[g].y + LAG_D_GadgetItem[g].y1
			
			lag__d = GetSpriteDepth(LAG_D_Gadget[i].id)-1 
			if lag__d<0
				lag__d=0
			endif
			
			LAG_D_GadgetItem[g].depth=lag__d
			
			select LAG_D_Gadget[i].typ 
				
				case LAG_C_TYPPANEL
					h2 = 30
					h3 = lag__h1
					h4 = 5
					
					if LAG_D_GadgetItem[g].position = LAG_D_Gadget[i].state
						h4 =2
						//message(LAG_D_GadgetItem[g].text$)
					endif
					
					// on montre l'onglet sélectionné
					n = LAG_D_GadgetItem[g].spr1
					if GetSpriteExists(n)
						SetSpritePosition(n,GetSpriteX(n),LAG_D_GadgetItem[g].Y1+LAG_D_GadgetItem[g].Y-LAG_d_Gadget[i].CurY)
						SetSpriteDepth(n,lag__d)
					endif
					
					// sprite
					n = LAG_D_GadgetItem[g].id 			
					xa = lag__x // GetSpriteX(n)
					ya = GetSpriteY(n)
					wa = LAG_D_GadgetItem[g].w // GetSpriteWidth(n)
					ha = GetSpriteHeight(n)
					SetSpritePosition(n,xa,LAG_D_GadgetItem[g].Y1+LAG_D_GadgetItem[g].Y-LAG_d_Gadget[i].CurY+h4)
					//SetSpriteDepth(n,d)
					
					// textid 
					n = LAG_D_GadgetItem[g].Textid
					y2 = LAG_D_GadgetItem[g].Y1+LAG_D_GadgetItem[g].Y-LAG_d_Gadget[i].CurY					
					SetTextDepth(n,lag__d)			
					SetTextPosition(n,xa+lag__w*0.5,y2+lag__h/4)			
					SetTextScissor(n,xa,ya,xa+lag__w,ya+ha)
				endcase
								
				case LAG_C_TYPCOMBOBOX
				endcase 
					
				case LAG_C_TYPLISTICON

					h2 = -5
					h3 = 5
					lag__x1 = LAG_D_GadgetItem[g].parentX
					lag__y1 = LAG_D_GadgetItem[g].parentY
					w9 = 16 // getSpriteWidth(LAG_D_GadgetItem[g].spr1)
					w2 = getSpriteWidth(LAG_D_GadgetItem[g].spr1)
					
					// icone
					n = LAG_D_GadgetItem[g].spr1
					x2 = LAG_D_GadgetItem[g].spr1x + LAG_D_GadgetItem[g].parentX // GetSpriteX(n)
					//y2 = LAG_D_GadgetItem[g].Y1 + LAG_D_GadgetItem[g].Y-LAG_d_Gadget[i].CurY
					y2 = LAG_D_GadgetItem[g].originY + LAG_D_GadgetItem[g].parentY -LAG_d_Gadget[i].CurY
					y3 = y2
					SetSpritePosition(n,x2,y2)
					SetSpriteDepth(n,lag__d)
					SetSpriteScissor(n,lag__x1,lag__y1+5,lag__x1+lag__w1-w9,lag__y1+lag__h1-5)
					
					// sprite
					n = LAG_D_GadgetItem[g].id 			
					x2 = LAG_D_GadgetItem[g].originX + LAG_D_GadgetItem[g].parentX // GetSpriteX(n)
					//y2 = LAG_D_GadgetItem[g].Y1+LAG_D_GadgetItem[g].Y-LAG_d_Gadget[i].CurY
					y2 = LAG_D_GadgetItem[g].originY + LAG_D_GadgetItem[g].parentY -LAG_d_Gadget[i].CurY
					SetSpritePosition(n,x2,y2)					
					SetSpriteDepth(n,lag__d)
					SetSpriteScissor(n,lag__x1,lag__y1+5,lag__x1+lag__w1-w9,lag__y1+lag__h1-5)
					
					ny=y2
					
					// textid 
					n = LAG_D_GadgetItem[g].Textid
					x2 = LAG_D_GadgetItem[g].spr1x + LAG_D_GadgetItem[g].parentX + 10 + w2
					//y2 = LAG_D_GadgetItem[g].Y1 + LAG_D_GadgetItem[g].Y - LAG_d_Gadget[i].CurY + lag__h/4
					y2 = LAG_D_GadgetItem[g].originy + LAG_D_GadgetItem[g].parentY - LAG_d_Gadget[i].CurY + lag__h/4
					SetTextDepth(n,lag__d)			
					SetTextPosition(n,x2,y2)			
					SetTextScissor(n,lag__x1,lag__y1+5,lag__x1+lag__w1-w9,lag__y1+lag__h1-5)
				
				
							
/*
					h = LAG_D_GadgetItem[g].h
					n = LAG_D_GadgetItem[g].spr1
					ny = LAG_D_GadgetItem[g].Y-LAG_d_Gadget[i].CurY  //+LAG_d_Gadget[i].WinY
					SetSpritePosition(n,GetSpriteX(n),ny)
					n = LAG_D_GadgetItem[g].id
					SetSpritePosition(n,getspriteX(n),ny)
					n= LAG_D_GadgetItem[g].Textid
					SetTextPosition(n,GetTExtX(n),ny+h/4)
		*/
		
		
					pos = LAG_D_GadgetItem[g].Position
		
					// the other little images (for layers for example
					n0 = LAG_D_GadgetItem[g].spr1
					For kk=0 to LAG_D_GadgetItem[g].spr.length
						//message("gadgetitem : "+LAG_D_GadgetItem[g].Text$+"/"+str(pos)+"/"+str(GetSpriteY(n0))+"/"+str(y3))
						n1 = LAG_D_GadgetItem[g].spr[kk].id
						x2 = LAG_D_GadgetItem[g].spr[kk].x + LAG_D_GadgetItem[g].parentX 
						SetSpritePosition(n1,x2,GetSpriteY(n0)+lag__h/4)
						
						SetSpriteDepth(n1,lag__d)
						SetSpriteScissor(n1,lag__x1,lag__y1+5,lag__x1+lag__w1-w9,lag__y1+lag__h1-5)
					next
				
				
				
				endcase
				
			endselect
						
			
			
		endif
	next

	
	
Endfunction



//*** GEt
Function LAg_GetGadgetItemText(GadgetId,Pos)
	
	for i= 0 to LAG_D_GadgetItem.length
		if LAG_D_GadgetItem[i].ParentID  = gadgetId
			if LAG_D_GadgetItem[i].position = pos
				txt$ = LAG_D_GadgetItem[i].text$
				exit
			endif
		endif
	next	
	
EndFunction txt$

Function LAG_GetGadgetItem(GadgetID, pos)
	
	n=0
	
	// to know the gadgetitem from a gadgetId, by its position, for example to change it if needed
	for i= 0 to LAG_D_GadgetItem.length
		if LAG_D_GadgetItem[i].ParentID  = gadgetId
			if LAG_D_GadgetItem[i].position = pos
				n = LAG_D_GadgetItem[i].id
				exitfunction LAG_D_GadgetItem[i].id
			endif
		endif
	next
	
Endfunction n

Function LAg_GetGadgetItemHeight(GadgetId)
	
	for i= 0 to LAG_D_GadgetItem.length
		if LAG_D_GadgetItem[i].ParentID  = gadgetId
			LAG__h = LAG_D_GadgetItem[i].h
			exit
		endif
	next
	
Endfunction LAG__h

Function LAG_GetGadgetItemAttribute(GadgetId, pos)

	for i= 0 to LAG_D_GadgetItem.length
		if LAG_D_GadgetItem[i].ParentID  = gadgetId
			if LAG_D_GadgetItem[i].position = pos
				LAG__att = LAG_D_GadgetItem[i].attribute
				exit
			endif
		endif
	next

Endfunction LAG__att

Function LAG_GetGadgetItemPosition(GadgetId, name$)
	
	if name$ = ""
		LAG__pos = LAG_D_Gadget[GadgetId].NbGadgetItem
	else
		for i= 0 to LAG_D_GadgetItem.length
			if LAG_D_GadgetItem[i].ParentID  = gadgetId
				if LAG_D_GadgetItem[i].Name$ = name$
					LAG__pos = LAG_D_GadgetItem[i].attribute
					exit
				endif
			endif
		next
	endif
	
endfunction LAG__pos




//*** set
Function LAg_SetGadgetItemText(GadgetId,Pos,txt$)
	
	for i= 0 to LAG_D_GadgetItem.length
		if LAG_D_GadgetItem[i].ParentID  = gadgetId
			if LAG_D_GadgetItem[i].position = pos				
				LAG_D_GadgetItem[i].text$ = txt$
				SetTextString(LAG_D_GadgetItem[i].TextId,txt$)
				exit
			endif
		endif
	next	
	
EndFunction
 
Function LAg_SetGadgetItemImage(GadgetId,Pos,img)
	
	// to change the image of a gadget item
	for i= 0 to LAG_D_GadgetItem.length
		if LAG_D_GadgetItem[i].ParentID  = gadgetId
			if LAG_D_GadgetItem[i].position = pos				
				// LAG_D_GadgetItem[i].text$ = txt$
				SetSpriteImage(LAG_D_GadgetItem[i].spr1,img)
				exit
			endif
		endif
	next	
	
EndFunction 

Function LAG_AddImageToGadgetItem(GadgetId,index,img,pos,x,y,w,h)
	
	// to add or set an image to a gadgetitem
	/*
	For example, it could be used to create easily a sort of layer with image : view, locked, preview, layer Backdrop...
	
	*/
	
	w1 = LAG_D_Gadget[GadgetId].w
	h1 = LAG_D_Gadget[GadgetId].h
	x1 = LAG_D_Gadget[GadgetId].x
	y1 = LAG_D_Gadget[GadgetId].y
	
	
	
	
	if pos = -1 // all gadgetitem receive the new image
		// to change the position and size of a gadget item
		for i= 0 to LAG_D_GadgetItem.length
			if LAG_D_GadgetItem[i].ParentID  = gadgetId
				
				
			endif
		next
	
	else
		
		// to add a image 
		for i= 0 to LAG_D_GadgetItem.length
			if LAG_D_GadgetItem[i].ParentID  = gadgetId
				if LAG_D_GadgetItem[i].position = pos
					
					
					//img = iAvatar
					
					///message("gadgetitem : "+LAG_D_GadgetItem[i].Text$+"/"+str(pos))
					
					if index=-1 or index>LAG_D_GadgetItem[i].spr.length
						j = LAG_D_GadgetItem[i].spr.length+1
						LAG_D_GadgetItem[i].spr.length = j
						LAG_D_GadgetItem[i].spr[j].id = CreateSprite(img)
						
					else
						j = index
					endif
						
					n= LAG_D_GadgetItem[i].spr[j].id
					FixSpriteToScreen(n,1)
					SetSpriteOffset(n,0,0)
					SetSpriteImage(n,img)
					if w>-1 and h>-1
						SetSpriteSize(n,w,h)
					endif
					
					
					
					n1 = LAG_D_GadgetItem[i].spr1			
					x2 = GetspriteX(n1)
					y2 = GetspriteY(n1)
					
					//x2 = LAG_D_GadgetItem[i].Parentx + LAG_D_GadgetItem[i].originX // LAG_D_GadgetItem[i].x
					//y2 = LAG_D_GadgetItem[i].Parenty + LAG_D_GadgetItem[i].originy // LAG_D_GadgetItem[i].y
					LAG_D_GadgetItem[i].spr[j].x = x
					LAG_D_GadgetItem[i].spr[j].y = y
					
					
					// SetSpritePosition(n,x2-100,y2) 
					SetSpritePosition(n,x2+x,y2+y) 					
					SetSpriteScissor(n,x1,y1,x1+w1,y1+h1)
					
					d=GetSpriteDepth(n1)-1
					
					SetSpriteDepth(n,0)
					exit
				endif
			endif
		next
		
	endif
	
EndFunction

Function LAG_SetGadgetItemAttribute(GadgetId, pos, attribute)

	for i= 0 to LAG_D_GadgetItem.length
		if LAG_D_GadgetItem[i].ParentID  = gadgetId
			if LAG_D_GadgetItem[i].position = pos
				LAG_D_GadgetItem[i].attribute = attribute
				exit
			endif
		endif
	next

Endfunction 





// size
Function LAG_SetGadgetItemReSizeAll(gadgetId,x,y,w,h)
	
	h1 = 0
	k = GadgetId
	if LAG_D_Gadget[k].typ = LAG_C_TYPLISTICON or LAG_D_Gadget[k].typ = LAG_C_TYPCOMBOBOX
		h1 = 3		
	endif
	
	
	// to change the position and size of a gadget item
	for i= 0 to LAG_D_GadgetItem.length
		
		if LAG_D_GadgetItem[i].ParentID  = gadgetId
			
			n = LAG_D_GadgetItem[i].id
			
			// set size 
			if w = -1
				w = GetSpriteWidth(n)
			endif
			if h =-1
				h = GetSpriteHeight(n)
			endif
			
			LAG_D_GadgetItem[i].w = w
			LAG_D_GadgetItem[i].h = h
			
			SetSpriteSize(n,GetSpriteWidth(n),h-h1)
			LAG_D_Gadget[GadgetId].h2 = h-h1
			
			LAG_D_GadgetItem[i].y = h*LAG_D_GadgetItem[i].Position + LAG_D_Gadget[GadgetId].y
			
			LAG_D_GadgetItem[i].originY = h*LAG_D_GadgetItem[i].Position
			
			// set position
			old = LAG_D_Gadget[GadgetId].x + LAG_D_GadgetItem[i].totalW
			x1 = LAG_D_Gadget[GadgetId].x + LAG_D_GadgetItem[i].totalW + x
			y1 = LAG_D_GadgetItem[i].y + y +h1*0.5
			
			LAG_D_GadgetItem[i].y1 =y
			LAG_D_GadgetItem[i].x1 =x
			SetSpritePosition(n,x1,y1)
			
			n = LAG_D_GadgetItem[i].spr1
			SetSpriteSize(n,w,h-h1)
			SetSpritePosition(n,x1,y1)
			
			
			
			For k=0 to LAG_D_GadgetItem[i].spr.length
				n1 = LAG_D_GadgetItem[i].spr[k].id			
				SetSpritePosition(n1,x1+150,y1)
			next
			
			n = LAG_D_GadgetItem[i].TextId
			SetTextSize(n,h*0.32)
			SetTextPosition(n,LAG_D_GadgetItem[i].TextX+x+w, y1+h/4) // LAG_D_GadgetItem[i].TextY+y+h)
			//x2 = LAG_D_Gadget[GadgetId].x + LAG_D_GadgetItem[i].totalW + x
			//y2 = LAG_D_GadgetItem[i].y + y
			//SetTextScissor(n,x1,y1,x1+w,y1+h)
			
			
			
			txt$= LAG_D_GadgetItem[i].Text$
			y7 = LAG_D_GadgetItem[i].TextY+y+h
			
			//message("Y de l'item - "+txt$+ " : "+str(y7)+"/"+str(LAG_D_GadgetItem[i].TextY)+"/"+str(y)+"/"+str(h))
			
			//message("Y de l'item - "+txt$+ " : "+str(y1+h/4)+"/"+str(n))
			
			
			
		endif
	next		
			
Endfunction

Function LAG_SetGadgetItemSize(gadgetId,pos,x,y,w,h)

	h1 = 0
	k = GadgetId
	if LAG_D_Gadget[k].typ = LAG_C_TYPLISTICON or LAG_D_Gadget[k].typ = LAG_C_TYPCOMBOBOX
		h1 = 3		
	endif
	
	// to change the position and size of a gadget item
	for i= 0 to LAG_D_GadgetItem.length
		if LAG_D_GadgetItem[i].ParentID  = gadgetId
			if LAG_D_GadgetItem[i].position = pos
				
				n = LAG_D_GadgetItem[i].id
				// set size 
				if w = -1
					w = GetSpriteWidth(n)
				endif
				if h =-1
					h = GetSpriteHeight(n)
				endif
				
				LAG_D_GadgetItem[i].w = w
				LAG_D_GadgetItem[i].h = h
				
				SetSpriteSize(n,w,h-h1)
				
				// set position
				old = LAG_D_Gadget[GadgetId].x + LAG_D_GadgetItem[i].totalW
				x1 = LAG_D_Gadget[GadgetId].x + LAG_D_GadgetItem[i].totalW + x
				y1 = LAG_D_GadgetItem[i].y + y +h1*0.5
				LAG_D_GadgetItem[i].y1 =y
				LAG_D_GadgetItem[i].x1 =x
				SetSpritePosition(n,x1,y1)
				
				n = LAG_D_GadgetItem[i].spr1
				if GetSpriteExists(n)
					SetSpritePosition(n,x1,y1)
				endif
				
				
				For k=0 to LAG_D_GadgetItem[i].spr.length
					n1 = LAG_D_GadgetItem[i].spr[k].id			
					SetSpritePosition(n1,x1+150,y1)
				next
				
				
				
				
				n = LAG_D_GadgetItem[i].TextId				
				SetTextPosition(n,x1+w/2,LAG_D_GadgetItem[i].TextY+y)
				SetTextScissor(n,x1,y1,x1+w,y1+h)
				
				exit
			endif
		endif
	next	

EndFunction



// Position
Function LAG_UpdatePositionItem(id, x1, y1)
	
	
	// si on a bougé un gadget de type listicon/panel/combobox... ou si on bouge un gadget contenant un gadget listicon/panel/..., il faut repositionner les items de ce gadget parent.
	
	
	i=id
	
	//then update the position of gadgetitem (for panel, listIcon)
	
	
	For j=0 to LAG_D_GadgetITem.length
			
		if  LAG_D_GadgetItem[j].ParentID = i
			
			w = LAG_D_Gadget[i].w
			h = LAG_D_Gadget[i].h
			
			Select LAG_D_Gadget[i].typ
				
				case LAG_C_TYPPANEL
			
				
				// main sprite
				x2 = LAG_D_GadgetItem[j].x + x1
				y2 = LAG_D_GadgetItem[j].y + y1
				n = LAG_D_GadgetItem[j].id
				SetSpritePosition(n,x2,y2)
				//SetSpriteScissor(n,x,y,x+w,y+h)
					
				//LAG_D_GadgetItem[j].x = x2 // LAG_D_GadgetItem[j].x + x - oldX
				//LAG_D_GadgetItem[j].y = y2 // LAG_D_GadgetItem[j].y + y - oldy	
					
					
				//other sprites
				n = LAG_D_GadgetItem[j].spr1
				if GetSpriteExists(n)
					x2 = LAG_D_GadgetItem[j].spr1x + x1
					y2 = LAG_D_GadgetItem[j].spr1y + y1
					SetSpritePosition(n,x2,y2)						
					// SetSpriteScissor(n,x,y,x+w,y+h)
					//LAG_D_GadgetItem[j].spr1x = x2
					//LAG_D_GadgetItem[j].spr1y = y2
				endif
					
				// text	
				n = LAG_D_GadgetItem[j].TextId
				if GetTextExists(n)
					x2 = LAG_D_GadgetItem[j].TextX + x1
					y2 = LAG_D_GadgetItem[j].TextY + y1
					SetTExtPosition(n,x2,y2)
					// à revoir pour les panels !
					//SetTExtScissor(n,x,y,x+w,y+h)
					// LAG_D_GadgetItem[j].TextX = x2
					// LAG_D_GadgetItem[j].TextY = y2
					// MEssage(LAG_D_GadgetItem[j].text$)
				endif
				
				
				
				
				// name of gadget	
				n = LAG_D_GadgetItem[j].nameid
				if GetTextExists(n)
					x2 = LAG_D_GadgetItem[j].NameX + x1
					y2 = LAG_D_GadgetItem[j].NameY + y1
					SetTExtPosition(n,x2,y2)
					SetTExtScissor(n,x1,y1,x1+w,y1+h)
					//LAG_D_GadgetItem[j].NameX = x2
					//LAG_D_GadgetItem[j].NameY = y2
				endif
				
				// editbox of gadgetitem	
				n = LAG_D_GadgetItem[j].EditBoxId
				if GetTextExists(n)
					SetEditBoxPosition(n,LAG_D_GadgetItem[j].TextX+x1+4,LAG_D_GadgetItem[j].TextY+y1)
					SetEditBoxScissor(n,x1,y1,x1+w,y1+h)
				endif
					
					
				// puis je bouge les autres sprites	
				for k=0 to LAG_D_GadgetItem[j].Spr.length
					
					n = LAG_D_GadgetItem[j].spr[k].id
					x2 = LAG_D_GadgetItem[j].spr[k].x +x1 //-oldx+x
					y2 = LAG_D_GadgetItem[j].spr[k].y +y1 //-oldy+y
					SetSpritePosition(n,x2,y2)
					
				NExt

					
			endcase
			
				case LAG_C_TYPLISTICON
					
					oldy = LAG_D_GadgetItem[j].parentY
					w9 = getspritewidth(LAG_D_GadgetItem[j].spr1)
					
					
					// main sprite (sprite de selection
					x2 = LAG_D_GadgetItem[j].originx + x1
					y2 = LAG_D_GadgetItem[j].originy + y1
					
					LAG_D_GadgetItem[j].y1 = y1
						
					n = LAG_D_GadgetItem[j].id
					SetSpritePosition(n,x2,y2)
					SetSpriteScissor(n,x1,y1+5,x1+w-w9,y1+h-5)
					
					// icone					
					n = LAG_D_GadgetItem[j].spr1
					if GetSpriteExists(n)
						x2 = LAG_D_GadgetItem[j].spr1x + x1
						y2 = LAG_D_GadgetItem[j].spr1y + y1-oldy
						SetSpritePosition(n,x2,y2)						
						SetSpriteScissor(n,x1,y1+5,x1+w,y1+h-5)
						
					endif
					
					// text					
					n = LAG_D_GadgetItem[j].TextId
					if GetTextExists(n)
						x2 = LAG_D_GadgetItem[j].TextX + x1						
						y2 = LAG_D_GadgetItem[j].TextY + y1-oldY						
						SetTExtPosition(n,x2,y2)						
						SetTExtScissor(n,x1,y1+5,x1+w,y1+h-5)						
					endif
					
					
					
					LAG_D_GadgetItem[j].parentY = y1
					LAG_D_GadgetItem[j].parentX = x1
				endcase
			
				case LAG_C_TYPCOMBOBOX
				
				endcase
			
			
			
			endselect	
				
				
				
				
		endif
	next
	
Endfunction




//state, attribute
Function LAG_SetGadgetAttribute(GadgetID,Attribute,value)
	
	// For attribute and value, see constants.agc //***** Attributes
	
	for i= 0 to LAG_D_GadgetItem.length
		if LAG_D_GadgetItem[i].ParentID  = gadgetId
			LAG_D_GadgetItem[i].attribute = Attribute
			LAG_D_GadgetItem[i].attributeValue = value
			
			n = LAG_D_GadgetItem[i].id
			n1 = LAG_D_GadgetItem[i].spr1
			t1 = LAG_D_GadgetItem[i].TextId
			
			if attribute = LAg_ListIcon_DisplayMode
				
				select Value
					
					case LAg_ListIcon_List //32*32
						w=32
						h=32
					endcase
					case LAg_ListIcon_ListMedium // 64*64
						w=64
						h=64
					endcase
					case LAg_ListIcon_ListLarge // 128*128
						w=128
						h=128
					endcase
				
				endselect
				LAG_D_GadgetItem[i].w = w
				LAG_D_GadgetItem[i].h = h
				SetSpriteSize(n,w,h)
				SetSpriteSize(n1,GetSpriteWidth(n1),h)
				
			endif
		endif
	next
	
EndFunction


Function LAg_SetGadgetItemState(id,pos,state)
	
	//if LAG_D_GadgetItem[id].Typ = LAG_C_TYPLISTICON
		
		LAG_D_GadgetItem[pos].state = state
		
    //endif
	
EndFunction

Function LAG_SetGadgetItemVisible(id,visible)
	
	n = LAG_D_GadgetItem[id].id
    if GetSpriteExists(n) and n > 10000
        SetSpriteDepth(LAG_D_GadgetItem[id].id,LAG_D_GadgetItem[id].depth*visible+(1-visible)*2000)
    Endif
    n = LAG_D_GadgetItem[id].spr1
    IF GetSpriteExists(n) and n > 10000
		SetSpriteDepth(n,LAG_D_GadgetItem[id].depth*visible+(1-visible)*2000)
    endif
    if GetTextExists(LAG_D_GadgetItem[id].textid) and LAG_D_GadgetItem[id].textid > 10000
        SetTextDepth(LAG_D_GadgetItem[id].textid,LAG_D_GadgetItem[id].depth*visible+(1-visible)*2000)
    Endif

EndFunction








//*** free gadgetitem
Function Lag_FreeallGadgetItemByGadget(gadgetId)
	
	//Message("avant : "+str(LAG_V_NbGadgetItem)+"/"+str(LAG_D_GadgetItem.length))

	
	
	// Pour supprimer un gadgetitem de la liste des gadgetitem du gadget sélectionné.
	for i=0 to LAG_D_GadgetItem.length
		
		if LAG_D_GadgetItem[i].ParentID = GadgetId
			
			//if LAG_D_GadgetItem[i].position=position
				
				n =  LAG_D_GadgetItem[i].id
				if GetSpriteExists(n)and n > 10000
					DeleteSprite(n)
				endif
					
				n =  LAG_D_GadgetItem[i].spr1
				if GetSpriteExists(n) and n > 10000
					DeleteSprite(n)
				endif
				
				n = LAG_D_GadgetItem[i].TextId			
				if GetTextExists(n) and n > 10000
					DeleteText(n)
				endif
				
				//message(LAG_D_GadgetItem[i].Text$)
				
				n = LAG_D_GadgetItem[i].NameId			
				if GetTextExists(n) and n > 10000
					DeleteText(n)
				endif
				
				// delete editbox
				n = LAG_D_GadgetItem[i].EditBoxId
				if GetEditBoxExists(n) and n > 10000
					DeleteEditBox(n)
				Endif
				
				
				LAG_D_GadgetItem.remove(i)
				dec i 
				//exit			
			//endif
		endif
	next
	
	// Message("free all item by gadget : "+str(LAG_V_NbGadgetItem)+"/"+str(LAG_D_GadgetItem.length))

	LAG_V_NbGadgetItem = LAG_D_GadgetItem.length
	LAG_D_Gadget[GadgetId].NbGadgetItem = 0
	LAG_d_Gadget[GadgetId].CurY =0
	
	//Message("après : "+str(LAG_V_NbGadgetItem)+"/"+str(LAG_D_GadgetItem.length))

	
EndFunction


Function LAG_FreeGadgetItem(GadgetId,position)
	
	ok = 0
	
	// Pour supprimer un gadgetitem de la liste des gadgetitem du gadget sélectionné.
	for i=0 to LAG_D_GadgetItem.length
		
		if LAG_D_GadgetItem[i].ParentID = GadgetId
			
			//message("identifiant de l'item : "+str(LAG_D_GadgetItem[i].id)+"/"+str(GadgetId))
			
			if LAG_D_GadgetItem[i].position =position
				ok = 1
				n =  LAG_D_GadgetItem[i].id
				if GetSpriteExists(n)
					DeleteSprite(n)
				endif
					
				n =  LAG_D_GadgetItem[i].spr1
				if GetSpriteExists(n)
					DeleteSprite(n)
				endif
				
				n = LAG_D_GadgetItem[i].TextId			
				if GetTextExists(n)
					DeleteText(n)
				endif
				
				n = LAG_D_GadgetItem[i].NameId			
				if GetTextExists(n)
					DeleteText(n)
				endif
				
				
				// delete editbox
				n = LAG_D_GadgetItem[i].EditBoxId
				if GetEditBoxExists(n) and n > 10000
					DeleteEditBox(n)
				Endif
				
				for k=0 to LAG_D_GadgetItem[i].spr.length
					n =  LAG_D_GadgetItem[i].spr[k].id
					if GetSpriteExists(n)
						DeleteSprite(n)
					endif
				next
				
				
				LAG_D_GadgetItem.remove(i)
				
				exit			
			endif
		endif
	next
	
	LAG_V_NbGadgetItem = LAG_D_GadgetItem.length
	
	// je dois enlever un gadget item chez le parent
	if ok =1
		dec LAG_D_Gadget[GadgetId].NbGadgetItem
		if  LAG_D_Gadget[GadgetId].NbGadgetItem <-1
			LAG_D_Gadget[GadgetId].NbGadgetItem = -1
		endif
		
		// puis, je change la position et le Y de chaque gadget item en dessous (si list icon).
		j = GadgetId
		LAg_h = LAG_d_Gadget[j].h2-1
		For i= 0 to LAG_D_GadgetItem.length
			
			if LAG_D_GadgetItem[i].ParentID = GadgetId
				
				select LAG_D_Gadget[GadgetId].Typ 
					
						Case LAG_C_TYPLISTICON, LAG_C_TYPCOMBOBOX
						
							if LAG_D_GadgetItem[i].Position>=position
							
							
								LAG_D_GadgetItem[i].Position = LAG_D_GadgetItem[i].Position-1
								LAG_D_GadgetItem[i].y = LAG_D_GadgetItem[i].y - LAG_H
								LAG_D_GadgetItem[i].originY = LAG_D_GadgetItem[i].originY - LAG_H
								
								// on doit changer la position des gadgetitem : 
								n = LAG_D_GadgetItem[i].spr1
								SetSpritePOsition(n,GetSpriteX(n),LAG_D_GadgetItem[i].Y-LAG_d_Gadget[j].CurY)
								n = LAG_D_GadgetItem[i].id
								SetSpritePOsition(n,getspriteX(n),LAG_D_GadgetItem[i].Y-LAG_d_Gadget[j].CurY)
								n= LAG_D_GadgetItem[i].Textid
								SetTextPOsition(n,GetTExtX(n),LAG_D_GadgetItem[i].Y-LAG_d_Gadget[j].CurY+(Lag_h+1)/4)
							endif
								
						endcase
					
					Endselect
					
			endif
		
		next
	
	endif
	
EndFunction


