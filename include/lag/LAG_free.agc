

//******************* Free Gadgets

// LAG_freegadgetitem() is in LAG_gadgetitem.agc


function LAG_FreeElementGadget(id)
	  
	
	LAG_D_Gadget[id].actif = 0
	
	Lag_max = LAG_LastMenuID
	
    // delete the sprite
    n = LAG_D_Gadget[id].id
    if GetSpriteExists(n) and  n > lag_max
		/*if (n>=100006 and n<=100061)
			message("ici : "+LAG_D_Gadget[id].text$+"/"+LAG_D_Gadget[id].name$)
		endif*/
        DeleteSprite(n)
    Endif
    
    n = LAG_D_Gadget[id].spr1
    if GetSpriteExists(n) and  n > Lag_max
		/*if (n>=100006 and n<=100061)
			message("ici : "+LAG_D_Gadget[id].text$+"/"+LAG_D_Gadget[id].name$)
		endif*/
        DeleteSprite(n)
    Endif
    

	For i=0 to LAG_D_Gadget[id].spr.length
		n = LAG_D_Gadget[id].spr[i].id
		if GetSpriteExists(n) and n > Lag_max
			/*if (n>=100006 and n<=100061)
				message("ici : "+LAG_D_Gadget[id].text$+"/"+LAG_D_Gadget[id].name$)
			endif*/			
			DeleteSprite(n)
		Endif
	next
	LAG_D_Gadget[id].spr.length = -1


    // delete the texts
    if GetTextExists(LAG_D_Gadget[id].textid) and  LAG_D_Gadget[id].textid > 100000
        DeleteText(LAG_D_Gadget[id].textid)
    Endif
    if GetTextExists(LAG_D_Gadget[id].nameid) and  LAG_D_Gadget[id].nameid > 100000
        DeleteText(LAG_D_Gadget[id].nameid)
    Endif

	// delete editbox
    if GetEditBoxExists(LAG_D_Gadget[id].EditBoxId) and  LAG_D_Gadget[id].EditBoxId > 100000
        DeleteEditBox(LAG_D_Gadget[id].EditBoxId)
    Endif
EndFunction

	
function LAG_FreeGadget(id)


	LAG_FreeElementGadget(id)

	typ 			= LAG_D_Gadget[id].typ
	nb_Gadget_item	= LAG_D_Gadget[id].NbGadgetItem
	
	// reset all the parameters
    LAG_ResetGadget(id,0)
	
	// LAG_D_Gadget.remove(id) // je ne peux pas car j'utilise un tableau avec index element  = numer of the gadget.
	
	
	// puis, je supprime les gadgets items si list-icon, panel,combobox... et les gadgets liés au gadget si container, scrollarea...
	Select  typ
		
		// on supprime les gadgetitems
		case LAG_C_TYPPANEL,LAG_C_TYPLISTICON,LAG_C_TYPLISTVIEW,LAG_C_TYPCOMBOBOX,LAG_C_TYPTREE
			// je supprime tous les items lié au gadget
			For i=0 to nb_Gadget_item
				LAG_FreeGadgetItem(Id,0) // 0 car comme j'enlève un item, à chaque fois, je dois ressupprimer le 0
			next			
		endcase
		
		// on supprime les gadget qui sont dans ce gadget (container, scrollarea...)
		case LAG_C_TYPCONTAINER
			For i=0 to LAG_D_Gadget.length
				if LAG_D_Gadget[i].ParentID = id
					LAG_FreeGadget(i)					
				endif
			next
		endcase
		
	Endselect

    
    
	

EndFunction


Function LAG_ResetGadget(i,mode)


	if i>-1 and i<=  LAG_D_Gadget.length
		// reset all the parameters
		// only the position
		LAG_D_Gadget[i].x = mode *-10000
		LAG_D_Gadget[i].y = mode *-10000

		if mode = 0 // all the others parameters, if needed
			LAG_D_Gadget[i].x = 0
			LAG_D_Gadget[i].y = 0
			LAG_D_Gadget[i].w = 0
			LAG_D_Gadget[i].h = 0
			LAG_D_Gadget[i].TotalW = 0
			LAG_D_Gadget[i].TotalH = 0
			LAG_D_Gadget[i].alpha = 255
			LAG_D_Gadget[i].Typ = -1
			LAG_D_Gadget[i].depth = 10
			LAG_D_Gadget[i].visible = 0
			LAG_D_Gadget[i].actif = 0
			LAG_D_Gadget[i].state = 0
			
			LAG_D_Gadget[i].Text$ = ""
			LAG_D_Gadget[i].Name$ = ""
			
			LAG_D_Gadget[i].ParentID = -2
			LAG_D_Gadget[i].ItemId = -2
			LAG_D_Gadget[i].WindowId = -2
			
			LAG_D_Gadget[i].NbGadgetItem = 0
			LAG_D_Gadget[i].Position = 0
			LAG_D_Gadget[i].option1 = 0
			LAG_D_Gadget[i].snap = 0
			LAG_D_Gadget[i].mini = 0
			LAG_D_Gadget[i].maxi = 0
			
			// on reset les sprites, text et editbox id
			
			LAG_D_Gadget[i].TExtid = -1
			LAG_D_Gadget[i].Nameid = -1
			LAG_D_Gadget[i].Editboxid = -1
			LAG_D_Gadget[i].id = -1
			LAG_D_Gadget[i].Spr1 = -1
			for j=0 to  LAG_D_Gadget[i].spr.length
				LAG_D_Gadget[i].Spr[j].id = -1
			next
			Lag_D_Gadget[i].spr.length = -1
			
		endif
    endif

EndFunction


// free all 
Function Free_Lag()

	// not finish
	// to free all the gadgets, gadgetitem, statusbar, menu, toolbar, window...
	
	For i =0 to LAG_D_Gadget.length
		LAG_FreeGadget(i)		
	next

	Lag_D_Gadget.Length = -1
	

EndFunction



// ***** HIDE LAG ui
Function LAG_HideALL(hide)
	
	// hide the gadgets
	For i=0 to LAG_D_Gadget.length
						
		LAG_D_Gadget[i].visible = 1-hide
		d = LAG_D_Gadget[i].visible
		
		
		// hide the s
		n = LAG_D_Gadget[i].id
		if GetSpriteExists(n)
			SetSpriteVisible(n,d*(1-hide))
		endif
		n = LAG_D_Gadget[i].spr1
		if GetSpriteExists(n)
			SetSpriteVisible(n,d*(1-hide))
		endif
		
		for j=0 to LAG_D_Gadget[i].spr.length
			n = LAG_D_Gadget[i].spr[j].id
			SetSpriteVisible(n,d*(1-hide))
		next
		
		// hide the texts
		n = LAG_D_Gadget[i].Textid
		if GetTextExists(n)
			SetTextVisible(n,d*(1-hide))
		endif
			
		n = LAG_D_Gadget[i].NameId
		if GetTextExists(n)
			SetTextVisible(n,d*(1-hide))
		endif
				
		// hide editbox
		n = LAG_D_Gadget[i].EditBoxId
		if GetEditBoxExists(n)
			SetEditBoxVisible(n,d*(1-hide))
		endif
		
	next
	
	//Hide the gadgetitem
	For i=0 to LAG_D_GadgetItem.length
		
		// visible or not
		d = LAG_D_Gadget[LAG_D_GadgetItem[i].ParentID].visible
		
		//hide or show the sprite and text
		n = LAG_D_GadgetItem[i].id
		if GetSpriteExists(n)
			SetSpriteVisible(n,d*(1-hide))
		endif
		n = LAG_D_GadgetItem[i].spr1
		if GetSpriteExists(n)
			SetSpriteVisible(n,d*(1-hide))
		endif
		
		for j=0 to LAG_D_GadgetItem[i].spr.length
			n = LAG_D_GadgetItem[i].spr[j].id
			SetSpriteVisible(n,d*(1-hide))
		next
		
		n = LAG_D_GadgetItem[i].Textid
		if GetTextExists(n)
			SetTextVisible(n,d*(1-hide))
		endif
		
	next
	
	
	// hide the menu
	LAG_CloseMenu()
	For i = 0 to LAG_d_Menu.length
		
		n = LAG_d_Menu[i].sprite
		if GetSpriteExists(n)
			SetSpriteVisible(n,1-hide)
		endif
		n = LAG_d_Menu[i].SpSelect
		if GetSpriteExists(n)
			SetSpriteVisible(n,1-hide)
		endif
		
		For j=0 to LAG_d_menu[i].MenuTitle.length
			n = LAG_d_menu[i].MenuTitle[j].sprite
			if GetSpriteExists(n)
				SetSpriteVisible(n,1-hide)
			endif
			n = LAG_d_menu[i].MenuTitle[j].textId
			if GetTextExists(n)
				SetTextVisible(n,1-hide)
			endif
		next
		
		
		
	NExt
	
	
	
	
	
	// hide the statusbar
	For j =0 to LAG_StatusBar.length
		n = LAG_StatusBar[j].Sprite
		if GetSpriteExists(n)
			SetSpriteVisible(n, 1-hide)
		endif	
		For i=0 to LAG_StatusBar[j].Field.length
			n = LAG_StatusBar[j].Field[i].TextID
			if GetTextExists(n)
				SetTextVisible(n,1-hide)
			endif
		next
	next
	
	
EndFunction

