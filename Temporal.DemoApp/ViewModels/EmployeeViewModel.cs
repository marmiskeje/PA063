using Prism.Mvvm;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Temporal.DemoApp
{
    internal class EmployeeViewModel : BindableBase
    {
        private EmployeeState state = EmployeeState.Default;
        private string fullName = String.Empty;

        public String FullName
        {
            get { return fullName; }
            set { SetProperty(ref fullName, value); }
        }
        public EmployeeState State
        {
            get { return state; }
            set { SetProperty(ref state, value); }
        }
    }

    internal enum EmployeeState
    {
        Default = 0,
        New = 1,
        Removed = -1
    }
}
