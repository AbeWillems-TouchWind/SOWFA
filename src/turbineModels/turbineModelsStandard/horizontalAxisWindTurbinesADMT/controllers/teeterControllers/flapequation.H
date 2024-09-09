scalar M = 2E6 * Foam::sin(5.2 * t);

// Solve the ODE (flapequation): I * Bddot + Ca * Bdot + (ka + kct) * B = M
teeterddot[i] = (M - TeeterCa[j] * teeterdot[i] - (TeeterKa[j] + TeeterKcf[j]) * teeter[i]) / TeeterI[j];


// Update Bdot and B using simple time-stepping (the backward Euler method)
teeterdot[i] = teeterdot[i] + teeterddot[i] * dt;
teeter[i] = teeter[i] + teeterdot[i] * dt;