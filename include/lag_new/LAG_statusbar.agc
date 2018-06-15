
//***************** statusbar


Type LAG_tField
	
	// the statusbar fields
	x as integer
	y as integer
	SpriteID as integer
	TextID as integer
	Text$
	W as integer
	
Endtype
	
Type LAG_tStatusBar
	
	Sprite as integer // the background of the statusbar, same image as menu
	X as integer
	Y as  integer
	// field for text
	Field as LAG_tField[]
	
	TotalW as integer
	ID as integer // used ?
	
EndType




// init
Function Lag_InitStatusBar()
	
	Global dim LAG_StatusBar[] as LAG_tStatusBar
	
EndFunction




// Add
Function LAG_AddStatusBar(id)
	
	
	if id =-1
		i = LAG_StatusBar.length +1
		LAG_StatusBar.length = i
	else
		if id >=LAG_StatusBar.length
			LAG_StatusBar.length = id
			i =LAG_StatusBar.length
		else
			i = id
		endif
	endif
	
	
	// add the statusbar 
	
	n = CreateSprite(LAG_i_Menu[LAG_c_iMenu])
	LAG_StatusBar[i].Sprite = n
	w = GetScreenBoundsRight() - GetScreenBoundsleft()
	SetSpriteSize(n,w,30)
	LAG_StatusBar[i].x = GetScreenBoundsleft()
	LAG_StatusBar[i].y = GetScreenBoundsBottom()-25
	
	SetSpritePosition(n,LAG_StatusBar[i].x, LAG_StatusBar[i].y)

	FixSpriteToScreen(n,1)
	SetSpriteDepth(n,9)
	SetSpritegroup(n,500)
	
EndFunction

Function LAG_AddStatusBarField(id, width)
	
	// add a statusbar field
	
	i = LAG_StatusBar[id].Field.length +1
	LAG_StatusBar[id].Field.length = i 
	
	x = 5 + LAG_StatusBar[id].TotalW
	y = GetSpriteY(LAG_StatusBar[id].Sprite)+4	

	// i = LAG_StatusBar.Id
	n = CreateText("")
	LAG_StatusBar[id].Field[i].TextID = n
	LAG_StatusBar[id].Field[i].x = x
	LAG_StatusBar[id].Field[i].y = y	
	SetTextPosition(n,x,y)
	FixTextToScreen(n,1)
	SetTextDepth(n,9)
	SetTextSize(n,15)
	
	LAG_StatusBar[id].TotalW = LAG_StatusBar[id].TotalW +width
	
	inc LAG_StatusBar[id].Id
	
EndFunction




// Set 
Function LAG_SetStatusBarHeight(id,height)
	
	n = LAG_StatusBar[id].Sprite
	SetSpriteSize(n,getspritewidth(n),height+5)
	
EndFunction

Function LAG_SetStatusBarWidth(id,width)
	
	n = LAG_StatusBar[id].Sprite
	SetSpriteSize(n,width,getspriteheight(n))
	
EndFunction

Function LAG_SetStatusBarPosition(id,x,y)
	
	// set the sprite position	
	SetSpritePosition(LAG_StatusBar[id].Sprite,x,y)
	
	// set the text (field) position
	For i=0 to LAG_StatusBar[id].Field.length
		n = LAG_StatusBar[id].Field[i].TextID
		x1 = LAG_StatusBar[id].Field[i].x
		// y1 = LAG_StatusBar.Field[i].y
		y1 = GetSpriteY(LAG_StatusBar[id].Sprite)+4	
		SetTextPosition(n,x1+x,y1)
	next
	
EndFunction


// set text
Function LAG_StatusBarText(id,field,txt$)
	
	SetTextString(LAG_StatusBar[id].Field[field].TextID,txt$)
	
EndFunction



// GET
Function LAG_GetStatusBarHeight(id)
	
	n = GetSpriteHeight(LAG_StatusBar[id].Sprite)-5
	
EndFunction n 
