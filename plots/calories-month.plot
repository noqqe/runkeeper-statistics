#!/usr/bin/gnuplot

# Title
set title 'Your burned calories per month'

# PNG
set terminal png
set output 'calories-month.png'

set style line 1 lt 1 lw 3 pt 3 linecolor rgb "#1874CD"

#set style fill solid border rgb "black"
set ylabel 'Calories' 
set xlabel 'Month'
set auto x
set yrange [0:*]
plot 'generated/calories-month.dat' using 2:xtic(1) w l ls 1  title "Rides"



