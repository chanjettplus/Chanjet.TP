using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Chanjet.TP.Data
{
    public interface IDatabase
    {
        void BeginTransaction();

        void CompleteTransaction();

        void AbortTransaction();

        object Insert(object o);

        object Insert(string tableName, object poco);

        object Insert(string tableName, string primaryKeyName, object poco);

        object Insert(string tableName, string primaryKeyName, bool autoIncrement, object poco);

        int Update(object o);

        int Update(string tableName, object o);

        int Update(object poco, IEnumerable<string> columns);

        int Update(object poco, object primaryKeyValue);

        int Update(object poco, object primaryKeyValue, IEnumerable<string> columns);

        int Update<T>(string sql, params object[] args);
        
        int Delete(object o);

        int Delete(string tableName, object o);

        int Delete<T>(object pocoOrPrimaryKey);

        int Delete<T>(string sql, params object[] args);

        IEnumerable<T> Query<T>(string sql, params object[] args);

    }
}
