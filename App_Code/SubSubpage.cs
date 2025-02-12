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
    public partial class SubSubpage
    {
        private static ISubSubpagePersister _DefaultPersister;
        private ISubSubpagePersister _Persister;
        private int _SubSubpageid;
        private int _SubPageID;
        private int _MasterPageID;
        private string _PageTitle;
        private string _PageName;
        private DateTime _ModifiedDate;
        private int? _Status;

        static SubSubpage()
        {
            // Assign default persister
            _DefaultPersister = new SqlServerSubSubpagePersister();
        }

        public SubSubpage()
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister; 
        }

        public SubSubpage(int _SubSubpageid)
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister; 

            // Assign method parameter to private fields
            this._SubSubpageid = _SubSubpageid; 

            // Call associated retrieve method
            Retrieve();
        }

        public SubSubpage(DataRow row)
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister; 

            // Assign column values to private members
            for (int  i = 0; i < row.Table.Columns.Count; i++)
            {
                switch (row.Table.Columns[i].ColumnName.ToUpper())
                {
                    case "SUBSUBPAGEID":
                        this.SubSubpageid = Convert.ToInt32(row[i, DataRowVersion.Current]); 
                        break;
                    
                    case "SUBPAGEID":
                        this.SubPageID = Convert.ToInt32(row[i, DataRowVersion.Current]); 
                        break;
                    
                    case "MASTERPAGEID":
                        this.MasterPageID = Convert.ToInt32(row[i, DataRowVersion.Current]); 
                        break;
                    
                    case "PAGETITLE":
                        this.PageTitle = (string)row[i, DataRowVersion.Current]; 
                        break;
                    
                    case "PAGENAME":
                        this.PageName = (string)row[i, DataRowVersion.Current]; 
                        break;
                    
                    case "MODIFIEDDATE":
                        this.ModifiedDate = Convert.ToDateTime(row[i, DataRowVersion.Current]); 
                        break;
                    
                    case "STATUS":
                        if(row.IsNull(i) == false)
                        {
                            this.Status = Convert.ToInt32(row[i, DataRowVersion.Current]); 
                        }
                        break;
                    
                }
            }
        }

        public static ISubSubpagePersister DefaultPersister
        {
            get { return _DefaultPersister; }
            set { _DefaultPersister = value; }
        }

        public ISubSubpagePersister Persister
        {
            get { return _Persister; }
            set { _Persister = value; }
        }

        public int SubSubpageid
        {
            get { return _SubSubpageid; }
            set { _SubSubpageid = value; }
        }

        public int SubPageID
        {
            get { return _SubPageID; }
            set { _SubPageID = value; }
        }

        public int MasterPageID
        {
            get { return _MasterPageID; }
            set { _MasterPageID = value; }
        }

        public string PageTitle
        {
            get { return _PageTitle; }
            set { _PageTitle = value; }
        }

        public string PageName
        {
            get { return _PageName; }
            set { _PageName = value; }
        }

        public DateTime ModifiedDate
        {
            get { return _ModifiedDate; }
            set { _ModifiedDate = value; }
        }

        public int? Status
        {
            get { return _Status; }
            set { _Status = value; }
        }

        public virtual void Clone(SubSubpage sourceObject)
        {
            // Clone attributes from source object
            this._SubSubpageid = sourceObject.SubSubpageid; 
            this._SubPageID = sourceObject.SubPageID; 
            this._MasterPageID = sourceObject.MasterPageID; 
            this._PageTitle = sourceObject.PageTitle; 
            this._PageName = sourceObject.PageName; 
            this._ModifiedDate = sourceObject.ModifiedDate; 
            this._Status = sourceObject.Status; 
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

        public static IReader<SubSubpage> ListAll()
        {
            return _DefaultPersister.ListAll(); 
        }

        public static IReader<SubSubpage> ListForSubPageID(int subPageID)
        {
            return _DefaultPersister.ListForSubPageID(subPageID); 
        }

    }
    
    public partial interface ISubSubpagePersister
    {
        int Retrieve(SubSubpage subSubpage);
        int Update(SubSubpage subSubpage);
        int Delete(SubSubpage subSubpage);
        int Insert(SubSubpage subSubpage);
        IReader<SubSubpage> ListAll();
        IReader<SubSubpage> ListForSubPageID(int subPageID);
    }
    
    public partial class SqlServerSubSubpagePersister : SqlPersisterBase, ISubSubpagePersister
    {
        public SqlServerSubSubpagePersister()
        {
        }

        public SqlServerSubSubpagePersister(string connectionString) : base(connectionString)
        {
        }

        public SqlServerSubSubpagePersister(SqlConnection connection) : base(connection)
        {
        }

        public SqlServerSubSubpagePersister(SqlTransaction transaction) : base(transaction)
        {
        }

        public int Retrieve(SubSubpage subSubpage)
        {
            int __rowsAffected = 1;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("SubSubpageGet"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Add command parameters
                    SqlParameter vSubSubpageid = new SqlParameter("@SubSubpageid", SqlDbType.Int);
                    vSubSubpageid.Direction = ParameterDirection.InputOutput; 
                    sqlCommand.Parameters.Add(vSubSubpageid);
                    SqlParameter vSubPageID = new SqlParameter("@SubPageID", SqlDbType.Int);
                    vSubPageID.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vSubPageID);
                    SqlParameter vMasterPageID = new SqlParameter("@MasterPageID", SqlDbType.Int);
                    vMasterPageID.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vMasterPageID);
                    SqlParameter vPageTitle = new SqlParameter("@PageTitle", SqlDbType.VarChar, 250);
                    vPageTitle.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vPageTitle);
                    SqlParameter vPageName = new SqlParameter("@PageName", SqlDbType.VarChar, 250);
                    vPageName.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vPageName);
                    SqlParameter vModifiedDate = new SqlParameter("@ModifiedDate", SqlDbType.DateTime);
                    vModifiedDate.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vModifiedDate);
                    SqlParameter vStatus = new SqlParameter("@Status", SqlDbType.Int);
                    vStatus.Direction = ParameterDirection.Output; 
                    sqlCommand.Parameters.Add(vStatus);

                    // Set input parameter values
                    SqlServerHelper.SetParameterValue(vSubSubpageid, subSubpage.SubSubpageid);

                    // Execute command
                    sqlCommand.ExecuteNonQuery();

                    try
                    {
                        // Get output parameter values
                        subSubpage.SubSubpageid = SqlServerHelper.ToInt32(vSubSubpageid); 
                        subSubpage.SubPageID = SqlServerHelper.ToInt32(vSubPageID); 
                        subSubpage.MasterPageID = SqlServerHelper.ToInt32(vMasterPageID); 
                        subSubpage.PageTitle = SqlServerHelper.ToString(vPageTitle); 
                        subSubpage.PageName = SqlServerHelper.ToString(vPageName); 
                        subSubpage.ModifiedDate = SqlServerHelper.ToDateTime(vModifiedDate); 
                        subSubpage.Status = SqlServerHelper.ToNullableInt32(vStatus); 

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

        public int Update(SubSubpage subSubpage)
        {
            int __rowsAffected = 0;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("SubSubpageUpdate"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Add command parameters
                SqlParameter vSubSubpageid = new SqlParameter("@SubSubpageid", SqlDbType.Int);
                vSubSubpageid.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vSubSubpageid);
                SqlParameter vSubPageID = new SqlParameter("@SubPageID", SqlDbType.Int);
                vSubPageID.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vSubPageID);
                SqlParameter vMasterPageID = new SqlParameter("@MasterPageID", SqlDbType.Int);
                vMasterPageID.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vMasterPageID);
                SqlParameter vPageTitle = new SqlParameter("@PageTitle", SqlDbType.VarChar, 250);
                vPageTitle.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vPageTitle);
                SqlParameter vPageName = new SqlParameter("@PageName", SqlDbType.VarChar, 250);
                vPageName.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vPageName);
                SqlParameter vModifiedDate = new SqlParameter("@ModifiedDate", SqlDbType.DateTime);
                vModifiedDate.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vModifiedDate);
                SqlParameter vStatus = new SqlParameter("@Status", SqlDbType.Int);
                vStatus.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vStatus);

                // Set input parameter values
                SqlServerHelper.SetParameterValue(vSubSubpageid, subSubpage.SubSubpageid);
                SqlServerHelper.SetParameterValue(vSubPageID, subSubpage.SubPageID);
                SqlServerHelper.SetParameterValue(vMasterPageID, subSubpage.MasterPageID);
                SqlServerHelper.SetParameterValue(vPageTitle, subSubpage.PageTitle);
                SqlServerHelper.SetParameterValue(vPageName, subSubpage.PageName);
                SqlServerHelper.SetParameterValue(vModifiedDate, subSubpage.ModifiedDate);
                SqlServerHelper.SetParameterValue(vStatus, subSubpage.Status);

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

        public int Delete(SubSubpage subSubpage)
        {
            int __rowsAffected = 0;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("SubSubpageDelete"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Add command parameters
                    SqlParameter vSub_SubPageID = new SqlParameter("@Sub_SubPageID", SqlDbType.Int);
                    vSub_SubPageID.Direction = ParameterDirection.Input; 
                    sqlCommand.Parameters.Add(vSub_SubPageID);

                    // Set input parameter values
                    SqlServerHelper.SetParameterValue(vSub_SubPageID, subSubpage.SubSubpageid);

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

        public int Insert(SubSubpage subSubpage)
        {
            int __rowsAffected = 0;
            
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("SubSubpageInsert"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Add command parameters
                SqlParameter vSubSubpageid = new SqlParameter("@SubSubpageid", SqlDbType.Int);
                vSubSubpageid.Direction = ParameterDirection.InputOutput; 
                sqlCommand.Parameters.Add(vSubSubpageid);
                SqlParameter vSubPageID = new SqlParameter("@SubPageID", SqlDbType.Int);
                vSubPageID.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vSubPageID);
                SqlParameter vMasterPageID = new SqlParameter("@MasterPageID", SqlDbType.Int);
                vMasterPageID.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vMasterPageID);
                SqlParameter vPageTitle = new SqlParameter("@PageTitle", SqlDbType.VarChar, 250);
                vPageTitle.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vPageTitle);
                SqlParameter vPageName = new SqlParameter("@PageName", SqlDbType.VarChar, 250);
                vPageName.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vPageName);
                SqlParameter vModifiedDate = new SqlParameter("@ModifiedDate", SqlDbType.DateTime);
                vModifiedDate.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vModifiedDate);
                SqlParameter vStatus = new SqlParameter("@Status", SqlDbType.Int);
                vStatus.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vStatus);

                // Set input parameter values
                SqlServerHelper.SetParameterValue(
                    vSubSubpageid, 
                    subSubpage.SubSubpageid, 
                    0);
                SqlServerHelper.SetParameterValue(vSubPageID, subSubpage.SubPageID);
                SqlServerHelper.SetParameterValue(vMasterPageID, subSubpage.MasterPageID);
                SqlServerHelper.SetParameterValue(vPageTitle, subSubpage.PageTitle);
                SqlServerHelper.SetParameterValue(vPageName, subSubpage.PageName);
                SqlServerHelper.SetParameterValue(vModifiedDate, subSubpage.ModifiedDate);
                SqlServerHelper.SetParameterValue(vStatus, subSubpage.Status);

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
                    subSubpage.SubSubpageid = SqlServerHelper.ToInt32(vSubSubpageid); 

                }
                finally
                {
                    // Detach command
                    DetachCommand(sqlCommand);
                }

            }
            
            return __rowsAffected; 
        }

        public IReader<SubSubpage> ListAll()
        {
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("SubSubpageListAll"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Execute command
                SqlDataReader reader = sqlCommand.ExecuteReader(AttachReaderCommand(sqlCommand));

                // Return reader
                return new SqlServerSubSubpageReader(reader); 
            }
        }

        public IReader<SubSubpage> ListForSubPageID(int subPageID)
        {
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("SubSubpageListForSubPageID"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure; 

                // Add command parameters
                SqlParameter vSubPageID = new SqlParameter("@SubPageID", SqlDbType.Int);
                vSubPageID.Direction = ParameterDirection.Input; 
                sqlCommand.Parameters.Add(vSubPageID);
                
                // Set input parameter values
                SqlServerHelper.SetParameterValue(vSubPageID, subPageID);

                // Execute command
                SqlDataReader reader = sqlCommand.ExecuteReader(AttachReaderCommand(sqlCommand));

                // Return reader
                return new SqlServerSubSubpageReader(reader); 
            }
        }

    }

    public partial class SqlServerSubSubpageReader : IReader<SubSubpage>
    {
        private SqlDataReader sqlDataReader;

        private SubSubpage _SubSubpage;

        private int _SubSubpageidOrdinal = -1;
        private int _SubPageIDOrdinal = -1;
        private int _MasterPageIDOrdinal = -1;
        private int _PageTitleOrdinal = -1;
        private int _PageNameOrdinal = -1;
        private int _ModifiedDateOrdinal = -1;
        private int _StatusOrdinal = -1;

        public SqlServerSubSubpageReader(SqlDataReader sqlDataReader)
        {
            this.sqlDataReader = sqlDataReader; 
            for (int  i = 0; i < sqlDataReader.FieldCount; i++)
            {
                string columnName = sqlDataReader.GetName(i);
                columnName = columnName.ToUpper(); 
                switch (columnName)
                {
                    case "SUBSUBPAGEID":
                        _SubSubpageidOrdinal = i; 
                        break;
                    
                    case "SUBPAGEID":
                        _SubPageIDOrdinal = i; 
                        break;
                    
                    case "MASTERPAGEID":
                        _MasterPageIDOrdinal = i; 
                        break;
                    
                    case "PAGETITLE":
                        _PageTitleOrdinal = i; 
                        break;
                    
                    case "PAGENAME":
                        _PageNameOrdinal = i; 
                        break;
                    
                    case "MODIFIEDDATE":
                        _ModifiedDateOrdinal = i; 
                        break;
                    
                    case "STATUS":
                        _StatusOrdinal = i; 
                        break;
                    
                }
            }
        }

        #region IReader<SubSubpage> Implementation
        
        public bool Read()
        {
            _SubSubpage = null; 
            return this.sqlDataReader.Read(); 
        }

        public SubSubpage Current
        {
            get
            {
                if(_SubSubpage == null)
                {
                    _SubSubpage = new SubSubpage();
                    if(_SubSubpageidOrdinal != -1)
                    {
                        _SubSubpage.SubSubpageid = SqlServerHelper.ToInt32(sqlDataReader, _SubSubpageidOrdinal); 
                    }
                    if(_SubPageIDOrdinal != -1)
                    {
                        _SubSubpage.SubPageID = SqlServerHelper.ToInt32(sqlDataReader, _SubPageIDOrdinal); 
                    }
                    if(_MasterPageIDOrdinal != -1)
                    {
                        _SubSubpage.MasterPageID = SqlServerHelper.ToInt32(sqlDataReader, _MasterPageIDOrdinal); 
                    }
                    _SubSubpage.PageTitle = SqlServerHelper.ToString(sqlDataReader, _PageTitleOrdinal); 
                    _SubSubpage.PageName = SqlServerHelper.ToString(sqlDataReader, _PageNameOrdinal); 
                    if(_ModifiedDateOrdinal != -1)
                    {
                        _SubSubpage.ModifiedDate = SqlServerHelper.ToDateTime(sqlDataReader, _ModifiedDateOrdinal); 
                    }
                    _SubSubpage.Status = SqlServerHelper.ToNullableInt32(sqlDataReader, _StatusOrdinal); 
                }
                

                return _SubSubpage; 
            }
        }

        public void Close()
        {
            sqlDataReader.Close();
        }

        public List<SubSubpage> ToList()
        {
            List<SubSubpage> list = new List<SubSubpage>();
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
        
        #region IEnumerable<SubSubpage> Implementation
        
        public IEnumerator<SubSubpage> GetEnumerator()
        {
            return new SubSubpageEnumerator(this); 
        }

        #endregion
        
        #region IEnumerable Implementation
        
        IEnumerator IEnumerable.GetEnumerator()
        {
            return new SubSubpageEnumerator(this); 
        }

        #endregion
        
        
        private partial class SubSubpageEnumerator : IEnumerator<SubSubpage>
        {
            private IReader<SubSubpage> subSubpageReader;

            public SubSubpageEnumerator(IReader<SubSubpage> subSubpageReader)
            {
                this.subSubpageReader = subSubpageReader; 
            }

            #region IEnumerator<SubSubpage> Members
            
            public SubSubpage Current
            {
                get { return this.subSubpageReader.Current; }
            }

            #endregion
            
            #region IDisposable Members
            
            public void Dispose()
            {
                this.subSubpageReader.Dispose();
            }

            #endregion
            
            #region IEnumerator Members
            
            object IEnumerator.Current
            {
                get { return this.subSubpageReader.Current; }
            }

            public bool MoveNext()
            {
                return this.subSubpageReader.Read(); 
            }

            public void Reset()
            {
                throw new Exception("Reset of subsubpage reader is not supported."); 
            }

            #endregion
            
        }
    }
}
