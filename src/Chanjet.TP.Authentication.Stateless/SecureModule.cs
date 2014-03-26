using Chanjet.TP.Core;
using Nancy;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Chanjet.TP.Authentication.Stateless
{
    public class SecureModule : NancyModule
    {
        public SecureModule( IUserMapper userMapper, ICache cache )
            :base("/auth")
        {
            Post["/"] = x =>
            {
                string ticket = userMapper.ValidateUser((string)this.Request.Form.Username,
                                                      (string)this.Request.Form.Password,
                                                      (string) this.Request.Form.Account,
                                                      (DateTime)this.Request.Form.LoginDate,
                                                      (int)this.Request.Form.ClientType);

                return string.IsNullOrEmpty(ticket)
                           ? new Response { StatusCode = HttpStatusCode.Unauthorized }
                           : this.Response.AsJson(new { Ticket = ticket });
            };

            Delete["/"] = x =>
            {
                var ticket = (string)this.Request.Form.Ticket;
                userMapper.RemoveTicket(ticket);
                return new Response { StatusCode = HttpStatusCode.OK };
            };
        }
    }
}
