using Chanjet.TP.Core;
using Nancy;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Chanjet.TP.Authentication.Stateless;
using System.IO;
using Nancy.Responses;


namespace Chanjet.TP.Authentication.Stateless
{
    public class SecureModule : NancyModule
    {
        public SecureModule( IUserMapper userMapper, ICache cache )
            :base("/api/auth")
        {
            Post["/"] = x =>
            {
                string ticket = userMapper.ValidateUser((string)this.Request.Form.username,
                                                      (string)this.Request.Form.password,
                                                      (string)this.Request.Form.account,
                                                      DateTime.Now,
                                                     0, 
                                                      "");

                if (String.IsNullOrEmpty(ticket))
                    return new Response { StatusCode = HttpStatusCode.Unauthorized };
                else
                {
                    var userIdentity = userMapper.GetUserFromTicket(ticket);

                    var response = this.Login(ticket);

                    response.Contents = GetJsonContents( new { Ticket = ticket, UserName = userIdentity.UserName }, new DefaultJsonSerializer());

                    return response;

                    //return this.Response.AsJson(new { Ticket = ticket, UserName = userIdentity.UserName, RememberMe = false });
                }
                    
           
            };

            Delete["/"] = x =>
            {
                var ticket = (string)this.Request.Form.ticket;
                userMapper.RemoveTicket(ticket);
                return new Response { StatusCode = HttpStatusCode.OK };
            };
        }

        private static Action<Stream> GetJsonContents( object model, ISerializer serializer)
        {
            return stream => serializer.Serialize("application/json", model, stream);
        }

    }
}
