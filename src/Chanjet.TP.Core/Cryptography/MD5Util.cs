using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;

namespace Chanjet.TP.Core.Cryptography
{
    public static class MD5Util
    {
        public static string Encrypt(string str)
        {
            UTF8Encoding encode = new UTF8Encoding();
            Byte[] hashByte = new byte[] { };

            MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider();

            hashByte = md5.ComputeHash(encode.GetBytes(str));

            return Convert.ToBase64String(hashByte);
        }
    }
}
