using System;
using System.Linq;
using System.Collections.Generic;
using System.Data.SqlClient;
using Dapper;
namespace Temporal.DAL.MSSQL
{
    internal abstract class BaseRepository
    {
        protected String ConnectionString { get; private set; }
        public BaseRepository(string connectionString)
        {
            ConnectionString = connectionString;
        }

        protected SqlConnection CreateConnection()
        {
            return new SqlConnection(ConnectionString);
        }

        protected IReadOnlyList<T> ExecuteQuery<T>(string procedureName, object param)
        {
            using (var connection = CreateConnection())
            {
                return connection.Query<T>(procedureName, param, commandType: System.Data.CommandType.StoredProcedure).ToList();
            }
        }
    }
}
