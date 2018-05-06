using System;
using System.Collections.Generic;
using System.Text;

namespace Temporal.DAL.Contracts
{
    public class Employee
    {
        public long ID { get; set; }
        public long BranchID { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public ChangeType ChangeType { get; set; }
    }
}
