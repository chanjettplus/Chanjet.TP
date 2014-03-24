using Autofac;
using Autofac.Features.Metadata;
using Chanjet.TP;
using Chanjet.TP.Core;
using Chanjet.TP.Logger;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace TestConsole
{
    class Program
    {
        static void Main(string[] args)
        {
            var builder = new ContainerBuilder();

            builder.RegisterType<Log4NetManagerAdapter>()
                .As<ILoggerManager>()
                .SingleInstance();
            var container = builder.Build();

            var logger = container.Resolve<ILoggerManager>().GetLogger("fewfew");


        }
    }

   

}
