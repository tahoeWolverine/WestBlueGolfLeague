using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.FtpClient;
using System.Text;
using System.Threading.Tasks;

namespace AccessExport
{
    public class FtpUtil
    {
        public delegate bool ShouldDownloadFile(string fileName);

        public static void DownloadFtpDirectory(NetworkCredential creds, string host, string remoteDir, string destinationDir, ShouldDownloadFile sdlf)
        {
            Directory.CreateDirectory(destinationDir);

            using (FtpClient ftp = new FtpClient { Credentials = creds, Host = host })
            {
                ftp.Connect();

                var listing = ftp.GetListing(remoteDir);

                foreach (var item in listing)
                {
                    if (item.Type != FtpFileSystemObjectType.File)
                    {
                        continue;
                    }

                    bool shouldDownload = sdlf(item.Name);

                    if (!shouldDownload) continue;

                    string fileFullPath = destinationDir + "/" + item.Name;

                    using (var stream = ftp.OpenRead(remoteDir + "/" + item.Name, FtpDataType.Binary))
                    {
                        if (stream.Length != 0)
                        {
                            // Create a FileStream object to write a stream to a file
                            using (FileStream fileStream = File.Create(fileFullPath, (int)stream.Length))
                            {
                                stream.CopyTo(fileStream);
                            }
                        }
                    }
                }
            }
        }
    }
}
