
//***************************************
//              Utiles
//***************************************



//************************ MATH ***************************//


// 
Function ReplaceExtension(file$, NewExt$)
	
	ext$ = GetExtensionFile(file$)
	file$ = ReplaceString(file$, ext$,"",1)
	file$ = ReplaceString(file$, ".","",1)
	file$ = file$ + "." + NewExt$
	
endFunction file$
Function GetExtensionFile(file$)
	
	count = FindStringCount(file$, "/" ) 
	sep$ = "/"
	count = FindStringCount(file$, "/" )
	if count = 0
		sep$ = "\"
		count = FindStringCount(file$, "\" )
	endif
	
	file$ = GetStringToken(file$,sep$,count+1)
	ext$ = GetStringToken(file$,".",2)
	
EndFunction ext$

Function GetFilePart(file$)	
	
	sep$ = "/"
	count = FindStringCount(file$, "/" )
	if count = 0
		sep$ = "\"
		count = FindStringCount(file$, "\" )
	endif
	
	file$ = GetStringToken(file$,sep$,count+1)
	
	////ext$ = right(file$,3)
	// result$ = Left(file$,len(file$)-4)
	
	////result$ = ReplaceString(file$,"."+ext$,"",1)
	
	result$ = GetStringToken(file$,".", 1)
	
	
	
EndFunction result$

Function GetPathPart(file$)
	
	count = FindStringCount(file$, "/" ) 
	sep$ = "/"
	count = FindStringCount(file$, "/" )
	if count = 0
		sep$ = "\"
		count = FindStringCount(file$, "\" )
	endif
	
	thefile$ = GetStringToken(file$, sep$, count+1)
	result$ = ReplaceString(file$, thefile$, "", 1)
	
endFunction Result$


Function CountFilesInFolder(folder$,ext$)
	
	/* 
	exmple : 
	folder$ = "textures/default/"
	
	ext$ = "jpg/png/"
	*/
	
	SetFolder("")
	SetFolder("media")
	count = CountStringTokens(folder$,"/")-1
	For i = 0 to Count
		fn$ = GetStringToken(folder$,"/",1+i)
		if fn$ <> ""
			SetFolder(fn$)
		endif
		//message(GetStringToken(folder$,"/",1+i))		
	next 
	
	//SetFolder("textures")
	//SetFolder("default")
	
	//nbext = CountStringTokens(ext$,"/")
	//for i=0 to nbext
		ext1$ = GetStringToken(ext$,"/",1)
		ext2$ = GetStringToken(ext$,"/",2)
		if ext2$=""
			ext2$ =ext1$
		endif
	//next
	
	fn$ =""	
	fn$ = GetFirstFile()
	n=-1
	dim FilImg$[]
	while fn$<>""	
		ext$=GetExtensionFile(fn$)
		if fn$ <> ""			
			if (ext$ = ext1$ or ext$ = ext2$) 
				inc n	
				dim FilImg$[n]
				FilImg$[n]=fn$			
			endif
		endif
		fn$=GetNextFile()				
	endwhile
		
	SetFolder("")
	SetFolder("media")
	
	
EndFunction n



Function CountFolderInFolder(folder$)
	
	/* 
	exmple : 
	folder$ = "textures/default/"
	*/
	
	SetFolder("")
	SetFolder("media")
	SetFolder(folder$)
	
	/*
	count = CountStringTokens(folder$,"/")-1
	For i = 0 to Count
		fn$ = GetStringToken(folder$,"/",1+i)
		if fn$ <> ""
			SetFolder(fn$)
		endif			
	next 
	*/
	//SetFolder("textures")
	//SetFolder("default")
	
	//nbext = CountStringTokens(ext$,"/")
	//for i=0 to nbext
		/*
		ext1$ = GetStringToken(ext$,"/",1)
		ext2$ = GetStringToken(ext$,"/",2)
		if ext2$=""
			ext2$ =ext1$
		endif
		*/
	//next
	
	fn$ =""	
	fn$ = GetFirstFolder()
	n=-1
	dim TempFolder$[]
	while fn$<>""	
		if fn$ <> ""			
			inc n	
			dim TempFolder$[n]
			TempFolder$[n] = fn$			
		endif
		fn$=GetNextFolder()				
	endwhile
	
		
	SetFolder("")
	SetFolder("media")
	
	
EndFunction n


// 3D

Type sphere
  x as float
  y as float
  z as float
  radius as float
EndType

/*
;purpose: To detect a collision between 2 spheres
; input:   S1- our first sphere
;          S2- our second sphere
;output: true If there is a collision, Else false
*/
Function Collision(S1 as sphere, S2 as sphere)
   
    if (Pow(S2.x - S1.x,2) + Pow(S2.y - S1.y,2) + Pow(S2.z - S1.z,2) < Pow(S1.radius + S2.radius,2))
		value = 1
	endif
		
EndFunction value





// function to get the angle between two points
function GetAngle(x1#, y1#, x2#, y2#)
    result# = ATanFull(x1#-x2#, y1#-y2#)
endfunction result#


// MATH
function Min3(a, b, c)
    if a < b
        a = c
    endif
endFunction a

function Min2(a as float, b as float )
    if a < b
        a = b
    endif
endFunction a

function min(a#, b#)
    if a#<b#
        exitfunction a#
    endif
endfunction b#

function Max(a, b)
    if a > b
        a = b
    endif
endFunction a

Function Over(a, b, c)
    if a > b
        a = c - b
    endif
EndFunction

Function Under(a, b, c)
    if a < b
        a = c - b
    endif
EndFunction

Function Pow2(a, b)
    resultat = a ^ b
EndFunction resultat

function PowFloat( base as float, exp as float )
    result# = base ^ exp
endfunction result#



Function GetDistance(x,y,x1,y1)
	dist = sqrt((x1-x)^2 + (y1-y)^2)
EndFunction dist

Function GetDistance3D_2(x,y,z,x1,y1,z1)
	
	dist = ((x1-x)^2 + (y1-y)^2 +(z1-z)^2)^(1/3)
	
EndFunction dist

function GetDistance3D(x1#,y1#,z1#,x2#,y2#,z2#)
	
	dx# = x1# - x2#
	dy# = y1# - y2#
	dz# = z1# - z2#
	distance# = sqrt(dx#*dx# + dy#*dy# + dz#*dz#)
	
endfunction distance#



//************************ Mouvement ***************************//

/*
Function GetDir(angle#)
	
	// pour trouver la direction en fonction de l'angle	
	// pour les animations : player, compagnon, mob
	
	If (angle# >= 0 and angle# < 23) or (angle# >= 338 and angle# <= 360)
		dir = 0
	Elseif angle# >= 23 and angle# < 68
		dir = 7
	Elseif angle# >= 68 and angle# < 113
		dir = 6
	Elseif angle# >= 113 and angle# < 158
		dir = 5
	Elseif angle# >= 158 and angle# < 203
		dir = 4
	Elseif angle# >= 203 and angle# < 248
		dir = 3
	Elseif angle# >= 248 and angle# < 293
		dir = 2
	Elseif angle# >= 293 and angle# < 338
		dir = 1
	Endif
EndFunction dir

Function SetDir(n,dir,fps,max)
	
	//
	//pour changer le sprite d'animation : player, mob, compagnon...
	//en fonction de la direction
	
	//fps, loop,from, to
	//
	PlaySprite(n, fps, 1, 1+dir*max, (1+dir)*max)
	

	
EndFunction

*/

// function to move to a point if needed
function MoveToward(x as float, y as float, ciblx as float, cibly as float, speed as float) // '{

    if x <> ciblx or y <> cibly

        //angle# = GetAngle(ciblx, cibly, GetSpriteX(spr), GetSpriteY(spr))
        //SetSpriteAngle(spr, angle#)

        if x <> ciblx
            x = x + cos(ATan2((cibly - y),(ciblx - x)))* speed
            if abs(x - ciblx) <= speed
                x = ciblx
            endif
        endif

        if y <> cibly
            y = y + sin(ATan2((cibly - y),(ciblx - x)))* speed
            if abs(y - cibly) <= speed
                y = cibly
            endif
        endif

        //SetSpritePosition(spr, x, y)
        returnvalue = 1
    else
        returnvalue = 0
    endif

endfunction returnvalue // '}


// fonction pour coller à une grille
Function Snap(a,b)
    a = a/b
    a = a * b
EndFunction a


