using Nancy.Security;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Chanjet.TP.Authentication.Stateless
{
    public class UserMapper 
    {
        private static List<Tuple<string, string, Guid>> Users = new List<Tuple<string, string, Guid>>();
        static readonly List<Tuple<string, string>> ActiveApiKeys = new List<Tuple<string, string>>();

        static UserMapper()
        {
            Users.Add(new Tuple<string, string, Guid>("admin", "admin", new Guid("55E1E49E-B7E8-4EEA-8459-7A906AC4D4C0")));
            Users.Add(new Tuple<string, string, Guid>("user", "user", new Guid("56E1E49E-B7E8-4EEA-8459-7A906AC4D4C0")));
        }



        public static IUserIdentity GetUserFromApiKey(string apiKey)
        {
            var activeKey = ActiveApiKeys.FirstOrDefault(x => x.Item2 == apiKey);

            if (activeKey == null)
            {
                return null;
            }

            var userRecord = Users.First(u => u.Item1 == activeKey.Item1);
            return new UserIdentity { UserName = userRecord.Item1 };
        }

        public static String ValidateUser(string username, string password, string account)
        {
            var userRecord = Users.Where(u => u.Item1 == username && u.Item2 == password).FirstOrDefault();

            if (userRecord == null)
            {
                return null;
            }

            var apiKey = Guid.NewGuid().ToString();
            ActiveApiKeys.Add(new Tuple<string, string>(username, apiKey));
            return apiKey;            
       
        }

        public static void RemoveApiKey(string apiKey)
        {
            var apiKeyToRemove = ActiveApiKeys.First(x => x.Item2 == apiKey);
            ActiveApiKeys.Remove(apiKeyToRemove);
        }
    }
}
