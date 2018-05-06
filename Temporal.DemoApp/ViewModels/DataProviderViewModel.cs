using Prism.Mvvm;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Temporal.DAL.Contracts;

namespace Temporal.DemoApp
{
    internal class DataProviderViewModel : BindableBase
    {
        private string name = String.Empty;

        public String Name
        {
            get { return name; }
            set { SetProperty(ref name, value); }
        }

        public IRepositoriesFactory RepositoriesFactory { get; set; }
    }
}
