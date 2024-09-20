//Info << "time = " << t << endl;
//Info << "teeter = " << teeter[i][0] << endl;
//Info << "teeter = " << teeter[i][1] << endl;
//Info << "dteeter = " << dteeter[i][0] << endl;
//Info << "dteeter = " << dteeter[i][1] << endl;


flapODEs[j].derivatives(t, teeter[i], dteeter[i]);
//Info << "dt = " << dt << endl;
//Info << "TeeterODEdtEst = " << TeeterODEdtEst[i] << endl;

//ODESolvers[j]->solve(t, t + dt, teeter[i], TeeterODEdtEst[i]);

if (!ODESolvers.empty())
{
    std::cerr << "Error: ODESolvers[0] is not empty." << std::endl;
}

if (ODESolvers[0].ptr())
{
    ODESolvers[0]->solve(t, t + dt, teeter[i], TeeterODEdtEst[i]);
}
else
{
    std::cerr << "Error: ODESolvers[0] is null or empty." << std::endl;
}