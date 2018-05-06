using System;
using System.Collections.Generic;
using System.Text;

namespace Temporal.DAL.Contracts
{
    public enum ChangeType
    {
        NoChange = 0,
        Removed = -1,
        New = 1
    }
}
