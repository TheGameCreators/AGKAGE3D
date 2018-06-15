

// view

function SetTheView() 
	
	// pour définir l'offset de la view

    z as float
    z = gameProp.zoom
    if  map_h>g_depth
		mh = map_h-g_depth
	else
		mh = map_h
	endif
		
    if viewx > (map_w * z - g_width)
        viewx = (map_w * z - g_width)
    endif

    if viewy  > (mh * z - g_height)
        viewy = (mh * z - g_height)
    endif
    
	if viewx < 0 
		viewx = 0
	endif

	if viewy < 0 
		viewy = 0
	endif
	
    SetViewOffset(viewx/z , viewy/z)

endfunction 


Function SetViewGame()

	// pour centrer la vue sur le personnage
	z as float
    z = gameProp.zoom
    
	viewx = Player.x - 512
	if viewx < -512
		viewx = -200
	endif
	viewy = Player.y -307
	if viewy < -307
		viewy = -200
	endif

	//SetSpritePositionByOffset(Player.Sprite, Player.x, Player.y)
	SetTheView()
	SetViewZoom(gameProp.zoom)

EndFunction
	

Function Zoom(mode$) 

    // pour zoomer, ingame
    if mode$ = "-"
        if GameProp.zoom > 1 // 0.5
            GameProp.zoom  = GameProp.zoom  - 0.01
            z = gameProp.zoom
            SetViewZoom(GameProp.zoom)
            //viewx = (x-newx)*z
            //viewy = (y-newy)*z
			///SetTheView()
           /*
            if GameProp.MoveCameraFree = 0
				if viewx>(map_w*z-g_width) or viewy>(map_h*z-g_height) or Player.x-g_width*z>(map_w) or Player.y-g_height*z>(map_h)
					SetTheView()
				endif
            endif
            */
        endif
    elseif mode$ = "+"
        if GameProp.zoom < 4
            GameProp.zoom  = GameProp.zoom  + 0.01
            z = gameProp.zoom
            SetViewZoom(GameProp.zoom)
        endif
    endif

EndFunction 



