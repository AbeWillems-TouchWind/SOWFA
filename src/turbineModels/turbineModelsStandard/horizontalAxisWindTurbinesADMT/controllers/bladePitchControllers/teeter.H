pitchCommanded = Foam::cos(polarbladePoints[i][j][k][1] - azimuth[i] - TeeterOffset[i]) * Foam::tan(delta3[m]) * teeter[i][0];
pitchCommanded = min(max(pitchCommanded, PitchMin[m]), PitchMax[m]);