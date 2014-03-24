using Chanjet.TP.Core;
using Chanjet.TP.Data;
using Chanjet.TP.Data.SystemManager;
using Nancy;
using Nancy.Routing;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SelftHostTest
{
    public class RestfulApiModule : NancyModule
    {
        public RestfulApiModule(IRouteCacheProvider routeCacheProvider)
        {
            Get["Tplus/Api/SM/Person"] = x =>
            {
                return Response.AsJson(ServicesFactory.GetServices<IRepository<Person>>().GetAll());
            };
            
            //this.Get
            Get["Tplus/Api/SM/Account"] = x =>
            {
                var o1 = Response.AsJson(ServicesFactory.GetServices<IRepository<Account>>().GetAll());
                var o2 = Response.AsJson(ServicesFactory.GetServices<IAccountRepository>().GetAll());
                var o3 = Response.AsJson(ServicesFactory.GetServices<IRepository<Person>>().GetAll());
                return Response.AsJson( ServicesFactory.GetServices<IRepository<Account>>().GetAll() );
            };
        }
    }
}
