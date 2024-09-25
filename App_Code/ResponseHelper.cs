using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for ResponseHelper
/// </summary>
public static class ResponseHelper
{
    public static void DownloadFile(HttpContext context, byte[] fileContent, string fileName, string contentType)
    {
        try
        {
            HttpResponse response = context.Response;
            response.Clear();
            response.Buffer = true;
            response.Charset = "";
            response.ContentType = contentType;
            response.AddHeader("content-disposition", "attachment;filename=" + fileName);
            response.BinaryWrite(fileContent);
            response.Flush();
            response.SuppressContent = true;
            context.ApplicationInstance.CompleteRequest();
        }
        catch (Exception ex)
        {
            throw new ExcelException(ex);
        }

    }
}