#!/bin/bash
 
# Script to make Turbine array output file of SOWAFA and make it from format
# of simple parameters such as spacing


# User Input.
NumberofTurbines=1
TurbineType='"NREL5MWRef"'
Yaw=270.0
Startlocationarray=300.0
TurbineSpacing=630.0
Ylocation=502.5

# Creation generate precursor data
echo "/*--------------------------------*- C++ -*----------------------------------*\    
| =========                 |                                                 |
| \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox            |
|  \\    /   O peration     | Version:  1.6                                    |
|   \\  /    A nd           | Web:      http://www.OpenFOAM.org                |
|    \\/     M anipulation  |                                                  |
\*---------------------------------------------------------------------------*/
FoamFile
{
    version     2.0;
    format      ascii;
    class       dictionary;
    object      turbineProperties;
}
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

globalProperties
{
    outputControl        \"timeStep\";
    outputInterval       1;
}

" > turbineArrayProperties

for ((ind = 0; ind < $NumberofTurbines; ind = ind+1)); do
	CurrentX=$(awk -v start="$Startlocationarray" -v spacing="$TurbineSpacing" -v idx="$ind" 'BEGIN { print start + spacing * idx }')
	CurrentY=$Ylocation

	echo "
turbine$ind
{
    turbineType          $TurbineType;
    baseLocation         ($CurrentX $CurrentY 0.0);
    nRadial              64;
    azimuthMaxDis        2.0;
    nAvgSector           1;
    pointDistType        \"uniform\";
    pointInterpType      \"linear\";
    bladeUpdateType      \"oldPosition\";
    epsilon              20.0;
    forceScalar          1.0;
    inflowVelocityScalar 0.94;
    tipRootLossCorrType  \"Glauert\";
    rotationDir          \"cw\";
    Azimuth              0.0;
    RotSpeed             9.15519863;
    TorqueGen            0.0;
    Pitch                0.0;
	Teeter			     0.0;
	TeeterOffset		 0.0;
    NacYaw             	 $Yaw;
    fluidDensity         1.225;
}" >> turbineArrayProperties
done 

echo "}
" >> turbineArrayProperties