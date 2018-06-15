//******************** window ***********************//


Type tLAg_Window
	
	Id as integer 
	Gadget as LAG_t_Gadget[] // list of gadget assigned to the window ?
	X as float	
	y as float
	StartX as float	
	StartY as float	
	
	Depth as integer
	MenuId as integer
	
	W as integer
	H as integer
	Hbase as integer // height at creation
	H1 as integer // height of the border
	
	Title$
	
	Mini as integer // is the window minimised ?
	
	//the menubox id
	BGId as integer
	MainBgId as integer
	
	//for the border
	BorderId as integer
	
	//the Three buttons : close, minimize, maximize
	BtnClose as integer
	BtnMin as integer
	
	// The Title text$	
	TextId as integer
	
	
EndType



// init the windows
Function LAG_InitWindow()
	
	Global LAG_CurrentWindow as integer
	Global LAG_ActiveWindowId as integer
	Global LAG_EventWindow as integer
		
	Global Dim Lag_Window[] as tLag_window


EndFunction

Function Lag_AddWindow(id)
	
	FreeToolTips()
	
	if id = -1
		// not possible for the moment
		// Global Dim Lag_Window[] as tLag_window
	else
		Global Dim Lag_Window[id] as tLag_window
		LAG_CurrentWindow = id
		LAG_ActiveWindowId  = id		
	endif
	
EndFunction


Function LAg_SetWindowColor(i,r,g,b)
	
	id = Lag_Window[i].MainBgId	
	LAG_SetMenuBoxColor(id,r,g,b)
	
EndFunction



// Move
Function Lag_MoveWindowGadget(i)
	
	For j=0 to LAG_D_Gadget.length // Lag_Window[i].
		
		if LAG_D_Gadget[j].WindowId = i
			
			x1 = Lag_Window[i].x - LAG_D_Gadget[j].winx + 5
			y1 = Lag_Window[i].y - LAG_D_Gadget[j].WinY + Lag_Window[i].h1
			x2 = Lag_Window[i].x
			y2 = Lag_Window[i].y
						
			y = LAG_D_Gadget[j].y
			x = LAG_D_Gadget[j].x+x1
			y3 = LAG_D_Gadget[j].y+y1
			
			w = Lag_Window[i].w //LAG_D_Gadget[j].w
			h = Lag_Window[i].h //LAG_D_Gadget[j].h
			
			n1 = LAG_D_Gadget[j].spr1
			n = LAG_D_Gadget[j].id
			
			if (n>=100006 and n<=100061)or (n1>=100006 and n<=100061)
				//message("ici !!!!!!!!!!!!!!!!!!!!!!! "+LAG_D_Gadget[j].text$+"/"+LAG_D_Gadget[j].name$)
			endif
			
			
			
			SetSpritePosition(LAG_D_Gadget[j].id, x,y3)
			SetSpriteScissor(n,x,y3,x+w,y3+h)
			
			n = LAG_D_Gadget[j].spr1
			if GetSpriteExists(n)
				SetSpritePosition(n, LAG_D_Gadget[j].spr1x+x1, LAG_D_Gadget[j].spr1y+y1) // + y3 au lieu de y1 ?
				SetSpriteScissor(n,x,y3,x+w,y3+h)
			endif
						
			For k=0 to LAG_D_Gadget[j].spr.length				
				n = LAG_D_Gadget[j].spr[k].id
				if GetSpriteExists(n)
						
					if n>=100006 and n<=100061
						message("ici !!!!!!!!!!!!!!!!!!!!!!! "+LAG_D_Gadget[j].text$+"/"+LAG_D_Gadget[j].name$)
					endif
			 
					SetSpritePosition(n, LAG_D_Gadget[j].spr[k].x+x1, LAG_D_Gadget[j].spr[k].y+y1)
					SetSpriteScissor(n,x,y3,x+w,y3+h)
				Endif
			next
	
			
			// Les texts et editbox
			n= LAG_D_Gadget[j].TextId
			if GetTextExists(n)				
				xa = LAG_D_Gadget[j].TextX+x1  
				ya = LAG_D_Gadget[j].TextY+y1
				SetTextPosition(n,xa,ya)
				SetTextScissor(n,x2,y2,x2+w,y2+h)
			endif
			
			n= LAG_D_Gadget[j].nameId
			if GetTextExists(n)
				xa = LAG_D_Gadget[j].NameX + x1 
				ya = LAG_D_Gadget[j].NameY + y1 
				SetTextPosition(n,xa,ya)
				SetTextScissor(n,x2,y2,x2+w,y2+h)
			endif
			
			n= LAG_D_Gadget[j].EditBoxId
			if GetEditBoxExists(n)
				xa = LAG_D_Gadget[j].TextX + x1 + 2
				ya = LAG_D_Gadget[j].TextY + y1 + 2
				SetEditBoxPosition(n,xa,ya)
				SetEditboxScissor(n,x2,y2,x2+w,y2+h)
			endif
			
			
			x = 5+ x 
			
			// then, we move the gadgetitem if gadget has gadgetitem
			if  LAG_D_Gadget[j].typ = LAG_C_TYPLISTICON or LAG_D_Gadget[j].typ = LAG_C_TYPPANEL
				for k=0 to LAG_D_GadgetItem.length
				
					if LAG_D_GadgetItem[k].parentId = j
						w1 = LAG_D_Gadget[j].w
						h1 = LAG_D_Gadget[j].h
						w9 = 32				
						ih = 32
						y5 = LAG_d_Gadget[j].CurY
						y4 = 5 + y3 +(ih+2)*LAG_D_GadgetItem[k].position-y5 // LAG_D_Gadget[j].y // 
						
						//attention : not all the sprites and text
						n = LAG_D_GadgetItem[k].id
						SetSpritePosition(n,x,y4)
						SetSpriteScissor(n,x,y3+5,x+w1-w9,y3+h1-10)
						
						LAG_D_GadgetItem[k].Y=y4+y5
						
						n = LAG_D_GadgetItem[k].spr1
						if GetSpriteExists(n)
							SetSpritePosition(n,x,y4)
							SetSpriteScissor(n,x,y3+5,x+w1-w9,y3+h1-10)
						endif
						
						n= LAG_D_GadgetItem[k].TextId
						if GetTextExists(n)
							SetTextPosition(n, x+10+ih, y4+ih/2-8) // car y du text est en y-5 de base ;)
							SetTextScissor(n,x,y3+5,x+w1-w9,y3+h1-10)
						endif
						
						
					endif
				next
			endif
			
			
		endif
	next
	
EndFunction




//********** Function available for LAG
Function Lag_OpenWindow(id,x,y,w,h,Title$,flag)
	
	 
	FoldStart //init the window
	
		FoldStart // create the sprite and text 
		LAG_MenuOpen = 2
		
		i =0
		
		Lag_AddWindow(id)
				
		Lag_Window[id].x = x //+GetScreenBoundsLeft()
		Lag_Window[id].y = y //+GetScreenBoundsTop()
		Lag_Window[id].w = w
		Lag_Window[id].h = h
		Lag_Window[id].hbase = h
		Lag_Window[id].h1 = 35
		h1=Lag_Window[id].h1
		
		d = 5
		Lag_Window[id].depth  = d
		
		// the background sprite  = border of the window		
		u =210
		i = LAG_CreateMenuBox(x, y, w, h, LAG_C_ICORNER, 255)
		LAG_SetMenuBoxColor(i,u,u,u)
		LAG_setMenuBoxDepth(i,d)
		Fond = LAG_GetMenuboxSprite(i)			
		Lag_Window[id].BGId = i		
		Lag_Window[id].BorderId = Fond
		
		Lag_Window[id].MenuId = -1 // pas de menu par default
		
		// the main BG (= bg of the window)	
		i = LAG_CreateMenuBox(x+5, y+h1-5, w-10, h-h1, LAG_C_ICORNER, 255) 
		Menu = LAG_GetMenuboxSprite(i)	
		LAG_setMenuBoxDepth(i,d)
		LAG_SetMenuBoxColor(i,255,255,255)
		Lag_Window[id].MainBgId = i
		
		
		// Lag_Window[id].BorderId = LAG_CreateMenuBox(x-5, y, w, h, LAG_C_ICORNER, 255) 
		
		
		
		// title	
		FontId = LAG_FontId2
		u#=h1*0.6
		txtid = LAg_AddTextFix(x+w/2,y+5,title$,FontId,u#,0)
		SetTextAlignment(txtid,1)
		
		Lag_Window[id].TextId = txtid
		Lag_Window[id].Title$ = title$
		
		
		// buttons
		Lag_Window[id].BtnClose = LAG_AddSprite(Icon[C_Icon_Del],x+w-37,y+5,16,16,1,0) 
		
		Lag_Window[id].BtnMin = LAG_AddSprite(LAG_i_Gadget[LAG_C_IBUTTON] ,x+w-60,y+5,16,16,1,0) 
		SetSpriteColor(Lag_Window[id].BtnMin,255,50,50,255)
		
		
		
		
		LAG_EventWindow = -1
		
		FoldEnd
		
		
	Foldend
	
	
EndFunction i





// Close 
Function LAG_CloseWindow(i)
	
	//delete the background of the window
	// id = val(GetStringToken(id$,"/",1))
	
	LAG_FreeMenuBox(Lag_Window[i].BGId) // the background
	LAG_FreeMenuBox(Lag_Window[i].MainBgId)
		
	
	//delete the title of the window	
	DeleteText(Lag_Window[i].TextId)
	LAG_CurrWindowId = -1
	
	// delete the button of the window, if window has buttons
	if Lag_Window[i].BtnClose > -1
		DeleteSprite(Lag_Window[i].BtnClose)
	Endif
	if Lag_Window[i].BtnMin > -1
		DeleteSprite(Lag_Window[i].BtnMin)
	endif
		
	
	// Delete All the gdagets of the window
	For j=0 to LAG_D_Gadget.length
		if LAG_D_Gadget[j].WindowId = i			
			LAG_FreeGadget(j)
		endif
	next
	
	if Lag_Window[i].MenuId >-1
		Lag_DeleteMenu(Lag_Window[i].MenuId)
	endif
	
	
	
	Lag_window.remove(i)
	LAG_EventWindow = -1
	LAG_ActiveWindowId = -1
	
	
	LAG_CurrentWindow = - 1
	
	
	
	
	
	// Message("il reste : "+str(Lag_window.length )+" windows")
	/*
	while GetpointerReleased()=0
		sync()
	endwhile
	*/
	
EndFunction







// to change some parameter  like viewoffset
Function LAG_Pause(vx,vy,z#)
		
	SetViewOffset(vx,vy)
	SetViewZoom(z#)
	
EndFunction



// Event window
Function LAG_EventWindow()
	
	// the event for the windows
	// we can move it, close it
	// ??? later : maximize, minimize, dock it ?
	
	// on met en pause le reste 
	//Vx = GetViewOffsetX()
	//Vy = GetViewOffsetY()	
	//z# = GetViewZoom()
	
	Lag_Pause(0,0,1)
	
	
	Foldstart 
	gx = GetPointerX()
	gy = GetpointerY()
	
		
	if Lag_window.length >-1		
		
		btn = GetSpriteHit(gx,gy)		
		// print("WINDOW | Buton : "+str(btn)+" - "+str(gx)+"/"+str(gy))

		If GetPointerPressed()
			
			LAG_ActiveWindowId = -1
			LAG_EventWindow = -1
			
			
			For i=0 to Lag_window.length
				
				if btn = Lag_Window[i].BorderId
					
					LAG_NumSpId = Lag_Window[i].BorderId
					LAG_ActiveWindowId = i
					LAG_EventWindow = LAG_C_MoveWindow
					
					// to know the start position of the window
					Lag_Window[i].StartX = Gx - Lag_Window[i].X
					Lag_Window[i].StartY = Gy - Lag_Window[i].Y
					
					// LAG_Event_Type = -1
					
					exit				
				endif
			Next
		
		
		elseif  GetPointerReleased() 
			
			For i=0 to Lag_window.length
				
				if btn= Lag_Window[i].BtnClose
						
					LAG_EventWindow = LAG_C_CloseWindow
					LAG_NumSpId = Lag_Window[i].BtnClose
					LAG_ActiveWindowId = i
					exit
					
						
				elseif btn = Lag_Window[i].BtnMin
						
						//LAG_EventWindow = LAG_C_MinimiseWindow
						//LAG_NumSpId = btn
						//LAG_ActiveWindowId = i
						
						//Lag_Window[i].mini = 1 - Lag_Window[i].mini 
						
						//Lag_Window[i].h = (Lag_Window[i].h1+5)*Lag_Window[i].mini + (Lag_Window[i].hbase)*(1-Lag_Window[i].mini)
						
						//LAg_setMenuBoxSize(Lag_Window[i].BgId,Lag_Window[i].w,Lag_Window[i].h+Lag_Window[i].h1)
						//LAg_setMenuBoxSize(Lag_Window[i].MainBgId,Lag_Window[i].w-10,Lag_Window[i].h)
						
						//exit
						
				endif
			next
				
		endif
		
		
		if LAG_ActiveWindowId > -1	
			
			If GetPointerState()
				
				if LAG_EventWindow = LAG_C_MoveWindow
				
					local xwin,ywin  as integer
					i = LAG_ActiveWindowId
					
					if i>0 // car 0 c'est la fenêtre main
						xwin = gx - Lag_Window[i].StartX 				
						ywin = gy - Lag_Window[i].StartY 
						Lag_Window[i].x = xwin
						Lag_Window[i].y = ywin
						
						// set the position for Border and main BG
						LAG_SetMenuBoxPosition(Lag_Window[i].BGId,xwin,ywin)		
						LAG_SetMenuBoxPosition(Lag_Window[i].MainBgId,xwin+5,ywin+Lag_Window[i].h1-5)
						
						// set position for title
						SetTextPosition(Lag_Window[i].TextId,xwin+Lag_Window[i].w/2,ywin+5)
						
						// butons position
						SetSpritePosition(Lag_Window[i].btnClose,xwin+Lag_Window[i].w-37,ywin+5)
						SetSpritePosition(Lag_Window[i].BtnMin,xwin+Lag_Window[i].w-60,ywin+5)
						
						// move all the gadget and gadgetitem of this windows !!!
						print("window id : "+str(i))			
						LAG_MoveWindowGadget(i)
					
					endif
					
				endif
			
				
			Endif
		Endif
		
		
	Endif
	
	
	Foldend
	
	
	//Lag_pause(vx,vy,z#)
	
EndFunction LAG_EventWindow


// GET

Function LAG_GetWindowX(i)
	if i>-1 and i<= Lag_Window.length
		xwin = Lag_Window[i].x
	endif
EndFunction xwin 

Function LAG_GetWindowY(i)
	if i>-1 and i<= Lag_Window.length
		xwin = Lag_Window[i].y
	endif
EndFunction xwin 
	
	
	
