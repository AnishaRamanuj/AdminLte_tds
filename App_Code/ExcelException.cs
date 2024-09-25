using System;

/// <summary>
/// Summary description for ExcelException
/// </summary>
public class ExcelException : Exception
{
    public ExcelException() : base() { }

    public ExcelException(Exception ex) : base(ex.Message, ex) { }
}