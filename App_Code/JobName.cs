using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.IO;

namespace JTMSProject
{

    public partial class JobName
    {
        private static IJobNamePersister _DefaultPersister;
        private IJobNamePersister _Persister;
        private int _mJobId;
        private int? _id;
        private int? _CompId;
        private string _mJobName;
        private string _JobCode;
        private string _Project_Id;
        //private double? _DayNo;

        static JobName()
        {
            // Assign default persister
            _DefaultPersister = new SqlServerJobNamePersister();
        }

        public JobName()
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister;
        }

        public JobName(int _mJobid)
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister;

            // Assign method parameter to private fields
            this._mJobId = _mJobid;

            // Call associated retrieve method
            Retrieve();
        }

        public JobName(DataRow row)
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister;

            // Assign column values to private members
            for (int i = 0; i < row.Table.Columns.Count; i++)
            {
                switch (row.Table.Columns[i].ColumnName.ToUpper())
                {
                    case "mJobID":
                        this.mJobid = Convert.ToInt32(row[i, DataRowVersion.Current]);
                        break;

                    case "ID":
                        if (row.IsNull(i) == false)
                        {
                            this.id = Convert.ToInt32(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "COMPID":
                        if (row.IsNull(i) == false)
                        {
                            this.CompId = Convert.ToInt32(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "mJobNAME":
                        if (row.IsNull(i) == false)
                        {
                            this.mJobName = (string)row[i, DataRowVersion.Current];
                        }
                        break;
                        
                    case "JobCode":
                        if (row.IsNull(i) == false)
                        {
                            this.JobCode = (string)row[i, DataRowVersion.Current];
                        }
                        break;
                    //case "DayNo":
                    //    if (row.IsNull(i) == false)
                    //    {
                    //        this.DayNo = Convert.ToDouble(row[i, DataRowVersion.Current]);
                    //    }
                    //    break;

                }
            }
        }

        public static IJobNamePersister DefaultPersister
        {
            get { return _DefaultPersister; }
            set { _DefaultPersister = value; }
        }

        public IJobNamePersister Persister
        {
            get { return _Persister; }
            set { _Persister = value; }
        }

        public int mJobid
        {
            get { return _mJobId ; }
            set { _mJobId  = value; }
        }

        public int? id
        {
            get { return _id; }
            set { _id = value; }
        }

        public int? CompId
        {
            get { return _CompId; }
            set { _CompId = value; }
        }

        public string mJobName
        {
            get { return _mJobName; }
            set { _mJobName = value; }
        }

        public string Project_Id
        {
            get { return _Project_Id; }
            set { _Project_Id = value; }
        }
         public string JobCode
        {
            get { return _JobCode; }
            set { _JobCode = value; }
        }
        
        //public double? DayNo
        //{
        //    get { return _DayNo; }
        //    set { _DayNo = value; }
        //}

        public virtual void Clone(JobName sourceObject)
        {
            // Clone attributes from source object
            this._mJobId  = sourceObject.mJobid;
            this._id = sourceObject.id;
            this._CompId = sourceObject.CompId;
            this._mJobName = sourceObject.mJobName;
            this._Project_Id = sourceObject.Project_Id;
            
            this._JobCode = sourceObject.JobCode;
            //this._DayNo = sourceObject.DayNo;
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

        public static IReader<JobName> ListAll()
        {
            return _DefaultPersister.ListAll();
        }
    }
    public partial interface IJobNamePersister
    {
        int Retrieve(JobName JobNameMaster);
        int Update(JobName JobNameMaster);
        int Delete(JobName JobNameMaster);
        int Insert(JobName JobNameMaster);
        IReader<JobName> ListAll();
    }

    public partial class SqlServerJobNamePersister : SqlPersisterBase, IJobNamePersister
    {
        public SqlServerJobNamePersister()
        {
        }

        public SqlServerJobNamePersister(string connectionString)
            : base(connectionString)
        {
        }

        public SqlServerJobNamePersister(SqlConnection connection)
            : base(connection)
        {
        }

        public SqlServerJobNamePersister(SqlTransaction transaction)
            : base(transaction)
        {
        }

        public int Retrieve(JobName JobNameMaster)
        {
            int __rowsAffected = 1;

            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("JobNameGet"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure;

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Add command parameters
                    SqlParameter vmJobid = new SqlParameter("@mJobid", SqlDbType.Int);
                    vmJobid.Direction = ParameterDirection.InputOutput;
                    sqlCommand.Parameters.Add(vmJobid);
                    SqlParameter vid = new SqlParameter("@id", SqlDbType.Int);
                    vid.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vid);
                    SqlParameter vCompId = new SqlParameter("@CompId", SqlDbType.Int);
                    vCompId.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vCompId);
                    SqlParameter vmJobName = new SqlParameter("@mJobName", SqlDbType.VarChar, 70);
                    vmJobName.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vmJobName);
                    SqlParameter vmProject_Id = new SqlParameter("@Pid", SqlDbType.VarChar, 150);
                    vmProject_Id.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vmProject_Id);
                    
                    //SqlParameter vJobCode = new SqlParameter("@JobCode", SqlDbType.VarChar, 70);
                    //vmJobName.Direction = ParameterDirection.Output;
                    //sqlCommand.Parameters.Add(vJobCode);
                    //SqlParameter vDayNo = new SqlParameter("@DayNo", SqlDbType.Float);
                    //vDayNo.Direction = ParameterDirection.Output;
                    //sqlCommand.Parameters.Add(vDayNo);

                    // Set input parameter values
                    SqlServerHelper.SetParameterValue(vmJobid, JobNameMaster.mJobid);

                    // Execute command
                    sqlCommand.ExecuteNonQuery();

                    try
                    {
                        // Get output parameter values
                        JobNameMaster.mJobid = SqlServerHelper.ToInt32(vmJobid);
                        JobNameMaster.id = SqlServerHelper.ToNullableInt32(vid);
                        JobNameMaster.CompId = SqlServerHelper.ToNullableInt32(vCompId);
                        JobNameMaster.mJobName = SqlServerHelper.ToString(vmJobName);
                        JobNameMaster.Project_Id = SqlServerHelper.ToString(vmProject_Id);
                      
                        //JobNameMaster.JobCode = SqlServerHelper.ToString(vJobCode);
                        //JobNameMaster.DayNo = SqlServerHelper.ToNullableDouble(vDayNo);

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

        public int Update(JobName JobNameMaster)
        {
            int __rowsAffected = 0;

            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("usp_JobNameUpdate"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure;

                // Add command parameters
                SqlParameter vmJobid = new SqlParameter("@mJobid", SqlDbType.Int);
                vmJobid.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vmJobid);
                SqlParameter vid = new SqlParameter("@id", SqlDbType.Int);
                vid.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vid);
                SqlParameter vCompId = new SqlParameter("@CompId", SqlDbType.Int);
                vCompId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vCompId);
                SqlParameter vmJobName = new SqlParameter("@mJobName", SqlDbType.VarChar, 70);
                vmJobName.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vmJobName);
                SqlParameter vmProject_Id = new SqlParameter("@Pid", SqlDbType.VarChar, 150);
                vmProject_Id.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vmProject_Id);
                
                //SqlParameter vJobCode = new SqlParameter("@JobCode", SqlDbType.VarChar, 70);
                //vmJobName.Direction = ParameterDirection.Input;
                //sqlCommand.Parameters.Add(vJobCode);

                //SqlParameter vDayNo = new SqlParameter("@DayNo", SqlDbType.Float);
                //vDayNo.Direction = ParameterDirection.Input;
                //sqlCommand.Parameters.Add(vDayNo);

                // Set input parameter values
                SqlServerHelper.SetParameterValue(vmJobid, JobNameMaster.mJobid);
                SqlServerHelper.SetParameterValue(vid, JobNameMaster.id);
                SqlServerHelper.SetParameterValue(vCompId, JobNameMaster.CompId);
                SqlServerHelper.SetParameterValue(vmJobName, JobNameMaster.mJobName);
                SqlServerHelper.SetParameterValue(vmProject_Id, JobNameMaster.Project_Id );
                //SqlServerHelper.SetParameterValue(vJobCode, JobNameMaster.JobCode);
                //SqlServerHelper.SetParameterValue(vDayNo, JobNameMaster.DayNo);

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

        public int Delete(JobName JobNameMaster)
        {
            int __rowsAffected = 0;

            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("JobNameDelete"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure;

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Add command parameters
                    SqlParameter vmJobid = new SqlParameter("@mJobid", SqlDbType.Int);
                    vmJobid.Direction = ParameterDirection.Input;
                    sqlCommand.Parameters.Add(vmJobid);

                    // Set input parameter values
                    SqlServerHelper.SetParameterValue(vmJobid, JobNameMaster.mJobid);

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

        public int Insert(JobName JobNameMaster)
        {
            int __rowsAffected = 0;

            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("JobNameInsert"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure;

                // Add command parameters
                SqlParameter vmJobid = new SqlParameter("@mJobid", SqlDbType.Int);
                vmJobid.Direction = ParameterDirection.InputOutput;
                sqlCommand.Parameters.Add(vmJobid);
                SqlParameter vid = new SqlParameter("@id", SqlDbType.Int);
                vid.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vid);
                SqlParameter vCompId = new SqlParameter("@CompId", SqlDbType.Int);
                vCompId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vCompId);
                SqlParameter vmJobName = new SqlParameter("@mJobName", SqlDbType.VarChar, 70);
                vmJobName.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vmJobName);
                //SqlParameter vmProject_Id = new SqlParameter("@Pid", SqlDbType.VarChar, 150);
                //vmProject_Id.Direction = ParameterDirection.Input;
                //sqlCommand.Parameters.Add(vmProject_Id);
                //SqlParameter vJobCode = new SqlParameter("@JobCode", SqlDbType.VarChar, 70);
                //vmJobName.Direction = ParameterDirection.Input;
                //sqlCommand.Parameters.Add(vJobCode);
                //SqlParameter vDayNo = new SqlParameter("@DayNo", SqlDbType.Float);
                //vDayNo.Direction = ParameterDirection.Input;
                //sqlCommand.Parameters.Add(vDayNo);

                // Set input parameter values
                SqlServerHelper.SetParameterValue(
                    vmJobid,
                    JobNameMaster.mJobid,
                    0);
                SqlServerHelper.SetParameterValue(vid, JobNameMaster.id);
                SqlServerHelper.SetParameterValue(vCompId, JobNameMaster.CompId);
                SqlServerHelper.SetParameterValue(vmJobName, JobNameMaster.mJobName);
                //SqlServerHelper.SetParameterValue(vmProject_Id, JobNameMaster.Project_Id);                
                 //SqlServerHelper.SetParameterValue(vJobCode, JobNameMaster.JobCode);
                //SqlServerHelper.SetParameterValue(vDayNo, JobNameMaster.DayNo);

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
                    JobNameMaster.mJobid = SqlServerHelper.ToInt32(vmJobid);

                }
                finally
                {
                    // Detach command
                    DetachCommand(sqlCommand);
                }

            }

            return __rowsAffected;
        }

        public IReader<JobName> ListAll()
        {
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("JobNameListAll"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure;

                // Execute command
                SqlDataReader reader = sqlCommand.ExecuteReader(AttachReaderCommand(sqlCommand));

                // Return reader
                return new SqlServerJobNameReader(reader);
            }
        }

    }

    public partial class SqlServerJobNameReader : IReader<JobName>
    {
        private SqlDataReader sqlDataReader;

        private JobName _JobNameMaster;

        private int _mJobidOrdinal = -1;
        private int _idOrdinal = -1;
        private int _CompIdOrdinal = -1;
        private int _mJobNameOrdinal = -1;
        private int _Project_IdOrdinal = -1;
        private int _JobCodeOrdinal = -1;
        //private int _DayNoOrdinal = -1;

        public SqlServerJobNameReader(SqlDataReader sqlDataReader)
        {
            this.sqlDataReader = sqlDataReader;
            for (int i = 0; i < sqlDataReader.FieldCount; i++)
            {
                string columnName = sqlDataReader.GetName(i);
                columnName = columnName.ToUpper();
                switch (columnName)
                {
                    case "mJobID":
                        _mJobidOrdinal = i;
                        break;

                    case "ID":
                        _idOrdinal = i;
                        break;

                    case "COMPID":
                        _CompIdOrdinal = i;
                        break;

                    case "mJobName":
                        _mJobNameOrdinal = i;
                        break;

                    case "Project_Id":
                        _Project_IdOrdinal = i;
                        break;

                    case "JobCode":
                        _JobCodeOrdinal = i;
                        break;
                    //case "DayNo":
                    //    _DayNoOrdinal = i;
                    //    break;

                }
            }
        }

        #region IReader<JobNameMaster> Implementation

        public bool Read()
        {
            _JobNameMaster = null;
            return this.sqlDataReader.Read();
        }

        public JobName Current
        {
            get
            {
                if (_JobNameMaster == null)
                {
                    _JobNameMaster = new JobName();
                    if (_mJobidOrdinal != -1)
                    {
                        _JobNameMaster.mJobid = SqlServerHelper.ToInt32(sqlDataReader, _mJobidOrdinal);
                    }
                    _JobNameMaster.id = SqlServerHelper.ToNullableInt32(sqlDataReader, _idOrdinal);
                    _JobNameMaster.CompId = SqlServerHelper.ToNullableInt32(sqlDataReader, _CompIdOrdinal);
                    _JobNameMaster.mJobName = SqlServerHelper.ToString(sqlDataReader, _mJobNameOrdinal);
                    
                    _JobNameMaster.JobCode = SqlServerHelper.ToString(sqlDataReader, _JobCodeOrdinal);
                    //_JobNameMaster.DayNo = SqlServerHelper.ToNullableDouble(sqlDataReader, _DayNoOrdinal);
                }


                return _JobNameMaster;
            }
        }

        public void Close()
        {
            sqlDataReader.Close();
        }

        public List<JobName> ToList()
        {
            List<JobName> list = new List<JobName>();
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

        #region IEnumerable<JobNameMaster> Implementation

        public IEnumerator<JobName> GetEnumerator()
        {
            return new JobNameEnumerator(this);
        }

        #endregion

        #region IEnumerable Implementation

        IEnumerator IEnumerable.GetEnumerator()
        {
            return new JobNameEnumerator(this);
        }

        #endregion


        private partial class JobNameEnumerator : IEnumerator<JobName>
        {
            private IReader<JobName> JobNameMasterReader;

            public JobNameEnumerator(IReader<JobName> JobNameMasterReader)
            {
                this.JobNameMasterReader = JobNameMasterReader;
            }

            #region IEnumerator<JobNameMaster> Members

            public JobName Current
            {
                get { return this.JobNameMasterReader.Current; }
            }

            #endregion

            #region IDisposable Members

            public void Dispose()
            {
                this.JobNameMasterReader.Dispose();
            }

            #endregion

            #region IEnumerator Members

            object IEnumerator.Current
            {
                get { return this.JobNameMasterReader.Current; }
            }

            public bool MoveNext()
            {
                return this.JobNameMasterReader.Read();
            }

            public void Reset()
            {
                throw new Exception("Reset of JobName reader is not supported.");
            }

            #endregion

        }
    }
}