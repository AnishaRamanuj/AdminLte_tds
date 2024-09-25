<%@ WebHandler Language="C#" Class="TS_ExpenseAttachmentUpload" %>
using System;
using System.IO;
using System.Net;
using System.Web;
using System.Web.Script.Serialization;
using System.Data.SqlClient;
using System.Data;
using Microsoft.ApplicationBlocks1.Data;
using System.Collections.Generic;
using CommonLibrary;
using System.Web.SessionState;

using System.Reflection;

public class TS_ExpenseAttachmentUpload : IHttpHandler,IReadOnlySessionState
{

    public void ProcessRequest(HttpContext context)
    {
        if (context.Request.Files.Count > 0)
        {
            try
            {
                string path = "";
                string fileName = "";
                string fPath = "";
                string eReturnspath = "";
                string ImgName = "";
                string ImgType = "";

                // string[] id = context.Request.QueryString["staffcode"].Split(',');

                string staffcode = context.Session["staffid"].ToString();
                string compid = context.Session["companyid"].ToString();

                eReturnspath = context.Server.MapPath("~/UploadData");
                string foldersPath =  "/" + compid + "/" + staffcode;
                path = eReturnspath + foldersPath;
                fPath = path;
                if (Directory.Exists(path) == false)
                {
                    Directory.CreateDirectory(path);
                }

                ////////////////// Staff Image 
                HttpPostedFile files = context.Request.Files[0];
                if (files.FileName != "")
                {
                    string Spath = path + "/" + "Attachement";
                    if (Directory.Exists(path))
                    {
                        Directory.CreateDirectory(Spath);

                        System.IO.DirectoryInfo di = new DirectoryInfo(Spath);

                        //foreach (FileInfo file in di.GetFiles())
                        //{
                        //    file.Delete();
                        //}
                        //foreach (DirectoryInfo dir in di.GetDirectories())
                        //{
                        //    dir.Delete(true);
                        //}
                    }
                    else
                    {
                        Directory.CreateDirectory(Spath);
                    }

                    fileName = files.FileName;// Path.GetFileName(files.FileName);

                    if (fileName != "")
                    {
                        if (File.Exists(eReturnspath + "/" + foldersPath + "/" + "Attachement" + "/" + fileName))
                        {
                                File.Delete(eReturnspath + "/" + foldersPath + "/" + "Attachement" + "/" + fileName);
                        }
                        files.SaveAs(eReturnspath + "/" + foldersPath + "/" + "Attachement" + "/" + fileName);
                        fPath = Spath;
                        ImgType = "Staff";
                    }
                }

                var outPutDirectory = Path.GetDirectoryName(Assembly.GetExecutingAssembly().CodeBase);
                fPath = fPath + '/' + fileName;
                string filePath = "/UploadData" + foldersPath + "/" + "Attachement" + "/" + fileName;


                string json = new JavaScriptSerializer().Serialize(
                  new
                  {
                      name = fileName,
                      path=filePath
                  });

                context.Response.StatusCode = (int)HttpStatusCode.OK;
                context.Response.ContentType = "text/json";
                context.Response.Write(json);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}