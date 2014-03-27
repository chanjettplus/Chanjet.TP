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
        private IDatabase _db;

        public RepositoryBase( IDatabase db)
        {
            _db = db;
        }


        public virtual void Insert(T entity)
        {
            _db.Insert(entity);
        }

        public virtual void Insert(string tableName, T entity)
        {
            _db.Insert(tableName, tableName);
        }

        public virtual void Update(T entity)
        {
            _db.Update(entity);
        }

        public virtual void Update(string tableName, T entity)
        {
            _db.Update(tableName, entity);
        }

        public virtual void Delete(T entity)
        {
            _db.Delete(entity);
        }

        public virtual void Delete(string tableName, T entity)
        {
            _db.Delete(tableName, entity);
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
