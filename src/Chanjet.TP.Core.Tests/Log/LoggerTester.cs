using NUnit.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Chanjet.TP.Tests
{
     [TestFixture]
    public class LoggerTester
    {
          [Test] 
         public void Debug()
         {
             LoggerManager.GetLogger("DebugTest").Debug("DebugTest");
         }
    }
}
