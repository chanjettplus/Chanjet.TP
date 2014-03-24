
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Chanjet.TP.Core
{
    public class ServicesFactory : IServicesFactory
    {
        public static T GetServices<T>()
            where T : class
        {
            return DIContainerManager.Resolve<IServicesFactory>().GetService<T>();
        }

        public static object GetServices(Type type)
        {
            return DIContainerManager.Resolve<IServicesFactory>().GetService(type);
        }

        public static object GetServices(string typeName)
        {
            return DIContainerManager.Resolve<IServicesFactory>().GetService(typeName);
        }

        public T GetService<T>()
            where T:class
        {
            return null;
        }

        public object GetService(Type type)
        {
            return null;
        }

        public object GetService(string typeName)
        {
            return null;
        }

        
    }

    public interface IServicesFactory
    {
        T GetService<T>() where T :class;
        object GetService(Type type);

        object GetService(string typeName);
    }
}
