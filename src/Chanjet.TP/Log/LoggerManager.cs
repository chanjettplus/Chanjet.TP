using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Chanjet.TP
{
  	public sealed class LoggerManager
	{
        public static ILogger GetLogger(string name)
        {
            return Log4NetAdapter.GetLogger(name);
        }

		public static ILogger GetLogger(Type type)
		{
            return Log4NetAdapter.GetLogger(type);
		}
	}
}

