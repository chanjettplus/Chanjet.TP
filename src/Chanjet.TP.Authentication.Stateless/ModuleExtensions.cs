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
        /*
        public static Response UserLoggedInResponse(Guid userIdentifier, DateTime? cookieExpiry = null)
        {
            var response = (Response)HttpStatusCode.OK;

            var authenticationCookie =
                BuildCookie(userIdentifier, cookieExpiry, currentConfiguration);

            response.AddCookie(authenticationCookie);

            return response;
        }

        private static INancyCookie BuildCookie(Guid userIdentifier, DateTime? cookieExpiry, FormsAuthenticationConfiguration configuration)
        {
            var cookieContents = EncryptAndSignCookie(userIdentifier.ToString(), configuration);

            var cookie = new NancyCookie(formsAuthenticationCookieName, cookieContents, true, configuration.RequiresSSL) { Expires = cookieExpiry };

            if (!string.IsNullOrEmpty(configuration.Domain))
            {
                cookie.Domain = configuration.Domain;
            }

            if (!string.IsNullOrEmpty(configuration.Path))
            {
                cookie.Path = configuration.Path;
            }

            return cookie;
        }


        private static string EncryptAndSignCookie(string cookieValue)
        {
            var encryptedCookie = CryptographyConfiguration.Default.EncryptionProvider.Encrypt(cookieValue);
            var hmacBytes = GenerateHmac(encryptedCookie);
            var hmacString = Convert.ToBase64String(hmacBytes);

            return String.Format("{1}{0}", encryptedCookie, hmacString);
        }

        private static byte[] GenerateHmac(string encryptedCookie)
        {
            return CryptographyConfiguration.Default.HmacProvider.GenerateHmac(encryptedCookie);
        }
         * 
         * */
    }
}
