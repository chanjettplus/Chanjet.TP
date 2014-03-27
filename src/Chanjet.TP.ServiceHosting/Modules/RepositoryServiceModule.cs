using Chanjet.TP.Core;
using Chanjet.TP.Data;
using Nancy;
using Nancy.Bootstrapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Chanjet.TP.ServiceHosting.Modules
{
    public class RepositoryServiceModule : NancyModule
    {
        public RepositoryServiceModule()
        {
            
            Get["/Api/{Domain}/{Model}"] = parameters =>
            {
                return Invoke(parameters.Domain,parameters.Model, "GetAll", null);
            };
        }
        

        private object Invoke(string domain, string model, string methodName, object[] parameters )
        {
            var modelType =
                (from type in AppDomainAssemblyTypeScanner.Types
                where type.FullName.Contains(String.Format("Chanjet.TP.{0}.Model.{1}", domain, model))
                select type).First();


            var repositoryType = typeof(IRepository<>).MakeGenericType(modelType);

            object srv = ServicesFactory.GetServices(repositoryType);
            return Response.AsJson(srv.GetType().GetMethod(methodName).Invoke(srv, parameters));

        }
    }
}
