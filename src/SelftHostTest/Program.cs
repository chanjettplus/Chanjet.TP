
using Chanjet.TP.Core;
using Chanjet.TP.Hosting.Self;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;


namespace SelftHostTest
{
    class Program
    {
        static void Main(string[] args)
        {
           ///
           /// var host = new SelfHosting(new Uri("http://localhost:8888/TP/"), new Uri("http://127.0.0.1:8888/TP/"));
           /// 
            var host = new SelfHosting(new Uri("http://localhost:55581/restApi/"), new Uri("http://localhost:55581/restApi/"));
            

            host.Start();

            Console.WriteLine("TPlus now listening - navigating to http://localhost:8888/TP/. Press enter to stop");
            try
            {
                //Process.Start("http://localhost:8888/TP/");
            }
            catch (Exception)
            {
            }
            Console.ReadKey();

        }

    }
}
