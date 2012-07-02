#!/usr/bin/gnuplot

# Title
set title 'Average speed per activity'

# PNG
set terminal png
set output 'speed-activity.png'

set style line 1 lt 1 lw 3 pt 3 linecolor rgb "#1874CD"
set ylabel 'Km/h' 
set xlabel 'Date'
set auto x
set yrange [0:*]
plot 'generated/speed.dat' using 2:xtic(1) w l ls 1  title "Rides"



