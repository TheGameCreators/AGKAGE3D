
//******************* variables 

Type sGameProp

	// properties for the game
	
    Version$
    VersionNum as integer
    Date$
    DateSaved$
    Profil as integer
    Lang$

	GameSaved as integer
	
	Shader As integer
	
    // options for the game
    Difficulty as integer
    Sound as integer
    Music as integer
    Debug as integer

	MoveCameraFree as integer // 
	Hasplayer as integer
    // NightOk as integer
    
    // ingame
    State as integer // l'ecran du jeu (profil, start, game, credit..)
    
    // Bound
	BoundLeft as integer
	BoundRight as integer
	BoundTop as integer
	BoundBottom as integer
	
	View as integer
	
EndType


//***************** variables  *******************//

Function SetVariables()

    Global GameProp as sGameprop
    gameProp.lang$ = "eng"
    gameProp.Debug = 0
    gameProp.shader = 100
    gameProp.View = 5 // perspective

    // on initialise certaines variables pour le jeu : à garder
    Global Map_w, Map_h, G_depth as integer
	G_depth = 5000

	// Editor
	Global ImgId, multiselect, SnapX, SnapY, SnapZ
	Global Start_oX#, Start_oY#, Start_oZ#
	Global Mouse_X, Mouse_Z as float

	


EndFunction


