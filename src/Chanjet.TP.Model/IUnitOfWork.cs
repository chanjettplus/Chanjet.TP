using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Chanjet.TP.Model
{
    public interface IUnitOfWork
    {
        void Begin();
        void Commit();
        void Rollback();

    }
}
