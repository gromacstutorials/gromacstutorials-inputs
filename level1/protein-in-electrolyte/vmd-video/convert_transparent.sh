#!/bin/sh

for file in dark.*.ppm; 
do 
	convert $file -transparent black -crop 500x557+100+0  $file.png;
done
img2webp -o video-protein-dark.webp -q 10 -mixed -d 33.33 *.png 
rm *.png

for file in light.*.ppm; 
do 
	convert $file -transparent white -crop 500x557+100+0  $file.png;
done
img2webp -o video-protein-white.webp -q 10 -mixed -d 33.33 *.png
rm *.png

for file in dark.*.ppm; 
do 
	convert $file $file.png; # -crop 500x557+100+0
done
img2webp -o video-protein.webp -q 40 -mixed -d 33.33 *.png 
rm *.png