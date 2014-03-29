using Chanjet.TP.Core;
using Chanjet.TP.Core.Cryptography;
using Chanjet.TP.Core.DataStruct;
using Chanjet.TP.Data;
using Nancy.Security;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace Chanjet.TP.Authentication.Stateless
{
    public class UserMapper : IUserMapper
    {
        private ICache _cache;
        private IDatabase _db;

        public UserMapper(ICache cache, IDatabase db)
        {
            _cache = cache;
            _db = db;
        }



        public String ValidateUser(string username, string password, string account, DateTime loginDate, int clientType, string version)
        {
            //登录认证
            var dsName = _db.Query<string>("SELECT dsname FROM eap_account where cAcc_num='" + account +"'").FirstOrDefault();

            var userIdentity = _db.Query<UserIdentity>(String.Format("select code as UserName, name as UserShowName from [{0}]..eap_user where name = '{1}' and password = '{2}'",
                dsName, username, MD5Util.Encrypt(password)))
                .FirstOrDefault();

            if (userIdentity == null) return null;

            userIdentity.Additional = DynamicDictionary.Create(new Dictionary<string, object>());
            userIdentity.Additional.Add("DatabaseName", dsName);
            userIdentity.Additional.Add("AccountNumber", account);

            //生成票并存入Cache
            var ticket = Guid.NewGuid().ToString();

            if (_cache.Contains(ticket))
                _cache[ticket] = userIdentity;
            else
                _cache.Add(ticket, userIdentity);

            return ticket;
        }

        public IUserIdentity GetUserFromTicket(string ticket)
        {
            if (_cache.Contains(ticket))
                return _cache[ticket] as IUserIdentity;

            return null;
        }

        public void RemoveTicket(string ticket)
        {
            if (_cache.Contains(ticket))
                _cache.Remove(ticket);
        }

    }
}
