using Autofac;
using Chanjet.TP.Core.DI;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Ufida.T.EAP.AppCrypto.Service;
using AutofacContrib.DynamicProxy2;
using Castle.DynamicProxy;
using Chanjet.TP.Core;
using Ufida.T.EAP.AppCrypto.Interface;
using Autofac.Core;

namespace SelftHostTest
{
    public class SelfHostBootstrapper : Nancy.Bootstrappers.Autofac.AutofacNancyBootstrapper , IDIContainer
    {
        protected override void ConfigureApplicationContainer(ILifetimeScope existingContainer)
        {
            base.ConfigureApplicationContainer(existingContainer);

            var builder = new ContainerBuilder();

            builder.RegisterType<ExceptionInterceptor>();
            builder.RegisterType<DynamicProxyInterceptor>();
            /*
            builder.RegisterType<AppCryptoService>()
                .As<IAppCrypto>()
                .EnableInterfaceInterceptors()
                .InterceptedBy(typeof(ExceptionInterceptor))
                .SingleInstance();


            builder.RegisterType<AccountRepository>()
                .EnableInterfaceInterceptors()
                .InterceptedBy(typeof(DynamicProxyInterceptor))
                .Named<IAccountRepository>("fff");
               // .EnableClassInterceptors()
               // .InterceptedBy(typeof(DynamicProxyInterceptor))
               // .SingleInstance();*/

            builder.RegisterType<ServicesFactory>()
                .AsImplementedInterfaces()
                .EnableInterfaceInterceptors()
                .InterceptedBy(typeof(DynamicProxyInterceptor))
                .SingleInstance();

            builder.RegisterGeneric(typeof(RepositoryBase<>)).As(typeof(IRepository<>));

            var repositorys = AppDomain.CurrentDomain.GetAssemblies()
                                  .SelectMany(ass=>ass.GetTypes())
                                  .Where(t=> !t.IsInterface && !t.IsGenericType && t.GetInterface("IRepository`1") != null);

            foreach(var o in repositorys)
            {
                builder.RegisterType(o).AsImplementedInterfaces();
            }
           
            //var ss = typeof(AccountRepository).GetInterface("IRepository`1");
            //builder.RegisterType<AppCryptoService>()

            builder.Update(existingContainer.ComponentRegistry);
            //var i = ApplicationContainer.ResolveNamed<IAccountRepository>("fff");
            //i.GetById(1);
           // var ii = this.ApplicationContainer.Resolve(typeof(IRepository<Object>)) as IRepository<object>;

           
           // var iii = this.ApplicationContainer.Resolve<IAppCrypto>();


           // var i = ApplicationContainer.ResolveNamed<IDependency>("fff");
            

             DIContainerManager.SetContainer(this);
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

        private Type GetTypeForName(string key)
        {
            return (
                from reg in this.ApplicationContainer.ComponentRegistry.Registrations
                from service in reg.Target.Services.OfType<KeyedService>()
                .Where(service => service.ServiceKey.ToString() == key)
                select service.ServiceType).FirstOrDefault();
        }
    }
}
