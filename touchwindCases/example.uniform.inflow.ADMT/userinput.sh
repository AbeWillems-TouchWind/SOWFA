#!/bin/sh

# Global user input 
export OpenFOAMversion=2.4.0   
export startTime=0 


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