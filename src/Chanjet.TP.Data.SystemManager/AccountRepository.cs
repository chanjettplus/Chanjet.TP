
using Chanjet.TP.Data;
using Chanjet.TP.SystemManager.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;


namespace Chanjet.TP.SystemManager.Data
{
    public class AccountRepository : RepositoryBase<Account>, IAccountRepository
    {
        private IDatabase _db;
        public AccountRepository( IDatabase db)
            :base( db)
        {
            _db = db;
        } 
   
        public override IEnumerable<Account> GetAll()
        {
            //return base.GetAll();
            return _db.Query<Account>("select cAcc_Num as Number,cAcc_Name as Name from eap_account");
  
        }
    }
}
