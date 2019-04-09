using System;
using System.IO;
using System.Threading.Tasks;
using MySql.Data.MySqlClient;

namespace logging
{
    class Program
    {
        // private static NLog.Logger logger = NLog.LogManager.GetCurrentClassLogger();
        static void Main(string[] args)
        {
            NLog.LogManager.Configuration = new NLog.Config.XmlLoggingConfiguration("nlog.config");
            var example = new MySqlExample();
            example.Create().Wait();
            example.Read().Wait();
            example.Update().Wait();
            example.Read().Wait();
        }
    }
}
