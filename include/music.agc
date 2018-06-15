


Function InitMusic()
	
	LoadMusic(1, "music\blendman_ArkeosTheme.ogg")
	if GetMusicExists(1)
        if gameProp.Music = 1
            if GetMusicPlaying()  = 0
                PlayMusic(1, 1)
                SetMusicFileVolume(1, 60)
            endif
        endif
    endif
    
EndFunction
