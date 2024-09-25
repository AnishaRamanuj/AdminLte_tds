
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.IO;

namespace JTMSProject
{

    public partial class TimesheetTable
    {

        private static ITimesheetTablePersister _DefaultPersister;
        private ITimesheetTablePersister _Persister;
        private int _TSId;
        private int? _StaffCode;
        private string _StaffName;
        private int? _JobId;
        private int? _CompId;
        private int? _CLTId;
        private int? _JobApprover;
        private string _FromTime;
        private string _ToTime;
        private string _TotalTime;
        private int? _OpeId;
        private double? _OpeAmt;
        private int? _LocId;
        private int? _NarId;
        private DateTime? _Date;
        private string _Status;
        private string _Satffstatus;
        private decimal? _Mints;
        private bool? _Billable;
        private string _Narration;
        private Stream _NarrationStream;
        private string _InvoiceNo;
        private DateTime? _LastDate;
        private double? _HourlyCharges;
        private string _Reason;
        private Stream _ReasonStream;
        private int _expId;
        private int _enquiryId;

        static TimesheetTable()
        {

            // Assign default persister
            _DefaultPersister = new SqlServerTimesheetTablePersister();
        }

        public TimesheetTable()
        {

            // Assign default persister to instance persister
            _Persister = _DefaultPersister;
        }

        public TimesheetTable(int _TSId)
        {

            // Assign default persister to instance persister
            _Persister = _DefaultPersister;

            // Assign method parameter to private fields
            this._TSId = _TSId;

            // Call associated retrieve method
            Retrieve();
        }

        public TimesheetTable(DataRow row)
        {

            // Assign default persister to instance persister
            _Persister = _DefaultPersister;

            // Assign column values to private members
            for (int i = 0; i < row.Table.Columns.Count; i++)
            {
                switch (row.Table.Columns[i].ColumnName.ToUpper())
                {
                    case "TSID":
                        this.TSId = Convert.ToInt32(row[i, DataRowVersion.Current]);
                        break;

                    case "STAFFCODE":
                        if (row.IsNull(i) == false)
                        {
                            this.StaffCode = Convert.ToInt32(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "STAFFNAME":
                        if (row.IsNull(i) == false)
                        {
                            this.StaffName = (string)row[i, DataRowVersion.Current];
                        }
                        break;

                    case "JOBID":
                        if (row.IsNull(i) == false)
                        {
                            this.JobId = Convert.ToInt32(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "COMPID":
                        if (row.IsNull(i) == false)
                        {
                            this.CompId = Convert.ToInt32(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "CLTID":
                        if (row.IsNull(i) == false)
                        {
                            this.CLTId = Convert.ToInt32(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "JOBAPPROVER":
                        if (row.IsNull(i) == false)
                        {
                            this.JobApprover = Convert.ToInt32(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "FROMTIME":
                        if (row.IsNull(i) == false)
                        {
                            this.FromTime = (string)row[i, DataRowVersion.Current];
                        }
                        break;

                    case "TOTIME":
                        if (row.IsNull(i) == false)
                        {
                            this.ToTime = (string)row[i, DataRowVersion.Current];
                        }
                        break;

                    case "TOTALTIME":
                        if (row.IsNull(i) == false)
                        {
                            this.TotalTime = (string)row[i, DataRowVersion.Current];
                        }
                        break;

                    case "OPEID":
                        if (row.IsNull(i) == false)
                        {
                            this.OpeId = Convert.ToInt32(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "OPEAMT":
                        if (row.IsNull(i) == false)
                        {
                            this.OpeAmt = Convert.ToDouble(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "LOCID":
                        if (row.IsNull(i) == false)
                        {
                            this.LocId = Convert.ToInt32(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "NARID":
                        if (row.IsNull(i) == false)
                        {
                            this.NarId = Convert.ToInt32(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "DATE":
                        if (row.IsNull(i) == false)
                        {
                            this.Date = Convert.ToDateTime(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "STATUS":
                        if (row.IsNull(i) == false)
                        {
                            this.Status = (string)row[i, DataRowVersion.Current];
                        }
                        break;

                    case "SATFFSTATUS":
                        if (row.IsNull(i) == false)
                        {
                            this.Satffstatus = (string)row[i, DataRowVersion.Current];
                        }
                        break;

                    case "MINTS":
                        if (row.IsNull(i) == false)
                        {
                            this.Mints = Convert.ToDecimal(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "BILLABLE":
                        if (row.IsNull(i) == false)
                        {
                            this.Billable = Convert.ToBoolean(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "NARRATION":
                        if (row.IsNull(i) == false)
                        {
                            this.Narration = (string)row[i, DataRowVersion.Current];
                        }
                        break;

                    case "INVOICENO":
                        if (row.IsNull(i) == false)
                        {
                            this.InvoiceNo = (string)row[i, DataRowVersion.Current];
                        }
                        break;

                    case "LASTDATE":
                        if (row.IsNull(i) == false)
                        {
                            this.LastDate = Convert.ToDateTime(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "HOURLYCHARGES":
                        if (row.IsNull(i) == false)
                        {
                            this.HourlyCharges = Convert.ToDouble(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "REASON":
                        if (row.IsNull(i) == false)
                        {
                            this.Reason = (string)row[i, DataRowVersion.Current];
                        }
                        break;
                    case "ExpID":
                        //if (row.IsNull(i) == false)
                        //{
                        this.expId = Convert.ToInt32(row[i, DataRowVersion.Current]);
                        //}
                        break;

                }
            }
        }

        public static ITimesheetTablePersister DefaultPersister
        {
            get { return _DefaultPersister; }
            set { _DefaultPersister = value; }
        }

        public ITimesheetTablePersister Persister
        {
            get { return _Persister; }
            set { _Persister = value; }
        }

        public int TSId
        {
            get { return _TSId; }
            set { _TSId = value; }
        }

        public int? StaffCode
        {
            get { return _StaffCode; }
            set { _StaffCode = value; }
        }

        public string StaffName
        {
            get { return _StaffName; }
            set { _StaffName = value; }
        }

        public int? JobId
        {
            get { return _JobId; }
            set { _JobId = value; }
        }

        public int? CompId
        {
            get { return _CompId; }
            set { _CompId = value; }
        }

        public int? CLTId
        {
            get { return _CLTId; }
            set { _CLTId = value; }
        }

        public int? JobApprover
        {
            get { return _JobApprover; }
            set { _JobApprover = value; }
        }

        public string FromTime
        {
            get { return _FromTime; }
            set { _FromTime = value; }
        }

        public string ToTime
        {
            get { return _ToTime; }
            set { _ToTime = value; }
        }

        public string TotalTime
        {
            get { return _TotalTime; }
            set { _TotalTime = value; }
        }

        public int? OpeId
        {
            get { return _OpeId; }
            set { _OpeId = value; }
        }

        public double? OpeAmt
        {
            get { return _OpeAmt; }
            set { _OpeAmt = value; }
        }

        public int? LocId
        {
            get { return _LocId; }
            set { _LocId = value; }
        }

        public int? NarId
        {
            get { return _NarId; }
            set { _NarId = value; }
        }

        public DateTime? Date
        {
            get { return _Date; }
            set { _Date = value; }
        }

        public string Status
        {
            get { return _Status; }
            set { _Status = value; }
        }

        public string Satffstatus
        {
            get { return _Satffstatus; }
            set { _Satffstatus = value; }
        }

        public decimal? Mints
        {
            get { return _Mints; }
            set { _Mints = value; }
        }

        public bool? Billable
        {
            get { return _Billable; }
            set { _Billable = value; }
        }

        public string Narration
        {
            get { return _Narration; }
            set { _Narration = value; }
        }

        public Stream NarrationStream
        {
            get { return _NarrationStream; }
            set { _NarrationStream = value; }
        }

        public string InvoiceNo
        {
            get { return _InvoiceNo; }
            set { _InvoiceNo = value; }
        }

        public DateTime? LastDate
        {
            get { return _LastDate; }
            set { _LastDate = value; }
        }

        public double? HourlyCharges
        {
            get { return _HourlyCharges; }
            set { _HourlyCharges = value; }
        }

        public string Reason
        {
            get { return _Reason; }
            set { _Reason = value; }
        }

        public Stream ReasonStream
        {
            get { return _ReasonStream; }
            set { _ReasonStream = value; }
        }
        public int expId
        {
            get { return _expId; }
            set { _expId = value; }
        }

        public int enquiryId
        {
            get { return _enquiryId; }
            set { _enquiryId = value; }
        }

        public virtual void Clone(TimesheetTable sourceObject)
        {

            // Clone attributes from source object
            this._TSId = sourceObject.TSId;
            this._StaffCode = sourceObject.StaffCode;
            this._StaffName = sourceObject.StaffName;
            this._JobId = sourceObject.JobId;
            this._CompId = sourceObject.CompId;
            this._CLTId = sourceObject.CLTId;
            this._JobApprover = sourceObject.JobApprover;
            this._FromTime = sourceObject.FromTime;
            this._ToTime = sourceObject.ToTime;
            this._TotalTime = sourceObject.TotalTime;
            this._OpeId = sourceObject.OpeId;
            this._OpeAmt = sourceObject.OpeAmt;
            this._LocId = sourceObject.LocId;
            this._NarId = sourceObject.NarId;
            this._Date = sourceObject.Date;
            this._Status = sourceObject.Status;
            this._Satffstatus = sourceObject.Satffstatus;
            this._Mints = sourceObject.Mints;
            this._Billable = sourceObject.Billable;
            this._Narration = sourceObject.Narration;
            this._InvoiceNo = sourceObject.InvoiceNo;
            this._LastDate = sourceObject.LastDate;
            this._HourlyCharges = sourceObject.HourlyCharges;
            this._Reason = sourceObject.Reason;
            this._expId = sourceObject.expId;
        }

        public virtual int Retrieve()
        {

            return _Persister.Retrieve(this);
        }

        public virtual int Update()
        {

            return _Persister.Update(this);
        }

        public virtual int Delete()
        {

            return _Persister.Delete(this);
        }

        public virtual int Insert()
        {

            return _Persister.Insert(this);
        }

        public virtual int InsertExpense()
        {

            return _Persister.InsertExpense(this);
        }

        public static IReader<TimesheetTable> ListAll()
        {

            return _DefaultPersister.ListAll();
        }

    }

    public partial interface ITimesheetTablePersister
    {

        int Retrieve(TimesheetTable timesheetTable);
        int Update(TimesheetTable timesheetTable);
        int Delete(TimesheetTable timesheetTable);
        int Insert(TimesheetTable timesheetTable);
        int InsertExpense(TimesheetTable timesheetTable);
        IReader<TimesheetTable> ListAll();
    }

    public partial class SqlServerTimesheetTablePersister : SqlPersisterBase, ITimesheetTablePersister
    {

        public SqlServerTimesheetTablePersister()
        {

        }

        public SqlServerTimesheetTablePersister(string connectionString)
            : base(connectionString)
        {

        }

        public SqlServerTimesheetTablePersister(SqlConnection connection)
            : base(connection)
        {

        }

        public SqlServerTimesheetTablePersister(SqlTransaction transaction)
            : base(transaction)
        {

        }

        public int Retrieve(TimesheetTable timesheetTable)
        {

            int __rowsAffected = 1;

            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("TimesheetTableGet"))
            {

                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure;

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Add command parameters
                    SqlParameter vTSId = new SqlParameter("@TSId", SqlDbType.Int);
                    vTSId.Direction = ParameterDirection.InputOutput;
                    sqlCommand.Parameters.Add(vTSId);
                    SqlParameter vStaffCode = new SqlParameter("@StaffCode", SqlDbType.Int);
                    vStaffCode.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vStaffCode);
                    SqlParameter vStaffName = new SqlParameter("@StaffName", SqlDbType.VarChar, 70);
                    vStaffName.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vStaffName);
                    SqlParameter vJobId = new SqlParameter("@JobId", SqlDbType.Int);
                    vJobId.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vJobId);
                    SqlParameter vCompId = new SqlParameter("@CompId", SqlDbType.Int);
                    vCompId.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vCompId);
                    SqlParameter vCLTId = new SqlParameter("@CLTId", SqlDbType.Int);
                    vCLTId.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vCLTId);
                    SqlParameter vJobApprover = new SqlParameter("@JobApprover", SqlDbType.Int);
                    vJobApprover.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vJobApprover);
                    SqlParameter vFromTime = new SqlParameter("@FromTime", SqlDbType.VarChar, 50);
                    vFromTime.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vFromTime);
                    SqlParameter vToTime = new SqlParameter("@ToTime", SqlDbType.VarChar, 50);
                    vToTime.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vToTime);
                    SqlParameter vTotalTime = new SqlParameter("@TotalTime", SqlDbType.VarChar, 50);
                    vTotalTime.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vTotalTime);
                    SqlParameter vOpeId = new SqlParameter("@OpeId", SqlDbType.Int);
                    vOpeId.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vOpeId);
                    SqlParameter vOpeAmt = new SqlParameter("@OpeAmt", SqlDbType.Float);
                    vOpeAmt.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vOpeAmt);
                    SqlParameter vLocId = new SqlParameter("@LocId", SqlDbType.Int);
                    vLocId.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vLocId);
                    SqlParameter vNarId = new SqlParameter("@NarId", SqlDbType.Int);
                    vNarId.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vNarId);
                    SqlParameter vDate = new SqlParameter("@Date", SqlDbType.DateTime);
                    vDate.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vDate);
                    SqlParameter vStatus = new SqlParameter("@Status", SqlDbType.VarChar, 50);
                    vStatus.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vStatus);
                    SqlParameter vSatffstatus = new SqlParameter("@Satffstatus", SqlDbType.VarChar, 50);
                    vSatffstatus.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vSatffstatus);
                    SqlParameter vMints = new SqlParameter("@Mints", SqlDbType.Decimal);
                    vMints.Precision = 18;
                    vMints.Scale = 0;
                    vMints.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vMints);
                    SqlParameter vBillable = new SqlParameter("@Billable", SqlDbType.Bit);
                    vBillable.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vBillable);
                    SqlParameter vNarration = new SqlParameter("@Narration", SqlDbType.VarChar, 2147483647);
                    vNarration.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vNarration);
                    SqlParameter vInvoiceNo = new SqlParameter("@InvoiceNo", SqlDbType.VarChar, 50);
                    vInvoiceNo.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vInvoiceNo);
                    SqlParameter vLastDate = new SqlParameter("@LastDate", SqlDbType.DateTime);
                    vLastDate.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vLastDate);
                    SqlParameter vHourlyCharges = new SqlParameter("@HourlyCharges", SqlDbType.Float);
                    vHourlyCharges.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vHourlyCharges);
                    SqlParameter vReason = new SqlParameter("@Reason", SqlDbType.VarChar, 2147483647);
                    vReason.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vReason);

                    // Set input parameter values
                    SqlServerHelper.SetParameterValue(vTSId, timesheetTable.TSId);

                    // Execute command
                    sqlCommand.ExecuteNonQuery();

                    try
                    {
                        // Get output parameter values
                        timesheetTable.TSId = SqlServerHelper.ToInt32(vTSId);
                        timesheetTable.StaffCode = SqlServerHelper.ToNullableInt32(vStaffCode);
                        timesheetTable.StaffName = SqlServerHelper.ToString(vStaffName);
                        timesheetTable.JobId = SqlServerHelper.ToNullableInt32(vJobId);
                        timesheetTable.CompId = SqlServerHelper.ToNullableInt32(vCompId);
                        timesheetTable.CLTId = SqlServerHelper.ToNullableInt32(vCLTId);
                        timesheetTable.JobApprover = SqlServerHelper.ToNullableInt32(vJobApprover);
                        timesheetTable.FromTime = SqlServerHelper.ToString(vFromTime);
                        timesheetTable.ToTime = SqlServerHelper.ToString(vToTime);
                        timesheetTable.TotalTime = SqlServerHelper.ToString(vTotalTime);
                        timesheetTable.OpeId = SqlServerHelper.ToNullableInt32(vOpeId);
                        timesheetTable.OpeAmt = SqlServerHelper.ToNullableDouble(vOpeAmt);
                        timesheetTable.LocId = SqlServerHelper.ToNullableInt32(vLocId);
                        timesheetTable.NarId = SqlServerHelper.ToNullableInt32(vNarId);
                        timesheetTable.Date = SqlServerHelper.ToNullableDateTime(vDate);
                        timesheetTable.Status = SqlServerHelper.ToString(vStatus);
                        timesheetTable.Satffstatus = SqlServerHelper.ToString(vSatffstatus);
                        timesheetTable.Mints = SqlServerHelper.ToNullableDecimal(vMints);
                        timesheetTable.Billable = SqlServerHelper.ToNullableBoolean(vBillable);
                        if (timesheetTable.NarrationStream != null)
                            SqlServerHelper.ToStream(vNarration, timesheetTable.NarrationStream);
                        else
                            timesheetTable.Narration = SqlServerHelper.ToString(vNarration);

                        timesheetTable.InvoiceNo = SqlServerHelper.ToString(vInvoiceNo);
                        timesheetTable.LastDate = SqlServerHelper.ToNullableDateTime(vLastDate);
                        timesheetTable.HourlyCharges = SqlServerHelper.ToNullableDouble(vHourlyCharges);
                        if (timesheetTable.ReasonStream != null)
                            SqlServerHelper.ToStream(vReason, timesheetTable.ReasonStream);
                        else
                            timesheetTable.Reason = SqlServerHelper.ToString(vReason);


                    }
                    catch (Exception ex)
                    {
                        if (ex is System.NullReferenceException)
                        {
                            __rowsAffected = 0;
                        }
                        else
                        {
                            throw ex;
                        }
                    }
                }
                finally
                {
                    // Detach command
                    DetachCommand(sqlCommand);
                }

            }

            return __rowsAffected;
        }

        public int Update(TimesheetTable timesheetTable)
        {

            int __rowsAffected = 0;

            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("TimesheetTableUpdate"))
            {

                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure;

                // Add command parameters
                SqlParameter vTSId = new SqlParameter("@TSId", SqlDbType.Int);
                vTSId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vTSId);
                SqlParameter vStaffCode = new SqlParameter("@StaffCode", SqlDbType.Int);
                vStaffCode.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vStaffCode);
                SqlParameter vStaffName = new SqlParameter("@StaffName", SqlDbType.VarChar, 70);
                vStaffName.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vStaffName);
                SqlParameter vJobId = new SqlParameter("@JobId", SqlDbType.Int);
                vJobId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vJobId);
                SqlParameter vCompId = new SqlParameter("@CompId", SqlDbType.Int);
                vCompId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vCompId);
                SqlParameter vCLTId = new SqlParameter("@CLTId", SqlDbType.Int);
                vCLTId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vCLTId);
                SqlParameter vJobApprover = new SqlParameter("@JobApprover", SqlDbType.Int);
                vJobApprover.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vJobApprover);
                SqlParameter vFromTime = new SqlParameter("@FromTime", SqlDbType.VarChar, 50);
                vFromTime.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vFromTime);
                SqlParameter vToTime = new SqlParameter("@ToTime", SqlDbType.VarChar, 50);
                vToTime.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vToTime);
                SqlParameter vTotalTime = new SqlParameter("@TotalTime", SqlDbType.VarChar, 50);
                vTotalTime.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vTotalTime);
                SqlParameter vOpeId = new SqlParameter("@OpeId", SqlDbType.Int);
                vOpeId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vOpeId);
                SqlParameter vOpeAmt = new SqlParameter("@OpeAmt", SqlDbType.Float);
                vOpeAmt.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vOpeAmt);
                SqlParameter vLocId = new SqlParameter("@LocId", SqlDbType.Int);
                vLocId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vLocId);
                SqlParameter vNarId = new SqlParameter("@NarId", SqlDbType.Int);
                vNarId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vNarId);
                SqlParameter vDate = new SqlParameter("@Date", SqlDbType.DateTime);
                vDate.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vDate);
                SqlParameter vStatus = new SqlParameter("@Status", SqlDbType.VarChar, 50);
                vStatus.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vStatus);
                SqlParameter vSatffstatus = new SqlParameter("@Satffstatus", SqlDbType.VarChar, 50);
                vSatffstatus.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vSatffstatus);
                SqlParameter vMints = new SqlParameter("@Mints", SqlDbType.Decimal);
                vMints.Precision = 18;
                vMints.Scale = 0;
                vMints.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vMints);
                SqlParameter vBillable = new SqlParameter("@Billable", SqlDbType.Bit);
                vBillable.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vBillable);
                SqlParameter vNarration = new SqlParameter("@Narration", SqlDbType.VarChar, 2147483647);
                vNarration.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vNarration);
                SqlParameter vInvoiceNo = new SqlParameter("@InvoiceNo", SqlDbType.VarChar, 50);
                vInvoiceNo.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vInvoiceNo);
                SqlParameter vLastDate = new SqlParameter("@LastDate", SqlDbType.DateTime);
                vLastDate.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vLastDate);
                SqlParameter vHourlyCharges = new SqlParameter("@HourlyCharges", SqlDbType.Float);
                vHourlyCharges.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vHourlyCharges);
                SqlParameter vReason = new SqlParameter("@Reason", SqlDbType.VarChar, 2147483647);
                vReason.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vReason);

                // Set input parameter values
                SqlServerHelper.SetParameterValue(vTSId, timesheetTable.TSId);
                SqlServerHelper.SetParameterValue(vStaffCode, timesheetTable.StaffCode);
                SqlServerHelper.SetParameterValue(vStaffName, timesheetTable.StaffName);
                SqlServerHelper.SetParameterValue(vJobId, timesheetTable.JobId);
                SqlServerHelper.SetParameterValue(vCompId, timesheetTable.CompId);
                SqlServerHelper.SetParameterValue(vCLTId, timesheetTable.CLTId);
                SqlServerHelper.SetParameterValue(vJobApprover, timesheetTable.JobApprover);
                SqlServerHelper.SetParameterValue(vFromTime, timesheetTable.FromTime);
                SqlServerHelper.SetParameterValue(vToTime, timesheetTable.ToTime);
                SqlServerHelper.SetParameterValue(vTotalTime, timesheetTable.TotalTime);
                SqlServerHelper.SetParameterValue(vOpeId, timesheetTable.OpeId);
                SqlServerHelper.SetParameterValue(vOpeAmt, timesheetTable.OpeAmt);
                SqlServerHelper.SetParameterValue(vLocId, timesheetTable.LocId);
                SqlServerHelper.SetParameterValue(vNarId, timesheetTable.NarId);
                SqlServerHelper.SetParameterValue(vDate, timesheetTable.Date);
                SqlServerHelper.SetParameterValue(vStatus, timesheetTable.Status);
                SqlServerHelper.SetParameterValue(vSatffstatus, timesheetTable.Satffstatus);
                SqlServerHelper.SetParameterValue(vMints, timesheetTable.Mints);
                SqlServerHelper.SetParameterValue(vBillable, timesheetTable.Billable);
                if (timesheetTable.NarrationStream != null)
                    SqlServerHelper.SetParameterValue(vNarration, timesheetTable.NarrationStream);
                else
                    SqlServerHelper.SetParameterValue(vNarration, timesheetTable.Narration);
                SqlServerHelper.SetParameterValue(vInvoiceNo, timesheetTable.InvoiceNo);
                SqlServerHelper.SetParameterValue(vLastDate, timesheetTable.LastDate);
                SqlServerHelper.SetParameterValue(vHourlyCharges, timesheetTable.HourlyCharges);
                if (timesheetTable.ReasonStream != null)
                    SqlServerHelper.SetParameterValue(vReason, timesheetTable.ReasonStream);
                else
                    SqlServerHelper.SetParameterValue(vReason, timesheetTable.Reason);

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Execute command
                    __rowsAffected = sqlCommand.ExecuteNonQuery();
                    if (__rowsAffected == 0)
                    {
                        return __rowsAffected;
                    }


                }
                finally
                {
                    // Detach command
                    DetachCommand(sqlCommand);
                }

            }

            return __rowsAffected;
        }

        public int Delete(TimesheetTable timesheetTable)
        {

            int __rowsAffected = 0;

            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("TimesheetTableDelete"))
            {

                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure;

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Add command parameters
                    SqlParameter vTSId = new SqlParameter("@TSId", SqlDbType.Int);
                    vTSId.Direction = ParameterDirection.Input;
                    sqlCommand.Parameters.Add(vTSId);

                    // Set input parameter values
                    SqlServerHelper.SetParameterValue(vTSId, timesheetTable.TSId);

                    // Execute command
                    __rowsAffected = sqlCommand.ExecuteNonQuery();

                }
                finally
                {
                    // Detach command
                    DetachCommand(sqlCommand);
                }

            }

            return __rowsAffected;
        }

        public int Insert(TimesheetTable timesheetTable)
        {

            int __rowsAffected = 0;

            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("TimesheetTableInsert"))
            {

                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure;

                // Add command parameters
                SqlParameter vTSId = new SqlParameter("@TSId", SqlDbType.Int);
                vTSId.Direction = ParameterDirection.InputOutput;
                sqlCommand.Parameters.Add(vTSId);
                SqlParameter vStaffCode = new SqlParameter("@StaffCode", SqlDbType.Int);
                vStaffCode.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vStaffCode);
                SqlParameter vStaffName = new SqlParameter("@StaffName", SqlDbType.VarChar, 70);
                vStaffName.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vStaffName);
                SqlParameter vJobId = new SqlParameter("@JobId", SqlDbType.Int);
                vJobId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vJobId);
                SqlParameter vCompId = new SqlParameter("@CompId", SqlDbType.Int);
                vCompId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vCompId);
                SqlParameter vCLTId = new SqlParameter("@CLTId", SqlDbType.Int);
                vCLTId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vCLTId);
                SqlParameter vJobApprover = new SqlParameter("@JobApprover", SqlDbType.Int);
                vJobApprover.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vJobApprover);
                SqlParameter vFromTime = new SqlParameter("@FromTime", SqlDbType.VarChar, 50);
                vFromTime.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vFromTime);
                SqlParameter vToTime = new SqlParameter("@ToTime", SqlDbType.VarChar, 50);
                vToTime.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vToTime);
                SqlParameter vTotalTime = new SqlParameter("@TotalTime", SqlDbType.VarChar, 50);
                vTotalTime.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vTotalTime);
                SqlParameter vOpeId = new SqlParameter("@OpeId", SqlDbType.Int);
                vOpeId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vOpeId);
                SqlParameter vOpeAmt = new SqlParameter("@OpeAmt", SqlDbType.Float);
                vOpeAmt.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vOpeAmt);
                SqlParameter vLocId = new SqlParameter("@LocId", SqlDbType.Int);
                vLocId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vLocId);
                SqlParameter vNarId = new SqlParameter("@NarId", SqlDbType.Int);
                vNarId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vNarId);
                SqlParameter vDate = new SqlParameter("@Date", SqlDbType.DateTime);
                vDate.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vDate);
                SqlParameter vStatus = new SqlParameter("@Status", SqlDbType.VarChar, 50);
                vStatus.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vStatus);
                SqlParameter vSatffstatus = new SqlParameter("@Satffstatus", SqlDbType.VarChar, 50);
                vSatffstatus.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vSatffstatus);
                SqlParameter vMints = new SqlParameter("@Mints", SqlDbType.Decimal);
                vMints.Precision = 18;
                vMints.Scale = 0;
                vMints.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vMints);
                SqlParameter vBillable = new SqlParameter("@Billable", SqlDbType.Bit);
                vBillable.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vBillable);
                SqlParameter vNarration = new SqlParameter("@Narration", SqlDbType.VarChar, 2147483647);
                vNarration.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vNarration);
                SqlParameter vInvoiceNo = new SqlParameter("@InvoiceNo", SqlDbType.VarChar, 50);
                vInvoiceNo.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vInvoiceNo);
                SqlParameter vLastDate = new SqlParameter("@LastDate", SqlDbType.DateTime);
                vLastDate.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vLastDate);
                SqlParameter vHourlyCharges = new SqlParameter("@HourlyCharges", SqlDbType.Float);
                vHourlyCharges.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vHourlyCharges);
                SqlParameter vReason = new SqlParameter("@Reason", SqlDbType.VarChar, 2147483647);
                vReason.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vReason);
                SqlParameter vEnquiryId = new SqlParameter("@EnquiryId", SqlDbType.Int);
                vReason.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vEnquiryId);
                // Set input parameter values
                SqlServerHelper.SetParameterValue(
                    vTSId,
                    timesheetTable.TSId,
                    0);
                SqlServerHelper.SetParameterValue(vStaffCode, timesheetTable.StaffCode);
                SqlServerHelper.SetParameterValue(vStaffName, timesheetTable.StaffName);
                SqlServerHelper.SetParameterValue(vJobId, timesheetTable.JobId);
                SqlServerHelper.SetParameterValue(vCompId, timesheetTable.CompId);
                SqlServerHelper.SetParameterValue(vCLTId, timesheetTable.CLTId);
                SqlServerHelper.SetParameterValue(vJobApprover, timesheetTable.JobApprover);
                SqlServerHelper.SetParameterValue(vFromTime, timesheetTable.FromTime);
                SqlServerHelper.SetParameterValue(vToTime, timesheetTable.ToTime);
                SqlServerHelper.SetParameterValue(vTotalTime, timesheetTable.TotalTime);
                SqlServerHelper.SetParameterValue(vOpeId, timesheetTable.OpeId);
                SqlServerHelper.SetParameterValue(vOpeAmt, timesheetTable.OpeAmt);
                SqlServerHelper.SetParameterValue(vLocId, timesheetTable.LocId);
                SqlServerHelper.SetParameterValue(vNarId, timesheetTable.NarId);
                SqlServerHelper.SetParameterValue(vDate, timesheetTable.Date);
                SqlServerHelper.SetParameterValue(vStatus, timesheetTable.Status);
                SqlServerHelper.SetParameterValue(vSatffstatus, timesheetTable.Satffstatus);
                SqlServerHelper.SetParameterValue(vMints, timesheetTable.Mints);
                SqlServerHelper.SetParameterValue(vBillable, timesheetTable.Billable);
                if (timesheetTable.NarrationStream != null)
                    SqlServerHelper.SetParameterValue(vNarration, timesheetTable.NarrationStream);
                else
                    SqlServerHelper.SetParameterValue(vNarration, timesheetTable.Narration);
                SqlServerHelper.SetParameterValue(vInvoiceNo, timesheetTable.InvoiceNo);
                SqlServerHelper.SetParameterValue(vLastDate, timesheetTable.LastDate);
                SqlServerHelper.SetParameterValue(vHourlyCharges, timesheetTable.HourlyCharges);
                if (timesheetTable.ReasonStream != null)
                    SqlServerHelper.SetParameterValue(vReason, timesheetTable.ReasonStream);
                else
                    SqlServerHelper.SetParameterValue(vReason, timesheetTable.Reason);
                SqlServerHelper.SetParameterValue(vEnquiryId, timesheetTable.enquiryId);
                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Execute command
                    __rowsAffected = sqlCommand.ExecuteNonQuery();
                    if (__rowsAffected == 0)
                    {
                        return __rowsAffected;
                    }


                    // Get output parameter values
                    timesheetTable.TSId = SqlServerHelper.ToInt32(vTSId);

                }
                finally
                {
                    // Detach command
                    DetachCommand(sqlCommand);
                }

            }

            return __rowsAffected;
        }


        public int InsertExpense(TimesheetTable timesheetTable)
        {

            int __rowsAffected = 0;

            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("ExpenseTableInsert"))
            {

                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure;

                // Add command parameters
                SqlParameter vEXPId = new SqlParameter("@ExpId", SqlDbType.Int);
                vEXPId.Direction = ParameterDirection.InputOutput;
                sqlCommand.Parameters.Add(vEXPId);
                SqlParameter vTsid = new SqlParameter("@TsID", SqlDbType.Int);
                vTsid.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vTsid);
                SqlParameter vStaffCode = new SqlParameter("@StaffCode", SqlDbType.Int);
                vStaffCode.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vStaffCode);
                SqlParameter vStaffName = new SqlParameter("@StaffName", SqlDbType.VarChar, 70);
                vStaffName.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vStaffName);
                SqlParameter vJobId = new SqlParameter("@JobId", SqlDbType.Int);
                vJobId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vJobId);
                SqlParameter vCompId = new SqlParameter("@CompId", SqlDbType.Int);
                vCompId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vCompId);
                SqlParameter vCLTId = new SqlParameter("@CLTId", SqlDbType.Int);
                vCLTId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vCLTId);

                SqlParameter vOpeId = new SqlParameter("@OpeId", SqlDbType.Int);
                vOpeId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vOpeId);
                SqlParameter vOpeAmt = new SqlParameter("@OpeAmt", SqlDbType.Float);
                vOpeAmt.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vOpeAmt);

                SqlParameter vDate = new SqlParameter("@Date", SqlDbType.DateTime);
                vDate.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vDate);
                SqlParameter vStatus = new SqlParameter("@Status", SqlDbType.VarChar, 50);
                vStatus.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vStatus);
                SqlParameter vNarration = new SqlParameter("@Narration", SqlDbType.VarChar, 2147483647);
                vNarration.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vNarration);


                SqlServerHelper.SetParameterValue(
                    vEXPId,
                    timesheetTable.expId,
                    0);
                SqlServerHelper.SetParameterValue(vTsid, timesheetTable.TSId);
                SqlServerHelper.SetParameterValue(vStaffCode, timesheetTable.StaffCode);
                SqlServerHelper.SetParameterValue(vStaffName, timesheetTable.StaffName);
                SqlServerHelper.SetParameterValue(vJobId, timesheetTable.JobId);
                SqlServerHelper.SetParameterValue(vCompId, timesheetTable.CompId);
                SqlServerHelper.SetParameterValue(vCLTId, timesheetTable.CLTId);
                SqlServerHelper.SetParameterValue(vOpeId, timesheetTable.OpeId);
                SqlServerHelper.SetParameterValue(vOpeAmt, timesheetTable.OpeAmt);
                SqlServerHelper.SetParameterValue(vDate, timesheetTable.Date);
                SqlServerHelper.SetParameterValue(vStatus, timesheetTable.Status);
                if (timesheetTable.NarrationStream != null)
                    SqlServerHelper.SetParameterValue(vNarration, timesheetTable.NarrationStream);
                else
                    SqlServerHelper.SetParameterValue(vNarration, timesheetTable.Narration);

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Execute command
                    __rowsAffected = sqlCommand.ExecuteNonQuery();
                    if (__rowsAffected == 0)
                    {
                        return __rowsAffected;
                    }


                    // Get output parameter values
                    timesheetTable.expId = SqlServerHelper.ToInt32(vEXPId);

                }
                finally
                {
                    // Detach command
                    DetachCommand(sqlCommand);
                }

            }

            return __rowsAffected;
        }
        public IReader<TimesheetTable> ListAll()
        {

            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("TimesheetTableListAll"))
            {

                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure;

                // Execute command
                SqlDataReader reader = sqlCommand.ExecuteReader(AttachReaderCommand(sqlCommand));

                // Return reader
                return new SqlServerTimesheetTableReader(reader);
            }
        }

    }

    public partial class SqlServerTimesheetTableReader : IReader<TimesheetTable>
    {

        private SqlDataReader sqlDataReader;

        private TimesheetTable _TimesheetTable;

        private int _TSIdOrdinal = -1;
        private int _StaffCodeOrdinal = -1;
        private int _StaffNameOrdinal = -1;
        private int _JobIdOrdinal = -1;
        private int _CompIdOrdinal = -1;
        private int _CLTIdOrdinal = -1;
        private int _JobApproverOrdinal = -1;
        private int _FromTimeOrdinal = -1;
        private int _ToTimeOrdinal = -1;
        private int _TotalTimeOrdinal = -1;
        private int _OpeIdOrdinal = -1;
        private int _OpeAmtOrdinal = -1;
        private int _LocIdOrdinal = -1;
        private int _NarIdOrdinal = -1;
        private int _DateOrdinal = -1;
        private int _StatusOrdinal = -1;
        private int _SatffstatusOrdinal = -1;
        private int _MintsOrdinal = -1;
        private int _BillableOrdinal = -1;
        private int _NarrationOrdinal = -1;
        private int _InvoiceNoOrdinal = -1;
        private int _LastDateOrdinal = -1;
        private int _HourlyChargesOrdinal = -1;
        private int _ReasonOrdinal = -1;
        private int _expIdOrdinal = -1;

        public SqlServerTimesheetTableReader(SqlDataReader sqlDataReader)
        {

            this.sqlDataReader = sqlDataReader;
            for (int i = 0; i < sqlDataReader.FieldCount; i++)
            {
                string columnName = sqlDataReader.GetName(i);
                columnName = columnName.ToUpper();
                switch (columnName)
                {
                    case "TSID":
                        _TSIdOrdinal = i;
                        break;

                    case "STAFFCODE":
                        _StaffCodeOrdinal = i;
                        break;

                    case "STAFFNAME":
                        _StaffNameOrdinal = i;
                        break;

                    case "JOBID":
                        _JobIdOrdinal = i;
                        break;

                    case "COMPID":
                        _CompIdOrdinal = i;
                        break;

                    case "CLTID":
                        _CLTIdOrdinal = i;
                        break;

                    case "JOBAPPROVER":
                        _JobApproverOrdinal = i;
                        break;

                    case "FROMTIME":
                        _FromTimeOrdinal = i;
                        break;

                    case "TOTIME":
                        _ToTimeOrdinal = i;
                        break;

                    case "TOTALTIME":
                        _TotalTimeOrdinal = i;
                        break;

                    case "OPEID":
                        _OpeIdOrdinal = i;
                        break;

                    case "OPEAMT":
                        _OpeAmtOrdinal = i;
                        break;

                    case "LOCID":
                        _LocIdOrdinal = i;
                        break;

                    case "NARID":
                        _NarIdOrdinal = i;
                        break;

                    case "DATE":
                        _DateOrdinal = i;
                        break;

                    case "STATUS":
                        _StatusOrdinal = i;
                        break;

                    case "SATFFSTATUS":
                        _SatffstatusOrdinal = i;
                        break;

                    case "MINTS":
                        _MintsOrdinal = i;
                        break;

                    case "BILLABLE":
                        _BillableOrdinal = i;
                        break;

                    case "NARRATION":
                        _NarrationOrdinal = i;
                        break;

                    case "INVOICENO":
                        _InvoiceNoOrdinal = i;
                        break;

                    case "LASTDATE":
                        _LastDateOrdinal = i;
                        break;

                    case "HOURLYCHARGES":
                        _HourlyChargesOrdinal = i;
                        break;

                    case "REASON":
                        _ReasonOrdinal = i;
                        break;

                    case "EXPID":
                        _expIdOrdinal = i;
                        break;

                }
            }
        }

        #region IReader<TimesheetTable> Implementation

        public bool Read()
        {

            _TimesheetTable = null;
            return this.sqlDataReader.Read();
        }

        public TimesheetTable Current
        {
            get
            {
                if (_TimesheetTable == null)
                {
                    _TimesheetTable = new TimesheetTable();
                    if (_TSIdOrdinal != -1)
                    {
                        _TimesheetTable.TSId = SqlServerHelper.ToInt32(sqlDataReader, _TSIdOrdinal);
                    }
                    _TimesheetTable.StaffCode = SqlServerHelper.ToNullableInt32(sqlDataReader, _StaffCodeOrdinal);
                    _TimesheetTable.StaffName = SqlServerHelper.ToString(sqlDataReader, _StaffNameOrdinal);
                    _TimesheetTable.JobId = SqlServerHelper.ToNullableInt32(sqlDataReader, _JobIdOrdinal);
                    _TimesheetTable.CompId = SqlServerHelper.ToNullableInt32(sqlDataReader, _CompIdOrdinal);
                    _TimesheetTable.CLTId = SqlServerHelper.ToNullableInt32(sqlDataReader, _CLTIdOrdinal);
                    _TimesheetTable.JobApprover = SqlServerHelper.ToNullableInt32(sqlDataReader, _JobApproverOrdinal);
                    _TimesheetTable.FromTime = SqlServerHelper.ToString(sqlDataReader, _FromTimeOrdinal);
                    _TimesheetTable.ToTime = SqlServerHelper.ToString(sqlDataReader, _ToTimeOrdinal);
                    _TimesheetTable.TotalTime = SqlServerHelper.ToString(sqlDataReader, _TotalTimeOrdinal);
                    _TimesheetTable.OpeId = SqlServerHelper.ToNullableInt32(sqlDataReader, _OpeIdOrdinal);
                    _TimesheetTable.OpeAmt = SqlServerHelper.ToNullableDouble(sqlDataReader, _OpeAmtOrdinal);
                    _TimesheetTable.LocId = SqlServerHelper.ToNullableInt32(sqlDataReader, _LocIdOrdinal);
                    _TimesheetTable.NarId = SqlServerHelper.ToNullableInt32(sqlDataReader, _NarIdOrdinal);
                    _TimesheetTable.Date = SqlServerHelper.ToNullableDateTime(sqlDataReader, _DateOrdinal);
                    _TimesheetTable.Status = SqlServerHelper.ToString(sqlDataReader, _StatusOrdinal);
                    _TimesheetTable.Satffstatus = SqlServerHelper.ToString(sqlDataReader, _SatffstatusOrdinal);
                    _TimesheetTable.Mints = SqlServerHelper.ToNullableDecimal(sqlDataReader, _MintsOrdinal);
                    _TimesheetTable.Billable = SqlServerHelper.ToNullableBoolean(sqlDataReader, _BillableOrdinal);
                    _TimesheetTable.Narration = SqlServerHelper.ToString(sqlDataReader, _NarrationOrdinal);
                    _TimesheetTable.InvoiceNo = SqlServerHelper.ToString(sqlDataReader, _InvoiceNoOrdinal);
                    _TimesheetTable.LastDate = SqlServerHelper.ToNullableDateTime(sqlDataReader, _LastDateOrdinal);
                    _TimesheetTable.HourlyCharges = SqlServerHelper.ToNullableDouble(sqlDataReader, _HourlyChargesOrdinal);
                    _TimesheetTable.Reason = SqlServerHelper.ToString(sqlDataReader, _ReasonOrdinal);
                    _TimesheetTable.expId = SqlServerHelper.ToInt32(sqlDataReader, _expIdOrdinal);
                }


                return _TimesheetTable;
            }
        }

        public void Close()
        {

            sqlDataReader.Close();
        }

        public List<TimesheetTable> ToList()
        {

            List<TimesheetTable> list = new List<TimesheetTable>();
            while (this.Read())
            {
                list.Add(this.Current);
            }
            this.Close();
            return list;
        }

        public DataTable ToDataTable()
        {

            DataTable dataTable = new DataTable();
            dataTable.Load(sqlDataReader);
            return dataTable;
        }

        #endregion

        #region IDisposable Implementation

        public void Dispose()
        {

            sqlDataReader.Dispose();
        }
        #endregion

        #region IEnumerable<TimesheetTable> Implementation

        public IEnumerator<TimesheetTable> GetEnumerator()
        {

            return new TimesheetTableEnumerator(this);
        }

        #endregion

        #region IEnumerable Implementation

        IEnumerator IEnumerable.GetEnumerator()
        {

            return new TimesheetTableEnumerator(this);
        }

        #endregion


        private partial class TimesheetTableEnumerator : IEnumerator<TimesheetTable>
        {

            private IReader<TimesheetTable> timesheetTableReader;

            public TimesheetTableEnumerator(IReader<TimesheetTable> timesheetTableReader)
            {

                this.timesheetTableReader = timesheetTableReader;
            }

            #region IEnumerator<TimesheetTable> Members

            public TimesheetTable Current
            {
                get { return this.timesheetTableReader.Current; }
            }

            #endregion

            #region IDisposable Members

            public void Dispose()
            {

                this.timesheetTableReader.Dispose();
            }

            #endregion

            #region IEnumerator Members

            object IEnumerator.Current
            {
                get { return this.timesheetTableReader.Current; }
            }

            public bool MoveNext()
            {

                return this.timesheetTableReader.Read();
            }

            public void Reset()
            {

                throw new Exception("Reset of timesheettable reader is not supported.");
            }

            #endregion

        }
    }
}
