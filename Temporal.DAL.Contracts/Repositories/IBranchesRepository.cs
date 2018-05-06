using System;
using System.Collections.Generic;
using System.Text;

namespace Temporal.DAL.Contracts
{
    public interface IBranchesRepository
    {
        IReadOnlyList<Branch> GetSnapshot(DateTime date);
        IReadOnlyList<Branch> CompareSnapshots(DateTime date1, DateTime date2);
    }
}
