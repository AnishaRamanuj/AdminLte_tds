using System;
using System.Collections.Generic;
using System.IO;
using System.Web;

/// <summary>
/// Summary description for Thumbnail
/// </summary>
public class Thumbnail
{
    private string fileName = string.Empty;
    private int fileSize;
    private string id;
    private string originalFileName = string.Empty;
    private byte[] thumbnail_data;
    private string fileExt;

    public Thumbnail(string id, string fileName, string originalFileName, int filesize)
    {
        ID = id;
        FileName = fileName;
        OriginalFileName = originalFileName;
        FileSize = filesize;
    }

    public Thumbnail(string id, byte[] data)
    {
        ID = id;
        Data = data;
    }

    public string ID
    {
        get { return id; }
        set { id = value; }
    }

    public byte[] Data
    {
        get { return thumbnail_data; }
        set { thumbnail_data = value; }
    }

    /// <summary>
    /// Unique file name genereated while saving the file in the server
    /// </summary>
    public string FileName
    {
        get { return fileName; }
        set { fileName = value; }
    }

    /// <summary>
    /// Name of the file uploaded by the user
    /// </summary>
    public string OriginalFileName
    {
        get { return originalFileName; }
        set { originalFileName = value; }
    }

    public bool HasFile
    {
        get
        {
            HttpCookie fileList = HttpContext.Current.Request.Cookies["fileList"];
            List<string> uploadedFiles = new List<string>();
            if (fileList != null)
            {
                string[] files = fileList.Value.Split(new string[] { "##" }, StringSplitOptions.RemoveEmptyEntries);
                foreach (string file in files)
                {
                    string[] fileArray = file.Split(new string[] { "$$" }, StringSplitOptions.RemoveEmptyEntries);
                    if (fileArray.Length > 0)
                    {
                        if (fileArray[1].Contains("@@"))
                        {
                            string[] fileNames = fileArray[1].Split(new string[] {"@@"},
                                                                    StringSplitOptions.RemoveEmptyEntries);
                            if (fileNames.Length > 0)
                            {
                                OriginalFileName = fileNames[0];
                            }
                        }
                        uploadedFiles.Add(fileArray[0]);
                    }
                }
            }

            if (uploadedFiles.Contains(id))
                return true;
            if (File.Exists(HttpContext.Current.Server.MapPath("~/upload/" + fileName)))
                File.Delete(HttpContext.Current.Server.MapPath("~/upload/" + fileName));
            return false;
        }
    }

    /// <summary>
    /// Size of the file uploaded by the user
    /// </summary>
    public int FileSize
    {
        get { return fileSize; }
        set { fileSize = value; }
    }

    /// <summary>
    /// Content type of the file uploaded by the user
    /// </summary>
    public string ContentType
    {
        get { return fileExt; }
        set { fileExt = value; }
    }
}