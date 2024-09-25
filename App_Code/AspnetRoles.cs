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
    public partial class AspnetRoles
    {
        private static IAspnetRolesPersister _DefaultPersister;
        private IAspnetRolesPersister _Persister;
        private Guid _ApplicationId;
        private Guid _RoleId;
        private string _RoleName;
        private string _LoweredRoleName;
        private string _Description;

        static AspnetRoles()
        {
            // Assign default persister
            _DefaultPersister = new SqlServerAspnetRolesPersister();
        }

        public AspnetRoles()
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister; 
        }

        public AspnetRoles(Guid _RoleId)
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister; 

            // Assign method parameter to private fields
            this._RoleId = _RoleId; 

            // Call associated retrieve method
            Retrieve();
        }

        public AspnetRoles(Guid _ApplicationId, string _LoweredRoleName)
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister; 

            // Assign method parameter to private fields
            this._ApplicationId = _ApplicationId; 
            this._LoweredRoleName = _LoweredRoleName; 

            // Call associated retrieve method
            RetrieveByAspnetRoles();
        }

        public AspnetRoles(DataRow row)
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister; 

            // Assign column values to private members
            for (int  i = 0; i < row.Table.Columns.Count; i++)
            {
                switch (row.Table.Columns[i].ColumnName.ToUpper())
                {
                    case "APPLICATIONID":
                        if(row[i, DataRowVersion.Current] is Guid)
                        {
                            this.ApplicationId = (Guid)row[i, DataRowVersion.Current]; 
                        }
                        else
                        {
                            this.ApplicationId = new Guid((Byte[])row[i, DataRowVersion.Current]); 
                        }
                        break;
                    
                    case "ROLEID":
                        if(row[i, DataRowVersion.Current] is Guid)
                        {
                            this.RoleId = (Guid)row[i, DataRowVersion.Current]; 
                        }
                        else
                        {
                            this.RoleId = new Guid((Byte[])row[i, DataRowVersion.Current]); 
                        }
                        break;
                    
                    case "ROLENAME":
                        this.RoleName = (string)row[i, DataRowVersion.Current]; 
                        break;
                    
                    case "LOWEREDROLENAME":
                        this.LoweredRoleName = (string)row[i, DataRowVersion.Current]; 
                        break;
                    
                    case "DESCRIPTION":
                        if(row.IsNull(i) == false)
                        {
                            this.Description = (string)row[i, DataRowVersion.Current]; 
                        }
                        break;
                    
                }
            }
        }

        public static IAspnetRolesPersister DefaultPersister
        {
            get { return _DefaultPersister; }
            set { _DefaultPersister = value; }
        }

        public IAspnetRolesPersister Persister
        {
            get { return _Persister; }
            set { _Persister = value; }
        }

        public Guid ApplicationId
        {
            get { return _ApplicationId; }
            set { _ApplicationId = value; }
        }

        public Guid RoleId
        {
            get { return _RoleId; }
            set { _RoleId = value; }
        }

        public string RoleName
        {
            get { return _RoleName; }
            set { _RoleName = value; }
        }

        public string LoweredRoleName
        {
            get { return _LoweredRoleName; }
            set { _LoweredRoleName = value; }
        }

        public string Description
        {
            get { return _Description; }
            set { _Description = value; }
        }

        public virtual void Clone(AspnetRoles sourceObject)
        {
            // Clone attributes from source object
            this._ApplicationId = sourceObject.ApplicationId; 
            this._RoleId = sourceObject.RoleId; 
            this._RoleName = sourceObject.RoleName; 
            this._LoweredRoleName = sourceObject.LoweredRoleName; 
            this._Description = sourceObject.Description; 
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

        public static IReader<AspnetRoles> ListAll()
        {
            return _DefaultPersister.ListAll(); 
        }

        public static IReader<AspnetRoles> ListForApplicationId(Guid applicationId)
        {
            return _DefaultPersister.ListForApplicationId(applicationId); 
        }

        public virtual int RetrieveByAspnetRoles()
        {
            return _Persister.RetrieveByAspnetRoles(this); 
        }

    }
    
    public partial interface IAspnetRolesPersister
    {
        int Retrieve(AspnetRoles aspnetRoles);
        int Update(AspnetRoles aspnetRoles);
        int Delete(AspnetRoles aspnetRoles);
        int Insert(AspnetRoles aspnetRoles);
        IReader<AspnetRoles> ListAll();
        IReader<AspnetRoles> ListForApplicationId(Guid applicationId);
        int RetrieveByAspnetRoles(AspnetRoles aspnetRoles);
    }
    
    public partial class SqlServerAspnetRolesPersister : SqlPersisterBase, IAspnetRolesPersister
    {
        public SqlServerAspnetRolesPersister()
        {
        }

        public SqlServerAspnetRolesPersister(string connectionString) : base(connectionString)
        {
        }

        public SqlServerAspnetRolesPersister(SqlConnection connection) : base(connection)
        {
        }

        public SqlServerAspnetRolesPersister(SqlTransaction transaction) : base(transaction)
        {
        }

        public int Retrieve(AspnetRoles aspnetRoles)
        {
            int __rowsAffected = 1;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("AspnetRolesGet"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Add command parameters
                    SqlParameter vApplicationId = new SqlParameter("@ApplicationId", SqlDbType.UniqueIdentifier);
                    vApplicationId.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vApplicationId);
                    SqlParameter vRoleId = new SqlParameter("@RoleId", SqlDbType.UniqueIdentifier);
                    vRoleId.Direction = ParameterDirection.InputOutput; 
                    sqlCommand.Parameters.Add(vRoleId);
                    SqlParameter vRoleName = new SqlParameter("@RoleName", SqlDbType.NVarChar, 256);
                    vRoleName.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vRoleName);
                    SqlParameter vLoweredRoleName = new SqlParameter("@LoweredRoleName", SqlDbType.NVarChar, 256);
                    vLoweredRoleName.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vLoweredRoleName);
                    SqlParameter vDescription = new SqlParameter("@Description", SqlDbType.NVarChar, 256);
                    vDescription.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vDescription);

                    // Set input parameter values
                    SqlServerHelper.SetParameterValue(vRoleId, aspnetRoles.RoleId);

                    // Execute command
                    sqlCommand.ExecuteNonQuery();

                    try
                    {
                        // Get output parameter values
                        aspnetRoles.ApplicationId = SqlServerHelper.ToGuid(vApplicationId); 
                        aspnetRoles.RoleId = SqlServerHelper.ToGuid(vRoleId); 
                        aspnetRoles.RoleName = SqlServerHelper.ToString(vRoleName); 
                        aspnetRoles.LoweredRoleName = SqlServerHelper.ToString(vLoweredRoleName); 
                        aspnetRoles.Description = SqlServerHelper.ToString(vDescription); 

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

        public int Update(AspnetRoles aspnetRoles)
        {
            int __rowsAffected = 0;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("AspnetRolesUpdate"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Add command parameters
                SqlParameter vApplicationId = new SqlParameter("@ApplicationId", SqlDbType.UniqueIdentifier);
                vApplicationId.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vApplicationId);
                SqlParameter vRoleId = new SqlParameter("@RoleId", SqlDbType.UniqueIdentifier);
                vRoleId.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vRoleId);
                SqlParameter vRoleName = new SqlParameter("@RoleName", SqlDbType.NVarChar, 256);
                vRoleName.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vRoleName);
                SqlParameter vLoweredRoleName = new SqlParameter("@LoweredRoleName", SqlDbType.NVarChar, 256);
                vLoweredRoleName.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vLoweredRoleName);
                SqlParameter vDescription = new SqlParameter("@Description", SqlDbType.NVarChar, 256);
                vDescription.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vDescription);

                // Set input parameter values
                SqlServerHelper.SetParameterValue(vApplicationId, aspnetRoles.ApplicationId);
                SqlServerHelper.SetParameterValue(vRoleId, aspnetRoles.RoleId);
                SqlServerHelper.SetParameterValue(vRoleName, aspnetRoles.RoleName);
                SqlServerHelper.SetParameterValue(vLoweredRoleName, aspnetRoles.LoweredRoleName);
                SqlServerHelper.SetParameterValue(vDescription, aspnetRoles.Description);

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

        public int Delete(AspnetRoles aspnetRoles)
        {
            int __rowsAffected = 0;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("AspnetRolesDelete"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Add command parameters
                    SqlParameter vRoleId = new SqlParameter("@RoleId", SqlDbType.UniqueIdentifier);
                    vRoleId.Direction = ParameterDirection.Input; 
                    sqlCommand.Parameters.Add(vRoleId);

                    // Set input parameter values
                    SqlServerHelper.SetParameterValue(vRoleId, aspnetRoles.RoleId);

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

        public int Insert(AspnetRoles aspnetRoles)
        {
            int __rowsAffected = 0;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("AspnetRolesInsert"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Add command parameters
                SqlParameter vApplicationId = new SqlParameter("@ApplicationId", SqlDbType.UniqueIdentifier);
                vApplicationId.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vApplicationId);
                SqlParameter vRoleId = new SqlParameter("@RoleId", SqlDbType.UniqueIdentifier);
                vRoleId.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vRoleId);
                SqlParameter vRoleName = new SqlParameter("@RoleName", SqlDbType.NVarChar, 256);
                vRoleName.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vRoleName);
                SqlParameter vLoweredRoleName = new SqlParameter("@LoweredRoleName", SqlDbType.NVarChar, 256);
                vLoweredRoleName.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vLoweredRoleName);
                SqlParameter vDescription = new SqlParameter("@Description", SqlDbType.NVarChar, 256);
                vDescription.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vDescription);

                // Set input parameter values
                SqlServerHelper.SetParameterValue(vApplicationId, aspnetRoles.ApplicationId);
                SqlServerHelper.SetParameterValue(vRoleId, aspnetRoles.RoleId);
                SqlServerHelper.SetParameterValue(vRoleName, aspnetRoles.RoleName);
                SqlServerHelper.SetParameterValue(vLoweredRoleName, aspnetRoles.LoweredRoleName);
                SqlServerHelper.SetParameterValue(vDescription, aspnetRoles.Description);

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

        public IReader<AspnetRoles> ListAll()
        {
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("AspnetRolesListAll"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Execute command
                SqlDataReader reader = sqlCommand.ExecuteReader(AttachReaderCommand(sqlCommand));

                // Return reader
                return new SqlServerAspnetRolesReader(reader); 
            }
        }

        public IReader<AspnetRoles> ListForApplicationId(Guid applicationId)
        {
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("AspnetRolesListForApplicationId"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Add command parameters
                SqlParameter vApplicationId = new SqlParameter("@ApplicationId", SqlDbType.UniqueIdentifier);
                vApplicationId.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vApplicationId);
                
                // Set input parameter values
                SqlServerHelper.SetParameterValue(vApplicationId, applicationId);

                // Execute command
                SqlDataReader reader = sqlCommand.ExecuteReader(AttachReaderCommand(sqlCommand));

                // Return reader
                return new SqlServerAspnetRolesReader(reader); 
            }
        }

        public int RetrieveByAspnetRoles(AspnetRoles aspnetRoles)
        {
            int __rowsAffected = 1;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("AspnetRolesGetByAspnetRolesIndex1"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Add command parameters
                    SqlParameter vApplicationId = new SqlParameter("@ApplicationId", SqlDbType.UniqueIdentifier);
                    vApplicationId.Direction = ParameterDirection.InputOutput; 
                    sqlCommand.Parameters.Add(vApplicationId);
                    SqlParameter vRoleId = new SqlParameter("@RoleId", SqlDbType.UniqueIdentifier);
                    vRoleId.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vRoleId);
                    SqlParameter vRoleName = new SqlParameter("@RoleName", SqlDbType.NVarChar, 256);
                    vRoleName.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vRoleName);
                    SqlParameter vLoweredRoleName = new SqlParameter("@LoweredRoleName", SqlDbType.NVarChar, 256);
                    vLoweredRoleName.Direction = ParameterDirection.InputOutput; 
                    sqlCommand.Parameters.Add(vLoweredRoleName);
                    SqlParameter vDescription = new SqlParameter("@Description", SqlDbType.NVarChar, 256);
                    vDescription.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vDescription);

                    // Set input parameter values
                    SqlServerHelper.SetParameterValue(vApplicationId, aspnetRoles.ApplicationId);
                    SqlServerHelper.SetParameterValue(vLoweredRoleName, aspnetRoles.LoweredRoleName);

                    // Execute command
                    sqlCommand.ExecuteNonQuery();

                    try
                    {
                        // Get output parameter values
                        aspnetRoles.ApplicationId = SqlServerHelper.ToGuid(vApplicationId); 
                        aspnetRoles.RoleId = SqlServerHelper.ToGuid(vRoleId); 
                        aspnetRoles.RoleName = SqlServerHelper.ToString(vRoleName); 
                        aspnetRoles.LoweredRoleName = SqlServerHelper.ToString(vLoweredRoleName); 
                        aspnetRoles.Description = SqlServerHelper.ToString(vDescription); 

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

    }

    public partial class SqlServerAspnetRolesReader : IReader<AspnetRoles>
    {
        private SqlDataReader sqlDataReader;

        private AspnetRoles _AspnetRoles;

        private int _ApplicationIdOrdinal = -1;
        private int _RoleIdOrdinal = -1;
        private int _RoleNameOrdinal = -1;
        private int _LoweredRoleNameOrdinal = -1;
        private int _DescriptionOrdinal = -1;

        public SqlServerAspnetRolesReader(SqlDataReader sqlDataReader)
        {
            this.sqlDataReader = sqlDataReader; 
            for (int  i = 0; i < sqlDataReader.FieldCount; i++)
            {
                string columnName = sqlDataReader.GetName(i);
                columnName = columnName.ToUpper(); 
                switch (columnName)
                {
                    case "APPLICATIONID":
                        _ApplicationIdOrdinal = i; 
                        break;
                    
                    case "ROLEID":
                        _RoleIdOrdinal = i; 
                        break;
                    
                    case "ROLENAME":
                        _RoleNameOrdinal = i; 
                        break;
                    
                    case "LOWEREDROLENAME":
                        _LoweredRoleNameOrdinal = i; 
                        break;
                    
                    case "DESCRIPTION":
                        _DescriptionOrdinal = i; 
                        break;
                    
                }
            }
        }

        #region IReader<AspnetRoles> Implementation
        
        public bool Read()
        {
            _AspnetRoles = null; 
            return this.sqlDataReader.Read(); 
        }

        public AspnetRoles Current
        {
            get
            {
                if(_AspnetRoles == null)
                {
                    _AspnetRoles = new AspnetRoles();
                    if(_ApplicationIdOrdinal != -1)
                    {
                        _AspnetRoles.ApplicationId = SqlServerHelper.ToGuid(sqlDataReader, _ApplicationIdOrdinal); 
                    }
                    if(_RoleIdOrdinal != -1)
                    {
                        _AspnetRoles.RoleId = SqlServerHelper.ToGuid(sqlDataReader, _RoleIdOrdinal); 
                    }
                    _AspnetRoles.RoleName = SqlServerHelper.ToString(sqlDataReader, _RoleNameOrdinal); 
                    _AspnetRoles.LoweredRoleName = SqlServerHelper.ToString(sqlDataReader, _LoweredRoleNameOrdinal); 
                    _AspnetRoles.Description = SqlServerHelper.ToString(sqlDataReader, _DescriptionOrdinal); 
                }
                

                return _AspnetRoles; 
            }
        }

        public void Close()
        {
            sqlDataReader.Close();
        }

        public List<AspnetRoles> ToList()
        {
            List<AspnetRoles> list = new List<AspnetRoles>();
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
        
        #region IEnumerable<AspnetRoles> Implementation
        
        public IEnumerator<AspnetRoles> GetEnumerator()
        {
            return new AspnetRolesEnumerator(this); 
        }

        #endregion
        
        #region IEnumerable Implementation
        
        IEnumerator IEnumerable.GetEnumerator()
        {
            return new AspnetRolesEnumerator(this); 
        }

        #endregion
        
        
        private partial class AspnetRolesEnumerator : IEnumerator<AspnetRoles>
        {
            private IReader<AspnetRoles> aspnetRolesReader;

            public AspnetRolesEnumerator(IReader<AspnetRoles> aspnetRolesReader)
            {
                this.aspnetRolesReader = aspnetRolesReader; 
            }

            #region IEnumerator<AspnetRoles> Members
            
            public AspnetRoles Current
            {
                get { return this.aspnetRolesReader.Current; }
            }

            #endregion
            
            #region IDisposable Members
            
            public void Dispose()
            {
                this.aspnetRolesReader.Dispose();
            }

            #endregion
            
            #region IEnumerator Members
            
            object IEnumerator.Current
            {
                get { return this.aspnetRolesReader.Current; }
            }

            public bool MoveNext()
            {
                return this.aspnetRolesReader.Read(); 
            }

            public void Reset()
            {
                throw new Exception("Reset of aspnetroles reader is not supported."); 
            }

            #endregion
            
        }
    }
}
