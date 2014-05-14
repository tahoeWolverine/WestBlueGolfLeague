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

        private static void TryDownloadFile(FtpClient ftpClient, FtpListItem item, string remoteDir, string destinationDir, ShouldDownloadFile sdlf)
        {
            bool shouldDownload = sdlf(item.Name);

            if (!shouldDownload) return;

            string fileFullPath = destinationDir + "/" + item.Name;

            using (var stream = ftpClient.OpenRead(remoteDir + "/" + item.Name, FtpDataType.Binary))
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

                    try
                    {
                        TryDownloadFile(ftp, item, remoteDir, destinationDir, sdlf);
                    }
                    catch (IOException ex)
                    {
                        throw new Exception("Unable to download file.", ex);
                    }
                }
            }
        }
    }
}
