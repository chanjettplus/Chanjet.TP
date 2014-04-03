using Nancy;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Chanjet.TP.ServiceHosting.Modules
{
    public class StaticContentModule : NancyModule
    {
        public StaticContentModule()
        {
            Get["/"] = parameters => Response.AsFile("StaticContent/login.html");
            Get["/login.html"] = parameters => Response.AsFile("StaticContent/login.html");
           
        }
    }
}
