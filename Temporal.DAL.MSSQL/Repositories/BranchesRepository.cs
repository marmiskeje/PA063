using System;
using System.Collections.Generic;
using System.Text;
using Temporal.DAL.Contracts;

namespace Temporal.DAL.MSSQL
{
    internal class BranchesRepository : BaseRepository, IBranchesRepository
    {
        public BranchesRepository(String connectionString) : base(connectionString)
        {

        }
        public IReadOnlyList<Branch> CompareSnapshots(DateTime date1, DateTime date2)
        {
            var param = new
            {
                Date1 = date1,
                Date2 = date2
            };
            return ExecuteQuery<Branch>("demo.Branches_CompareSnapshots", param);
        }

        public IReadOnlyList<Branch> GetSnapshot(DateTime date)
        {
            var param = new
            {
                Date = date
            };
            return ExecuteQuery<Branch>("demo.Branches_GetSnapshot", param);
        }
    }
}
