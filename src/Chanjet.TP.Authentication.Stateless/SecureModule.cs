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
        public SecureModule():base("/auth")
        {
            Post["/"] = x =>
            {
                string apiKey = UserMapper.ValidateUser((string)this.Request.Form.Username,
                                                      (string)this.Request.Form.Password,
                                                      (string) this.Request.Form.Account);

                return string.IsNullOrEmpty(apiKey)
                           ? new Response { StatusCode = HttpStatusCode.Unauthorized }
                           : this.Response.AsJson(new { ApiKey = apiKey });
            };

            Delete["/"] = x =>
            {
                var apiKey = (string)this.Request.Form.ApiKey;
                UserMapper.RemoveApiKey(apiKey);
                return new Response { StatusCode = HttpStatusCode.OK };
            };
        }
    }
}
