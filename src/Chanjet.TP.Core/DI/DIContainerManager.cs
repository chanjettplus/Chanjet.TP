using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Chanjet.TP.Core
{
    public interface IDIContainer
    {
        T Resolve<T>();
        object Resolve(Type type);

        object Resolve(string typeName);

    }

    public class DIContainerManager
    {
        private static IDIContainer _container;
        public static void SetContainer(IDIContainer container)
        {
            _container = container;
        }

        public static T Resolve<T>()
        {
            return _container.Resolve<T>();
        }
        
        public static object Resolve(Type type)
        {
            return _container.Resolve(type);
        }

        public static object Resolve(string typeName)
        {
            return _container.Resolve(typeName);
        }


    }
}
