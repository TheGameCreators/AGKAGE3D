
//********************************************************//
//
//              Dictionnaire : fonction pour les
//                  différentes langues du jeu
//
//********************************************************//

type sdico 

    //************** General ***************//
    // boutons
    Btn1$ // general
    BtnStart$

    // messages
    Welcome$
    Info$
    Level$

    // screen
    Profil$
    BtnStore$
    Map$
    Stat$

    //************** Objets ***************//
    Bonus$
    Spell$
  
    // infos pour les tours
    Tower$

    // options
    Option$
    Message$
    Compagnon$



endtype 

function ReadPref(nom$, valeur$) 

    Line$ = ReadLine(1)
    Index$ = GetStringToken(Line$,"|",1)
    if Index$ = nom$
        info$ = GetStringToken(Line$,"|",2)
    endif
    if info$ =""
        info$ =valeur$
    endif

endfunction info$ // '}



Function InitLang()

    Global dico as sdico

    save$ = "ArkeosChronicle_sav" + str(gameProp.profil) + ".txt"

    if GetFileExists(save$) = 1

        OpenToRead(10, save$)

            While FileEOF(10) = 0

                Line$ = ReadLine(10)

                // si ligne encodée
                // result$ = Decode64$(Line$)
                Index$ = GetStringToken(Line$ ,",",1)

                if Index$ = "1"
                    gameProp.DateSaved$ = GetStringToken(Line$,",",7)
                    if gameProp.DateSaved$ =""
						gameProp.DateSaved$ = gameProp.Date$
					endif
                    gameProp.lang$ = GetStringToken(Line$,",",6)
                    if gameProp.lang$ = ""
                        gameProp.lang$ = "eng"
                    endif
                endif

            EndWhile

        closefile(10)
    endif


EndFunction

function GetLanguage(mode) 

    // mode = 0 chargement au départ du jeu
    // mode = 1 : on change la langue

    if gameProp.lang$ = ""
        gameProp.lang$ = "eng"
    else
		// message("lang :"+gameProp.lang$)
    endif

    dico_$ = "txt/" + gameProp.lang$ + ".txt"

    if GetFileExists(dico_$) = 1

        OpenToRead(6, dico_$)

            While FileEOF(6) = 0

                Line$ = ReadLine(6)
                Index$ = GetStringToken(Line$,"|",1)
                Line$ = ReplaceString2(Line$, "#", chr(10))
				
                select Index$
                    case "Btn1" :
                        dico.Btn1$ = Line$
                    endcase
                    case "Welcome" :
                        dico.Welcome$ = Line$
                    endcase
                    case "Info" :
                        dico.Info$ = Line$
                    endcase
                    case "Level"
                        dico.Level$ = Line$
                    endcase                    
                    case "Stat"
                        dico.Stat$ = Line$
                    endcase                    
                    case "Bonus"
                        dico.Bonus$ = Line$
                    endcase                   
                    case "Options"
                        dico.Option$ = line$
                    endcase
                    case "BtnStart"
                        dico.BtnStart$ = line$
                    endcase
                    case "BtnStore"
                        dico.BtnStore$ = line$
                    endcase
                    case "Profil"
                        dico.Profil$ = line$
                    endcase
                    case "Map"
                        dico.Map$ = line$
                    endcase
                    case "Message"
                        dico.Message$ = line$
                    endcase                    
                    case "Compagnon"
                        dico.Compagnon$ = line$
                    endcase                    
                    case "Spell"
                        dico.Spell$ = line$
                    endcase
                                       
                endselect

            endwhile
        
        closefile(6)
    endif

    if mode = 1
        // puis on recharge les infos : tour, mob
        /*
        ChargeInfoTour()
        ChargeNomMap()
        ChargeInfoSort()
        ChargeInfoMob()
        ChargeInfoSucces()
        */
    endif

EndFunction





