flapODEs[j].derivatives(t, teeter[i], dteeter[i]);
//scalar moment = 2e6* Foam::sin(t * 5.2);
//flapODEs[j].UpdateMoment(moment);
flapODEs[j].UpdateMoment(AzimuthMomentumSum[i]);

flapODEs[j].PrintVariables(1);
ODESolvers[j]->solve(t, t + dt, teeter[i], TeeterODEdtEst[i]);
teeterCommanded = min(max(teeter[i][0], TeeterMin[j]), TeeterMax[j]);