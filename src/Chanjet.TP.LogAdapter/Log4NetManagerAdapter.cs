using Chanjet.TP.Core;
using log4net.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Chanjet.TP.Logger
{
    public class Log4NetManagerAdapter : ILoggerManager
    {
        public Chanjet.TP.Core.ILogger GetLogger(Type type)
        {
            return new Log4NetAdapter( log4net.LogManager.GetLogger(type));
        }

        public Chanjet.TP.Core.ILogger GetLogger(string name)
        {
            return new Log4NetAdapter(log4net.LogManager.GetLogger(name));
        }
    }
}
