using System;
using System.Collections.Generic;
using System.Text;

namespace Temporal.DAL.Contracts
{
    public interface IEmployeesRepository
    {
        IReadOnlyList<Employee> GetSnapshot(DateTime date);
        IReadOnlyList<Employee> CompareSnapshots(DateTime date1, DateTime date2);
    }
}
