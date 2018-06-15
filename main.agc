

InitFirstOpening() // in init.agc

#include "include/include.agc"

// Init the Interface (Ui, menu, gadgets...), options...
InitGeneral() // in init.agc


FoldStart // define Some parameters for the visual editor

action = C_ACTIONSELECT

Obj$ = "Box,Sphere,Capsule,Cone,Cylinder,Plane,Object3D"
ObjTyp$ = GetStringToken(Obj$,",",ObjTyp+1)


CreateText(1, Info$)
SetTextPosition(1,PaneLW+20,65)
SetTextSize(1,15)
SetTextDepth(1,20)
SetTextMaxWidth(1,G_width-2*(PaneLW+20))

Event_Menu = -1
Event_Gadget = 0
id = -1
LAG_v_MenuItemId = -1

MX as float
MY as float
Dc as float 


Dc = Options.Camera.Speed
CamOrtho as integer
SetCameraRotation(1,30,0,0)
SetCubeViewTocamera(1)




// for transformation of object
ux as float 
uy as float 
uz as float 





// SetPhysicsDebugOn()
IF use_Lag = 1
	SetTool(Event_Gadget)
	LAG_SetGadgetState(C_Gad_PreviewModel,UiObjImg[0])
	
	LAG_Message("Info","Please, note that this visual editor isn't finished at all, it's a wip version, so some features aren't available and it's possible there's still some bugs. Maybe, some features will changed in a next version.","")
	
endif

	
FoldEnd


SetCameraRange(1,1,10000)
Options.Camera.Far = 10000
/*
SetCameraRotation(1,60,0,0)
SetCAmeraPosition(1,0,150,-50)
SetCameraFOV(1,70)


w1 = 600 // size of the ground
global TheGourndZ = 192
CreateObjectPlane(TheGourndZ,w1,w1)
SetObjectRotation(TheGourndZ,90,0,0)
// SetObjectCullMode(1,1)
SetObjectColor(TheGourndZ,150,150,150,255)
SetObjectImage(TheGourndZ,iLightmap,0)
SetObjectPosition(TheGourndZ,0,0,0)

For i =0 to 10
	x = random(-100,100)
	y = random(-10,50)
	z = random(-100,100)
	AddObjet(x,y,z,"")
next

ObjId = TheGourndZ
*/

// For the lightmap
Global TheGourndZ = -1 // the ground
Global TheObjectLightMap = -1
Active_Gadget = -1

GetScreenBoundEditor()

// temporary !!, to see the lightmap image
/*
CreateSprite(1,1)
SetSpriteSize(1,128,128)
SetSpritePosition(1,-2300,80)
SetSpriteImage(1,iLightmap)
SetSpriteDepth(1, 0)
*/


//SetGenerateMipmaps(0)


//********************* MAIN LOOP **********************//

do
		
	MX = getpointerX()
	MY = getPointerY()
	
	// print(str(Getspritex(C_Gad_TB))+"/"+str(GetspriteY(C_Gad_TB)))
	
	
	FoldStart //Debug 
	if Options.Debug = 1
		Info$ = "FPS : "+str(ScreenFPS())+Chr(10)		
		//Info$ = Info$ + "Mouse : "+str(Get3DVectorXFromScreen(mx,my)*10,2)+"/"+str(Get3DVectorYFromScreen(mx,my)*10,2)+"/"+str(Get3DVectorZFromScreen(mx,my)*10,2)+Chr(10)	
		Info$ = Info$ +"Obj Id : "+str(ObjId)+Chr(10)
		Info$ = Info$ +"Physics : "+ str(Options.physicOn)+Chr(10)
		Info$ = Info$ +"Active Obj Physics : "+ str(Get3DPhysicsActiveObjects() )+Chr(10)
		Info$ = Info$ +"Obj Physics : "+ str(Get3DPhysicsTotalObjects())+Chr(10)
		/*
		if objid > -1 and objid<= object.length
			if assettyp =C_ASSETOBJ
			Info$ = Info$ +"W : "+str(GetObjectWidth(ObjId))+" / H : "+str(GetObjectHeight(ObjId))+" / L : "+str(GetObjectLength(ObjId))+chr(10)
			Info$ = Info$ +"Hmin : "+str(GetObjectSizeMinY(object[ObjId].obj))+" / Hmax : "+str(GetObjectSizeMaxY(object[ObjId].obj))+chr(10)
			endif
		endif
		*/
		
		// info$ = info$ + "Cubeview : "+str(GetObjectAngleX(CubeView))+"/"+str(GetObjectAngleY(CubeView))+"/"+str(GetObjectAngleZ(CubeView))
		// Info$ = Info$ + str(x)+"|"+str(y)+"|"+str(z)
		SetTextString(1,info$)		
		// Print(Str(mx)+"/"+str(my))
	endif
	
	Foldend
	
	//Print("Min/max "+str(Options.Minx)+"/"+str(Options.MaxX)+" | "+str(Options.MinY)+"/"+str(Options.MaxY)+" | "+str(Options.MinZ)+"/"+str(Options.MaxZ)+"/")
	
	if Action = C_ACTIONPLAY // play
		
		ScreenGame() // in ScreenGame.agc
		
	else
		
		foldstart //************* autosave
		
			IF autosave>=0
				dec autosave
			else
				autosave = 3600
				if object.length >=0
					olddoc$ = doc.FileName$
					if AutosaveDoc$ = ""
						AutosaveDoc$ = "autosave\Autosave"+str(random(0,100000))+"_"+GetCurrentDate()+".age"
					endif
					Doc.Filename$ = AutosaveDoc$ 
					SaveDoc(0)
					Doc.FileName$ = olddoc$
				endif
			endif
			
		foldend
			
		GetScreenBoundEditor() // in editor.agc
	
				
		FoldStart //************* Mouse Event & Gadget/Menu	
		
		// LAG_EventWindow()
		LAG_EventType()
		
		
		// verification for editbox		
		FoldStart // Active gadget (for editbox)
		
		if Active_Gadget > -1
			If Lag_GetGadgetType(Active_Gadget) = LAG_C_TYPSTRING
				if Lag_event_type = LAG_C_EVENTTYPEKEYRELEASED or Lag_event_type = LAG_C_EVENTTYPEKEYPRESSED
					// print("ok key !!!!!!!!!!!")
					Keypressed = 1
				endif
				if GetEditBoxHasFocus(LAG_D_Gadget[Active_Gadget].EditBoxId) = 0
					Active_Gadget = -1
				endif
			endif
		else
			if Event_Gadget> -1
				If Lag_GetGadgetType(Event_Gadget) = LAG_C_TYPSTRING
					if GetEditBoxHasFocus(LAG_D_Gadget[Event_Gadget].EditBoxId) <>  0
						Active_Gadget = Event_Gadget
					endif
				endif
			endif
		endif
		
		Foldend
		
				
		if options.HideLag = 0 and ((Mx<= PanelW+GameProp.BoundLeft or Mx >= GameProp.BoundRight-PanelW or MY<=60+GameProp.BoundTop or LAG_v_MenuItemId <> -1))
				
			
			FoldStart // Menu & gadgets
			
				IF use_Lag = 1
					
					ToolTipsEvent(getpointerX(),getpointerY())
					Keypressed = 0
					
					FoldStart // using LAG ui (Menu & gadgets)			
					
					if GetRawMouseRightReleased()  // or (GetRawMouseLeftPressed()				
						
						LAG_CloseMenu()
						
					else
						
						Event_Menu = LAG_EventMenu()
				
						// verify the event for menu and gadget, if LeftClic or keyboard event 
						
						if Event_Menu <> -1
							
							FoldStart // menu
							
							If Event_Menu <= C_MENU_QUIT
								
								Select Event_Menu // FILE
									
									// files 							
									case C_MENU_NEW
										NewDoc(0)
									endcase
									case C_MENU_OPEN 
										OpenDoc(0)
									endcase
									case C_MENU_MERGE 
										OpenDoc(1)
									endcase
									case C_MENU_SAVEAS
										SaveDoc(1)
									endcase
									case C_MENU_EXPORT
										ExportForAGK(0, 0)
									endcase
									case C_MENU_SAVE
										SaveDoc(0)
									endcase
									case C_MENU_QUIT
										LAG_message("Quit","Bye ;)","")
										Event_Gadget = 0
										end
									endcase
								endselect
							
							elseIf Event_Menu <= C_MENU_SETOBJPARAM // edit
								
								Select Event_menu
									// EDIT 
									Case C_MENU_HIDE
										For i=0 to object.length
											if Object[i].Selected = 1
												SetObjectvisible(Object[i].Obj,0)
												SetSpriteVisible(Object[i].Spr,0)
												Object[i].Hide = 0
											endif
										next
									EndCase
									Case C_MENU_FREEZE
										For i=0 to object.length
											if Object[i].Selected = 1
												Object[i].Locked = 1											
											endif
										next
									EndCase
									Case C_MENU_COPY
										CopyObject()
									endcase							
									Case C_MENU_CLONE
										CopyObject()
										PasteObject()
									Endcase
									Case C_MENU_PASTE
										PasteObject()
									endcase									
									case C_MENU_SETOBJPARAM
										OpenWindowObjParam() // in object.agc
									endcase
																
								Endselect
								
							elseIf Event_Menu <= C_MENU_USERTLM // view
								
								Select Event_menu
									
									// view
									case C_MENU_VIEWRESET
										SetView(2)
									endcase
									case C_MENU_VIEWSELECTED										
										SetView(1)
									Endcase						
									case C_MENU_VIEWCENTER
										SetView(0)				
									Endcase						
									case C_MENU_DEBUG						
										Options.Debug = 1-Options.Debug
										if Options.Debug =0
											SetTextString(1,"")
										endif
									Endcase 					
									case C_MENU_USEWATER
										Options.ShowWater = 1-Options.ShowWater
									Endcase
									case C_MENU_GRID
										Options.ShowGrid = 1-Options.ShowGrid
										SetObjectVisible(Grid,Options.ShowGrid)
									Endcase 
									case C_MENU_USERTLM
										Options.ShowLMRT = 1-Options.ShowLMRT
									endcase
									case C_MENU_SHOWCENTER
										Options.ShowCenter = 1-Options.ShowCenter
										UpdateAllCenter()
										SetAllCenterVisible()
									endcase
									/*
									case C_MENU_SUN
										Options.ShowSun = 1-Options.ShowSun
										SetSunActive(Options.ShowSun)
									Endcase 
									case C_MENU_SKYBOX
										Options.ShowSkyBox = 1-Options.ShowSkyBox
										SetSkyBoxSunVisible(Options.ShowSkyBox)
									Endcase 
									case C_MENU_FOG
										Options.ShowFog = 1-Options.ShowFog
										SetFogMode(Options.ShowFog)
									Endcase 
									*/
								Endselect
															
							elseIf Event_Menu <= C_MENU_CreateLightMAp // Add
									
								Select Event_menu 
									case C_MENU_ADDOBJ
										AssetTyp = C_ASSETOBJ
										CreateNewObject(1) // in editor.agc
									endcase
									
									case C_MENU_ADDLIGHT
										AssetTyp = C_ASSETLIGHT
										AddLight(0,20,0,150,255,255,255,-1,1)
										//LAG_Message("Light",Help$,"")
									Endcase									
									
									case C_MENU_ADDCAMERA
										AssetTyp = C_ASSETCAMERA
										AddCamera(0,20,0,0,0,0,1,1000,70)										
									endcase
									
									case C_MENU_CHANGETYP
										inc ObjTyp
										if ObjTyp>C_OBJBANK
											ObjTyp = 0
										endif
										ObjTyp$ = GetStringToken(Obj$,",",ObjTyp+1)
									endcase									
									case C_MENU_CHANGEIMG
										/*
										inc TextureID
										if TextureID>texture.length
											TextureID = 0
										endif
										LAG_SetGadgetState(C_Gad_BankImg,Texture[textureId].img)
										*/	
									endcase				
									Case C_MENU_ADDWATER
										// ! <-----------------------  !!!! TODO : Créer une interface avec gestion de la création de l'asset Water ou load/save preset
										wat = Options.WaterImageSize								
										AddWater(-2,wat,wat,wat,wat,0)
									endcase
									Case C_MENU_ADDTERRAIN
										OpenWindowTerrain()
									endcase
									Case C_MENU_CreateLightMAp
										// CreateLightMap()
										if ObjId >-1 and ObjId <= Object.length
											TheObjectLightMAp = ObjId
											Object[ObjId].LightMapID = 1
											SyncShadow()					
											SaveImage(iLightmap,"lightmap.jpg")
										else
											LAG_message("Info","Please, select the ground which receive the lightmap first","")
										endif									
									endcase
									
								endselect
							
							elseIf Event_Menu <= C_MENU_UPDATE // HElp	
								
								Select Event_menu	
									case C_MENU_ABOUT
										LAG_message("Info","AGE (Agk Game Editor) is a visual 3D editor for AGK (and made in AGK), to help you to create 3D level, add gameplay, shader, image...."+chr(10)+"Version : "+C_VERSION+chr(10)+"Date : "+C_DATE+chr(10)+"Dev : Blendman","")
									endcase					
									case C_MENU_HELP										
										LAG_Message("Help",Help$,"")										
									endCase
									case C_MENU_INFO
										ViewFile("doc/age3D.rtf")
									endcase
									case C_MENU_RELEASE
										ViewFile("doc/releaseLog.rtf")
									endcase
								endselect
							
							elseIf Event_Menu <= C_MENU_SELECTBYNAME // selection
									
								Select Event_menu								
									// Select
									case C_MENU_SELECTBYGROUP
										Name$ = Lag_InputRequester("Select Object by group","")
										if name$ <> ""
											moveobj=0
											For i=0 to object.length
												Object[i].Selected = 0
												SetObjectColorEmissive(Object[i].Obj,Object[i].r,Object[i].g,Object[i].b)
											next
												
											For i=0 to object.length
												for j =0 to Object[i].Group.Length
													if object[i].group[j] = name$
														objId = i
														Object[i].Selected = 1
														SetObjectColorEmissive(Object[i].Obj,50,0,0)
														moveobj=1
														GetObjProp()
														exit											
													endif
												next
											next
											if moveobj = 0
											endif
										endif
									Endcase 
									case C_MENU_SelectByName
										Name$ = Lag_InputRequester("Select Object by name","")
										if name$ <> ""
											moveobj=0
											For i=0 to object.length
												Object[i].Selected = 0
												SetObjectColorEmissive(Object[i].Obj,Object[i].r,Object[i].g,Object[i].b)
											next
																				
											For i=0 to object.length
												if object[i].name$ = name$
													objId = i
													Object[i].Selected = 1
													SetObjectColorEmissive(Object[i].Obj,50,0,0)
													moveobj=1
													GetObjProp()
													exit											
												endif
											next
											if moveobj = 0
											endif
										endif
									Endcase 
									case C_MENU_SELECTALL
										if assetTyp = C_ASSETOBJ
											For i=0 to object.length
												Object[i].Selected = 1
												SetObjectColorEmissive(Object[i].Obj,50,0,0)
											next
										endif
									Endcase							
								Endselect
							
							else	
								
								txt$ = LAG_GetMenuItemText(0,Event_Menu)
								LAG_message("Info",txt$+" : not implemented","")
								
							endif
							
						Foldend
						
						
						elseif LAG_v_MenuItemId = -1 and  Options.MenuOpen = 0
							
							FoldStart // event_gadget
							
							Event_Gadget  = LAG_EventGadget()
							
							// print("EventGadget : "+str(Event_Gadget))
							
							if Event_Gadget < 0 or Event_Gadget > C_Gad_Last or My <= 30+Options.Y+GameProp.BoundTop
								
								FreeToolTips()
								// Active_Gadget = -1
								
							elseif Event_Gadget > 0 and Event_Gadget <= C_Gad_Last
								
								// main window								
								CreateToolTips(getPointerX(),getPointerY(),Event_Gadget)
								
								if Lag_event_type = LAG_c_EventTypeMousePressed
									if Active_Gadget = -1
										If Lag_GetGadgetType(Event_Gadget) = LAG_C_TYPSTRING
											Active_Gadget = Event_Gadget
										endif
									else
										If Lag_GetGadgetType(Active_Gadget) = LAG_C_TYPSTRING
											if GetEditBoxActive(LAG_D_Gadget[Active_Gadget].EditBoxId) = 0
												Active_Gadget = -1
											endif
										endif
									endif
								endif
								
								// toolbar 
								if Event_gadget >= C_GAD_TBNEW and Event_gadget<= C_Gad_TBDEL
									
									if event_Gadget >= C_Gad_TBViewPan and event_Gadget <= C_Gad_TBViewZoom
										
										Select event_Gadget
											
											case C_Gad_TBViewPan
												ActionView = 1
											endcase
											
											case C_Gad_TBViewRot
												ActionView = 2
											endcase
											
											case C_Gad_TBViewZoom
												ActionView = 3
											endcase
											
										endselect
									
									else
										ActionView = 0
										
										IF GetRawMouseLeftPressed() or LAG_Event_Type = LAG_c_EventTypeMousePressed
											Action$ = SetTool(Event_Gadget)
										endif
										
									endif
									
								else
									
									FoldStart // others gadgets
									
									// Windows prop ( anim, shader...) 
									if Event_Gadget >= C_Gad_WinObjBehavior and Event_Gadget<C_Gad_NameObj
									
										Select Event_Gadget // Windows prop ( anim, shader...) 
											
											case C_Gad_WinObjBehavior
												if LAG_event_Type = LAG_C_EVENTTYPEMOUSERELEASED //GetRawMouseLeftReleased()
													OpenWindowBehavior()
												endif
											Endcase	
											
											case C_Gad_WinObjPhysic
												if LAG_event_Type = LAG_C_EVENTTYPEMOUSERELEASED //GetRawMouseLeftReleased()
													OpenWindowObjPhysics()
												endif
											Endcase	
											
											case C_GAD_LoadPartsys
												if LAG_event_Type = LAG_C_EVENTTYPEMOUSERELEASED 
													If ObjId >- 1 and ObjId<= Object.length
														if Object[objID].typ= C_OBJPARTSYS
															LoadParticleSystemPreset("",0)
														endif
													endif
												endif
											Endcase	
											
											case C_GAD_SavePartsys
												if LAG_event_Type = LAG_C_EVENTTYPEMOUSERELEASED 
													If ObjId >- 1 and ObjId<= Object.length
														if Object[objID].typ= C_OBJPARTSYS
															SaveParticleSystemPreset("", 0)
														endif
													endif
												endif
											Endcase	
											
											case C_Gad_WinObjShader
												if LAG_event_Type = LAG_C_EVENTTYPEMOUSERELEASED //GetRawMouseLeftReleased()
													OpenWindowShader()
												endif
											Endcase	
												
										endselect
									
									// Obj prop
									elseif Event_Gadget >= C_Gad_NameObj and Event_Gadget<=C_Gad_AnimSpeed
										
										FoldStart // Object properties 
										
										if Event_Gadget >= C_Gad_lock_X and Event_Gadget <= C_Gad_lock_SZ
											
											SetObjectLock()
										
										else
										
											Select Event_Gadget
												
												case C_Gad_X,C_Gad_Size,C_Gad_Y,C_Gad_Z,C_Gad_Rx,C_Gad_Ry,C_Gad_RZ,C_Gad_Sx,C_Gad_Sy,C_Gad_Sz,C_Gad_NameObj,C_Gad_Param1,C_Gad_Param2
													SetAssetProp(C_SETOBJPROP_GEN) 
													//  = -> SetObjProp(mode) dans object.agc
												endcase
												
												case C_Gad_Shado, C_Gad_ShadoCast,C_Gad_ShadoRec, C_Gad_ObjFog, C_Gad_ObjLight, C_Gad_ObjVisible, C_Gad_Hide,C_Gad_Lock 
													if LAG_event_Type = LAG_c_EventTypeMousePressed
														SetAssetProp(C_SETOBJPROP_GEN) //  = -> SetObjProp(mode) dans object.agc
													endif
												endcase 
												
												case C_Gad_BM 
													if LAG_event_Type = LAG_c_EventTypeMousePressed
															if AssetTyp = C_ASSETOBJ
															if Objid>-1 and objID <= object.length
																inc Object[ObjId].BM
																if Object[ObjId].BM > 4
																	 Object[ObjId].BM = 0
																endif
																bm$ = "Normal,add,mult,sub,other,"
																LAg_SetGadgetText(C_Gad_BM, GetStringToken(bm$, ",", Object[ObjId].BM+1))
																SetAssetProp(C_SETOBJPROP_COL)
															endif
														endif
													endif
												endcase 
												
												case C_Gad_Tra 
													if LAG_event_Type = LAG_c_EventTypeMousePressed
														if AssetTyp = C_ASSETOBJ
															if Objid>-1 and objID <= object.length
																inc Object[ObjId].tra
																if Object[ObjId].tra > 2
																	 Object[ObjId].tra = 0
																endif
																bm$ = "Opaque,Transp,Custom,"
																LAg_SetGadgetText(C_Gad_tra, GetStringToken(bm$, ",", Object[ObjId].tra+1))
																SetAssetProp(C_SETOBJPROP_COL)
															endif
														endif
													endif
												endcase 
												
												case C_gad_alpha, C_Gad_B, C_Gad_G, C_Gad_R
													SetAssetProp(C_SETOBJPROP_COL)
												endcase 
													
												case C_Gad_uvx, C_Gad_uvy, C_Gad_uvw, C_Gad_uvh, C_Gad_SetShader
													SetAssetProp(C_SETOBJPROP_UV)
												endcase
												
												case C_Gad_SetStage
													SetAssetProp(C_SETOBJPROP_STAGEImg)	
												endcase
												
												case C_Gad_Physic
													//if LAG_event_Type = LAG_C_EVENTTYPEMOUSERELEASED
													if LAG_event_Type = LAG_c_EventTypeMousePressed
														if ObjID>-1 and ObjId <= object.length
															
															i=ObjId
															// Object[i].Physic = val(LAG_GetGadgetText(C_Gad_Physic))
															inc Object[i].Physic 
															if Object[i].Physic>4
																Object[i].Physic  =0
															endif
															Txt$ ="No Physic/Static/Dynamic/Kinematic/Character"
															LAG_SetGadgetText(C_Gad_Physic, GetStringToken(Txt$,"/",Object[i].Physic+1))
															SetPhysicToObject(i,0)
															// OpenWindowObjPhysic()
														endif
													endif
												endcase 
												
												case C_Gad_PlayAnim
													IF GetRawMouseLeftPressed() or LAG_Event_Type = LAG_c_EventTypeMousePressed
														play = LAG_GetGadgetState(C_Gad_PlayAnim)
														Speed# = Valfloat(LAG_GetGadgettext(C_Gad_AnimSpeed))
														FrSt# = Valfloat(LAG_GetGadgettext(C_Gad_AnimStart))
														FRend# = Valfloat(LAG_GetGadgettext(C_Gad_AnimEnd))
														SetObjectAnimation(play, speed#, FrSt#, FrEnd#)
													endif
												endcase
												
												case C_Gad_AnimSpeed, C_Gad_AnimStart, C_Gad_AnimEnd	
													
													if 	Lag_event_type = LAG_C_EVENTTYPEKEYRELEASED
														play = LAG_GetGadgetState(C_Gad_PlayAnim)
														Speed# = Valfloat(LAG_GetGadgettext(C_Gad_AnimSpeed))
														FrSt# = Valfloat(LAG_GetGadgettext(C_Gad_AnimStart))
														FRend# = Valfloat(LAG_GetGadgettext(C_Gad_AnimEnd))
														SetObjectAnimation(play, speed#, FrSt#, FrEnd#)
													endif
													
												endcase
												
												case C_Gad_Type
													if LAG_event_Type = LAG_c_EventTypeMousereleased
														typ$ = GetObjTypFromFile("")
														maxtyp = CountStringTokens(typ$, ",")
														inc ZeTyp 
														if ZeTyp >= maxtyp
															ZeTyp = 0
														endif
														LAg_SetGadgetText(C_Gad_Type, GetStringToken(typ$, ",",1+zetyp))
														Select AssetTyp
															case C_ASSETOBJ
																if ObjID > -1 and objID <= object.length
																	Object[objid].ObjTyp = Zetyp
																endif
															endcase
														endselect
														
														t$ = GetStringToken(typ$, ",",1+zetyp)
														subtyp$ = GetObjTypFromFile(t$)
														LAg_SetGadgetText(C_Gad_subType, GetStringToken(Subtyp$, ",",1))
													endif
												endcase
												
												case C_Gad_SubType
													if LAG_event_Type = LAG_c_EventTypeMousereleased
														typ$ = Lag_GetGadgetText(C_Gad_Type)
														subtyp$ = GetObjTypFromFile(typ$)
														maxtyp = CountStringTokens(subtyp$, ",")
														inc ZesubTyp 
														if ZesubTyp >= maxtyp
															ZesubTyp = 0
														endif
														LAg_SetGadgetText(C_Gad_subType, GetStringToken(Subtyp$, ",",1+ZesubTyp))
														Select AssetTyp
															case C_ASSETOBJ
																if ObjID > -1 and objID <= object.length
																	Object[objid].SubTyp = ZesubTyp
																endif
															endcase
														endselect
													endif
												endcase
											
											endselect 
										
										endif
										
										Foldend
									
									// options	
									elseif Event_Gadget >= C_Gad_SnapX and Event_Gadget <= C_Gad_SelectList
										
										FoldStart // options 
										if Event_Gadget >= C_Gad_CamPresetList and Event_Gadget <=C_Gad_CamOrtW
											
											if Event_Gadget = C_Gad_CamPresetList 
												
											else
											
												if 	Lag_event_type = LAG_C_EVENTTYPEKEYRELEASED
											//case C_Gad_CamFar, C_Gad_CamFov, C_Gad_CamNear, C_Gad_CamOrtW
													Options.Camera.X = val(LAG_GetGadgetText(C_Gad_CamX))
													Options.Camera.Y = val(LAG_GetGadgetText(C_Gad_CamY))
													Options.Camera.Z = val(LAG_GetGadgetText(C_Gad_CamZ))
													
													
													CamX = Options.Camera.X
													CamY = Options.Camera.Y
													CamZ = Options.Camera.Z
													
													Options.Camera.RX = val(LAG_GetGadgetText(C_Gad_CamRX))
													Options.Camera.RY = val(LAG_GetGadgetText(C_Gad_CamRY))
													Options.Camera.RZ = val(LAG_GetGadgetText(C_Gad_CamRZ))
													
													
													Options.Camera.Far = val(LAG_GetGadgetText(C_Gad_CamFar))
													Options.Camera.Fov = val(LAG_GetGadgetText(C_Gad_CamFov))
													Options.Camera.Near = valfloat(LAG_GetGadgetText(C_Gad_CamNear))
													Options.Camera.OrthoW = valFloat(LAG_GetGadgetText(C_Gad_CamOrtW))
													
													SetCamera()
													SaveOptions()
												endif
											//Endcase 
											endif
											
										else
											
											select Event_Gadget
												
												case C_Gad_Snap, C_Gad_SnapX, C_Gad_SnapY, C_Gad_SnapZ
													Snap = LAG_GetGadgetState(C_Gad_Snap)
													SnapX = val(LAG_GetGadgetTExt(C_Gad_SnapX))
													SnapY = val(LAG_GetGadgetTExt(C_Gad_Snapy))
													SnapZ = val(LAG_GetGadgetTExt(C_Gad_SnapZ))
													Options.Snap = Snap	
													SaveOptions()											
												endcase
												
												case C_Gad_LockX, C_Gad_LockY, C_Gad_LockZ
													
													select action
														
														case C_ACTIONMOVE
															Options.LockX = LAG_GetGadgetState(C_Gad_LockX)
															Options.LockY = LAG_GetGadgetState(C_Gad_LockY)
															Options.LockZ = LAG_GetGadgetState(C_Gad_LockZ)
														endcase
														
														case C_ACTIONROTATE
															Options.LockRX = LAG_GetGadgetState(C_Gad_LockX)
															Options.LockRY = LAG_GetGadgetState(C_Gad_LockY)
															Options.LockRZ = LAG_GetGadgetState(C_Gad_LockZ)
														endcase
														
														case C_ACTIONSCALE
															Options.LockSX = LAG_GetGadgetState(C_Gad_LockX)
															Options.LockSY = LAG_GetGadgetState(C_Gad_LockY)
															Options.LockSZ = LAG_GetGadgetState(C_Gad_LockZ)
														endcase
													
													endselect
													SaveOptions()
												endcase
												
												case C_Gad_SelectList
													IF GetRawMouseLeftPressed() or LAG_Event_Type = LAG_c_EventTypeMousePressed
														
														j = LAG_GetGadgetState(C_Gad_SelectList)
														
														assetTyp = LAG_GetGadgetItemAttribute(C_Gad_SelectList,j)
														select assettyp
															
															case C_ASSETLIGHT
																if j <= light.length and j>=0
																	if light[j].hide = 0
																		objId = j
																		Name$ = LAg_GetGadgetItemText(C_Gad_SelectList, ObjId)
																		SelectObject(-1)
																	endif
																endif
															endcase
															
															case C_ASSETOBJ

																if j <= Object.length and j>=0
																	if object[j].hide = 0
																		objId = j
																		Name$ = LAg_GetGadgetItemText(C_Gad_SelectList, ObjId)
																		SelectObject(-1)
																	endif
																endif
																
															endcase
															
															case  C_ASSETMESH
																Meshid = j+1
															endcase
															
															case  C_ASSETCAMERA
																
																if j <= camera.length and j>=0
																	if camera[j].hide = 0
																		objId = j
																		Name$ = LAg_GetGadgetItemText(C_Gad_SelectList, ObjId)
																		SelectObject(-1)
																	endif
																endif
																
															endcase
															
														endselect
													endif
												endcase
												
												case C_Gad_BtnSelectTyp
													IF GetRawMouseLeftPressed() or LAG_Event_Type = LAG_c_EventTypeMousePressed														
														inc assetTyp
														if assetTyp > C_ASSETMax
															assetTyp = C_ASSETOBJ
														endif
														Lag_FreeallGadgetItemByGadget(C_Gad_SelectList)	
														CreateAllGadgetItem()
														
													endif
												endcase
											
											endselect
										
										endif
										foldend
									
									// sky	
									elseif Event_Gadget >= C_Gad_SkyOk and Event_Gadget<=C_Gad_SHADO_SizeH
																					
										select Event_Gadget	 // sky & atmosphere			
											
											case C_GAD_AtmSave
												IF LAG_Event_Type = LAG_C_EVENTTYPEMOUSERELEASED	
													SaveAtmosphere("",0,0)
												endif
											endcase
											 
											case C_GAD_AtmLoad
												IF LAG_Event_Type = LAG_C_EVENTTYPEMOUSERELEASED	
													LoadAtmosphere("",0,0)
												endif
											endcase 
											
											case C_Gad_AmbInt, C_Gad_SunInt
												if keypressed or LAG_Event_Type = LAG_C_EVENTTYPEKEYPRESSED	
													UpdateSky()
												endif											
											endcase
											
											case C_Gad_SkyHR,C_Gad_SkyHG,C_Gad_SkyHB,C_Gad_SkyR,C_Gad_SkyG,C_Gad_SkyB,C_Gad_SunR,C_Gad_SunX,C_Gad_SunY,C_Gad_SunZ,C_Gad_SunG,C_Gad_SunB,C_Gad_FogR,C_Gad_FogG,C_Gad_FogB,C_Gad_FogMax,C_Gad_FogMin,C_Gad_AmbR,C_Gad_AmbG,C_Gad_AmbB											
												//If LAG_Event_Type = LAG_C_EVENTTYPEMOUSEMOVE
													UpdateSky()
												//endif
											endcase
											
											case C_Gad_SkyOk, C_Gad_SunOk, C_Gad_FogOk, C_Gad_SHADO_RT, C_Gad_AmbOk
												IF GetRawMouseLeftPressed() or LAG_Event_Type = LAG_C_EVENTTYPEMOUSEPRESSED								
													UpdateSky()
												endif
											endcase
											
											case C_Gad_SHADO_Bias, C_Gad_SHADO_Smooth, C_Gad_SHADO_Type,C_Gad_SHADO_SizeW, C_Gad_SHADO_SizeH
												UpdateSky()
											endcase
											
											
										endselect
									
									// image bank & Object
									elseif Event_Gadget >= C_Gad_BankImg and Event_Gadget<=C_Gad_ShaderFolder
										
										// Create, Object & image bank
										select Event_Gadget
										
											// change asset size
											case C_Gad_AssetSize, C_Gad_AssetW, C_Gad_AssetL, C_Gad_AssetL
												if LAG_Event_Type = LAG_C_EVENTTYPEKEYPRESSED	
													Options.Asset.Size = valfloat(LAG_GetGadgetText(C_Gad_AssetSize))
													Options.Asset.W = valfloat(LAG_GetGadgetText(C_Gad_AssetW))
													Options.Asset.H = valfloat(LAG_GetGadgetText(C_Gad_AssetH))
													Options.Asset.L = valfloat(LAG_GetGadgetText(C_Gad_AssetL))
													SaveOptions()
												endif
											endcase 
											case C_Gad_AssetProp
												IF GetRawMouseLeftReleased() or LAG_Event_Type = LAG_C_EVENTTYPEMOUSERELEASED	
													OpenWindowAssetCreate() 
													SaveOptions()
												endif
											endcase
											
											// Change Object 3D											
											case C_Gad_BankPrevM
												If GetRawMouseLeftPressed() or LAG_event_Type = LAG_C_EVENTTYPEMOUSERELEASED 
													dec ObjTyp
													if ObjTyp < 0
														ObjTyp = C_OBJBANK
													endif
													LAG_SetGadgetState(C_Gad_PreviewModel,UiObjImg[ObjTyp]) // change the image
													SetObjectPanel()
												endif
											endcase
											case C_Gad_BankNextM
												If GetRawMouseLeftPressed() or LAG_event_Type = LAG_C_EVENTTYPEMOUSERELEASED 
													inc ObjTyp
													if ObjTyp > C_OBJBANK
														ObjTyp = 0
													endif
													LAG_SetGadgetState(C_Gad_PreviewModel,UiObjImg[ObjTyp]) // change the image
													SetObjectPanel()
												endif
											endcase
											Case C_Gad_BankMeshSet
												if LAG_Event_Type = LAG_C_EVENTTYPEMOUSEreleased
													SetObjectMesh()
												endif
											endcase
											
											
											// Images
											case C_Gad_ImgUsed
												if  LAG_event_Type = LAG_C_EVENTTYPEMOUSERELEASED 
													options.listImageTyp = 1- options.listImageTyp
													txt$ = "Bank,used,"
													Lag_SetGadgetText(C_Gad_ImgUsed, GetStringToken(txt$,",", options.listImageTyp+1))
													UpdateListImage()
												endif
											endcase
											
											
											
											// import and add model gadgets
											case C_Gad_BankExport
												if GetRawMouseLeftReleased() 
													ExportModel()
												endif
											endcase
											case C_Gad_BankImport
												if GetRawMouseLeftReleased() 
													ImportModel("",0) // in document.agc
												endif
											endcase
												
											case C_Gad_BankNew
												If GetRawMouseLeftReleased()
													NewBankPreset()
												endif
											Endcase
											case C_Gad_BankOpen
												if GetRawMouseLeftReleased()
													OpenBankPreset("",0)
												endif
											endcase
											case C_Gad_BankSave
												if GetRawMouseLeftReleased()
													SaveBankPreset("",0)
												endif
											endcase
											case C_Gad_BankSub
												// remove an unused model from the bank
												If GetRawMouseLeftReleased()
													if Options.BankModelId >-1													
														RemoveModelFromBank()
													else
														LAG_Message("Information","You need to select a model first before to remove it from the bank.","") 
													endif
												endif
											endcase 
											case C_Gad_BankAdd
												if GetRawMouseLeftPressed() 
													If bankModel.length >-1
														if Options.BankModelId >-1
															ObjTyp = C_OBJBANK
															AddObjet(0,0,0,"")
														endif
													else
														LAG_Message("Information","You need to import a model first. Clic on the 'import model' button to import a model into the bank model, then clic on the '+' or the A key to add the model in the level.","")
													endif
												endif
											endcase
											
											case C_Gad_BankList
												IF GetRawMouseLeftPressed() or LAG_Event_Type = LAG_c_EventTypeMousePressed 											
													ObjTyp = C_OBJBANK
													Options.BankModelId = LAG_GetGadgetState(C_Gad_BankList)
													Options.BankModeName$ = LAg_GetGadgetItemText(C_Gad_BankList,Options.BankModelId)
													// LAG_message("ok","clic on bank list : "+str(BankModelId)+" "+BankModeName$,"")
												endif
											Endcase 
											
											// Change images
											case C_Gad_ShaderList
												if LAG_Event_Type = LAG_C_EVENTTYPEMOUSEreleased
													/*
													l$=""
													For i=0 to ShaderBank.length
														l$ = l$ + str(i)+" : "+ ShaderBank[i].Filename$+chr(13)
													next
													Message(l$)
													*/
													OpenWindowObjShader() 
												endif
											Endcase 
											
											case C_Gad_ShaderReload
												if LAG_Event_Type = LAG_C_EVENTTYPEMOUSEreleased
													ReloadALLShaders()
												endif
											Endcase 
											
											case C_Gad_SetImg												
												
												if GetRawMouseLeftPressed() or LAG_Event_Type = LAG_c_EventTypeMousePressed
													
													if ObjTyp = C_OBJPARTSYS
														
														For j=0 to object.length
															if object[j].selected =1 and Object[j].locked =0
																if object[j].Typ = C_OBJPARTSYS
																	Object[j].stage[1].TextureId = TextureId
																	SetPartSystemImg(object[j].IdObj3D,Particle[TextureId].img,-1)
																endif
															endif
														next
													
													else
														
														For j=0 to object.length
															
															if object[j].selected =1 and Object[j].locked =0
																
																if object[j].Typ <> C_OBJPARTSYS
																	
																	SetObjectColorEmissive(Object[j].Obj,0,0,0)
																	
																	stId = Object[j].StageId
																	
																	if options.listImageTyp = 0
																		n = CheckTextureId()
																		img = Texture[n].img
																		Object[j].stage[StId].TextureId = n
																	else
																		if textureId > -1 and textureId <= texture.length
																			img = Texture[TextureId].img
																			Object[j].stage[StId].TextureId = TextureId
																		endif
																	endif
																	
																	if assetTyp = C_ASSETOBJ
																		SetObjectImage(Object[j].Obj, img, stid)
																	elseif assetTyp = C_ASSETMESH
																		SetObjectMeshImage(Object[j].Obj, MeshId, img, stid)
																	endif
																	
																	Object[j].stage[StId].ImageId = img
																	UpdateGadTextureStage()
																endif
																
															endif
														next
													
													endif
												endif												
											endcase	
											
											case C_Gad_ImgDelete
												if GetRawMouseLeftPressed() or LAG_Event_Type = LAG_c_EventTypeMousePressed
													SetObjectImage2(0,0)
													UpdateGadTextureStage()
												endif
											endcase
												
											case C_Gad_ListStage
												if LAG_event_Type = LAG_c_EventTypeMousePressed
													StageId = LAG_GetGadgetState(C_Gad_ListStage)
													LAg_SetGadgetText(C_Gad_SetStage,str(StageId))
													options.UpdateStagelist = 1
													SetAssetProp(C_SETOBJPROP_STAGEImg)	
													options.UpdateStagelist = 0
												endif
											Endcase 
												
											case C_Gad_ImgNormal
												if GetRawMouseLeftPressed() or LAG_Event_Type = LAG_c_EventTypeMousePressed
													SetObjectImage2(-1, lag_getgadgetstate(C_Gad_ImgNormal))
												endif
											endcase
											
											case C_Gad_ImgLightmap
												if GetRawMouseLeftPressed() or LAG_Event_Type = LAG_c_EventTypeMousePressed
													SetObjectImage2(-2, lag_getgadgetstate(C_Gad_ImgLightmap))
												endif
												
											endcase
											
											case C_Gad_ImgReload	
												if GetRawMouseLeftReleased() or LAG_Event_Type = LAG_c_EventTypeMouseReleased
													ReloadImage() // in editor.agc
												endif
											endcase
																						
											case C_Gad_ImgList
												
												if LAG_Event_Type = LAG_c_EventTypeMousePressed
													TextureId = LAG_GetGadgetState(C_Gad_ImgList)
													TextureName$ = LAg_GetGadgetItemText(C_Gad_ImgList,TextureId)
													Lag_SetGadgetText(C_Gad_ImgName, TextureName$)
													
													if TextureID>=0  
														ImgID = GetCurrentTexture(0)
														LAG_SetGadgetState(C_Gad_BankImg,imgID)
													endif
													
												endif
												
											endcase
															
											case C_Gad_BankImgPrev // Image prev
												IF LAG_Event_Type = LAG_c_EventTypeMouseReleased
													//message("<")
													Dec FolderId
													if FolderId<0
														FolderId = ImgFolder.length
													endif
													UpdateListImage()
																										
												endif
											endcase											
											case C_Gad_BankImgNext // image Next
												IF LAG_Event_Type = LAG_c_EventTypeMouseReleased
													//message(">")
													inc FolderId
													if FolderId > ImgFolder.length
														FolderId = 0
													endif
													UpdateListImage()
													
												endif
											Endcase
										
										endselect
											
									else
										
										FoldStart // autres gadgets 
										
										if Event_gadget = C_Gad_PanelL
											
											PanelL_Id = Lag_GetGadgetState(C_Gad_PanelL)
											SetPanel("", PanelL_Id)
											
										elseif Event_gadget = C_Gad_PanelR
											
											pos = Lag_GetGadgetState(C_Gad_PanelR)
											PanelL_Id = pos
											
											if pos = 2
												SetToolContainer(C_Gad_Tool1)
											endif
											
										elseif Event_gadget < C_Gad_Tool1
											
											// Other gadgets
											Select Event_Gadget
											
											
												
											endselect
										
										else
											
											if Event_gadget>= C_Gad_Tool1 and Event_gadget<= C_Gad_Tool4
												IF GetRawMouseLeftPressed() or LAG_Event_Type = LAG_c_EventTypeMousePressed
													SetToolContainer(Event_Gadget)
												endif
											else
												
												// gadget for the tools (lightmapper, lvl prop...)
												
												Select Event_gadget
													
													case C_Gad_LM_UseLight
														IF GetRawMouseLeftReleased() or LAG_Event_Type = LAG_c_EventTypeMouseReleased
															SetLightMapProp()
															SyncShadow()
														endif
													endcase 
													
													case C_Gad_LM_SoftShSample,C_Gad_LM_ShadoAlpha,C_Gad_LM_ShadoR,C_Gad_LM_ShadoG,C_Gad_LM_ShadoB,C_Gad_LM_Rx,C_Gad_LM_Ry,C_Gad_LM_Rz,C_Gad_LM_SoftShSize,C_Gad_LM_Height,C_Gad_LM_SizeRange
														SetLightMapProp()
														SyncShadow()
													endcase
													
													case C_Gad_GameMode
														IF LAG_Event_Type = LAG_c_EventTypeMousePressed
															Txt$ = "plateform,isometric,3rd pers,RTS,FPS,fixed,Side scrolled"
															inc Options.GameMode
															if options.gameMode>6
																options.GameMode=0
															endif
															LAG_SetGadgetText(C_Gad_GameMode,GetStringToken(txt$,",",1+Options.GameMode))
														endif
													endcase
													
													case C_Gad_Orientation
														IF GetRawMouseLeftPressed() or LAG_Event_Type = LAG_c_EventTypeMousePressed
															Options.Orientation= 1-Options.Orientation
															Txt$ = "Global,Local"
															LAG_SetGadgetText(C_Gad_Orientation,GetStringToken(txt$,",",1+Options.Orientation))
														endif
													endcase
													
													case C_Gad_UsePhysics
														IF LAG_Event_Type = LAG_c_EventTypeMousePressed
															
															
															if Options.PhysicOn = 1 
																Options.PhysicOn = 0
															else
																Reset3DPhysicsWorld()
																For i=0 to object.length
																	SetPhysicToObject(i,1)
																next
																Options.PhysicOn = 1
															endif
															
														endif
													endcase
													
													case C_Gad_PivotCenter
														if GetRawMouseLeftPressed() or LAG_Event_Type = LAG_c_EventTypeMousePressed
															inc Options.Pivotcenter
															txt$ = "Origin,Box,Active," //,Cursor"
															if Options.Pivotcenter > 2
																Options.Pivotcenter =0
															endif
															LAG_SetGadgetText(C_Gad_PivotCenter,GetStringToken(txt$,",",1+Options.Pivotcenter))
														endif
													endcase
												
												EndSelect
												
											endif
										endif
										
										FoldEnd
										
									endif
									
									Foldend
									
								endif
								
							endif
							
							Foldend
							
						endif
					
					endif
					
					FoldEnd
				
				endif
				
			FoldEnd
			
			
		else
			
			FoldStart // Other events (mouse, action, camera...)
			
			FreeToolTips()
			EventLight()
			
			foldStart // if we move the camera
			IF use_Lag = 1
				
				if OldCamX <> Getcamerax(1) or OldCamY <> GetcameraY(1) or OldCamZ <> GetcameraZ(1)
					
					OldCamX = GetcameraX(1)
					OldCamY = GetcameraY(1)
					OldCamZ = GetcameraZ(1)
						
					//LAG_StatusBarText(0,1,"Camera Pos :"+str(OldCamX)+"/"+str(OldCamY)+"/"+str(OldCamZ)+"| Rot : "+str(GetCameraAngleX(1),0)+"/"+str(GetCameraAngleY(1),0)+"/"+str(GetCameraAngleZ(1),0))
					LAG_SetGadgetText(C_Gad_CamX,str(OldCamX)) 
					LAG_SetGadgetText(C_Gad_CamY,str(OldCamY)) 
					LAG_SetGadgetText(C_Gad_CamZ,str(OldCamZ)) 
					LAG_SetGadgetText(C_Gad_CamRX,str(GetCameraAngleX(1),0)) 
					LAG_SetGadgetText(C_Gad_CamRY,str(GetCameraAngleY(1),0)) 
					LAG_SetGadgetText(C_Gad_CamRZ,str(GetCameraAngleZ(1),0)) 
					
					v$="Front,2,Right,Left,Perspective,Bottom,Top,"
					LAG_StatusBarText(0,1,"View : "+GetStringToken(v$,",",Cameraview))
					
					LAG_StatusBarText(0,2,"Nb obj :"+str(Object.Length+1)+" | Phys : "+str(Get3DPhysicsTotalObjects())+" | Poly : "+str(GetPolygonsDrawn()))
					
				endif
			endif
			Foldend
			
			
			FoldStart //****************** The other events  : mouse (action)  & camera only

			
			foldstart // ***************  Mouse
			
			
			if LAG_MenuOpen >= 1 // if a menu is opened -> close it

				foldstart // ----- Mouse, action
				
				if Use_lag =1
					if GetPointerState()			
						LAG_v_MenuItemId = -1
						LAG_CloseMENU()
						LAG_MenuOpen = 0
					endif
				endif
				
			else
				/*
				if GetPointerReleased()
					if ObjId > -1
						GetObjProp()
					endif
				endif
				*/
									
				FoldStart // Action
				
				if actionview = 0
					
					if Alt = 0 and Ctrl = 0 // GetRawKeyState(Key_Alt) = 0	and GetRawKeyState(Key_Control) = 0
									
						select action
					
					case C_ACTIONCREATE 
						
						if GetPointerPressed()
							CreateNewObject(0) // in object.agc
						endif
						
						If GetRawMouseLeftState()
							If Options.AutoCreate = 1 // to paint on the level with objects (like grass)
								CreateNewObject(0) // in object.agc
							endif							
						endif
						
						
					endcase
						
					case C_ACTIONSELECT 
						
						
						
						if GetRawMouseLeftPressed()
							
							SelectStartX = mx
							SelectStartY = my
							objId = -1
							
							// unselect all
							if shift= 0								
								SelectObject(1)							
							endif
							
							SelectionBorder = 1
							
							moveobj = CheckRaycast(moveobj)
							UpdateSelection()
							
						elseIf GetPointerReleased()
							
							SelectionBorder = 0
							// determine if the centre of the object if within the selection box
							// based on the object's screen x and y position
							For i=0 to object.length
					 
								if object[i].xp_screen# > left# and object[i].xp_screen# < right#
									if object[i].yp_screen# > top# and object[i].yp_screen# < bottom#
										object[i].selected = 1
										SetObjectColorEmissive(object[i].obj,255,0,0)
									endif
								endif
					 
							next
						
						endif
						
						FoldStart // pointer state
						if GetPointerstate() 
							
							Selectionborder = 1
							EndX# = mx
							EndY# = my
							StartX# = SelectStartX
							StartY# = SelectStartY
							
							// determine the left, right, top and bottom of the selection box
							if StartX# < EndX#
								left# = StartX#
								right# = EndX#
							else
								left# = EndX#
								right# = StartX#
							endif
					 
							if StartY# < EndY#
								top# = StartY#
								bottom# = EndY#
							else
								top# = EndY#
								bottom# = StartY#
							endif
					 
						endif
						
						foldend
						
					Endcase	
					
					case C_ACTIONMOVE 
						
						a# = 0.0007875*2.5 // needed to move object in ortho view !!!! a# = 0.0007875
						
						FoldStart // pointer pressed
							
							
							if GetRawMouseLeftPressed()
								
								if shift= 0								
									SelectObject(1)						
								endif	
									
								if (cloning =0 or shift=0)
									moveobj = CheckRaycast(moveobj)
								endif
								
								if moveobj >=0
									
									FoldStart 
									
									okmove = GetAssetCanMove(moveobj) // in editor.agc
									
									if okmove =1
										
										UpdateSelection()	
											
										GetAssetPos(moveobj)
										
										if Options.Camera.Ortho = 1 
											
											Orthowidth# = Options.Camera.OrthoW * a#
											
											mousex# = GetPointerX() * Orthowidth#
											mousey# = GetPointerY() * Orthowidth#
											
											startx# = mousex# 
											starty# = mousey# 
											
										else
											
											mousex# = GetPointerX() 
											mousey# = GetPointerY() 
												
											CamX# = GetCameraX(1)
											CamY# = GetCameraY(1)
											CamZ# = GetCameraZ(1)
											
											//if options.LockY = 0
												u = GetDistance3D(camx#, camY#, camZ#, objx, objy, objz) 
												TheDist = u
												Start_oX# = Get3DVectorXFromScreen(mousex#, mousey#) * u + camX# - ObjX
												Start_oY# = Get3DVectorYFromScreen(mousex#, mousey#) * u + camY# - ObjY 
												Start_oZ# = Get3DVectorZFromScreen(mousex#, mousey#) * u + camZ# - objZ
											//else
												
												//Start_oX# = Get3DVectorXFromScreen( mousex#, mousey# )  + camX# - ObjX
												//Start_oY# = Get3DVectorYFromScreen( mousex#, mousey# )  + camY# - ObjY 
												//Start_oZ# = Get3DVectorZFromScreen( mousex#, mousey# )  + camZ# - objZ
												
											//endif
												
										endif
									endif
									
									foldend
									
								endif
								
							endif	
						
						foldend
																		
						FoldStart // state
							
						if GetRawMouseLeftState()
							
							if moveobj >=0 or (shift = 1 and cloning=1) // and ObjId >-1	
								
								okmove = GetAssetCanMove(moveobj) // in editor.agc
								
								// MoveObject
								okok = 1
								
								if okmove = 1	
									
										
									if Options.Camera.Ortho = 1 
										
										FoldStart 
										// AR !! 
										Orthowidth# = Options.Camera.OrthoW*a#
										
										
										mousex# = GetPointerX() * Orthowidth#
										mousey# = GetPointerY() * Orthowidth#
										
										xa = mousex# - startx#
										ya = mousey# - starty#
										
										x# = xa
										y# = ya
										
										// print("X : "+str(x#)+" /y : "+str(y#)+" | pointer : "+str(GetPointerX())+" | "+str(GetPointerY())+" | obj : "+str(GetObjectX(Object[moveobj].Obj))+"/"+str(GetObjectZ(Object[moveobj].Obj)))
										
										if cameraview = 7
											z# = -y# + objZ
											x# = x# + objX
											y# = 0
										elseif cameraview = 1										
											y# = -y# + objY	
											x# = x#	+ objX	
											z# = 0
										elseif  cameraview = 3
											y# = -y# + objY								
											z# = -x# + objZ
											x# = 0
										else
											
										endif
										Foldend
									
									else
										
										Foldstart 
										if  (options.LockY = 0 or okok = 1)
									
											
											GetAssetPos(moveobj)
										
										
											mousex# = GetPointerX()
											mousey# = GetPointerY()
					
											CamX# = GetCameraX(1)
											CamY# = GetCameraY(1)
											CamZ# = GetCameraZ(1)
											u =  GetDistance3D(camx#, camY#, camZ#, objx, objy, objz)
											Y# = Get3DVectorYFromScreen( mousex#, mousey# ) * u + Camy# - Start_oY#
											X# = Get3DVectorXFromScreen( mousex#, mousey# ) * u + CamX# - Start_oX#
											Z# = Get3DVectorZFromScreen( mousex#, mousey# ) * u + CamZ# - Start_oZ# 
										
										else
											
											// print("camera Ortho !")
												
											get_mouse_coords(0) // in editor.agc 
											
											//if GetCameraAngleY(1) > 10										
												x# = Mouse_X // round(Mouse_X)
											//endif
											
											//if GetCameraAngleX(1) > 10
												z# = Mouse_Z // round(Mouse_Z)
												//if GetCameraAngleY(1) > 10	
													y# = 0
												//else											
													
												//endif
											//else
												//z# = Mouse_X
												//y# = 0
												
												// get_mouse_coords(1)
												// z# = 0										
												 // y# = Mouse_Z*0.2
											//endif	
											
											
										endif
										foldend
									endif
											
									// UpdateSelection()
									
									
									// move object selected 			
									For i=0 to object.length
										
										if Object[i].locked = 0
											
											if Object[i].hide = 0
											
												if object[i].selected	
													
													lockX = max(Object[i].lock.pos.x + options.LockX, 1)
													locky = max(Object[i].lock.pos.y + options.LockY, 1)
													lockz = max(Object[i].lock.pos.z + options.LockZ, 1)
													
													//if options.LockX = 1 and options.LockZ = 1
														
														//y1# = object[i].y*LockY - (y# + object[i].Starty - Options.Starty#) *(1-LockY) 
														
													//else
														
														x1# = object[i].x*LockX + (x# + object[i].Start.pos.x - Options.Startx#) *(1-LockX) 
														
														y1# = object[i].y*LockY + (y# + object[i].Start.pos.y - Options.StartY#) *(1-LockY) 
														
														z1# = object[i].z*LockZ + (z# + object[i].Start.pos.z - Options.StartZ#) *(1-LockZ) 
														
														//print(str(object[i].Startx - Options.Startx#)+"/"+str(object[i].Starty - Options.Starty#)+"/"+str(object[i].Startz - Options.Startz#))
														
														
													//endif
													
													
													if Snap >= 1
														
														x = round(x1# / SNapX)
														x1# = x * SnapX
														
														z = round(z1# / SnapZ)
														z1# = z * SnapZ
														
														y = round(y1# / SnapY)
														y1# = y * SnapY
														
													endif
													
													
													MoveObject(i, x1#, y1#, z1#)
													
												endif
											
											endif
											
										endif
										
									next											
									
									// Move light selected
									For i=0 to Light.length
												
												if Light[i].locked=0
													
													if Light[i].hide=0
													
														if Light[i].selected
																
															//lockX = max(Light[i].lock.pos.x + options.LockX, 1)
															//locky = max(Light[i].lock.pos.y + options.LockY, 1)
															//lockz = max(Light[i].lock.pos.z + options.LockZ, 1)	
															
															lockX = max(Light[i].lock.pos.x + options.LockX, 1)
															locky = max(Light[i].lock.pos.y + options.LockY, 1)
															lockz = max(Light[i].lock.pos.z + options.LockZ, 1)	
																
															
																										
															x1# = Light[i].x*LockX + (x# + Light[i].startX - Options.StartX#)*(1-LockX)
															
															y1# = Light[i].y*LockY + (y# + Light[i].Starty - Options.Starty#)*(1-LockY)
															
															z1# = Light[i].z*LockZ + (z# + Light[i].StartZ - Options.StartZ#)*(1-LockZ)	
															
															if Snap >= 1
																
																x = round(x1# / SNapX)
																x1# = x * SnapX
																
																z = round(z1# / SnapZ)
																z1# = z * SnapZ
																
																y = round(y1# / SnapY)
																y1# = y * SnapY
																
															endif
															
																									
															OBjId = i
															// MoveLight(x1#, Light[i].y, z1#)
															MoveLight(x1#, y1#, z1#)
														endif
													endif
												endif
											next											
								
							
								endif
								
								
								
							endif
							
						endif
							
						Foldend
						
						FoldStart // released
						if GetRawMouseLeftReleased()
														
							if moveObj >= 0 or (shift = 1 and cloning = 1)								
									
								For i=0 to object.length	
													
									if object[i].Locked = 0							
										//if object[i].hide = 0	
																
											if object[i].Selected
												
												n = Object[i].Obj
												
												Object[i].x = GetObjectX(n)
												Object[i].y = GetObjectY(n)
												Object[i].z = GetObjectZ(n)
												
												Object[i].Start.Pos.X = Object[i].x  
												Object[i].Start.Pos.Y = Object[i].y  
												Object[i].Start.Pos.Z = Object[i].z 
												
													
											endif
										//endif					
									endif					
								next
								
								
								UpdateSelection()
								
								For i=0 to light.length					
									if light[i].Locked = 0
										
										//if light[i].hide = 0
																	
											if light[i].Selected
												
												n = light[i].Obj
												
												light[i].x = GetObjectX(n)
												light[i].y = GetObjectY(n)
												light[i].z = GetObjectZ(n)
												
												light[i].StartX = light[i].x  
												light[i].StartY = light[i].y  
												light[i].StartZ = light[i].z 
													
											endif
										//endif
									endif					
								next
								
								For i=0 to Camera.length					
									if Camera[i].Locked = 0
										
										//if light[i].hide = 0
																	
											if Camera[i].Selected
												
												n = Camera[i].Obj
												
												Camera[i].x = GetObjectX(n)
												Camera[i].y = GetObjectY(n)
												Camera[i].z = GetObjectZ(n)
												
												Camera[i].StartX = Camera[i].x  
												Camera[i].StartY = Camera[i].y  
												Camera[i].StartZ = Camera[i].z 
													
											endif
										//endif
									endif					
								next
								
								GetAssetProp()
								
							endif
							moveobj = -1
							cloning = 0
							
						endif
						foldend
						
						
						endcase
					
					case C_ACTIONSCALE 
										
						if GetRawMouseLeftPressed()
							
							moveobj = CheckRaycast(moveobj)
							StartX# = mx
							
						elseif GetPointerReleased()
							
							moveobj = 0	
							For i =0 to Object.length
								
								if Object[i].selected = 1
									n = Object[i].Obj
									Object[i].sx = Object[i].Start.Siz.X // GetObjectSizeMaxX(n)-GetObjectSizeMinX(n) // ux
									Object[i].sy = Object[i].Start.Siz.Y // GetObjectSizeMaxY(n)-GetObjectSizeMinY(n) // uy
									Object[i].sz = Object[i].Start.Siz.Z // GetObjectSizeMaxZ(n)-GetObjectSizeMinZ(n) // uz
									Object[i].Size = Object[i].StartS // GetObjectSizeMaxZ(n)-GetObjectSizeMinZ(n) // uz
									
									if options.Pivotcenter = 1
										Object[i].X = Object[i].x1
										Object[i].y = Object[i].y1
										Object[i].z = Object[i].z1										
									endif
									
									if options.Pivotcenter <> C_PIVOT_ORIGIN
										FixObjectToObject(n,-1)
									endif
									
									if ObjId = i
										GetObjProp()
									endif
									UpdateSelection()
								endif
								
							next							
						
						endif
						
						if GetPointerState()
							
							lockxyz = Options.LockSX + Options.LockSY + Options.LockSZ 
							
							For i= 0 to object.length
								
								if object[i].selected = 1
									
									if object[i].Locked = 0	
										
										n = Object[i].Obj
										a# = 0.05* (mx-StartX#)

										if options.Pivotcenter = 1
											// FixObjectToObject(n,ObjPivot)
											/*
											Object[i].X1 = Object[i].x *a#*0.1
											Object[i].y1 = Object[i].y *a#*0.01
											Object[i].z1 = Object[i].z *a#*0.1
											SetObjectPOsition(n,Object[i].X1,Object[i].y1,Object[i].z1)
											*/
											
											SetObjectScale2(i, a#)
											
										else
											//SetObjectScale2(n,ux*s#,uy*s#,uz*s#)
											SetObjectScale2(i, a#)
										endif
										
										
										
										if ObjId = i
											GetObjProp()
										endif
										
										UpdateSelection()
										
									endif
									
								endif
								
							next
							
						endif					
					endcase
					
					case C_ACTIONROTATE 				
						
						if GetPointerPressed()
							
							moveobj = CheckRaycast(moveobj)
							obj = PickObject(0) //CheckWorld()
							StartX# = mx
							
							For i=0 to Object.length
								n = Object[i].Obj
								// obj=ObjectRayCast(n,getcamerax(1),getcameray(1),getcameraz(1),worldx#,worldy#,worldz#)
								if obj=n
									ObjId = i							
									Moveobj = i
									AssetTyp = C_ASSETOBJ						
									exit
								endif
							next
						
						elseif GetPointerReleased()
							
							moveobj = 0
							For i=0 to object.length
								
								if Object[i].Selected =1
									
									if object[i].locked= 0
										
										n = Object[i].Obj
										if Options.Orientation =0
											 	
											Object[i].rx= mod(Object[i].Start.Rot.X,360) // GetObjectAngleX(n)
											Object[i].ry= mod(Object[i].Start.Rot.Y,360) // GetObjectAngleY(n)
											Object[i].rz= mod(Object[i].Start.Rot.Z,360) // GetObjectAngleZ(n)
											
										endif
										
										
										if objid =i									
											GetObjProp()
										endif
											
									endif
									
								endif
								
							next
						
						endif
						
						if GetPointerState()							
							For i= 0 to object.length							
								
								if object[i].selected =1
									
									if object[i].locked = 0
										
										n = Object[i].Obj 						
										a# = 2
										uu# = (mx-StartX#)*a#
										
										lockRX = max(Object[i].lock.Rot.x + options.LockRX, 1)
										lockRy = max(Object[i].lock.Rot.y + options.LockRY, 1)
										lockRz = max(Object[i].lock.Rot.z + options.LockRZ, 1)
										
										ux = ( uu# * (1-LockRX) + Object[i].Rx)
										uy = ( uu# * (1-LockRY) + Object[i].Ry)
										uz = ( uu# * (1-LockRZ) + Object[i].Rz)
										
										if Options.Pivotcenter = C_PIVOT_ORIGIN
											
											if Options.Orientation =0
												
												SetObjectRotation(n,ux,uy,uz)
												Object[i].Start.Rot.X = ux
												Object[i].Start.Rot.Y = uy
												Object[i].Start.Rot.Z = uz
												
												UpdateRotOutline(i,ux,uy,uz)
											
											elseif Options.Orientation =1
												
												ux1# = (mx-StartX#) * (1-LockRX)					
												uy1# = (mx-StartX#) * (1-LockRY)						
												uz1# = (mx-StartX#) * (1-LockRZ)	
												StartX# = mx 					
												RotateObjectLocalX(n, ux1#)
												RotateObjectLocalY(n, uy1#)
												RotateObjectLocalZ(n, uz1#)
												
												Object[i].rx = mod(Object[i].rx + ux1#, 360)
												Object[i].ry = mod(Object[i].ry + uy1#, 360)
												Object[i].rz = mod(Object[i].rz + uz1#, 360)
												
												UpdateOutline(i,1,0,1)
											endif
											
										else
											
											
										endif
										
										if objid =i									
											GetObjProp()
										endif
									endif
								endif
							next
						endif							
						
							
					endcase
					
					case C_ACTIONDELETE
						
						if GetPointerPressed()	
							
							obj = PickObject(0)
								
							MoveObj =0
								
							For i=0 to Object.length
								n = Object[i].Obj
								if obj=n	
									ObjId = -1							
									Moveobj = 1	
									if Object[i].Typ = C_OBJWATER
										dec NbWater
									endif					
									DeleteTheObject(i)
									Object.remove(i)							
									exit
								endif
							next
							
							if 	Moveobj = 0
								
								For i=0 to Light.length
									n = Light[i].Obj
									if obj=n	
										ObjId = i							
										Moveobj = 1								
										DeleteObject(Light[i].Obj)
										DeletePointLight(i+1)								
										Light.remove(i)												
										exit
									endif
								next
								
								if MoveObj =1
									DeleteLight()
									MoveObj = 0
									ObjId = -1
								endif
								
							else
								// need update the lightmap
								For i = 0 to Object.Length									
									if Object[i].LightMapID = 1
										TheObjectLightMAp = i
										exit
									endif
								next
							
							endif
							
						endif
						
					endcase
					
					endselect				
					
					endif
				endif
				
				FoldEnd
			
			
			foldend
			
				Foldstart // EDITOR MODE : move camera 
				
				Gosub MoveCamera // in editor.agc
				
				Foldend
			
			endif
			
			
			
			foldend
			
			
			
			
			foldend
			
			
			
			FoldStart //****************** Keyboard and event on the level only ********************//
			
			
			// print(str(GetRawLastKey()))
			if Active_Gadget = - 1			
			
				if Ctrl = 1 // GetRawKeyState(KEY_CONTROL)
					
					FoldStart  // Ctrl = 1
					// Select - deselect
					if GetRawKeyPressed(KEY_A) 
						SelectObject(0)
					endif
					if GetRawKeyPressed(KEY_D)				
						SelectObject(1)
					Endif
					If GetRawKeyPressed(KEY_P)
						if objID>-1 and objId<= object.length
							Object[ObjId].IsPlayer = 1
						endif
					endif
					
					// Lightmap
					If GetRawKeyPressed(key_L)
						if ObjId >-1 and ObjId <= Object.length
							TheObjectLightMAp = ObjId
							Object[ObjId].LightMapID = 1
							SyncShadow()					
							SaveImage(iLightmap,"lightmap.jpg")
						else
							LAG_message("Info","Please, select the ground which receive the lightmap first","")
						endif
					endif
					
					if GetRawKeyPressed(KEY_F)
						TransformObject(C_transform_Lock, 0)
					endif
					
					if GetRawKeyPressed(KEY_H)
						TransformObject(C_transform_Hide, 0)
					endif				
					if GetRawKeyPressed(KEY_N)  
						SaveOptions()
						NewDoc(0)
						Ctrl =0			
					endif
					if GetRawKeyPressed(KEY_O)  
						SaveOptions()
						OpenDoc(0)
						Ctrl =0			
					endif
					if GetRawKeyPressed(KEY_S)  
						SaveDoc(0)
						SaveOptions()
						Ctrl =0
					endif
					// copy/paste/clone
					
					if GetRawKeyPressed(KEY_C)
						CopyObject()
					Endif
					if GetRawKeyPressed(KEY_V)
						PasteObject()
					Endif
					Foldend
				
				else
					
					if shift = 1 // GetRawKeyState(KEY_SHIFT)
						
						FoldStart // shift =1
						if GetRawKeyPressed(KEY_D)	 //Clone
							CopyObject()
							PasteObject()
							cloning = 1
						endif			
						if GetRawKeyPressed(KEY_U)				
							Snap = 1 - Snap
							LAG_SetGadgetState(2,Snap)
							SaveOptions()				
						endif
						
						if GetRawKeyPressed(KEY_R)=1 												
							For i=0 to Object.length
								if object[i].selected= 1 and object[i].locked = 0
								Object[i].rx = 0
								Object[i].ry = 0
								Object[i].rz = 0
								SetObjectRotation(Object[i].Obj,0,0,0)
									if objId = i
										GetObjProp()
									endif
								endif
							next						
						Endif
						
						if GetRawKeyPressed(KEY_S)=1 
							For i=0 to Object.length
								if object[i].selected= 1 and object[i].locked = 0
									Object[i].sx = 1
									Object[i].sy = 1
									Object[i].sz = 1
									Object[i].size = 1
									SetObjectScale2(i,0)
									if objId = i
										GetObjProp()
									endif
								endif
							next
						Endif
							
						if GetRawKeyPressed(KEY_P)=1 
							//For i=0 to Object.length
							i = ObjId
								if object[i].selected= 1 and object[i].locked = 0
									Object[i].x = 0
									Object[i].y = 0
									Object[i].z = 0								
									SetObjectPosition(Object[i].Obj,0,0,0)
									UpdateObjectCenterSprite(i)
									GetObjProp()
								endif
							//next
						Endif
							
						FoldEnd
					
					else
											
						FoldStart // Alt = 1
						
						if Alt =1 						
							//if GetRawKeyPressed(KEY_H) // hide
								/*
								For i=0 to Object.length
									if object[i].selected
										Object[i].Hide=0
										SetObjectVisible(Object[i].Obj,1)
										SetSpriteVisible(Object[i].spr,1)
									endif
								next
								For i=0 to light.length
									if light[i].selected
										light[i].Hide=0
										SetObjectVisible(light[i].Obj,1)									
									endif
								next
								*/
							//endif
						Foldend
							
						else
							
							FoldStart // no ctrl, no shift, no alt 
							
							If GetRawKeyPressed(KEY_SLASH)
								SetView(1)	// editor .agc 				
							endif
							If GetRawKeyPressed(KEY_P)
								 Action = C_ACTIONPLAY		
							endif
							If GetRawKeyPressed(KEY_ASTERIX)
								SetView(0) // in editor.agc							
							endif
							If GetRawKeyPressed(KEY_9)
								SetView(2) // in editor.agc							
							endif
							
							FOldStart // Option
							if GetRawKeyPressed(KEY_F4)
								Options.Fullscreen = 1- Options.Fullscreen
								SetWindowSize(G_width,G_height, Options.Fullscreen)
								if Options.FullScreen
									y=-30
									Options.Y = -30
									LAG_SetMenuPosition(0,0,y)
									LAG_SetGadgetSize(C_Gad_TB,LAG_c_ignore,y+30,LAG_c_ignore,LAG_c_ignore,LAG_c_ignore)
									
								else
									y=0
									Options.Y = 0	
									LAG_SetMenuPosition(0,0,y)							
									LAG_SetGadgetSize(C_Gad_TB,LAG_c_ignore,y+30,LAG_c_ignore,LAG_c_ignore,LAG_c_ignore)								
								endif
							endif
							
							if GetRawKeyPressed(KEY_F1)
								LAG_Message("Help",Help$,"")				
							endif
							
							if GetRawKeyPressed(KEY_F) // freeze object
								TransformObject(C_transform_Lock, 1)
							endif	
							if GetRawKeyPressed(KEY_H) // hide
								TransformObject(C_transform_Hide, 1)
							endif
							Foldend
							
							FoldStart // Action
							if GetRawKeyPressed(KEY_G) // move
								Move = 1
								Action = C_ACTIONMOVE
								action$ = SetAction() // in aditor.ini
							endif
							
							if GetRawKeyPressed(KEY_R) // Rotate
								Rot = 1
								Action = C_ACTIONROTATE
								action$ = SetAction()
							endif
							
							if GetRawKeyPressed(KEY_S) // Scale
								Scale = 1
								Action = C_ACTIONSCALE
								action$ = SetAction()
							endif
							
							if GetRawKeyPressed(KEY_DELETE) // delete						
								DeleteAsset()								
								MoveObj = 0						
							endif
							
							FoldEnd 
							
							FoldStart // View
							
							if GetRawKeyPressed(KEY_0) // view camera default
								SetCAmeraPosition(1,Options.Camera.X, Options.Camera.Y, Options.Camera.Z)
								SetCameraRotation(1,Options.Camera.RX, Options.Camera.RY, Options.Camera.RZ)
								SetCameraFOV(1,Options.Camera.Fov)
								CamOk = 0
								UpdateCameraUi() // dans editor.agc	
								CameraView = 0
								SetObjectRotation(Grid,0,0,0) 
							endif
							
							if GetRawKeyPressed(KEY_7) // TOP
								if CamOk = 0
									CamOk = 1
									GetCameraProp()
								endif
								Options.Camera.Ortho = 1
								if Options.Camera.OrthoW <=0
									Options.Camera.OrthoW = 1000
								endif
								
								CameraView = 7
								
								SetCameraRotation(1,90,0,0)
								// SetObjectRotation(CubeView, 90,0,0)
								
								SetCAmeraPosition(1,0,200,0)
								SetObjectRotation(Grid,0,0,0) 
								// SetCAmeraPosition(1,0,0,-150)
								SetCameraOrthoWidth(1,Options.Camera.OrthoW)
								SetCameraFov(1,0)								
								UpdateCameraUi() // dans editor.agc	
								// SetAllObjectCulling(1)
							endif
							
							if GetRawKeyPressed(KEY_3) // Right
								if CamOk = 0
									CamOk = 1
									GetCameraProp() // in editor.agc
								endif
								Options.Camera.Ortho = 1
								if Options.Camera.OrthoW <=0
									Options.Camera.OrthoW = 1000
								endif
								SetCameraRotation(1,0,90,0)
								// SetObjectRotation(CubeView, 0,90,0)
								SetCameraOrthoWidth(1,Options.Camera.OrthoW)
								SetCameraFov(1,0)
								UpdateCameraUi() // dans editor.agc	
								CameraView = 3
								//SetAllObjectCulling(1)
								SetObjectRotation(Grid,90,90,0) 
							endif
							
							if GetRawKeyPressed(KEY_1) // front
								if CamOk = 0
									CamOk = 1
									GetCameraProp()
								endif
								Options.Camera.Ortho = 1
								if Options.Camera.OrthoW <=0
									Options.Camera.OrthoW = 1000
								endif
								
								SetCameraRotation(1,0,0,0)
								SetObjectRotation(CubeView, 0,0,0)
								
								SetCameraOrthoWidth(1,Options.Camera.OrthoW )
								SetCameraFov(1,0)							
								UpdateCameraUi() // dans editor.agc	
								//SetAllObjectCulling(1)
								CameraView = 1
								SetObjectRotation(Grid,90,0,0) 
							endif
							
							
							// perspective - orthographic
							if GetRawKeyPressed(KEY_5)
								
								if CamOk = 0
									CamOk = 1
									GetCameraProp()
								endif
																
								
								if CameraView = 3
									SetObjectRotation(CubeView, 0,0,0)
									SetCameraRotation(1,30,0,0)
									// SetCubeViewTocamera(1)
									
									RotateObjectGlobalY(CubeView,90)
									RotateCameraGlobalY(1,90)									
									RotateCameraLocalX(1,0)									
									SetCubeViewTocamera(0)
									
								elseif CameraView = 7
									SetObjectRotation(CubeView, 0, 0,0)
								endif
								
								
								CameraView = 5
								
								Options.Camera.Ortho = 1 - Options.Camera.Ortho
								if Options.Camera.Ortho = 0 // perspective
									if Options.Camera.Fov = 0
										Options.Camera.Fov = 70
									endif													
									SetCameraFov(1,Options.Camera.Fov)								
								elseif Options.Camera.Ortho = 1												
									SetCameraFov(1,0)
									if Options.Camera.OrthoW <=0
										Options.Camera.OrthoW = 1000
									endif
									SetCameraOrthoWidth(1, Options.Camera.OrthoW)
								endif
								UpdateCameraUi() // dans editor.agc	
								//SetAllObjectCulling(1-Options.CameraOrtho)
								SetObjectRotation(Grid,0,0,0) 			
							endif
							Foldend
							
							//If GetRawKeyPressed(Key_2)
								// SetCameraToLightMapView()						
							//endif
							
							/*
							if GetRawKeyPressed(KEY_U)
								Options.ShowSun = 1-Options.ShowSun
								SetSunActive(Options.ShowSun)
								SaveOptions()				
							endif
							if GetRawKeyPressed(KEY_B)
								Options.ShowSkyBox = 1-Options.ShowSkyBox
								SetSkyBoxVisible(Options.ShowSkyBox)
								SaveOptions()				
							endif
							if GetRawKeyPressed(KEY_F)
								Options.ShowFog = 1-Options.ShowFog
								SetFogMode(Options.ShowFog)	
								SaveOptions()			
							endif
							*/
							
							
							// Add object, change type...
							ObjTyp$ = CheckKeyboard(ObjTyp$) // dans editor.agc
							
							Foldend
							
						endif
							
					endif
				endif
				
			endif
			
			Foldend
		
			Foldend
		
		endif	
		
		Foldend
		
		

		FoldStart //************* Keyboard and Other code here if needed ********************//
		
		// keyboard events <----------- : shortcuts should be assigned with menu, and keyboard could be an EventType

		if GetRawKeyPressed(KEY_ESCAPE)
			SaveOptions()
			end
		endif
		
		FoldStart // Ctrl, alt, shift
		
		If GetRawKeyState(KEY_CONTROL) 
			Ctrl = 1
		Endif
		if GetRawKeyReleased(KEY_CONTROL) 
			Ctrl = 0
		endif	    
		IF GetRawKeyState(KEY_SHIFT) 
			Shift = 1
		Endif
		if GetRawKeyReleased(KEY_SHIFT) 
			Shift =0
		endif
		IF GetRawKeyState(KEY_Alt) 
			Alt = 1
		Endif
		if GetRawKeyReleased(KEY_Alt) 
			Alt =0
		endif
		
		Foldend
			
		// Print("ctrl : "+str(ctrl)+"/ shift : "+str(shift))	
			
		if Active_Gadget = - 1
		
			if Ctrl = 1// GetRawKeyState(KEY_CONTROL) = 1
				
				FoldStart  // Ctrl = 1
				
				if alt = 1 
					
					if GetRawKeyPressed(KEY_S)  
						SaveDoc(1)
						SaveOptions()
						Ctrl =0
						alt = 0
					endif
					
				else
					if GetRawKeyPressed(KEY_G)  
						Options.ShowGrid = 1-Options.ShowGrid
						// LAG_SetGadgetState(,Options.ShowGrid)
						SetObjectVisible(Grid,Options.ShowGrid)
						SaveOptions()
						Ctrl =0
					endif
					
					if GetRawKeyPressed(KEY_S)  
						SaveDoc(0)
						SaveOptions()
						Ctrl =0
					endif
					
					if GetRawKeyPressed(KEY_N)  
						SaveOptions()
						NewDoc(0)
						Ctrl =0			
					endif
					if GetRawKeyPressed(KEY_O)  
						SaveOptions()
						OpenDoc(0)
						Ctrl =0			
					endif
				endif
				Foldend
			
			else
				// ObjTyp$ = CheckKeyBoard()
				
				IF shift = 0 and alt = 0
					if GetRawKeyPressed(KEY_TAB) = 1 // tab						
						Options.HideLag = 1- Options.hideLag
						Lag_HideAll(Options.HideLag)
						SaveOptions()
					endif
				endif
				
			endif
		
		endif
		
		Foldend
	
	endif	

	
	
	FoldStart //************ Other events // "game" event or automatic even
		
		SetShaderConstantByName(ShaderBank[0].Shader,"cameraPosition",getcamerax(1),getcameraY(1),getcameraZ(1),0)
		SetShaderConstantByName(ShaderBank[0].Shader,"lightVector", Sun.x, Sun.Y, Sun.Z,0)
				
		EventBehavior()
		
		// Lightmap update
		if options.ShowLMRT = 1
			If Scale = 0 and rotate = 0
				SyncShadow()
			endif
		endif
		
		EventFX()
		
		if SelectionBorder = 1
			DrawBox(SelectStartX,SelectStartY,mx,my,255,255,255,255,0)
		endif

		IF Options.physicOn = 1
			Step3DPhysicsWorld()			
		endif
		
		// SetObjectLookat(oSun, sun.x, sun.y, sun.z,0)	
	  
	  
		if NbWater >-1 and Options.ShowWater=1
			SyncWater()		
		else		
			Sync()
		endif
		
	Foldend
	
	
loop



SaveOptions()



