<%@ WebService Language="C#" Class="DrawingMaster" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data.SqlClient;
using System.Data;
using DataAccessLayer;
using Microsoft.ApplicationBlocks1.Data;
using CommonLibrary;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using System.Globalization;
using System.IO;
using ClosedXML.Excel;
using System.Net;
using System.Linq;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class DrawingMaster : System.Web.Services.WebService
{
    public const string UPLOAD_BULK_DRAWING_RECORD_CLIENTNAME_CELLADDRESS = "C1";
    public const string UPLOAD_BULK_DRAWING_RECORD_PROJECTNAME_CELLADDRESS = "C2";
    public const string UPLOAD_BULK_DRAWING_RECORD_DRAWINGNUMBER_CELLADDRESS = "B";
    public const string UPLOAD_BULK_DRAWING_RECORD_DRAWINGNAME_CELLADDRESS = "C";
    public const string UPLOAD_BULK_DRAWING_RECORD_FOLDERPATH = "~/Uploads/";
    public const string UPLOAD_DRAWING_STATUS_SUCCESS = "Success";
    public const string UPLOAD_DRAWING_STATUS_FAILED = "Failed";
    public const string UPLOAD_DRAWING_STATUS_PARTIAL_SUCCESS = "Partial Success";

    [WebMethod]
    public string GetDrawingRecord(string compid, string Srch, int pageIndex, int pageSize, string sortType)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_DrawingMaster> obj_Job = new List<vw_DrawingMaster>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@pageIndex", pageIndex);
            param[3] = new SqlParameter("@pageSize", pageSize);
            param[4] = new SqlParameter("@sortType", sortType);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetDrawing", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_DrawingMaster()
                    {
                        TSId = objComm.GetValue<int>(drrr["sino"].ToString()),
                        DrawingId = objComm.GetValue<int>(drrr["Drawing_Id"].ToString()),
                        DrawingName = objComm.GetValue<string>(drrr["DName"].ToString()),
                        DrawingNumber = objComm.GetValue<string>(drrr["DNumber"].ToString()),
                        DrawingDesc = objComm.GetValue<string>(drrr["DDescription"].ToString()),
                        ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                        ProjectName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                        ClientId = objComm.GetValue<int>(drrr["ClientId"].ToString()),
                        ProjectId = objComm.GetValue<int>(drrr["ProjectId"].ToString()),
                        TotalCount = objComm.GetValue<int>(drrr["Totalcount"].ToString())
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_DrawingMaster> tbl = obj_Job as IEnumerable<vw_DrawingMaster>;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string InsertUpdateDrawing(int compId, int drawingId, string drawingName, string drawingNum, string Description, int projectId, int clientId)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectDrawing> obj_Job = new List<tbl_ProjectDrawing>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[7];
            param[0] = new SqlParameter("@Compid", compId);
            param[1] = new SqlParameter("@Did", drawingId);
            param[2] = new SqlParameter("@DrawingNum", drawingNum);
            param[3] = new SqlParameter("@DrawingName", drawingName);
            param[4] = new SqlParameter("@description", "");
            param[5] = new SqlParameter("@ProjectId", projectId);
            param[6] = new SqlParameter("@ClientId", clientId);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_InserUpdateDrawing", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectDrawing()
                    {
                        DrawingId = objComm.GetValue<int>(drrr["did"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_ProjectDrawing> tbl = obj_Job as IEnumerable<tbl_ProjectDrawing>;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string DeleteDrawing(int compid, int drawingId)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectDrawing> obj_Job = new List<tbl_ProjectDrawing>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@drawingid", drawingId);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetDeleteDrawing", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectDrawing()
                    {
                        DrawingId = objComm.GetValue<int>(drrr["did"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectDrawing> tbl = obj_Job as IEnumerable<tbl_ProjectDrawing>;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GetDrawingClients(int compId, int drawingId)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Client> clients = new List<tbl_Client>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@CompId", compId);
            param[1] = new SqlParameter("@DrawingId", drawingId);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_bootstrap_GetDrawingClients", param))
            {
                while (drrr.Read())
                {
                    clients.Add(new tbl_Client()
                    {
                        Cltid = objComm.GetValue<int>(drrr["CLTId"].ToString()),
                        Clientname = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(clients);
    }

    [WebMethod]
    public string GetDrawingProjects(int compId, int clientId, int drawingId)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        DataSet ds;
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@CompId", compId);
            param[1] = new SqlParameter("@ClientId", clientId);
            param[2] = new SqlParameter("@DrawingId", drawingId);
            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_bootstrap_GetDrawingProjects", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return ds.GetXml();
    }

    [WebMethod]
    public string BulkUploadDrawingRecords()
    {
        HttpContext.Current.Response.ClearHeaders();
        vw_DrawingMaster drawingMaster = new vw_DrawingMaster();
        //string response = "Failed to Upload";
        List<UploadDrawingRecord> uploadDrawingRecords = new List<UploadDrawingRecord>();
        BulkUploadDrawingsResponse bulkUploadResponse = new BulkUploadDrawingsResponse();
        bulkUploadResponse.BulkUploadStatus = UPLOAD_DRAWING_STATUS_FAILED;
        bulkUploadResponse.BulkUploadMessage = "Failed to Upload";

        //Create the Directory.
        string path = HttpContext.Current.Server.MapPath(UPLOAD_BULK_DRAWING_RECORD_FOLDERPATH);
        if (!Directory.Exists(path))
        {
            Directory.CreateDirectory(path);
        }

        //Fetch the File.
        HttpPostedFile postedFile = HttpContext.Current.Request.Files[0];

        //Fetch the File Name.
        var file = HttpContext.Current.Request.Files.Count > 0 ? HttpContext.Current.Request.Files[0] : null;

        if (file != null && file.ContentLength > 0)
        {
            var fileName = Path.GetFileName(file.FileName);
            string filePath = path + fileName;
            postedFile.SaveAs(filePath);

            string compId = HttpContext.Current.Request.Form["compId"];
            drawingMaster.CompId = Convert.ToInt32(compId);

            using (XLWorkbook workBook = new XLWorkbook(filePath))
            {
                IXLWorksheet workSheet = workBook.Worksheet(1);
                drawingMaster.ClientName = workSheet.Cell(UPLOAD_BULK_DRAWING_RECORD_CLIENTNAME_CELLADDRESS).Value.ToString();
                drawingMaster.ProjectName = workSheet.Cell(UPLOAD_BULK_DRAWING_RECORD_PROJECTNAME_CELLADDRESS).Value.ToString();

                try
                {
                    drawingMaster = GetClientAndProjectByName(drawingMaster);
                    if (drawingMaster.ClientId > 0 && drawingMaster.ProjectId > 0)
                    {
                        uploadDrawingRecords = SendDrawingDataToDatabase(workSheet, drawingMaster.ClientId, drawingMaster.ProjectId, drawingMaster.CompId);
                        bulkUploadResponse.UploadedDrawingRecords = uploadDrawingRecords;

                        if (uploadDrawingRecords.Exists(r => r.UploadStatus == UPLOAD_DRAWING_STATUS_FAILED))
                        {
                            bulkUploadResponse.BulkUploadStatus = UPLOAD_DRAWING_STATUS_PARTIAL_SUCCESS;
                            bulkUploadResponse.BulkUploadMessage = "Few Drawings failed to upload, please check error messages.";
                        }
                        else
                        {
                            bulkUploadResponse.BulkUploadStatus = UPLOAD_DRAWING_STATUS_SUCCESS;
                            bulkUploadResponse.BulkUploadMessage = "All Drawings uploaded successfully";
                        }
                    }
                    else
                    {
                        bulkUploadResponse.BulkUploadStatus = UPLOAD_DRAWING_STATUS_FAILED;
                        bulkUploadResponse.BulkUploadMessage = "Client Name/Project Name not exists in the system OR not matched!";
                    }
                }
                catch (Exception ex)
                {
                    throw ex;
                }
                finally
                {
                    //Send OK Response to Client.
                    HttpContext.Current.Response.StatusCode = (int)HttpStatusCode.OK;
                    HttpContext.Current.Response.Write(new JavaScriptSerializer().Serialize(bulkUploadResponse));
                    HttpContext.Current.Response.Flush();
                    HttpContext.Current.Response.End();
                }
            }
        }
        return new JavaScriptSerializer().Serialize(uploadDrawingRecords);
    }

    private List<UploadDrawingRecord> SendDrawingDataToDatabase(IXLWorksheet workSheet, int clientId, int projectId, int compId)
    {
        List<string> drawingNumbers = new List<string>();
        UploadDrawingRecord drawingMaster = new UploadDrawingRecord();
        List<UploadDrawingRecord> uploadDrawingRecords = new List<UploadDrawingRecord>();
        int wr = workSheet.Rows().Count();
        try
        {
            for (int i = 4; i < workSheet.Rows().Count(); i++)
            {
                IXLRow row = workSheet.Row(i);
                drawingMaster.DrawingNumber = row.Cell(UPLOAD_BULK_DRAWING_RECORD_DRAWINGNUMBER_CELLADDRESS).Value.ToString();
                drawingMaster.DrawingName = row.Cell(UPLOAD_BULK_DRAWING_RECORD_DRAWINGNAME_CELLADDRESS).Value.ToString();

                if (!string.IsNullOrEmpty(drawingMaster.DrawingNumber) && !string.IsNullOrEmpty(drawingMaster.DrawingName))
                {
                    drawingMaster.CompId = compId;
                    drawingMaster.ProjectId = projectId;
                    drawingMaster.ClientId = clientId;

                    if (drawingNumbers.Contains(drawingMaster.DrawingNumber))
                    {
                        uploadDrawingRecords.Add(new UploadDrawingRecord()
                        {
                            UploadStatus = UPLOAD_DRAWING_STATUS_FAILED,
                            UploadFailureReason = "Duplicate entry in the sheet for Drawing No." + drawingMaster.DrawingNumber,
                        });
                    }
                    else
                    {
                        drawingNumbers.Add(drawingMaster.DrawingNumber);
                        drawingMaster.DrawingId = InsertUpdateDrawingBulk(drawingMaster);
                        if (drawingMaster.DrawingId > 0)
                        {
                            uploadDrawingRecords.Add(new UploadDrawingRecord()
                            {
                                UploadStatus = UPLOAD_DRAWING_STATUS_SUCCESS,
                                UploadFailureReason =  "Drawing No." + drawingMaster.DrawingNumber
                            });
                        }
                        else if (drawingMaster.DrawingId == -2)
                        {
                            uploadDrawingRecords.Add(new UploadDrawingRecord()
                            {
                                UploadStatus = UPLOAD_DRAWING_STATUS_FAILED,
                                UploadFailureReason = "Duplicate entry in the sheet for Drawing No." + drawingMaster.DrawingNumber,
                            });
                        }
                        else
                        {
                            uploadDrawingRecords.Add(new UploadDrawingRecord()
                            {
                                UploadStatus = UPLOAD_DRAWING_STATUS_FAILED,
                                UploadFailureReason = "Failed to insert data in the database",
                            });
                        }
                    }
                }
                else
                {
                    break;
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return uploadDrawingRecords;
    }

    private int InsertUpdateDrawingBulk(UploadDrawingRecord drawingMaster)
    {
        int drawingId = 0;
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        SqlParameter[] param = new SqlParameter[6];
        tbl_Project_Client tbl_Project_Client = new tbl_Project_Client();
        param[0] = new SqlParameter("@CompId", drawingMaster.CompId);
        param[1] = new SqlParameter("@ProjectId", drawingMaster.ProjectId);
        param[2] = new SqlParameter("@ClientId", drawingMaster.ClientId);
        param[3] = new SqlParameter("@DrawingName", drawingMaster.DrawingName);
        param[4] = new SqlParameter("@DrawingNumber", drawingMaster.DrawingNumber);

        object objDrawingId = SqlHelper.ExecuteScalar(objComm._cnnString, CommandType.StoredProcedure, "usp_bootstrap_InsertDrawing_BulkInsert", param);
        if (objDrawingId != null && objDrawingId.ToString() != "")
            int.TryParse(objDrawingId.ToString(), out drawingId);

        return drawingId;
    }

    private vw_DrawingMaster GetClientAndProjectByName(vw_DrawingMaster drawingMaster)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();

        SqlParameter[] param = new SqlParameter[3];
        param[0] = new SqlParameter("@CompId", drawingMaster.CompId);
        param[1] = new SqlParameter("@ClientName", drawingMaster.ClientName);
        param[2] = new SqlParameter("@ProjectName", drawingMaster.ProjectName);
        using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_bootstrap_GetDrawingClientID_ProjectId", param))
        {
            if (drrr.HasRows)
            {
                while (drrr.Read())
                {
                    drawingMaster.ClientId = objComm.GetValue<int>(drrr["CLTId"].ToString());
                    drawingMaster.ProjectId = objComm.GetValue<int>(drrr["ProjectId"].ToString());
                }
            }
        }
        return drawingMaster;
    }
}

public class UploadDrawingRecord
{
    public string DrawingNumber { get; set; }
    public string DrawingName { get; set; }
    public int DrawingId { get; set; }
    public int CompId { get; set; }
    public int ClientId { get; set; }
    public string ClientName { get; set; }
    public int ProjectId { get; set; }
    public string ProjectName { get; set; }
    public string UploadStatus { get; set; }
    public string UploadFailureReason { get; set; }
}

public class BulkUploadDrawingsResponse
{
    public string BulkUploadStatus { get; set; }
    public string BulkUploadMessage { get; set; }
    public List<UploadDrawingRecord> UploadedDrawingRecords { get; set; }
}