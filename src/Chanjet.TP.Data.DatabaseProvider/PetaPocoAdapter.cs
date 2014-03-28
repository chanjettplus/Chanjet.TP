using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Chanjet.TP.Data.DatabaseProvider
{
    public class PetaPocoAdapter : PetaPoco.Database, IDatabase
    {
        public PetaPocoAdapter(string connectionStringName)
            : base(connectionStringName)
        {
        }


        public PetaPocoAdapter(System.Data.IDbConnection connection)
            : base(connection)
        {
            
        }

        public PetaPocoAdapter(string connectionString, string providerName)
            : base(connectionString, providerName)
        {
        }


        public PetaPocoAdapter(string connectionString, System.Data.Common.DbProviderFactory provider)
            : base(connectionString, provider)
        {
            
        }

        public object Insert(string tableName, object poco)
        {
            return this.Insert(tableName, "", poco);
        }

        public int Update(string tableName, object poco)
        {
            return this.Update(tableName, "", poco, "");
        }

        public int Delete(string tableName, object poco)
        {
            return this.Delete(tableName, "", poco);
        }

       
    }
}
