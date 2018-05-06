using System;
using System.Linq;
using System.Collections.Generic;
using Dapper;
using Npgsql;

namespace Temporal.DAL.PostgresNoTemporal
{
    internal abstract class BaseRepository
    {
        protected String ConnectionString { get; private set; }
        public BaseRepository(string connectionString)
        {
            ConnectionString = connectionString;
        }

        protected NpgsqlConnection CreateConnection()
        {
            return new NpgsqlConnection(ConnectionString);
        }

        protected IReadOnlyList<T> ExecuteQuery<T>(string sql, object param)
        {
            using (var connection = CreateConnection())
            {
                return connection.Query<T>(sql, param, commandType: System.Data.CommandType.Text).ToList();
            }
        }
    }
}
