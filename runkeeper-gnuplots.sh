#!/bin/bash
GENOUT="generated"
DATAFILE="activity.dat"
PNGOUT="png"
INDEXSITE="html/index.html"
ACTIVITIESSITE="html/activities.html"
MONTHLYSITE="html/monthly.html"
OVERALLSITE="html/overall.html"
YEAR="$(date +%Y)"
## Data generation and plotting
#ID, Date, Distance, Duration, Pace, Speed, Burned, Climb
function distance () { 
    echo "Building distance (activity)..."
    grep -v '^#' $DATAFILE | awk -F, '{print $2" "$3 }' > $GENOUT/distance.dat
    gnuplot plots/distance.plot
}

function distance-month () { 
    echo "Building distance (monthly)..."
        for x in {1..12} ; do
                C=0
                y=$((x+1))
                if [ ${#x} -eq 1 ]; then
                        x="0$x"
                fi
                if [ ${#y} -eq 1 ]; then
                        y="0$y"
                fi
                if [ ${y} -eq 13 ]; then
                    f=$(grep -v '^#' $DATAFILE | grep "$YEAR-12-" | awk -F, '{print $3}')
                    for z in $f; do 
                        C=$(echo "$C + ${z:-0}" | bc )
                    done
                    echo "$x $C"
                else
                    f=$(grep -v '^#' $DATAFILE | grep "$YEAR-$x-" | awk -F, '{print $3}')
                    for z in $f; do 
                        C=$(echo "$C + ${z:-0}" | bc )
                    done
                    echo "$x $C"
                fi
        done  > $GENOUT/distance-month.dat
    gnuplot plots/distance-month.plot
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

function calories-month () { 
    echo "Building calories (monthly)..."
        for x in {1..12} ; do
                C=0
                y=$((x+1))
                if [ ${#x} -eq 1 ]; then
                        x="0$x"
                fi
                if [ ${#y} -eq 1 ]; then
                        y="0$y"
                fi
                if [ ${y} -eq 13 ]; then
                    f=$(grep -v '^#' $DATAFILE | grep "$YEAR-12-" | awk -F, '{print $7}')
                    for z in $f; do 
                        C=$(echo "$C + ${z:-0}" | bc )
                    done
                    echo "$x $C"
                else
                    f=$(grep -v '^#' $DATAFILE | grep "$YEAR-$x-" | awk -F, '{print $7}')
                    for z in $f; do 
                        C=$(echo "$C + ${z:-0}" | bc )
                    done
                    echo "$x $C"
                fi
        done  > $GENOUT/calories-month.dat
    gnuplot plots/calories-month.plot
}

function climb () { 
echo "Building climb..."
grep -v '^#' $DATAFILE | awk -F, '{print $2" "$8 }' > $GENOUT/climb.dat
gnuplot plots/climb.plot
}

## General overall stats
function overall () {

    # Height
    C=0
    for x in $(grep -v '^#' $DATAFILE | awk -F, '{print $8 }'); do
        C=$((C+$x)) 
    done
    echo "Climb: $C metres of height" 

    # Calories 
    C=0
    for x in $(grep -v '^#' $DATAFILE | awk -F, '{print $7 }'); do
        C=$((C+$x))
    done
    echo "Calories: $C " 

    # Distance 
    C=0
    for x in $(grep -v '^#' $DATAFILE | awk -F, '{print $3 }'); do
        C=$(echo "$C + $x" | bc) 
    done
    echo "Distance: $C km" 

    # Speed Average
    C=0
    SUM=0
    for x in $(grep -v '^#' $DATAFILE | awk -F, '{print $6 }'); do
        C=$(echo "$C + $x" | bc) 
        ((SUM++))
    done
    C=$(echo "$C / $SUM" | bc )
    echo "Speed Average: $C km/h" 
    
    # Pace
    C=0
    SUM=0
    for x in $(grep -v '^#' $DATAFILE | awk -F, '{print $5 }'); do
        C=$(echo "$C + $x" | bc) 
        ((SUM++))
    done
    C=$(echo "$C / $SUM" | bc )
    echo "Pace Average: $C minutes per km" 

    # Duration
    C=0
    for x in $(grep -v '^#' $DATAFILE | awk -F, '{print $4 }'); do
        C=$(echo "$C + $x" | bc) 
    done
    echo "Duration: $C hours" 
}

## Cleanup and HTML Generation 
function moving () {
    rm png/*.png
    mv *.png png/ 
}

function html-index () {
    cat html/header.html 
    echo '<div id="content">' 
    echo '<h2>Your Graphs by Activity</h2>'
    for x in $(ls png/*-activity.png); do
        echo "<img src=\"../$x\"><br/><br/><br/>"
    done
    echo '</div> <!-- content -->'
    cat html/footer.html
}

function html-activities () {
    cat html/header.html 
    echo '<div id="content">' 
    echo '<h2>Your Activities</h2>'
    OIFS=$IFS
    IFS='
'
    echo "<ul>"
    #ID, Date, Distance, Duration, Pace, Speed, Burned, Climb
    for x in $(cat activity.dat | grep -v ^# | sort -rn); do
        echo $x | awk -F, '{print "<li>" $1 \
            "<br>Date: "$2 "<br>Distance: "$2 \
            "<br>Duration: "$3 \
            "<br>Pace: "$4\
            "<br>Speed: "$5\
            "<br>Burned: "$6\
            "<br>Climb: "$7\
            "<br><br></li>"}'
    done
    echo "</ul>"
    echo '</div> <!-- content -->'
    IFS=$OIFS
    cat html/footer.html
}   

function html-monthly () {
    cat html/header.html 
    echo '<div id="content">' 
    echo '<h2>Your Graphs Monthly</h2>'
    for x in $(ls png/*-month.png); do
        echo "<img src=\"../$x\"><br/><br/><br/>"
    done
    echo '</div> <!-- content -->'
    IFS=$OIFS
    cat html/footer.html
}   

function html-overall () {
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
    echo '</div> <!-- content -->'
    cat html/footer.html
}

# devel
## Runtime
calories
distance
climb
speed
pace
duration
distance-month
calories-month
moving
html-index > $INDEXSITE 
html-activities > $ACTIVITIESSITE 
html-monthly > $MONTHLYSITE
html-overall > $OVERALLSITE
