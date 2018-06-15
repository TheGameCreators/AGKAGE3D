
/*

Les différents ecrans et les loops qui y correspondent
- 0 : écran start (accueil) avec boutons new game, loadgame,  ou play ( =choose profil)/options/credits...
- 1 : écran jeu : on joue
- 2 : menu pause ??
- 3 : écran options
- 4 : écran credits
- 5 : écran profil
- 6 : quitter : avec la publicité : achetez la version complète :)
- 9 : uniquement dans la version lite : écran acheter : lien vers googleplay et la version complète

*/


//******************* general loop *********************//

Function GeneralLoop() 

    select gameProp.state

        case C_SCREENSTART : // ecran d'accueil menu
            EcranAccueil()
        endcase

        case C_SCREENGAME : // on joue, ecran game
            EcranJeu()
        endcase

        case C_SCREENCHARGE : // ecran de  chargement entre les maps (pas le loading du départ)
           // EcranChargement(1)
        endcase

        case C_SCREENPAUSE : // Ecran pause 
            //EcranPause()
        endcase
        
        case C_SCREENWORLDMAP : // Ecran pause 
            //EcranCarteMonde()
        endcase
		
		case C_SCREENOPTIONS : // Ecran options
            //EcranOptions(0)
        endcase
        
        case C_SCREENCREDITS : // Ecran des crédits
            //EcranCredit()
        endcase

        case C_SCREENPROFIL : // Ecran des profils
            //EcranProfil()
        endcase

    Endselect

    //Sync()


EndFunction 





