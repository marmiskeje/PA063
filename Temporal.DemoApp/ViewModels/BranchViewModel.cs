using Prism.Mvvm;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Temporal.DemoApp
{
    internal class BranchViewModel : BindableBase
    {
        private string name = String.Empty;
        private BranchState state = BranchState.Default;
        private ObservableCollection<object> children = new ObservableCollection<object>();

        public String Name
        {
            get { return name; }
            set { SetProperty(ref name, value); }
        }
        public BranchState State
        {
            get { return state; }
            set { SetProperty(ref state, value); }
        }

        public ObservableCollection<object> Children
        {
            get { return children; }
        }
    }

    internal enum BranchState
    {
        Default = 0,
        New = 1,
        Removed = -1
    }
}
