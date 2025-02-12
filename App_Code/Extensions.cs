﻿using System.Collections.Generic;
using System.Data;
using System.Reflection;
using System.Runtime.CompilerServices;
using System.Web;

/// <summary>
/// Extensions methods
/// </summary>
public static class Extensions
{
    public static void WriteJson(this HttpResponse response, string json)
    {
        response.Clear();
        response.ContentType = "application/json";
        response.Write(json);
        response.Flush();
        response.End();
    }

    public static DataTable ToDatatable<T>(this List<T> items)
    {
        DataTable dataTable = new DataTable(typeof(T).Name);
        PropertyInfo[] Props = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);
        foreach (PropertyInfo prop in Props)
        {
            dataTable.Columns.Add(prop.Name);
        }
        foreach (T item in items)
        {
            var values = new object[Props.Length];
            for (int i = 0; i < Props.Length; i++)
            {
                values[i] = Props[i].GetValue(item, null);
            }
            dataTable.Rows.Add(values);
        }
        return dataTable;
    }
}