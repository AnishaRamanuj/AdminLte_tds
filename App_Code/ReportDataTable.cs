using System;
using System.Collections.Generic;
using System.Data;

/// <summary>
/// Summary description for ReportDataTable
/// </summary>
public class ReportDataTable
{

    public ReportDataTable()
    {

    }

    public DataTable PopulateDayOfWeek(DataTable dtStaffEffort, DateTime searchMonth)
    {
        int daysInMonth = DateTime.DaysInMonth(searchMonth.Year, searchMonth.Month);

        DataTable dtCloned = dtStaffEffort.Clone();
        for (int i = 1; i <= daysInMonth + 2; i++)
        {
            dtCloned.Columns[i].DataType = typeof(string);
        }

        foreach (DataRow row in dtStaffEffort.Rows)
        {
            dtCloned.ImportRow(row);
        }

        DataRow toInsert = dtCloned.NewRow();
        dtCloned.Rows.InsertAt(toInsert, 0);

        for (int i = 1; i <= daysInMonth; i++)
        {
            DateTime headerColumn;

            if (DateTime.TryParse(string.Format("{0}-{1}-{2}", searchMonth.Year, searchMonth.Month, i), out headerColumn))
            {
                dtCloned.Rows[0][i.ToString()] = headerColumn.DayOfWeek.ToString().Substring(0, 3);
            }
            else
            { 
            //nothing to do
            }
        }    
        return dtCloned;
    }
}

public class ReportWeekDayColumns 
{
    public string WeekDay { get; set; }
    public List<int> ColumnIndexes { get; set; }
}