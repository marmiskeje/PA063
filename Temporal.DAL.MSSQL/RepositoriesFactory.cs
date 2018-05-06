using System;
using System.Collections.Generic;
using System.Text;
using Temporal.DAL.Contracts;

namespace Temporal.DAL.MSSQL
{
    public class RepositoriesFactory : IRepositoriesFactory
    {
        private readonly string connectionString;

        public RepositoriesFactory(string connectionString)
        {
            this.connectionString = connectionString;
        }
        public IBranchesRepository GetBranchesRepository()
        {
            return new BranchesRepository(connectionString);
        }

        public IEmployeesRepository GetEmployeesRepository()
        {
            return new EmployeesRepository(connectionString);
        }
    }
}
