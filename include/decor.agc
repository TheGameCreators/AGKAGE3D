

// ************************ DECORS ***********************//

Type sDecor
	
	sprite as integer
	x as float
	y as float
	z as float
	rx as float
	ry as float
	rz as float
	sx as float
	sy as float
	sz as float
	
endtype


// init 
Function InitDecor()
	
	Global Dim Decor[] as sDecor
	
	
EndFunction

Function CreateDecor()
	
	
	// ------ GROUND

	u = 15
	//setimagewrapU(1,u*4)
	//setimagewrapV(1,u*4)
	Global Ground1
	if GetObjectExists(Ground1) and Ground1 > 10000
		DeleteObject(Ground1)
	endif
	Ground1 = CreateObjectBox(5*u,5,5*u)
	SetObjectImage(Ground1,iBg,0)
	//SetObjectShader(Ground1,shFog)
	SetObjectPosition(Ground1,0,-2.5,0)
	SetObjectVisible(Ground1,0)

	//Create3DPhysicsStaticBody(Ground1)
	//SetObjectShapeBox(Ground1)
	// SetObject3DPhysicsRestitution(Ground1,1)
	// setObjectCollisionMode(Ground1,1)

	
	
EndFunction


