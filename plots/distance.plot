#!/usr/bin/gnuplot

# Title
set title 'Distance of your Runkeeper Activities'

# PNG
set terminal png
set output 'distance-activity.png'

set style line 1 lt 1 lw 3 pt 3 linecolor rgb "#1874CD"

set ylabel 'Distance' 
set xlabel 'Activity ID'
set auto x
set auto y 
plot 'generated/distance.dat' using 2:xtic(1) w l ls 1  title "Distances"



