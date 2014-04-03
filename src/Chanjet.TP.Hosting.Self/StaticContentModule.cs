using Nancy;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Chanjet.TP.Hosting.Self
{
    public class StaticContentModule :NancyModule
    {
        public StaticContentModule()
        {
            Get["/LoginUI"] = _ => Response.AsFile("login.html");
            Get["/"] = _ => Response.AsFile("index.html");
        }
    }
}
