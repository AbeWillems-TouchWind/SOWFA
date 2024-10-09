#!/bin/sh

# Global user input 
export OpenFOAMversion=2.4.0   

# Read the startTime value from the controlDict file
controlDictFile="system/controlDict"
if [ -f "$controlDictFile" ]; then
    # Use awk to find the line with 'startTime' and extract the value
    startTime=$(awk '/startTime/ {for (i=1; i<=NF; i++) if ($i == "startTime") {gsub(";", "", $(i+1)); print $(i+1)}}' "$controlDictFile")
    
    # Convert startTime to an integer
    startTimeInt=$(printf "%.0f" "$startTime")  # This converts to integer
    
    # Export the value as a global variable
    if [ -n "$startTimeInt" ]; then
        export startTime=$startTimeInt  # Export the integer version
    else
        echo "Error: startTime not found in controlDict file."
    fi

    # Use awk to find the line with 'endTime' and extract the value
    endTime=$(awk '/endTime/ {for (i=1; i<=NF; i++) if ($i == "endTime") {gsub(";", "", $(i+1)); print $(i+1)}}' "$controlDictFile")
    
    # Convert endTime to an integer
    endTimeInt=$(printf "%.0f" "$endTime")  # This converts to integer
    
    # Export the value as a global variable
    if [ -n "$endTimeInt" ]; then
        export endTime=$endTimeInt  # Export the integer version
    else
        echo "Error: endTime not found in controlDict file."
    fi
else
    echo "Error: controlDict file not found."
fi
#export startTime=0 
#export endTime=200

# Read the nCores value from the setUp file
if [ -f setUp ]; then
    nCores=$(awk '/nCores/ {print $2}' setUp | tr -d ';')
    
    # Export the value as a global variable
    if [ -n "$nCores" ]; then
        export cores=$nCores
    else
        echo "Error: nCores not found in setUp file."
    fi
else
    echo "Error: setUp file not found."
fi
# export cores=12     

