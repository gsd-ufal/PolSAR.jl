function SummaryImage(roiStart, roiHeight, roiWidth, summaryHeight, summaryWidth, datasetHeight, datasetWidth, imageID)

    index = 1   # The array in which is going to be stored the needed values from the dataset data needs and index variable different from the tipical i or j form the loops
    roiStart *= 8  # roiStart is multiplied by 8 in order to skip pixels accordingly

    roiHeight = trunc(roiHeight) # trunced in order to avoid non integer values (unnaccepted by the functions that use those variables)
    roiWidth = trunc(roiWidth)
    
    imageVector = zeros(Float64, summaryHeight*summaryWidth)

    # SETTING POINTER: Here we get the position of the last pickable pixel in the line, setting the imageID to 0 (the beginning) and then to the desired beginning of the upcomming image, then it is skiped to it's width (remember that each pixel is 8 bits), then saved for further use and finally reset to 0.

    seekstart(imageID)
    skip(imageID, roiStart)
    skip(imageID, 8*roiWidth)
    roiWidthPosition = convert(Int32, position(imageID)/8)
    seekstart(imageID)
    skip(imageID, roiStart)

    # SETTING PACES: Calculates the proportion in which the rows and columns pixels are skiped. 

    if (summaryWidth == roiWidth)
        widthPace = 0
        back = 0    # Back is needed because each access in the dataset file pixels automatically moves the pointer.
    else
        widthPace = trunc(roiWidth/summaryWidth)
        back = -8
    end

    if (summaryHeight == roiHeight)
        heightPace = 0
    else
        heightPace = trunc(roiHeight/summaryHeight)-1
    end

    heightPace  = convert(Int64, heightPace)
    widthPace = convert(Int64, widthPace)

    # FIRST LINE READING

    imageVector[index] = abs(read(imageID, Float64, 1)[1])
    index +=  1

    for (j in 1:(summaryWidth-1)) # The order in which the pixels are accessed is important
        skip(imageID, 8*widthPace)
        imageVector[index] = abs(read(imageID, Float64, 1)[1])
        index +=  1
        skip(imageID, back) # the automatical skip when the position is accessed in the dataset file is not accounted in the pace calculus
    end

    # ALL THE REMAINING LINES: After the first line is read, probably there are n != widthPace, making the continuous pace place the new line before or after it should begin to be alligned. To correct that, the moduloPosition is calculated using the modulo operation to find where the pointer is at in relation with the roiWidth, then the skipAux is calculated, taking in consideration also the heightPace, the pointer is moved, and the new line can begin alligned with the first.

    moduloPosition = convert(Int32, position(imageID)/8)
    moduloValue = roiWidthPosition % moduloPosition
    skipAux = 8*(moduloValue + (datasetWidth - roiWidth) + (heightPace*datasetWidth))
    skip(imageID, skipAux)  

    # Now that the first line is done and the number of pixels to skip in the end of every line is known the rest of the image can be done.
  
    for (i in 1:summaryHeight-1)
        imageVector[index] = abs(read(imageID, Float64, 1)[1])
        index += 1
        for (j in 1:(summaryWidth-1))
            skip(imageID, 8*widthPace)
            imageVector[index] = abs(read(imageID, Float64, 1)[1])
            index += 1
            skip(imageID, back)
        end
        skip(imageID, skipAux)
    end

	imageVector

end
