function MeanFilter(image, width, height)
	newImage = image
	for (i in 2:(width-1))
		for (j in 2:(height-1))
			newImage[i,j,1] =  (image[i-1,j-1,1] + image[i,j-1,1] 	+ image[i+1,j-1,1] + 
							  image[i-1,j,1] 	 + image[i,j,1] 		+ image[i+1,j,1] +
							  image[i-1,j+1,1] + image[i,j+1,1] 	+ image[i+1,j+1,1])/9
			newImage[i,j,2] =  (image[i-1,j-1,2] + image[i,j-1,2] 	+ image[i+1,j-1,2] + 
							  image[i-1,j,2] 	 + image[i,j,2] 		+ image[i+1,j,2] +
							  image[i-1,j+1,2] + image[i,j+1,2] 	+ image[i+1,j+1,2])/9
			newImage[i,j,3] =  (image[i-1,j-1,3] + image[i,j-1,3] 	+ image[i+1,j-1,3] + 
							  image[i-1,j,3] 	 + image[i,j,3] 		+ image[i+1,j,3] +
							  image[i-1,j+1,3] + image[i,j+1,3] 	+ image[i+1,j+1,3])/9
		end
	end
	return (newImage)
end
