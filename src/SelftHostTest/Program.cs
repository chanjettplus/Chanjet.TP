
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

            var host = new SelfHosting(new Uri("http://localhost:12652/"), new Uri("http://127.0.0.1:12652/"));
     
            host.Start();

            Console.WriteLine("TPlus now listening - navigating to http://localhost:12652/. Press enter to stop");
            try
            {
                //Process.Start("http://localhost:12652/");
            }
            catch (Exception)
            {
            }
            Console.ReadKey();

        }

    }
}
