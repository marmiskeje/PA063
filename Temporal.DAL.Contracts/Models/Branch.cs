using System;
using System.Collections.Generic;
using System.Text;

namespace Temporal.DAL.Contracts
{
    public class Branch
    {
        public long ID { get; set; }
        public String Name { get; set; }
        public long? ParentID { get; set; }
        public ChangeType ChangeType { get; set; }
    }
}
