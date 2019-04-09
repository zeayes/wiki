using System;
using MySql.Data.MySqlClient;
using System.Threading.Tasks;

namespace logging

{
    public class MySqlExample
    {
        static NLog.Logger logger = NLog.LogManager.GetCurrentClassLogger();
        static MySqlConnectionStringBuilder builder = new MySqlConnectionStringBuilder
        {
            Server = "127.0.0.1",
            UserID = "root",
            Password = "",
            Database = "test",
            SslMode = MySqlSslMode.None,
        };
       public async Task Read()
       {
           using (var conn = new MySqlConnection(builder.ConnectionString))
           {
               logger.Debug("opening connection");
               await conn.OpenAsync();
               using (var command = conn.CreateCommand())
               {
                   command.CommandText = "SELECT * FROM users";
                   using (var reader = await command.ExecuteReaderAsync())
                   {
                       while (await reader.ReadAsync())
                       {
                           logger.Info(string.Format("Reading from table=({0}, {1})", reader.GetInt32(0), reader.GetString(1)));
                       }
                   }
               }
               logger.Debug("Closing connection");
           }
       }

       public async Task Create()
       {
           using (var conn = new MySqlConnection(builder.ConnectionString))
           {
               logger.Debug("opening connection");
               await conn.OpenAsync();
               using (var command = conn.CreateCommand())
               {
                   command.CommandText = "DROP TABLE IF EXISTS users";
                   await command.ExecuteNonQueryAsync();
                   logger.Info("finished dropping talbe");

                   command.CommandText = "CREATE TABLE users (id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(20))";
                   await command.ExecuteNonQueryAsync();
                   logger.Info("finished creating talbe");

                   command.CommandText = "INSERT INTO users (id, name) VALUES (@id, @name)";
                   command.Parameters.AddWithValue("@id", 1);
                   command.Parameters.AddWithValue("@name", "tide");
                   int rowCount = await command.ExecuteNonQueryAsync();
                   logger.Info($"Number of rows inserted={rowCount}");
               }
               logger.Debug("Closing connection");
           }
       }
       public async Task Update()
       {
           using (var conn = new MySqlConnection(builder.ConnectionString))
           {
               logger.Debug("opening connection");
               await conn.OpenAsync();
               using (var command = conn.CreateCommand())
               {
                   command.CommandText = "UPDATE users SET name = @name WHERE id = @id";
                   command.Parameters.AddWithValue("@name", "jim");
                   command.Parameters.AddWithValue("@id", 1);
                   int rowCount = await command.ExecuteNonQueryAsync();
                   logger.Info($"Number of rows updated={rowCount}");
               }
               logger.Debug("Closing connection");
           }
       }
    }

}
