using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Chanjet.TP.Model;

namespace Chanjet.TP.Data
{
    public class UnitOfWork : IUnitOfWork
    {
        private IDatabase _db;

        public UnitOfWork(IDatabase db )
        {
            _db = db;
        }

        public void Begin()
        {
            _db.BeginTransaction();
        }

        public void Commit()
        {
            _db.CompleteTransaction();
        }

        public void Rollback()
        {
            _db.AbortTransaction();
        }
    }
}
