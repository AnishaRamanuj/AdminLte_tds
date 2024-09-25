using System.Collections.Generic;

public class TimesheetEditData
{
    public List<int> SelectedIDs { get; set; }
    public bool Staffstatus { get; set; }
    public string CompId { get; set; }
    public string JobApprover { get; set; }
    public string Status { get; set; }
    public List<TimesheetEditRecord> EditedRecords { get; set; }
}

public class TimesheetEditRecord
{
    public int TsId { get; set; }
    public bool? IsBillable { get; set; }
    public string Reason { get; set; }
    public string EditedHours { get; set; }
}