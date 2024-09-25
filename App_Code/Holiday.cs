using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.IO;

namespace JTMSProject
{
public partial class HolidayMaster
{
       private static IHolidayMasterPersister _DefaultPersister;
        private IHolidayMasterPersister _Persister;
        private int _HolidayId;
        private int? _id;
        private int? _CompId;
        private string _HolidayName;
        private string _FinYear;
        private string _BrId;
        private DateTime? _HolidayDate;
        //private double? _HourlyCharges;

        static HolidayMaster()
        {
            // Assign default persister
            _DefaultPersister = new SqlServerHolidayMasterPersister();
        }

        public HolidayMaster()
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister; 
        }

        public HolidayMaster(int _HolidayId)
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister; 

            // Assign method parameter to private fields
            this._HolidayId = _HolidayId; 

            // Call associated retrieve method
            Retrieve();
        }

        public HolidayMaster(DataRow row)
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister; 

            // Assign column values to private members
            for (int  i = 0; i < row.Table.Columns.Count; i++)
            {
                switch (row.Table.Columns[i].ColumnName.ToUpper())
                {
                    case "HolidayID":
                        this.HolidayId = Convert.ToInt32(row[i, DataRowVersion.Current]); 
                        break;
                    
                    case "ID":
                        if(row.IsNull(i) == false)
                        {
                            this.id = Convert.ToInt32(row[i, DataRowVersion.Current]); 
                        }
                        break;
                    
                    case "COMPID":
                        if(row.IsNull(i) == false)
                        {
                            this.CompId = Convert.ToInt32(row[i, DataRowVersion.Current]); 
                        }
                        break;
                    
                    case "HolidayNAME":
                        if(row.IsNull(i) == false)
                        {
                            this.HolidayName = (string)row[i, DataRowVersion.Current]; 
                        }
                        break;

                    case "FinYr":
                        if (row.IsNull(i) == false)
                        {
                            this.FinYr = (string)row[i, DataRowVersion.Current];
                        }
                        break;

                    case "Brid":
                        if (row.IsNull(i) == false)
                        {
                            this.Brid = (string)row[i, DataRowVersion.Current];
                        }
                        break;

                    case "HolidayDATE":
                        if (row.IsNull(i) == false)
                        {
                            this.HolidayDate = Convert.ToDateTime(row[i, DataRowVersion.Current]); 
                        }
                        break;
                }
            }
        }

        public static IHolidayMasterPersister DefaultPersister
        {
            get { return _DefaultPersister; }
            set { _DefaultPersister = value; }
        }

        public IHolidayMasterPersister Persister
        {
            get { return _Persister; }
            set { _Persister = value; }
        }

        public int HolidayId
        {
            get { return _HolidayId; }
            set { _HolidayId = value; }
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

        public string HolidayName
        {
            get { return _HolidayName; }
            set { _HolidayName = value; }
        }

        public string FinYr
        {
            get { return _FinYear; }
            set { _FinYear = value; }
        }

    
        public string Brid
        {
            get { return _BrId; }
            set { _BrId = value; }
        }

        public DateTime? HolidayDate
        {
            get { return _HolidayDate; }
            set { _HolidayDate = value; }
        }
        public virtual void Clone(HolidayMaster sourceObject)
        {
            // Clone attributes from source object
            this._HolidayId = sourceObject.HolidayId; 
            this._id = sourceObject.id; 
            this._CompId = sourceObject.CompId; 
            this._HolidayName = sourceObject.HolidayName;
            this._FinYear = sourceObject.FinYr;
            this._BrId = sourceObject.Brid;
            this._HolidayDate = sourceObject.HolidayDate; 
            //this._HourlyCharges = sourceObject.HourlyCharges; 
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

        public static IReader<HolidayMaster> ListAll()
        {
            return _DefaultPersister.ListAll(); 
        }

    }
    
    public partial interface IHolidayMasterPersister
    {
        int Retrieve(HolidayMaster HolidayMaster);
        int Update(HolidayMaster HolidayMaster);
        int Delete(HolidayMaster HolidayMaster);
        int Insert(HolidayMaster HolidayMaster);
        IReader<HolidayMaster> ListAll();
    }
    
    public partial class SqlServerHolidayMasterPersister : SqlPersisterBase, IHolidayMasterPersister
    {
        public SqlServerHolidayMasterPersister()
        {
        }

        public SqlServerHolidayMasterPersister(string connectionString) : base(connectionString)
        {
        }

        public SqlServerHolidayMasterPersister(SqlConnection connection) : base(connection)
        {
        }

        public SqlServerHolidayMasterPersister(SqlTransaction transaction) : base(transaction)
        {
        }

        public int Retrieve(HolidayMaster HolidayMaster)
        {
            int __rowsAffected = 1;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("HolidayMasterGet"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Add command parameters
                    SqlParameter vHolidayId = new SqlParameter("@HolidayId", SqlDbType.Int);
                    vHolidayId.Direction = ParameterDirection.InputOutput; 
                    sqlCommand.Parameters.Add(vHolidayId);
                    SqlParameter vid = new SqlParameter("@id", SqlDbType.Int);
                    vid.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vid);
                    SqlParameter vCompId = new SqlParameter("@CompId", SqlDbType.Int);
                    vCompId.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vCompId);
                    SqlParameter vHolidayName = new SqlParameter("@HolidayName", SqlDbType.VarChar, 70);
                    vHolidayName.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vHolidayName);

                    SqlParameter vFinYr = new SqlParameter("@FinYr", SqlDbType.VarChar, 70);
                    vFinYr.Direction = ParameterDirection.Input ;
                    sqlCommand.Parameters.Add(vFinYr);

                    SqlParameter vBrid = new SqlParameter("@Brid", SqlDbType.VarChar, 70);
                    vFinYr.Direction = ParameterDirection.Input;
                    sqlCommand.Parameters.Add(vBrid);

                    SqlParameter vHolidayDate = new SqlParameter("@HolidayDate", SqlDbType.DateTime);
                    vHolidayDate.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vHolidayDate);
                    
                    // Set input parameter values
                    SqlServerHelper.SetParameterValue(vHolidayId, HolidayMaster.HolidayId);

                    // Execute command
                    sqlCommand.ExecuteNonQuery();

                    try
                    {
                        // Get output parameter values
                        HolidayMaster.HolidayId = SqlServerHelper.ToInt32(vHolidayId); 
                        HolidayMaster.id = SqlServerHelper.ToNullableInt32(vid); 
                        HolidayMaster.CompId = SqlServerHelper.ToNullableInt32(vCompId); 
                        HolidayMaster.HolidayName = SqlServerHelper.ToString(vHolidayName);
                        HolidayMaster.FinYr = SqlServerHelper.ToString(vFinYr);
                        HolidayMaster.Brid = SqlServerHelper.ToString(vBrid);
                        HolidayMaster.HolidayDate = SqlServerHelper.ToDateTime(vHolidayDate); 
                        //HolidayMaster.HourlyCharges = SqlServerHelper.ToNullableDouble(vHourlyCharges); 

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

        public int Update(HolidayMaster HolidayMaster)
        {
            int __rowsAffected = 0;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("HolidayMasterUpdate"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Add command parameters
                SqlParameter vHolidayId = new SqlParameter("@HolidayId", SqlDbType.Int);
                vHolidayId.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vHolidayId);
                SqlParameter vid = new SqlParameter("@id", SqlDbType.Int);
                vid.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vid);
                SqlParameter vCompId = new SqlParameter("@CompId", SqlDbType.Int);
                vCompId.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vCompId);
                SqlParameter vHolidayName = new SqlParameter("@HolidayName", SqlDbType.VarChar, 70);
                vHolidayName.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vHolidayName);

                SqlParameter vFinYr = new SqlParameter("@FinYr", SqlDbType.VarChar, 70);
                vFinYr.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vFinYr);

                SqlParameter vbrid = new SqlParameter("@Brid", SqlDbType.VarChar, 70);
                vbrid.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vbrid);

                SqlParameter vHolidayDate = new SqlParameter("@HolidayDate", SqlDbType.DateTime);
                vHolidayDate.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vHolidayDate);
                // Set input parameter values
                SqlServerHelper.SetParameterValue(vHolidayId, HolidayMaster.HolidayId);
                SqlServerHelper.SetParameterValue(vid, HolidayMaster.id);
                SqlServerHelper.SetParameterValue(vCompId, HolidayMaster.CompId);
                SqlServerHelper.SetParameterValue(vHolidayName, HolidayMaster.HolidayName);
                SqlServerHelper.SetParameterValue(vFinYr, HolidayMaster.FinYr);
                SqlServerHelper.SetParameterValue(vbrid, HolidayMaster.Brid);
                SqlServerHelper.SetParameterValue(vHolidayDate, HolidayMaster.HolidayDate);
                //SqlServerHelper.SetParameterValue(vHourlyCharges, HolidayMaster.HourlyCharges);

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

        public int Delete(HolidayMaster HolidayMaster)
        {
            int __rowsAffected = 0;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("HolidayMasterDelete"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Add command parameters
                    SqlParameter vHolidayId = new SqlParameter("@HolidayId", SqlDbType.Int);
                    vHolidayId.Direction = ParameterDirection.Input; 
                    sqlCommand.Parameters.Add(vHolidayId);

                    // Set input parameter values
                    SqlServerHelper.SetParameterValue(vHolidayId, HolidayMaster.HolidayId);

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

        public int Insert(HolidayMaster HolidayMaster)
        {
            int __rowsAffected = 0;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("HolidayMasterInsert"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Add command parameters
                SqlParameter vHolidayId = new SqlParameter("@HolidayId", SqlDbType.Int);
                vHolidayId.Direction = ParameterDirection.InputOutput; 
                sqlCommand.Parameters.Add(vHolidayId);
                SqlParameter vid = new SqlParameter("@id", SqlDbType.Int);
                vid.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vid);
                SqlParameter vCompId = new SqlParameter("@CompId", SqlDbType.Int);
                vCompId.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vCompId);
                SqlParameter vHolidayName = new SqlParameter("@HolidayName", SqlDbType.VarChar, 70);
                vHolidayName.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vHolidayName);

                SqlParameter vFinYr = new SqlParameter("@FinYr", SqlDbType.VarChar, 70);
                vFinYr.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vFinYr);

                SqlParameter vbrid = new SqlParameter("@Brid", SqlDbType.VarChar, 70);
                vbrid.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vbrid);


                SqlParameter vHolidayDate = new SqlParameter("@HolidayDate", SqlDbType.DateTime );
                vHolidayDate.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vHolidayDate);
                // Set input parameter values
                SqlServerHelper.SetParameterValue(
                    vHolidayId, 
                    HolidayMaster.HolidayId, 
                    0);
                SqlServerHelper.SetParameterValue(vid, HolidayMaster.id);
                SqlServerHelper.SetParameterValue(vCompId, HolidayMaster.CompId);
                SqlServerHelper.SetParameterValue(vHolidayName, HolidayMaster.HolidayName);
                SqlServerHelper.SetParameterValue(vFinYr, HolidayMaster.FinYr);
                SqlServerHelper.SetParameterValue(vbrid, HolidayMaster.Brid);
                SqlServerHelper.SetParameterValue(vHolidayDate, HolidayMaster.HolidayDate);
                //SqlServerHelper.SetParameterValue(vHourlyCharges, HolidayMaster.HourlyCharges);

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
                    HolidayMaster.HolidayId = SqlServerHelper.ToInt32(vHolidayId); 

                }
                finally
                {
                    // Detach command
                    DetachCommand(sqlCommand);
                }

            }
            
            return __rowsAffected; 
        }

        public IReader<HolidayMaster> ListAll()
        {
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("HolidayMasterListAll"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Execute command
                SqlDataReader reader = sqlCommand.ExecuteReader(AttachReaderCommand(sqlCommand));

                // Return reader
                return new SqlServerHolidayMasterReader(reader); 
            }
        }

    }

    public partial class SqlServerHolidayMasterReader : IReader<HolidayMaster>
    {
        private SqlDataReader sqlDataReader;

        private HolidayMaster _HolidayMaster;

        private int _HolidayIdOrdinal = -1;
        private int _idOrdinal = -1;
        private int _CompIdOrdinal = -1;
        private int _HolidayNameOrdinal = -1;
        private int _FinYrOrdinal = -1;
        private int _BridOrdinal = -1;
        private int _HolidayDateOrdinal = -1;
        //private int _HourlyChargesOrdinal = -1;

        public SqlServerHolidayMasterReader(SqlDataReader sqlDataReader)
        {
            this.sqlDataReader = sqlDataReader; 
            for (int  i = 0; i < sqlDataReader.FieldCount; i++)
            {
                string columnName = sqlDataReader.GetName(i);
                columnName = columnName.ToUpper(); 
                switch (columnName)
                {
                    case "HolidayID":
                        _HolidayIdOrdinal = i; 
                        break;
                    
                    case "ID":
                        _idOrdinal = i; 
                        break;
                    
                    case "COMPID":
                        _CompIdOrdinal = i; 
                        break;
                    
                    case "HolidayNAME":
                        _HolidayNameOrdinal = i; 
                        break;

                    case "FinYear":
                        _FinYrOrdinal = i;
                        break;

                    case "BrId":
                        _BridOrdinal = i;
                        break;

                    case "HolidayDate":
                        _HolidayDateOrdinal = i;
                        break;
                    //case "HOURLYCHARGES":
                    //    _HourlyChargesOrdinal = i; 
                    //    break;
                    
                }
            }
        }

        #region IReader<HolidayMaster> Implementation
        
        public bool Read()
        {
            _HolidayMaster = null; 
            return this.sqlDataReader.Read(); 
        }

        public HolidayMaster Current
        {
            get
            {
                if(_HolidayMaster == null)
                {
                    _HolidayMaster = new HolidayMaster();
                    if(_HolidayIdOrdinal != -1)
                    {
                        _HolidayMaster.HolidayId = SqlServerHelper.ToInt32(sqlDataReader, _HolidayIdOrdinal); 
                    }
                    _HolidayMaster.id = SqlServerHelper.ToNullableInt32(sqlDataReader, _idOrdinal); 
                    _HolidayMaster.CompId = SqlServerHelper.ToNullableInt32(sqlDataReader, _CompIdOrdinal); 
                    _HolidayMaster.HolidayName = SqlServerHelper.ToString(sqlDataReader, _HolidayNameOrdinal);
                    _HolidayMaster.FinYr = SqlServerHelper.ToString(sqlDataReader, _FinYrOrdinal );
                    _HolidayMaster.Brid = SqlServerHelper.ToString(sqlDataReader, _BridOrdinal);
                    _HolidayMaster.HolidayDate = SqlServerHelper.ToDateTime(sqlDataReader, _HolidayDateOrdinal); 
                    //_HolidayMaster.HourlyCharges = SqlServerHelper.ToNullableDouble(sqlDataReader, _HourlyChargesOrdinal); 
                }
                

                return _HolidayMaster; 
            }
        }

        public void Close()
        {
            sqlDataReader.Close();
        }

        public List<HolidayMaster> ToList()
        {
            List<HolidayMaster> list = new List<HolidayMaster>();
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
        
        #region IEnumerable<HolidayMaster> Implementation
        
        public IEnumerator<HolidayMaster> GetEnumerator()
        {
            return new HolidayMasterEnumerator(this); 
        }

        #endregion
        
        #region IEnumerable Implementation
        
        IEnumerator IEnumerable.GetEnumerator()
        {
            return new HolidayMasterEnumerator(this); 
        }

        #endregion
        
        
        private partial class HolidayMasterEnumerator : IEnumerator<HolidayMaster>
        {
            private IReader<HolidayMaster> HolidayMasterReader;

            public HolidayMasterEnumerator(IReader<HolidayMaster> HolidayMasterReader)
            {
                this.HolidayMasterReader = HolidayMasterReader; 
            }

            #region IEnumerator<HolidayMaster> Members
            
            public HolidayMaster Current
            {
                get { return this.HolidayMasterReader.Current; }
            }

            #endregion
            
            #region IDisposable Members
            
            public void Dispose()
            {
                this.HolidayMasterReader.Dispose();
            }

            #endregion
            
            #region IEnumerator Members
            
            object IEnumerator.Current
            {
                get { return this.HolidayMasterReader.Current; }
            }

            public bool MoveNext()
            {
                return this.HolidayMasterReader.Read(); 
            }

            public void Reset()
            {
                throw new Exception("Reset of Holidaymaster reader is not supported."); 
            }

            #endregion
            
        }
    }
}
