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
    public partial class LocationMaster
    {
        private static ILocationMasterPersister _DefaultPersister;
        private ILocationMasterPersister _Persister;
        private int _LocId;
        private int? _CompId;
        private int? _id;
        private string _LocationName;

        static LocationMaster()
        {
            // Assign default persister
            _DefaultPersister = new SqlServerLocationMasterPersister();
        }

        public LocationMaster()
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister; 
        }

        public LocationMaster(int _LocId)
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister; 

            // Assign method parameter to private fields
            this._LocId = _LocId; 

            // Call associated retrieve method
            Retrieve();
        }

        public LocationMaster(DataRow row)
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister; 

            // Assign column values to private members
            for (int  i = 0; i < row.Table.Columns.Count; i++)
            {
                switch (row.Table.Columns[i].ColumnName.ToUpper())
                {
                    case "LOCID":
                        this.LocId = Convert.ToInt32(row[i, DataRowVersion.Current]); 
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
                    
                    case "LOCATIONNAME":
                        if(row.IsNull(i) == false)
                        {
                            this.LocationName = (string)row[i, DataRowVersion.Current]; 
                        }
                        break;
                    
                }
            }
        }

        public static ILocationMasterPersister DefaultPersister
        {
            get { return _DefaultPersister; }
            set { _DefaultPersister = value; }
        }

        public ILocationMasterPersister Persister
        {
            get { return _Persister; }
            set { _Persister = value; }
        }

        public int LocId
        {
            get { return _LocId; }
            set { _LocId = value; }
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

        public string LocationName
        {
            get { return _LocationName; }
            set { _LocationName = value; }
        }

        public virtual void Clone(LocationMaster sourceObject)
        {
            // Clone attributes from source object
            this._LocId = sourceObject.LocId; 
            this._CompId = sourceObject.CompId; 
            this._id = sourceObject.id; 
            this._LocationName = sourceObject.LocationName; 
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

        public static IReader<LocationMaster> ListAll()
        {
            return _DefaultPersister.ListAll(); 
        }

    }
    
    public partial interface ILocationMasterPersister
    {
        int Retrieve(LocationMaster locationMaster);
        int Update(LocationMaster locationMaster);
        int Delete(LocationMaster locationMaster);
        int Insert(LocationMaster locationMaster);
        IReader<LocationMaster> ListAll();
    }
    
    public partial class SqlServerLocationMasterPersister : SqlPersisterBase, ILocationMasterPersister
    {
        public SqlServerLocationMasterPersister()
        {
        }

        public SqlServerLocationMasterPersister(string connectionString) : base(connectionString)
        {
        }

        public SqlServerLocationMasterPersister(SqlConnection connection) : base(connection)
        {
        }

        public SqlServerLocationMasterPersister(SqlTransaction transaction) : base(transaction)
        {
        }

        public int Retrieve(LocationMaster locationMaster)
        {
            int __rowsAffected = 1;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("LocationMasterGet"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Add command parameters
                    SqlParameter vLocId = new SqlParameter("@LocId", SqlDbType.Int);
                    vLocId.Direction = ParameterDirection.InputOutput; 
                    sqlCommand.Parameters.Add(vLocId);
                    SqlParameter vCompId = new SqlParameter("@CompId", SqlDbType.Int);
                    vCompId.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vCompId);
                    SqlParameter vid = new SqlParameter("@id", SqlDbType.Int);
                    vid.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vid);
                    SqlParameter vLocationName = new SqlParameter("@LocationName", SqlDbType.VarChar, 70);
                    vLocationName.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vLocationName);

                    // Set input parameter values
                    SqlServerHelper.SetParameterValue(vLocId, locationMaster.LocId);

                    // Execute command
                    sqlCommand.ExecuteNonQuery();

                    try
                    {
                        // Get output parameter values
                        locationMaster.LocId = SqlServerHelper.ToInt32(vLocId); 
                        locationMaster.CompId = SqlServerHelper.ToNullableInt32(vCompId); 
                        locationMaster.id = SqlServerHelper.ToNullableInt32(vid); 
                        locationMaster.LocationName = SqlServerHelper.ToString(vLocationName); 

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

        public int Update(LocationMaster locationMaster)
        {
            int __rowsAffected = 0;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("LocationMasterUpdate"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Add command parameters
                SqlParameter vLocId = new SqlParameter("@LocId", SqlDbType.Int);
                vLocId.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vLocId);
                SqlParameter vCompId = new SqlParameter("@CompId", SqlDbType.Int);
                vCompId.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vCompId);
                SqlParameter vid = new SqlParameter("@id", SqlDbType.Int);
                vid.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vid);
                SqlParameter vLocationName = new SqlParameter("@LocationName", SqlDbType.VarChar, 70);
                vLocationName.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vLocationName);

                // Set input parameter values
                SqlServerHelper.SetParameterValue(vLocId, locationMaster.LocId);
                SqlServerHelper.SetParameterValue(vCompId, locationMaster.CompId);
                SqlServerHelper.SetParameterValue(vid, locationMaster.id);
                SqlServerHelper.SetParameterValue(vLocationName, locationMaster.LocationName);

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

        public int Delete(LocationMaster locationMaster)
        {
            int __rowsAffected = 0;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("LocationMasterDelete"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Add command parameters
                    SqlParameter vLocId = new SqlParameter("@LocId", SqlDbType.Int);
                    vLocId.Direction = ParameterDirection.Input; 
                    sqlCommand.Parameters.Add(vLocId);

                    // Set input parameter values
                    SqlServerHelper.SetParameterValue(vLocId, locationMaster.LocId);

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

        public int Insert(LocationMaster locationMaster)
        {
            int __rowsAffected = 0;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("LocationMasterInsert"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Add command parameters
                SqlParameter vLocId = new SqlParameter("@LocId", SqlDbType.Int);
                vLocId.Direction = ParameterDirection.InputOutput; 
                sqlCommand.Parameters.Add(vLocId);
                SqlParameter vCompId = new SqlParameter("@CompId", SqlDbType.Int);
                vCompId.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vCompId);
                SqlParameter vid = new SqlParameter("@id", SqlDbType.Int);
                vid.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vid);
                SqlParameter vLocationName = new SqlParameter("@LocationName", SqlDbType.VarChar, 70);
                vLocationName.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vLocationName);

                // Set input parameter values
                SqlServerHelper.SetParameterValue(
                    vLocId, 
                    locationMaster.LocId, 
                    0);
                SqlServerHelper.SetParameterValue(vCompId, locationMaster.CompId);
                SqlServerHelper.SetParameterValue(vid, locationMaster.id);
                SqlServerHelper.SetParameterValue(vLocationName, locationMaster.LocationName);

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
                    locationMaster.LocId = SqlServerHelper.ToInt32(vLocId); 

                }
                finally
                {
                    // Detach command
                    DetachCommand(sqlCommand);
                }

            }
            
            return __rowsAffected; 
        }

        public IReader<LocationMaster> ListAll()
        {
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("LocationMasterListAll"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Execute command
                SqlDataReader reader = sqlCommand.ExecuteReader(AttachReaderCommand(sqlCommand));

                // Return reader
                return new SqlServerLocationMasterReader(reader); 
            }
        }

    }

    public partial class SqlServerLocationMasterReader : IReader<LocationMaster>
    {
        private SqlDataReader sqlDataReader;

        private LocationMaster _LocationMaster;

        private int _LocIdOrdinal = -1;
        private int _CompIdOrdinal = -1;
        private int _idOrdinal = -1;
        private int _LocationNameOrdinal = -1;

        public SqlServerLocationMasterReader(SqlDataReader sqlDataReader)
        {
            this.sqlDataReader = sqlDataReader; 
            for (int  i = 0; i < sqlDataReader.FieldCount; i++)
            {
                string columnName = sqlDataReader.GetName(i);
                columnName = columnName.ToUpper(); 
                switch (columnName)
                {
                    case "LOCID":
                        _LocIdOrdinal = i; 
                        break;
                    
                    case "COMPID":
                        _CompIdOrdinal = i; 
                        break;
                    
                    case "ID":
                        _idOrdinal = i; 
                        break;
                    
                    case "LOCATIONNAME":
                        _LocationNameOrdinal = i; 
                        break;
                    
                }
            }
        }

        #region IReader<LocationMaster> Implementation
        
        public bool Read()
        {
            _LocationMaster = null; 
            return this.sqlDataReader.Read(); 
        }

        public LocationMaster Current
        {
            get
            {
                if(_LocationMaster == null)
                {
                    _LocationMaster = new LocationMaster();
                    if(_LocIdOrdinal != -1)
                    {
                        _LocationMaster.LocId = SqlServerHelper.ToInt32(sqlDataReader, _LocIdOrdinal); 
                    }
                    _LocationMaster.CompId = SqlServerHelper.ToNullableInt32(sqlDataReader, _CompIdOrdinal); 
                    _LocationMaster.id = SqlServerHelper.ToNullableInt32(sqlDataReader, _idOrdinal); 
                    _LocationMaster.LocationName = SqlServerHelper.ToString(sqlDataReader, _LocationNameOrdinal); 
                }
                

                return _LocationMaster; 
            }
        }

        public void Close()
        {
            sqlDataReader.Close();
        }

        public List<LocationMaster> ToList()
        {
            List<LocationMaster> list = new List<LocationMaster>();
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
        
        #region IEnumerable<LocationMaster> Implementation
        
        public IEnumerator<LocationMaster> GetEnumerator()
        {
            return new LocationMasterEnumerator(this); 
        }

        #endregion
        
        #region IEnumerable Implementation
        
        IEnumerator IEnumerable.GetEnumerator()
        {
            return new LocationMasterEnumerator(this); 
        }

        #endregion
        
        
        private partial class LocationMasterEnumerator : IEnumerator<LocationMaster>
        {
            private IReader<LocationMaster> locationMasterReader;

            public LocationMasterEnumerator(IReader<LocationMaster> locationMasterReader)
            {
                this.locationMasterReader = locationMasterReader; 
            }

            #region IEnumerator<LocationMaster> Members
            
            public LocationMaster Current
            {
                get { return this.locationMasterReader.Current; }
            }

            #endregion
            
            #region IDisposable Members
            
            public void Dispose()
            {
                this.locationMasterReader.Dispose();
            }

            #endregion
            
            #region IEnumerator Members
            
            object IEnumerator.Current
            {
                get { return this.locationMasterReader.Current; }
            }

            public bool MoveNext()
            {
                return this.locationMasterReader.Read(); 
            }

            public void Reset()
            {
                throw new Exception("Reset of locationmaster reader is not supported."); 
            }

            #endregion
            
        }
    }
}
