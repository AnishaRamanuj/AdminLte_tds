using ClosedXML.Excel;
using System.Data;
using System.IO;
using System.Linq;

/// <summary>
/// Summary description for ExcelUtility
/// </summary>
public static class ExcelUtility
{
    public static byte[] ToExcel(this DataTable dataTable, string sheetName = "Sheet1")
    {
        using (XLWorkbook wb = new XLWorkbook())
        {
            wb.Worksheets.Add(dataTable, sheetName);
            wb.Worksheets.Worksheet(1).Columns().AdjustToContents();
            wb.Worksheets.Worksheet(1).Rows().AdjustToContents();
            using (var stream = new MemoryStream())
            {
                wb.SaveAs(stream);
                return stream.ToArray();
            }
        }
    }

    public static byte[] ToExcel(this DataSet dataset, string[] sheetNames = null)
    {
        using (XLWorkbook wb = new XLWorkbook())
        {
            sheetNames = Enumerable.Range(0, dataset.Tables.Count)
                .Select(i => sheetNames != null && !string.IsNullOrEmpty(sheetNames.ElementAtOrDefault(i)) ? sheetNames[i] : "Sheet " + (i + 1).ToString()).ToArray();
            for (int i = 0, j = dataset.Tables.Count; i < j; i++)
            {
                wb.Worksheets.Add(dataset.Tables[i], sheetNames[i]);
                wb.Worksheets.Worksheet(i + 1).Columns().AdjustToContents();
                wb.Worksheets.Worksheet(i + 1).Rows().AdjustToContents();
            }
            using (var stream = new MemoryStream())
            {
                wb.SaveAs(stream);
                return stream.ToArray();
            }
        }
    }
}