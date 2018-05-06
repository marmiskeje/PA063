using Prism.Commands;
using Prism.Mvvm;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using Temporal.DAL.Contracts;

namespace Temporal.DemoApp
{
    internal class MainViewModel : BindableBase
    {
        private DateTime snapshotDateTime = new DateTime(2000, 1, 1);
        private DateTime compareLeftDateTime = new DateTime(2000, 1, 1);
        private DateTime compareRightDateTime = new DateTime(2005, 1, 1);
        private DataProviderViewModel selectedProvider;

        public DateTime SnapshotDateTime
        {
            get { return snapshotDateTime; }
            set { SetProperty(ref snapshotDateTime, value); }
        }
        public DateTime CompareLeftDateTime
        {
            get { return compareLeftDateTime; }
            set { SetProperty(ref compareLeftDateTime, value); }
        }
        public DateTime CompareRightDateTime
        {
            get { return compareRightDateTime; }
            set { SetProperty(ref compareRightDateTime, value); }
        }
        public DataProviderViewModel SelectedProvider
        {
            get { return selectedProvider; }
            set { SetProperty(ref selectedProvider, value); }
        }

        public ObservableCollection<BranchViewModel> SnapshotItems { get; private set; }
        public ObservableCollection<BranchViewModel> SnapshotCompareLeftItems { get; private set; }
        public ObservableCollection<BranchViewModel> SnapshotCompareRightItems { get; private set; }
        public ObservableCollection<DataProviderViewModel> Providers { get; private set; }
        public DelegateCommand GetSnapshotCommand { get; private set; }
        public DelegateCommand CompareCommand { get; private set; }

        public MainViewModel()
        {
            SnapshotItems = new ObservableCollection<BranchViewModel>();
            SnapshotCompareLeftItems = new ObservableCollection<BranchViewModel>();
            SnapshotCompareRightItems = new ObservableCollection<BranchViewModel>();
            Providers = new ObservableCollection<DataProviderViewModel>();
            Providers.Add(new DataProviderViewModel()
            {
                Name = "MS SQL native temporal",
                RepositoriesFactory = new DAL.MSSQL.RepositoriesFactory(ConfigurationManager.AppSettings["MSSQLConnectionString"])
            });
            Providers.Add(new DataProviderViewModel()
            {
                Name = "Postgres Temporal",
                RepositoriesFactory = new DAL.PostgresTemporal.RepositoriesFactory(ConfigurationManager.AppSettings["PostgresTemporalConnectionString"])
            });
            Providers.Add(new DataProviderViewModel()
            {
                Name = "Postgres NonTemporal",
                RepositoriesFactory = new DAL.PostgresNoTemporal.RepositoriesFactory(ConfigurationManager.AppSettings["PostgresNonTemporalConnectionString"])
            });
            SelectedProvider = Providers.First();
            GetSnapshotCommand = new DelegateCommand(() =>
            {
                HandleError(() => UpdateSnapshotItems(SnapshotItems, SnapshotDateTime, nameof(SnapshotItems)));
            });
            CompareCommand = new DelegateCommand(() =>
            {
                HandleError(() =>
                {
                    if (CompareLeftDateTime > CompareRightDateTime)
                    {
                        throw new Exception("First date can´t be greather then second date.");
                    }
                    UpdateSnapshotItems(SnapshotCompareLeftItems, CompareLeftDateTime, nameof(SnapshotCompareLeftItems));
                    UpdateComparisonItems(SnapshotCompareRightItems, CompareLeftDateTime, CompareRightDateTime, nameof(SnapshotCompareRightItems));
                });
            });
        }

        private void HandleError(Action action)
        {
            try
            {
                action();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Error", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void UpdateSnapshotItems(ObservableCollection<BranchViewModel> snapshotItems, DateTime date, string propertyName)
        {
            snapshotItems.Clear();
            var branchesRepository = SelectedProvider.RepositoriesFactory.GetBranchesRepository();
            var employeesRepository = SelectedProvider.RepositoriesFactory.GetEmployeesRepository();
            var branches = branchesRepository.GetSnapshot(date);
            var employees = employeesRepository.GetSnapshot(date);
            var branchesById = new Dictionary<long, BranchViewModel>();
            BuildTree(branches, branchesById);
            foreach (var e in employees)
            {
                if (branchesById.ContainsKey(e.BranchID))
                {
                    branchesById[e.BranchID].Children.Add(new EmployeeViewModel() { FullName = e.FirstName + " " + e.LastName, State = (EmployeeState)(int)e.ChangeType });
                }
            }
            if (branchesById.Count > 0)
            {
                snapshotItems.Add(branchesById.First().Value);
            }
            RaisePropertyChanged(propertyName);
        }
        private void UpdateComparisonItems(ObservableCollection<BranchViewModel> snapshotItems, DateTime date1, DateTime date2, string propertyName)
        {
            snapshotItems.Clear();
            var branchesRepository = SelectedProvider.RepositoriesFactory.GetBranchesRepository();
            var employeesRepository = SelectedProvider.RepositoriesFactory.GetEmployeesRepository();
            var branches = branchesRepository.CompareSnapshots(date1, date2);
            var employees = employeesRepository.CompareSnapshots(date1, date2);
            var branchesById = new Dictionary<long, BranchViewModel>();
            BuildTree(branches, branchesById);
            foreach (var e in employees)
            {
                if (branchesById.ContainsKey(e.BranchID))
                {
                    branchesById[e.BranchID].Children.Add(new EmployeeViewModel() { FullName = e.FirstName + " " + e.LastName, State = (EmployeeState)(int)e.ChangeType });
                }
            }
            if (branchesById.Count > 0)
            {
                snapshotItems.Add(branchesById.First().Value);
            }
            RaisePropertyChanged(propertyName);
        }

        private void BuildTree(IEnumerable<Branch> branches, Dictionary<long, BranchViewModel> branchesById)
        {
            foreach (var b in branches)
            {
                var toAdd = new BranchViewModel() { Name = b.Name, State = (BranchState)(int)b.ChangeType };
                branchesById.Add(b.ID, toAdd);
                if (b.ParentID.HasValue && branchesById.ContainsKey(b.ParentID.Value))
                {
                    branchesById[b.ParentID.Value].Children.Add(toAdd);
                }
            }
        }
    }
}
