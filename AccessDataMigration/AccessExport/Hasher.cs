using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace AccessExport
{
    public class Hasher
    {
        public static byte[] Hash(string data, string salt, int stretchLength = 200)
        {
            byte[] saltBytes = UTF8Encoding.UTF8.GetBytes(salt);
            byte[] dataBytes = UTF8Encoding.UTF8.GetBytes(data);

            byte[] dataPlusSalt = new byte[dataBytes.Length + saltBytes.Length];
            dataBytes.CopyTo(dataPlusSalt, 0);
            saltBytes.CopyTo(dataPlusSalt, dataBytes.Length);

            var hashAlgo = new SHA256Managed();

            var hashedBytes = hashAlgo.ComputeHash(dataPlusSalt);

            for (int i = 0; i < stretchLength; i++)
            {
                hashedBytes = hashAlgo.ComputeHash(hashedBytes);
            }

            return hashedBytes;
        }
    }
}
