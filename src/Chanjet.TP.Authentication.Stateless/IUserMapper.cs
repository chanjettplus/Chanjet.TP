using Nancy.Security;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Chanjet.TP.Authentication.Stateless
{
    public interface IUserMapper
    {
        String ValidateUser(string username, string password, string account, DateTime loginDate, int clientType, string version);
        IUserIdentity GetUserFromTicket(string ticket);
        void RemoveTicket(string ticket);

    }
}
