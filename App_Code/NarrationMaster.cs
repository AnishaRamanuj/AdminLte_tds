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
    public partial class NarrationMaster
    {
        private static INarrationMasterPersister _DefaultPersister;
        private INarrationMasterPersister _Persister;
        private int _NarId;
        private int? _CompId;
        private int? _id;
        private string _NarrationName;
        private int? _StaffCode;

        static NarrationMaster()
        {
            // Assign default persister
            _DefaultPersister = new SqlServerNarrationMasterPersister();
        }

        public NarrationMaster()
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister; 
        }

        public NarrationMaster(int _NarId)
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister; 

            // Assign method parameter to private fields
            this._NarId = _NarId; 

            // Call associated retrieve method
            Retrieve();
        }

        public NarrationMaster(DataRow row)
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister; 

            // Assign column values to private members
            for (int  i = 0; i < row.Table.Columns.Count; i++)
            {
                switch (row.Table.Columns[i].ColumnName.ToUpper())
                {
                    case "NARID":
                        this.NarId = Convert.ToInt32(row[i, DataRowVersion.Current]); 
                        break;
                    
                    case "COMPID":
                        if(row.IsNull(i) == false)
                        {
                            this.CompId = Convert.ToInt32(row[i, DataRowVersion.Current]); 
                        }
                        break;
                    
                    case "ID":
                        if(row.IsNull(i) == false)
                        {
                            this.id = Convert.ToInt32(row[i, DataRowVersion.Current]); 
                        }
                        break;
                    
                    case "NARRATIONNAME":
                        if(row.IsNull(i) == false)
                        {
                            this.NarrationName = (string)row[i, DataRowVersion.Current]; 
                        }
                        break;
                    
                    case "STAFFCODE":
                        if(row.IsNull(i) == false)
                        {
                            this.StaffCode = Convert.ToInt32(row[i, DataRowVersion.Current]); 
                        }
                        break;
                    
                }
            }
        }

        public static INarrationMasterPersister DefaultPersister
        {
            get { return _DefaultPersister; }
            set { _DefaultPersister = value; }
        }

        public INarrationMasterPersister Persister
        {
            get { return _Persister; }
            set { _Persister = value; }
        }

        public int NarId
        {
            get { return _NarId; }
            set { _NarId = value; }
        }

        public int? CompId
        {
            get { return _CompId; }
            set { _CompId = value; }
        }

        public int? id
        {
            get { return _id; }
            set { _id = value; }
        }

        public string NarrationName
        {
            get { return _NarrationName; }
            set { _NarrationName = value; }
        }

        public int? StaffCode
        {
            get { return _StaffCode; }
            set { _StaffCode = value; }
        }

        public virtual void Clone(NarrationMaster sourceObject)
        {
            // Clone attributes from source object
            this._NarId = sourceObject.NarId; 
            this._CompId = sourceObject.CompId; 
            this._id = sourceObject.id; 
            this._NarrationName = sourceObject.NarrationName; 
            this._StaffCode = sourceObject.StaffCode; 
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

        public static IReader<NarrationMaster> ListAll()
        {
            return _DefaultPersister.ListAll(); 
        }

    }
    
    public partial interface INarrationMasterPersister
    {
        int Retrieve(NarrationMaster narrationMaster);
        int Update(NarrationMaster narrationMaster);
        int Delete(NarrationMaster narrationMaster);
        int Insert(NarrationMaster narrationMaster);
        IReader<NarrationMaster> ListAll();
    }
    
    public partial class SqlServerNarrationMasterPersister : SqlPersisterBase, INarrationMasterPersister
    {
        public SqlServerNarrationMasterPersister()
        {
        }

        public SqlServerNarrationMasterPersister(string connectionString) : base(connectionString)
        {
        }

        public SqlServerNarrationMasterPersister(SqlConnection connection) : base(connection)
        {
        }

        public SqlServerNarrationMasterPersister(SqlTransaction transaction) : base(transaction)
        {
        }

        public int Retrieve(NarrationMaster narrationMaster)
        {
            int __rowsAffected = 1;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("NarrationMasterGet"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Add command parameters
                    SqlParameter vNarId = new SqlParameter("@NarId", SqlDbType.Int);
                    vNarId.Direction = ParameterDirection.InputOutput; 
                    sqlCommand.Parameters.Add(vNarId);
                    SqlParameter vCompId = new SqlParameter("@CompId", SqlDbType.Int);
                    vCompId.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vCompId);
                    SqlParameter vid = new SqlParameter("@id", SqlDbType.Int);
                    vid.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vid);
                    SqlParameter vNarrationName = new SqlParameter("@NarrationName", SqlDbType.VarChar, 300);
                    vNarrationName.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vNarrationName);
                    SqlParameter vStaffCode = new SqlParameter("@StaffCode", SqlDbType.Int);
                    vStaffCode.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vStaffCode);

                    // Set input parameter values
                    SqlServerHelper.SetParameterValue(vNarId, narrationMaster.NarId);

                    // Execute command
                    sqlCommand.ExecuteNonQuery();

                    try
                    {
                        // Get output parameter values
                        narrationMaster.NarId = SqlServerHelper.ToInt32(vNarId); 
                        narrationMaster.CompId = SqlServerHelper.ToNullableInt32(vCompId); 
                        narrationMaster.id = SqlServerHelper.ToNullableInt32(vid); 
                        narrationMaster.NarrationName = SqlServerHelper.ToString(vNarrationName); 
                        narrationMaster.StaffCode = SqlServerHelper.ToNullableInt32(vStaffCode); 

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

        public int Update(NarrationMaster narrationMaster)
        {
            int __rowsAffected = 0;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("NarrationMasterUpdate"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Add command parameters
                SqlParameter vNarId = new SqlParameter("@NarId", SqlDbType.Int);
                vNarId.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vNarId);
                SqlParameter vCompId = new SqlParameter("@CompId", SqlDbType.Int);
                vCompId.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vCompId);
                SqlParameter vid = new SqlParameter("@id", SqlDbType.Int);
                vid.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vid);
                SqlParameter vNarrationName = new SqlParameter("@NarrationName", SqlDbType.VarChar, 300);
                vNarrationName.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vNarrationName);
                SqlParameter vStaffCode = new SqlParameter("@StaffCode", SqlDbType.Int);
                vStaffCode.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vStaffCode);

                // Set input parameter values
                SqlServerHelper.SetParameterValue(vNarId, narrationMaster.NarId);
                SqlServerHelper.SetParameterValue(vCompId, narrationMaster.CompId);
                SqlServerHelper.SetParameterValue(vid, narrationMaster.id);
                SqlServerHelper.SetParameterValue(vNarrationName, narrationMaster.NarrationName);
                SqlServerHelper.SetParameterValue(vStaffCode, narrationMaster.StaffCode);

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

        public int Delete(NarrationMaster narrationMaster)
        {
            int __rowsAffected = 0;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("NarrationMasterDelete"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Add command parameters
                    SqlParameter vNarId = new SqlParameter("@NarId", SqlDbType.Int);
                    vNarId.Direction = ParameterDirection.Input; 
                    sqlCommand.Parameters.Add(vNarId);

                    // Set input parameter values
                    SqlServerHelper.SetParameterValue(vNarId, narrationMaster.NarId);

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

        public int Insert(NarrationMaster narrationMaster)
        {
            int __rowsAffected = 0;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("NarrationMasterInsert"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Add command parameters
                SqlParameter vNarId = new SqlParameter("@NarId", SqlDbType.Int);
                vNarId.Direction = ParameterDirection.InputOutput; 
                sqlCommand.Parameters.Add(vNarId);
                SqlParameter vCompId = new SqlParameter("@CompId", SqlDbType.Int);
                vCompId.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vCompId);
                SqlParameter vid = new SqlParameter("@id", SqlDbType.Int);
                vid.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vid);
                SqlParameter vNarrationName = new SqlParameter("@NarrationName", SqlDbType.VarChar, 300);
                vNarrationName.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vNarrationName);
                SqlParameter vStaffCode = new SqlParameter("@StaffCode", SqlDbType.Int);
                vStaffCode.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vStaffCode);

                // Set input parameter values
                SqlServerHelper.SetParameterValue(
                    vNarId, 
                    narrationMaster.NarId, 
                    0);
                SqlServerHelper.SetParameterValue(vCompId, narrationMaster.CompId);
                SqlServerHelper.SetParameterValue(vid, narrationMaster.id);
                SqlServerHelper.SetParameterValue(vNarrationName, narrationMaster.NarrationName);
                SqlServerHelper.SetParameterValue(vStaffCode, narrationMaster.StaffCode);

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
                    narrationMaster.NarId = SqlServerHelper.ToInt32(vNarId); 

                }
                finally
                {
                    // Detach command
                    DetachCommand(sqlCommand);
                }

            }
            
            return __rowsAffected; 
        }

        public IReader<NarrationMaster> ListAll()
        {
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("NarrationMasterListAll"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Execute command
                SqlDataReader reader = sqlCommand.ExecuteReader(AttachReaderCommand(sqlCommand));

                // Return reader
                return new SqlServerNarrationMasterReader(reader); 
            }
        }

    }

    public partial class SqlServerNarrationMasterReader : IReader<NarrationMaster>
    {
        private SqlDataReader sqlDataReader;

        private NarrationMaster _NarrationMaster;

        private int _NarIdOrdinal = -1;
        private int _CompIdOrdinal = -1;
        private int _idOrdinal = -1;
        private int _NarrationNameOrdinal = -1;
        private int _StaffCodeOrdinal = -1;

        public SqlServerNarrationMasterReader(SqlDataReader sqlDataReader)
        {
            this.sqlDataReader = sqlDataReader; 
            for (int  i = 0; i < sqlDataReader.FieldCount; i++)
            {
                string columnName = sqlDataReader.GetName(i);
                columnName = columnName.ToUpper(); 
                switch (columnName)
                {
                    case "NARID":
                        _NarIdOrdinal = i; 
                        break;
                    
                    case "COMPID":
                        _CompIdOrdinal = i; 
                        break;
                    
                    case "ID":
                        _idOrdinal = i; 
                        break;
                    
                    case "NARRATIONNAME":
                        _NarrationNameOrdinal = i; 
                        break;
                    
                    case "STAFFCODE":
                        _StaffCodeOrdinal = i; 
                        break;
                    
                }
            }
        }

        #region IReader<NarrationMaster> Implementation
        
        public bool Read()
        {
            _NarrationMaster = null; 
            return this.sqlDataReader.Read(); 
        }

        public NarrationMaster Current
        {
            get
            {
                if(_NarrationMaster == null)
                {
                    _NarrationMaster = new NarrationMaster();
                    if(_NarIdOrdinal != -1)
                    {
                        _NarrationMaster.NarId = SqlServerHelper.ToInt32(sqlDataReader, _NarIdOrdinal); 
                    }
                    _NarrationMaster.CompId = SqlServerHelper.ToNullableInt32(sqlDataReader, _CompIdOrdinal); 
                    _NarrationMaster.id = SqlServerHelper.ToNullableInt32(sqlDataReader, _idOrdinal); 
                    _NarrationMaster.NarrationName = SqlServerHelper.ToString(sqlDataReader, _NarrationNameOrdinal); 
                    _NarrationMaster.StaffCode = SqlServerHelper.ToNullableInt32(sqlDataReader, _StaffCodeOrdinal); 
                }
                

                return _NarrationMaster; 
            }
        }

        public void Close()
        {
            sqlDataReader.Close();
        }

        public List<NarrationMaster> ToList()
        {
            List<NarrationMaster> list = new List<NarrationMaster>();
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
        
        #region IEnumerable<NarrationMaster> Implementation
        
        public IEnumerator<NarrationMaster> GetEnumerator()
        {
            return new NarrationMasterEnumerator(this); 
        }

        #endregion
        
        #region IEnumerable Implementation
        
        IEnumerator IEnumerable.GetEnumerator()
        {
            return new NarrationMasterEnumerator(this); 
        }

        #endregion
        
        
        private partial class NarrationMasterEnumerator : IEnumerator<NarrationMaster>
        {
            private IReader<NarrationMaster> narrationMasterReader;

            public NarrationMasterEnumerator(IReader<NarrationMaster> narrationMasterReader)
            {
                this.narrationMasterReader = narrationMasterReader; 
            }

            #region IEnumerator<NarrationMaster> Members
            
            public NarrationMaster Current
            {
                get { return this.narrationMasterReader.Current; }
            }

            #endregion
            
            #region IDisposable Members
            
            public void Dispose()
            {
                this.narrationMasterReader.Dispose();
            }

            #endregion
            
            #region IEnumerator Members
            
            object IEnumerator.Current
            {
                get { return this.narrationMasterReader.Current; }
            }

            public bool MoveNext()
            {
                return this.narrationMasterReader.Read(); 
            }

            public void Reset()
            {
                throw new Exception("Reset of narrationmaster reader is not supported."); 
            }

            #endregion
            
        }
    }
}
