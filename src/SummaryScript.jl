module summaryScript

using Images, ImageView
    
include("ReadImage.jl")
include("PauliLocal.jl")    		# A false coloring function
include("summaryImage.jl")             # Visualization and summarying function
#include("PauliDecomposition.jl")   # A false coloring function (with Redis)
#include("SaltPepperNoise.jl")      # SaltPepperNoise ands the said noise to the image
#include("MeanFilter.jl")           # MeanFilter is the proper filter to deal with salt and pepper noise

function view(hh::AbstractString, hv::AbstractString, vv::AbstractString,summaryPercent=100,roiPercent=100,imgname="img.png")

	tic()

    global time = zeros(5)

    # time[1] = step 1
    # time[2] = step 2
    # time[3] = step 3

    # CONSTANTS

    # SandAnd dims
    # datasetHeight          	= 11858
    # datasetWidth	        	= 1650

    # ChiVol dims
    # datasetHeight          	= 153546
    # datasetWidth	        	= 9580

	# roiHeight=76773
	# roiWidth=4790
	# summaryHeight=4798
	# summaryWidth=300

    roiStart		            = 0
    datasetHeight      		= 11858
    datasetWidth	    		= 1650
    roiHeight          	= round(Int,datasetHeight*(roiPercent/100))
    roiWidth	        	= round(Int,datasetWidth*(roiPercent/100))
    summaryHeight 	        	= round(Int,datasetHeight*(summaryPercent/100))
    summaryWidth	            = round(Int,datasetWidth*(summaryPercent/100))


	# connection files

    connection1 = open(hh) # HHHH
    connection2 = open(hv) # HVHV
    connection3 = open(vv) # VVVV

	########## Step 1

    # Image bands

	A = summaryImage(roiStart, roiHeight, roiWidth, summaryHeight, summaryWidth, datasetHeight, datasetWidth, connection1)
	B = summaryImage(roiStart, roiHeight, roiWidth, summaryHeight, summaryWidth, datasetHeight, datasetWidth, connection2)
	C = summaryImage(roiStart, roiHeight, roiWidth, summaryHeight, summaryWidth, datasetHeight, datasetWidth, connection3)

	time[1] = toc()

	########## Step 2

	tic()
	pauliRGBeq = PauliDecomposition(A, B, C, summaryHeight, summaryWidth)
	time[2] = toc()

	########## Step 3
	tic()
    saveimg_time = Images.save(imgname,convert(Image,pauliRGBeq))
    #ImageView.view(pauliRGBeq)  
	time[3] = toc()

    # Add of noise and visualization
    #@time noisy = SaltPepperNoise(pauliRGBeq, summaryWidth, summaryHeight)

    # Filtering and visualization
    #@time pauliRGBeqMean = MeanFilter(noisy, summaryWidth, summaryHeight)

    close(connection1)
    close(connection2)
    close(connection3)

	time

end

end
