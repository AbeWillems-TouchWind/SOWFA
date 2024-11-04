flapODEs[j].derivatives(t, teeter[i], dteeter[i]);
flapODEs[j].UpdateMoment(moment[i]);

flapODEs[j].PrintVariables(0);
ODESolvers[j]->solve(t, t + dt, teeter[i], teeterODEdtEst[i]);
teeterCommanded = min(max(teeter[i][0], TeeterMin[j]), TeeterMax[j]);