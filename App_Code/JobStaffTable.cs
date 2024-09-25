// This code was generated by an EVALUATION copy of Schematrix SchemaCoder.
// Redistribution of this source code, or an application developed from it, is forbidden.
// Modification of this source code to remove this comment is also forbidden.
// Please visit http://www.schematrix.com/ to obtain a license to use this software.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.IO;

namespace JTMSProject
{
    public partial class JobStaffTable
    {
        private static IJobStaffTablePersister _DefaultPersister;
        private IJobStaffTablePersister _Persister;
        private int _JSId;
        private int? _JobId;
        private int? _StaffCode;
        private int? _CompId;

        static JobStaffTable()
        {
            // Assign default persister
            _DefaultPersister = new SqlServerJobStaffTablePersister();
        }

        public JobStaffTable()
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister; 
        }

        public JobStaffTable(int _JSId)
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister; 

            // Assign method parameter to private fields
            this._JSId = _JSId; 

            // Call associated retrieve method
            Retrieve();
        }

        public JobStaffTable(DataRow row)
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister; 

            // Assign column values to private members
            for (int  i = 0; i < row.Table.Columns.Count; i++)
            {
                switch (row.Table.Columns[i].ColumnName.ToUpper())
                {
                    case "JSID":
                        this.JSId = Convert.ToInt32(row[i, DataRowVersion.Current]); 
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
                    
                    case "COMPID":
                        if(row.IsNull(i) == false)
                        {
                            this.CompId = Convert.ToInt32(row[i, DataRowVersion.Current]); 
                        }
                        break;
                    
                }
            }
        }

        public static IJobStaffTablePersister DefaultPersister
        {
            get { return _DefaultPersister; }
            set { _DefaultPersister = value; }
        }

        public IJobStaffTablePersister Persister
        {
            get { return _Persister; }
            set { _Persister = value; }
        }

        public int JSId
        {
            get { return _JSId; }
            set { _JSId = value; }
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

        public int? CompId
        {
            get { return _CompId; }
            set { _CompId = value; }
        }

        public virtual void Clone(JobStaffTable sourceObject)
        {
            // Clone attributes from source object
            this._JSId = sourceObject.JSId; 
            this._JobId = sourceObject.JobId; 
            this._StaffCode = sourceObject.StaffCode; 
            this._CompId = sourceObject.CompId; 
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

        public virtual int Delete_new()
        {
            return _Persister.Delete_new(this);
        }

        public virtual int Insert()
        {
            return _Persister.Insert(this); 
        }

        public static IReader<JobStaffTable> ListAll()
        {
            return _DefaultPersister.ListAll(); 
        }

        public static IReader<JobStaffTable> ListForJobId(int? jobId)
        {
            return _DefaultPersister.ListForJobId(jobId); 
        }

    }
    
    public partial interface IJobStaffTablePersister
    {
        int Retrieve(JobStaffTable jobStaffTable);
        int Update(JobStaffTable jobStaffTable);
        int Delete(JobStaffTable jobStaffTable);
        int Delete_new(JobStaffTable jobStaffTable);
        int Insert(JobStaffTable jobStaffTable);
        IReader<JobStaffTable> ListAll();
        IReader<JobStaffTable> ListForJobId(int? jobId);
    }
    
    public partial class SqlServerJobStaffTablePersister : SqlPersisterBase, IJobStaffTablePersister
    {
        public SqlServerJobStaffTablePersister()
        {
        }

        public SqlServerJobStaffTablePersister(string connectionString) : base(connectionString)
        {
        }

        public SqlServerJobStaffTablePersister(SqlConnection connection) : base(connection)
        {
        }

        public SqlServerJobStaffTablePersister(SqlTransaction transaction) : base(transaction)
        {
        }

        public int Retrieve(JobStaffTable jobStaffTable)
        {
            int __rowsAffected = 1;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("JobStaffTableGet"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Add command parameters
                    SqlParameter vJSId = new SqlParameter("@JSId", SqlDbType.Int);
                    vJSId.Direction = ParameterDirection.InputOutput; 
                    sqlCommand.Parameters.Add(vJSId);
                    SqlParameter vJobId = new SqlParameter("@JobId", SqlDbType.Int);
                    vJobId.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vJobId);
                    SqlParameter vStaffCode = new SqlParameter("@StaffCode", SqlDbType.Int);
                    vStaffCode.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vStaffCode);
                    SqlParameter vCompId = new SqlParameter("@CompId", SqlDbType.Int);
                    vCompId.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vCompId);

                    // Set input parameter values
                    SqlServerHelper.SetParameterValue(vJSId, jobStaffTable.JSId);

                    // Execute command
                    sqlCommand.ExecuteNonQuery();

                    try
                    {
                        // Get output parameter values
                        jobStaffTable.JSId = SqlServerHelper.ToInt32(vJSId); 
                        jobStaffTable.JobId = SqlServerHelper.ToNullableInt32(vJobId); 
                        jobStaffTable.StaffCode = SqlServerHelper.ToNullableInt32(vStaffCode); 
                        jobStaffTable.CompId = SqlServerHelper.ToNullableInt32(vCompId); 

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

        public int Update(JobStaffTable jobStaffTable)
        {
            int __rowsAffected = 0;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("JobStaffTableUpdate"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Add command parameters
                SqlParameter vJSId = new SqlParameter("@JSId", SqlDbType.Int);
                vJSId.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vJSId);
                SqlParameter vJobId = new SqlParameter("@JobId", SqlDbType.Int);
                vJobId.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vJobId);
                SqlParameter vStaffCode = new SqlParameter("@StaffCode", SqlDbType.Int);
                vStaffCode.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vStaffCode);
                SqlParameter vCompId = new SqlParameter("@CompId", SqlDbType.Int);
                vCompId.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vCompId);

                // Set input parameter values
                SqlServerHelper.SetParameterValue(vJSId, jobStaffTable.JSId);
                SqlServerHelper.SetParameterValue(vJobId, jobStaffTable.JobId);
                SqlServerHelper.SetParameterValue(vStaffCode, jobStaffTable.StaffCode);
                SqlServerHelper.SetParameterValue(vCompId, jobStaffTable.CompId);

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

        public int Delete(JobStaffTable jobStaffTable)
        {
            int __rowsAffected = 0;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("JobStaffTableDelete"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Add command parameters
                    SqlParameter vJSId = new SqlParameter("@JSId", SqlDbType.Int);
                    vJSId.Direction = ParameterDirection.Input; 
                    sqlCommand.Parameters.Add(vJSId);

                    // Set input parameter values
                    SqlServerHelper.SetParameterValue(vJSId, jobStaffTable.JSId);

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

        public int Delete_new(JobStaffTable jobStaffTable)
        {
            int __rowsAffected = 0;

            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("JobStaffTableDelete_new"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure;

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Add command parameters
                    SqlParameter vJobId = new SqlParameter("@JobId", SqlDbType.Int);
                    vJobId.Direction = ParameterDirection.Input;
                    sqlCommand.Parameters.Add(vJobId);

                    // Set input parameter values
                    SqlServerHelper.SetParameterValue(vJobId, jobStaffTable.JobId);

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

        public int Insert(JobStaffTable jobStaffTable)
        {
            int __rowsAffected = 0;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("JobStaffTableInsert"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Add command parameters
                SqlParameter vJSId = new SqlParameter("@JSId", SqlDbType.Int);
                vJSId.Direction = ParameterDirection.InputOutput; 
                sqlCommand.Parameters.Add(vJSId);
                SqlParameter vJobId = new SqlParameter("@JobId", SqlDbType.Int);
                vJobId.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vJobId);
                SqlParameter vStaffCode = new SqlParameter("@StaffCode", SqlDbType.Int);
                vStaffCode.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vStaffCode);
                SqlParameter vCompId = new SqlParameter("@CompId", SqlDbType.Int);
                vCompId.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vCompId);

                // Set input parameter values
                SqlServerHelper.SetParameterValue(
                    vJSId, 
                    jobStaffTable.JSId, 
                    0);
                SqlServerHelper.SetParameterValue(vJobId, jobStaffTable.JobId);
                SqlServerHelper.SetParameterValue(vStaffCode, jobStaffTable.StaffCode);
                SqlServerHelper.SetParameterValue(vCompId, jobStaffTable.CompId);

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
                    jobStaffTable.JSId = SqlServerHelper.ToInt32(vJSId); 

                }
                finally
                {
                    // Detach command
                    DetachCommand(sqlCommand);
                }

            }
            
            return __rowsAffected; 
        }

        public IReader<JobStaffTable> ListAll()
        {
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("JobStaffTableListAll"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Execute command
                SqlDataReader reader = sqlCommand.ExecuteReader(AttachReaderCommand(sqlCommand));

                // Return reader
                return new SqlServerJobStaffTableReader(reader); 
            }
        }

        public IReader<JobStaffTable> ListForJobId(int? jobId)
        {
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("JobStaffTableListForJobId"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Add command parameters
                SqlParameter vJobId = new SqlParameter("@JobId", SqlDbType.Int);
                vJobId.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vJobId);
                
                // Set input parameter values
                SqlServerHelper.SetParameterValue(vJobId, jobId);

                // Execute command
                SqlDataReader reader = sqlCommand.ExecuteReader(AttachReaderCommand(sqlCommand));

                // Return reader
                return new SqlServerJobStaffTableReader(reader); 
            }
        }

    }

    public partial class SqlServerJobStaffTableReader : IReader<JobStaffTable>
    {
        private SqlDataReader sqlDataReader;

        private JobStaffTable _JobStaffTable;

        private int _JSIdOrdinal = -1;
        private int _JobIdOrdinal = -1;
        private int _StaffCodeOrdinal = -1;
        private int _CompIdOrdinal = -1;

        public SqlServerJobStaffTableReader(SqlDataReader sqlDataReader)
        {
            this.sqlDataReader = sqlDataReader; 
            for (int  i = 0; i < sqlDataReader.FieldCount; i++)
            {
                string columnName = sqlDataReader.GetName(i);
                columnName = columnName.ToUpper(); 
                switch (columnName)
                {
                    case "JSID":
                        _JSIdOrdinal = i; 
                        break;
                    
                    case "JOBID":
                        _JobIdOrdinal = i; 
                        break;
                    
                    case "STAFFCODE":
                        _StaffCodeOrdinal = i; 
                        break;
                    
                    case "COMPID":
                        _CompIdOrdinal = i; 
                        break;
                    
                }
            }
        }

        #region IReader<JobStaffTable> Implementation
        
        public bool Read()
        {
            _JobStaffTable = null; 
            return this.sqlDataReader.Read(); 
        }

        public JobStaffTable Current
        {
            get
            {
                if(_JobStaffTable == null)
                {
                    _JobStaffTable = new JobStaffTable();
                    if(_JSIdOrdinal != -1)
                    {
                        _JobStaffTable.JSId = SqlServerHelper.ToInt32(sqlDataReader, _JSIdOrdinal); 
                    }
                    _JobStaffTable.JobId = SqlServerHelper.ToNullableInt32(sqlDataReader, _JobIdOrdinal); 
                    _JobStaffTable.StaffCode = SqlServerHelper.ToNullableInt32(sqlDataReader, _StaffCodeOrdinal); 
                    _JobStaffTable.CompId = SqlServerHelper.ToNullableInt32(sqlDataReader, _CompIdOrdinal); 
                }
                

                return _JobStaffTable; 
            }
        }

        public void Close()
        {
            sqlDataReader.Close();
        }

        public List<JobStaffTable> ToList()
        {
            List<JobStaffTable> list = new List<JobStaffTable>();
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
        
        #region IEnumerable<JobStaffTable> Implementation
        
        public IEnumerator<JobStaffTable> GetEnumerator()
        {
            return new JobStaffTableEnumerator(this); 
        }

        #endregion
        
        #region IEnumerable Implementation
        
        IEnumerator IEnumerable.GetEnumerator()
        {
            return new JobStaffTableEnumerator(this); 
        }

        #endregion
        
        
        private partial class JobStaffTableEnumerator : IEnumerator<JobStaffTable>
        {
            private IReader<JobStaffTable> jobStaffTableReader;

            public JobStaffTableEnumerator(IReader<JobStaffTable> jobStaffTableReader)
            {
                this.jobStaffTableReader = jobStaffTableReader; 
            }

            #region IEnumerator<JobStaffTable> Members
            
            public JobStaffTable Current
            {
                get { return this.jobStaffTableReader.Current; }
            }

            #endregion
            
            #region IDisposable Members
            
            public void Dispose()
            {
                this.jobStaffTableReader.Dispose();
            }

            #endregion
            
            #region IEnumerator Members
            
            object IEnumerator.Current
            {
                get { return this.jobStaffTableReader.Current; }
            }

            public bool MoveNext()
            {
                return this.jobStaffTableReader.Read(); 
            }

            public void Reset()
            {
                throw new Exception("Reset of jobstafftable reader is not supported."); 
            }

            #endregion
            
        }
    }
}
