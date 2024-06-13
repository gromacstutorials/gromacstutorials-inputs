#!/bin/sh

for file in dark.*.ppm; 
do 
	convert $file -transparent black  $file.png; # -crop 500x557+100+0
done
img2webp -o video-PEG-dark.webp -q 10 -mixed -d 33 *.png 
rm *.png

for file in light.*.ppm; 
do 
	convert $file -transparent white  $file.png; # -crop 500x557+100+0
done
img2webp -o video-PEG-light.webp -q 10 -mixed -d 33 *.png
rm *.png

