#!/usr/bin/gnuplot

# Title
set title 'Duration in hours per activity'

# PNG
set terminal png
set output 'duration-activity.png'
set style line 1 lt 1 lw 3 pt 3 linecolor rgb "#1874CD"

set ylabel 'Hours' 
set xlabel 'Activity ID'
set auto x
set yrange [0:*]
plot 'generated/duration.dat' using 2:xtic(1) w l ls 1 title "Rides"



