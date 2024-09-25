
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.IO;

namespace JTMSProject
{
    public partial class SatffJobList
    {
        private static ISatffJobListPersister _DefaultPersister;
        private ISatffJobListPersister _Persister;
        private int _Id;
        private int? _TaskId;
        private string _TaskName;
        private int? _JobId;
        private int? _StaffCode;
        private double? _TimeTaken;
        private DateTime? _Date;
        private int? _Field3;
        private int? _Field4;
        private int? _Field5;
        private int? _Field6;
        private int? _Field7;
        private double? _Total;
        private double? _Estimate;

        static SatffJobList()
        {
            // Assign default persister
            _DefaultPersister = new SqlServerSatffJobListPersister();
        }

        public SatffJobList()
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister; 
        }

        public SatffJobList(int _Id)
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister; 

            // Assign method parameter to private fields
            this._Id = _Id; 

            // Call associated retrieve method
            Retrieve();
        }

        public SatffJobList(DataRow row)
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister; 

            // Assign column values to private members
            for (int  i = 0; i < row.Table.Columns.Count; i++)
            {
                switch (row.Table.Columns[i].ColumnName.ToUpper())
                {
                    case "ID":
                        this.Id = Convert.ToInt32(row[i, DataRowVersion.Current]); 
                        break;
                    
                    case "TASKID":
                        if(row.IsNull(i) == false)
                        {
                            this.TaskId = Convert.ToInt32(row[i, DataRowVersion.Current]); 
                        }
                        break;
                    
                    case "TASKNAME":
                        if(row.IsNull(i) == false)
                        {
                            this.TaskName = (string)row[i, DataRowVersion.Current]; 
                        }
                        break;
                    
                    case "JOBID":
                        if(row.IsNull(i) == false)
                        {
                            this.JobId = Convert.ToInt32(row[i, DataRowVersion.Current]); 
                        }
                        break;
                    
                    case "STAFFCODE":
                        if(row.IsNull(i) == false)
                        {
                            this.StaffCode = Convert.ToInt32(row[i, DataRowVersion.Current]); 
                        }
                        break;
                    
                    case "TIMETAKEN":
                        if(row.IsNull(i) == false)
                        {
                            this.TimeTaken = Convert.ToDouble(row[i, DataRowVersion.Current]); 
                        }
                        break;
                    
                    case "DATE":
                        if(row.IsNull(i) == false)
                        {
                            this.Date = Convert.ToDateTime(row[i, DataRowVersion.Current]); 
                        }
                        break;
                    
                    case "FIELD3":
                        if(row.IsNull(i) == false)
                        {
                            this.Field3 = Convert.ToInt32(row[i, DataRowVersion.Current]); 
                        }
                        break;
                    
                    case "FIELD4":
                        if(row.IsNull(i) == false)
                        {
                            this.Field4 = Convert.ToInt32(row[i, DataRowVersion.Current]); 
                        }
                        break;
                    
                    case "FIELD5":
                        if(row.IsNull(i) == false)
                        {
                            this.Field5 = Convert.ToInt32(row[i, DataRowVersion.Current]); 
                        }
                        break;
                    
                    case "FIELD6":
                        if(row.IsNull(i) == false)
                        {
                            this.Field6 = Convert.ToInt32(row[i, DataRowVersion.Current]); 
                        }
                        break;
                    
                    case "FIELD7":
                        if(row.IsNull(i) == false)
                        {
                            this.Field7 = Convert.ToInt32(row[i, DataRowVersion.Current]); 
                        }
                        break;
                    
                    case "TOTAL":
                        if(row.IsNull(i) == false)
                        {
                            this.Total = Convert.ToDouble(row[i, DataRowVersion.Current]); 
                        }
                        break;
                    
                    case "ESTIMATE":
                        if(row.IsNull(i) == false)
                        {
                            this.Estimate = Convert.ToDouble(row[i, DataRowVersion.Current]); 
                        }
                        break;
                    
                }
            }
        }

        public static ISatffJobListPersister DefaultPersister
        {
            get { return _DefaultPersister; }
            set { _DefaultPersister = value; }
        }

        public ISatffJobListPersister Persister
        {
            get { return _Persister; }
            set { _Persister = value; }
        }

        public int Id
        {
            get { return _Id; }
            set { _Id = value; }
        }

        public int? TaskId
        {
            get { return _TaskId; }
            set { _TaskId = value; }
        }

        public string TaskName
        {
            get { return _TaskName; }
            set { _TaskName = value; }
        }

        public int? JobId
        {
            get { return _JobId; }
            set { _JobId = value; }
        }

        public int? StaffCode
        {
            get { return _StaffCode; }
            set { _StaffCode = value; }
        }

        public double? TimeTaken
        {
            get { return _TimeTaken; }
            set { _TimeTaken = value; }
        }

        public DateTime? Date
        {
            get { return _Date; }
            set { _Date = value; }
        }

        public int? Field3
        {
            get { return _Field3; }
            set { _Field3 = value; }
        }

        public int? Field4
        {
            get { return _Field4; }
            set { _Field4 = value; }
        }

        public int? Field5
        {
            get { return _Field5; }
            set { _Field5 = value; }
        }

        public int? Field6
        {
            get { return _Field6; }
            set { _Field6 = value; }
        }

        public int? Field7
        {
            get { return _Field7; }
            set { _Field7 = value; }
        }

        public double? Total
        {
            get { return _Total; }
            set { _Total = value; }
        }

        public double? Estimate
        {
            get { return _Estimate; }
            set { _Estimate = value; }
        }

        public virtual void Clone(SatffJobList sourceObject)
        {
            // Clone attributes from source object
            this._Id = sourceObject.Id; 
            this._TaskId = sourceObject.TaskId; 
            this._TaskName = sourceObject.TaskName; 
            this._JobId = sourceObject.JobId; 
            this._StaffCode = sourceObject.StaffCode; 
            this._TimeTaken = sourceObject.TimeTaken; 
            this._Date = sourceObject.Date; 
            this._Field3 = sourceObject.Field3; 
            this._Field4 = sourceObject.Field4; 
            this._Field5 = sourceObject.Field5; 
            this._Field6 = sourceObject.Field6; 
            this._Field7 = sourceObject.Field7; 
            this._Total = sourceObject.Total; 
            this._Estimate = sourceObject.Estimate; 
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

        public static IReader<SatffJobList> ListAll()
        {
            return _DefaultPersister.ListAll(); 
        }

        public static IReader<SatffJobList> ListForTaskId(int? taskId)
        {
            return _DefaultPersister.ListForTaskId(taskId); 
        }

    }
    
    public partial interface ISatffJobListPersister
    {
        int Retrieve(SatffJobList satffJobList);
        int Update(SatffJobList satffJobList);
        int Delete(SatffJobList satffJobList);
        int Insert(SatffJobList satffJobList);
        IReader<SatffJobList> ListAll();
        IReader<SatffJobList> ListForTaskId(int? taskId);
    }
    
    public partial class SqlServerSatffJobListPersister : SqlPersisterBase, ISatffJobListPersister
    {
        public SqlServerSatffJobListPersister()
        {
        }

        public SqlServerSatffJobListPersister(string connectionString) : base(connectionString)
        {
        }

        public SqlServerSatffJobListPersister(SqlConnection connection) : base(connection)
        {
        }

        public SqlServerSatffJobListPersister(SqlTransaction transaction) : base(transaction)
        {
        }

        public int Retrieve(SatffJobList satffJobList)
        {
            int __rowsAffected = 1;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("SatffJobListGet"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Add command parameters
                    SqlParameter vId = new SqlParameter("@Id", SqlDbType.Int);
                    vId.Direction = ParameterDirection.InputOutput; 
                    sqlCommand.Parameters.Add(vId);
                    SqlParameter vTaskId = new SqlParameter("@TaskId", SqlDbType.Int);
                    vTaskId.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vTaskId);
                    SqlParameter vTaskName = new SqlParameter("@TaskName", SqlDbType.VarChar, 70);
                    vTaskName.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vTaskName);
                    SqlParameter vJobId = new SqlParameter("@JobId", SqlDbType.Int);
                    vJobId.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vJobId);
                    SqlParameter vStaffCode = new SqlParameter("@StaffCode", SqlDbType.Int);
                    vStaffCode.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vStaffCode);
                    SqlParameter vTimeTaken = new SqlParameter("@TimeTaken", SqlDbType.Float);
                    vTimeTaken.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vTimeTaken);
                    SqlParameter vDate = new SqlParameter("@Date", SqlDbType.DateTime);
                    vDate.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vDate);
                    SqlParameter vField3 = new SqlParameter("@Field3", SqlDbType.Int);
                    vField3.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vField3);
                    SqlParameter vField4 = new SqlParameter("@Field4", SqlDbType.Int);
                    vField4.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vField4);
                    SqlParameter vField5 = new SqlParameter("@Field5", SqlDbType.Int);
                    vField5.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vField5);
                    SqlParameter vField6 = new SqlParameter("@Field6", SqlDbType.Int);
                    vField6.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vField6);
                    SqlParameter vField7 = new SqlParameter("@Field7", SqlDbType.Int);
                    vField7.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vField7);
                    SqlParameter vTotal = new SqlParameter("@Total", SqlDbType.Float);
                    vTotal.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vTotal);
                    SqlParameter vEstimate = new SqlParameter("@Estimate", SqlDbType.Float);
                    vEstimate.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vEstimate);

                    // Set input parameter values
                    SqlServerHelper.SetParameterValue(vId, satffJobList.Id);

                    // Execute command
                    sqlCommand.ExecuteNonQuery();

                    try
                    {
                        // Get output parameter values
                        satffJobList.Id = SqlServerHelper.ToInt32(vId); 
                        satffJobList.TaskId = SqlServerHelper.ToNullableInt32(vTaskId); 
                        satffJobList.TaskName = SqlServerHelper.ToString(vTaskName); 
                        satffJobList.JobId = SqlServerHelper.ToNullableInt32(vJobId); 
                        satffJobList.StaffCode = SqlServerHelper.ToNullableInt32(vStaffCode); 
                        satffJobList.TimeTaken = SqlServerHelper.ToNullableDouble(vTimeTaken); 
                        satffJobList.Date = SqlServerHelper.ToNullableDateTime(vDate); 
                        satffJobList.Field3 = SqlServerHelper.ToNullableInt32(vField3); 
                        satffJobList.Field4 = SqlServerHelper.ToNullableInt32(vField4); 
                        satffJobList.Field5 = SqlServerHelper.ToNullableInt32(vField5); 
                        satffJobList.Field6 = SqlServerHelper.ToNullableInt32(vField6); 
                        satffJobList.Field7 = SqlServerHelper.ToNullableInt32(vField7); 
                        satffJobList.Total = SqlServerHelper.ToNullableDouble(vTotal); 
                        satffJobList.Estimate = SqlServerHelper.ToNullableDouble(vEstimate); 

                    }
                    catch(Exception ex)
                    {
                        if(ex is System.NullReferenceException)
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

        public int Update(SatffJobList satffJobList)
        {
            int __rowsAffected = 0;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("SatffJobListUpdate"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Add command parameters
                SqlParameter vId = new SqlParameter("@Id", SqlDbType.Int);
                vId.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vId);
                SqlParameter vTaskId = new SqlParameter("@TaskId", SqlDbType.Int);
                vTaskId.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vTaskId);
                SqlParameter vTaskName = new SqlParameter("@TaskName", SqlDbType.VarChar, 70);
                vTaskName.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vTaskName);
                SqlParameter vJobId = new SqlParameter("@JobId", SqlDbType.Int);
                vJobId.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vJobId);
                SqlParameter vStaffCode = new SqlParameter("@StaffCode", SqlDbType.Int);
                vStaffCode.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vStaffCode);
                SqlParameter vTimeTaken = new SqlParameter("@TimeTaken", SqlDbType.Float);
                vTimeTaken.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vTimeTaken);
                SqlParameter vDate = new SqlParameter("@Date", SqlDbType.DateTime);
                vDate.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vDate);
                SqlParameter vField3 = new SqlParameter("@Field3", SqlDbType.Int);
                vField3.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vField3);
                SqlParameter vField4 = new SqlParameter("@Field4", SqlDbType.Int);
                vField4.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vField4);
                SqlParameter vField5 = new SqlParameter("@Field5", SqlDbType.Int);
                vField5.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vField5);
                SqlParameter vField6 = new SqlParameter("@Field6", SqlDbType.Int);
                vField6.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vField6);
                SqlParameter vField7 = new SqlParameter("@Field7", SqlDbType.Int);
                vField7.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vField7);
                SqlParameter vTotal = new SqlParameter("@Total", SqlDbType.Float);
                vTotal.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vTotal);
                SqlParameter vEstimate = new SqlParameter("@Estimate", SqlDbType.Float);
                vEstimate.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vEstimate);

                // Set input parameter values
                SqlServerHelper.SetParameterValue(vId, satffJobList.Id);
                SqlServerHelper.SetParameterValue(vTaskId, satffJobList.TaskId);
                SqlServerHelper.SetParameterValue(vTaskName, satffJobList.TaskName);
                SqlServerHelper.SetParameterValue(vJobId, satffJobList.JobId);
                SqlServerHelper.SetParameterValue(vStaffCode, satffJobList.StaffCode);
                SqlServerHelper.SetParameterValue(vTimeTaken, satffJobList.TimeTaken);
                SqlServerHelper.SetParameterValue(vDate, satffJobList.Date);
                SqlServerHelper.SetParameterValue(vField3, satffJobList.Field3);
                SqlServerHelper.SetParameterValue(vField4, satffJobList.Field4);
                SqlServerHelper.SetParameterValue(vField5, satffJobList.Field5);
                SqlServerHelper.SetParameterValue(vField6, satffJobList.Field6);
                SqlServerHelper.SetParameterValue(vField7, satffJobList.Field7);
                SqlServerHelper.SetParameterValue(vTotal, satffJobList.Total);
                SqlServerHelper.SetParameterValue(vEstimate, satffJobList.Estimate);

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Execute command
                    __rowsAffected = sqlCommand.ExecuteNonQuery(); 
                    if(__rowsAffected == 0)
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

        public int Delete(SatffJobList satffJobList)
        {
            int __rowsAffected = 0;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("SatffJobListDelete"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Add command parameters
                    SqlParameter vId = new SqlParameter("@Id", SqlDbType.Int);
                    vId.Direction = ParameterDirection.Input; 
                    sqlCommand.Parameters.Add(vId);

                    // Set input parameter values
                    SqlServerHelper.SetParameterValue(vId, satffJobList.Id);

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

        public int Insert(SatffJobList satffJobList)
        {
            int __rowsAffected = 0;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("SatffJobListInsert"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Add command parameters
                SqlParameter vId = new SqlParameter("@Id", SqlDbType.Int);
                vId.Direction = ParameterDirection.InputOutput; 
                sqlCommand.Parameters.Add(vId);
                SqlParameter vTaskId = new SqlParameter("@TaskId", SqlDbType.Int);
                vTaskId.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vTaskId);
                SqlParameter vTaskName = new SqlParameter("@TaskName", SqlDbType.VarChar, 70);
                vTaskName.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vTaskName);
                SqlParameter vJobId = new SqlParameter("@JobId", SqlDbType.Int);
                vJobId.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vJobId);
                SqlParameter vStaffCode = new SqlParameter("@StaffCode", SqlDbType.Int);
                vStaffCode.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vStaffCode);
                SqlParameter vTimeTaken = new SqlParameter("@TimeTaken", SqlDbType.Float);
                vTimeTaken.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vTimeTaken);
                SqlParameter vDate = new SqlParameter("@Date", SqlDbType.DateTime);
                vDate.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vDate);
                SqlParameter vField3 = new SqlParameter("@Field3", SqlDbType.Int);
                vField3.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vField3);
                SqlParameter vField4 = new SqlParameter("@Field4", SqlDbType.Int);
                vField4.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vField4);
                SqlParameter vField5 = new SqlParameter("@Field5", SqlDbType.Int);
                vField5.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vField5);
                SqlParameter vField6 = new SqlParameter("@Field6", SqlDbType.Int);
                vField6.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vField6);
                SqlParameter vField7 = new SqlParameter("@Field7", SqlDbType.Int);
                vField7.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vField7);
                SqlParameter vTotal = new SqlParameter("@Total", SqlDbType.Float);
                vTotal.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vTotal);
                SqlParameter vEstimate = new SqlParameter("@Estimate", SqlDbType.Float);
                vEstimate.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vEstimate);

                // Set input parameter values
                SqlServerHelper.SetParameterValue(
                    vId, 
                    satffJobList.Id, 
                    0);
                SqlServerHelper.SetParameterValue(vTaskId, satffJobList.TaskId);
                SqlServerHelper.SetParameterValue(vTaskName, satffJobList.TaskName);
                SqlServerHelper.SetParameterValue(vJobId, satffJobList.JobId);
                SqlServerHelper.SetParameterValue(vStaffCode, satffJobList.StaffCode);
                SqlServerHelper.SetParameterValue(vTimeTaken, satffJobList.TimeTaken);
                SqlServerHelper.SetParameterValue(vDate, satffJobList.Date);
                SqlServerHelper.SetParameterValue(vField3, satffJobList.Field3);
                SqlServerHelper.SetParameterValue(vField4, satffJobList.Field4);
                SqlServerHelper.SetParameterValue(vField5, satffJobList.Field5);
                SqlServerHelper.SetParameterValue(vField6, satffJobList.Field6);
                SqlServerHelper.SetParameterValue(vField7, satffJobList.Field7);
                SqlServerHelper.SetParameterValue(vTotal, satffJobList.Total);
                SqlServerHelper.SetParameterValue(vEstimate, satffJobList.Estimate);

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Execute command
                    __rowsAffected = sqlCommand.ExecuteNonQuery(); 
                    if(__rowsAffected == 0)
                    {
                        return __rowsAffected; 
                    }
                    

                    // Get output parameter values
                    satffJobList.Id = SqlServerHelper.ToInt32(vId); 

                }
                finally
                {
                    // Detach command
                    DetachCommand(sqlCommand);
                }

            }
            
            return __rowsAffected; 
        }

        public IReader<SatffJobList> ListAll()
        {
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("SatffJobListListAll"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Execute command
                SqlDataReader reader = sqlCommand.ExecuteReader(AttachReaderCommand(sqlCommand));

                // Return reader
                return new SqlServerSatffJobListReader(reader); 
            }
        }

        public IReader<SatffJobList> ListForTaskId(int? taskId)
        {
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("SatffJobListListForTaskId"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Add command parameters
                SqlParameter vTaskId = new SqlParameter("@TaskId", SqlDbType.Int);
                vTaskId.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vTaskId);
                
                // Set input parameter values
                SqlServerHelper.SetParameterValue(vTaskId, taskId);

                // Execute command
                SqlDataReader reader = sqlCommand.ExecuteReader(AttachReaderCommand(sqlCommand));

                // Return reader
                return new SqlServerSatffJobListReader(reader); 
            }
        }

    }

    public partial class SqlServerSatffJobListReader : IReader<SatffJobList>
    {
        private SqlDataReader sqlDataReader;

        private SatffJobList _SatffJobList;

        private int _IdOrdinal = -1;
        private int _TaskIdOrdinal = -1;
        private int _TaskNameOrdinal = -1;
        private int _JobIdOrdinal = -1;
        private int _StaffCodeOrdinal = -1;
        private int _TimeTakenOrdinal = -1;
        private int _DateOrdinal = -1;
        private int _Field3Ordinal = -1;
        private int _Field4Ordinal = -1;
        private int _Field5Ordinal = -1;
        private int _Field6Ordinal = -1;
        private int _Field7Ordinal = -1;
        private int _TotalOrdinal = -1;
        private int _EstimateOrdinal = -1;

        public SqlServerSatffJobListReader(SqlDataReader sqlDataReader)
        {
            this.sqlDataReader = sqlDataReader; 
            for (int  i = 0; i < sqlDataReader.FieldCount; i++)
            {
                string columnName = sqlDataReader.GetName(i);
                columnName = columnName.ToUpper(); 
                switch (columnName)
                {
                    case "ID":
                        _IdOrdinal = i; 
                        break;
                    
                    case "TASKID":
                        _TaskIdOrdinal = i; 
                        break;
                    
                    case "TASKNAME":
                        _TaskNameOrdinal = i; 
                        break;
                    
                    case "JOBID":
                        _JobIdOrdinal = i; 
                        break;
                    
                    case "STAFFCODE":
                        _StaffCodeOrdinal = i; 
                        break;
                    
                    case "TIMETAKEN":
                        _TimeTakenOrdinal = i; 
                        break;
                    
                    case "DATE":
                        _DateOrdinal = i; 
                        break;
                    
                    case "FIELD3":
                        _Field3Ordinal = i; 
                        break;
                    
                    case "FIELD4":
                        _Field4Ordinal = i; 
                        break;
                    
                    case "FIELD5":
                        _Field5Ordinal = i; 
                        break;
                    
                    case "FIELD6":
                        _Field6Ordinal = i; 
                        break;
                    
                    case "FIELD7":
                        _Field7Ordinal = i; 
                        break;
                    
                    case "TOTAL":
                        _TotalOrdinal = i; 
                        break;
                    
                    case "ESTIMATE":
                        _EstimateOrdinal = i; 
                        break;
                    
                }
            }
        }

        #region IReader<SatffJobList> Implementation
        
        public bool Read()
        {
            _SatffJobList = null; 
            return this.sqlDataReader.Read(); 
        }

        public SatffJobList Current
        {
            get
            {
                if(_SatffJobList == null)
                {
                    _SatffJobList = new SatffJobList();
                    if(_IdOrdinal != -1)
                    {
                        _SatffJobList.Id = SqlServerHelper.ToInt32(sqlDataReader, _IdOrdinal); 
                    }
                    _SatffJobList.TaskId = SqlServerHelper.ToNullableInt32(sqlDataReader, _TaskIdOrdinal); 
                    _SatffJobList.TaskName = SqlServerHelper.ToString(sqlDataReader, _TaskNameOrdinal); 
                    _SatffJobList.JobId = SqlServerHelper.ToNullableInt32(sqlDataReader, _JobIdOrdinal); 
                    _SatffJobList.StaffCode = SqlServerHelper.ToNullableInt32(sqlDataReader, _StaffCodeOrdinal); 
                    _SatffJobList.TimeTaken = SqlServerHelper.ToNullableDouble(sqlDataReader, _TimeTakenOrdinal); 
                    _SatffJobList.Date = SqlServerHelper.ToNullableDateTime(sqlDataReader, _DateOrdinal); 
                    _SatffJobList.Field3 = SqlServerHelper.ToNullableInt32(sqlDataReader, _Field3Ordinal); 
                    _SatffJobList.Field4 = SqlServerHelper.ToNullableInt32(sqlDataReader, _Field4Ordinal); 
                    _SatffJobList.Field5 = SqlServerHelper.ToNullableInt32(sqlDataReader, _Field5Ordinal); 
                    _SatffJobList.Field6 = SqlServerHelper.ToNullableInt32(sqlDataReader, _Field6Ordinal); 
                    _SatffJobList.Field7 = SqlServerHelper.ToNullableInt32(sqlDataReader, _Field7Ordinal); 
                    _SatffJobList.Total = SqlServerHelper.ToNullableDouble(sqlDataReader, _TotalOrdinal); 
                    _SatffJobList.Estimate = SqlServerHelper.ToNullableDouble(sqlDataReader, _EstimateOrdinal); 
                }
                

                return _SatffJobList; 
            }
        }

        public void Close()
        {
            sqlDataReader.Close();
        }

        public List<SatffJobList> ToList()
        {
            List<SatffJobList> list = new List<SatffJobList>();
            while(this.Read())
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
        
        #region IEnumerable<SatffJobList> Implementation
        
        public IEnumerator<SatffJobList> GetEnumerator()
        {
            return new SatffJobListEnumerator(this); 
        }

        #endregion
        
        #region IEnumerable Implementation
        
        IEnumerator IEnumerable.GetEnumerator()
        {
            return new SatffJobListEnumerator(this); 
        }

        #endregion
        
        
        private partial class SatffJobListEnumerator : IEnumerator<SatffJobList>
        {
            private IReader<SatffJobList> satffJobListReader;

            public SatffJobListEnumerator(IReader<SatffJobList> satffJobListReader)
            {
                this.satffJobListReader = satffJobListReader; 
            }

            #region IEnumerator<SatffJobList> Members
            
            public SatffJobList Current
            {
                get { return this.satffJobListReader.Current; }
            }

            #endregion
            
            #region IDisposable Members
            
            public void Dispose()
            {
                this.satffJobListReader.Dispose();
            }

            #endregion
            
            #region IEnumerator Members
            
            object IEnumerator.Current
            {
                get { return this.satffJobListReader.Current; }
            }

            public bool MoveNext()
            {
                return this.satffJobListReader.Read(); 
            }

            public void Reset()
            {
                throw new Exception("Reset of satffjoblist reader is not supported."); 
            }

            #endregion
            
        }
    }
}
