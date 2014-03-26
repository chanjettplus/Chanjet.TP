using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Chanjet.TP.Data
{
    public interface IUnitOfWork
    {
        void Begin();
        void Commit();
        void Rollback();

    }
}
