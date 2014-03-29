using Chanjet.TP.Core.Identity;
using Nancy.Security;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Chanjet.TP.Authentication.Stateless
{

    public class UserIdentity : IUserIdentity, IUser
    {
        public IEnumerable<string> Claims { get; set; }

        
        public string UserName { get; internal set; }


        public dynamic Additional
        {
            get;
            internal set;
        }
    }
}
