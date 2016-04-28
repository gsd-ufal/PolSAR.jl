function ReadImage(roiStart, roiHeight, roiWidth, summaryHeight, summaryWidth, datasetHeight, datasetWidth, imageID1, imageID2, imageID3)
	
	println("Reading image...")    
	tic()
    A = summaryImage(roiStart, roiHeight, roiWidth, summaryHeight, summaryWidth, datasetHeight, datasetWidth, imageID1)
    B = summaryImage(roiStart, roiHeight, roiWidth, summaryHeight, summaryWidth, datasetHeight, datasetWidth, imageID2)
    C = summaryImage(roiStart, roiHeight, roiWidth, summaryHeight, summaryWidth, datasetHeight, datasetWidth, imageID3)
	println("Time: ",toc())

	println("Set list...")
    for i in 1:1000000
        rpush(pipeline,imageID1.name,A[i])
        rpush(pipeline,imageID2.name,B[i])
        rpush(pipeline,imageID3.name,C[i])
    end
    
end
