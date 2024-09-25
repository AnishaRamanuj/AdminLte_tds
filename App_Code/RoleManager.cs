
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.IO;

namespace JTMSProject
{
    public partial class RoleManager
    {
        private static IRoleManagerPersister _DefaultPersister;
        private IRoleManagerPersister _Persister;
        private int _RoleID;
        private string _RoleName;
        private DateTime _ModifiedDate;

        static RoleManager()
        {
            // Assign default persister
            _DefaultPersister = new SqlServerRoleManagerPersister();
        }

        public RoleManager()
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister; 
        }

        public RoleManager(int _RoleID)
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister; 

            // Assign method parameter to private fields
            this._RoleID = _RoleID; 

            // Call associated retrieve method
            Retrieve();
        }

        public RoleManager(DataRow row)
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister; 

            // Assign column values to private members
            for (int  i = 0; i < row.Table.Columns.Count; i++)
            {
                switch (row.Table.Columns[i].ColumnName.ToUpper())
                {
                    case "ROLEID":
                        this.RoleID = Convert.ToInt32(row[i, DataRowVersion.Current]); 
                        break;
                    
                    case "ROLENAME":
                        if(row.IsNull(i) == false)
                        {
                            this.RoleName = (string)row[i, DataRowVersion.Current]; 
                        }
                        break;
                    
                    case "MODIFIEDDATE":
                        this.ModifiedDate = Convert.ToDateTime(row[i, DataRowVersion.Current]); 
                        break;
                    
                }
            }
        }

        public static IRoleManagerPersister DefaultPersister
        {
            get { return _DefaultPersister; }
            set { _DefaultPersister = value; }
        }

        public IRoleManagerPersister Persister
        {
            get { return _Persister; }
            set { _Persister = value; }
        }

        public int RoleID
        {
            get { return _RoleID; }
            set { _RoleID = value; }
        }

        public string RoleName
        {
            get { return _RoleName; }
            set { _RoleName = value; }
        }

        public DateTime ModifiedDate
        {
            get { return _ModifiedDate; }
            set { _ModifiedDate = value; }
        }

        public virtual void Clone(RoleManager sourceObject)
        {
            // Clone attributes from source object
            this._RoleID = sourceObject.RoleID; 
            this._RoleName = sourceObject.RoleName; 
            this._ModifiedDate = sourceObject.ModifiedDate; 
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

        public static IReader<RoleManager> ListAll()
        {
            return _DefaultPersister.ListAll(); 
        }

    }
    
    public partial interface IRoleManagerPersister
    {
        int Retrieve(RoleManager roleManager);
        int Update(RoleManager roleManager);
        int Delete(RoleManager roleManager);
        int Insert(RoleManager roleManager);
        IReader<RoleManager> ListAll();
    }
    
    public partial class SqlServerRoleManagerPersister : SqlPersisterBase, IRoleManagerPersister
    {
        public SqlServerRoleManagerPersister()
        {
        }

        public SqlServerRoleManagerPersister(string connectionString) : base(connectionString)
        {
        }

        public SqlServerRoleManagerPersister(SqlConnection connection) : base(connection)
        {
        }

        public SqlServerRoleManagerPersister(SqlTransaction transaction) : base(transaction)
        {
        }

        public int Retrieve(RoleManager roleManager)
        {
            int __rowsAffected = 1;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("RoleManagerGet"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Add command parameters
                    SqlParameter vRoleID = new SqlParameter("@RoleID", SqlDbType.Int);
                    vRoleID.Direction = ParameterDirection.InputOutput; 
                    sqlCommand.Parameters.Add(vRoleID);
                    SqlParameter vRoleName = new SqlParameter("@RoleName", SqlDbType.VarChar, 50);
                    vRoleName.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vRoleName);
                    SqlParameter vModifiedDate = new SqlParameter("@ModifiedDate", SqlDbType.DateTime);
                    vModifiedDate.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vModifiedDate);

                    // Set input parameter values
                    SqlServerHelper.SetParameterValue(vRoleID, roleManager.RoleID);

                    // Execute command
                    sqlCommand.ExecuteNonQuery();

                    try
                    {
                        // Get output parameter values
                        roleManager.RoleID = SqlServerHelper.ToInt32(vRoleID); 
                        roleManager.RoleName = SqlServerHelper.ToString(vRoleName); 
                        roleManager.ModifiedDate = SqlServerHelper.ToDateTime(vModifiedDate); 

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

        public int Update(RoleManager roleManager)
        {
            int __rowsAffected = 0;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("RoleManagerUpdate"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Add command parameters
                SqlParameter vRoleID = new SqlParameter("@RoleID", SqlDbType.Int);
                vRoleID.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vRoleID);
                SqlParameter vRoleName = new SqlParameter("@RoleName", SqlDbType.VarChar, 50);
                vRoleName.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vRoleName);
                SqlParameter vModifiedDate = new SqlParameter("@ModifiedDate", SqlDbType.DateTime);
                vModifiedDate.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vModifiedDate);

                // Set input parameter values
                SqlServerHelper.SetParameterValue(vRoleID, roleManager.RoleID);
                SqlServerHelper.SetParameterValue(vRoleName, roleManager.RoleName);
                SqlServerHelper.SetParameterValue(vModifiedDate, roleManager.ModifiedDate);

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

        public int Delete(RoleManager roleManager)
        {
            int __rowsAffected = 0;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("RoleManagerDelete"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Add command parameters
                    SqlParameter vRoleID = new SqlParameter("@RoleID", SqlDbType.Int);
                    vRoleID.Direction = ParameterDirection.Input; 
                    sqlCommand.Parameters.Add(vRoleID);

                    // Set input parameter values
                    SqlServerHelper.SetParameterValue(vRoleID, roleManager.RoleID);

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

        public int Insert(RoleManager roleManager)
        {
            int __rowsAffected = 0;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("RoleManagerInsert"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Add command parameters
                SqlParameter vRoleID = new SqlParameter("@RoleID", SqlDbType.Int);
                vRoleID.Direction = ParameterDirection.InputOutput; 
                sqlCommand.Parameters.Add(vRoleID);
                SqlParameter vRoleName = new SqlParameter("@RoleName", SqlDbType.VarChar, 50);
                vRoleName.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vRoleName);
                SqlParameter vModifiedDate = new SqlParameter("@ModifiedDate", SqlDbType.DateTime);
                vModifiedDate.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vModifiedDate);

                // Set input parameter values
                SqlServerHelper.SetParameterValue(
                    vRoleID, 
                    roleManager.RoleID, 
                    0);
                SqlServerHelper.SetParameterValue(vRoleName, roleManager.RoleName);
                SqlServerHelper.SetParameterValue(vModifiedDate, roleManager.ModifiedDate);

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
                    roleManager.RoleID = SqlServerHelper.ToInt32(vRoleID); 

                }
                finally
                {
                    // Detach command
                    DetachCommand(sqlCommand);
                }

            }
            
            return __rowsAffected; 
        }

        public IReader<RoleManager> ListAll()
        {
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("RoleManagerListAll"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Execute command
                SqlDataReader reader = sqlCommand.ExecuteReader(AttachReaderCommand(sqlCommand));

                // Return reader
                return new SqlServerRoleManagerReader(reader); 
            }
        }

    }

    public partial class SqlServerRoleManagerReader : IReader<RoleManager>
    {
        private SqlDataReader sqlDataReader;

        private RoleManager _RoleManager;

        private int _RoleIDOrdinal = -1;
        private int _RoleNameOrdinal = -1;
        private int _ModifiedDateOrdinal = -1;

        public SqlServerRoleManagerReader(SqlDataReader sqlDataReader)
        {
            this.sqlDataReader = sqlDataReader; 
            for (int  i = 0; i < sqlDataReader.FieldCount; i++)
            {
                string columnName = sqlDataReader.GetName(i);
                columnName = columnName.ToUpper(); 
                switch (columnName)
                {
                    case "ROLEID":
                        _RoleIDOrdinal = i; 
                        break;
                    
                    case "ROLENAME":
                        _RoleNameOrdinal = i; 
                        break;
                    
                    case "MODIFIEDDATE":
                        _ModifiedDateOrdinal = i; 
                        break;
                    
                }
            }
        }

        #region IReader<RoleManager> Implementation
        
        public bool Read()
        {
            _RoleManager = null; 
            return this.sqlDataReader.Read(); 
        }

        public RoleManager Current
        {
            get
            {
                if(_RoleManager == null)
                {
                    _RoleManager = new RoleManager();
                    if(_RoleIDOrdinal != -1)
                    {
                        _RoleManager.RoleID = SqlServerHelper.ToInt32(sqlDataReader, _RoleIDOrdinal); 
                    }
                    _RoleManager.RoleName = SqlServerHelper.ToString(sqlDataReader, _RoleNameOrdinal); 
                    if(_ModifiedDateOrdinal != -1)
                    {
                        _RoleManager.ModifiedDate = SqlServerHelper.ToDateTime(sqlDataReader, _ModifiedDateOrdinal); 
                    }
                }
                

                return _RoleManager; 
            }
        }

        public void Close()
        {
            sqlDataReader.Close();
        }

        public List<RoleManager> ToList()
        {
            List<RoleManager> list = new List<RoleManager>();
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
        
        #region IEnumerable<RoleManager> Implementation
        
        public IEnumerator<RoleManager> GetEnumerator()
        {
            return new RoleManagerEnumerator(this); 
        }

        #endregion
        
        #region IEnumerable Implementation
        
        IEnumerator IEnumerable.GetEnumerator()
        {
            return new RoleManagerEnumerator(this); 
        }

        #endregion
        
        
        private partial class RoleManagerEnumerator : IEnumerator<RoleManager>
        {
            private IReader<RoleManager> roleManagerReader;

            public RoleManagerEnumerator(IReader<RoleManager> roleManagerReader)
            {
                this.roleManagerReader = roleManagerReader; 
            }

            #region IEnumerator<RoleManager> Members
            
            public RoleManager Current
            {
                get { return this.roleManagerReader.Current; }
            }

            #endregion
            
            #region IDisposable Members
            
            public void Dispose()
            {
                this.roleManagerReader.Dispose();
            }

            #endregion
            
            #region IEnumerator Members
            
            object IEnumerator.Current
            {
                get { return this.roleManagerReader.Current; }
            }

            public bool MoveNext()
            {
                return this.roleManagerReader.Read(); 
            }

            public void Reset()
            {
                throw new Exception("Reset of rolemanager reader is not supported."); 
            }

            #endregion
            
        }
    }
}
