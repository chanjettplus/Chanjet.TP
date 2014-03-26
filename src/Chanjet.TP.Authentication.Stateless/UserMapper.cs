using Chanjet.TP.Core;
using Nancy.Security;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Chanjet.TP.Authentication.Stateless
{
    public class UserMapper : IUserMapper
    {
        private ICache _cache;

        public UserMapper(ICache cache)
        {
            _cache = cache;
        }

        public String ValidateUser(string username, string password, string account, DateTime loginDate, int clientType)
        {
            //登录认证
            //todo:

            var userInfo = new UserIdentity() { UserName = username };

            //生成票并存入Cache
            var ticket = Guid.NewGuid().ToString();

            if (_cache.Contains(ticket))
                _cache[ticket] = userInfo;
            else
                _cache.Add(ticket, userInfo);

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
