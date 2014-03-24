
using Chanjet.TP.Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Ufida.T.EAP.Dal;

namespace Chanjet.TP.SystemManager.Data
{
    public class AccountRepository : RepositoryBase<Account>, IAccountRepository
    {
        public override IEnumerable<Account> GetAll()
        {
            List<Account> result = new List<Account>();
            DBSession dbsession = DBSessionFactory.getUserCtrlTranSession("UFTSystem");

            using (IDataReader reader = dbsession.getReader("select cAcc_Num as Number,cAcc_Name as Name from eap_account"))
            {
                while (reader.Read())
                {
                    result.Add(this.DynamicMap<Account>(reader));
                }
            }

            return result;
        }
    }
}
