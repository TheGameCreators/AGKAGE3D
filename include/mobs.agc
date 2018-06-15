

// ************************ MOBS ***********************//
Type sMob
		
	x as float
	Z as float
	CibleX as float
	CibleZ as float
	Sprite as integer
	CibleOk as integer
	
	IsAttacked as integer
	Life as integer
	Lifemax as integer
	WalkOk as integer
	TimeFight as integer
	TimeWalk as integer 
	
	IsDead as integer	
EndType
	
// init
Function InitMob()
	
	Global dim Mob[] as sMob
	
EndFunction

Function SetPhysic(n)
	
	f = 50
	m = 200
	Create3DPhysicsDynamicBody(n)
	SetObjectShapeBox(n)
	SetObject3DPhysicsDamping(n,0,0)
	SetObject3DPhysicsMass(n,m)
	SetObject3DPhysicsFriction(n,f)
	SetObject3DPhysicsMaxLinearVelocity(n,0.1)
	SetObject3DPhysicsRollingFriction(n,f)
	
EndFunction


Function CreateTheMOb()
	
	// test
	nbMob = 4
	Global dim Mob[nbMob] as sMob

	For i=0 to nbMob		
		// Mob[i].sprite = InstanceObject(Objet[10].id)
		Mob[i].sprite = CloneObject(Objet[10].id)
		n = Mob[i].sprite	
		SetObjectImage(n,iMob,0)
		
		// SetObjectShader(Mob[i].sprite,shFog)
		// SetObjectScale(Mob[i].sprite,0.1,0.1,0.1)
		mob[i].x = random(-2,5)
		mob[i].z = random(-2,5)
		mob[i].life = 60
		mob[i].lifeMax = 60
		SetObjectPosition(n,mob[i].x,0,mob[i].z)
		// SetPhysic(n)
	next
	
EndFunction



// event mob
Function EventMob()
	
	sp as float
	sp = 0.05
	For i=0 to Mob.length
		n = mob[i].sprite
		
		if mob[i].life <= 0
			
			if mob[i].IsDead = 0
				mob[i].IsDead = 1
				Delete3DPhysicsBody(n)
			else
				if GetObjectY(n) > -5
					SetObjectPosition(n,getobjectX(n),GetObjectY(n)-0.1,GetObjectZ(n))
				else
					DeleteObject(n)
					mob.remove(i)
				endif
			endif
			
		else // le mob est vivant
			
			if mob[i].timeFight>0
				dec mob[i].timeFight
			endif
			
			//s'il est dans le radar du player, il est ok pour l'attaque
			if abs(Player.x-Mob[i].x)<=5 and abs(player.z-Mob[i].z)<=5
				Mob[i].IsAttacked = 1
			else
				if Mob[i].IsAttacked = 1
					if Mob[i].TimeWalk<=0
						Mob[i].TimeWalk = 30
						Mob[i].CibleX=Player.X+random(0,3)-random(0,3)
						Mob[i].CibleZ=Player.Z+random(0,3)-random(0,3)
						Mob[i].walkok = 1
					else
						dec Mob[i].TimeWalk
					endif
				endif						
			endif
			
			// s'il est suffisamment près, il attaque
			if abs(Player.x-Mob[i].x)<=3 and abs(player.z-Mob[i].z)<=3
				if mob[i].timeFight <= 0
					Player.life = Player.life - 12	
					mob[i].timeFight= 100				
				endif
				mob[i].cibleok = 0
			else
				mob[i].cibleOk = 1
			endif
			
			foldstart // attacked
			if Mob[i].IsAttacked = 1
				
				if mob[i].cibleOK = 1
					if Mob [i].walkok = 0
						Mob[i].CibleX=Player.X+random(0,3)-random(0,3)
						Mob[i].CibleZ=Player.Z+random(0,3)-random(0,3)
						Mob[i].walkok = 1
					endif
				
				// if walk = 1
					/*
					Mob[i].x = GetObjectX(n)			
					Mob[i].z = GetObjectZ(n)	
					x1 		= Mob[i].CibleX
					y1 		= Mob[i].CibleZ
						
					if Mob[i].x <> x1 or Mob[i].z <> y1
						sp# = 0.05
						move=1
						if abs(Mob[i].x-x1)<=2			
							Mob[i].x = x1					
						endif
						if abs(Mob[i].z-y1)<=2			
							Mob[i].z = y1
						endif
						//SetObjectLookAt(1,x1,2,y1,0)
					else 
						move =0
						walk = 0
					endif
					*/
					
					if Mob[i].X < Mob[i].CibleX
						Mob[i].x = Mob[i].x+sp							
					elseif  Mob[i].X > Mob[i].CibleX
						Mob[i].x = Mob[i].x-sp			
					endif
					if abs(mob[i].x-Mob[i].Ciblex) < sp
						mob[i].x = Mob[i].Ciblex										
					endif
					if Mob[i].z < Mob[i].CibleZ
						Mob[i].z = Mob[i].z+sp								
					elseif Mob[i].z > Mob[i].CibleZ
						Mob[i].z = Mob[i].z-sp			
					endif	
					if abs(mob[i].z-Mob[i].CibleZ) < sp
						mob[i].z = Mob[i].CibleZ					
					endif
							
					if Mob[i].walkok = 1
						//MoveObjectLocalZ(n,sp#)
					//if Mob[i].walkok=1
						if Mob[i].x<>Mob[i].CibleX or Mob[i].z<>Mob[i].CibleZ
							//angle# = -getangle(Mob[i].Ciblex,Mob[i].x,Mob[i].CibleZ,Mob[i].Z)
							//SetObjectRotation(mob[i].sprite,0,angle#,0)							
							SetObjectLookAt(n,PLayer.x,player.y,player.z,0)
						endif
						SetObjectPosition(n,Mob[i].x,0,mob[i].z)
						if i = player.MobId
							SetObjectPosition(CibleMob,Mob[i].x,0,mob[i].z)
						endif
					endif
					//if Mob[i].X=Mob[i].CibleX and Mob[i].z = Mob[i].Ciblez
						//Mob[i].WalkOk = 0
					//endif
				endif
				
			endif
			foldend
		
		endif
	Next 
		
	


EndFunction


