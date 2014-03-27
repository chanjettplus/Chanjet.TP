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
        private IDatabase _db;

        public RepositoryBase(IUnitOfWork uow, IDatabase db)
        {
            _uow = uow;
            _db = db;
        }


        public virtual void Insert(T entity)
        {
            _db.Insert(entity);
        }

        public virtual void Update(T entity)
        {
            _db.Update(entity);
        }

        public virtual void Delete(T entity)
        {
            _db.Delete(entity);
        }

        public virtual T GetById(long id)
        {
            return _db.Query<T>("WHERE ID=@ID", id).FirstOrDefault();
        }

        public virtual T GetById(string id)
        {
            return _db.Query<T>("WHERE ID=@ID", id).FirstOrDefault();
        }

        public virtual IEnumerable<T> GetAll()
        {
            return _db.Query<T>("");
        }



    }
}
