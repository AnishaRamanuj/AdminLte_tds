using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Runtime.Serialization;

namespace JTMSProject
{
    [DataContract]
    public partial class MasterLevelPayment
    {
        private static IMasterLevelPaymentPersister _defaultPersister;
        private decimal _commission;
        private decimal _insuranceCommission;
        private decimal _maxCommission;
        private int _maxCount;
        private int _paymentLevel;
        private IMasterLevelPaymentPersister _persister;

        static MasterLevelPayment()
        {
            // Assign default persister
            _defaultPersister = new SqlServerMasterLevelPaymentPersister();
        }

        public MasterLevelPayment()
        {
            // Create instance level persister
            _persister = new SqlServerMasterLevelPaymentPersister();
        }

        public MasterLevelPayment(int _paymentLevel)
        {
            // Create instance level persister
            _persister = new SqlServerMasterLevelPaymentPersister();

            // Assign method parameter to private fields
            this._paymentLevel = _paymentLevel;

            // Call associated retrieve method
            Retrieve();
        }

        public MasterLevelPayment(DataRow row)
        {
            // Create instance level persister
            _persister = new SqlServerMasterLevelPaymentPersister();

            // Assign column values to private members
            for (int i = 0; i < row.Table.Columns.Count; i++)
            {
                switch (row.Table.Columns[i].ColumnName.ToUpper())
                {
                    case "PAYMENTLEVEL":
                        PaymentLevel = Convert.ToInt32(row[i, DataRowVersion.Current]);
                        break;

                    case "COMMISSION":
                        Commission = Convert.ToDecimal(row[i, DataRowVersion.Current]);
                        break;

                    case "INSURANCECOMMISSION":
                        InsuranceCommission = Convert.ToDecimal(row[i, DataRowVersion.Current]);
                        break;

                    case "MAXCOUNT":
                        MaxCount = Convert.ToInt32(row[i, DataRowVersion.Current]);
                        break;

                    case "MAXCOMMISSION":
                        MaxCommission = Convert.ToDecimal(row[i, DataRowVersion.Current]);
                        break;
                }
            }
        }

        public static IMasterLevelPaymentPersister DefaultPersister
        {
            get { return _defaultPersister; }
            set { _defaultPersister = value; }
        }

        public IMasterLevelPaymentPersister Persister
        {
            get { return _persister; }
            set { _persister = value; }
        }

        [DataMember]
        public int PaymentLevel
        {
            get { return _paymentLevel; }
            set { _paymentLevel = value; }
        }

        [DataMember]
        public decimal Commission
        {
            get { return _commission; }
            set { _commission = value; }
        }

        [DataMember]
        public decimal InsuranceCommission
        {
            get { return _insuranceCommission; }
            set { _insuranceCommission = value; }
        }

        [DataMember]
        public int MaxCount
        {
            get { return _maxCount; }
            set { _maxCount = value; }
        }

        [DataMember]
        public decimal MaxCommission
        {
            get { return _maxCommission; }
            set { _maxCommission = value; }
        }

        public virtual void Clone(MasterLevelPayment sourceObject)
        {
            if (sourceObject == null)
            {
                throw new ArgumentNullException("sourceObject");
            }

            // Clone attributes from source object
            _paymentLevel = sourceObject.PaymentLevel;
            _commission = sourceObject.Commission;
            _insuranceCommission = sourceObject.InsuranceCommission;
            _maxCount = sourceObject.MaxCount;
            _maxCommission = sourceObject.MaxCommission;
        }

        public virtual int Retrieve()
        {
            return _persister.Retrieve(this);
        }

        public virtual int Update()
        {
            return _persister.Update(this);
        }

        public virtual int Delete()
        {
            return _persister.Delete(this);
        }

        public virtual int Insert()
        {
            return _persister.Insert(this);
        }

        public static IReader<MasterLevelPayment> ListAll()
        {
            return _defaultPersister.ListAll();
        }
    }

    public partial interface IMasterLevelPaymentPersister
    {
        int Retrieve(MasterLevelPayment masterLevelPayment);
        int Update(MasterLevelPayment masterLevelPayment);
        int Delete(MasterLevelPayment masterLevelPayment);
        int Insert(MasterLevelPayment masterLevelPayment);
        IReader<MasterLevelPayment> ListAll();
    }

    public partial class SqlServerMasterLevelPaymentPersister : SqlPersisterBase, IMasterLevelPaymentPersister
    {
        public SqlServerMasterLevelPaymentPersister()
        {
        }

        public SqlServerMasterLevelPaymentPersister(string connectionString) : base(connectionString)
        {
        }

        public SqlServerMasterLevelPaymentPersister(SqlConnection connection) : base(connection)
        {
        }

        public SqlServerMasterLevelPaymentPersister(SqlTransaction transaction) : base(transaction)
        {
        }

        #region IMasterLevelPaymentPersister Members

        public int Retrieve(MasterLevelPayment masterLevelPayment)
        {
            int __rowsAffected = 1;

            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("MasterLevelPaymentGet"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure;

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Add command parameters
                    SqlParameter vPaymentLevel = new SqlParameter("@PaymentLevel", SqlDbType.Int);
                    vPaymentLevel.Direction = ParameterDirection.InputOutput;
                    sqlCommand.Parameters.Add(vPaymentLevel);
                    SqlParameter vCommission = new SqlParameter("@Commission", SqlDbType.SmallMoney);
                    vCommission.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vCommission);
                    SqlParameter vInsuranceCommission = new SqlParameter("@InsuranceCommission", SqlDbType.SmallMoney);
                    vInsuranceCommission.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vInsuranceCommission);
                    SqlParameter vMaxCount = new SqlParameter("@MaxCount", SqlDbType.Int);
                    vMaxCount.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vMaxCount);
                    SqlParameter vMaxCommission = new SqlParameter("@MaxCommission", SqlDbType.Money);
                    vMaxCommission.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vMaxCommission);

                    // Set input parameter values
                    SqlServerHelper.SetParameterValue(vPaymentLevel, masterLevelPayment.PaymentLevel);

                    // Execute command
                    sqlCommand.ExecuteNonQuery();

                    try
                    {
                        // Get output parameter values
                        masterLevelPayment.PaymentLevel = SqlServerHelper.ToInt32(vPaymentLevel);
                        masterLevelPayment.Commission = SqlServerHelper.ToDecimal(vCommission);
                        masterLevelPayment.InsuranceCommission = SqlServerHelper.ToDecimal(vInsuranceCommission);
                        masterLevelPayment.MaxCount = SqlServerHelper.ToInt32(vMaxCount);
                        masterLevelPayment.MaxCommission = SqlServerHelper.ToDecimal(vMaxCommission);
                    }
                    catch (Exception ex)
                    {
                        if (ex is NullReferenceException)
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

        public int Update(MasterLevelPayment masterLevelPayment)
        {
            int __rowsAffected = 0;

            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("MasterLevelPaymentUpdate"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure;

                // Add command parameters
                SqlParameter vPaymentLevel = new SqlParameter("@PaymentLevel", SqlDbType.Int);
                vPaymentLevel.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vPaymentLevel);
                SqlParameter vCommission = new SqlParameter("@Commission", SqlDbType.SmallMoney);
                vCommission.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vCommission);
                SqlParameter vInsuranceCommission = new SqlParameter("@InsuranceCommission", SqlDbType.SmallMoney);
                vInsuranceCommission.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vInsuranceCommission);
                SqlParameter vMaxCount = new SqlParameter("@MaxCount", SqlDbType.Int);
                vMaxCount.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vMaxCount);
                SqlParameter vMaxCommission = new SqlParameter("@MaxCommission", SqlDbType.Money);
                vMaxCommission.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vMaxCommission);

                // Set input parameter values
                SqlServerHelper.SetParameterValue(vPaymentLevel, masterLevelPayment.PaymentLevel);
                SqlServerHelper.SetParameterValue(vCommission, masterLevelPayment.Commission);
                SqlServerHelper.SetParameterValue(vInsuranceCommission, masterLevelPayment.InsuranceCommission);
                SqlServerHelper.SetParameterValue(vMaxCount, masterLevelPayment.MaxCount);
                SqlServerHelper.SetParameterValue(vMaxCommission, masterLevelPayment.MaxCommission);

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

        public int Delete(MasterLevelPayment masterLevelPayment)
        {
            int __rowsAffected = 0;

            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("MasterLevelPaymentDelete"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure;

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Add command parameters
                    SqlParameter vPaymentLevel = new SqlParameter("@PaymentLevel", SqlDbType.Int);
                    vPaymentLevel.Direction = ParameterDirection.Input;
                    sqlCommand.Parameters.Add(vPaymentLevel);

                    // Set input parameter values
                    SqlServerHelper.SetParameterValue(vPaymentLevel, masterLevelPayment.PaymentLevel);

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

        public int Insert(MasterLevelPayment masterLevelPayment)
        {
            int __rowsAffected = 0;

            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("MasterLevelPaymentInsert"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure;

                // Add command parameters
                SqlParameter vPaymentLevel = new SqlParameter("@PaymentLevel", SqlDbType.Int);
                vPaymentLevel.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vPaymentLevel);
                SqlParameter vCommission = new SqlParameter("@Commission", SqlDbType.SmallMoney);
                vCommission.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vCommission);
                SqlParameter vInsuranceCommission = new SqlParameter("@InsuranceCommission", SqlDbType.SmallMoney);
                vInsuranceCommission.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vInsuranceCommission);
                SqlParameter vMaxCount = new SqlParameter("@MaxCount", SqlDbType.Int);
                vMaxCount.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vMaxCount);
                SqlParameter vMaxCommission = new SqlParameter("@MaxCommission", SqlDbType.Money);
                vMaxCommission.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vMaxCommission);

                // Set input parameter values
                SqlServerHelper.SetParameterValue(vPaymentLevel, masterLevelPayment.PaymentLevel);
                SqlServerHelper.SetParameterValue(vCommission, masterLevelPayment.Commission);
                SqlServerHelper.SetParameterValue(vInsuranceCommission, masterLevelPayment.InsuranceCommission);
                SqlServerHelper.SetParameterValue(vMaxCount, masterLevelPayment.MaxCount);
                SqlServerHelper.SetParameterValue(vMaxCommission, masterLevelPayment.MaxCommission);

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

        public IReader<MasterLevelPayment> ListAll()
        {
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("MasterLevelPaymentListAll"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure;

                // Execute command
                SqlDataReader reader = sqlCommand.ExecuteReader(AttachReaderCommand(sqlCommand));

                // Return reader
                return new SqlServerMasterLevelPaymentReader(reader);
            }
        }

        #endregion
    }

    public partial class SqlServerMasterLevelPaymentReader : IReader<MasterLevelPayment>
    {
        private int _commissionOrdinal = -1;
        private int _insuranceCommissionOrdinal = -1;
        private MasterLevelPayment _masterLevelPayment;
        private int _maxCommissionOrdinal = -1;
        private int _maxCountOrdinal = -1;
        private int _paymentLevelOrdinal = -1;
        private SqlDataReader sqlDataReader;

        public SqlServerMasterLevelPaymentReader(SqlDataReader sqlDataReader)
        {
            this.sqlDataReader = sqlDataReader;
            for (int i = 0; i < sqlDataReader.FieldCount; i++)
            {
                string columnName = sqlDataReader.GetName(i);
                columnName = columnName.ToUpper();
                switch (columnName)
                {
                    case "PAYMENTLEVEL":
                        _paymentLevelOrdinal = i;
                        break;

                    case "COMMISSION":
                        _commissionOrdinal = i;
                        break;

                    case "INSURANCECOMMISSION":
                        _insuranceCommissionOrdinal = i;
                        break;

                    case "MAXCOUNT":
                        _maxCountOrdinal = i;
                        break;

                    case "MAXCOMMISSION":
                        _maxCommissionOrdinal = i;
                        break;
                }
            }
        }

        #region IReader<MasterLevelPayment> Implementation

        public bool Read()
        {
            _masterLevelPayment = null;
            return sqlDataReader.Read();
        }

        public MasterLevelPayment Current
        {
            get
            {
                if (_masterLevelPayment == null)
                {
                    _masterLevelPayment = new MasterLevelPayment();
                    if (_paymentLevelOrdinal != -1)
                    {
                        _masterLevelPayment.PaymentLevel = SqlServerHelper.ToInt32(sqlDataReader, _paymentLevelOrdinal);
                    }
                    if (_commissionOrdinal != -1)
                    {
                        _masterLevelPayment.Commission = SqlServerHelper.ToDecimal(sqlDataReader, _commissionOrdinal);
                    }
                    if (_insuranceCommissionOrdinal != -1)
                    {
                        _masterLevelPayment.InsuranceCommission = SqlServerHelper.ToDecimal(sqlDataReader,
                                                                                            _insuranceCommissionOrdinal);
                    }
                    if (_maxCountOrdinal != -1)
                    {
                        _masterLevelPayment.MaxCount = SqlServerHelper.ToInt32(sqlDataReader, _maxCountOrdinal);
                    }
                    if (_maxCommissionOrdinal != -1)
                    {
                        _masterLevelPayment.MaxCommission = SqlServerHelper.ToDecimal(sqlDataReader,
                                                                                      _maxCommissionOrdinal);
                    }
                }


                return _masterLevelPayment;
            }
        }

        public void Close()
        {
            sqlDataReader.Close();
        }

        public List<MasterLevelPayment> ToList()
        {
            List<MasterLevelPayment> list = new List<MasterLevelPayment>();
            while (Read())
            {
                list.Add(Current);
            }
            Close();
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

        #region IEnumerable<MasterLevelPayment> Implementation

        public IEnumerator<MasterLevelPayment> GetEnumerator()
        {
            return new MasterLevelPaymentEnumerator(this);
        }

        #endregion

        #region IEnumerable Implementation

        IEnumerator IEnumerable.GetEnumerator()
        {
            return new MasterLevelPaymentEnumerator(this);
        }

        #endregion

        #region Nested type: MasterLevelPaymentEnumerator

        private partial class MasterLevelPaymentEnumerator : IEnumerator<MasterLevelPayment>
        {
            private IReader<MasterLevelPayment> masterLevelPaymentReader;

            public MasterLevelPaymentEnumerator(IReader<MasterLevelPayment> masterLevelPaymentReader)
            {
                this.masterLevelPaymentReader = masterLevelPaymentReader;
            }

            #region IEnumerator<MasterLevelPayment> Members

            public MasterLevelPayment Current
            {
                get { return masterLevelPaymentReader.Current; }
            }

            public void Dispose()
            {
                masterLevelPaymentReader.Dispose();
            }

            object IEnumerator.Current
            {
                get { return masterLevelPaymentReader.Current; }
            }

            public bool MoveNext()
            {
                return masterLevelPaymentReader.Read();
            }

            public void Reset()
            {
                throw new Exception("Reset of masterlevelpayment reader is not supported.");
            }

            #endregion
        }

        #endregion
    }
}