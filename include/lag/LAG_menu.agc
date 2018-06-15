
//************************************************//
//
//                     MENU
//
//
//************************************************//

/* INFOS

A menu is defined by :
- a menu (which contain  : the menu title and the menu item (for the menu title associated)
- some menu title (file- edit, view...)
- some menu item (file : new, open, save, save as...)

The current menu used is defined by a global variable : LAG_v_CurrMenuId

*/


//*************** TYPE ***************//

Type LAG_tMenuBar
	
	x as integer
    y as integer   
    w as integer
    h as integer
    sprite as integer
	MenuTitleId as integer // pour connaitre l'id du menu titre, pour resize la menubar si besoin
	
Endtype

type LAG_t_MenuTitle

    x as integer
    y as integer
    Width as integer // the size of the width max of the menuitem
	h as integer
	
    sprite as integer
  
    id as integer
    menuId as integer
    text$
    textId as integer

	// some Fx (border and shadow
    spriteBord as integer
    spriteBordX as integer
    spriteBordY as integer
    spriteShadow as integer
    spriteShadowX as integer
    spriteShadowY as integer
    

    position as integer
    PositionItemY as integer // the know the position of the Max item in Y, because we can have menubar() or other submenu()

	MenuBar as LAG_tMenuBar[]

EndType

type LAG_t_MenuItem

    x as integer
    y as integer
    textX as integer
    textY as integer
    w as integer
    h as integer

    Enable as integer // is the menu enable or not ?
    Actif  as integer // to know if the array element is used, if you create amenuitem id =1 and another with id = 18, you have 2 to 17 that are inactive

    sprite as integer
    id as integer // id of the item
    textId as integer // id of the text of the item ( textId =createtext())

    menuId as integer // id of the main menu of the item
    menuTitleId as integer // the menutitle parent
    text$
    position as integer // position in the menu title

EndType


type LAG_t_Menu

    x as integer
    y as integer
    height as integer // height of the menu
	
	Group as integer
	
	
	Depth as integer

    sprite as integer
    SpSelect as integer //for the selected MenuItem

    id as integer //id of the menu
    windowId as integer
    state as integer
    SelectedItemId as integer // the selected item in the menu (needed because we test the GetSpriteHit() and keep a number in the sprite of the select which is the sprite id of the item)

    // customisation
    TextSize as integer
    MenuSpace as integer // space between the menutitle
    ColorSelect as integer

    // the number of item and title
    NbMenuTitle as integer
    MenuTitle as LAG_t_MenuTitle[]
    MenuItem as LAG_t_MenuItem[]
    
    
    PositionTitleX as integer // the know the position of the current title in X, because the position is linked to the text of the title

    NbMenuItem as integer // number total of menuitem

EndType




//************** create the menu

Function LAG_CreateMenu(MenuId,height,space,windowid)

    // height of the menu
    // space between 2 menus titles

    if MenuId > -1 
		// define the number of menu we have created in our application (in general we have one menu on the main window, and some other menu for the other window (preference...))
        if LAG_v_NbMenu <= MenuId
            LAG_v_NbMenu = MenuId
        endif
    endif
    
	// message("nb menu : "+str(LAG_v_NbMenu))

    Global dim LAG_d_Menu[LAG_v_NbMenu] as LAG_t_Menu // incremente the array of the menu
	
	i = MenuId
	
	LAG_d_Menu[i].windowId = windowId
	
	if windowID <= 0 // main window
		LAG_d_Menu[i].depth = 6
	else
		LAG_d_Menu[i].depth = Lag_Window[windowId].depth -1
		if LAG_d_Menu[i].depth<0
			LAG_d_Menu[i].depth=0
		endif		
		Lag_Window[windowId].MenuId = MenuId
	endif
	

    LAG_v_CurrMenuId = MenuId // Set the current menu Id
    // LAG_CurrMenuId = MenuId // Set the current menu Id

	// now, we define the parameters of this menu
    i = LAG_v_NbMenu

    LAG_d_menu[i].NbMenuItem = - 1 // for the moment no menu title, nor menu item
    LAG_d_menu[i].NbMenuTitle = - 1
    
    // the space between two menu title, you can change that if you want.
    if space > 5
        LAG_d_menu[i].MenuSpace = space
    else
        LAG_d_menu[i].MenuSpace = 5
    endif





	// position and size
    LAG_d_Menu[i].PositionTitleX = 10
    LAG_d_Menu[i].TextSize = 18
    
    
   

	// image
    iw# = GetImageWidth(LAG_i_Menu[LAG_c_iMenu])
    if height > 6
        LAG_d_menu[i].Height = height
        ih# = height
    else
        LAG_d_menu[i].Height = GetImageHeight(LAG_i_Menu[LAG_c_iMenu])
        ih# = LAG_d_menu[i].Height
    endif

	// sprite
    LAG_d_menu[i].sprite = CreateSprite(LAG_i_Menu[LAG_c_iMenu])
    sp = LAG_d_menu[i].sprite

	


    SetSpriteSize(sp,GetVirtualWidth()+200,ih#)
    setSpriteUVscale(sp,iw#/GetSpriteWidth(sp),ih#/GetSpriteHeight(sp))
    SetSpriteDepth(sp,LAG_d_Menu[i].depth)
    FixSpriteToScreen(sp,1)
	SetSpritePosition(sp,-100,0)
	g = 500
	SetSpriteGroup(sp,g)
	
	LAG_d_menu[i].x = 0
	LAG_d_menu[i].y = 0
	LAG_d_menu[i].group = g
	  
	  
	  
    // the selected box
    LAG_d_menu[i].SelectedItemId = -1
    /*
    LAG_d_menu[i].SpSelect = CreateSprite(0)
    s = LAG_d_menu[i].SpSelect
    SetSpriteSize(s,100,LAG_d_menu[i].Height)
    SetSpriteColor(s,200,200,255,120)
    SetSpriteDepth(s,0)
    FixSpriteToScreen(s,1)
    SetSpriteGroup(s,LAG_d_menu[i].group)
    SetSpritePosition(s,-2000,0)
	*/

    inc LAG_v_NbMenu // we incremente the number of menu

EndFunction sp




// add a menu title or a menu item (menubar not finished)
Function LAG_MenuTitle(MenuId,txt$)

    i = MenuId

    inc  LAG_d_menu[i].NbMenuTitle
    j =  LAG_d_menu[i].MenuTitle.length + 1 // LAG_d_menu[i].NbMenuTitle
    
    LAG_d_menu[i].MenuTitle.length = j
    
    // Global dim LAG_d_MenuTitle[j] as LAG_t_MenuTitle
    

    LAG_d_menu[i].MenuTitle[j].y = 5 + LAG_d_menu[i].y
    LAG_d_menu[i].MenuTitle[j].id = LAG_d_menu[i].NbMenuTitle
    LAG_d_menu[i].MenuTitle[j].position = LAG_d_menu[i].NbMenuTitle
    LAG_d_menu[i].MenuTitle[j].menuId = i

    ih# = LAG_d_menu[i].Height // GetImageHeight(LAG_i_Menu[LAG_c_iMenu])

    // position & size of the title
    x = LAG_d_Menu[i].PositionTitleX + LAG_d_menu[i].x
    y =  LAG_d_menu[i].MenuTitle[j].y
    LAG_d_menu[i].MenuTitle[j].x = x

    LAG_d_menu[i].MenuTitle[j].Width = 150

    size = LAG_d_Menu[i].TextSize
    w = Len(txt$)*size/2
    h = size + 6

    LAG_d_menu[i].MenuTitle[j].PositionItemY =   LAG_d_menu[i].MenuTitle[j].y + h + 2
	
	LAG_d_menu[i].MenuTitle[j].h = h

    // add the sprite and text
    LAG_d_menu[i].MenuTitle[j].sprite = LAG_AddSprite(LAG_i_Menu[LAG_c_iMenu],x,0,w,ih#,1,LAG_d_Menu[i].depth)
	sp =  LAG_d_menu[i].MenuTitle[j].sprite
	g = 500
	SetSpriteGroup(sp,g)


    LAG_d_menu[i].MenuTitle[j].textId = LAG_CreateTExt(txt$,x+w/2,y+2,LAG_d_Menu[i].depth,1,size)
    LAG_d_menu[i].MenuTitle[j].text$ = txt$
    n=LAG_d_menu[i].MenuTitle[j].textId 

    SetTextAlignment(n,1)
	SetTextColor(n,LAG_TextColorR,LAG_TextColorG,LAG_TextColorB,255)

    // need to change the width of the sprite and position
    w = GetTextTotalWidth( LAG_d_menu[i].MenuTitle[j].textId)
    SetSpriteSize(LAG_d_menu[i].MenuTitle[j].sprite,w,ih#)
    SetTextPosition(LAG_d_menu[i].MenuTitle[j].textId, x+w/2,y+2)

    // position x
    LAG_d_Menu[i].PositionTitleX = LAG_d_Menu[i].PositionTitleX + w + LAG_d_menu[i].MenuSpace

    //SetSpriteDepth(LAG_d_menu[LAG_CurrMenuId].SpSelect,0)

EndFunction


Function LAG_MenuItem(MenuTitleId,MenuItemId,txt$)


	
    i = MenuTitleId // to know the id othe menu title, and use some of his parameters (size...)

	k =  LAG_v_CurrMenuId


    if MenuItemId >-1 // we use the MenuItemId parameter. If we use a defined integer, we have to verify if the array.length is ok
		// we verify the lenght of the dim
        if LAG_d_menu[k].NbMenuItem <= MenuItemId
            LAG_d_menu[k].NbMenuItem = MenuItemId
            AddNewItem = 1
        endif
    else //add an item dynamically
        inc LAG_d_menu[k].NbMenuItem
        AddNewItem = 1
    endif

	
	// we have define the MenuTitle for reference for this menuitem, we can use add a newitem on this menu
    // add a new item
    if AddNewItem = 1
        k1 = LAG_d_menu[k].NbMenuItem // the new number of item of this menu
        // Global dim LAG_d_MenuItem[k1] as LAG_t_MenuItem  // we add a new item in the array (of the menu)
    
		LAG_d_menu[k].MenuItem.length = k1
    
    endif

	// now, define the  parameters of the  menuitem
    j = MenuItemId

    LAG_d_menu[k].MenuItem[j].menuTitleId = MenuTitleId
    LAG_d_menu[k].MenuItem[j].Actif = 1
    LAG_d_menu[k].MenuItem[j].Enable = 1
	
	// the text
	LAG_d_menu[k].MenuItem[j].text$ = txt$
 
    // size of the font for the text
    size = LAG_d_Menu[k].TextSize

    // verify if the text isn't too long
    // max 200 px - you can change it if you want
    u=100
    if len(txt$)> u
        txt$ = left(txt$,u)
    endif


    // the width of all menuitem of the menutitle
    w = LAG_d_menu[k].MenuTitle[i].Width
    resize = 0
    if w < len(txt$)*8 
		
		// if the new textsize is > the old textsize (stocked in LAG_d_MenuTitle[i].Width)
		// we change it for all the other menu of this menu title
        w = len(txt$)*8
        LAG_d_menu[k].MenuTitle[i].Width = w
        
        resize = 1
        
    endif


	// parameters of this menuItem
    h = size + 10
    LAG_d_menu[k].MenuItem[j].y = LAG_d_menu[k].MenuTitle[i].PositionItemY
    LAG_d_menu[k].MenuItem[j].x = LAG_d_menu[k].MenuTitle[i].x -10
    x = LAG_d_menu[k].MenuItem[j].x
    y = LAG_d_menu[k].MenuItem[j].y


    // the text (x,y,id and text$)
    LAG_d_menu[k].MenuItem[j].textX = x+10
    LAG_d_menu[k].MenuItem[j].textY	= y+h/2-size/2
    LAG_d_menu[k].MenuItem[j].textId = LAG_CreateText(txt$,x+10,y+h/2-size/2,0,1,size)
    LAG_d_menu[k].MenuItem[j].text$ = txt$
    n = LAG_d_menu[k].MenuItem[j].textId
	SetTextColor(n,LAG_TextColorR,LAG_TextColorG,LAG_TextColorB,255)


	// size
	LAG_d_menu[k].MenuItem[j].w = w
    LAG_d_menu[k].MenuItem[j].h = h
	
	
	// the sprite groupe
	g = 500


	


	// on crée l'ombre si on ne l'a pas déjà
	if GetSpriteExists(LAG_d_menu[k].MenuTitle[i].spriteShadow)=0
		n =  LAG_AddSprite(0,x,-1000,w,h,1,0)
		LAG_d_menu[k].MenuTitle[i].spriteShadowX = x+2
		LAG_d_menu[k].MenuTitle[i].spriteShadowY = y+1
		LAG_d_menu[k].MenuTitle[i].spriteShadow = n
		SetSpriteColor(n,0,0,0,80)
		SetSpriteGroup(n,g)
		// then resize the sprite
		h1 = LAG_d_menu[k].MenuTitle[i].PositionItemY + h - LAG_d_menu[k].MenuTitle[i].h-3
		SetSpriteSize(n,w+2,h1)
	else
		n = LAG_d_menu[k].MenuTitle[i].spriteShadow
		h1 = LAG_d_menu[k].MenuTitle[i].PositionItemY + h - LAG_d_menu[k].MenuTitle[i].h-3
		SetSpriteSize(n,w+2,h1)
		SetSpriteGroup(n,g)
	endif

	// on crée la bordure si on ne l'a pas déjà
	if GetSpriteExists(LAG_d_menu[k].MenuTitle[i].spriteBord)=0
		n =  LAG_AddSprite(0,x-1,-1000,w,h,1,0)
		LAG_d_menu[k].MenuTitle[i].spriteBordX = x-2
		LAG_d_menu[k].MenuTitle[i].spriteBordY = y-2
		LAG_d_menu[k].MenuTitle[i].spriteBord = n
		SetSpriteColor(n,120,120,120,255)
		SetSpriteGroup(n,g)
		// then resize the sprite
		h1 = LAG_d_menu[k].MenuTitle[i].PositionItemY + h - LAG_d_menu[k].MenuTitle[i].h -3 //GetSpriteHeight(n)+h-4
		SetSpriteSize(n,w+4,h1)
	else
		n = LAG_d_menu[k].MenuTitle[i].spriteBord
		h1 = LAG_d_menu[k].MenuTitle[i].PositionItemY + h - LAG_d_menu[k].MenuTitle[i].h -3 //GetSpriteHeight(n)+h-4
		SetSpriteSize(n,w+4,h1)
		SetSpriteGroup(n,g)
	endif

	




    // create the main sprite 
    n = LAG_AddSprite(LAG_i_Menu[LAG_c_iMenuItem],x,y,w,h,1,0)
	LAG_d_menu[k].MenuItem[j].sprite = n
	SetSpriteGroup(n,g)
	
	
	if menuItemId = C_MENU_GamePropertie
		

		LAG_LastMenuID = n
		//MEssage("menu : "+txt$+"/"+str(n))
	endif
	
	
	// on resize tous les menus si la width est plus grande qu'avant
	if resize = 1
		
		// resize all the other menuitem sprite
        for u = 0 to LAG_d_menu[k].MenuItem.length //j
            if LAG_d_menu[k].MenuItem[u].menuTitleId = MenuTitleId
                LAG_d_menu[k].MenuItem[u].w = w
                SetSpriteSize(LAG_d_menu[k].MenuItem[u].sprite,w, GetSpriteHeight(LAG_d_menu[k].MenuItem[u].sprite))
            endif
        next u
		
		
		// then resize the menubar of this menu
		for u = 0 to  LAG_d_menu[k].MenuTitle[i].MenuBar.length //j
			LAG_d_menu[k].MenuTitle[i].MenuBar[u].w = w
			n =  LAG_d_menu[k].MenuTitle[i].MenuBar[u].sprite
			SetSpriteSize(n,w, GetSpriteHeight(n))
        next u
		
	endif

	// position (for the next menuitem)
    LAG_d_menu[k].MenuTitle[i].PositionItemY = LAG_d_menu[k].MenuTitle[i].PositionItemY + h


	// for the moment, you don't have to see this menuitem ^^
    SetSpritePosition(LAG_d_menu[k].MenuItem[j].sprite, x, -10000)
    SetTextPosition(LAG_d_menu[k].MenuItem[j].textId, x, -10000)


EndFunction


Function LAG_MenuBar(MenuTitleId)

    //************* not finished ?
    i = MenuTitleId
    k = LAG_v_CurrMenuId
   
    
    
    
    
    size = LAG_d_Menu[k].TextSize
	x1 = 10 // LAG_d_Menu[k].PositionTitleX

    w =  LAG_d_menu[k].MenuTitle[i].Width
    h = GetImageHeight(LAG_i_Menu[LAG_c_iMenuBar])
    y =  LAG_d_menu[k].MenuTitle[i].PositionItemY
    
     
    // need to create a special menuitem for the menubar
    j =  LAG_d_menu[k].NbMenuItem
	
	n = LAG_d_menu[k].MenuTitle[i].MenuBar.length + 1 
	LAG_d_menu[k].MenuTitle[i].MenuBar.length = n 
   
    LAG_d_menu[k].MenuTitle[i].MenuBar[n].sprite = LAG_AddSprite(LAG_i_Menu[LAG_c_iMenuBar],-1000,y,w,h,1,0)
    LAG_d_menu[k].MenuTitle[i].MenuBar[n].x = LAG_d_menu[k].MenuTitle[i].x-x1
    LAG_d_menu[k].MenuTitle[i].MenuBar[n].y = y
    LAG_d_menu[k].MenuTitle[i].MenuBar[n].MenuTitleId = MenuTitleId
	LAG_d_menu[k].MenuTitle[i].PositionItemY = LAG_d_menu[k].MenuTitle[i].PositionItemY + GetImageHeight(LAG_i_Menu[LAG_c_iMenuBar])
    
	sp =  LAG_d_menu[k].MenuTitle[i].MenuBar[n].sprite
	g = 500
	SetSpriteGroup(sp,g)

EndFunction




//**************** Get

Function LAG_GetCurrentMenu()
    // to get the current menu used
    MenuId = LAG_v_CurrMenuId
EndFunction MenuId


Function LAG_GetMenuTitleText(MenuId,MenutitleId)

    txt$ = LAG_d_menu[MenuId].MenuTitle[MenutitleId].text$

EndFunction txt$


Function LAG_GetMenuItemText(MenuId,MenuItemId)

    txt$ = LAG_d_menu[MenuId].MenuItem[MenuItemId].text$

EndFunction txt$


Function LAG_GetMenuState(MenuId)

    state = LAG_d_menu[MenuId].state

EndFunction state



//**************** Set

Function LAG_SetMenuPosition(MenuId,x,y)

	i = menuId


	// d'abord, je conserve la position précédentedu menu
	OldX =  LAG_d_menu[i].x 
	OldY =  LAG_d_menu[i].y 

	//puis, je vérifie si la position n'est pas ignorée
    LAG_d_menu[i].x = LAG_Ignore(LAG_d_menu[i].x, x)
    LAG_d_menu[i].y = LAG_Ignore(LAG_d_menu[i].y, y)

	x = LAG_d_menu[i].x
	y = LAG_d_menu[i].y

    // move the position of the menu
	SetSpritePosition(LAG_d_menu[i].sprite,LAG_d_menu[i].x,LAG_d_menu[i].y) 


	// then move the menu title
	for j=0 to LAG_d_menu[i].MenuTitle.Length 
		
		// text
		n = LAG_d_menu[i].MenuTitle[j].textId
		x1 = GetTextX(n) - OldX		
		y = LAG_d_menu[i].y		
		SetTextPosition(LAG_d_menu[i].MenuTitle[j].textId, x+x1,y+7)
		
		// sprite
		n =  LAG_d_menu[i].MenuTitle[j].sprite
		x1 = GetSpriteX(n) - OldX
		SetSpritePosition(n,x+x1, y)
		LAG_d_menu[i].MenuTitle[j].x = x+x1
		
		
		// Only change the X position, because it only change
		
		
		// sprite bord
		n =  LAG_d_menu[i].MenuTitle[j].spriteBord
		x1 = LAG_d_menu[i].MenuTitle[j].spriteBordX - oldX
		//y1 = LAG_d_menu[i].MenuTitle[j].spriteBordy - oldy
		LAG_d_menu[i].MenuTitle[j].spriteBordX = x+x1
		//LAG_d_menu[i].MenuTitle[j].spriteBordY = y+y1
		
		//sprite shadow
		n =  LAG_d_menu[i].MenuTitle[j].spriteShadow
		x1 = LAG_d_menu[i].MenuTitle[j].spriteShadowX - oldX
		//y1 = LAG_d_menu[i].MenuTitle[j].spriteShadowY - oldy
		LAG_d_menu[i].MenuTitle[j].spriteShadowX = x+x1
		//LAG_d_menu[i].MenuTitle[j].spriteShadowY = y+y1
		
		
		//menu bar
		
		for k=0 to LAG_d_menu[i].MenuTitle[j].MenuBar.length
			//sprite shadow
			n =  LAG_d_menu[i].MenuTitle[j].MenuBar[k].sprite
			x1 = LAG_d_menu[i].MenuTitle[j].MenuBar[k].x - oldX
			//y1 = LAG_d_menu[i].MenuTitle[j].MenuBar[k].y - oldy
			LAG_d_menu[i].MenuTitle[j].MenuBar[k].x = x+x1
			//LAG_d_menu[i].MenuTitle[j].MenuBar[k].y = y+y1
		
		next
		
		
	next
	
	// then move the menuitem (menuitem = submenu (text + sprite to select it)
	
	for j=0 to LAG_d_menu[i].MenuItem.Length 
		
		n = LAG_d_menu[i].MenuItem[j].textId
		x1 = LAG_d_menu[i].MenuItem[j].textX - OldX		
		//y1 = LAG_d_menu[i].MenuItem[j].textY - oldY
		//SetTextPosition(LAG_d_MenuItem[j].textId, x+x1,y+y1)
		LAG_d_menu[i].MenuItem[j].textX = x + x1
		//LAG_d_menu[i].MenuItem[j].textY = y + y1
		
		// sprite
		n =  LAG_d_menu[i].MenuItem[j].sprite
		x1 = LAG_d_menu[i].MenuItem[j].x - OldX
		//y1 = LAG_d_menu[i].MenuItem[j].y - Oldy		
		//SetSpritePosition(n,x+x1,y+y1)
		LAG_d_menu[i].MenuItem[j].X = x+x1
		//LAG_d_menu[i].MenuItem[j].Y = y+y1
		
	next
	

EndFunction


Function LAG_SetMenuSize(MenuId, width, height)
	
	// to set the size of the menu
	n = LAG_d_menu[MenuId].sprite
	w = width
	h= height
	if width = -1
		w= GetSpriteWidth(n)
	endif
	if height=-1
		h = GetSpriteHeight(n)
	endif
	SetSpritesize(n,w,h) 

EndFunction


Function LAG_SetCurrentMenu(MenuId)
    // to Set the current menu used
    LAG_v_CurrMenuId = MenuId

EndFunction


Function LAG_SetMenuState(MenuId, state)

    LAG_d_menu[MenuId].state = state

EndFunction


Function LAG_SetMenuItemText(MenuId,MenuItemId,text$)

    LAG_d_menu[MenuId].menuItem[MenuItemId].text$ = text$
    SetTextString( LAG_d_menu[MenuId].menuItem[MenuItemId].textId, text$)

EndFunction





//**************** event menu


Function LAG_EventMenu()

    EventMenu = -1

	p = LAG_v_CurrMenuId


    if LAG_Event_Type = LAG_c_EventTypeMouseReleased

        // if we touch a menuItem, we have to know what is his number to do the action
        for i = 0 to LAG_d_menu[p].MenuItem.length // 
            
            if LAG_d_menu[p].MenuItem[i].Actif = 1
				
				//if LAG_d_MenuItem[i].sprite = LAG_NumSpId 
                if LAG_d_menu[p].MenuItem[i].sprite = LAG_d_menu[p].SelectedItemId or LAG_d_menu[p].MenuItem[i].sprite = LAG_NumSpId
                    LAG_CloseMenu()
                    EventMenu = i
                    Options.MenuOpen = 0 
                    exit
                endif
                
            endif
            
        next i
        
      

    elseif LAG_Event_Type = LAG_c_EventTypeMousePressed
		
        state = LAG_GetMenuState(p) //what is the state of the current menu
        
        if state = 1 // it's opened, so we can test the menu item
			
			// on vérifie qu'on n'a pas quitté un menu item, on est donc au delà d'un menu
			
			for i =0 to LAG_d_menu[p].MenuItem.length //NbMenuItem
                //if LAG_d_MenuItem[i].Actif = 1
                    if LAG_d_menu[p].MenuItem[i].sprite = LAG_NumSpId 
						ok = 1
						exit
					endif
				//endif
			next
			
			if ok = 0
				// on n'est pas sur un menu item, on est donc au delà d'un menu
				LAG_CloseMenu()
                EventMenu = -1
                Options.MenuOpen = 0
            else
				
			endif
						
            /*
            // it's better to not use the mousepressed to activate a menuitem, use only the mousereleased, it's like a normal windows menu
            for i =0 to LAG_d_menu[LAG_v_CurrMenuId].NbMenuItem
                if LAG_d_MenuItem[i].Actif = 1
                    if LAG_d_MenuItem[i].sprite = LAG_d_menu[LAG_v_CurrMenuId].SelectedItemId or LAG_d_MenuItem[i].sprite =LAG_NumSpId
                        LAG_SetMenuState(LAG_v_CurrMenuId,0)
                        LAG_OpenMenuItem(-1)
                        EventMenu = i
                        LAG_v_MenuItemId = -1
                        LAG_d_menu[LAG_v_CurrMenuId].SelectedItemId = -1
                        SetSpritePosition(LAG_d_menu[LAG_v_CurrMenuId].SpSelect,-5000,-5000)
                        Sync()
                        exit
                    endif
                endif
            next i
            */
        
        else // the menu isn't opened, so we have to test the menu title
            for i =0 to LAG_d_menu[p].MenuTitle.length  //.NbMenuTitle
                if LAG_d_menu[p].MenuTitle[i].sprite= LAG_d_menu[p].SelectedItemId or LAG_d_menu[p].MenuTitle[i].sprite=LAG_NumSpId
                    // EventMenu = i  // if you need to know the number of the menutitle, you can uncomment this line
                    LAG_OpenMenuItem(i)                    
                    LAG_SetMenuState(p,1)
                    LAG_v_MenuItemId = i
                    exit
                endif
            next i
        endif
		

    elseif LAG_Event_Type = LAG_c_EventTypeMouse or LAG_Event_Type=LAG_c_EventTypeMouseMove
		
		// with mouse move, we verify only if the menu is opened and if the mouse is over it
		
        state = LAG_GetMenuState(p)

        if LAG_v_EventMenuId > -1 and state = 1

            spSel = LAG_d_menu[p].SpSelect
            //if the sprite for the menuitem selection doens't exist, create it !
			if GetSpriteExists(spSel) = 0
				LAG_d_menu[p].SpSelect = CreateSprite(0)
				s = LAG_d_menu[p].SpSelect
				SetSpriteSize(s, 100, LAG_d_menu[p].Height)
				SetSpriteColor(s,200,200,255,120)
				SetSpriteDepth(s,0)
				FixSpriteToScreen(s,1)
				SetSpriteGroup(s,LAG_d_menu[p].group)
				SetSpritePosition(s,-2000,0)
			endif
			
			
			ym0 = getspriteY(LAG_d_menu[p].sprite) // LAG_d_Menu[p].y 
			// we verify the menu title
            for i =0 to LAG_d_menu[p].MenuTitle.length  // .NbMenuTitle
                
                if LAG_d_menu[p].MenuTitle[i].sprite= LAG_NumSpId
                    // EventMenu = i  // if you need to know the number of the menutitle, you can uncomment this line
                    LAG_OpenMenuItem(-1)
                    LAG_OpenMenuItem(i)
                    LAG_v_MenuItemId = i
                    
                    //LAG_SetMenuState(p,1)
                    if GetSpriteExists(spSel)
						SetSpritePosition(spSel,LAG_d_menu[p].MenuTitle[i].x-10,ym0)						
						SetSpriteSize(spSel,GetSpriteWidth(LAG_d_menu[p].MenuTitle[i].sprite)+20,GetSpriteHeight(LAG_d_menu[p].MenuTitle[i].sprite) )
                    endif
                    
                    exit
                    
                endif
                
            next i
            
			// and we verify the menu item
            for i =0 to LAG_d_menu[p].MenuItem.length // .NbMenuItem
               
                if LAG_d_menu[p].MenuItem[i].Actif = 1
                    
                    if LAG_d_menu[p].MenuItem[i].sprite = LAG_NumSpId //or LAG_d_MenuItem[i].sprite = LAG_d_menu[p].SelectedItemId
                        // EventMenu = i
                        // LAG_SetMenuState(p,1)
                        LAG_d_menu[p].SelectedItemId = LAG_d_menu[p].MenuItem[i].sprite
                        //SetSpritePosition(spSel,LAG_d_menu[p].MenuItem[i].x, LAG_d_menu[p].MenuItem[i].y)
                        ym0 = getspriteY(LAG_d_menu[p].MenuItem[i].sprite) 
                        SetSpritePosition(spSel,LAG_d_menu[p].MenuItem[i].x, ym0)
                        SetSpriteSize(spSel,GetSpriteWidth(LAG_d_menu[p].MenuItem[i].sprite),GetSpriteHeight(LAG_d_menu[p].MenuItem[i].sprite) )
                        exit
                        
                    endif
                    
                endif
                
            next i

        endif

    Endif

	LAG_Event_Menu = EventMenu
	
EndFunction EventMenu


Function LAG_OpenMenuItem(i)

	// to close or open a menu item/Title
		
	nyy = -5000
	
	p=LAG_v_CurrMenuId
	
    if LAG_d_menu[p].MenuItem.length >=0  //.NbMenuItem >= 0
		
		FoldStart // close all the menu
        if i = -1 
            For j = 0 to LAG_d_menu[p].MenuItem.length // .NbMenuItem
                if LAG_d_menu[p].MenuItem[j].Actif = 1
                    SetSpritePosition(LAG_d_menu[p].MenuItem[j].sprite,LAG_d_menu[p].MenuItem[j].x,nyy)
                    SetTextPosition(LAG_d_menu[p].MenuItem[j].textId, LAG_d_menu[p].MenuItem[j].x, nyy)
                endif
            next j
            // hide the menu bar
            for k =0 to LAG_d_menu[p].MenuTitle.length
				
				SetSpritePosition(LAG_d_menu[p].MenuTitle[k].spriteBord,0,nyy)
				SetSpritePosition(LAG_d_menu[p].MenuTitle[k].spriteShadow,0,nyy)
				
				For j=0 to LAG_d_menu[p].MenuTitle[k].MenuBar.length
					SetSpritePosition(LAG_d_menu[p].MenuTitle[k].MenuBar[j].sprite,LAG_d_menu[p].MenuTitle[k].MenuBar[j].x,nyy)
				next
            next
            LAG_MenuOpen = 0
            Options.MenuOpen = 0
            
            //set editbox active
            for i=0 to LAG_D_Gadget.length
				If LAG_D_Gadget[i].typ = LAG_C_TYPSTRING
					SetEditBoxactive(LAG_D_Gadget[i].EditBoxId,1)
				endif
			Next   
           
        Foldend
           
            
        else 
		
		FoldStart // open the specific menu	
			
			ym0 = LAG_d_Menu[p].y 

            For j = 0 to LAG_d_menu[p].MenuItem.length // .NbMenuItem
                if LAG_d_menu[p].MenuItem[j].Actif = 1
                    if LAG_d_menu[p].MenuItem[j].MenuTitleId = i
                        SetSpritePosition(LAG_d_menu[p].MenuItem[j].sprite,LAG_d_menu[p].MenuItem[j].x,LAG_d_menu[p].MenuItem[j].y + ym0)
                        SetTextPosition(LAG_d_menu[p].MenuItem[j].textId, LAG_d_menu[p].MenuItem[j].textX, LAG_d_menu[p].MenuItem[j].TextY + ym0)
                        LAG_MenuOpen = 1
                        Options.MenuOpen = 1
                    endif
                endif
            next j
            
            SetSpritePosition(LAG_d_menu[p].MenuTitle[i].spriteBord,LAG_d_menu[p].MenuTitle[i].spriteBordX,LAG_d_menu[p].MenuTitle[i].spriteBordY+ym0)
            SetSpritePosition(LAG_d_menu[p].MenuTitle[i].spriteShadow,LAG_d_menu[p].MenuTitle[i].spriteShadowX,LAG_d_menu[p].MenuTitle[i].spriteShadowY+ym0)
            
            For j=0 to LAG_d_menu[p].MenuTitle[i].MenuBar.length				
				SetSpritePosition(LAG_d_menu[p].MenuTitle[i].MenuBar[j].sprite,LAG_d_menu[p].MenuTitle[i].MenuBar[j].x,LAG_d_menu[p].MenuTitle[i].MenuBar[j].y + ym0)
            next
            
             //set editbox unactive
            for i=0 to LAG_D_Gadget.length
				If LAG_D_Gadget[i].typ = LAG_C_TYPSTRING
					SetEditBoxactive(LAG_D_Gadget[i].EditBoxId,0)
				endif
			Next      
          
        Foldend  
            
        endif
    endif

EndFunction


Function LAG_CloseMenu()
	
	LAG_SetMenuState(LAG_v_CurrMenuId,0)
	LAG_v_MenuItemId = -1
	LAG_OpenMenuItem(-1)
	EventMenu = -1                 
	LAG_d_menu[LAG_v_CurrMenuId].SelectedItemId = -1	
	SetSpritePosition(LAG_d_menu[LAG_v_CurrMenuId].SpSelect,-5000,-5000)
	
	
EndFunction


// Delete menu
Function Lag_DeleteMenu(MenuId)

	// delete sprite
	// delete text
	
	//message("menuid à supprimer : "+str(MenuID))
	
	i = MenuID 
		
	n = LAG_d_Menu[i].sprite
	if GetSpriteExists(n)
		deleteSprite(n)
	endif
	
	n = LAG_d_Menu[i].SpSelect
	if GetSpriteExists(n)
		deleteSprite(n)
	endif
	
	For j=0 to LAG_d_menu[i].MenuTitle.length
		
		n = LAG_d_menu[i].MenuTitle[j].sprite
		if GetSpriteExists(n)
			deleteSprite(n)
		endif
		n = LAG_d_menu[i].MenuTitle[j].spriteBord
		if GetSpriteExists(n)
			deleteSprite(n)
		endif
		n = LAG_d_menu[i].MenuTitle[j].spriteShadow
		if GetSpriteExists(n)
			deleteSprite(n)
		endif
		
		n = LAG_d_menu[i].MenuTitle[j].textId
		if GetTextExists(n)
			deletetext(n)
		endif
		
		// delete the sprite of menubar
		for k=0 to LAG_d_menu[i].MenuTitle[j].MenuBar.length
			n = LAG_d_menu[i].MenuTitle[j].MenuBar[k].sprite
			if GetSpriteExists(n)
				deleteSprite(n)
			endif		
		next
		
	next
		
	For j=0 to LAG_d_menu[i].MenuItem.length
		n = LAG_d_menu[i].MenuItem[j].sprite
		if GetSpriteExists(n)
			deleteSprite(n)
		endif				
		n = LAG_d_menu[i].MenuItem[j].textId
		if GetTextExists(n)
			deletetext(n)
		endif
	next
	
	// remove menu
	LAG_d_menu.remove(i)
	LAG_v_NbMenu = LAG_d_menu.length

	LAG_v_CurrMenuId = 0

Endfunction








