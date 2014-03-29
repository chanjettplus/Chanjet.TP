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
using Nancy;
using Chanjet.TP.Core.Identity;
using Chanjet.TP.Core.Context;
using Nancy.Security;



namespace Chanjet.TP.ServiceHosting
{
    public class ServiceHostBootstrapper : Nancy.Bootstrappers.Autofac.AutofacNancyBootstrapper 
    {
        /// <summary>
        /// 配置IOC容器
        /// </summary>
        /// <param name="existingContainer"></param>
        protected override void ConfigureApplicationContainer(ILifetimeScope existingContainer)
        {
            base.ConfigureApplicationContainer(existingContainer);
        
            var fileNames = (from file in Directory.GetFiles(AppDomain.CurrentDomain.BaseDirectory, "*.Data.dll", SearchOption.AllDirectories) select Path.GetFileName(file))
                            .Concat(from file in Directory.GetFiles(AppDomain.CurrentDomain.BaseDirectory, "*.Model.dll", SearchOption.AllDirectories) select Path.GetFileName(file))
                            .ToArray();

            AppDomainAssemblyTypeScanner.AddAssembliesToScan(fileNames);

            var builder = new ContainerBuilder();

            builder.RegisterType<ExceptionInterceptor>();
            //builder.RegisterType<DynamicProxyInterceptor>();

            builder.RegisterType<UserMapper>().As<IUserMapper>();
            builder.RegisterType<UnitOfWork>().As<IUnitOfWork>();
            builder.RegisterType<DefaultCache>().As<ICache>().SingleInstance();

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

            //DIContainerManager.SetContainer(this);
        }

        protected override IEnumerable<INancyModule> GetAllModules(ILifetimeScope container)
        {
            RegisterIDatabase(container, null);
            return base.GetAllModules(container);
        }

      
        /// <summary>
        /// 应用程序启动
        /// </summary>
        /// <param name="container">IOC容器</param>
        /// <param name="pipelines">管道</param>
        protected override void ApplicationStartup(ILifetimeScope container, IPipelines pipelines)
        {
            base.ApplicationStartup(container, pipelines);
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
                var builder = new ContainerBuilder();

                RegisterIThreadContext(container, null);
                RegisterIDatabase(container, null);

                var ticket = GetTicket(nancyContext);

                if (String.IsNullOrWhiteSpace(ticket))
                {
                    return null;
                }

                var userIdentity = container.Resolve<IUserMapper>().GetUserFromTicket(ticket) as IUser;

                RegisterIThreadContext(container, userIdentity);
                RegisterIDatabase(container, userIdentity);

                return userIdentity as IUserIdentity;
            });

            AllowAccessToConsumingSite(pipelines);

            StatelessAuthentication.Enable(pipelines, configuration);
        }


        static void AllowAccessToConsumingSite(IPipelines pipelines)
        {
            pipelines.AfterRequest.AddItemToEndOfPipeline(x =>
            {
                x.Response.Headers.Add("Access-Control-Allow-Origin", "*");
                x.Response.Headers.Add("Access-Control-Allow-Methods", "POST,GET,DELETE,PUT,OPTIONS");
            });
        }

        private string GetTicket(Nancy.NancyContext context)
        {
            string ticket = string.Empty;

            ticket = (string)context.Request.Query.ticket.Value;

            if (String.IsNullOrEmpty(ticket) 
                && context.Request.Cookies != null 
                && context.Request.Cookies.Count > 0
                && context.Request.Cookies.ContainsKey("ticket"))
                ticket = context.Request.Cookies["ticket"];

            if (String.IsNullOrEmpty(ticket))
                ticket = (string)context.Request.Form.ticket.Value;

            return ticket;


        }

        private void RegisterIThreadContext(ILifetimeScope container, IUser userIdentity)
        {
            if (userIdentity == null)
                return;

            var builder = new ContainerBuilder();

            builder.Register(c => new ThreadContext(userIdentity)).As<IThreadContext>().InstancePerLifetimeScope();

            builder.Update(container.ComponentRegistry);

        }

        private void RegisterIDatabase(ILifetimeScope container, IUser userIdentity)
        {
            if (userIdentity == null)
            {
                var builder = new ContainerBuilder();

                builder
                    .Register(c => new PetaPocoAdapter("Data Source=.;Initial Catalog=UFTSystem;User ID=sa;Password=uf*123456;", "System.Data.SqlClient"))
                    .As<IDatabase>();

                builder.Update(container.ComponentRegistry);
            }
            else
            {
                var builder = new ContainerBuilder();

                builder
                    .Register(c => new PetaPocoAdapter("Data Source=.;Initial Catalog=" + userIdentity.Additional.DatabaseName + ";User ID=sa;Password=uf*123456;", "System.Data.SqlClient"))
                    .As<IDatabase>();

                builder.Update(container.ComponentRegistry);
            }
        }


    }
}
