using Autofac;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutofacContrib.DynamicProxy2;
using Castle.DynamicProxy;
using Chanjet.TP.Core;
using Autofac.Core;
using Chanjet.TP.Data;
using System.IO;
using System.Reflection;

using Nancy.Bootstrapper;
using Nancy.Authentication.Stateless;
using Chanjet.TP.Authentication.Stateless;



namespace Chanjet.TP.ServiceHosting
{
    public class SelfHostBootstrapper : Nancy.Bootstrappers.Autofac.AutofacNancyBootstrapper , IDIContainer
    {
        protected override void ConfigureApplicationContainer(ILifetimeScope existingContainer)
        {
            base.ConfigureApplicationContainer(existingContainer);

            var builder = new ContainerBuilder();

            builder.RegisterType<ExceptionInterceptor>();
            builder.RegisterType<DynamicProxyInterceptor>();

            builder.RegisterType<SelfHosting>().As<ISelfHosting>().SingleInstance();
   
            builder.RegisterType<ServicesFactory>()
                .AsImplementedInterfaces()
                .EnableInterfaceInterceptors()
                .InterceptedBy(typeof(DynamicProxyInterceptor))
                .SingleInstance();

            builder.RegisterGeneric(typeof(RepositoryBase<>)).As(typeof(IRepository<>));

            var repositorys = AppDomain.CurrentDomain.GetAssemblies().SelectMany(ass => ass.GetTypes())
                 .Where(t => !t.IsInterface && !t.IsGenericType && t.GetInterface("IRepository`1") != null);

            foreach (var o in repositorys)
            {
                builder.RegisterType(o).AsImplementedInterfaces();
            }

            builder.Update(existingContainer.ComponentRegistry);

            ModelLoader.LoadModels(existingContainer);

            DIContainerManager.SetContainer(this);

        }

        protected override void RequestStartup(ILifetimeScope container, Nancy.Bootstrapper.IPipelines pipelines, Nancy.NancyContext context)
        {
            base.RequestStartup(container, pipelines, context);

            var configuration =
            new StatelessAuthenticationConfiguration(nancyContext =>
            {
                var apiKey = (string)nancyContext.Request.Query.ApiKey.Value;
                return UserMapper.GetUserFromApiKey(apiKey);
            });

            AllowAccessToConsumingSite(pipelines);

            StatelessAuthentication.Enable(pipelines, configuration);
        }


        public T Resolve<T>()
        {
            return this.ApplicationContainer.Resolve<T>();
        }

        public object Resolve(Type type)
        {
            return this.ApplicationContainer.Resolve(type);
        }


        private Type GetTypeForName(string key)
        {
            return (
                from reg in this.ApplicationContainer.ComponentRegistry.Registrations
                from service in reg.Target.Services.OfType<KeyedService>()
                .Where(service => service.ServiceKey.ToString() == key)
                select service.ServiceType).FirstOrDefault();
        }


        public object Resolve(string typeName)
        {
            return null;

        }

        static void AllowAccessToConsumingSite(IPipelines pipelines)
        {
            pipelines.AfterRequest.AddItemToEndOfPipeline(x =>
            {
                x.Response.Headers.Add("Access-Control-Allow-Origin", "*");
                x.Response.Headers.Add("Access-Control-Allow-Methods", "POST,GET,DELETE,PUT,OPTIONS");
            });
        }
    }
}
