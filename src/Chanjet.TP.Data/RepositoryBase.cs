using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;


namespace Chanjet.TP.Data
{
    public class RepositoryBase<T> : IRepository<T>
        where T:class
    {
        private IUnitOfWork _uow;

        public RepositoryBase(IUnitOfWork uow)
        {
            _uow = uow;
        }

        public virtual void Add(T entity)
        {
            throw new NotImplementedException();
        }

        public virtual void Update(T entity)
        {
            throw new NotImplementedException();
        }

        public virtual void Delete(T entity)
        {
            throw new NotImplementedException();
        }

        public virtual T GetById(long id)
        {
            throw new NotImplementedException();
        }

        public virtual T GetById(string id)
        {
            throw new NotImplementedException();
        }

        public virtual IEnumerable<T> GetAll()
        {
            throw new NotImplementedException();
        }

        public T DynamicMap<T>(object source)
        {
            return AutoMapper.Mapper.DynamicMap<T>(source);
        }
    }
}
