using System;
using System.Collections.Generic;
using System.Text;

namespace Temporal.DAL.Contracts
{
    public interface IRepositoriesFactory
    {
        IBranchesRepository GetBranchesRepository();
        IEmployeesRepository GetEmployeesRepository();
    }
}
