using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Chanjet.TP.Core
{
  	public interface ILoggerManager
	{
        ILogger GetLogger(string name);
      
		ILogger GetLogger(Type type);
	}
}

