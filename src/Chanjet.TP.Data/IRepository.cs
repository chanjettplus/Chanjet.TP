using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Chanjet.TP.Data
{
    public interface IRepository<T> where T : class
    {
        void Add(T entity);
        void Update(T entity);
        void Delete(T entity);
        T GetById(long id);
        T GetById(string id);
        IEnumerable<T> GetAll();

        T DynamicMap<T>(object source);
    }
}
