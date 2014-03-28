using Autofac;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Autofac.Extras.DynamicProxy2;
using Castle.DynamicProxy;
using Chanjet.TP.Core;
using Autofac.Core;
using Chanjet.TP.Data;
using System.IO;
using System.Reflection;

using Nancy.Bootstrapper;
using Nancy.Authentication.Stateless;
using Nancy.Conventions;
using Chanjet.TP.Authentication.Stateless;
using Chanjet.TP.Core.Cache;
using Chanjet.TP.Data.DatabaseProvider;



namespace Chanjet.TP.ServiceHosting
{
    public class ServiceHostBootstrapper : Nancy.Bootstrappers.Autofac.AutofacNancyBootstrapper , IDIContainer
    {
        /// <summary>
        /// 配置IOC容器
        /// </summary>
        /// <param name="existingContainer"></param>
        protected override void ConfigureApplicationContainer(ILifetimeScope existingContainer)
        {
            base.ConfigureApplicationContainer(existingContainer);
        
            var fileNames = (from file in Directory.GetFiles(AppDomain.CurrentDomain.BaseDirectory, "*.Data.dll", SearchOption.AllDirectories)
                            select Path.GetFileName(file)).ToArray();

            AppDomainAssemblyTypeScanner.AddAssembliesToScan(fileNames);

            var fileNames1 = (from file in Directory.GetFiles(AppDomain.CurrentDomain.BaseDirectory, "*.Model.dll", SearchOption.AllDirectories)
                             select Path.GetFileName(file)).ToArray();

            AppDomainAssemblyTypeScanner.AddAssembliesToScan(fileNames1);

            var builder = new ContainerBuilder();

            builder.RegisterType<ExceptionInterceptor>();
            builder.RegisterType<DynamicProxyInterceptor>();

            builder.RegisterType<DefaultCache>().As<ICache>();
            builder.RegisterType<UserMapper>().As<IUserMapper>();
            
            builder.RegisterType<UnitOfWork>().As<IUnitOfWork>();
            builder.Register( c=> new PetaPocoAdapter("Data Source=.;Initial Catalog=UFTSystem;User ID=sa;Password=uf*123456;", "System.Data.SqlClient"))
                .As<IDatabase>();

            builder.RegisterType<ServicesFactory>()
                .AsImplementedInterfaces()
                .EnableInterfaceInterceptors()
                .InterceptedBy(typeof(DynamicProxyInterceptor))
                .SingleInstance();



            var repositorys = AppDomain.CurrentDomain.GetAssemblies()
                .Where(ass => ass.Location.IndexOf(".Data.dll", StringComparison.OrdinalIgnoreCase) > 0)
                .SelectMany(ass =>  ass.GetTypes())
                .Where(t => !t.IsInterface && !t.IsGenericType && t.GetInterface("IRepository`1") != null);

            foreach (var o in repositorys)
            {
                builder.RegisterType(o).AsImplementedInterfaces();
            }

            builder.RegisterGeneric(typeof(RepositoryBase<>)).As(typeof(IRepository<>));

            builder.Update(existingContainer.ComponentRegistry);

            DIContainerManager.SetContainer(this);
        }

        /// <summary>
        /// 应用程序启动
        /// </summary>
        /// <param name="container">IOC容器</param>
        /// <param name="pipelines">管道</param>
        protected override void ApplicationStartup(ILifetimeScope container, IPipelines pipelines)
        {
            base.ApplicationStartup(container, pipelines);

            //this.Conventions.StaticContentsConventions.Add(StaticContentConventionBuilder.AddDirectory("moo", "Content"));
        }

        /// <summary>
        /// 请求开始
        /// </summary>
        /// <param name="container">IOC容器</param>
        /// <param name="pipelines">管道</param>
        /// <param name="context">上下文</param>
        protected override void RequestStartup(ILifetimeScope container, Nancy.Bootstrapper.IPipelines pipelines, Nancy.NancyContext context)
        {
            base.RequestStartup(container, pipelines, context);

            var configuration =
            new StatelessAuthenticationConfiguration(nancyContext =>
            {
                var ticket = (string)nancyContext.Request.Query.Ticket.Value;

                if (String.IsNullOrWhiteSpace(ticket))
                    return null;

                return this.ApplicationContainer.Resolve<IUserMapper>().GetUserFromTicket(ticket);
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
