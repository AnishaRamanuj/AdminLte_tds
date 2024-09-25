
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.IO;

namespace JTMSProject
{
    public partial class SecurityPermission
    {
        private static ISecurityPermissionPersister _DefaultPersister;
        private ISecurityPermissionPersister _Persister;
        private int _SPId;
        private int? _CompId;
        private string _Schemes;
        private int? _UserCount;
        private int? _StaffCount;
        private string _WebSpace;
        private int? _DayCount;
        private decimal? _Price;
        private string _Version;

        static SecurityPermission()
        {
            // Assign default persister
            _DefaultPersister = new SqlServerSecurityPermissionPersister();
        }

        public SecurityPermission()
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister; 
        }

        public SecurityPermission(int _SPId)
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister; 

            // Assign method parameter to private fields
            this._SPId = _SPId; 

            // Call associated retrieve method
            Retrieve();
        }

        public SecurityPermission(DataRow row)
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister; 

            // Assign column values to private members
            for (int  i = 0; i < row.Table.Columns.Count; i++)
            {
                switch (row.Table.Columns[i].ColumnName.ToUpper())
                {
                    case "SPID":
                        this.SPId = Convert.ToInt32(row[i, DataRowVersion.Current]); 
                        break;
                    
                    case "COMPID":
                        if(row.IsNull(i) == false)
                        {
                            this.CompId = Convert.ToInt32(row[i, DataRowVersion.Current]); 
                        }
                        break;
                    
                    case "SCHEMES":
                        if(row.IsNull(i) == false)
                        {
                            this.Schemes = (string)row[i, DataRowVersion.Current]; 
                        }
                        break;
                    
                    case "USERCOUNT":
                        if(row.IsNull(i) == false)
                        {
                            this.UserCount = Convert.ToInt32(row[i, DataRowVersion.Current]); 
                        }
                        break;
                    
                    case "STAFFCOUNT":
                        if(row.IsNull(i) == false)
                        {
                            this.StaffCount = Convert.ToInt32(row[i, DataRowVersion.Current]); 
                        }
                        break;
                    
                    case "WEBSPACE":
                        if(row.IsNull(i) == false)
                        {
                            this.WebSpace = (string)row[i, DataRowVersion.Current]; 
                        }
                        break;
                    
                    case "DAYCOUNT":
                        if(row.IsNull(i) == false)
                        {
                            this.DayCount = Convert.ToInt32(row[i, DataRowVersion.Current]); 
                        }
                        break;
                    
                    case "PRICE":
                        if(row.IsNull(i) == false)
                        {
                            this.Price = Convert.ToDecimal(row[i, DataRowVersion.Current]); 
                        }
                        break;
                    
                    case "VERSION":
                        if(row.IsNull(i) == false)
                        {
                            this.Version = (string)row[i, DataRowVersion.Current]; 
                        }
                        break;
                    
                }
            }
        }

        public static ISecurityPermissionPersister DefaultPersister
        {
            get { return _DefaultPersister; }
            set { _DefaultPersister = value; }
        }

        public ISecurityPermissionPersister Persister
        {
            get { return _Persister; }
            set { _Persister = value; }
        }

        public int SPId
        {
            get { return _SPId; }
            set { _SPId = value; }
        }

        public int? CompId
        {
            get { return _CompId; }
            set { _CompId = value; }
        }

        public string Schemes
        {
            get { return _Schemes; }
            set { _Schemes = value; }
        }

        public int? UserCount
        {
            get { return _UserCount; }
            set { _UserCount = value; }
        }

        public int? StaffCount
        {
            get { return _StaffCount; }
            set { _StaffCount = value; }
        }

        public string WebSpace
        {
            get { return _WebSpace; }
            set { _WebSpace = value; }
        }

        public int? DayCount
        {
            get { return _DayCount; }
            set { _DayCount = value; }
        }

        public decimal? Price
        {
            get { return _Price; }
            set { _Price = value; }
        }

        public string Version
        {
            get { return _Version; }
            set { _Version = value; }
        }

        public virtual void Clone(SecurityPermission sourceObject)
        {
            // Clone attributes from source object
            this._SPId = sourceObject.SPId; 
            this._CompId = sourceObject.CompId; 
            this._Schemes = sourceObject.Schemes; 
            this._UserCount = sourceObject.UserCount; 
            this._StaffCount = sourceObject.StaffCount; 
            this._WebSpace = sourceObject.WebSpace; 
            this._DayCount = sourceObject.DayCount; 
            this._Price = sourceObject.Price; 
            this._Version = sourceObject.Version; 
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

        public static IReader<SecurityPermission> ListAll()
        {
            return _DefaultPersister.ListAll(); 
        }

    }
    
    public partial interface ISecurityPermissionPersister
    {
        int Retrieve(SecurityPermission securityPermission);
        int Update(SecurityPermission securityPermission);
        int Delete(SecurityPermission securityPermission);
        int Insert(SecurityPermission securityPermission);
        IReader<SecurityPermission> ListAll();
    }
    
    public partial class SqlServerSecurityPermissionPersister : SqlPersisterBase, ISecurityPermissionPersister
    {
        public SqlServerSecurityPermissionPersister()
        {
        }

        public SqlServerSecurityPermissionPersister(string connectionString) : base(connectionString)
        {
        }

        public SqlServerSecurityPermissionPersister(SqlConnection connection) : base(connection)
        {
        }

        public SqlServerSecurityPermissionPersister(SqlTransaction transaction) : base(transaction)
        {
        }

        public int Retrieve(SecurityPermission securityPermission)
        {
            int __rowsAffected = 1;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("SecurityPermissionGet"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Add command parameters
                    SqlParameter vSPId = new SqlParameter("@SPId", SqlDbType.Int);
                    vSPId.Direction = ParameterDirection.InputOutput; 
                    sqlCommand.Parameters.Add(vSPId);
                    SqlParameter vCompId = new SqlParameter("@CompId", SqlDbType.Int);
                    vCompId.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vCompId);
                    SqlParameter vSchemes = new SqlParameter("@Schemes", SqlDbType.VarChar, 100);
                    vSchemes.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vSchemes);
                    SqlParameter vUserCount = new SqlParameter("@UserCount", SqlDbType.Int);
                    vUserCount.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vUserCount);
                    SqlParameter vStaffCount = new SqlParameter("@StaffCount", SqlDbType.Int);
                    vStaffCount.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vStaffCount);
                    SqlParameter vWebSpace = new SqlParameter("@WebSpace", SqlDbType.VarChar, 100);
                    vWebSpace.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vWebSpace);
                    SqlParameter vDayCount = new SqlParameter("@DayCount", SqlDbType.Int);
                    vDayCount.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vDayCount);
                    SqlParameter vPrice = new SqlParameter("@Price", SqlDbType.Money);
                    vPrice.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vPrice);
                    SqlParameter vVersion = new SqlParameter("@Version", SqlDbType.VarChar, 100);
                    vVersion.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vVersion);

                    // Set input parameter values
                    SqlServerHelper.SetParameterValue(vSPId, securityPermission.SPId);

                    // Execute command
                    sqlCommand.ExecuteNonQuery();

                    try
                    {
                        // Get output parameter values
                        securityPermission.SPId = SqlServerHelper.ToInt32(vSPId); 
                        securityPermission.CompId = SqlServerHelper.ToNullableInt32(vCompId); 
                        securityPermission.Schemes = SqlServerHelper.ToString(vSchemes); 
                        securityPermission.UserCount = SqlServerHelper.ToNullableInt32(vUserCount); 
                        securityPermission.StaffCount = SqlServerHelper.ToNullableInt32(vStaffCount); 
                        securityPermission.WebSpace = SqlServerHelper.ToString(vWebSpace); 
                        securityPermission.DayCount = SqlServerHelper.ToNullableInt32(vDayCount); 
                        securityPermission.Price = SqlServerHelper.ToNullableDecimal(vPrice); 
                        securityPermission.Version = SqlServerHelper.ToString(vVersion); 

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

        public int Update(SecurityPermission securityPermission)
        {
            int __rowsAffected = 0;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("SecurityPermissionUpdate"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Add command parameters
                SqlParameter vSPId = new SqlParameter("@SPId", SqlDbType.Int);
                vSPId.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vSPId);
                SqlParameter vCompId = new SqlParameter("@CompId", SqlDbType.Int);
                vCompId.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vCompId);
                SqlParameter vSchemes = new SqlParameter("@Schemes", SqlDbType.VarChar, 100);
                vSchemes.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vSchemes);
                SqlParameter vUserCount = new SqlParameter("@UserCount", SqlDbType.Int);
                vUserCount.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vUserCount);
                SqlParameter vStaffCount = new SqlParameter("@StaffCount", SqlDbType.Int);
                vStaffCount.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vStaffCount);
                SqlParameter vWebSpace = new SqlParameter("@WebSpace", SqlDbType.VarChar, 100);
                vWebSpace.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vWebSpace);
                SqlParameter vDayCount = new SqlParameter("@DayCount", SqlDbType.Int);
                vDayCount.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vDayCount);
                SqlParameter vPrice = new SqlParameter("@Price", SqlDbType.Money);
                vPrice.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vPrice);
                SqlParameter vVersion = new SqlParameter("@Version", SqlDbType.VarChar, 100);
                vVersion.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vVersion);

                // Set input parameter values
                SqlServerHelper.SetParameterValue(vSPId, securityPermission.SPId);
                SqlServerHelper.SetParameterValue(vCompId, securityPermission.CompId);
                SqlServerHelper.SetParameterValue(vSchemes, securityPermission.Schemes);
                SqlServerHelper.SetParameterValue(vUserCount, securityPermission.UserCount);
                SqlServerHelper.SetParameterValue(vStaffCount, securityPermission.StaffCount);
                SqlServerHelper.SetParameterValue(vWebSpace, securityPermission.WebSpace);
                SqlServerHelper.SetParameterValue(vDayCount, securityPermission.DayCount);
                SqlServerHelper.SetParameterValue(vPrice, securityPermission.Price);
                SqlServerHelper.SetParameterValue(vVersion, securityPermission.Version);

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

        public int Delete(SecurityPermission securityPermission)
        {
            int __rowsAffected = 0;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("SecurityPermissionDelete"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Add command parameters
                    SqlParameter vSPId = new SqlParameter("@SPId", SqlDbType.Int);
                    vSPId.Direction = ParameterDirection.Input; 
                    sqlCommand.Parameters.Add(vSPId);

                    // Set input parameter values
                    SqlServerHelper.SetParameterValue(vSPId, securityPermission.SPId);

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

        public int Insert(SecurityPermission securityPermission)
        {
            int __rowsAffected = 0;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("SecurityPermissionInsert"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Add command parameters
                SqlParameter vSPId = new SqlParameter("@SPId", SqlDbType.Int);
                vSPId.Direction = ParameterDirection.InputOutput; 
                sqlCommand.Parameters.Add(vSPId);
                SqlParameter vCompId = new SqlParameter("@CompId", SqlDbType.Int);
                vCompId.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vCompId);
                SqlParameter vSchemes = new SqlParameter("@Schemes", SqlDbType.VarChar, 100);
                vSchemes.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vSchemes);
                SqlParameter vUserCount = new SqlParameter("@UserCount", SqlDbType.Int);
                vUserCount.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vUserCount);
                SqlParameter vStaffCount = new SqlParameter("@StaffCount", SqlDbType.Int);
                vStaffCount.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vStaffCount);
                SqlParameter vWebSpace = new SqlParameter("@WebSpace", SqlDbType.VarChar, 100);
                vWebSpace.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vWebSpace);
                SqlParameter vDayCount = new SqlParameter("@DayCount", SqlDbType.Int);
                vDayCount.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vDayCount);
                SqlParameter vPrice = new SqlParameter("@Price", SqlDbType.Money);
                vPrice.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vPrice);
                SqlParameter vVersion = new SqlParameter("@Version", SqlDbType.VarChar, 100);
                vVersion.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vVersion);

                // Set input parameter values
                SqlServerHelper.SetParameterValue(
                    vSPId, 
                    securityPermission.SPId, 
                    0);
                SqlServerHelper.SetParameterValue(vCompId, securityPermission.CompId);
                SqlServerHelper.SetParameterValue(vSchemes, securityPermission.Schemes);
                SqlServerHelper.SetParameterValue(vUserCount, securityPermission.UserCount);
                SqlServerHelper.SetParameterValue(vStaffCount, securityPermission.StaffCount);
                SqlServerHelper.SetParameterValue(vWebSpace, securityPermission.WebSpace);
                SqlServerHelper.SetParameterValue(vDayCount, securityPermission.DayCount);
                SqlServerHelper.SetParameterValue(vPrice, securityPermission.Price);
                SqlServerHelper.SetParameterValue(vVersion, securityPermission.Version);

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
                    securityPermission.SPId = SqlServerHelper.ToInt32(vSPId); 

                }
                finally
                {
                    // Detach command
                    DetachCommand(sqlCommand);
                }

            }
            
            return __rowsAffected; 
        }

        public IReader<SecurityPermission> ListAll()
        {
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("SecurityPermissionListAll"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Execute command
                SqlDataReader reader = sqlCommand.ExecuteReader(AttachReaderCommand(sqlCommand));

                // Return reader
                return new SqlServerSecurityPermissionReader(reader); 
            }
        }

    }

    public partial class SqlServerSecurityPermissionReader : IReader<SecurityPermission>
    {
        private SqlDataReader sqlDataReader;

        private SecurityPermission _SecurityPermission;

        private int _SPIdOrdinal = -1;
        private int _CompIdOrdinal = -1;
        private int _SchemesOrdinal = -1;
        private int _UserCountOrdinal = -1;
        private int _StaffCountOrdinal = -1;
        private int _WebSpaceOrdinal = -1;
        private int _DayCountOrdinal = -1;
        private int _PriceOrdinal = -1;
        private int _VersionOrdinal = -1;

        public SqlServerSecurityPermissionReader(SqlDataReader sqlDataReader)
        {
            this.sqlDataReader = sqlDataReader; 
            for (int  i = 0; i < sqlDataReader.FieldCount; i++)
            {
                string columnName = sqlDataReader.GetName(i);
                columnName = columnName.ToUpper(); 
                switch (columnName)
                {
                    case "SPID":
                        _SPIdOrdinal = i; 
                        break;
                    
                    case "COMPID":
                        _CompIdOrdinal = i; 
                        break;
                    
                    case "SCHEMES":
                        _SchemesOrdinal = i; 
                        break;
                    
                    case "USERCOUNT":
                        _UserCountOrdinal = i; 
                        break;
                    
                    case "STAFFCOUNT":
                        _StaffCountOrdinal = i; 
                        break;
                    
                    case "WEBSPACE":
                        _WebSpaceOrdinal = i; 
                        break;
                    
                    case "DAYCOUNT":
                        _DayCountOrdinal = i; 
                        break;
                    
                    case "PRICE":
                        _PriceOrdinal = i; 
                        break;
                    
                    case "VERSION":
                        _VersionOrdinal = i; 
                        break;
                    
                }
            }
        }

        #region IReader<SecurityPermission> Implementation
        
        public bool Read()
        {
            _SecurityPermission = null; 
            return this.sqlDataReader.Read(); 
        }

        public SecurityPermission Current
        {
            get
            {
                if(_SecurityPermission == null)
                {
                    _SecurityPermission = new SecurityPermission();
                    if(_SPIdOrdinal != -1)
                    {
                        _SecurityPermission.SPId = SqlServerHelper.ToInt32(sqlDataReader, _SPIdOrdinal); 
                    }
                    _SecurityPermission.CompId = SqlServerHelper.ToNullableInt32(sqlDataReader, _CompIdOrdinal); 
                    _SecurityPermission.Schemes = SqlServerHelper.ToString(sqlDataReader, _SchemesOrdinal); 
                    _SecurityPermission.UserCount = SqlServerHelper.ToNullableInt32(sqlDataReader, _UserCountOrdinal); 
                    _SecurityPermission.StaffCount = SqlServerHelper.ToNullableInt32(sqlDataReader, _StaffCountOrdinal); 
                    _SecurityPermission.WebSpace = SqlServerHelper.ToString(sqlDataReader, _WebSpaceOrdinal); 
                    _SecurityPermission.DayCount = SqlServerHelper.ToNullableInt32(sqlDataReader, _DayCountOrdinal); 
                    _SecurityPermission.Price = SqlServerHelper.ToNullableDecimal(sqlDataReader, _PriceOrdinal); 
                    _SecurityPermission.Version = SqlServerHelper.ToString(sqlDataReader, _VersionOrdinal); 
                }
                

                return _SecurityPermission; 
            }
        }

        public void Close()
        {
            sqlDataReader.Close();
        }

        public List<SecurityPermission> ToList()
        {
            List<SecurityPermission> list = new List<SecurityPermission>();
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
        
        #region IEnumerable<SecurityPermission> Implementation
        
        public IEnumerator<SecurityPermission> GetEnumerator()
        {
            return new SecurityPermissionEnumerator(this); 
        }

        #endregion
        
        #region IEnumerable Implementation
        
        IEnumerator IEnumerable.GetEnumerator()
        {
            return new SecurityPermissionEnumerator(this); 
        }

        #endregion
        
        
        private partial class SecurityPermissionEnumerator : IEnumerator<SecurityPermission>
        {
            private IReader<SecurityPermission> securityPermissionReader;

            public SecurityPermissionEnumerator(IReader<SecurityPermission> securityPermissionReader)
            {
                this.securityPermissionReader = securityPermissionReader; 
            }

            #region IEnumerator<SecurityPermission> Members
            
            public SecurityPermission Current
            {
                get { return this.securityPermissionReader.Current; }
            }

            #endregion
            
            #region IDisposable Members
            
            public void Dispose()
            {
                this.securityPermissionReader.Dispose();
            }

            #endregion
            
            #region IEnumerator Members
            
            object IEnumerator.Current
            {
                get { return this.securityPermissionReader.Current; }
            }

            public bool MoveNext()
            {
                return this.securityPermissionReader.Read(); 
            }

            public void Reset()
            {
                throw new Exception("Reset of securitypermission reader is not supported."); 
            }

            #endregion
            
        }
    }
}
