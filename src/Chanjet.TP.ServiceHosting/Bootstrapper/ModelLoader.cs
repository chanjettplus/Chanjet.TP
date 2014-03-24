using Autofac;
using Chanjet.TP.Data;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;

namespace Chanjet.TP.ServiceHosting
{
    public static class ModelLoader
    {
        private static Dictionary<string, Assembly> _modelAssemblies = new Dictionary<string, Assembly>();
        public static void LoadModels(ILifetimeScope existingContainer)
        {
            var builder = new ContainerBuilder();
            var assemblys = new List<Assembly>();

            var files = Directory.GetFiles(AppDomain.CurrentDomain.BaseDirectory, "*.Data.dll");
            foreach (var file in files)
            {
                var assembly = Assembly.LoadFrom(file);
                _modelAssemblies.Add(assembly.GetName().Name, assembly);
                assemblys.Add(assembly);
            }

            var repositorys = assemblys.ToArray().SelectMany(ass => ass.GetTypes())
                 .Where(t => !t.IsInterface && !t.IsGenericType && t.GetInterface("IRepository`1") != null);

            foreach (var o in repositorys)
            {
                builder.RegisterType(o).AsImplementedInterfaces();
            }

            builder.Update(existingContainer.ComponentRegistry);
        }

        public static Type GetModelRepositoryType(string modelTypeName)
        {
            var tmp = modelTypeName.Split(',');
            if (!_modelAssemblies.ContainsKey(tmp[1].Trim())) return null;
            var assembly = _modelAssemblies[tmp[1].Trim()];
            var modelType = assembly.GetType(tmp[0].Trim());

            return typeof(IRepository<>).MakeGenericType(modelType);
        }

    }
}
