#!/bin/bash
GENOUT="generated"
DATAFILE="runs.data"
PNGOUT="png"
SITE="html/index.html"

## Data generation and plotting
#ID, Date, Distance, Duration, Pace, Speed, Burned, Climb
function distance () { 
    echo "Building distance..."
    grep -v '^#' $DATAFILE | awk -F, '{print $2" "$3 }' > $GENOUT/distance.dat
    gnuplot plots/distance.plot
}

function duration () { 
    echo "Building duration..."
    grep -v '^#' $DATAFILE | awk -F, '{print $2" "$4 }' > $GENOUT/duration.dat
    gnuplot plots/duration.plot
}

function pace () { 
    echo "Building pace..."
    grep -v '^#' $DATAFILE | awk -F, '{print $2" "$5 }' > $GENOUT/pace.dat
    gnuplot plots/pace.plot
}

function speed () { 
    echo "Building speed..."
    grep -v '^#' $DATAFILE | awk -F, '{print $2" "$6 }' > $GENOUT/speed.dat
    gnuplot plots/speed.plot
}

function calories () {
    echo "Building calories..."
    grep -v '^#' $DATAFILE | awk -F, '{print $2" "$7 }' > $GENOUT/calories.dat
    gnuplot plots/calories.plot
} 

function climb () { 
    echo "Building climb..."
    grep -v '^#' $DATAFILE | awk -F, '{print $2" "$8 }' > $GENOUT/climb.dat
    gnuplot plots/climb.plot
}

## General overall stats
function overall () {

    C=0
    for x in $(grep -v '^#' $DATAFILE | awk -F, '{print $8 }'); do
        C=$((C+$x)) 
    done
    echo "Climb: $C metres of high " 

    C=0
    for x in $(grep -v '^#' $DATAFILE | awk -F, '{print $7 }'); do
        C=$((C+$x))
    done
    echo "Calories: $C " 

    C=0
    for x in $(grep -v '^#' $DATAFILE | awk -F, '{print $3 }'); do
        C=$(echo "$C + $x" | bc) 
    done
    echo "Distance: $C km" 

    C=0
    SUM=0
    for x in $(grep -v '^#' $DATAFILE | awk -F, '{print $6 }'); do
        C=$(echo "$C + $x" | bc) 
        ((SUM++))
    done
    C=$(echo "$C / $SUM" | bc )
    echo "Speed Average: $C km/h" 
}

## Cleanup and HTML Generation 
function moving () {
    mv *.png png/ 
}

function make-site () {
    cat html/header.html 
    echo '<div id="content">' 
    echo '<h2>Overall Stats</h2>'
    OIFS=$IFS
    IFS='
'
    for x in $(overall); do
        echo "$x<br>"
    done
    IFS=$OIFS
    echo '<h2>Graphs</h2>'
    for x in $(ls png/*.png); do
        echo "<img src=\"../$x\"><br/><br/><br/>"
    done
    echo '</div> <!-- content -->'
    cat html/footer.html
}
    

## Runtime
calories
distance
climb
speed
pace
duration
moving
make-site > $SITE 
