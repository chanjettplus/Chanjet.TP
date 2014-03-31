using Nancy;
using Nancy.Cookies;
using Nancy.Cryptography;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Chanjet.TP.Authentication.Stateless
{
    public static class ModuleExtensions
    {
        public static Response Login(this INancyModule module, String userIdentifier, DateTime? cookieExpiry = null)
        {
            return StatelessAuthenticationExtensions.UserLoggedInResponse(userIdentifier, cookieExpiry);
        }


        public static Response Logout(this INancyModule module)
        {
            return StatelessAuthenticationExtensions.LogOutResponse();
        }
    }
}
