using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Web;
using System.Data;
using System.Reflection;
namespace CommonLogin
{
    public class CommonLoginUsr : DataAccessLayer.Common
    {
        delegate bool TryParse<T>(string str, out T value);

        public T GetValue<T>(object value)
        {

            if (typeof(T).Name == "String" && (string)value == "")
            {
                value = "";
            }
            if (typeof(T).Name == "Int32" && (string)value == "")
            {
                value = 0;
            }
            ////float
            if (typeof(T).Name == "Single" && (string)value == "")
            {
                value = 0;
            }
            ////decimal
            if (typeof(T).Name == "Decimal" && (string)value == "")
            {
                value = 0;
            }
            if (typeof(T).Name == "DateTime" && (string)value == "")
            {
                value = default(DateTime);
            }
            if (typeof(T).Name == "Boolean" && (string)value == "")
            {
                value = default(bool);
            }
            return (T)Convert.ChangeType(value, typeof(T));
        }

        public static void PrintError(Exception ex, string PageName)
        {
            //write log to a text file

            FileInfo fi = new FileInfo(HttpContext.Current.Server.MapPath("~/upload/") + "ErrorLog.txt");
            if (!fi.Exists)
            {
                using (StreamWriter sw = fi.CreateText())
                {
                    sw.WriteLine("===================================================");
                    sw.WriteLine("This is a new exception from database access module : " + DateTime.Now);
                    sw.WriteLine("===================================================");
                    sw.WriteLine(ex.Message + ex.StackTrace + ex.Source + ex.HelpLink);
                    sw.WriteLine("===================================================");
                    sw.WriteLine("Page Name " + PageName);
                    sw.Close();
                }
            }
            else
            {
                fi.Refresh();
                if (!fi.IsReadOnly)
                {
                    using (StreamWriter sw = fi.AppendText())
                    {
                        sw.WriteLine("===================================================");
                        sw.WriteLine("This is a new exception from database access module : " + DateTime.Now);
                        sw.WriteLine("===================================================");
                        sw.WriteLine(ex.Message + ex.StackTrace + ex.Source + ex.HelpLink);
                        sw.WriteLine("===================================================");
                        sw.WriteLine("Page Name " + PageName);
                        sw.Close();
                    }
                }
            }
        }


        public static void PrintError(string Message)
        {
            //write log to a text file

            FileInfo fi = new FileInfo(HttpContext.Current.Server.MapPath("~/upload/") + "ErrorLog.txt");
            if (!fi.Exists)
            {
                using (StreamWriter sw = fi.CreateText())
                {
                    sw.WriteLine("===================================================");
                    sw.WriteLine("This is a new exception from database access module : " + DateTime.Now);
                    sw.WriteLine("===================================================");
                    sw.WriteLine(Message);
                    sw.WriteLine("===================================================");
                    sw.WriteLine("Page Name " + Message);
                    sw.Close();
                }
            }
            else
            {
                fi.Refresh();
                if (!fi.IsReadOnly)
                {
                    using (StreamWriter sw = fi.AppendText())
                    {
                        sw.WriteLine("===================================================");
                        sw.WriteLine("This is a new exception from database access module : " + DateTime.Now);
                        sw.WriteLine("===================================================");
                        sw.WriteLine(Message);
                        sw.WriteLine("===================================================");
                        sw.WriteLine("Page Name " + Message);
                        sw.Close();
                    }
                }
            }
        }

        public static DataTable ToDataTable<T>(List<T> items)
        {
            DataTable dataTable = new DataTable(typeof(T).Name);

            //Get all the properties
            PropertyInfo[] Props = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);
            foreach (PropertyInfo prop in Props)
            {
                //Defining type of data column gives proper data table 
                var type = (prop.PropertyType.IsGenericType && prop.PropertyType.GetGenericTypeDefinition() == typeof(Nullable<>) ? Nullable.GetUnderlyingType(prop.PropertyType) : prop.PropertyType);
                //Setting column names as Property names
                dataTable.Columns.Add(prop.Name, type);
            }
            foreach (T item in items)
            {
                var values = new object[Props.Length];
                for (int i = 0; i < Props.Length; i++)
                {
                    //inserting property values to datatable rows
                    values[i] = Props[i].GetValue(item, null);
                }
                dataTable.Rows.Add(values);
            }
            //put a breakpoint here and check datatable
            return dataTable;
        }
    }
    public class TableEntity
    {

    }

    public class Tbl_Login
    {

        public string Usrname { get; set; }
        public string UsrPass { get; set; }
        public string UsrRole { get; set; }
        public string url { get; set; }
        public string Msg { get; set; }
    }

}