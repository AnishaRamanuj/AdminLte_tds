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
    public partial class AspnetSchemaversions
    {
        private static IAspnetSchemaversionsPersister _DefaultPersister;
        private IAspnetSchemaversionsPersister _Persister;
        private string _Feature;
        private string _CompatibleSchemaVersion;
        private bool _IsCurrentVersion;

        static AspnetSchemaversions()
        {
            // Assign default persister
            _DefaultPersister = new SqlServerAspnetSchemaversionsPersister();
        }

        public AspnetSchemaversions()
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister; 
        }

        public AspnetSchemaversions(string _Feature, string _CompatibleSchemaVersion)
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister; 

            // Assign method parameter to private fields
            this._Feature = _Feature; 
            this._CompatibleSchemaVersion = _CompatibleSchemaVersion; 

            // Call associated retrieve method
            Retrieve();
        }

        public AspnetSchemaversions(DataRow row)
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister; 

            // Assign column values to private members
            for (int  i = 0; i < row.Table.Columns.Count; i++)
            {
                switch (row.Table.Columns[i].ColumnName.ToUpper())
                {
                    case "FEATURE":
                        this.Feature = (string)row[i, DataRowVersion.Current]; 
                        break;
                    
                    case "COMPATIBLESCHEMAVERSION":
                        this.CompatibleSchemaVersion = (string)row[i, DataRowVersion.Current]; 
                        break;
                    
                    case "ISCURRENTVERSION":
                        this.IsCurrentVersion = Convert.ToBoolean(row[i, DataRowVersion.Current]); 
                        break;
                    
                }
            }
        }

        public static IAspnetSchemaversionsPersister DefaultPersister
        {
            get { return _DefaultPersister; }
            set { _DefaultPersister = value; }
        }

        public IAspnetSchemaversionsPersister Persister
        {
            get { return _Persister; }
            set { _Persister = value; }
        }

        public string Feature
        {
            get { return _Feature; }
            set { _Feature = value; }
        }

        public string CompatibleSchemaVersion
        {
            get { return _CompatibleSchemaVersion; }
            set { _CompatibleSchemaVersion = value; }
        }

        public bool IsCurrentVersion
        {
            get { return _IsCurrentVersion; }
            set { _IsCurrentVersion = value; }
        }

        public virtual void Clone(AspnetSchemaversions sourceObject)
        {
            // Clone attributes from source object
            this._Feature = sourceObject.Feature; 
            this._CompatibleSchemaVersion = sourceObject.CompatibleSchemaVersion; 
            this._IsCurrentVersion = sourceObject.IsCurrentVersion; 
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

        public static IReader<AspnetSchemaversions> ListAll()
        {
            return _DefaultPersister.ListAll(); 
        }

    }
    
    public partial interface IAspnetSchemaversionsPersister
    {
        int Retrieve(AspnetSchemaversions aspnetSchemaversions);
        int Update(AspnetSchemaversions aspnetSchemaversions);
        int Delete(AspnetSchemaversions aspnetSchemaversions);
        int Insert(AspnetSchemaversions aspnetSchemaversions);
        IReader<AspnetSchemaversions> ListAll();
    }
    
    public partial class SqlServerAspnetSchemaversionsPersister : SqlPersisterBase, IAspnetSchemaversionsPersister
    {
        public SqlServerAspnetSchemaversionsPersister()
        {
        }

        public SqlServerAspnetSchemaversionsPersister(string connectionString) : base(connectionString)
        {
        }

        public SqlServerAspnetSchemaversionsPersister(SqlConnection connection) : base(connection)
        {
        }

        public SqlServerAspnetSchemaversionsPersister(SqlTransaction transaction) : base(transaction)
        {
        }

        public int Retrieve(AspnetSchemaversions aspnetSchemaversions)
        {
            int __rowsAffected = 1;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("AspnetSchemaversionsGet"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Add command parameters
                    SqlParameter vFeature = new SqlParameter("@Feature", SqlDbType.NVarChar, 128);
                    vFeature.Direction = ParameterDirection.InputOutput; 
                    sqlCommand.Parameters.Add(vFeature);
                    SqlParameter vCompatibleSchemaVersion = new SqlParameter("@CompatibleSchemaVersion", SqlDbType.NVarChar, 128);
                    vCompatibleSchemaVersion.Direction = ParameterDirection.InputOutput; 
                    sqlCommand.Parameters.Add(vCompatibleSchemaVersion);
                    SqlParameter vIsCurrentVersion = new SqlParameter("@IsCurrentVersion", SqlDbType.Bit);
                    vIsCurrentVersion.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vIsCurrentVersion);

                    // Set input parameter values
                    SqlServerHelper.SetParameterValue(vFeature, aspnetSchemaversions.Feature);
                    SqlServerHelper.SetParameterValue(vCompatibleSchemaVersion, aspnetSchemaversions.CompatibleSchemaVersion);

                    // Execute command
                    sqlCommand.ExecuteNonQuery();

                    try
                    {
                        // Get output parameter values
                        aspnetSchemaversions.Feature = SqlServerHelper.ToString(vFeature); 
                        aspnetSchemaversions.CompatibleSchemaVersion = SqlServerHelper.ToString(vCompatibleSchemaVersion); 
                        aspnetSchemaversions.IsCurrentVersion = SqlServerHelper.ToBoolean(vIsCurrentVersion); 

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

        public int Update(AspnetSchemaversions aspnetSchemaversions)
        {
            int __rowsAffected = 0;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("AspnetSchemaversionsUpdate"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Add command parameters
                SqlParameter vFeature = new SqlParameter("@Feature", SqlDbType.NVarChar, 128);
                vFeature.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vFeature);
                SqlParameter vCompatibleSchemaVersion = new SqlParameter("@CompatibleSchemaVersion", SqlDbType.NVarChar, 128);
                vCompatibleSchemaVersion.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vCompatibleSchemaVersion);
                SqlParameter vIsCurrentVersion = new SqlParameter("@IsCurrentVersion", SqlDbType.Bit);
                vIsCurrentVersion.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vIsCurrentVersion);

                // Set input parameter values
                SqlServerHelper.SetParameterValue(vFeature, aspnetSchemaversions.Feature);
                SqlServerHelper.SetParameterValue(vCompatibleSchemaVersion, aspnetSchemaversions.CompatibleSchemaVersion);
                SqlServerHelper.SetParameterValue(vIsCurrentVersion, aspnetSchemaversions.IsCurrentVersion);

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

        public int Delete(AspnetSchemaversions aspnetSchemaversions)
        {
            int __rowsAffected = 0;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("AspnetSchemaversionsDelete"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Add command parameters
                    SqlParameter vFeature = new SqlParameter("@Feature", SqlDbType.NVarChar, 128);
                    vFeature.Direction = ParameterDirection.Input; 
                    sqlCommand.Parameters.Add(vFeature);
                    SqlParameter vCompatibleSchemaVersion = new SqlParameter("@CompatibleSchemaVersion", SqlDbType.NVarChar, 128);
                    vCompatibleSchemaVersion.Direction = ParameterDirection.Input; 
                    sqlCommand.Parameters.Add(vCompatibleSchemaVersion);

                    // Set input parameter values
                    SqlServerHelper.SetParameterValue(vFeature, aspnetSchemaversions.Feature);
                    SqlServerHelper.SetParameterValue(vCompatibleSchemaVersion, aspnetSchemaversions.CompatibleSchemaVersion);

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

        public int Insert(AspnetSchemaversions aspnetSchemaversions)
        {
            int __rowsAffected = 0;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("AspnetSchemaversionsInsert"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Add command parameters
                SqlParameter vFeature = new SqlParameter("@Feature", SqlDbType.NVarChar, 128);
                vFeature.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vFeature);
                SqlParameter vCompatibleSchemaVersion = new SqlParameter("@CompatibleSchemaVersion", SqlDbType.NVarChar, 128);
                vCompatibleSchemaVersion.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vCompatibleSchemaVersion);
                SqlParameter vIsCurrentVersion = new SqlParameter("@IsCurrentVersion", SqlDbType.Bit);
                vIsCurrentVersion.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vIsCurrentVersion);

                // Set input parameter values
                SqlServerHelper.SetParameterValue(vFeature, aspnetSchemaversions.Feature);
                SqlServerHelper.SetParameterValue(vCompatibleSchemaVersion, aspnetSchemaversions.CompatibleSchemaVersion);
                SqlServerHelper.SetParameterValue(vIsCurrentVersion, aspnetSchemaversions.IsCurrentVersion);

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

        public IReader<AspnetSchemaversions> ListAll()
        {
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("AspnetSchemaversionsListAll"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Execute command
                SqlDataReader reader = sqlCommand.ExecuteReader(AttachReaderCommand(sqlCommand));

                // Return reader
                return new SqlServerAspnetSchemaversionsReader(reader); 
            }
        }

    }

    public partial class SqlServerAspnetSchemaversionsReader : IReader<AspnetSchemaversions>
    {
        private SqlDataReader sqlDataReader;

        private AspnetSchemaversions _AspnetSchemaversions;

        private int _FeatureOrdinal = -1;
        private int _CompatibleSchemaVersionOrdinal = -1;
        private int _IsCurrentVersionOrdinal = -1;

        public SqlServerAspnetSchemaversionsReader(SqlDataReader sqlDataReader)
        {
            this.sqlDataReader = sqlDataReader; 
            for (int  i = 0; i < sqlDataReader.FieldCount; i++)
            {
                string columnName = sqlDataReader.GetName(i);
                columnName = columnName.ToUpper(); 
                switch (columnName)
                {
                    case "FEATURE":
                        _FeatureOrdinal = i; 
                        break;
                    
                    case "COMPATIBLESCHEMAVERSION":
                        _CompatibleSchemaVersionOrdinal = i; 
                        break;
                    
                    case "ISCURRENTVERSION":
                        _IsCurrentVersionOrdinal = i; 
                        break;
                    
                }
            }
        }

        #region IReader<AspnetSchemaversions> Implementation
        
        public bool Read()
        {
            _AspnetSchemaversions = null; 
            return this.sqlDataReader.Read(); 
        }

        public AspnetSchemaversions Current
        {
            get
            {
                if(_AspnetSchemaversions == null)
                {
                    _AspnetSchemaversions = new AspnetSchemaversions();
                    _AspnetSchemaversions.Feature = SqlServerHelper.ToString(sqlDataReader, _FeatureOrdinal); 
                    _AspnetSchemaversions.CompatibleSchemaVersion = SqlServerHelper.ToString(sqlDataReader, _CompatibleSchemaVersionOrdinal); 
                    if(_IsCurrentVersionOrdinal != -1)
                    {
                        _AspnetSchemaversions.IsCurrentVersion = SqlServerHelper.ToBoolean(sqlDataReader, _IsCurrentVersionOrdinal); 
                    }
                }
                

                return _AspnetSchemaversions; 
            }
        }

        public void Close()
        {
            sqlDataReader.Close();
        }

        public List<AspnetSchemaversions> ToList()
        {
            List<AspnetSchemaversions> list = new List<AspnetSchemaversions>();
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
        
        #region IEnumerable<AspnetSchemaversions> Implementation
        
        public IEnumerator<AspnetSchemaversions> GetEnumerator()
        {
            return new AspnetSchemaversionsEnumerator(this); 
        }

        #endregion
        
        #region IEnumerable Implementation
        
        IEnumerator IEnumerable.GetEnumerator()
        {
            return new AspnetSchemaversionsEnumerator(this); 
        }

        #endregion
        
        
        private partial class AspnetSchemaversionsEnumerator : IEnumerator<AspnetSchemaversions>
        {
            private IReader<AspnetSchemaversions> aspnetSchemaversionsReader;

            public AspnetSchemaversionsEnumerator(IReader<AspnetSchemaversions> aspnetSchemaversionsReader)
            {
                this.aspnetSchemaversionsReader = aspnetSchemaversionsReader; 
            }

            #region IEnumerator<AspnetSchemaversions> Members
            
            public AspnetSchemaversions Current
            {
                get { return this.aspnetSchemaversionsReader.Current; }
            }

            #endregion
            
            #region IDisposable Members
            
            public void Dispose()
            {
                this.aspnetSchemaversionsReader.Dispose();
            }

            #endregion
            
            #region IEnumerator Members
            
            object IEnumerator.Current
            {
                get { return this.aspnetSchemaversionsReader.Current; }
            }

            public bool MoveNext()
            {
                return this.aspnetSchemaversionsReader.Read(); 
            }

            public void Reset()
            {
                throw new Exception("Reset of aspnetschemaversions reader is not supported."); 
            }

            #endregion
            
        }
    }
}
