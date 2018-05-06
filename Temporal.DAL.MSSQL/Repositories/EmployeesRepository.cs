using System;
using System.Collections.Generic;
using System.Text;
using Temporal.DAL.Contracts;

namespace Temporal.DAL.MSSQL
{
    internal class EmployeesRepository : BaseRepository, IEmployeesRepository
    {
        public EmployeesRepository(String connectionString) : base(connectionString)
        {

        }
        public IReadOnlyList<Employee> CompareSnapshots(DateTime date1, DateTime date2)
        {
            var param = new
            {
                Date1 = date1,
                Date2 = date2
            };
            return ExecuteQuery<Employee>("demo.Employees_CompareSnapshots", param);
        }

        public IReadOnlyList<Employee> GetSnapshot(DateTime date)
        {
            var param = new
            {
                Date = date
            };
            return ExecuteQuery<Employee>("demo.Employees_GetSnapshot", param);
        }
    }
}
