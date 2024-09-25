
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.IO;

/// <summary>
/// Summary description for InvoiceConfig
/// </summary>
namespace JTMSProject
{
    public partial class InvoiceConfig
    {
        private static IInvoiceConfigPersister _DefaultPersister;
        private IInvoiceConfigPersister _Persister;
        private int _VId;
        private string _Prefix;
        private int? _CompId;
        //private int? _StartingFrom;
        private string _Suffix;

        static InvoiceConfig()
        {
            // Assign default persister
            _DefaultPersister = new SqlServerInvoiceConfigPersister();
        }

        public InvoiceConfig()
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister;
        }

        public InvoiceConfig(int _VId)
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister;

            // Assign method parameter to private fields
            this._VId = _VId;

            // Call associated retrieve method
            Retrieve();
        }

        public InvoiceConfig(DataRow row)
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister;

            // Assign column values to private members
            for (int i = 0; i < row.Table.Columns.Count; i++)
            {
                switch (row.Table.Columns[i].ColumnName.ToUpper())
                {
                    case "VId":
                        this.VId = Convert.ToInt32(row[i, DataRowVersion.Current]);
                        break;

                    case "Prefix":
                        if (row.IsNull(i) == false)
                        {
                            this.Prefix = (string)(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "COMPID":
                        if (row.IsNull(i) == false)
                        {
                            this.CompId = Convert.ToInt32(row[i, DataRowVersion.Current]);
                        }
                        break;

                    //case "StartingFrom":
                    //    if (row.IsNull(i) == false)
                    //    {
                    //        this.StartingFrom = Convert.ToInt32(row[i, DataRowVersion.Current]);
                    //    }
                    //    break;

                    case "Suffix":
                        if (row.IsNull(i) == false)
                        {
                            this.Suffix = (string)row[i, DataRowVersion.Current];
                        }
                        break;

                }
            }
        }

        public static IInvoiceConfigPersister DefaultPersister
        {
            get { return _DefaultPersister; }
            set { _DefaultPersister = value; }
        }

        public IInvoiceConfigPersister Persister
        {
            get { return _Persister; }
            set { _Persister = value; }
        }

        public int VId
        {
            get { return _VId; }
            set { _VId = value; }
        }

        public string Prefix
        {
            get { return _Prefix; }
            set { _Prefix = value; }
        }

        public int? CompId
        {
            get { return _CompId; }
            set { _CompId = value; }
        }

        //public int? StartingFrom
        //{
        //    get { return _StartingFrom; }
        //    set { _StartingFrom = value; }
        //}

        public string  Suffix
        {
            get { return _Suffix; }
            set { _Suffix = value; }
        }

        public virtual void Clone(InvoiceConfig sourceObject)
        {
            // Clone attributes from source object
            this._VId = sourceObject.VId;
            this._Prefix = sourceObject.Prefix;
            this._CompId = sourceObject.CompId;
            //this._StartingFrom = sourceObject.StartingFrom;
            this._Suffix = sourceObject.Suffix;
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

        public static IReader<InvoiceConfig> ListAll()
        {
            return _DefaultPersister.ListAll();
        }
    }
    public partial interface IInvoiceConfigPersister
    {
        int Retrieve(InvoiceConfig InvoiceConfigMaster);
        int Update(InvoiceConfig InvoiceConfigMaster);
        int Delete(InvoiceConfig InvoiceConfigMaster);
        int Insert(InvoiceConfig InvoiceConfigMaster);
        IReader<InvoiceConfig> ListAll();
    }

    public partial class SqlServerInvoiceConfigPersister : SqlPersisterBase, IInvoiceConfigPersister
    {
        public SqlServerInvoiceConfigPersister()
        {
        }

        public SqlServerInvoiceConfigPersister(string connectionString)
            : base(connectionString)
        {
        }

        public SqlServerInvoiceConfigPersister(SqlConnection connection)
            : base(connection)
        {
        }

        public SqlServerInvoiceConfigPersister(SqlTransaction transaction)
            : base(transaction)
        {
        }

        public int Retrieve(InvoiceConfig InvoiceConfigMaster)
        {
            int __rowsAffected = 1;

            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("InvoiceConfigGet"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure;

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Add command parameters
                    SqlParameter vVId = new SqlParameter("@VId", SqlDbType.Int);
                    vVId.Direction = ParameterDirection.InputOutput;
                    sqlCommand.Parameters.Add(vVId);
                    SqlParameter vPrefix = new SqlParameter("@Prefix", SqlDbType.Int);
                    vPrefix.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vPrefix);
                    SqlParameter vCompId = new SqlParameter("@CompId", SqlDbType.Int);
                    vCompId.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vCompId);
                    //SqlParameter vStartingFrom = new SqlParameter("@StartingFrom", SqlDbType.Int);
                    //vStartingFrom.Direction = ParameterDirection.Output;
                    //sqlCommand.Parameters.Add(vStartingFrom);
                    SqlParameter vSuffix = new SqlParameter("@Suffix", SqlDbType.VarChar,50 );
                    vSuffix.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vSuffix);

                    // Set input parameter values
                    SqlServerHelper.SetParameterValue(vVId, InvoiceConfigMaster.VId);

                    // Execute command
                    sqlCommand.ExecuteNonQuery();

                    try
                    {
                        // Get output parameter values
                        InvoiceConfigMaster.VId = SqlServerHelper.ToInt32(vVId);
                        InvoiceConfigMaster.Prefix = SqlServerHelper.ToString(vPrefix);
                        InvoiceConfigMaster.CompId = SqlServerHelper.ToNullableInt32(vCompId);
                        //InvoiceConfigMaster.StartingFrom = SqlServerHelper.ToNullableInt32(vStartingFrom);
                        InvoiceConfigMaster.Suffix = SqlServerHelper.ToString(vSuffix);

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

        public int Update(InvoiceConfig InvoiceConfigMaster)
        {
            int __rowsAffected = 0;

            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("InvoiceConfigUpdate"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure;

                // Add command parameters
                SqlParameter vVId = new SqlParameter("@VId", SqlDbType.Int);
                vVId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vVId);
                SqlParameter vPrefix = new SqlParameter("@Prefix", SqlDbType.Int);
                vPrefix.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vPrefix);
                SqlParameter vCompId = new SqlParameter("@CompId", SqlDbType.Int);
                vCompId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vCompId);
                //SqlParameter vStartingFrom = new SqlParameter("@StartingFrom", SqlDbType.Int);
                //vStartingFrom.Direction = ParameterDirection.Input;
                //sqlCommand.Parameters.Add(vStartingFrom);
                SqlParameter vSuffix = new SqlParameter("@Suffix", SqlDbType.VarChar ,50);
                vSuffix.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vSuffix);

                // Set input parameter values
                SqlServerHelper.SetParameterValue(vVId, InvoiceConfigMaster.VId);
                SqlServerHelper.SetParameterValue(vPrefix, InvoiceConfigMaster.Prefix);
                SqlServerHelper.SetParameterValue(vCompId, InvoiceConfigMaster.CompId);
                //SqlServerHelper.SetParameterValue(vStartingFrom, InvoiceConfigMaster.StartingFrom);
                SqlServerHelper.SetParameterValue(vSuffix, InvoiceConfigMaster.Suffix);

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

        public int Delete(InvoiceConfig InvoiceConfigMaster)
        {
            int __rowsAffected = 0;

            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("InvoiceConfigDelete"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure;

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Add command parameters
                    SqlParameter vVId = new SqlParameter("@VId", SqlDbType.Int);
                    vVId.Direction = ParameterDirection.Input;
                    sqlCommand.Parameters.Add(vVId);

                    // Set input parameter values
                    SqlServerHelper.SetParameterValue(vVId, InvoiceConfigMaster.VId);

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

        public int Insert(InvoiceConfig InvoiceConfigMaster)
        {
            int __rowsAffected = 0;

            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("Invoice_ConfigInsert"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure;

                // Add command parameters
                SqlParameter vVId = new SqlParameter("@VId", SqlDbType.Int);
                vVId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vVId);
                SqlParameter vPrefix = new SqlParameter("@Prefix", SqlDbType.VarChar, 50);
                vPrefix.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vPrefix);
                SqlParameter vCompId = new SqlParameter("@CompId", SqlDbType.Int);
                vCompId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vCompId);
                //SqlParameter vStartingFrom = new SqlParameter("@StartingFrom", SqlDbType.Int );
                //vStartingFrom.Direction = ParameterDirection.Input;
                //sqlCommand.Parameters.Add(vStartingFrom);
                SqlParameter vSuffix = new SqlParameter("@Suffix", SqlDbType.VarChar ,50);
                vSuffix.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vSuffix);

                // Set input parameter values
                SqlServerHelper.SetParameterValue(vVId,InvoiceConfigMaster.VId);
                SqlServerHelper.SetParameterValue(vPrefix, InvoiceConfigMaster.Prefix);
                SqlServerHelper.SetParameterValue(vCompId, InvoiceConfigMaster.CompId);
                //SqlServerHelper.SetParameterValue(vStartingFrom, InvoiceConfigMaster.StartingFrom);
                SqlServerHelper.SetParameterValue(vSuffix, InvoiceConfigMaster.Suffix);

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
                    //InvoiceConfigMaster.VId = SqlServerHelper.ToInt32(vVId);

                }
                finally
                {
                    // Detach command
                    DetachCommand(sqlCommand);
                }

            }

            return __rowsAffected;
        }

        public IReader<InvoiceConfig> ListAll()
        {
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("InvoiceConfigListAll"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure;

                // Execute command
                SqlDataReader reader = sqlCommand.ExecuteReader(AttachReaderCommand(sqlCommand));

                // Return reader
                return new SqlServerInvoiceConfigReader(reader);
            }
        }

    }

    public partial class SqlServerInvoiceConfigReader : IReader<InvoiceConfig>
    {
        private SqlDataReader sqlDataReader;

        private InvoiceConfig _InvoiceConfigMaster;

        private int _VIdOrdinal = -1;
        private int _PrefixOrdinal = -1;
        private int _CompIdOrdinal = -1;
        //private int _StartingFromOrdinal = -1;
        private int _SuffixOrdinal = -1;

        public SqlServerInvoiceConfigReader(SqlDataReader sqlDataReader)
        {
            this.sqlDataReader = sqlDataReader;
            for (int i = 0; i < sqlDataReader.FieldCount; i++)
            {
                string columnName = sqlDataReader.GetName(i);
                columnName = columnName.ToUpper();
                switch (columnName)
                {
                    case "VId":
                        _VIdOrdinal = i;
                        break;

                    case "Prefix":
                        _PrefixOrdinal = i;
                        break;

                    case "COMPID":
                        _CompIdOrdinal = i;
                        break;

                    //case "StartingFrom":
                    //    _StartingFromOrdinal = i;
                    //    break;

                    case "Suffix":
                        _SuffixOrdinal = i;
                        break;

                }
            }
        }

        #region IReader<InvoiceConfigMaster> Implementation

        public bool Read()
        {
            _InvoiceConfigMaster = null;
            return this.sqlDataReader.Read();
        }

        public InvoiceConfig Current
        {
            get
            {
                if (_InvoiceConfigMaster == null)
                {
                    _InvoiceConfigMaster = new InvoiceConfig();
                    if (_VIdOrdinal != -1)
                    {
                        _InvoiceConfigMaster.VId = SqlServerHelper.ToInt32(sqlDataReader, _VIdOrdinal);
                    }
                    _InvoiceConfigMaster.Prefix = SqlServerHelper.ToString(sqlDataReader, _PrefixOrdinal);
                    _InvoiceConfigMaster.CompId = SqlServerHelper.ToNullableInt32(sqlDataReader, _CompIdOrdinal);
                    //_InvoiceConfigMaster.StartingFrom = SqlServerHelper.ToNullableInt32(sqlDataReader, _StartingFromOrdinal);
                    _InvoiceConfigMaster.Suffix = SqlServerHelper.ToString(sqlDataReader, _SuffixOrdinal);
                }


                return _InvoiceConfigMaster;
            }
        }

        public void Close()
        {
            sqlDataReader.Close();
        }

        public List<InvoiceConfig> ToList()
        {
            List<InvoiceConfig> list = new List<InvoiceConfig>();
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

        #region IEnumerable<InvoiceConfigMaster> Implementation

        public IEnumerator<InvoiceConfig> GetEnumerator()
        {
            return new InvoiceConfigEnumerator(this);
        }

        #endregion

        #region IEnumerable Implementation

        IEnumerator IEnumerable.GetEnumerator()
        {
            return new InvoiceConfigEnumerator(this);
        }

        #endregion


        private partial class InvoiceConfigEnumerator : IEnumerator<InvoiceConfig>
        {
            private IReader<InvoiceConfig> InvoiceConfigMasterReader;

            public InvoiceConfigEnumerator(IReader<InvoiceConfig> InvoiceConfigMasterReader)
            {
                this.InvoiceConfigMasterReader = InvoiceConfigMasterReader;
            }

            #region IEnumerator<InvoiceConfigMaster> Members

            public InvoiceConfig Current
            {
                get { return this.InvoiceConfigMasterReader.Current; }
            }

            #endregion

            #region IDisposable Members

            public void Dispose()
            {
                this.InvoiceConfigMasterReader.Dispose();
            }

            #endregion

            #region IEnumerator Members

            object IEnumerator.Current
            {
                get { return this.InvoiceConfigMasterReader.Current; }
            }

            public bool MoveNext()
            {
                return this.InvoiceConfigMasterReader.Read();
            }

            public void Reset()
            {
                throw new Exception("Reset of InvoiceConfig reader is not supported.");
            }

            #endregion

        }
    }
}

