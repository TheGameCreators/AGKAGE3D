
FoldStart //****  By Scraggle, thanks ;) 

#constant TRUE = 1
#constant FALSE = 0



function SetSpriteSize9Slice( sImg, tSpr, tW, tH, cW, cH )
    
    
    /* ************  SetSpriteSize9Slice( sImg, tSpr, tW, tH, cW, cH )   *************
 
	Description:    Creates a sprite by resizing an image without affecting the corners
					by dividing the image into nine parts, positioning the
					corners and then resizing everything else to fit
	 
	Parameters:     sImg - The source image, this must exist of the function will fail
					tSpr - The target sprite, this must exist of the function will fail
						   unless the parameter is -1 in which case a new sprite is returned
					tW - The width of the target wprite
					tH - The height of the target sprite
					
					cW - The width of the corner that will not be resized,
						 if -1 then the width of the source image is divided evenly in 3 parts
					cH - The height of the corner that will not be resized
						 if -1 then the height of the source image is divided evenly in 3 parts
	 
	Returns:        tSpr - The value of the target sprite - only used if the passed tSpr is -1
	*/

    
    if not GetImageExists(sImg)
        message( "SetSpriteSize9Slice() called"+chr(13)+"with invalid source image")
        exitfunction 0
    endif
    if tSpr > -1
        if not GetSpriteExists(tSpr)
            message( "CopySpriteAreaToSprite() called"+chr(13)+"with invalid target sprite")
            exitfunction 0
        endif
    endif
 
 
    if cW = -1 then cW = GetImageWidth(sImg)/3
    if cH = -1 then cH = GetImageHeight(sImg)/3
 
    tTopW = iMax(tW - cW*2, 1)
    tLeftH = iMax(tH - cH*2, 1)
    sW = GetImageWidth(sImg)
    sH = GetImageHeight(sImg)
 
    tMb = CreateMemblockEmptyImage( tW, tH )
    c = MakeColor(200, 0, 100)
    for k = 12 to tW*tH*4+12 step 4
        SetMemblockInt(tMb,k,c)
    next k
 
    //Place Corners
    tMb = CopyImageAreaToMemblock( sImg, tMb, 0, 0, cW, cH, 0, 0 )
    tMb = CopyImageAreaToMemblock( sImg, tMb, sW-cW, 0, cW, cH, tW-cW, 0 )
    tMb = CopyImageAreaToMemblock( sImg, tMb, 0, sH-cH, cW, cH, 0, tH-cH )
    tMb = CopyImageAreaToMemblock( sImg, tMb, sW-cW, sH-cH, cW, cH, tW-cW, tH-cH )
 
    //Make Top
    sTopW = sW - cW*2
    tempImg = CopyImageAreaToImage( sImg, -1, cW, 0, sTopW, cH, 0, 0 )
    ResizeImage( tempImg, tTopW, cH)
    tMb = CopyImageAreaToMemblock( tempImg, tMb, 0, 0, tTopW, cH, cW, 0 )
    DeleteImage(tempImg)
 
    //Make Bottom
    tempImg = CopyImageAreaToImage( sImg, -1, cW, sH-cH, sTopW, cH, 0, 0 )
    ResizeImage( tempImg, tTopW, cH)
    tMb = CopyImageAreaToMemblock( tempImg, tMb, 0, 0, tTopW, cH, cW, tH-cH )
    DeleteImage(tempImg)
 
    //Make Left
    sLeftH = sH - cH*2
    tempImg = CopyImageAreaToImage( sImg, -1, 0, cH, cW, sLeftH, 0, 0 )
    ResizeImage( tempImg, cW, tLeftH)
    tMb = CopyImageAreaToMemblock( tempImg, tMb, 0, 0, cW, tLeftH, 0, cH )
    DeleteImage(tempImg)
 
    //Make Right
    tempImg = CopyImageAreaToImage( sImg, -1, sW-cW, cH, cW, sLeftH, 0, 0 )
    ResizeImage( tempImg, cW, tLeftH)
    tMb = CopyImageAreaToMemblock( tempImg, tMb, 0, 0, cW, tLeftH, tW-cW, cH )
    DeleteImage(tempImg)
 
    //Make Middle
    tempImg = CopyImageAreaToImage( sImg, -1, cW, cH, sTopW, sLeftH, 0, 0 )
    ResizeImage( tempImg, tTopW, tLeftH)
    tMb = CopyImageAreaToMemblock( tempImg, tMb, 0, 0, tTopW, tLeftH, cW, cH  )
    DeleteImage(tempImg)
 
 
    if tSpr = -1
        tSpr = createsprite( CreateImageFromMemblock( tMb ) )
    else
        SetSpriteImage( tSpr, CreateImageFromMemblock( tMb ) )
    endif
 
    DeleteMemblock(tMB)
 
endfunction tSpr


function CopyMemblockAreaToMemblock( sMb, tMb, x, y, w, h, tX, tY )
    /* **********    CopyMemblockAreaToMemblock( sMb, tMb, x, y, w, h, tX, tY )   ***************
 
Description:    Copy a rectangular area from one memblock to another.
                The rectangle can be anywhere in the source image
                and it can be positione anywhere in the target image.
 
Parameters:     sMB - The source memblock - must exit or the function will fail
                tMB - The target memblock - must exit or the function will fail
                      unless the parameter is -1, in which case a new memblock will be created
                x,y - The top left of the rectangle to capture
                w,h = The width and height of the rectangle to capture
                      If these values are negative then absolute coordinate are used instead
                tX,tY - The top left of the target image to insert the extracted image into.
                        If tMB = -1 then these values are ignored
 
Returns:        The ID of the target memblock - Only used if a new memblock has been created
*/

    if not GetMemblockExists(sMB)
        message( "CopyMemblockAreaToMemblock() called"+chr(13)+"with invalid source memblock")
        exitfunction 0
    endif
 
    sW = GetMemblockInt(sMB, 0)
    if w < 0 then w = abs(w)-x
    if h < 0 then h = abs(h)-y
 
    if tMb = -1
        tMb = CreateMemblockEmptyImage(w,h)
        tW = w
        tX = 0
        txOff = 0
        tyOff = 0
    else
        if not GetMemblockExists(tMb)
            message( "CopyMemblockAreaToMemblock() called"+chr(13)+"with invalid target memblock")
            exitfunction 0
        endif
        insert = TRUE
        tW = GetMemblockInt(tMb, 0)
        txOff = tX*4
        tyOff = (tW*tY*4)
    endif
 
    for k = y to y+h
        syOff = ((sW*k)*4)+12
        CopyMemblock(sMb, tMb, syOff+(x*4), tyOff+txOff+12, w*4 )
        if insert
            inc tyOff, tw*4
        else
            inc tyOff, w*4
        endif
    next k
 
endfunction tMb
 
 

function CopyImageAreaToImage( sImg, tImg, x, y, w, h, tX, tY )
   
   /* *********     CopyImageAreaToImage( sImg, tImg, x, y, w, h, tX, tY )   *********************
 
	Description:    Copies a rectangular area of an image into another image
					The rectangle can be anywhere in the source image
					and it can be positioned anywhere in the target image.
	 
	Parameters:     sImg - The source image - must exit or the function will fail
					tImg - The target image - must exit or the function will fail
						   unless the parameter is -1, in which case a new image will be created
					x,y - The top left of the rectangle to capture
					w,h - The width and height of the rectangle to capture
						  If these values are negative then absolute coordinate are used instead
					tX,tY - The top left of the target image to insert the extracted image into.
							If tImg = -1 then these values are ignored
	 
	Returns:        The ID of the target image - Only used if a new image has been created
	*/
   
    if not GetImageExists(sImg)
        message( "CopyImageAreaToImage() called"+chr(13)+"with invalid source image")
        exitfunction 0
    endif
    if tImg > -1
        if not GetImageExists(sImg)
            message( "CopyImageAreaToImage() called"+chr(13)+"with invalid target image")
            exitfunction 0
        endif
        tMb = CreateMemblockFromImage(tImg)
    else
        tMb = -1
    endif
 
    if w < 0 then w = abs(w)-x
    if h < 0 then h = abs(h)-y
 
    sMb = CreateMemblockFromImage(sImg)
    tMb2 = CopyMemblockAreaToMemblock( sMb, tMb, x, y, w, h, tX, tY )
    tImg = CreateImageFromMemblock( tMb2 )
    DeleteMemblock(sMb)
    DeleteMemblock(tMb2)
    
endfunction tImg
 
 

function CopySpriteAreaToSprite( sSpr, tSpr, x, y, w, h, tX, tY )
    
    /* *********     CopySpriteAreaToSprite( sSpr, tSpr, x, y, w, h, tX, tY )   *******************
 
	Description:    Copies a rectangular area of a sprite into another sprite
					The rectangle can be anywhere in the source sprite
					and it can be positione anywhere in the target sprite.
	 
	Parameters:     sSpr - The source sprite - must exit or the function will fail
					tSpr - The target sprite - must exit or the function will fail
						   unless the parameter is -1, in which case a new sprite will be created
					x,y - The top left of the rectangle to capture
					w,h - The width and height of the rectangle to capture
						  If these values are negative then absolute coordinate are used instead
					tX,tY - The top left of the target sprite to insert the extracted sprite into.
							If tSpr = -1 then these values are ignored
	 
	Returns:        The ID of the target sprite - Only used if a new sprite has been created
	*/
    
    if not GetSpriteExists(sSpr)
        message( "CopySpriteAreaToSprite() called"+chr(13)+"with invalid source sprite")
        exitfunction 0
    endif
    if tSpr > -1
        if not GetSpriteExists(sSpr)
            message( "CopySpriteAreaToSprite() called"+chr(13)+"with invalid target sprite")
            exitfunction 0
        endif
        tImg = GetSpriteImageID(tSpr)
        tMb = CreateMemblockFromImage(tImg)
    else
        tMb = -1
    endif
 
    if w < 0 then w = abs(w)-x
    if h < 0 then h = abs(h)-y
 
    sImg = GetSpriteImageID(sSpr)
    sMb = CreateMemblockFromImage(sImg)
    tMb = CopyMemblockAreaToMemblock( sMb, tMb, x, y, w, h, tX, tY )
    tImg = CreateImageFromMemblock( tMb )
 
    if tSpr > -1
        SetSpriteImage(tSpr, tImg)
    else
        tSpr = CreateSprite(tImg)
    endif
    DeleteMemblock(sMB)
endfunction tSpr
 
 

function CopySpriteAreaToMemblock( sSpr, tMb, x, y, w, h, tX, tY )
   
   /* *********     CopySpriteAreaToMemblock( sSpr, tMb, x, y, w, h, tX, tY )   ****************
 
Description:    Copies a rectangular area of a sprite into a memblock
                The rectangle can be anywhere in the source sprite
                and it can be positione anywhere in the target memblock.
 
Parameters:     sSpr - The source sprite - must exit or the function will fail
                tMb - The target memblock - must exit or the function will fail
                       unless the parameter is -1, in which case a new memblock will be created
                x,y - The top left of the rectangle to capture
                w,h - The width and height of the rectangle to capture
                      If these values are negative then absolute coordinate are used instead
                tX,tY - The top left of the target memblock to insert the extracted sprite into.
                        If tMb = -1 then these values are ignored
 
Returns:        The ID of the target memblock - Only used if a new memblock has been created
*/
   
    if not GetSpriteExists(sSpr)
        message( "CopySpriteAreaToMemblock() called"+chr(13)+"with invalid source sprite")
        exitfunction 0
    endif
 
    if w < 0 then w = abs(w)-x
    if h < 0 then h = abs(h)-y
 
    sMb = CreateMemblockFromImage( GetSpriteImageID(sSpr) )
    tMb = CopyMemblockAreaToMemblock( sMb, tMb, x, y, w, h, tX, tY )
    DeleteMemblock(sMB)
endfunction tMb
 
 
function CopyImageAreaToMemblock( sImg, tMb, x, y, w, h, tX, tY )
   
	/* *********     CopyImageAreaToMemblock( sImg, tMb, x, y, w, h, tX, tY )   ********************
 
	Description:    Copies a rectangular area of an image into a memblock
					The rectangle can be anywhere in the source image
					and it can be positione anywhere in the target memblock.
	 
	Parameters:     sImg - The source image - must exit or the function will fail
					tMb - The target memblock - must exit or the function will fail
						   unless the parameter is -1, in which case a new memblock will be created
					x,y - The top left of the rectangle to capture
					w,h - The width and height of the rectangle to capture
						  If these values are negative then absolute coordinate are used instead
					tX,tY - The top left of the target memblock to insert the extracted image into.
							If tMb = -1 then these values are ignored
	 
	Returns:        The ID of the target memblock - Only used if a new memblock has been created
	*/

   
    if not GetImageExists(sImg)
        message( "CopyImageAreaToMemblock() called"+chr(13)+"with invalid source image")
        exitfunction 0
    endif
 
    sMb = CreateMemblockFromImage( sImg )
    rMb = CopyMemblockAreaToMemblock( sMb, tMb, x, y, w, h, tX, tY )
    DeleteMemblock(sMB)
endfunction rMb
 
 
function CopyImageAreaToSprite( sImg, tSpr, x, y, w, h, tX, tY )
    
    /* *********     CopyImageAreaToSprite( sImg, tSpr, x, y, w, h, tX, tY )   *********************
 
	Description:    Copies a rectangular area of an image into a sprite
					The rectangle can be anywhere in the source image
					and it can be positione anywhere in the target sprite.
	 
	Parameters:     sImg - The source image - must exit or the function will fail
					tSpr - The target sprite - must exit or the function will fail
						   unless the parameter is -1, in which case a new sprite will be created
					x,y - The top left of the rectangle to capture
					w,h - The width and height of the rectangle to capture
						  If these values are negative then absolute coordinate are used instead
					tX,tY - The top left of the target sprite to insert the extracted image into.
							If tMb = -1 then these values are ignored
	 
	Returns:        The ID of the target sprite - Only used if a new sprite has been created
	*/

    
    if not GetImageExists(sImg)
        message( "CopyImageAreaToSprite() called"+chr(13)+"with invalid source image")
        exitfunction 0
    endif
    if tSpr > -1
        if not GetSpriteExists(tSpr)
            message( "CopySpriteAreaToSprite() called"+chr(13)+"with invalid target sprite")
            exitfunction 0
        endif
        tMb = CreateMemblockFromImage( GetSpriteImageID(tSpr) )
    else
        tMb = -1
    endif
 
    sMb = CreateMemblockFromImage(sImg)
    rMb = CopyMemblockAreaToMemblock( sMb, tMb, x, y, w, h, tX, tY )
    tImg = CreateImageFromMemblock(rMB)
 
    if tSpr = -1
        tSpr = createsprite(tImg)
    else
        SetSpriteImage(tSpr, tImg)
    endif
 
    DeleteMemblock(sMb)
    DeleteMemblock(tMb)
endfunction tSpr
 
 
function SetSpriteSize9SliceFromArea( sImg, tSpr, sX, sY, sW, sH, tW, tH, cW, cH )
    
    /* ***********   SetSpriteSize9SliceFromArea( sImg, tSpr, sX, sY, sW, sH, tW, tH, cW, cH )   *****************
 
	Description:    Creates a sprite by resizing an image without affecting the corners
					by dividing the image into nine parts, positioning the
					corners and then resizing everything else to fit.
					It differs from SetSpriteSize9Slice() in that an area is passed to the function
					and the new sprite is captured and resized from that area of the source image
					instead of using the complete image.
	 
	Parameters:     sImg - The source image, this must exist of the function will fail
					tSpr - The target sprite, this must exist of the function will fail
						   unless the parameter is -1 in which case a new sprite is returned
					sX - The X position of the area to capture from the source image
					sY - The Y position of the area to capture from the source image
					sW - The width of the area to capture from.
						 If the value is negative then this is an absolute value instead
					sH - The height of the area to capture from
						 If the value is negative then this is an absolute value instead
					tW - The wisth of the target sprite
					tH - The height of the target sprite
					cW - The width of the corner that will not be resized,
						 if -1 then the width of the source image is divided evenly in 3 parts
					cH - The height of the corner that will not be resized
						 if -1 then the height of the source image is divided evenly in 3 parts
	 
	Returns:        tSpr - The value of the target sprite - only used if the passed tSpr is -1
	*/

    
    if sW < 0 then sW = abs(sW)-sX
    if sH < 0 then sH = abs(sH)-sY
    areaImg = CopyImageAreaToImage( sImg, -1, sX, sY, sW, sH, 0, 0 )
    tSpr = SetSpriteSize9Slice( areaImg, tSpr, tW, tH, cW, cH )
endfunction tSpr
 
 
function CreateMemblockEmptyImage(w, h)
   
   /* *********     CreateMemblockEmptyImage(w, h)   **************************
 
	Description:    Creates a new memblock ready to create an image and
					populates the header of the memblock with the dimensions.
	 
	Parameters:     w - The width of the image
					h - The height of the image
	 
	Returns:        mb - The memblock ID of the newly created memblock
	*/

    mb = CreateMemblock(w*h*4+12)
    SetMemblockInt(mb, 0, w)
    SetMemblockInt(mb, 4, h)
    SetMemblockInt(mb, 8, 32)
    
endfunction mb
 
 
function CreateMemblockMask( sImg, rm, gm, bm )
   
	/* *********     CreateMemblockMask( sImg, rm, gm, bm )   **************************
 
	Description:    Creates a mask based on the alpha channel of the source image
					but only if the source image colour matches that passed in
	 
	Parameters:     sImg - The source image used to create a mask
					rm - the red component of the source image used to establish
						 if a mask should be created from that pixel
					rg - The green component (as above)
					rb - The blue component (as above)
	 
	Returns:        tMb - The memblock ID of the newly created memblock
	*/

   
    if not GetImageExists(sImg)
        message( "CreateMemblockMask() called"+chr(13)+"with invalid source image")
        exitfunction 0
    endif
    sMb = CreateMemblockFromImage(sImg)
    tMb = CreateMemblockEmptyImage( GetImageWidth(sImg), GetImageHeight(sImg) )
    for k = 12 to GetMemblockSize(sMb) step 4
        if GetMemblockByte(sMb, k) = rm or rm = -1
            if GetMemblockByte(sMb, k+1) = gm or gm = -1
                if GetMemblockByte(sMb, k+2) = bm or bm = -1
                    for j = 0 to 3
                        SetMemblockByte(tMb, k+j, GetMemblockByte(sMb, k+3))
                    next j
                endif
            endif
        endif
    next k
    img = CreateImageFromMemblock(tMb)
    SaveImage(img, "mask.png")
      
      
endfunction tMb
 

function CreateMemblockMaskFromArea( sImg, rm, gm, bm, x, y, w, h )
	
	/* *********     CreateMemblockMaskFromArea( sImg, rm, gm, bm, x, y, w, h )    **************************
 
	Description:    Creates a mask based on the alpha channel of the source image
					but only if the source image colour matches that passed in
					and then only within the area specified by the passed parameters
	 
	Parameters:     sImg - The source image used to create a mask
					rm - the red component of the source image used to establish
						 if a mask should be created from that pixel
					rg - The green component (as above)
					rb - The blue component (as above)
									sX - The X position of the area to capture from the source image
					sY - The Y position of the area to capture from the source image
					sW - The width of the area to capture from.
						 If the value is negative then this is an absolute value instead
					sH - The height of the area to capture from
						 If the value is negative then this is an absolute value instead
	 
	 
	Returns:        tMb - The memblock ID of the newly created memblock
	*/
   
    if not GetImageExists(sImg)
        message( "CreateMemblockMask() called"+chr(13)+"with invalid source image")
        exitfunction 0
    endif
    if w < 0 then w = abs(w)-x
    if h < 0 then h = abs(h)-y
    SetSpriteTransparency(sImg, 1)
    tempMb = CreateMemblockEmptyImage( GetImageWidth(sImg), GetImageHeight(sImg) )
    tempMb = CopyImageAreaToMemblock( sImg, tempMb, x, y, w, h ,0, 0 )
    tempImg = CreateImageFromMemblock(tempMb)
    tMb = CreateMemblockMask(tempImg, rm, gm, bm)
    DeleteImage(tempImg)
    DeleteMemblock(tempMb)
    
endfunction tMb
 
 
function ApplyMaskToImage( img, mask, x, y )
   
	/* *********     ApplyMaskToImage( img, mask, x, y )  **************************
 
	Description:    Applies a previously created mask to the alpha channel of an image
					Both the mask and the image must exist or the function will fail
	 
	Parameters:     img - The image to apply the alpha mask on to
					mask - the ID of a memblock holding a previously created mask
					x,y - the coordinates to offset the mask.
	 
	Returns:        nothing
	*/

   
    tempImg = CreateImageFromMemblock(mask)
 
    SetImageMask(img, tempImg, 4, 4, x, y )
    DeleteImage(tempImg)
endfunction
  

function InvertMemblockAlpha( mb )
   
	/* *********     InvertMemblockalpha( mb )     **************************
 
	Description:    Inverts the alpha channel of a given memblock
	 
	Parameters:     mb - The memblock who's alpha channel you wish to invert
	 
	Returns:        nothing
	*/
	   
    for k = 15 to GetMemblockSize(mb) step 4
        thisalpha = GetMemblockByte(mb, k)
        alpha = 255-thisalpha
        SetMemblockByte(mb, k, alpha)
    next k
    
endfunction
 
 
function InvertImageAlpha( img )
    
    /* *********     InvertImageAlpha( img )     **************************
 
	Description:    Inverts the alpha channel of a given image
	 
	Parameters:     img - The image who's alpha channel you wish to invert
	 
	Returns:        nothing
	*/

    
    mb = CreateMemblockFromImage(img)
    for k = 15 to GetMemblockSize(mb) step 4
        thisalpha = GetMemblockByte(mb, k)
        alpha = 255-thisalpha
        SetMemblockByte(mb, k, alpha)
    next k
    CreateImageFromMemblock(img, mb)
    DeleteMemblock(mb)
    
endfunction
 
 
function SetSpriteTiled( spr, w#, h# )
   
	/* *********     SetSpriteTiled( spr, w#, h# )  **************************
 
	Description:    Performs in much the same way as a simpe SetSpriteSize()
					However, the texture remains the same size and is instead
					tiled across the sprite
	 
	Parameters:     spr - The sprite to resize
					w#,h# - the new width of height of the sprite
	 
	Returns:        nothing
	*/

   
   
    SetSpriteSize(spr, w#, h#)
    img = GetSpriteImageID(spr)
    SetImageWrapU(img, 1)
    SetImageWrapV(img, 1)
    qx# = (GetImageWidth(img)/w#)
    qy# = (GetImageHeight(img)/h#)
    SetSpriteUVScale(spr, qx#, qy#)
    
endfunction
 
 
function BlendImages( iUpper, iLower, ialpha, Width, Height)
 
	/* *********     BlendImages( iUpper, iLower, ialpha, Width, Height)   *************
 
	Description:    This function will take two images of any size (equal or not)
					and blend them together according to the values of a third
					greyscale alpha map image
	 
	Parameters:     iUpper - The image that will show through in the white areas of the alpha map
					iLower - The image that will show through in the black areas of the alpha map
					ialpha - The greyscale image used to blend iUpper & iLower
					Width  - The width you want the resultant image to be
					Height - The height you want the resultant image to be
	 
	Returns:        iResult - The image number of the resultant blended image
	 
	Note:           The images do not need to be the same size nor do any of them need to
					be the size of the resultant image.
					They will all be scaled automatically.
	*/

    Local Percent       as float
    Local UpperBlue     as integer
    Local UpperGreen    as integer
    Local UpperRed      as integer
    Local LowerBlue     as integer
    Local LowerGreen    as integer
    Local LowerRed      as integer
    Local ResultBlue    as integer
    Local ResultGreen   as integer
    Local ResultRed     as integer
    Local mUpper        as integer
    Local mLower        as integer
    Local malpha        as integer
    Local mResult       as integer
    Local iResult       as integer
 
    if getimagewidth(iUpper) <> width or getimageheight(iUpper) <> height then iUpper = myResizeImage( iUpper, Width, Height )
    if getimagewidth(iLower) <> width or getimageheight(iLower) <> height then iLower = myResizeImage( iLower, Width, Height )
    if getimagewidth(ialpha) <> width or getimageheight(ialpha) <> height then ialpha = myResizeImage( ialpha, Width, Height )
 
    mUpper  = 1
    mLower  = 2
    malpha  = 3
    mResult = 4
 
    CreateMemblockFromImage( mUpper,  iUpper )
    CreateMemblockFromImage( mLower,  iLower )
    CreateMemblockFromImage( malpha,  ialpha )
    CreateMemblockFromImage( mResult, iUpper )
 
    mbSize = getmemblocksize( mUpper )
    for Pos = 12 to mbSize step 4
 
        Percent     = ( getmemblockbyte( malpha, Pos ) / 255.0 )
 
        UpperBlue   = getMemblockByte( mUpper, Pos + 0 )
        UpperGreen  = getMemblockByte( mUpper, Pos + 1 )
        UpperRed    = getMemblockByte( mUpper, Pos + 2 )
 
        LowerBlue   = getMemblockByte( mLower, Pos + 0 )
        LowerGreen  = getMemblockByte( mLower, Pos + 1 )
        LowerRed    = getMemblockByte( mLower, Pos + 2 )
 
        ResultBlue  = UpperBlue  * ( 1- Percent ) + LowerBlue  * Percent
        ResultGreen = UpperGreen * ( 1- Percent ) + LowerGreen * Percent
        ResultRed   = UpperRed   * ( 1- Percent ) + LowerRed   * Percent
 
        setmemblockbyte( mResult, Pos + 0, ResultBlue )
        setmemblockbyte( mResult, Pos + 1, ResultGreen )
        setmemblockbyte( mResult, Pos + 2, ResultRed )
        setmemblockbyte( mResult, Pos + 3, 255 )
 
    next Pos
 
    iResult = CreateImageFromMemblock( mResult )
 
    deletememblock( mUpper )
    deletememblock( mLower )
    deletememblock( malpha )
    deletememblock( mResult )
 
endfunction iResult


function myResizeImage( Image, Width, Height )
	
    s = CreateSprite( image )
    SetSpriteSize( s, Width, Height )
    SetSpritePosition( s, 0, 0 )
    Render()
    i = GetImage( 0, 0, Width, Height )
    DeleteSprite( s )
    
endfunction i




////////////////////////
// MAX
function iMax( v as integer, mv as integer )
    if v > mv then exitfunction v
endfunction mv
 
function fMax( v as float, mv as float )
    if v > mv then exitfunction v
endfunction mv
 
function fMax3( a#, b#, c# )
    if (a#>b#) and (a#>c#) then exitfunction a#
    if b#>c# then exitfunction b#
endfunction c#
 
////////////////////////
// MIN
function iMin( v as integer, mv as integer )
    if v < mv then exitfunction v
endfunction mv
 
function fMin( v as float, mv as float )
    if v < mv then exitfunction v
endfunction mv
 
function fMin3( a#, b#, c# )
    if (a#<b#) and (a#<c#) then exitfunction a#
    if b#<c# then exitfunction b#
endfunction c#


Foldend




FoldStart //*************** utilities (addsprite, text, editbox) **************//

function LAG_AddSprite(img,x,y,w,h,fix,depth)

    //if GetSpriteExists(sprite) = 0
        sprite = CreateSprite(img)
    //endif
    SetSpritePosition(sprite, x, y)
    SetSpriteDepth(sprite, depth)
    FixSpriteToScreen(sprite, fix)
    
    if w>-1 and h>-1
		SetSpriteSize(sprite, w, h)
	endif
	
endfunction sprite


Function LAG_CreateTExt(txt$,x,y,depth,fix,h)

    txt = CreateText(txt$)
    SetTextPosition(txt,x,y)
    SetTextDepth(txt,depth)
    FixTextToScreen(txt,fix)
    SetTextSize(txt,h)
    SetTextColor(txt, LAG_TextColorR,LAG_TextColorG,LAG_TextColorB,255)
    //SetTextFontImage(txt,LAG_FontId1)
    //SetTextExtendedFontImage(txt,LAG_FontId1)

EndFunction txt


Function LAG_AddEditBox(img,x,y,w,h,fix,depth,border,txt$)

    sp = CreateEditBox()
    SetEditBoxPosition(sp,x,y+2)
    SetEditBoxDepth(sp,depth)
    SetEditBoxSize(sp,w-2,h)
    SetEditBoxTextSize(sp,16)
    //SetEditBoxFontImage(sp,LAG_FontId1)    
    //SetEditBoxExtendedFontImage(sp,LAG_FontId1)
    
    SetEditBoxBackgroundImage(sp,img)
    if img <=0
		SetEditBoxBackgroundColor(sp,255,255,255,0)
		SetEditBoxBorderColor(sp,255,255,255,0)
    endif
    SetEditBoxBorderSize(sp,border)
    FixEditBoxToScreen(sp,fix)

EndFunction sp


Foldend




//********** open file : addItemToListIcon : to add gadget item automatically for list-icon, by a folder.
Function LAg_AddItemToListIcon(folder$,ext$,gadgetId)
	
	//check the files for the folder$
	SetFolder("")
	SetFolder("media")
	SetFolder(folder$)
	
	path$ = folder$
	
	//check the file, with extension
	fn$ = GetFirstFile()
	
	/*
	if fn$<>"" 
		if (GetExtensionFile(fn$) = ext$ or ext = 1) 
			local Dim Tempfile$[0]
			Tempfile$[0]=fn$			
			n=0
		endif
	endif
	*/
	
	// local dim Tempfile$[] // old technic
	n=-1
	while fn$<>""				
		if (GetExtensionFile(fn$) = ext$) // or ext = 1)
			inc n
			// local dim Tempfile$[n] // old
			LAg_D_gadget[gadgetId].Tempfile$.length = n
			LAg_D_gadget[gadgetId].Tempfile$[n]=fn$
		endif
		fn$=GetNextFile()				
	endwhile
	
	// on remet les folder comme il faut :)
	SetFolder("")
	SetFolder("media")
	
	
	// verify if file$ <> ""
	/*
	For i=0 to file$.length
		if file$[i] =""
			File$.remove(i)
			i=i-1
		endif
	next
	*/
	
	// the image for the gadget
	//local Dim TempImg[n]
	LAg_D_gadget[gadgetId].TempImg.length = n
	for i=0 to n
		if GetImageExists(LAg_D_gadget[gadgetId].TempImg[i])
			DeleteImage(LAg_D_gadget[gadgetId].TempImg[i])
		endif
	next
	
	nbitem = LAG_D_Gadget[GadgetId].NbGadgetItem // to know how much gadgetitem the gadge has
	
	For i=0 to LAg_D_gadget[gadgetId].TempFile$.length	
		Desc$ = LAg_D_gadget[gadgetId].TempFile$[i]
		name$ = GetFilePart(LAg_D_gadget[gadgetId].TempFile$[i])		
		Img$ = path$+name$+"\"+name$+".jpg"

		iF GetFileExists(img$)
			LAg_D_gadget[gadgetId].TempImg[i] = loadimage(Img$)
		else
			LAg_D_gadget[gadgetId].TempImg[i] =0
		endif		
		LAG_AddGadgetItem(gadgetId,i+nbitem,Desc$,LAg_D_gadget[gadgetId].TempImg[i])
	next
	
	// *******  note : don't forget to use : LAg_FreeItemFromList() to free all the gadgetItem of the gadget  ******* // 
	//Undim TempFile$[] 
	//undim TempImg[] 
	
	
EndFunction

Function LAG_FreeItemFromList(gadgetId)
	
	//message("le gadget sur lequel on vire les items : "+str(gadgetId))
	For i=0 to LAg_D_gadget[gadgetId].TempFile$.length
		Lag_FreeGadgetItem(gadgetId,i)
		LAg_D_gadget[gadgetId].TempFile$[i]=""
		DeleteImage(LAg_D_gadget[gadgetId].TempImg[i])
		// puis, on supprime l'element de l'array du gadget
		LAg_D_gadget[gadgetId].TempFile$.remove(i)
		LAg_D_gadget[gadgetId].TempImg.remove(i)
		dec i
	Next
	
	LAG_D_Gadget[GadgetId].NbGadgetItem = 0
	LAG_d_Gadget[GadgetId].CurY =0
	
	//Undim TempFile$[] 
	//undim TempImg[] 
	LAg_D_gadget[gadgetId].TempFile$.length = -1
	LAg_D_gadget[gadgetId].TempImg.length = -1
	
endfunction

Function LAg_AddItemFileToListIcon(gadgetId,file$,separator$,index)

	if GetFileExists(File$)
		
		
		// local dim Tempfile$[]
		// the image for the gadget
		LAg_D_gadget[gadgetId].Tempfile$.length = -1
	
		fil = OpenToRead(file$)
		n =-1
		while FileEOF(fil)=0
			
			fn$ = ReadLine(fil)
			if fn$ <> ""
				inc n
				//local dim Tempfile$[n]
				LAg_D_gadget[gadgetId].Tempfile$.length = n
				//local Dim TempImg[n]
				LAg_D_gadget[gadgetId].TempImg.length = n
				LAg_D_gadget[gadgetId].TempImg[n] =0 // no image
				LAg_D_gadget[gadgetId].Tempfile$[n]=GetStringToken(fn$,separator$,index)
			endif
			
		endwhile
		
		closefile(fil)
		
		
		nbitem = LAG_D_Gadget[GadgetId].NbGadgetItem // to know how much gadgetitem the gadge has
		For i=0 to LAg_D_gadget[gadgetId].TempFile$.length	
			Desc$ = LAg_D_gadget[gadgetId].TempFile$[i]
			LAG_AddGadgetItem(gadgetId,i+nbitem,Desc$,LAg_D_gadget[gadgetId].TempImg[i])
		next
	else
		message("file doesn't exists : "+file$)	
	endif



EndFunction





//********** Openfile savefile requester

Function LAG_updateListFolder(DefaultFolder$, pattern$, position, x, y, w, h)
	
	
	
	// To update the list of folder of a list view// pour updater la liste des fichiers d'une listview
	
	// je place le bon dossier
	if DefaultFolder$ = ""
		DefaultFolder$ = "models"
	endif
		
	//** the folders
	SetFolder("")
	SetFolder("media")
		
	SetFolder(GetStringToken(DefaultFolder$,"/",1))
	
	// create folder
	
	// add a folder name ".." if we want to be back to this folder 
	local dim Folder$[0]
	Folder$[0] = "."
	
	fn$ = GetFirstFolder()
	while fn$<>""
				
		if fn$ <> ""
			inc n
			local dim Folder$[n]
			Folder$[n]=fn$
		endif
		
		fn$ = GetNextFolder()
			
	endwhile
	
	if n > GetFolderCount()+1
		n = GetFolderCount()+1
		local dim Folder$[n]
	endif
	n = Folder$.length	
	Dim SpFolder[n]
	Dim TextFolder[n]
		
		
	// delete
	/*	
	For i=0 to Folder$.length
		if Folder$[i] = ""
			Folder$.remove(i)
			dec i
		endif
	next 
	*/
	
	// Size of sprite
	w6 = w
	h6 = h
	
	// create the folder sprite & text
	For i=0 to Folder$.length
	
		if Folder$[i] <> ""
			SpFolder[i] = CreateSprite(0)
			j = SpFolder[i]
			SetSpriteSize(j,250,20)
			SetSpritePosition(j,x,y+(1+i)*22) 		
			SetSpriteColor(j,60,60,60,255)
			SetSpriteDepth(j,1)
			SetSpriteScissor(j,x,y+2,x+w6-20,y+h6)
			FixSpriteToScreen(j,1)
			
			TextFolder[i] = CreateText(Folder$[i])
			j = TextFolder[i]
			SetTextPosition(j,x,y+2+(1+i)*22)
			SetTextSize(j,15)
			SetTExtDepth(j,1)
			SetTextScissor(j,x,y+2,x+w6-50,y+h6)
			FixTExtToScreen(j,1)
			
		endif
		
	next
	
	SetFolder("")
	SetFolder("media")
	
EndFunction n

Function LAG_updateList(DefaultFiles$, Pattern$, position, x, y, w, h, view)
	
	
	w6 = w : h6 = h
	
	// pour updater la liste des fichiers d'une listview
	if position <= 0
		position = 2
	endif	
	ext$ = GetStringToken(Pattern$, "|", position)
	nbExt = CountStringTokens(pattern$, ";")
	
	if ext$ = "*.*" or ext$ = ""
		
		ext = 1
		ext$ = "age"
		ext$ = ReplaceString(ext$,"*","",-1)
		ext$ = ReplaceString(ext$,".","",-1)
		
	elseif nbExt > 0
		
		dim Ext_$[NbExt]
		For i =0 to ext_$.length
			ext_$[i] = GetStringToken(ext$, ";", 1+i)
			ext_$[i] = ReplaceString(ext_$[i],"*","",-1)
			ext_$[i] = ReplaceString(ext_$[i],".","",-1)
		next
		ext = 2
		
	else
		
		ext$ = ReplaceString(ext$,"*","",-1)
		ext$ = ReplaceString(ext$,".","",-1)
		
	endif
		
	// je place le bon dossier
	if DefaultFiles$ = ""
		DefaultFiles$ = "scenes"
	endif
		
	
	Foldstart //***  check the default File
	
	SetFolder("")
	SetFolder("media")	
	SetFolder(DefaultFiles$)
	
	
	// puis, on vérifie les fichiers
	fn$ = GetFirstFile()
	
	if fn$="" // on vérifie les folders
		//fn$ = GetFirstFolder()
		//if fn$ <> ""
			//local Dim file$[0]
			//file$[0]=fn$			
			//n=0
		//endif
	else
		
		if ext = 2 // several extension possible
			
			For i=0 to ext_$.length
				if (GetExtensionFile(fn$) = ext_$[i] ) and fn$ <> ""
					local Dim file$[0]
					file$[0]=fn$			
					n=0
					exit
				endif
			next
			
		else // just 1 extension
		
			if (GetExtensionFile(fn$) = ext$ or ext = 1) and fn$ <> ""
				local Dim file$[0]
				file$[0]=fn$			
				n=0
			endif
		
		endif
	endif
	
	while fn$<>""
		
		fn$=GetNextFile()	
		
		if ext = 2 // several extension possible
			
			For i=0 to ext_$.length
				if (GetExtensionFile(fn$) = ext_$[i] ) and fn$ <> ""
					inc n
					local dim file$[n]
					file$[n]=fn$
					exit
				endif
			next
			
		else // just 1 extension
							
			if (GetExtensionFile(fn$) = ext$ or ext = 1) and fn$ <> ""
				inc n
				local dim file$[n]
				file$[n]=fn$
			endif
			
		endif
	
	endwhile
	
	// on remet les folder comme il faut :)
	SetFolder("")
	SetFolder("media")
	
	Foldend
	
	
	// verify if file$ <> ""
	For i=0 to file$.length
		if file$[i] =""
			File$.remove(i)
			i=i-1	
		endif
	next
	
	// on crée sprite et text des fichiers	
	n = file$.length
	Dim SpFile[]
	Dim TxtFile[]
	h3 = 20
	if view =1
		k = IconFile.length
		for j =0 to k
			DeleteImage(500+j)
		next
		Dim IconFile[]
		Dim IconFile[n]
		nx = 64
		h3 = 64
	endif
	
	Dim SpFile[n]
	Dim TxtFile[n]
	
	hop = 200
	
	For i=0 to SpFile.length
	
		if file$[i] <> ""
			
			y1 = y+i*(h3+2)
			x1 = x
			//create sprite for select
			SpFile[i] = CreateSprite(0)
			j = SPFile[i]
			SetSpriteSize(j,w6-20,h3)
			SetSpriteOffset(j,0,0)
			SetSpritePosition(j,x1+nx,y1) 		
			SetSpriteColor(j,60,60,60,255)
			SetSpriteDepth(j,1)
			SetSpriteScissor(j,x1,y,x+w6-28,y+h6)
			FixSpriteToScreen(j,1)
			
			// create the preview icon
			if view = 1
				
				ext1$ = GetExtensionFile(file$[i])
				
				zeFile$ = ReplaceString(file$[i], "."+ext1$, "", 1)
				
				FinalFile$ = DefaultFiles$ + zeFile$ + ".jpg"	
				// message(zeFile$+" | "+ext1$+" | "+FinalFile$)
				
				// loadimage for preview
				img = 0
				if GetFileExists(FinalFile$)
					LoadImage(500+i,FinalFile$)
					img = 500+i	
				endif
							
				iconFile[i] = CreateSprite(img)
				j = iconFile[i]
				SetSpriteOffset(j,0,0)
				SetSpriteSize(j,h3,h3)
				SetSpritePosition(j,x1-2,y1)		
				SetSpriteDepth(j,0)
				SetSpriteScissor(j,x1,y,x+w6-20,y+h6)
				FixSpriteToScreen(j,1)
				
			endif
			
			// the text of the file
			TxtFile[i] = CreateText(file$[i])
			j = TxtFile[i]
			SetTextPosition(j,x1+nx,y+2+i*(h3+2))
			SetTextSize(j,15)
			SetTExtDepth(j,1)
			SetTextScissor(j,x1,y,x+w6-50,y+h6)
			SetTextLineSpacing(j,4)
			FixTextToScreen(j,1)
		endif
	next

	undim file$[]

Endfunction n

Function LAg_FreeList(view)
	
	For i= 0 to SpFile.length
		if view =1
			DeleteSprite(iconFile[i])
		endif
		DeleteSprite(SpFile[i])
		DeleteText(TxtFile[i])
	next
	
		
	Dim SpFile[]
	Dim TxtFile[]
	Dim file$[]
	
	undim file$[]
	undim SpFile[]
	unDim TxtFile[]
	
	if View
		n = IconFile.length
		unDim IconFile[]
		for i =0 to n
			DeleteImage(500+i)
		next
	endif
	
EndFunction






Function LAG_OpenFile(Title$, DefaultFiles$, Pattern$, Position, width, height, view)

	
	/*
	Title$ : title of the window
	DefaultFiles$ : defaultfile 
	Pattern$ : the pattern is the extension to open  = "name$|extension$|name2$|extension2$|" , exemple : "Model FPE|*.fpe|3D Files|*.dae;*.x;*.obj|Dae|*.dae|X|*.x|Obj|*.obj"
	
	Position : the position in extension pattern
	width : of the window
	height : of the window
	view : what are the icon : 0 = just a list (no icon), 1 = see icons
	
	
	*/
	
	
	
	
	FoldStart // OpenFileRequester
	
	FreeToolTips()
	
		FoldStart // create The UI & list of files  to choose
		
		
		FoldStart // create the sprite and text 
		
		if width = -1
			width = 600
		endif
		if height=-1
			height = 400
		endif
		
		// The images
		MessageBtn2 =  LAG_i_Gadget[LAG_C_IFILEPREV] 
		MessageBtn1 =  LAG_i_Gadget[LAG_C_iBUTTON] 
		MessageBtn =  LAG_i_Gadget[LAG_C_IBUTTON_C] 
		Ascen =  LAG_i_Gadget[LAG_C_IASCENSOR] 

		zeW = G_width*0.5 +GetScreenBoundsLeft()
		zeH = G_height*0.5 +GetScreenBoundsTop()
		
		
		
		// the background sprite 
		i1 = LAG_CreateMenuBox(ZeW-width/2-5, zeH-height/2-45, width+10, height+50, LAG_C_ICORNER, 255)
		fond = LAG_GetMenuboxSprite(i1)		
		LAG_SetMenuBoxColor(i1,180,180,180)
		nmb=0
		
		i2 = LAG_CreateMenuBox(ZeW-width/2, zeH-height/2, width, height, LAG_C_ICORNER, 255) : inc nmb 
		Menu = LAG_GetMenuboxSprite(i2)
		x = GetSpriteX(Menu)+190
		y = GetSpriteY(Menu)+50
		a=6
		
		
		// the background for the files
		w6 = width-220
		h6 = height-200
		i3 = LAG_CreateMenuBox(x-a, y-a, w6+a*2, h6+a*2, LAG_C_ICORNER2, 255) : inc nmb 
		FileList = LAG_GetMenuboxSprite(i3)
		
		g = 19
		w5 = 5
		b = 30-g
		Ascensor = Lag_AddSprite2(Ascen,x+w6-w5-w1*2-25,y-a+2,1,0)
		SetSpriteSize(Ascensor,g+b,h6+a*2-4)
		BtnUp = Lag_AddSprite2(MessageBtn1,x+w6-w5-w1*2-25+b/2,y-a+4,1,0)
		SetSpriteSize(BtnUp,g,g)
		BtnDown = Lag_AddSprite2(MessageBtn1,x+w6-w5-w1*2-25+b/2,y-a+h6-g+8,1,0)
		SetSpriteSize(BtnDown,g,g)
		
		
		
		FoldStart // Folder list
			
		w = 150
		x1 = x-a-w-20 
		y1 = GetSpriteY(Menu)+10 //y-a 
		w7 = w+a*2 
		h7 = h6 + a*2 
		i4 = LAG_CreateMenuBox(x1, y1, w7, h7, LAG_C_ICORNER2, 255) : inc nmb 
		FolderList = LAG_GetMenuboxSprite(i4) 
		// to know the sprite of the menubox, to free the menubox at the end of the function
		
		
		g = 19
		w5 = 5
		b = 30-g
		x2 = x1+w7-35
		Ascensor_Folder = Lag_AddSprite2(Ascen,x2,y1+2,1,0)
		SetSpriteSize(Ascensor_Folder,g+b,h7-4)
		BtnUp_Folder = Lag_AddSprite2(MessageBtn1,x2+b/2,y1+2,1,0)
		SetSpriteSize(BtnUp_Folder,g,g)
		BtnDown_Folder = Lag_AddSprite2(MessageBtn1,x2+b/2,y1+2+h7-g-4,1,0)
		SetSpriteSize(BtnDown_Folder,g,g)
		
		
		// size for the folder sprite
		hhf = 22
		
		i5 = LAG_CreateMenuBox(x1, y1+h7+10, w7, height-h7-30, LAG_C_ICORNER2, 255) : inc nmb 
		SurfacePreview = LAG_GetMenuboxSprite(i5) 
		
		// ObjPreview = CreateObjectBox(10,10,10)
		// SetObjectPosition(ObjPreview,
		
		
		
		Foldend
		
		
		FoldStart // create editobox for filename
		w8 = 100
		w = w6 -w8-a*4
		NameFile = CreateEditBox()
		SetEditBoxPosition(NameFile,x-a, y+h6+a*2)
		SetEditBoxSize(NameFile, w+a*2, 20+a)
		SetEditBoxBackgroundImage(NameFile,LAG_i_Gadget[LAG_C_ISTRING])
		SetEditBoxDepth(NameFile,1)
		SetEditBoxTextColor(NameFile,LAG_TextColorR,LAG_TextColorG,LAG_TextColorB)
		SetEditBoxTextSize(NameFile,18)
		FixEditBoxToScreen(NameFile,1)
		
		// pattern (extension file par exemple)
		local MessageBtn1,w1,h1,h2,btnok,btnNo,btnCancel,txt2,txt3,txt4 as integer

		FontId = LAG_FontId2
		w1 = GetImageWidth(MessageBtn1)+20
		h1 = 40
		h2 = GetImageHeight(MessageBtn1)
		
		Foldend
		
		
		// Boutons - buttons
		FoldStart // pattern (extension choice)
		
		//i5 = LAG_CreateMenuBox(x-a+w+a*2+5, y+h6+a*2-2, w8+a*2, 20+a*2, LAG_C_ICORNER2, 255) : inc nmb 
		//Pattern = LAG_GetMenuboxSprite(i)
		xp1 = x-a+w+a*2+5
		yp1 = y+h6+a*2-2
		Pattern = Lag_AddSprite2(MessageBtn1,xp1,yp1,1,0)
		SetSpriteSize(Pattern,w1,h2)
		
		// get extension of files
		ext$ = GetStringToken(Pattern$,"|",2)
		if ext$ = "*.*" or ext$ = ""
			ext = 1
		elseif countStringTokens(ext$,";") > 0
			ext = 2
		else 
			ext$ = ReplaceString(ext$,"*","",-1)
			ext$ = ReplaceString(ext$,".","",-1)
		endif
		
		
		// Number of extension in pattern
		NbExt = (CountStringTokens(Pattern$,"|"))/2 - 1
		if NbExt<0
			NbExt = 0
		endif
		
		//text for pattern button
		PatternTxt = LAG_AddTextFix(GetSpriteX(Pattern)+GetSpriteWidth(Pattern)/2,GetSpriteY(Pattern)+5,ext$,FontId,20,0)
		SetTextAlignment(PatternTxt, 1)
		
		
		
		
		Foldend
		

		Foldstart // btn ok, cancel
		btnok = Lag_AddSprite2(MessageBtn1,GetSpriteX(Menu)+width-w1*2-25,GetSpriteY(Menu)+height-40,1,0)
		SetSpriteSize(btnok,w1,h2)
		btnNo = Lag_AddSprite2(MessageBtn1,GetSpriteX(Menu)+width-20-w1, GetSpriteY(Menu)+height-40,1,0)
		SetSpriteDepth(btnNo,0)
		SetSpriteSize(btnNo,w1,h2)
		
		// texts					
		txt2 = LAG_AddTextFix(GetSpriteX(btnok)+GetSpriteWidth(btnok)/2,GetSpriteY(btnok)+5,"OK",FontId,20,0)
		SetTextAlignment(txt2, 1)
		txt3 = LAG_AddTextFix(GetSpriteX(btnNo)+GetSpriteWidth(btnNo)/2,GetSpriteY(btnNo)+5,"CANCEL",FontId,20,0)
		SetTextAlignment(txt3, 1)
	
		Foldend
		
		
		FoldStart // buttons for preview
		u = 32 +10
		btnPreview64 = Lag_AddSprite2(MessageBtn2,x,y-u,1,0) 
		btnPreview32 = Lag_AddSprite2(MessageBtn2,x+34,y-u,1,0) 
		btnPreview16 = Lag_AddSprite2(MessageBtn2,x+34*2,y-u,1,0)
		btnPreviewAr = Lag_AddSprite2(MessageBtn2,x+34*3,y-u,1,0) 
		SetSpriteAnimation(btnPreview64,32,32,4) : SetSpriteFrame(btnPreview64,1) : SetSpriteSize(btnPreview64,32,32) 
		SetSpriteAnimation(btnPreview32,32,32,4) : SetSpriteFrame(btnPreview32,2) : SetSpriteSize(btnPreview32,32,32)
		SetSpriteAnimation(btnPreview16,32,32,4) : SetSpriteFrame(btnPreview16,3) : SetSpriteSize(btnPreview16,32,32)
		SetSpriteAnimation(btnPreviewAr,32,32,4) : SetSpriteFrame(btnPreviewAr,4) : SetSpriteSize(btnPreviewar,32,32)

		Foldend
		
		
		// title		
		txttitle = LAg_AddTextFix(GetSpriteX(Fond)+width/2,GetSpriteY(Fond)+5,title$,FontId,30,0)
		SetTextAlignment(txttitle,1)
		
		Foldend 
		
		
		FoldStart //***  paths for files & list of files in folder
		
		Path$ = GetPathPart(DefaultFiles$)
		if path$ = ""
			path$ = DefaultFiles$
		endif
		Path1$ = GetPathPart(DefaultFiles$)
		if path1$ = ""
			path1$ = DefaultFiles$
		endif
		
		//Message("path : "+Path$)
		//Message("path1 : "+Path1$)
		
		
		// *** update the list folder and icon
		n1 = LAG_updateListFolder(DefaultFiles$, Pattern$, 2, x1+5, y1, w7-10, h6)
		n = LAG_UpdateList(DefaultFiles$, Pattern$, 2, x, y, w6, h6, view)
		
		OldFolderId = -1
		
		// height for the file sprite
		hh = 22
		if view =1
			hh = 66
			nx = 64
		endif
		move = 0
		ww = w6-25	
		
		
		Foldend
		
		
		
		// to select multi file
		dim File_ToLoad$[] 
		
		Foldend
			
			
			
			
			
			
		repeat
			
			GetScreenBoundEditor()
			
			If GetRawKeyReleased(KEY_ESCAPE)
				quit = 1
			elseif GetRawKeyReleased(KEY_Enter)
				quit = 2
			endif
			
			FoldStart // mouse 	(x,y, press,state	
			mx = ScreenToWorldX(GetPointerX())
			my = ScreenToWorldY(GetPointerY())
			
			If GetRawKeyPressed(KEY_Shift)
				Shift_OF = 1
			endif
			if GetRawKeyReleased(KEY_Shift)
				Shift_OF = 0
			endif
			
			If GetRawKeyPressed(KEY_CONTROL)
				Ctrl_OF = 1
			endif
			if GetRawKeyReleased(KEY_CONTROL)
				Ctrl_OF = 0
			endif
			
			FoldStart // multi select or deselect
			if Ctrl_OF = 1
				If GetRawKeyPressed(KEY_A)
					Multi_OF = 1
					File_ToLoad$.length = -1
					For i=0 to SpFile.length
							
						SetSpriteColor(SpFile[i],120,120,120,255)
						IdFile= i
						
						FileToLoad$ = path$ + GetTextString(TxtFile[i])
						
						//add to dim file_toload (multi-opening)
						ftl = File_ToLoad$.length +1
						File_ToLoad$.length = ftl
						File_ToLoad$[ftl] = FileToLoad$
						
						//set text
						SetEditBoxText(NameFile,GetTextString(TxtFile[i]))
						
					next 		
					
				endif
				If GetRawKeyPressed(KEY_D)
					Multi_OF = 0
					File_ToLoad$.length = -1
					For i=0 to SpFile.length
						SetSpriteColor(SpFile[i],60,60,60,255)
					next
				endif
			endif
				
			Foldend
				
				
			if GetPointerPressed() = 1
				
				butonTest = GetSpriteHit(mx,my)
				
				if butonTest = BtnOk
					SetSpriteImage(BtnOk,MessageBtn)
				elseif butonTest = BtnNo
					SetSpriteImage(BtnNo,MessageBtn)
				elseif butonTest = BtnUp
					SetSpriteImage(BtnUp,MessageBtn)					
					move =1
				elseif butonTest = BtnDown
					SetSpriteImage(BtnDown,MessageBtn)					
					move =-1
				elseif butonTest = BtnUp_Folder
					SetSpriteImage(BtnUp_Folder,MessageBtn)					
					moveF =1
				elseif butonTest = BtnDown_Folder
					SetSpriteImage(BtnDown_Folder,MessageBtn)					
					moveF =-1
				endif
				
			endif
			
			If GetPointerState()
				
				FoldStart // move file or folder
				
				// move file
				if Move <> 0
					pos= pos+move*10
					dir = move*10
					if move = 1
						if pos > 0
							pos = 0
							dir = 0						
						endif
					else
						if pos < -((SpFile.length)*hh ) 
							pos = -((SpFile.length)*hh )
							dir =0
						endif
					endif
				
					For i=0 to SpFile.length
						j = SPFile[i]			
						SetSpritePosition(j,GetSpriteX(j),GetSpriteY(j)+dir) 
						if view = 1
							j2 = iconFile[i]	
							SetSpritePosition(j2,GetSpriteX(j2),GetSpriteY(j2)+dir) 	
						endif
						j = TxtFile[i]
						SetTextPosition(j,GetTextX(j),GetTextY(j)+dir)
					next
					
				endif
				
				// mode folder
				if MoveF <> 0
					posF= posF+moveF*10
					dir = moveF*10
					if moveF = 1
						if posF > 0
							posF = 0
							dir = 0						
						endif
					else
						if posF < -((SpFolder.length-2) * hhf ) 
							posF = -((SpFolder.length-2) * hhf )
							dir =0
						endif
					endif
				
					For i=0 to SpFolder.length
						j = SpFolder[i]			
						SetSpritePosition(j,GetSpriteX(j),GetSpriteY(j)+dir) 
						/*
						if view = 1
							j2 = iconFolder[i]	
							SetSpritePosition(j2,GetSpriteX(j2),GetSpriteY(j2)+dir) 	
						endif
						*/
						j = TextFolder[i]
						SetTextPosition(j,GetTextX(j),GetTextY(j)+dir)
					next
					
				endif
				
				foldend
			
			endif
			
			Foldend
			
			//print(str(pos)+"/"+str((SpFile.length)*22 -h6 ))
				
			if GetPointerReleased() = 1
				
				move =0
				butonTest = GetSpriteHit(mx,my)
				
				SetSpriteImage(BtnOk,MessageBtn1)
				SetSpriteImage(BtnNo,MessageBtn1)
				SetSpriteImage(BtnUp,MessageBtn1)
				SetSpriteImage(BtnDown,MessageBtn1)
				
				if butonTest = BtnOk					
					quit = 2
				elseif butonTest = BtnNo					
					quit = 1					
				
				FoldStart // change pattern (extension)
				
				elseif butonTest = Pattern
				
					inc ExtId
					if ExtId > NbExt
						ExtId = 0
					endif
					position = 2*ExtId+2
					ext$ = GetStringToken(Pattern$,"|",position)
					if ext$ = "*.*" or ext$ = ""
						ext = 1
					elseif countStringTokens(ext$,";") > 0
						ext = 2
					else 
						ext$ = ReplaceString(ext$,"*","",-1)
						ext$ = ReplaceString(ext$,".","",-1)
					endif
					ext1$ = GetStringToken(Pattern$,"|",2*ExtId+1)
					SetTextString(PatternTxt, ext1$)
					
					// delete folders
					For i= 0 to SpFolder.length
						DeleteSprite(SpFolder[i])
						DeleteText(TextFolder[i])
					next
					Undim SpFolder[]
					Undim TextFolder[]
					// delete list of file
					LAg_FreeList(view)
					
					// create folder and list of file again
					n1 = LAG_updateListFolder(DefaultFiles$, Pattern$, position, x1+5,y1, w7-10, h6)
					n = LAG_UpdateList(DefaultFiles$, Pattern$, position, x, y, w6, h6, view)

				Foldend
				
				FoldStart // on change le preview des fichier	
				
				elseif butonTest = btnPreview64					
					nx = 64
					hh = nx+2					
					For i=0 to SpFile.length
						j = SPFile[i]			
						SetSpritePosition(j,x,y+i*hh+pos)
						SetSpriteSize(j,ww,nx)
						x1 = x
						if view = 1
							j = iconFile[i]							
							SetSpritePosition(j,x,y+i*hh+pos)
							SetSpriteSize(j,nx,nx) 	
						endif						 
						j = TxtFile[i]
						SetTextPosition(j,x+nx+12,y+2+i*hh+pos)
						SetTextMaxWidth(j,ww-nx-10)
						SetTextSize(j,16)
					next
				
				elseif butonTest = btnPreview32					
					nx = 32
					hh = nx+2				
					For i=0 to SpFile.length
						j = SPFile[i]			
						SetSpritePosition(j,x,y+i*hh+pos)
						SetSpriteSize(j,ww,nx)						 
						if view = 1
							j = iconFile[i]	
							SetSpritePosition(j,x,y+i*hh+pos)
							SetSpriteSize(j,nx,nx) 	
						endif
						j = TxtFile[i]
						SetTextPosition(j,x+nx+12,y+2+i*hh+pos)
						SetTextMaxWidth(j,ww-nx-10)
						SetTextSize(j,15)						
							
					next
				
				elseif butonTest = btnPreview16					
					nx = 16
					hh = nx+ 2
					For i=0 to SpFile.length
						j = SPFile[i]			
						SetSpritePosition(j,x,y+i*hh+pos)
						SetSpriteSize(j,ww,nx)						 
						if view = 1
							j = iconFile[i]	
							SetSpritePosition(j,x,y+i*hh+pos)
							SetSpriteSize(j,nx,nx) 	
						endif	
						j = TxtFile[i]
						SetTextPosition(j,x+nx+12,y+2+i*hh+pos)
						SetTextMaxWidth(j,ww-nx-10)
						SetTextSize(j,12)						
												
					next
				
				elseif butonTest = btnPreviewAr
					nx = 64
					hh = nx + 48 // size of the icone + marge
					n1 = w6 
					n1 = (w6 / hh) // the max number of image, by line
					
										
					For i=0 to SpFile.length
						yy2 = i
						yy2 = ceil(yy2/n1)
						y_1 = y + yy2*hh -2
						
						x_1 = x + mod(i,n1)*hh
						
						j = SPFile[i]	
						SetSpritePosition(j,x_1,y_1)
						SetSpriteSize(j,hh,hh)
						if view = 1
							j = iconFile[i]	
							SetSpritePosition(j,x_1+(hh-nx)*0.5,y_1+4)
							SetSpriteSize(j,nx,nx) 	
						endif
											 
						j1 = TxtFile[i]
						SetTextPosition(j1,x_1+12,y_1+nx+5)					
						SetTextMaxWidth(j1,hh)
						SetTextSize(j1,12)
													
					next
				
				foldend
					
				else
					// on clique sur un des dossier
					IdFile = -1
					For i=0 to SpFolder.length
						SetSpriteColor(SpFolder[i],60,60,60,255)
					next		
					For i=0 to SpFolder.length
						if butonTest = SpFolder[i]
							SetSpriteColor(SpFolder[i],120,120,120,255)
							IdFile= i
							if OldFolderId <> IdFile
								OldFolderId = IdFile
								// free all previous file
								For j= 0 to SpFile.length
									if view =1
										DeleteSprite(iconFile[j])
									endif
									DeleteSprite(SpFile[j])
									DeleteText(TxtFile[j])
								next
								
								
								// create the new file
								gt$ = GetTextString(TextFolder[i])+"/"
								if gt$ = "./"
									gt$ = ""
								endif
								path$ = path1$+ gt$
								// message("path : "+path$+" | pattern :"+pattern$)								
								LAG_updateList(path$,Pattern$,position,x,y,w6,h6,view)
								pos=0
							endif
							exit
						endif
					next
					
					// on clique sur un des fichiers
					if IdFile =-1
						IF Shift_OF = 0
							File_ToLoad$.length = -1
							For i=0 to SpFile.length
								SetSpriteColor(SpFile[i],60,60,60,255)
							next
						endif	
							
						For i=0 to SpFile.length
							if view = 1
								if butonTest = SpFile[i] or butonTest = iconFile[i]
									SetSpriteColor(SpFile[i],120,120,120,255)
									IdFile= i
									
									FileToLoad$ = path$ + GetTextString(TxtFile[i])
									
									//add to dim file_toload (multi-opening)
									ftl = File_ToLoad$.length +1
									File_ToLoad$.length = ftl
									File_ToLoad$[ftl] = FileToLoad$
									
									//set text
									SetEditBoxText(NameFile,GetTextString(TxtFile[i]))
									exit
								endif
							else
								if butonTest = SpFile[i] 
									
									SetSpriteColor(SpFile[i],120,120,120,255)
									IdFile= i
									FileToLoad$ = path$ + GetTextString(TxtFile[i])
									
									//add to dim file_toload (multi-opening)
									ftl = File_ToLoad$.length +1
									File_ToLoad$.length = ftl
									File_ToLoad$[ftl] = FileToLoad$
									
									// set text
									SetEditBoxText(NameFile,GetTextString(TxtFile[i]))
									exit
								endif
							endif
						next
					endif
									
				endif
			endif
					
			
			sync()
		until quit>=1
			
			
			
			
			
	
			
		foldstart  // free ressources
		
		// doc.FileName$ = GetEditBoxText(editbox)
		
		DeleteSprite(BtnOk)
		DeleteSprite(BtnNo)
		DeleteSprite(BtnDown)
		DeleteSprite(BtnUp)
		DeleteSprite(Ascensor)
		
		DeleteSprite(Ascensor_Folder)
		DeleteSprite(BtnDown_Folder)
		DeleteSprite(BtnUp_Folder)
		
		DeleteSprite(btnPreviewAr)
		DeleteSprite(btnPreview16)
		DeleteSprite(btnPreview32)
		DeleteSprite(btnPreview64)
		DeleteText(txt3)
		DeleteText(txt2)
		DeleteText(txttitle)
		
		DeleteSprite(Pattern)
		DeleteText(PatternTxt)	
		
		// DeleteObject(ObjPreview)
        
		DeleteEditBox(NameFile)
		
		// DeleteEditBox(editbox)
		LAG_FreeMenuBox(i1)
		LAG_FreeMenuBox(i2)
		LAG_FreeMenuBox(i3)
		LAG_FreeMenuBox(i4)
		LAG_FreeMenuBox(i5) // ObjPreview
		
		// LAG_FreeMenuBox(i5)
		
		// delete the folder sprite & text
		For i= 0 to SpFolder.length
			DeleteSprite(SpFolder[i])
			DeleteText(TextFolder[i])
		next
		
		Undim SpFolder[]
		Undim TextFolder[]
		// undim File_ToLoad$[] 
		
		LAg_FreeList(view)
		
		foldend
	
	FoldEnd
	

	FileName$ = ""
	
	if Quit = 2
			
		FileName$ = FileToLoad$ // Path$+File$[IdFile]
		// message(filename$)
	endif

	
	
	
EndFunction FileName$

Function LAG_SaveFile(Title$, DefaultFolder$, DefaultFile$)
	
	Filename$ = ""
	
	FreeToolTips()
	
	
	
	
	FoldStart // savefilerequester : create the interface & repeat & free ressources
	
		FoldStart // create the sprite and text 
		
		zeW = G_width/2+ GetScreenBoundsLeft()
		zeH = G_Height/2+ GetScreenBoundsTop()
		
		width = 400
		height = 200
		a =5 : b = 45
		i1 = LAG_CreateMenuBox(zeW-width/2-a, zeH-height/2-b, width+a*2, height+b+a, LAG_C_ICORNER, 255)
		Fond = LAG_GetMenuboxSprite(i1)	
		
		LAG_SetMenuBoxColor(i1,180,180,180)
		
		i2 = LAG_CreateMenuBox(zeW-width/2, zeH-height/2, width, height, LAG_C_ICORNER, 255)
		Menu = LAG_GetMenuboxSprite(i2)	
		
		// Boutons - buttons
		local MessageBtn1,MessageBtn,w1,h1,h2,btnok,btnNo,btnCancel,txt2,txt3,txt4 as integer

		FontId = LAG_FontId2
		MessageBtn1 =  LAG_i_Gadget[LAG_C_IBUTTON] 
		MessageBtn =  LAG_i_Gadget[LAG_C_IBUTTON_C] 
		w1 = GetImageWidth(MessageBtn1)+20
		h1 = 40
		h2 = GetImageHeight(MessageBtn1)
		
		btnok = Lag_AddSprite2(MessageBtn1,GetSpriteX(Menu)+width/2-w1-2,GetSpriteY(Menu)+height-40,1,0)
		SetSpriteSize(btnok,w1,h2)
		btnNo = Lag_AddSprite2(MessageBtn1,GetSpriteX(Menu)+width/2+2, GetSpriteY(Menu)+height-40,1,0)
		SetSpriteDepth(btnNo,0)
		SetSpriteSize(btnNo,w1,h2)
		
		// texts					
		txt2 = LAG_AddTextFix(GetSpriteX(btnok)+GetSpriteWidth(btnok)/2,GetSpriteY(btnok)+5,"OK",FontId,20,0)
		SetTextAlignment(txt2, 1)
		txt3 = LAG_AddTextFix(GetSpriteX(btnNo)+GetSpriteWidth(btnNo)/2,GetSpriteY(btnNo)+5,"CANCEL",FontId,20,0)
		SetTextAlignment(txt3, 1)
		
		
		// title
		// title$ = "Save the document"
		txttitle = LAg_AddTextFix(GetSpriteX(Menu)+width/2,GetSpriteY(Fond)+5,title$,FontId,30,0)
		SetTextAlignment(txttitle,1)


		img = LAG_i_Gadget[LAG_c_iString]
		w = 200
		h = 25
		y = GetSpriteY(Menu)+50
		x = GetSpriteX(Menu)+width/2-w/2
		Editbox = LAG_AddEditBox(img,x,y,w,h,1,0,1,"")
		SetEditBoxText(EditBox,DefaultFile$)
		SetEditBoxTextColor(Editbox,LAG_TextColorR,LAG_TextColorG,LAG_TextColorB)

		
		
		Foldend
						
		repeat
			
			GetScreenBoundEditor()
			
			If GetRawKeyPressed(KEY_ESCAPE)
				quit = 1
			elseif GetRawKeyPressed(KEY_Enter)
				quit = 2	
			endif
		
			mx = ScreenToWorldX(GetPointerX())
			my = ScreenToWorldY(GetPointerY())

			if GetPointerPressed() = 1
				butonTest = GetSpriteHit(mx,my)
				if butonTest = btnok
					SetSpriteImage(BtnOk,MessageBtn)
				elseif butonTest = btnNo
				SetSpriteImage(Btnno,MessageBtn)
				endif
			Endif
			if GetPointerReleased() = 1
				SetSpriteImage(BtnOk,MessageBtn1)
				SetSpriteImage(BtnNo,MessageBtn1)
				butonTest = GetSpriteHit(mx,my)
				if butonTest = btnok
					quit = 2					
				elseif butonTest = btnNo 
					quit = 1					
				endif	
			endif
					
			
			sync()
		until quit>=1
			
		foldstart  // free ressources
		
		FileName$ = GetEditBoxText(editbox)
		
		DeleteSprite(btnok)
		DeleteText(txt3)
		DeleteText(txt2)
		DeleteText(txttitle)	
		DeleteText(txt3)
        DeleteSprite(btnNo)
		DeleteEditBox(editbox)
		LAG_FreeMenuBox(i1)
		LAG_FreeMenuBox(i2)
		
		foldend
	
	FoldEnd		
	
	
	
	
	
EndFunction FileName$







//********** Other requester
Function Lag_InputRequester(Title$,msg$)
	
	FreeToolTips()
	
	// An input requester
	FoldStart 
	
		FoldStart // create the sprite and text 
		
	
		width = 400
		height = 200
		i = LAG_CreateMenuBox(G_width/2-width/2+ GetScreenBoundsLeft(), G_height/2-height/2+ GetScreenBoundsTop(), width, height, LAG_C_ICORNER, 255)
		Menu = LAG_GetMenuboxSprite(i)
		
		// Boutons - buttons
		local MessageBtn1,w1,h1,h2,btnok,btnNo,btnCancel,txt2,txt3,txt4 as integer

		FontId = LAG_FontId2
		MessageBtn1 =  LAG_i_Gadget[LAG_C_IBUTTON] 
		w1 = GetImageWidth(MessageBtn1)+20
		h1 = 40
		h2 = GetImageHeight(MessageBtn1)
		
		btnok = Lag_AddSprite2(MessageBtn1,GetSpriteX(Menu)+width/2-w1-2,GetSpriteY(Menu)+height-40,1,0)
		SetSpriteSize(btnok,w1,h2)
		btnNo = Lag_AddSprite2(MessageBtn1,GetSpriteX(Menu)+width/2+2, GetSpriteY(Menu)+height-40,1,0)
		SetSpriteDepth(btnNo,0)
		SetSpriteSize(btnNo,w1,h2)
		
		// texts					
		txt2 = LAG_AddTextFix(GetSpriteX(btnok)+GetSpriteWidth(btnok)/2,GetSpriteY(btnok)+5,"OK",FontId,20,0)
		SetTextAlignment(txt2, 1)
		txt3 = LAG_AddTextFix(GetSpriteX(btnNo)+GetSpriteWidth(btnNo)/2,GetSpriteY(btnNo)+5,"CANCEL",FontId,20,0)
		SetTextAlignment(txt3, 1)
		
		
		// title		
		txttitle = LAg_AddTextFix(GetSpriteX(Menu)+width/2,GetSpriteY(Menu)+5,title$,FontId,30,0)
		SetTextAlignment(txttitle,1)


		img = LAG_i_Gadget[LAG_c_iString]
		w = 200
		h = 25
		y = GetSpriteY(Menu)+50
		x = GetSpriteX(Menu)+width/2-w/2
		Editbox = LAG_AddEditBox(img,x,y,w,h,1,0,1,"")
		SetEditBoxText(EditBox,Doc.FileName$)
		SetEditBoxTextColor(EditBox,LAG_TextColorR,LAG_TextColorG,LAG_TextColorB)

		
		Foldend
						
		repeat
			
			If GetRawKeyPressed(KEY_ESCAPE)
				quit = 1
			elseif GetRawKeyPressed(KEY_Enter)
				quit = 2
			endif
		
			mx = ScreenToWorldX(GetPointerX())
			my = ScreenToWorldY(GetPointerY())

			if GetPointerReleased() = 1
				butonTest = GetSpriteHit(mx,my)
				if butonTest = btnok
					quit = 2					
				elseif butonTest = btnNo 
					quit = 1					
				endif	
			endif
					
			
			sync()
		until quit>=1
			
		foldstart  // free ressources
		
		Result$ = GetEditBoxText(editbox)
		
		DeleteSprite(btnok)
		DeleteText(txt3)
		DeleteText(txt2)
		DeleteText(txttitle)	
		DeleteText(txt3)
        DeleteSprite(btnNo)
		DeleteEditBox(editbox)
		LAG_FreeMenuBox(i)
		
		foldend
	
	FoldEnd		
		
	
EndFunction Result$





//********** draw

Function LAG_DrawRectangle(x,y,w,h)
    /*
    Drawline(x,y,x+w,y,0,0,0)
    Drawline(x,y,x,y+h,0,0,0)
    Drawline(x,y+h,x+w,y+h,0,0,0)
    Drawline(x+w,y,x+w,y+h,0,0,0)
    */
EndFunction






//********** other

Function LAG_Ignore(a,b)
	
    if b <> LAG_c_ignore
        c = b
    else
		c = a
    endif
EndFunction c



// RGB -> r,g,b
function Red(color)
    Red = mod(color, 256)
EndFunction red

function blue(color)
    blue = mod((color/256),256)
EndFunction blue

function green(color)
    green = mod((color/(256*256)), 256)
EndFunction green

Function RGB(r,g,b)
    color = r +g*256 + b*256*256
EndFunction color
