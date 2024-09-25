<%@ WebHandler Language="C#" Class="Staff_PhotoUpload" %>
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
using System.Reflection;

public class Staff_PhotoUpload : IHttpHandler
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

                string[] id = context.Request.QueryString["staffcode"].Split(',');

                string staffcode = id[0].ToString();
                string compid = id[1].ToString();

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
                    string Spath = path + "/" + "Image";
                    if (Directory.Exists(path))
                    {
                        Directory.CreateDirectory(Spath);

                        System.IO.DirectoryInfo di = new DirectoryInfo(Spath);

                        foreach (FileInfo file in di.GetFiles())
                        {
                            file.Delete();
                        }
                        foreach (DirectoryInfo dir in di.GetDirectories())
                        {
                            dir.Delete(true);
                        }
                    }
                    else
                    {
                        Directory.CreateDirectory(Spath);
                    }

                    fileName = files.FileName;// Path.GetFileName(files.FileName);
                    if (fileName != "")
                    {
                        files.SaveAs(eReturnspath + "/" + foldersPath + "/" + "Image" + "/" + fileName);
                        fPath = Spath;
                        ImgType = "Staff";
                    }
                }

                var outPutDirectory = Path.GetDirectoryName(Assembly.GetExecutingAssembly().CodeBase);
                fPath = fPath + '/' + fileName;
                string filePath = "/UploadData" + foldersPath + "/" + "Image" + "/" + fileName;
                CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
                List<tbl_StaffImage> listUpd = new List<tbl_StaffImage>();

                SqlParameter[] param = new SqlParameter[5];
                param[0] = new SqlParameter("@compid", compid);
                param[1] = new SqlParameter("@Staffcode", staffcode);
                //param[0] = new SqlParameter("@Cat", ImgCat);
                param[2] = new SqlParameter("@ImgType", ImgType);
                param[3] = new SqlParameter("@ImgName", ImgName);
                //param[3] = new SqlParameter("@CTitle", CTitle);
                //param[4] = new SqlParameter("@Upld", Upld);
                param[4] = new SqlParameter("@fPath", filePath);


                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_UpsertStaffImage", param))
                {
                    while (drrr.Read())
                    {
                        listUpd.Add(new tbl_StaffImage()
                        {
                            ImgId = objComm.GetValue<int>(drrr["EmpImg_id"].ToString()),
                        });
                    }
                }

                string json = new JavaScriptSerializer().Serialize(
                  new
                  {
                      name = fileName
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