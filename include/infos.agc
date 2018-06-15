

FoldStart //******* Infos, ventes, AGK feature request 


/* ****** INFOS

NAME : AGE 3D (Agk Game Editor)
DEV : Made by blendman 
DATE : 2014/09 (for the LAG library (Interface : menu, gadget, statusbar, toolbar, message, requester...), 2015/11 (first editor)  & 2016/06 (for AGE 3D)

Description : A 3D visual editor for AGK (with some gameplays assets to help to create game more easily in a version 1.1  :))


This Editor use :
- LAG : Library AGK GUI, made by blendman (10/2014)
- 3D level editor made by blendman (11/2015) 
- Animatoon (made by blendman, 08/2014), some part of the code are used (to paint on a texture/image, for texture or terrain)


Thanks : 
- MenuBox by Baxlash (for LAG)
- Water + water shader (reflection / refraction) By Janbo.
- 29games : selection border, help in the 3D view camera look at center
- MadBit : shader spec + normalmap

	
*/



/* ****** VENTES

AGE version basic : 15 €
- Objects + 3D models
- transformations : position, rot,scale, shaders, images
- terrain : just heightmap
- shader juste ouvrir et set
- water
- particles
- Atmosphere
- play level just preview
- créer, open levels 
- file save : save level as txt (simple, le même que le mimen, sans certaines infos (hide, locked...)
Non : 
- Behavior
- Terrain creation
- Shader création
- Animation gestion



AGE version Studio : 25 €
- idem que basic
- Terrain creation
- Behavior
- Play level avec action/event
- file save : only le level + un exemple d'ouverture


AGE version Pro : 100 €
- Idem que studio
- Shader creation
- Animation gestion
- Action/Event (player, keyboard, joystick...)
- file save : fichiers agc complet (donc, une partie des sources d'AGE ?)



*/



FoldStart //******* AGK FEATURES REQUEST FOR AGE 
 
/* ****** AGK FEATURES REQUEST FOR AGE 

3D
	ok ? - Shader specular
	ok - Shader normalmap
	ok - Shader rim light
	OK AR - dynamic soft shadow (shadow mapping) 
	- lightmapper : lightmap & shadow map (+ ambient ?)
	
	- reflection
	- refraction	
	- shader other than phong : velvet, fresnel
	- multi-textures / multi-shaders by object
	- more than 4 lights by objects : set the number of lights as an option (only 4 for the moment).
	
	- saveobject / savemesh : in b3D, obj, dae, x with animation name ! 
	
	- LoadObject with multi texture and assign texture
	- GetObjectScaleX/ScaleY/scaleZ
	ok ? - GetObjectWidth, GetObjectHeight, GetObjectLength
	- GetObjectPivotX / Y / Z
	- GetSunAngleX / Y/ Z
	
	
	
3D debug
	- see bounding box of object (physic, normal)
	- 3D line
	
Animation 3D
	- SetObjectAnimationName(obj,name$,start,end)
	
Windows : 
	- f9 to f12

*/

Foldend



Foldend




FoldStart //******* BUGS 


/* ****** BUGS

File
	- opendoc : if we have models opened, it bug with objects using the id of this objects
	(si on a déjà des modèles d'ouvert, ça merdouille avec les id des objets utilisant les ids de ces objets, notamment les shaders : il faut tout effacer (toutes les banques), même les models)
	- opendoc : bug sur fichier puf house4, sol image pas ok ?? car = 0 ?
	
Edition / transformations
	- copy/paste : pb de position in ortho view
	AR - bug avec scale object animated 
	
gametest
	AR - camera rotation free
 
 
In reflexion : 
 	?? - light (object) change plane to sphere

 
*/




/* **** OK : 
	
	ok 0.55 - move object in ortho dont work properly
	ok 0.54 - si key_enter : ça joue sur les trackbar
	ok 0.54 - if GetScreenBoundEditor -> mouse position (top or right or on statusbas) isn't correct
	ok 0.51.7 - bug move light
	ok 0.5x- with fullscreen, menuitem are move in y
	ok 0.46 - save fpe : image bug dans fichier ???
	ok 0.45 - bug sur opendoc avec ancien fichier (version < 0.44) :(
	ok 0.41.3 - after past, if move objects selected -> they return to their old place (of object cloned) ??
	ok 0.40.1- if open a window : bug with GUI !! ok !!!
	ok 0.22 - with multi select+clone , the object have all the same objTyp, even if we have selected differents objects
	ok (bug agk) - Camera in top : with ortho view, the objects disappear ? -> setObjectScreenCull = 0 -> ok
	ok 0.19 - opendoc : the object hasn't their image
	ok 0.19 - Lock doesn't work with Scale-object
	
	
*/



Foldend
 
 
 
 
FoldStart //******* TODOLIST 




/* ****** Priority


*** pour jeux
- 









***TODO
View
	- painting object object on level automatically
	- rot/scale by pivot (fixobjtoobj -> yes)
	- move an objet with group move the group
	ok 0.48 - move in y

Create
	ok 0.58.5 - asset : colision, physics body

toolbar 
	ok 0.58.5 - add pan, zoom, rotate view
	
GUI
	- object : layers
	- object : groupe 
	ok 0.56.3 - onglet selec : by obj, light, part, by group
	ok 0.48 - image : add preview image (all image) or listicon
	ok 0.48 - image : stringgadget : image name
	ok 0.51.6 - image = normal (buton normal) -> setObjectNormalmap()
	ok 0.51.6 - image = lightmap (buton lightmap) -> setObjectlightmap()
	ok 0.60 - object : type button (object, action, mob...)
	ok 0.61 - object : param1, 2
	ok AR 0.47 - object : bm
	ok AR crash ! - image : reload shader (delete it and reload it)

Save/Load	
	ok - export ajouter : object (lightmap, normal), image (wrap) 
	ec - save all texturestage (image/stage, bm)
	ok 0.48 - autosave
	ok 0.54.7 - save camera prop (position/rot, fov...)
	ok 0.54.8 - load camera prop (position/rot, fov...)
	
	
Object
	- lock size by object 
	ok 0.47 - lock move by object
	ok 0.47 - lock rot by object 
	ok 0.56.5- set image on mesh
	ok 0.56.5- set normalmap on mesh
	ok 0.56.5- set lightmap on mesh



	
*** OK :
	ok 0.45 - import model 3D (x, dae...)
	ok 0.44 - asset : w,h,l -> chge fonction du typ & asset (obj,box,plane..)
	ok 0.44 - image : reload texture
	ok 0.42.6 - edit modify : snap, physics
	ok 0.42.4 - edit modify : cast, receive


*** bug :
	ok ? - grid size bug


*/





/* ****** TODOLIST (BY version )
Version 0.1 (UI) (10/06/2016)
	ok : 06/06
ok - Menu
ok - UI : panel left : properties
ok - Ui : panel right : options, FX
ok - statusbar
ok - toolbar + buttons : new,open,save / asset type / action
ok - Add light
ok - Add object : box,plane,sphere,cone,capsule,cylinder

Version 0.2 (object) (20/06/2016)
	ok : 11/06
ok - add object bank
ok - add img bank
ok - action : move
ok - action : rotate
ok - action : Scale
ok - action : delete
ok - Get/Set prop to asset : X,Y,Z,rot(general),size(general)
ok - Light : Get/Set R,G,B,range

Version 0.3 (images) (30/06/2016)
	ok 23/06/2016
ok - change image at creation (for object <> bank-obj3D)
ok - Object : change image 
ok - set image creation
ok - change chanel image 
ok - save document 
ok - load document 

Non, uniquement dans la version "pro" : - export to AGK level (*.agc project ?)


Version 0.4 (Atmospheric) (10/07/2016)

ok 0.10 - Fog : active
ok 0.13 - fog color,range
ok 0.13 - Sun : color
ok 0.13 - sun direction
ok 0.12 - Skybox : active,colorH,color,
ok 0.13 - set Ambient color
ok 0.17 - Atmosphere : save/load
ok - amosphere : save/load interface
- skybox : suncolor,sunsize,halosize,sunvisible

Non, ou plus tard, mais je n'en vois pas trop l'intérêt : 
? - skybox : save,load
? - sun : save,load
? - fog : save,load
? - ambient : save,load



Version 0.5 (Shader) (20/07/2016)
ok 0.15 - copy/paste
ok 0.15 - clone
ok 0.14 - set shader
? - Shader maker : modify a shader (add spec, normal, diffuse, reflec...)


Version 0.6 (Terrain, water) (30/07/2016)
ok 0.17 - Terrain : create with heightmap
ok 0.17 - Terrain : set texture ?
ok 0.14 - water + shader reflection/refraction (janbo)
ok 0.19.11 - tooltips
ok 0.30 - Terrain : shader multi-texture (4) en fonction du relief
? - Terrain : paint on texture (stencil) ?
???? 
? - Terrain : paint on terrain, modify terrain (elevation + 1)
? - Terrain : paint on terrain, modify terrain (elevation - 1)
? - Terrain : paint on terrain, modify terrain (elevation rise (engros, on met à zero))


Version 0.7 (physic) (10/08/2016)
ok 0.31 - set object physic : nothing, static, dynamic, kinematic 
ok 0.31 - createphysicworld, stepphysic
ok 0.35 - set object character
- set shape, mass, friction
- set gravity

Version 0.8 (FX) (20/08/2016)
ok 0.32 - Particles : create
ok 0.32 - Particles : change color
ok 0.32 - Particles : change size
ok 0.32 - Particles : change speed
ok 0.32 - Particles : change range
ok 0.32 - Particles : move
ok 0.32 - Particles : delete
ok 0.33 - Particles : change  image
ok 0.34 - Particles : savedoc
ok 0.34 - Particles : loaddoc
ok 0.34 - Particles : savepreset
ok 0.34 - Particles : loadpreset
ok 0.34.2 - Particles : change number of particles
- Particles : modify typ


Version 0.9 (gameplay asset) (30/08/2016)
ok 0.35 - behavior : player keyboard
ok 0.35 - behavior : player joystick
- behavior : player mouse
ok with physic - Action : collision
- gameplay asset : start level
- gameplay asset : change level (teleporter)
- gameplay asset : drop collect
- gameplay asset : treasure

Version 1.0 (?) (30/09/2016)
?
- NPC IA : quest
- NPC IA : enemy
- NPC IA : infos
- NPC IA : friends

Version 1.1 (lightmap/shadowmap) (30/10/2016)
ok 0.24 - shadowmap
ok 0.24 - shadowmap : save image
ok 0.32 - shadow size, range, height
ok 0.30 - lightmap-RT on objects that has lightmap shadow set to on
- lightmap - precalc on objects that has lightmap shadow set to on
- Shadowmapping : Shadowmap not only in top view 
- Real Shadow



Objects :
ok - add box
ok - add plane
ok - add sphere
ok - add capsule
ok - add Cone
ok - add cylinder
ok 0.16 - add 3D object from bank


Bank
ok 0.20 - see folders
ok 0.20 - clic on folder : refresh the model list
ok 0.20 AR - ListIcon or Treegadget (for name of entity)
ok 0.30 - Reset bank (new)
ok 0.30 - save bank (preset)
ok 0.30 - load bank (preset)
ok - Addmodel to bank
ok 0.30 - delete model from bank

ok - multiUV
ok 0.30 - multitexture (shaders)
- paint on texture (for terrain, ground) (see animatoon made in agk)


Shaders :
ok - Diffuse
ok - normal map
- spec map
ok - reflection (env map)
- reflection (miror)
- refraction


Model import : 
ok 0.31	- on ne peut pas importer plusieurs entity utilisant le même modèle mais des textures différentes

*/





/* ****** TODOLIST (GENERAL)


** Improvements
	- add some 3D utilities (arrow) to move,rotate,scale object
	ok - better 3D view rotation
	ok 0.31 - border selection

General 
	ok 0.15 - copy/paste/clone
	- Duplicate object ( = properties are the same, when changing an object, it change all the other duplicate object)
	- Undo/Redo system
	ok AR - multi-selection + G
	ok - multi-selection + R
	ok - multi-selection + S

	ok - Terrain : add a loading / "please wait..." message 
	- Select by name : add the list of object
	pk - Select shader by name : add the list of shader we can set on our object
	- hierarchy view (like in blender)

Object
	- avoir en options : size
	- box, plan : w,h,l
	- sphere : nombre de line, nombre de rayon
	- Ctrl+R : rotation +90
	- ctrl+up/down : size +1/-1
	- ctrl+left/down : rot local +1/-1


Presets :
	ok - bank model presets
	- bank shader presets
	- bank image presets
	ok - atmospher presets (skybox,sun, ambient, fog)
	? - lighting presets
	- gameplay/assets (start, zone, end level...)
	- scripts presets
	ok AR - behavior preset
	- terrain presets
	- water presets
	- particle presets
	? - FX presets

Editor /window :
	ok ar - Shader + texture
	- terrain / ground
	- paint (terrain, ground)
	- water
	ok in panel "tool" - lightmap
	ok ar - behavior
	ok in panel "sky" - atmosphere



Bank model :
	ok 0.20 - see the list of folders
	ok 0.20 - when clic on a folder, the list of models (fpe) in this folder is updated
	ok 0.36 - see the image of models
	- select several models / all models
	

LAG (Lib Agk Gui) : 
	ok 0.21 - Hide/Show LAG
	ok 0.17 - Lag_InputRequester()
	ok 0.16 - ListIconGadget
	ok 0.15 - SaveFileRequester()
	ok 0.13 - OpenFileRequester()
	ok 0.32 - revoir freegadget : supprimer les gadgetitems	
	- Tree Gadget
	ok - Editor Gadget
	- Combobox gadget 
	ok - Frame gadget 
	ok 0.27 - Menu : when exit the surface of a menu & clic , the menu close automatically
	ok 0.27 - Menu : MenuBar()
	ok 0.27 - Menu : border
	ok 0.27 - Menu : shadows
	- Menu : icon...
	- Menu : submenu (+opensubmenu/closesubmenu...)
	
	
*/






Foldend




FoldStart //******* CHANGES



/* 2018 (1/45/76) (nb day by month/total year/total)



todo : 
	- Image panel : btn Add image (in textures used list)
	- Image panel : btn remove image (from textures used list)
	- copy/paste : coller en fonction de l'angle de camera ou de la vue
		
	- window : copy properties from 1 object
	- set param window : add fog, lightmode, visible
	
	- add shortcut when action : X (only x Axis), Y (only y Axis), Z (only Z Axis)
	
	
	
	

L [9/04/2018] (0.64.2) (3/47/77) (8h20-10h) puis travail sur puf
// Fixes
	- bug avec le size x/y/z si float
	- copy/paste : ne colle pas le Y de l'objet precedent !

* puf : voir log




D [8/04/2018] (0.64.1) (2/46/77)
// Fixes
	- with multi select (import model), cant open a file (*.age)
	
	

V [6/04/2018] (0.64) (1/45/76)
// New
	- LAG_OpenFile() : multi-selection -> we can open multi-objects now !
	- LAG_OpenFile() : Ctrl+A : select all file (and open it if clic on btn ok)
	- LAG_OpenFile() : Ctrl+D : deselect all file
// Changes
	- LAG_OpenFile(() et LAG_SaveFile() ajout GetScreenBoundEditor()
	- lag_openfile() : add ascencer + 2 btn for folder 
	- utile : GetFilePart(file$)	, getpartpath... utile / et \ au cas où.
	AR - some changes in lag_openfile() to add a viewer for 3D object model (when import a 3D model).
// fixes
	- if create bankmodel, then clic panel prop (empty) -> object get empty propertie (size =0, pos = 0....)




V [24/03/2018] (0.63.1) (19/44/76)
// New
	- Exportlevel : if option useAge3Dtyp<> 1 -> not "object" but "typ_subtyp"



V [23/03/2018] (0.63) (18/43/75)
// New
	- list stage : clic on stage : select the stage and update info about stage texture
	- list stage : update list stage (img + name)
	- list stage : free list stage if no object selected
	- save : visible, lightmode, fogmode, anim (speed, fr_start, fr_end), restitution, damping,
	- load : visible, lightmode, fogmode, anim (speed, fr_start, fr_end), restitution, damping,
	- Export : visible, lightmode, fogmode, anim (speed, fr_start, fr_end), restitution, damping,
// Fixes
	- when create a primitive object : textureID wasn't correct in Object[ObjId].Stage[0].TextureId)
	- When unselect object, some gadget weren't reseted (visible, lightmode, type/subtype, param1, param2)
	- create object, change texture, copy/paste : keep old texture
	- copy/paste : when multi-texture -> not viewed on the copied object (but are on each stage, miss just an update)
	- if create object (primitive) -> save : no texture (or texture 0)
	- if copy object -> save : no texture (ou texture 0)
	- copy/paste : ne copie pas les dimensions, prend en compte les anciennes de l'objet créé avec A
	- bug copy/paste : bug size (w,h,l)
	- bug copy/paste position
	- bug select position
	- bug create, copy/paste, rotation, select et move -> position 0
	- bug pan view mouse : inversed after viewtop / view persp
Lag
	- Lag_ResetPanelGadget()



J [22/03/2018] (0.62) (17/42/74)
// New
	ec - ajout list stage
	- save : object type, sub-type, param1 & 2
	- export : object type, sub-type, param1 & 2
	- load : object type, sub-type, param1 & 2
	- set/get objectprop : param 1, 2
// Changes
	- Panel image : position img preview, <, folder, >
	- Panel Create : add name  : asset select, model select
	- Panel image : add name : folder, img preview, obj texture
	- Add some tooltips missing for gadgets
//fixes
	- gadget anim not update if select obj
Lag
	- LAG_FrameGadget(id,x,y,w,h,txt$,option)



Me [21/03/2018] (0.61) (16/41/73)
// New
	- properties : add gadget param1,param2 (for type)
	- 3 cartoon shaders (multiply, add, mix)
	ec - save\load : object type, sub-type, param1, para2
// Changes
	- lag_openfil : ajout d'un dossier "." (pour revenir au folder ar default)
	- savedoc : text in white
	- comment some print()
	- at start, sort texture folder by name
	- saveDoc() : ReplaceAllString(txt$)
	- WriteAtmospheric() : ReplaceAllString(txt$)
	- ExportLevel() : ReplaceAllString(txt$)
// Fixes
	- Object kept the full path of file
	- when close a windows -> some gadget won't work properly. I Setgadgetstate(C_Gad_PanelL,0) the UI to fixe it.
	- openbank(), opendoc(), importmodel() : if file = ""  we have an error message (file "" doesn't exist), event if we cancel
	- LoadAtmosphere() : idem
	- opendoc() : don't update world
	- at creation, object has image= 0 to all stage by default (should be -1)
	- when importmodel, all image stages = 0, should be=-1
	- when importmodel,idem textureId
	- when opendoc() : empty stage should be =-1 if in file its =-1



M [20/03/2018] (0.60) (15/40/72)
// New
	- 3D : alienator : lightmap & export : good !
	- Prop: visible, lightmmode
	- options (save\load) : physics scale & gravity (x,y,z)
	- shader terrain0 (ground + road + alphamask)
	- Image panel : Show imagebank / images used
	- properties : add gadget Type, sub-type
	- Open file to set the type for object and subtype (we can custom it) 
	AR - Image panel : btn Add image (in textures used list)
	AR - Image panel : btn remove image (from textures used list)
// Changes
	- Prop : Checkbox -> buton image (lock, hide)
	- Prop : some properties wasn't updated when select an object
	- image panel : btn shader reload deleted because it crash the program a lot of time (bug agk ?)
// Fixes	
	- setimage : didn't add the image to texture used
	- fixe a bug when hide some gadgets (panel prop)
	- prop : btn set object type doesn't work
	- prop : hide btn doesn't work
	- bug et plantage si on change le folder image (visiblement, on perd les textures


L [19/03/2018] (0.59) (14/39/71)
// new
	- select : add outline to object & bounding box
	- When clic on btn asset prop -> OpenWindowAssetCreate() (change colision, physicbody)
	- add buton for view (pan, rot, zoom)
	- properties : add gadget type
// Changes
	- when set image or shader -> object color emissive =0 to see the change
	- If object not animated : gadget anim hiden
	- SaveOptions() when change : asset creation, options, world
// Fixes
	- View top was view bottom
	- when use lock scale, scale was only integer (not float)
	- gadget sx/sy/sz ne prend pas les float en compte
	- scale + lock : snap automatic !!


D [18/03/2018] (0.58) (13/38/70) (10h)
// New
	- add dim ImgFolder$[] to stock the name of the folder in "media\texture\"
	- Clic on < and > folder change name of folder
	- Clic on < and > folder : update the list of images in the listicon gadget
	- Clic on item list image : update image preview
	- Create : add colision, physicsbody for new asset
	- image folder : add tooltips
	- new buton creation asset (prop)
// Changes
	- change when select an object if btn select is on mesh -> show mesh
	- lots of changes in texture assigned to object (with new system (folder image)
	- Shaderlist : open now a windows to selected the shader in a listicon (list of shader, description text)
LAG
	- LAg_Message() : add GetScreenBoundEditor()
	


S [17/03/2018] (0.57.6) (12/37/69) (10h30)
// new
	- add shader matcap
	- add gadgetfolder texture
	- add gadget < & > to change current folder texture
// Changes
	- Change bank texture, add image list for temporary preview image.
	- add AddTextureToList(file$, used, wrap) to add texture to the list of preview image
	- only reset texture bank if needed
Lag
	- change listicon slider speed
	
	
	

V [16/03/2018] (0.57) (11/36/68) (8h-11h30 (testFog), 11h30 -13h30 & 16h-17h30 avec pause de 10 minutes/h)
// new	
	- add windows physics (work with multi select) : physics body, colision
	- change physics: if clic on btn : reset physics world, and recreate all physics
	- save\load\export : object (collision)
	- add sun object
	- add meshId : when select a model with several mesh, you can set image on each mesh.
	- camera: can be selected from select list
	wip - set normalmap on mesh (not saved for the moment !) 
	wip - set lightmap on mesh (not saved for the moment !) 
// Changes
	ec - Change bank texture, add image list for temporary preview image.
// test
	- fogtest : test camera and objectsphereslide()
	- test shaders
	
	

J [15/03/2018] (0.56.3) (10/35/67) (10h40 -12h30 avec pause de 10 minutes/h)
// test
	- fogTest : test de shader sur platform, test shader sur jim
	- test camera side
	- test shader (matcap)


M [13/03/2018] (0.56.3) (10/35/67) (10h40 -12h30 avec pause de 10 minutes/h)
// New
	- object : add transparency
// Changes
	- checkbox lock -> btnimage lock
// fixes
	- some gadgets (propertie) doesn't be reseted when deselect object


L [12/03/2018] (0.56) (9/34/66) (8h -12h30 avec pause de 10 minutes/h)
// New
	- 3D : add model3d camera
	- camera : add a camera, with propertie(pos,rot,fov,range)
	- camera : select/deselect
	- camera : getObjcameraProp()
	- camera : SetObjcameraProp() (pos, rot, range, fov, orthow, name, lock(pos,rot))
	- camera : delete
	- camera : C key to create the camera at mouse(x/0/Z)
	- new buton panel select : asset type to select (obj, light, camera, fx, mesh)
	- add possibility to get the mesh & nummesh from an object (in select panel)
	- when select an obj -> panel select show its mesh
// Changes
	- numerous changes in selection, getassetprop... for the new camera asset.
	- panel select : show only in the list asset of current assetTyp (object, light, camera)
	- when create new asset : clear gadgetitem panel select, addicon to gadgetitem (panel select)
// Fixes
	- light properties : don't update name, lock pos
	- light properties : should show shadow (lm, cast, receive)
	- when create light, prop wasn't updated
	- when create light, other objid wans't unselected
	- when create light, light isn't in red
	- when create light, light is black
	- when create light, light isn't added to panel select
	- panel select : light cant be selected
	- fix a bug when moving, rotate or scale (G, R,S) and no asset in the level
LAG 
	- LAG_GetGadgetItemAttribute(GadgetId, pos)
	- LAG_SetGadgetItemAttribute(GadgetId, pos, attribute)
	- LAG_GetGadgetItemPosition(GadgetId, name$) -> just after creation (name$ ="") or with its name, to know its position
	
	
	

V [9/03/2018] (0.55) (8/33/65)
// New
	- save camera prop (position/rot, fov, range, ortho...)
	- Load camera prop (position/rot, fov, range, ortho...)
// Changes
	- a lot of changes in camera and option.camera to save it and load it
	- name for texture doesn't use the path no more, only the filename
// Fixes
	- Debug info text position and maxwidth if change window size 
Lag
	- change speed listicon move Y : incremented
	
	


J [8/03/2018] (0.54.4) (7/32/64)
// Changes
	- when change view, grid is rotated (right, front)
	AR bug ec - listicon : smal icon in square mode
// Fixes
	- move object in ortho dont work properly (view top, right, front)
	- bug when clic in "select list" with 0 object 





Me [7/03/2018] (0.54) (6/32/63)
// Changes
	- Options.Asset.W, H et L : can be float. min = 0.1
// Fixes
	- general asset propertie : change W, H or L isn't updated 
	- GUI-resize : if change window size : gadget Left doesn't work properly
	- GUI-resize : if change window size : gadget right doesn't work properly
	- GUI-resize : if change window size : tool bar  doesn't work properly
	- GUI-resize : some tooltips didn't work 
	- move mouse inversed in view top (key_7)
	- pickobject in ortho view
	AR - top view : move object only in X & Z
Lag
	- si key_enter : ça modifiait les trackbar



M [6/03/2018] (0.53.8)(5/31/62)
	- Change on AGE3D example
	
	
	
L [5/03/2018] (0.53.8) (5/31/62)
// Changes
	- export level : image (wrap)
	- export level : object (lightmap, normalmap, isplayer)
	- SaveDoc : object (isplayer)
	- OpenDoc : object (isplayer, normalmap, lightmap, fogmode)
	- OpenDoc : object (isplayer, normalmap, lightmap, fogmode)
// fix
	- OpenDoc: I update only the shadow propertie if Shado.width >=16 and Shado.height >=16
	- saveDoc as : bug 
	- view Right :camera now move in X & Y correctly
	- view Front :camera now move in X & Y correctly
	ec - move mouse inversed in view top (key_7)
	ec - pickobject in ortho view
	

D [4/03/2018] (0.53) (4/30/61)
// Change
	- example of use (basic game example) : add player, camera fixe to player...


S [3/03/2018] (0.52.7) (3/29/60)
// Change
	- example of use (basic game example) : several changes in loadlevel()

V [2/03/2018] (0.52.6) (2/28/59)
// Change
	- example of use (basic game example) : several changes in loadlevel()


j [1/03/2018] (0.52.5) (1/27/58)
// new
	- now, gadgets "propertie" change by assetTyp (object & light only)
	AR - export level -> path texture/model... AR
	ec - example of use (basic game example)
// fixes	
	- view Top :camera now move in X & Y correctly
	- view Right :camera now move in X & Y correctly
	- view Front :camera now move in X & Y correctly
	

Me [28/02/2018] (0.52) (25/26/57)
// New
	- add checkbox normalmap image for object / set or unset the normalmap on object
	- add checkbox lightmap image for object / set or unset the lightmap on object
	- add checkbox to ambient (to activate it or not)
	- add gadget : delete image from stage
	- add some properties to light (lock, parentid, group, layer)
	- remove gadget : image name (id in fact)
	- remove gadget container on right panel
	- remove gadget day/night cycle (need to fixe the container set size & position (element & container) if panel size change)
	- add fogmode for objects + gadgets
// Changes
	- object use lightMode = 1 now by default
	- some changes in UI atmospheric
	- some changes in atmospheric.agc to use the new ambient checkbox
// fixes
	- bug when move light 
	- fix statusbar width when change width of window
Lag
	- fix : if window size change, menu selector, and all menuitem elements sprite/text were bugged 





M [27/02/2018] (0.51.2) (24/25/56)
// new
	- add lightmap to fpe
	- add lightmap to object
// Fixe
	- refmap shader ok with lighting (rimlight)
// test 
	- baking multi object in blender



L [26/02/2018] (0.51.1) (24/25/56)
// New
	AR - add GetScreenBoundEditor




D [25/02/2018] (0.51) (23/24/55)
// New
	- add normalmap texture for model bank
	- add lightmap texture for model bank not used)
	- add normalmap for model imported from bank
// Changes
	- autosave is now saved in "autosave" folder (media\scenes\autosave\)
// Fixes
	ec - ortho mode : arrow doesn't work properly
	- opendoc : shader wasn't set on object with shader
	
	

S [24/02/2018] (0.50.5) (22/23/54)
// Changes
	- some changes with object animated (use instance instead clone, scale -> scalepermanent...)
//fixes
	- object animated should be scale with scale permanent
	- view to select  center the camera on the selcube, not the selected
	- bug when reload texture not exist
	- Crash when reload texture if used ??
	
	
	

V [23/02/2018] (0.50.2) (21/22/53)
// New
	- test new model (bool, hachman -> bug anim)

* Other
// test
	- TPS example (add enemy, enemy bullet...)
	

J [22/02/2018] (0.50.2) (20/21/52)
// New
	- image : add button image to bank
// Changes
	- lightmap : test for camera rotation for shadow not only in topview (doesn't work for the moment : need to add camera position)
// fixes
	- export as fpe : when object has no shader -> crash


Me[21/02/2018] (0.50.1) (19/20/51)
// Test
	- lost  of tests for camera in gamemode : not working as I want :(
	
	
	

M [20/02/2018] (0.50) (18/19/50)
// New
	- constant : orientation, pivot transformation
	- When transformation : use pivot (origin, bbox, active)
// Changes
	- Key_TAb : is now only used in editor mode
	- Clean up the code (a few) :)
// Fixes	
	
	
	

L [19/02/2018] (0.49) (17/18/49)
// New
	- add "activegadget", to keep the focus on editbox when = activegadget
// Changes
	- at start, I loaded 3 times the texturebank (?)
	- LAg : add active_gadget, to know, what is the active gadget, if it's an editbox, and so know what to do if editbox change
// Fixes
	- ambient light wasn't updated if we change it and not on the gadget
	- Key_H : all object/light were hiden, even if not selected
	- Key_F : all object/light were Frozen, even if not selected
	- fix shader refmap (rimlight didn't use the lighting)
	- load model (not fpe) : bug si loadobjectwithchildren (inverted normal, not good rotation)
	- opendoc : bug avec model
	- opendoc : bug avec texture
	- opendoc : bug avec shader
	- Resetdoc : list img not reset
	- Resetdoc : select list not reset
	- opendoc : bug with old file (<version 0.44) : model should use fpe, not model format (.x, .dae...) and shader/image of fpe.
	- opendoc : not good name on list selected, with model
	ec - opendoc : bug with old file (<version 0.44) : for some objects, image wasn't set correctly
* LAG
	- add : Lag_GetGadgetType(id)



L [19/02/2018] (0.48) (16/17/48)
// New
	- image : add preview image (all image) or listicon -> clic to change textureID
	- image : stringgadget : image name -> get name of texture selected
	- fpe import : add model (sphere, box..) and w/h/l
	- fpe export : add model (sphere, box, plane, capsule...), add dimension (w, h, l) for object not model
// Changes
	- Improvment of the "select and move" system
	- changes : option save\load asset W,H,L
// Fixes
	- when copy/paste some object, the position wasn't save each time
	- Fix some bug with copy/paste then move object (selection)
	- when openmodel or file, the texture wasn't add to the list
	


D [18/02/2018] (0.47.5) (15/16/47)
// Changes
	- Change the select and move system, to get the Y position


S [17/02/2018] (0.47.3) (14/15/46)
// New
	- autosave
// Fixes
	ec - select in ortho mode doesn't work
	ec - grid (add axis x/y) test for a grid shader, doesn't work.
	- grid size bug


V [16/02/2018] (0.47) (13/14/45)
// New
	- profil object (for objtyp box, sphere...) to save later their properties
	- object : add lock move x/y/z by object (get/set)
	- object : add lock Rot x/y/z by object (get/set)
	AR - object : Set/Get bm (blendmode) : normal, additive
// Changes
	- Level tool (lightmapper, misc) : add name + some change in UI
// Fixes
	- Some fix in ExportModel (fpe) : now it's ok !
	- save fpe : image bug 
	- save fpe : no extenstion
	- importModel : we can now import a *.fpe using the same 3D model

*Lag
	- add name (text) to container if needed




J [15/02/2018] (0.46) (12/13/44)
// New
	- camera : gadget Get/Set position & rotation
// Changes
	- camera : no more info in statusbar (pos/rot)
	- camera : some changes in pan (move) view (with view top, right, front (key numpad 7,3,1))
	- camera : in ortho mode, camera can be rotated
	- lightmap : test to get the shadow in realtime
	- import model : all uv channels (w,h) for model are = 1 now by default
// Fixes
	- shader refmap3 : doesn't use the lighting as it should
	- fix a bug with add object and general size (was double in object dimension and scale)
	- when select object : textureId isn't updated
	- when delete object : gadget was not reset , and objid =-1
	- import model : image in bank wasn't correct
	- Importmodel : texture not ok
	- select obj (model from bank) -> image not ok in stage
	
	


Me [14/02/2018] (0.45) (11/12/43)
// New
	- object animation : play/stop, speed, frame start/end
	- importmodel : import not only .fpe, but all the format agk can import
	- importmodel : use image preview same name as file if exists
	- importmodel : a lot of changes to work
	- importmodel : add all format supported by agk
	- importmodel : import the texture if it has the same name as the model
	- export as fpe
// Fixes
	- bug sur opendoc avec ancien fichier (en fait, ça ne marchait pas)
	- Object propertie : play CheckBox doesn't work

* LAG
	- LAG_OpenFile() : add the extension functions
	- LAG_OpenFile() : can select/change extension 
	- LAG_OpenFile() : can use several extension
	- LAG_OpenFile() : use this extension to show the files with that extension
	- LAG_OpenFile() : ok for .x, .obj, .dae 
	- LAG_OpenFile() : preview is fine for some object :)


M [13/02/2018] (0.44.1) (10/11/43) 
// Fixes
	- fix some bug in opendoc\savedoc
	
* WR_calculateur	
	
	

L [12/02/2018] (0.44) (9/10/42) 
// New
	- doc load : add gen (date, editorversion), game (version, name)
	- doc (save) : add gen (date), game (version, name)
	- doc (save\load) : new save\load for image stage (image, uv...)
	- doc (save\load) : now, it save all stage chanel + image + uv
	- doc (save\load) : add "shaderlib" in doc
// Changes
	- object image : add object.stage[7] with uv scale/offset, imageId, textureID
	- numerous changes with new system of texture stage by object (reset doc, create object...)
// Fixes
	- when copy/paste object, all textures and shaders weren't ok
	- fix a bug in terrain with new image system
	- when open a doc, the items of the select list hasn't the name of object
	- when select object by panel select : objprop not updated
	- when select object : img preview not updated after loaddoc()
	
	


D [11/02/2018] (0.43.5) (8/9/41) 
// New
	ec - object prop : groupe, layer, lock move/rot/scale, type, param1,2, blendmode (transparency)
	- SetMesh : change an entity mesh by another (box, plane, sphere, model...)
	- Object parameter at creation (W, H, L) : change by object type (box, sphere...)
	- Object parameter at creation (W, H, L) : now we can set the parameter before creation fo some object , like box, sphere, cylinder...
	- reload the shaders : reload all the shader, if We have make some change to test
	- reload the shaders : set the new shader to all objects
// Changes

// Fixes





S [10/02/2018] (0.43) (7/8/40) 
// New
	- new shaders : metal, metal2, refmap2, refmap3, metalAorim, 
// Changes
	- pan view -> return to previous (better)
// Fixes
	- Ctrl+H : don't unhide the lights
	- Ctrl+F : dont' unlock the lights
	
	

V [9/02/2018] (0.42.6) (6/7/39) 
// new
	- edit / modify objects : cast, receive
	- edit / modify objects : physics shape
	- edit / modify objects : snap
// fixes
	- snap parameters (x,y,z) only change if check again the snap ckeckbox.
	- after past, if move objects selected -> they return to their old place (of object cloned) ??
	- image for tool was black
	- after create, if select  then move object -> they return to their old place (of object cloned) ??
	- fix some bug with gadget in window change prop (edit)
	- when start snapx/y/z were = 0 and if use edit/change param -> use snap -> bug
	

J [8/02/2018] (0.42) (5/6/38) 
// New
	- addgadget list for selection
	- add object -> add to the select list
	- delete obj -> delete item from selectlist
	- selectlist : clic on item select object
// Changes
	- cible look at camera
	- better camera PAN & Rotation & Zoom (thanks to 29games)
	ec - GUI : when select light or particle, image change on asset image
	- GUI : improvement gui shadow
// fixes
	- if create obj, we see center even if showcenter = 0
	- ctrl+H : unhide center even if not showcenter
	


[7/02/2018] (0.41) (4/5/37) 
// New
	AR - GameTest : camera rotation free (Xbox joystick)
	- UI : add general size buton for new asset
	- option(load\save) : add size for new asset
	- UI : add Img Id editbox for object
// Changes
	- Test game : camera not good position/rotation (platform mode)
	- GUI : some modifications & improvements
	- GUI : change physic-gadget : string to button
// fixes
	- if open a window : bug with GUI
	- when exit game, centers of objects aren't updated
	- when open a doc, light Y wasn't used
	- some fixes, when opening a doc
	- when create object from bank, the scale was correct (if use asset size)



[6/02/2018] (0.40) (3/4/36) 
// New
	- select border : clic to select an asset works now
	- sky & Atmosphere : add gadget shadow (shadow, bias, smooth, size W/H)
	- shadow (shadow, bias, smooth, size W/H) load & save in atmosphere file
	- P : play the level
	- Ctrl+P to selected : object is player.
// Changes
	- setobjprop : don't change color of selected object if not change color/tra. If change colors, add red color to emissive if selected.
	- init : resetoption, camera near/far loaded from option file.
	- init : snap param weren't defined by option file
	- if select : check if objTyp is object or light to show properties
// fixes
	- paste : object was not created at mouse
	- paste : change to work with multi selection
	- image preview: if =0, no change in preview
	- fix a bug when copy/paste several assets
	- when clic object : receive shado not updated
	- when loadmap : shadow not used on object
	- Ctrl+C /Ctrl+V : don't paste the object at mouse coord
	- open bank : don't see the image of object
	ec - after past, if move objects selected -> they return to their old place (of object cloned) ??




[5/02/2018] (0.39) (2/3/35) 
// New
	- Shift + P : reset position (0, 0, 0)
	- move with snap (object + light)
	- Ctrl + A : select all object + light visible
	- Ctrl + D : deselect all object + light visible (+menuitem)
	- H : hide selected light too
// Changes
	- Pickobject /light : changed (no more use the grid to raycast)
	- mouse coordinate : change the system, use the system by Galelorn, thanks a lot ! much better
	- object : add ImgID[7] to know the image used by stage
	- object : UV add 7 UV chanel to object.
// Fixes
	- fixe some checkbox name and space (UI)
	- Lightmap : render only object with "shadow" checked
	- when change stage image, uv wasn't correct
	- wheel mouse mode ortho not zoom /unzoom 
	AR - grid not good size
	- light was created only in 0/50/0, now it's with mouse coordinates
	- Move light with shift : all lights were on the same position 


[4/02/2018] (0.38.3) (1/2/34) 
// Fixes
	- ligthmap ne marchait plus



[5/01/2018] (0.38.2) (1/1/33) (10h-12h)
// New
	- New icones (from age2D)
// Fixes
	- some icones are missing (file, slider...)
	- In screengame, if no object : can use esc or other keyboard.
	- bug preview model image (when import a new model)

*/



/* 2017 (1/32)

[11/01/2017] (0.38.1) (32) (9h-10h)
// Fixes
	- centers objects not update when move the view
	- save/load : showcenter

*/



/* 2016 (30/31)

[12/07/2016] (0.38) (31) (9h-17h)
// New
	- when fullscreen, the menu and toolbar are moved to top
// Changes
	- when fullscreen, if play, the window isn't resized
* LaGui 0.57
// New
	- LAG_setmenuposition(id,x,y)
	- Lag_GetgadgetX(), LAG_GetgadgetY()
// Changes
	- Lag_SetGadgetSize(id,x,y,w,h,textsize) : works now
	- menu select is now at menu.y (was  at 0)
	

[06/07/2016] (0.37) (30) (11h-17h)
// New
	- Options : load/save some player parmeters (life,damage, speed)
	- Physic : add character physic for model
	- behavior : add joystick controler for player
	- add player.agc
// fixes
	- when delete an animated object, children weren't deleted
	- fixe a little bug with Lag_openfile (no miniature)
	

[05/07/2016] (0.36.5) (29) (11h-17h)
// Changes
	- import model is now 800*500 window
* LaGui 0.56
// New
	- Lag_OpenFile window : add button to change preview : list 64*64,32*32,16*16 or image array
	- Lag_OpenFile window : add preview image for file (options)
// Fixes
	- fixe some bugs with Lag_OpenFile window (if width <>600 and height <> 400)
// changes
	- better slider system for Lag_OpenFile window
	- better Lag_OpenFile window


[04/07/2016] (0.36) (28) (11h-17h)
// New
	- in game : I check if the object are < distante to the player, if not visible =0
	- behavior : now, the behaviors are set on the object (object.behavior[0]), and I create the behavior when launch the game (action=play)
	- options (save/load) : show center, gameMode
	- view : show center
	- add a bg and the logo "AGE"




[03/07/2016] (0.35.5) (27) (11h-17h)
// New
	- options: add CameraOrthoWidth, if fov=0 -> ortho =1
	- NewBankPreset() : reset model, resetTexture & resetShader
// Changes
	- key 3,1 : some changes to be ok with right and front view (camera was rotated)
	- key 5,7,3,1 : updateallcenter()
	- key 5,7,3,1 : if ortho -> fov = 0, else fov = oldfov
	- in view top,right,front : wheel now zoom the view
	- center is hidden when object hidden
	- in play mode : unhide only the LaGui if action <> C_actionPlay (we can test a level and change level)
// Fixes
	- newdoc : ajout de NewBankPreset() (reset les modeles et texture utilisées, sauf si merge)
	- newdoc : it miss DeleteAllBehavior()
	
	

[02/07/2016] (0.35) (26) (11h-17h)
// New
	- Game mode : we can choose in 5 modes for the game test : plateformer (camera follow the player and rotate with him), isometric (camera follow the player), 3d person, RTS (not active), Fps (not active), fixe (camera is fixed and look at player)
	- play : with arrow and behavior player keboard, we can move the player to test the level
	- play : we can change the camera position with F1
	- Behavior : add player keyboard behavior
	not used for the moment - options : DistanceLod : the minimum distance for the LOD, if exists by object
	- options : DistancePartToCam : the minimum distance to see the particle fx
	not used for the moment - options : DistanceCulling : the minimum dsitance to see the object 
	- options : export index : to save the file with the words we choose
	- add physic step to play mode
	- add particle to play mode
	- Change particles number
// Changes
	- When play mode : the editor utilities are hidden(center, objects selected in red, grid, cibleEd...)
// Fixes
	- The center of particle system wasn't updated if the object cube (boudingbox of part system) was hidden
	- fixe a bug with saveas (if ctrl wasn't pressed, it was freeze)
	- fixe a bug when newdoc : nbwater was always = 0 (need to be resetted to -1)
	
	
[01/07/2016] (0.34) (25) (11h-17h)
// New
	- new button : load / save particle preset
	- Load Particle system preset
	- Save Particle system preset
	- Particle systems are loaded from doc
	- Particle systems are saved in doc
// Fixes
	- some minor fixes with particle system	
*LAGui 0.55
// New
	- New theme : grey (style Qt)
	- LAg_SetFontColorUI(color) : to change the fontColor of the UI (menu, button...)
// Changes
	- Panel is now heigher by 2pixels at top
	- the font image are now not smoothed (magfilter on)
	- font size for button are fixed to 18
	- font size for editbox (stringgadget) is fixed to 18 (in LAg_util.agc)
	- font color for editbox is now the same as fontcolor UI
	- some minor fixes in Lag_OpenFile, LAg_SaveFile(), Lag8inputrequester() : font size and color changes
	

[30/06/2016] (0.33.3) (24) (11h-17h)
// New
	- particle : now, the color are changed only with bm = 0 or 1 , else the color = 255,255,255
	not finished - Select objects by group
	- help : release log, information
// Fixes
	- some minor fixes


[29/06/2016] (0.33) (23) (9h-17h)
// New
	- we can change the blendmode of part-syst
	- all image in textures/part are loaded at start
	- we can change the image of part-syst
	- now, the image change thanks to objtyp selected (if type = particle, the image shown are particle images, if objtyp = other (box, plane..), images shown are texture)
// Fixes
	- some bugfixes


[28/06/2016] (0.32) (22) (9h-17h)
// New
	- we can change particle colors, alpha, speed, random x/y/z, life
	- we can delete particle syst
	- we can move the part sys
	- we can add several part syst on the leve ! yes, breakdown :D
	- Add image iFx for Fx (particles) : 5 images
	- Add initpartsystem(), eventFx() in main loop
	- Add Fx particle file	
	- Add obj water in load doc
// Fixes
	- when open a model, I reset the dim for image, to not have all models have the precedent number of image/stage.
	- when open a model, now I verify the image if path is absolute or relative, and I load the image (absolute or relative (in the same folder as model))
*LaGui 0.54.3
// Fixes
	- when free a gadget with gadgetitem, the items weren't all deleted.
	- when delete a gadget type container, the gadget inside should be deleted too.
	
	
	
	
[27/06/2016] (0.31.5) (21) (9h-17h)
// 3D
	- house medieval1
// New
	- lightmap : add size, softness, height parameters
	- options : add lightmap size for the image
// Changes
	- selectionborder : la sélection s'opère au release mouse
	- lm : optimisation. Les objets ne projetant pas d'ombre ne sont plus calculés
// fixes
	- lightmap : le sol (recevant le lm) était visible dans certains cas, ça créait un artefact
	- si key /, les centres ne sont plus updatés
	- qd on copie/paste ou duplique object, les centres n'étaient plus corrects
	- avec le lightmap, on ne voyait plus le drawbox de la selection border
	
	
	
[26/06/2016] (0.31) (20) (9h-17h)
// New
	- physic : saved and loaded in document
	caché - physic : ajout d'une fenêtre pour gérer certains paramètres lié à la physic : physicbody, shape, mass
	- physic : we can add physic to object. Physic available : noone, static, dynamic, kinematic. When an object is physic, the 3Dphysicworld is enable.
	- objects have a center now : it's for selection border (center is visible by default, but I will add a flag to show /hide the center)
	- Border selection is ok (thanks to 29 games !)
*Lagui 0.54.2
	- Freegadget didn't delete the editbox for stringgadget


[25/06/2016] (0.30.6) (19) (9h-17h)
// Changes
	- when cible an object, the option generalx,y,z is set byt the object position.


[24/06/2016] (0.30.5) (18) (9h-17h)
// New
	- on peut importer plusieurs entity utilisant le même modèle mais des textures ou shaders différentes (good to create variations of the same ennemy, terrain,object...)
// Changes
	- on peut importer un shader soit dans le dossier de l'objet, soit dans un autre dossier
	- import model : je vérifie jusque 8 images désormais (le max de stage) 
	- import model : j'importe uvscalex et y, et uvoffsetx et y (stage 0  uniquement pour le moment)
	- quelques modifications dans la bank model/img pour gérer les uv importé
// Fixes
	- fixes some bugs when importing the shader, if the shaders isn't in the object folder



[23/06/2016] (0.30) (17) (9h-17h)
// New
	- import model  : j'importe désormais toutes les images (4 max pour le moment) et le shader, et j'applique shader et image aux instances d'objets.
	- Object : Rotation  with orientation (global, local)
	- Object : Move with orientation (global, local)
	- terrain shader 2 : this shader is the same as terrain shader by agk, instead of using colors, it use texture, so it's better result
	- Bank : remove model from bank
	- Bank preset : openbank preset, savebank preset
// Changes
	- object : add parameter shadowRT for the shadow in Realtime
	- panel properties réarrangé : boutons en haut (shader, behavior), bouton uv set shader dans le panel "image"
// Fixes
	- après rotation, l'objet n'avait pas la nouvelle rotation, mais gardait l'ancienne
*LA_gui 0.54.1
// Fixes
	- qd on supprimait un gadgetitem d'une listicon, ça n'actualisait pas les positions des autres gadgets items en dessous
	- editbox & stringgadget : désormais l'éditbox rend transparente les images = 0 uniquement, comme ça je peux utiliser l'éditbox normalement, avec une image de fond

	

[22/06/2016] (0.29) (16) (9h-17h)
// New
	- Shift + clic : select or deselect the object (multi-selection)
	- Menu : SET OBJ PARAM -> permet de changer certains paramètres pour tous les objets sélectionnés  : shadow on/off, position (x,y,z), size (x,y,z)
// Fixes
	- fixe some little bugs with the water object (grid doesn't disapparear, rot x wasn't keept..)
	- si on supprime un objet, le lightmap restait sur l'id précédent et ne fonctionnait plus 
	- Lightmap : je ne le calcule que si j'ai bien un objet qui le reçoit, sinon, je vérifie si l'objet existe.
// Changes
	- lightmap : les objets projettent une ombre uniquement si shadow est coché
	- changes with getrawkeystate : ctrl, shift et alt : ajout de boucle pour vérifier qu'on a relaché ctrl, shift et alt
	- behavior : les rotations sont locales désormais.
// Test
	- export de quelques modèles pour tester : decor (fence01,02, crate1,tonneau01,helice01,poto01,tree), dragon, iceman. Ils sont excellents :)
*La_Gui 0.54
// new
	-Window : Lag_GetWindowX / Y 
// changes
	- we can now use -1 for a gadget, the gadget renvoie alors l'id crée (gadget.length + 1)
	- l'editbox n'a plus de fond (elle l'avait en double)
// fixes
	- Window : Checkbox ne bougeait pas correctement avec la fenêtre
	- Window : Stringgadget ne bougeait pas correctement avec la fenêtre
	- openfile : on avait toujours Deux fois le même 1er fichier (si + de 2 fichiers dans le dossier)



[21/06/2016] (0.28) (16) (9h-17h)
// New
	- importmodel : add wrap parameter for terrain wrap image
	- When scale/rotation, I check the pivotcenter for transformation (only origin for the moment)
	- Mousemove : middle clic or alt+left : now, if we have an object selected, The view is rotation and camera look at the selected object.
	- UI toolbar : add 3 buttons : orientation( global, local), pivotcenter, snap
	- createobject (A key) : now, object is created at mouse coordonates
	- behavior : 6 new behavior presets (rotx,y,z,scalex,y,z), scale need from - to 
	- menu : reset view
	- menu : view to selected
	- menu : view center (0,0,0)
// fixes
	- when clic+ ctrl : the object was selected and moved
	- fixe a bug with behavior which only run if mouse was over UI
	- fixe a bug with ctrl+G (show grid) in double so it was cancelled ^^
*LA_Gui 0.53
// New
	- menu : add a shadow border to menuitem
	- menu : add a little border to menuitem, like a true menu :)
	- menubar()
// changes	
	- editbox are unactive if menu is opened
// Fixes
	- menu : when clic over the menu, it now close the menu
	- with LAg_SetGadgetVisible editbox are now unactive if not visible



[20/06/2016] (0.27.5) (15) (9h-17h)
// New
	- test (not finished) : boundingbox for selected objects (doesn't work with rotation)
	- Key / : center the view to selected object
	- new User mouse > middle mouse or leftmouse +alt : rotate the view, Shift+alt+ left : pan the view (like blender).
// Test
	- terrain creation
	- particles



[19/06/2016] (0.27) (15) (9h-17h)
// New
	- lightmap : test to change the shadow calculation (not very well), and to have shadow not only in top view (doesn't work properly)
	- options : the window position are saved (behavior, shader...)
	not finished - behavior : we can add/delete a behavior for selected objects/lights
// Test
	- shadowmap: pas réussi, ma technic ne fonctionne pas :(
// Changes
	- behavior : they change, I load the info from files and set the behavior by object, then create an array of behavior from the object.
* LaGui0.52.1
// Changes
	- when mousereleased, all gadget.pressed=0



[18/06/2016] (0.26) (15) (9h-17h)
// new
	- add some behavior : Rot X,Y,Z,scaleX,radar1 (not finished)
// Test
	- terrain : multi-texture + keycolor (thanks to vanB for the example).
* LaGui 0.52
// new
	- LAG_freeGadgetItem()
	- LAG_FreeItemFromList(gadget) : to delete all the item from a listicon & undim the the array used by the list
// fixes
	- LAg_AddgadgetItem : fixe a little bug with depth
	- Gadgetitem & window : when moving a window, the gadgetitem weren't moved with the gadget (if listicon)
	
	
[17/06/2016] (0.25) (14) (9h-17h)
// New
	- panel tool : lightmapper : shadowsoft size, shadow alpha, 
	- Panel right : Tool panel (instead of infos) 
	- Add a container by tool selected (lightmapper & level for test), with some gadgets. When clic on tool, the container change with the gadgets for this tool.
	- The UVscale and UVOffset are now changed by texture stage (good with ambient/shadowMap !)
// Fixes
	- Tab key didn't work properly.
* Lag 0.51
// new
	- The gadgets with a parent gadget move if the parent is moving (great to create several interface with different block of gadget, if different tool is selected, option are differents for example).
	- add the size of text in the gadget type
// Changes
	- on panel, only the event on the item are checked now
//fixes
	- Fixe a little bug with trackbar x position (with parent)
	- fixe some bugs with gadgetlist
	
	

[16/06/2016] (0.24) (13) (9h-17h)
// New
	- add a first lightmapper. it's not perfect at all, but it works ^^ !!!
	- Dynamic shadow in real time ! :)
	- soft shadow in real time
	
	
	

[15/06/2016] (0.23) (12) (9h-17h)
// New	
	- Now, we can save and load easily preset for atmospheric fx (skybox, fog, sun, ambient). 
	- atmosphere preset load / save : to load or save a preset for sun, skybox, fog, ambient
	- Transparency : we can now change the alpha of the object. if alpha<255, object transparency is set to 1, else it's set to 0
// fixes
	- when menu is opend, gadget aren't available until menu is opened
	- when LAG is hiden (Options.HideLag = 1), the gadgets and menu aren't available (not clickeable...)
	- we couldn't set an image to the terrain
* LAG
	- LAg_AddItemToListIcon() : to automatically add item list to list icon, from a folder + extension for exemple.
	
	

[14/06/2016] (0.22) (12) (9h-17h)
// New
general
	- move after clone several object : move only the cloned object
	- reset rot/scale : works with all object selected
	- setimage : works with all object selected
Window system	
	- window system : we can reduce (minimize) the window
	- window system : we can close the window (close button or any event we want)
	- window system : we can move the window
	- New window system : to create easily windows and use event on that window 
Terrain
	- Creation of the terrain editor, with 2 buttons only (ok, cancel)
Behavior	
	- test : delete the behavior for object
	- test : add a test behavior for object (rotation in Y only)
	- behavior editor for object : add a button to open the behavior window (not finished, behavior to add !) 
Shader / image
	- when select an object, the current stage is displayed on the gadget "stage"
	- when select an object, the image (panel image) is updated with the image of the current stage 
	- when change the stage texture (panel image), the image is updated with the image of the stage of the selected object
	- shader editor : add a button to open the shader window (window not finished, the window is just opened ^^)
// Changes
	- a lot of changes in opendoc(), savedoc, Lag_message, LAg_openFile(), LAg_Savefile(), Lag_menuBox()... because of the new Window system (need menubox)
*LAg
// new
	- Lag_OpenWindow() : now, each gadget has a window id (by default, the main window = 0). When close the window, it delete all gadgets assigned to this window.
	- Lots of change in LAG_menubox. Now, I don't delete the menubox, they are not active If I use LAG_FreeMenuBox()
	- LAG_SetMenuBoxPosition(id,x,y)
	- LAG_GetMenuboxSprite(id)
	
	
	
[13/06/2016] (0.21) (11) (9h-17h)
// New
	- The rotation of objects are now made by the mouse position (not a rotation automatic anymore)
	- now we can Rotate several objects : The rotation  is only at pivot of object for the moment
	- now we can scale several objects. The scale is only at pivot of object for the moment
	- Multi-selection+S
	- F : Freeze (lock) selected object / Ctrl+F : unFreeze all
	- h : hide the selected objects / Ctrl+H : unhide all objects
	- in statusbar : add getpolygondrawn()
	- Wheel mouse : move camera local Z (zoom in/out)
	- 0 key : set camera to last position (perspective)
	- Tab key : hide/show the LAG ui
	- When Open a doc, we have now a "loading" message
	- When clic on "play" button, now, the Lag Ui (menu, statusbar,gadgets, toolbar, message..) are hidden and the interface is inactive, the game is "loaded  " and we can play it (in the resolution of the game needed (1024*768 for the moment), at max fps :). 
// Tests
	- Specular shader (works but not very fine)	
// Changes	
	- With multi-selection, only the new objects created are selected after cloning
// Fixes
	- object locked : when scale (S) or Rotation, the object locked was rotated or scaled even if object was locked
	- When scaling an object, the new size wasn't updated unless we clic again on the object
* LAG
// NEw
	- when key pressed=enter : text is ok in stringgadget
	- add LAG_Event_Type :  LAG_C_EVENTTYPEKEYPRESSED & LAG_C_EVENTTYPEKEYRELEASED (for EditBox / stringgadget)
// Changes
	- Hide/Show LAG
	- lag_message, openfile, savefile,LAg_input_requester : now, if we GetRawKeyPressed() = enter, it close the window like we click on "ok"



[12/06/2016] (0.20) (11) (9h-17h)
// New
	- LAG_ListIcon : now, we can move the "sidebar", to see all the gadgetitem hidden
	- options : now, when we change the transformation tool, I keep the lock by tool, and update the Gadget UI (lock in panel options)
	- options : I save the lock (pos,rot,scale)
	- Now, when we clic on an object, I get the objID and objtyp so if we duplicate or add a next 3D model, it will be the same as this selected model.
	- When import a model, we have now the list of folders for model
	- when clic on a folder (in import model window), it actualise the files in that folder
// Fixes
	- Fixe an error in the scissor of the gadget item of list icon
	- Fixe error message when opening a model with no shader or no texture
* LAG
// New
	- LAG_ListIcon : now, we can move the "sidebar", to see all the gadgetitem hidden
	- Lag_OpenFile() : we have now the folder, and we can change the folder, that update the list of file in this folder


[11/06/2016] (0.19) (10) (8h-17h)
// New
	- ToolTips for gadgets
// Changes
	- when action = create, the object are create at mouse coordinates, if clic in the 3D view
	- when first start, the options.ini is created
// Fixes
	- some minor fixes
	- Fixe a bug with opendoc : all objet were model3D , instead of their good typ ( plane, cube, sphere...)
	- fixe a bug with opendoc : atmospheric effect wasn't load properly
	- fixe a bug when open some file, the atmospher message appear (file exists..) in some case
	
	
	
[10/06/2016] (0.18) (10) (8h-17h)
// New
	- object animated are now loaded with animation, and animation is started at creation
	- add button + preview image for object preview
	- tool create : when use tool create ("+"  icon), if we clic on the level, we create an object from this typ
	- load previous atmospheric file at start
	- add ambient intensity + stringgadget (factor for color)
	- when loading a new model3D, I add its texture in the texture bank
	- save atmospheric file (skybox,sun,fog,ambient) as separate file (to be loaded with atmospheric presets, for later)
	- camera position in statusbar
	- Object number  in statusbar
// Fixes
	- Rotation is now ok, can be lock with lock x/y/z checkbox
	- Shader rim-light is ok with lighting & fog now ! beautiful :D
	
* LAG
// New
	- Lag_SaveFile()
// fixes
	- fix minor error in statusbar position


[09/06/2016] (0.17) (9) (8h-17h)
// New
	- OpenDoc/SaveDoc : save the bank object
	- OpenDoc/SaveDoc : save the Object 3D from bank
	- Change Shader of the selected object
	- Set image to stage 0,1,2... to selected object
	- OpenDoc/SaveDoc : save the sun intensity
	- new stringgadget : sun intensity (to change the RGB with more value)
	- new menu : add terrain
	- add a Terrain system generation (based on the terrain from agk) : load a file to create the terrain
	- shaderbank system is ok : now I load and stock the shader in a bank name
	- Del : delete the selected objects
	? - Del : delete the selected lights (I can't really test if because of the limits of number of light by object)
	- Clone light
// Fixes
	- Stage String wasn't used
	- getobjprop : doesn't get the size and alpha of object
	- getobjprop : size wasn't float
	 
* LAG
// New
	- Lag_InputRequester()


[08/06/2016] (0.16) (9) (9h-17h)
// New
	- Ctrl+D : Clone a 3Dobj (create a copy, it's like : ctrl+C then Ctrl+V) work with all 3D object (plane, box..), 3D model and water probably.
	- Bank model : clic on > open the "importmodel()" window
	- Bank model : we can select the model to import (only in the current directory, for the moment)
	- Bank model : when clic on "ok", it import the model and create the gadgetitem for the list-icon
	- Bank model : clic on the gadget item (list-icon), model is selected, if we clic on "+" (or if we use the "A" key), it add the model to our level 
	- Option : cameraFov, near, Far
	- Option : DrawWater
//Changes
	- int & size for object/light is now string -not trackbar)
	- light icon (plane) is now 30*30 instead of 10*10
//Fixes
	- when water activated, grid became invisible
	- when create water,ObjTyp restait sur C_OBJ_Water
	- Ctrl+C didn't keep the good objTyp
	- various bug fixes
	
* LAG
// Changes
	- LAG_EventGadget() : now, the gadget item for list-icon change aspect when clicked
	- LAG_Getgadgetstate() : now return the item selected for list-icon
	- LAG_message : some changes to have a better design message + over button
	- LAG_freemenubox : can have -1 to delete the last menubox id	
	
	
	
[07/06/2016] (0.15) (8) (9h-17h)
// New
	- LockX, LockZ  LockY -> ok but move in Y must be changed (I don't know how to do that properly ??, perhap's with the screen coordonate)
	- move several object if selected
	- multi-selection (with shift)
	- copy/paste object
	- Add array bankObject, for Object 3D (not finished)
	- Water can be moved, sized,rotated and deleted now
	- SetObjectcoloremissive avec les slider R,G,B ds prop
// Fixes
	- ambient text was wrong (r,r,r)

* LAG
// new
	- LAG_ListIconGadget()
// Changes
	- Now, I hide all the sprites and text on gadgetitem, not just the 0
	- Some changes in Lag_OpenFile() : check extension, pattern and show only the file with pattern extension


[06/06/2016] (0.14) (7) (9h-17h)
// New
	- add Lib image on save/load file
	- set shader
	- add object Water (by janbo)
	- add shader reflexion / refraction for water (by janbo)
	- Options : lock X,Y,Z : not finished
	


	
[05/06/2016] (0.13) (6) (9h-17h)
// New
	- Ui : name object
	- Ui : better Lag_OpenFile() window
	- Ui : Fog
	- Fog : color, mix, max, active, save/load
	- Sun : load/save,x,y,z
//Changes
	- better selection for object
// Fixes
	- Minor bugs fixes
* LAG
	- add 2 new images (for starways)
	- LAG_OpenFile()
	- some minor bugs fixes
	
[04/06/2016] (0.12) (5) (9h-17h)
// New
	- Load document
	- Skybox : color, ColorH, Sun color
	- Ui : Sky + Trackbar...
	- Object : rx,ry,rz,sx,sy,sz, uvx,uvy,uvw,uvh, Change image (stage0)
	- Ui : Object prop -> sx,sy,sz,rx,ry,rz,shadow
// Changes
	- Options: theme, clearcolor
// Fixes 
	- minor bugs fixed

* lag
// Changes
	- add background to panel
	- change font color by theme
	
	
[03/06/2016] (0.11) (4) (7h-17h)
// New
View
	- camera top, front, right
Asset & object	
	- Shift +S/R : reset the Rotation and the Size to 0
	- Object3D can be scaled
	- Object3D can be rotated 
	- Object3D can be moved 
	- Object3D : properties are now updated if changed
	- Now, We can change the ObjTyp with Key 1 : objtyp are ! box,sphere,capsule,cone,cylinder, plane and object3D (object3D not fonctional)
	- add 4 textures, to test the creation with those textures
Options, document	
	- Add options, saveoption, loadoption
	- Add document parameters : type doc, InitDoc()	
// CHANGES
	- when newdoc : skybox, fog and sun are reset and set to 0
//Fixes
	- some minors bugs fixed
	
*LAG
// changes
	- add a flag LAG_MenuOpen to know if a menu is open or not
// fixes
	- fix minor bugs in LAG_Message()
	- fixe a bug in answer with LAg_message()
	- fix a bug with panel gadget : the gadgetItem was update when clic on it


[02/06/2016] (0.10) (3) (8h-17h)
// New
	- Add Object box
	- move object 3D
	- Get obj prop	
	- Move light
	- Set/Get light prop : set rgb,radius,x,y,z,locked,hide
	- Add light : now, I add a plane to see the light
	- Select Obj
	- now Obj Selected are in Red
	- Add fly mode in action <> play 
UI	
	- Add the toolbar, with : new, open,save / obj,light,camera,fx / add,select,move,rot,scale,clone,delete/
	- Add the StatusBar
	- Add the LAG (Lib AGK Gui) interface :). The LAG is a lib for AGK to create interface easyli, made by blendman, oh that's me :)
	- Check event only if x & y in the gadget area

*LAG 
// New
	- Addstatusbar, statusbarfield, statusbartext
	- ContainterGadget() not finished	
// Changes
	- Now, the message use the proper height for the text, to draw it.
	- changes in button image (centered, not resized)
*/



/* 2015 (1/1)

[13/11/2015] (0.01) (1) (9h-17h)
* 3D level editor
// New
Tests
	- add player, ground, objet decor, mob
	- qd clic on map, ciblex/y
	- si ciblex/y : player move vers cible, angle change en fonction de la direction
	- Mob : add, si player dans radar, mob vont vers player, si player dans zone attack, mob attack
	- player perd vie, si vie <= 0 player mort
	- le player peut cibler un mob (marche pas avec scale)
Editor
	- on peut créer un objet
	- on peut déplacer un objet
	- on peut rotationner un objet

*/




Foldend

