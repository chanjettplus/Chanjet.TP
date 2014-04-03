
using Nancy;
using Nancy.Authentication.Stateless;
using Nancy.Bootstrapper;
using Nancy.Cookies;
using Nancy.Cryptography;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Chanjet.TP.Authentication.Stateless
{
    public static class StatelessAuthenticationExtensions  
    {
        internal static string statelessAuthenticationCookieName = "_tpsa";
        /*
        public static void Enable(IPipelines pipelines, StatelessAuthenticationConfiguration configuration)
        {
            if (pipelines == null)
            {
                throw new ArgumentNullException("pipelines");
            }

            pipelines.BeforeRequest.AddItemToStartOfPipeline(GetLoadAuthenticationHook());
     
        }

        private static Func<NancyContext, Response> GetLoadAuthenticationHook()
        {
            return context =>
            {
                var user = GetAuthenticatedUserFromCookie(context);

                if (!String.IsNullOrEmpty(user))
                {
                    var container = context.Items.First().Value as ILifetimeScope;

                    container.Resolve<IUserMapper>
                    context.CurrentUser =  userMppaer.GetUserFromTicket(user);
                }

                return null;
            };
        }*/

        public static string GetAuthenticatedUserFromCookie(NancyContext context)
        {
            if (!context.Request.Cookies.ContainsKey(statelessAuthenticationCookieName))
            {
                return "";
            }

            var cookieValue = DecryptAndValidateAuthenticationCookie(context.Request.Cookies[statelessAuthenticationCookieName]);

            return cookieValue;
        }


        /// <summary>
        /// 用户登录信息加入cookie
        /// </summary>
        /// <param name="userIdentifier"></param>
        /// <param name="cookieExpiry"></param>
        /// <returns></returns>
        public static Response UserLoggedInResponse( String userIdentifier, DateTime? cookieExpiry = null)
        {
            var response = (Response)HttpStatusCode.OK;

            var authenticationCookie =
                BuildCookie(userIdentifier, cookieExpiry);

            response.AddCookie(authenticationCookie);
            
            return response;
        }

        /// <summary>
        /// 注销
        /// </summary>
        /// <returns></returns>
        public static Response LogOutResponse()
        {
            var response =
                (Response)HttpStatusCode.OK;

            var authenticationCookie = BuildLogoutCookie();

            response.AddCookie(authenticationCookie);

            return response;
        }

        /// <summary>
        /// 生成Cookie
        /// </summary>
        /// <param name="userIdentifier"></param>
        /// <param name="cookieExpiry"></param>
        /// <returns></returns>
        private static INancyCookie BuildCookie( String userIdentifier, DateTime? cookieExpiry)
        {
            var cookieContents = EncryptAndSignCookie(userIdentifier.ToString());

            var cookie = new NancyCookie(statelessAuthenticationCookieName, cookieContents, true, false) { Expires = cookieExpiry };

            return cookie;
        }

        /// <summary>
        /// 生产注销cookie
        /// </summary>
        /// <returns></returns>
        private static INancyCookie BuildLogoutCookie()
        {
            var cookie = new NancyCookie(statelessAuthenticationCookieName, String.Empty, true, false) { Expires = DateTime.Now.AddDays(-1) };
        
            return cookie;
        }


        /// <summary>
        /// 加密并签名cookie
        /// </summary>
        /// <param name="cookieValue"></param>
        /// <returns></returns>
        private static string EncryptAndSignCookie(string cookieValue)
        {
            var encryptedCookie = CryptographyConfiguration.Default.EncryptionProvider.Encrypt(cookieValue);
            var hmacBytes = GenerateHmac(encryptedCookie);
            var hmacString = Convert.ToBase64String(hmacBytes);

            return String.Format("{1}{0}", encryptedCookie, hmacString);
        }

        /// <summary>
        /// 解密并校验cookievalue
        /// </summary>
        /// <param name="cookieValue"></param>
        /// <returns></returns>
        public static string DecryptAndValidateAuthenticationCookie(string cookieValue)
        {
            var decodedCookie = Nancy.Helpers.HttpUtility.UrlDecode(cookieValue);

            var hmacStringLength = Base64Helpers.GetBase64Length(CryptographyConfiguration.Default.HmacProvider.HmacLength);

            var encryptedCookie = decodedCookie.Substring(hmacStringLength);
            var hmacString = decodedCookie.Substring(0, hmacStringLength);

            var encryptionProvider = CryptographyConfiguration.Default.EncryptionProvider;

            var hmacBytes = Convert.FromBase64String(hmacString);
            var newHmac = GenerateHmac(encryptedCookie);
            var hmacValid = HmacComparer.Compare(newHmac, hmacBytes, CryptographyConfiguration.Default.HmacProvider.HmacLength);

            var decrypted = encryptionProvider.Decrypt(encryptedCookie);

            return hmacValid ? decrypted : string.Empty;
        }


        /// <summary>
        /// 签名cookie
        /// </summary>
        /// <param name="encryptedCookie"></param>
        /// <returns></returns>
        private static byte[] GenerateHmac(string encryptedCookie)
        {
            return CryptographyConfiguration.Default.HmacProvider.GenerateHmac(encryptedCookie);
        }
    }
}
