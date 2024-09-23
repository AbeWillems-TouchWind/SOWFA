/*---------------------------------------------------------------------------*\
  =========                 |
  \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox
   \\    /   O peration     |
    \\  /    A nd           | Copyright (C) 2011-2013 OpenFOAM Foundation
     \\/     M anipulation  |
-------------------------------------------------------------------------------
License
    This file is part of OpenFOAM.

    OpenFOAM is free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    OpenFOAM is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
    FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
    for more details.

    You should have received a copy of the GNU General Public License
    along with OpenFOAM.  If not, see <http://www.gnu.org/licenses/>.

Description

\*---------------------------------------------------------------------------*/

#include "argList.H"
#include "IOmanip.H"
#include "ODESystem.H"
#include "ODESolver.H"

using namespace Foam;

// * * * * * * * * * * * * * *  Constructor  * * * * * * * * * * * * * * * * //

class flapODE : public ODESystem
{
    scalar I_;
    scalar Ca_;
    scalar ka_;
    scalar kcf_;
    scalar M_;


public:
    // Default constructor
    flapODE() :
        ODESystem(), 
        I_(0.0), 
        Ca_(0.0), 
        ka_(0.0),
        kcf_(0.0), 
        M_(0.0)
    {}

    // Parameterized constructor
    flapODE(scalar inertia, scalar dampening, scalar stiffness_a, scalar stiffness_c)
    :
    ODESystem(), 
    I_(inertia), 
    Ca_(dampening), 
    ka_(stiffness_a),
    kcf_(stiffness_c), 
    M_(0.0)
    {}

    label nEqns() const
    {
        return 2;
    }

    void derivatives(const scalar x, const scalarField& y, scalarField& dydx) const
    {
        dydx[0] = y[1];
        dydx[1] = -(Ca_/I_)*y[1] - ((ka_ + kcf_)/I_)*y[0] + M_ / I_;
    }

    void jacobian(const scalar x, const scalarField& y, scalarField& dfdx, scalarSquareMatrix& dfdy) const
    {
        // Time derivatives (df/dt) are zero since the system does not explicitly depend on time.
        dfdx[0] = 0.0;
        dfdx[1] = 0.0;

        // Jacobian matrix with respect to y1 and y2
        dfdy[0][0] = 0.0;                       // ∂(dy1/dt) / ∂y1 = 0
        dfdy[0][1] = 1.0;                       // ∂(dy1/dt) / ∂y2 = 1
        dfdy[1][0] = -(ka_ + kcf_) / I_;        // ∂(dy2/dt) / ∂y1 = -(ka + kcf) / I
        dfdy[1][1] = -Ca_ / I_;                 // ∂(dy2/dt) / ∂y2 = -Ca / I
    }

    void UpdateMoment(scalar Moment_current)
    {
        M_ = Moment_current;
    }

    void PrintVariables(scalar P = 0)
    {
        if (P != 0)
        {
            Info << "FlapODE Moment = " << M_ << endl;
        }
        else
        {
            Info << "FlapODE Inertia = " << I_ << endl;
            Info << "FlapODE Dampening = " << Ca_ << endl;
            Info << "FlapODE Stiffness Aero = " << ka_ << endl;
            Info << "FlapODE Stiffness Centrifugal = " << kcf_ << endl;
            Info << "FlapODE Moment = " << M_ << endl;
        }
    
    }
};