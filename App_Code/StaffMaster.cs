
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.IO;
using Microsoft.ApplicationBlocks1.Data;
using CommonLibrary;
using System.Configuration;

namespace JTMSProject
{
    public partial class StaffMaster : CommonFunctions
    {
        private static IStaffMasterPersister _DefaultPersister;
        private IStaffMasterPersister _Persister;
        private int _StaffCode;
        private int? _CompId;
        private int? _CLTId;
        private string _StaffName;
        private string _Addr1;
        private string _Addr2;
        private string _Addr3;
        private string _City;
        private string _Mobile;
        private string _Email;
        private int? _DepId;
        private int? _DsgId;
        private int? _BrId;
        private int? _Staffrole;
        private DateTime? _DateOfJoining;
        private DateTime? _DateOfLeaving;
        private double? _HourlyCharges;
        private double? _CurMonthSal;
        private string _username;
        private string _password;
        private string _Role;
        private string _Qual;
        private DateTime? _YrGd;
        private DateTime? _YrPG;
        private DateTime? _YrRj;
        private bool? _IsApproved;
        private Guid? _UserId;
        private DateTime? _LastLogin;
        private int? _Logins;
        private bool? _Job_dept;
        private bool? _IsDeleted;
        private int? _rollID;
        private bool? _ishod;
        private string _EmpType;

        static StaffMaster()
        {
            // Assign default persister
            _DefaultPersister = new SqlServerStaffMasterPersister();
        }

        public StaffMaster()
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister;
        }

        public StaffMaster(int _StaffCode)
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister;

            // Assign method parameter to private fields
            this._StaffCode = _StaffCode;

            // Call associated retrieve method
            Retrieve();
        }

        public StaffMaster(DataRow row)
        {
            // Assign default persister to instance persister
            _Persister = _DefaultPersister;

            // Assign column values to private members
            for (int i = 0; i < row.Table.Columns.Count; i++)
            {
                switch (row.Table.Columns[i].ColumnName.ToUpper())
                {
                    case "STAFFCODE":
                        this.StaffCode = Convert.ToInt32(row[i, DataRowVersion.Current]);
                        break;

                    case "COMPID":
                        if (row.IsNull(i) == false)
                        {
                            this.CompId = Convert.ToInt32(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "CLTID":
                        if (row.IsNull(i) == false)
                        {
                            this.CLTId = Convert.ToInt32(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "STAFFNAME":
                        if (row.IsNull(i) == false)
                        {
                            this.StaffName = (string)row[i, DataRowVersion.Current];
                        }
                        break;

                    case "ADDR1":
                        if (row.IsNull(i) == false)
                        {
                            this.Addr1 = (string)row[i, DataRowVersion.Current];
                        }
                        break;

                    case "ADDR2":
                        if (row.IsNull(i) == false)
                        {
                            this.Addr2 = (string)row[i, DataRowVersion.Current];
                        }
                        break;

                    case "ADDR3":
                        if (row.IsNull(i) == false)
                        {
                            this.Addr3 = (string)row[i, DataRowVersion.Current];
                        }
                        break;

                    case "CITY":
                        if (row.IsNull(i) == false)
                        {
                            this.City = (string)row[i, DataRowVersion.Current];
                        }
                        break;

                    case "MOBILE":
                        if (row.IsNull(i) == false)
                        {
                            this.Mobile = (string)row[i, DataRowVersion.Current];
                        }
                        break;

                    case "EMAIL":
                        if (row.IsNull(i) == false)
                        {
                            this.Email = (string)row[i, DataRowVersion.Current];
                        }
                        break;

                    case "DEPID":
                        if (row.IsNull(i) == false)
                        {
                            this.DepId = Convert.ToInt32(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "DSGID":
                        if (row.IsNull(i) == false)
                        {
                            this.DsgId = Convert.ToInt32(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "BRID":
                        if (row.IsNull(i) == false)
                        {
                            this.BrId = Convert.ToInt32(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "STAFF_ROLE":
                        if(row.IsNull(i) == false)
                        {
                            this.BrId = Convert.ToInt32(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "DATEOFJOINING":
                        if (row.IsNull(i) == false)
                        {
                            this.DateOfJoining = Convert.ToDateTime(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "DATEOFLEAVING":
                        if (row.IsNull(i) == false)
                        {
                            this.DateOfLeaving = Convert.ToDateTime(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "HOURLYCHARGES":
                        if (row.IsNull(i) == false)
                        {
                            this.HourlyCharges = Convert.ToDouble(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "CURMONTHSAL":
                        if (row.IsNull(i) == false)
                        {
                            this.CurMonthSal = Convert.ToDouble(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "USERNAME":
                        if (row.IsNull(i) == false)
                        {
                            this.username = (string)row[i, DataRowVersion.Current];
                        }
                        break;

                    case "PASSWORD":
                        if (row.IsNull(i) == false)
                        {
                            this.password = (string)row[i, DataRowVersion.Current];
                        }
                        break;
                        

                    case "ROLE":
                        if (row.IsNull(i) == false)
                        {
                            this.Role = (string)row[i, DataRowVersion.Current];
                        }
                        break;
                    case "QUAL":
                        if (row.IsNull(i) == false)
                        {
                            this.Qual = (string)row[i, DataRowVersion.Current];
                        }
                        break;

                    case "YRGD":
                        if (row.IsNull(i) == false)
                        {
                            this.YrGd = Convert.ToDateTime(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "YRPG":
                        if (row.IsNull(i) == false)
                        {
                            this.YrPG = Convert.ToDateTime(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "YRRJ":
                        if (row.IsNull(i) == false)
                        {
                            this.YrRj = Convert.ToDateTime(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "ISAPPROVED":
                        if (row.IsNull(i) == false)
                        {
                            this.IsApproved = Convert.ToBoolean(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "USERID":
                        if (row.IsNull(i) == false)
                        {
                            if (row[i, DataRowVersion.Current] is Guid)
                            {
                                this.UserId = (Guid)row[i, DataRowVersion.Current];
                            }
                            else
                            {
                                this.UserId = new Guid((Byte[])row[i, DataRowVersion.Current]);
                            }
                        }
                        break;

                    case "LASTLOGIN":
                        if (row.IsNull(i) == false)
                        {
                            this.LastLogin = Convert.ToDateTime(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "LOGINS":
                        if (row.IsNull(i) == false)
                        {
                            this.Logins = Convert.ToInt32(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "ISDELETED":
                        if (row.IsNull(i) == false)
                        {
                            this.IsDeleted = Convert.ToBoolean(row[i, DataRowVersion.Current]);
                        }
                        break;
                    case "JobDEP":
                        if (row.IsNull(i) == false)
                        {
                            this.JobDep = Convert.ToBoolean(row[i, DataRowVersion.Current]);
                        }
                        break;

                    case "EmpType":
                        if (row.IsNull(i) == false)
                        {
                            this.EmpType = (string)row[i, DataRowVersion.Current];
                        }
                        break;
                }
            }
        }



        public SqlDataReader GetIenumrable_sRegistration_Job(vw_JobnClientnStaff obj)
        {
            try
            {
                SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
                SqlParameter[] param = new SqlParameter[3];
                param[0] = new SqlParameter("@CompanyID", obj.CompId);
                param[1] = new SqlParameter("@PageIndex", obj.pageIndex);
                param[2] = new SqlParameter("@PageSize", obj.pageNewSize);

                return SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_sRegistration_Job", param);
            }
            catch (Exception ex)
            {
                PrintError(ex, "JobMaster");
                return null;

            }
        }

        public IEnumerable<tbl_mjob_dept> SqlDR_GetIenumrable_sRegistration_Job(vw_JobnClientnStaff obj)
        {
            try
            {
                List<tbl_mjob_dept> tbl = new List<tbl_mjob_dept>();

                using (SqlDataReader drrr = GetIenumrable_sRegistration_Job(obj))
                {
                    while (drrr.Read())
                    {
                        tbl.Add(new tbl_mjob_dept()
                        {
                            Jobid = GetValue<int>(drrr["Jobid"].ToString()),
                            Cltid = GetValue<int>(drrr["Cltid"].ToString()),
                            MJobName = GetValue<string>(drrr["MJobName"].ToString()),
                            Departments = GetValue<string>(drrr["DID"].ToString()),
                        });
                    }

                }
                return tbl as IEnumerable<tbl_mjob_dept>;
            }
            catch (Exception ex)
            {
                PrintError(ex, "JobMaster");
                return null;
            }
        }






        public SqlDataReader GetIenumrable_Job(vw_JobnClientnStaff obj)
        {
            try
            {
                SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
                SqlParameter[] param = new SqlParameter[4];
                param[0] = new SqlParameter("@CompanyID", obj.CompId);
                param[1] = new SqlParameter("@PageIndex", obj.pageIndex);
                param[2] = new SqlParameter("@PageSize", obj.pageNewSize);
                param[3] = new SqlParameter("@Staffcode", obj.StaffCode);
                //DataSet ds = SqlHelper.ExecuteDataset (sqlConn, CommandType.StoredProcedure, "usp_vw_JobnClientnStaff", param);
                return SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_vw_JobnClientnStaff", param);
            }
            catch (Exception ex)
            {
                PrintError(ex, "JobMaster");
                return null;

            }
        }

        public IEnumerable<tbl_mjob_dept> SqlDR_GetIenumrable_Job(vw_JobnClientnStaff obj)
        {
            try
            {
                List<tbl_mjob_dept> tbl = new List<tbl_mjob_dept>();

                using (SqlDataReader drrr = GetIenumrable_Job(obj))
                {
                    while (drrr.Read())
                    {
                        tbl.Add(new tbl_mjob_dept()
                        {
                            Jobid = GetValue<int>(drrr["Jobid"].ToString()),
                            Cltid = GetValue<int>(drrr["Cltid"].ToString()),
                            //ClientName = GetValue<string>(drrr["ClientName"].ToString()),
                            MJobName = GetValue<string>(drrr["MJobName"].ToString()),
                            ischecked = GetValue<int>(drrr["ischecked"].ToString()),
                            Departments = GetValue<string>(drrr["DID"].ToString()),
                        });
                    }

                }
                return tbl as IEnumerable<tbl_mjob_dept>;
            }
            catch (Exception ex)
            {
                PrintError(ex, "JobMaster");
                return null;
            }
        }




        public SqlDataReader GetIenumrable_sRegistration_Client(Client_Master obj)
        {
            try
            {
                SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
                SqlParameter[] param = new SqlParameter[1];
                param[0] = new SqlParameter("@CompanyID", obj.CompId);

                return SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_sRegistration_Client", param);
            }
            catch (Exception ex)
            {
                PrintError(ex, "ClientMaster");
                return null;

            }
        }

        public IEnumerable<Client_Master> SqlDR_GetIenumrable_sRegistration_Client(Client_Master obj)
        {
            try
            {
                List<Client_Master> tbl = new List<Client_Master>();


                using (SqlDataReader drrr = GetIenumrable_sRegistration_Client(obj))
                {
                    while (drrr.Read())
                    {
                        tbl.Add(new Client_Master()
                        {
                            CLTId = GetValue<int>(drrr["Cltid"].ToString()),
                            ClientName = GetValue<string>(drrr["ClientName"].ToString()),

                        });
                    }
                }
                return tbl as IEnumerable<Client_Master>;
            }
            catch (Exception ex)
            {
                PrintError(ex, "ClientMaster");
                return null;
            }
        }




        public SqlDataReader GetIenumrable_Client(Client_Master obj)
        {
            try
            {
                SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
                SqlParameter[] param = new SqlParameter[2];
                param[0] = new SqlParameter("@CompanyID", obj.CompId);
                param[1] = new SqlParameter("@Staffcode", obj.StaffCode);
                return SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_ClientMasterGet", param);
            }
            catch (Exception ex)
            {
                PrintError(ex, "ClientMaster");
                return null;

            }
        }

        public IEnumerable<Client_Master> SqlDR_GetIenumrable_Client(Client_Master obj)
        {
            try
            {
                List<Client_Master> tbl = new List<Client_Master>();


                using (SqlDataReader drrr = GetIenumrable_Client(obj))
                {
                    while (drrr.Read())
                    {
                        tbl.Add(new Client_Master()
                        {
                            CLTId = GetValue<int>(drrr["Cltid"].ToString()),
                            ClientName = GetValue<string>(drrr["ClientName"].ToString()),
                            ischecked = GetValue<int>(drrr["ischecked"].ToString()),
                        });
                    }
                }
                return tbl as IEnumerable<Client_Master>;
            }
            catch (Exception ex)
            {
                PrintError(ex, "ClientMaster");
                return null;
            }
        }




        public SqlDataReader Sql_Hrly_Details(HourlyCharges obj)
        {
            try
            {
                SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
                SqlParameter[] param = new SqlParameter[2];
                param[0] = new SqlParameter("@Company_ID", obj.compid);
                param[1] = new SqlParameter("@Staffcode", obj.StaffCode);
                return SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Hourly_Details", param);
            }
            catch (Exception ex)
            {
                PrintError(ex, "ClientMaster");
                return null;

            }
        }

        public IEnumerable<HourlyCharges> Hrly_Details(HourlyCharges obj)
        {
            try
            {
                List<HourlyCharges> tbl = new List<HourlyCharges>();


                using (SqlDataReader drrr = Sql_Hrly_Details(obj))
                {
                    while (drrr.Read())
                    {
                        tbl.Add(new HourlyCharges()
                        {
                            HrlyID = GetValue<int>(drrr["id"].ToString()),
                            HCharges = GetValue<float>(drrr["hourlycharges"].ToString()),
                            frDate = GetValue<string>(drrr["fr"].ToString()),
                            toDate = GetValue<string>(drrr["todate"].ToString()),
                        });
                    }
                }
                return tbl as IEnumerable<HourlyCharges>;
            }
            catch (Exception ex)
            {
                PrintError(ex, "HourlyCharges");
                return null;
            }
        }


        public SqlDataReader Sql_GetDATES(HourlyCharges obj)
        {
            try
            {
                SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
                SqlParameter[] param = new SqlParameter[2];
                param[0] = new SqlParameter("@Company_ID", obj.compid);
                param[1] = new SqlParameter("@Staffcode", obj.StaffCode);
                return SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Get_Staff_Details", param);
            }
            catch (Exception ex)
            {
                PrintError(ex, "ClientMaster");
                return null;

            }
        }

        public IEnumerable<HourlyCharges> Join_DT(HourlyCharges obj)
        {
            try
            {
                List<HourlyCharges> tbl = new List<HourlyCharges>();


                using (SqlDataReader drrr = Sql_GetDATES(obj))
                {
                    while (drrr.Read())
                    {
                        tbl.Add(new HourlyCharges()
                        {
                            JoinDT  = GetValue<string>(drrr["JDT"].ToString()),
                        });
                    }
                }
                return tbl as IEnumerable<HourlyCharges>;
            }
            catch (Exception ex)
            {
                PrintError(ex, "HourlyCharges");
                return null;
            }
        }


        public IEnumerable<HourlyCharges> Leaving_DT(HourlyCharges obj)
        {
            try
            {
                List<HourlyCharges> tbl = new List<HourlyCharges>();

                using (SqlDataReader drrr = Sql_GetDATES(obj))
                {
                    while (drrr.Read())
                    {

                        tbl.Add(new HourlyCharges()
                        {
                            ResignDT = GetValue<string>(drrr["LDT"].ToString()),
                        });
                    }
                }
                return tbl as IEnumerable<HourlyCharges>;
            }
            catch (Exception ex)
            {
                PrintError(ex, "HourlyCharges");
                return null;
            }
        }

        public IEnumerable<HourlyCharges> Get_Password(HourlyCharges obj)
        {
            try
            {
                List<HourlyCharges> tbl = new List<HourlyCharges>();


                using (SqlDataReader drrr = Sql_GetDATES(obj))
                {
                    while (drrr.Read())
                    {
                        tbl.Add(new HourlyCharges()
                        {
                            UPass = GetValue<string>(drrr["password"].ToString()),
                            UserID = GetValue<string>(drrr["userid"].ToString()),
                        });
                    }
                }
                return tbl as IEnumerable<HourlyCharges>;
            }
            catch (Exception ex)
            {
                PrintError(ex, "HourlyCharges");
                return null;
            }
        }
        public IEnumerable<HourlyCharges> Get_rollID(HourlyCharges obj)
        {
            try
            {
                List<HourlyCharges> tbl = new List<HourlyCharges>();
                using (SqlDataReader drrr = Sql_GetDATES(obj))
                {
                    while (drrr.Read())
                    { 
                    tbl.Add(new HourlyCharges()
                        {
                            rollid = GetValue<int>(drrr["Staff_roll"].ToString()),
                            UserID = GetValue<string>(drrr["userid"].ToString()),
                        });
                    }
                    }
                    return tbl as IEnumerable<HourlyCharges>;
                
           
            }
                 catch(Exception ex)
            {
                PrintError(ex,"HourlyCharges");
                    return null;
                }
        }

        public DataSet  Get_Timesheet_Details(HourlyCharges obj)
        {
            try
            {
                SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
                SqlParameter[] param = new SqlParameter[2];
                param[0] = new SqlParameter("@Company_ID", obj.compid);
                param[1] = new SqlParameter("@hid", obj.HrlyID );
                return SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "usp_Hourly_Timesheet_Details", param);
            }
            catch (Exception ex)
            {
                PrintError(ex, "Hourly");
                return null;

            }
        }

        public IEnumerable<HourlyCharges> Hrly_Timesheet_Details(HourlyCharges obj)
        {
            try
            {
                List<HourlyCharges> tbl = new List<HourlyCharges>();
                int i = 0;
                DataSet ds = new DataSet(); 
                ds= Get_Timesheet_Details(obj);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    // do not delete
                    i = Convert.ToInt32(ds.Tables[0].Rows[0][0].ToString() );
                }
                else
                {
                    // delete
                    i = 0;
                }
                    tbl.Add(new HourlyCharges()
                        {
                            HrlyID = i,
                        });

                return tbl as IEnumerable<HourlyCharges>;
            }
            catch (Exception ex)
            {
                PrintError(ex, "HourlyCharges");
                return null;
            }
        }


        public DataSet Get_date_Details(int compid, int hid, int stfcode, DateTime fr)
        {
            try
            {
                SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
                SqlParameter[] param = new SqlParameter[4];
                param[0] = new SqlParameter("@Company_ID", compid);
                param[1] = new SqlParameter("@Staffcode", stfcode);
                param[2] = new SqlParameter("@hid", hid);
                param[3] = new SqlParameter("@fr", fr);


                return SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "usp_Hourly_EditDetails", param);
            }
            catch (Exception ex)
            {

                return null;

            }
        }

        public static IStaffMasterPersister DefaultPersister
        {
            get { return _DefaultPersister; }
            set { _DefaultPersister = value; }
        }

        public IStaffMasterPersister Persister
        {
            get { return _Persister; }
            set { _Persister = value; }
        }

        public int StaffCode
        {
            get { return _StaffCode; }
            set { _StaffCode = value; }
        }

        public int? CompId
        {
            get { return _CompId; }
            set { _CompId = value; }
        }

        public int? CLTId
        {
            get { return _CLTId; }
            set { _CLTId = value; }
        }

        public string StaffName
        {
            get { return _StaffName; }
            set { _StaffName = value; }
        }

        public string Addr1
        {
            get { return _Addr1; }
            set { _Addr1 = value; }
        }

        public string Addr2
        {
            get { return _Addr2; }
            set { _Addr2 = value; }
        }

        public string Addr3
        {
            get { return _Addr3; }
            set { _Addr3 = value; }
        }

        public string City
        {
            get { return _City; }
            set { _City = value; }
        }

        public string Mobile
        {
            get { return _Mobile; }
            set { _Mobile = value; }
        }

        public string Email
        {
            get { return _Email; }
            set { _Email = value; }
        }

        public int? DepId
        {
            get { return _DepId; }
            set { _DepId = value; }
        }

        public bool? JobDep
        {
            get { return _Job_dept; }
            set { _Job_dept = value; }
        }

        public int? DsgId
        {
            get { return _DsgId; }
            set { _DsgId = value; }
        }

        public int? BrId
        {
            get { return _BrId; }
            set { _BrId = value; }
        }

        public int? Staffrole
        {
            get { return _Staffrole; }
            set { _Staffrole = value; }
        }

        public DateTime? DateOfJoining
        {
            get { return _DateOfJoining; }
            set { _DateOfJoining = value; }
        }

        public DateTime? DateOfLeaving
        {
            get { return _DateOfLeaving; }
            set { _DateOfLeaving = value; }
        }

        public double? HourlyCharges
        {
            get { return _HourlyCharges; }
            set { _HourlyCharges = value; }
        }

        public double? CurMonthSal
        {
            get { return _CurMonthSal; }
            set { _CurMonthSal = value; }
        }

        public string username
        {
            get { return _username; }
            set { _username = value; }
        }

        public string password
        {
            get { return _password; }
            set { _password = value; }
        }

        public string Role
        {
            get { return _Role; }
            set { _Role = value; }
        }

        public string Qual
        {
            get { return _Qual; }
            set { _Qual = value; }
        }

        public string EmpType
        {
            get { return _EmpType; }
            set { _EmpType = value; }
        }

        public DateTime? YrGd
        {
            get { return _YrGd; }
            set { _YrGd = value; }
        }
        public DateTime? YrPG
        {
            get { return _YrPG; }
            set { _YrPG = value; }
        }

        public DateTime? YrRj
        {
            get { return _YrRj; }
            set { _YrRj = value; }
        }

        public bool? IsApproved
        {
            get { return _IsApproved; }
            set { _IsApproved = value; }
        }

        public Guid? UserId
        {
            get { return _UserId; }
            set { _UserId = value; }
        }

        public DateTime? LastLogin
        {
            get { return _LastLogin; }
            set { _LastLogin = value; }
        }

        public int? Logins
        {
            get { return _Logins; }
            set { _Logins = value; }
        }

        public bool? IsDeleted
        {
            get { return _IsDeleted; }
            set { _IsDeleted = value; }
        }

        public bool? ishod
        {
            get { return _ishod; }
            set{_ishod=value;}
        }

        public virtual void Clone(StaffMaster sourceObject)
        {
            // Clone attributes from source object
            this._StaffCode = sourceObject.StaffCode;
            this._CompId = sourceObject.CompId;
            this._CLTId = sourceObject.CLTId;
            this._StaffName = sourceObject.StaffName;
            this._Addr1 = sourceObject.Addr1;
            this._Addr2 = sourceObject.Addr2;
            this._Addr3 = sourceObject.Addr3;
            this._City = sourceObject.City;
            this._Mobile = sourceObject.Mobile;
            this._Email = sourceObject.Email;
            this._DepId = sourceObject.DepId;
            this._DsgId = sourceObject.DsgId;
            this._BrId = sourceObject.BrId;
            this._DateOfJoining = sourceObject.DateOfJoining;
            this._DateOfLeaving = sourceObject.DateOfLeaving;
            this._HourlyCharges = sourceObject.HourlyCharges;
            this._CurMonthSal = sourceObject.CurMonthSal;
            this._username = sourceObject.username;
            this._password = sourceObject.password;
            this._Role = sourceObject.Role;
            this._Qual = sourceObject.Qual;
            this._YrGd = sourceObject.YrGd;
            this._YrPG = sourceObject.YrGd;
            this._YrRj = sourceObject.YrRj;

            this._IsApproved = sourceObject.IsApproved;
            this._UserId = sourceObject.UserId;
            this._LastLogin = sourceObject.LastLogin;
            this._Logins = sourceObject.Logins;
            this._IsDeleted = sourceObject.IsDeleted;
            this._Job_dept = sourceObject.JobDep;
            this._EmpType = sourceObject.EmpType;
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

        public static IReader<StaffMaster> ListAll()
        {
            return _DefaultPersister.ListAll();
        }

        public static IReader<StaffMaster> ListForCompId(int? compId)
        {
            return _DefaultPersister.ListForCompId(compId);
        }


        public string staffThumbLoginID { get; set; }
    }

    public partial interface IStaffMasterPersister
    {
        int Retrieve(StaffMaster staffMaster);
        int Update(StaffMaster staffMaster);
        int Delete(StaffMaster staffMaster);
        int Insert(StaffMaster staffMaster);
        IReader<StaffMaster> ListAll();
        IReader<StaffMaster> ListForCompId(int? compId);
    }

    public partial class SqlServerStaffMasterPersister : SqlPersisterBase, IStaffMasterPersister
    {
        public SqlServerStaffMasterPersister()
        {
        }

        public SqlServerStaffMasterPersister(string connectionString)
            : base(connectionString)
        {
        }

        public SqlServerStaffMasterPersister(SqlConnection connection)
            : base(connection)
        {
        }

        public SqlServerStaffMasterPersister(SqlTransaction transaction)
            : base(transaction)
        {
        }

        public int Retrieve(StaffMaster staffMaster)
        {
            int __rowsAffected = 1;

            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("StaffMasterGet"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure;

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Add command parameters
                    SqlParameter vStaffCode = new SqlParameter("@StaffCode", SqlDbType.Int);
                    vStaffCode.Direction = ParameterDirection.InputOutput;
                    sqlCommand.Parameters.Add(vStaffCode);
                    SqlParameter vCompId = new SqlParameter("@CompId", SqlDbType.Int);
                    vCompId.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vCompId);
                    SqlParameter vCLTId = new SqlParameter("@CLTId", SqlDbType.Int);
                    vCLTId.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vCLTId);
                    SqlParameter vStaffName = new SqlParameter("@StaffName", SqlDbType.VarChar, 70);
                    vStaffName.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vStaffName);
                    SqlParameter vAddr1 = new SqlParameter("@Addr1", SqlDbType.VarChar, 50);
                    vAddr1.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vAddr1);
                    SqlParameter vAddr2 = new SqlParameter("@Addr2", SqlDbType.VarChar, 50);
                    vAddr2.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vAddr2);
                    SqlParameter vAddr3 = new SqlParameter("@Addr3", SqlDbType.VarChar, 50);
                    vAddr3.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vAddr3);
                    SqlParameter vCity = new SqlParameter("@City", SqlDbType.VarChar, 50);
                    vCity.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vCity);
                    SqlParameter vMobile = new SqlParameter("@Mobile", SqlDbType.VarChar, 50);
                    vMobile.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vMobile);
                    SqlParameter vEmail = new SqlParameter("@Email", SqlDbType.VarChar, 70);
                    vEmail.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vEmail);
                    SqlParameter vDepId = new SqlParameter("@DepId", SqlDbType.Int);
                    vDepId.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vDepId);
                    SqlParameter vDsgId = new SqlParameter("@DsgId", SqlDbType.Int);
                    vDsgId.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vDsgId);
                    SqlParameter vBrId = new SqlParameter("@BrId", SqlDbType.Int);
                    vBrId.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vBrId);
                    SqlParameter vStaffrole = new SqlParameter("@Staff_role", SqlDbType.Int);
                    vStaffrole.Direction = ParameterDirection.Input;
                    sqlCommand.Parameters.Add(vStaffrole);
                    SqlParameter vDateOfJoining = new SqlParameter("@DateOfJoining", SqlDbType.DateTime);
                    vDateOfJoining.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vDateOfJoining);
                    SqlParameter vDateOfLeaving = new SqlParameter("@DateOfLeaving", SqlDbType.DateTime);
                    vDateOfLeaving.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vDateOfLeaving);
                    SqlParameter vHourlyCharges = new SqlParameter("@HourlyCharges", SqlDbType.Float);
                    vHourlyCharges.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vHourlyCharges);
                    SqlParameter vCurMonthSal = new SqlParameter("@CurMonthSal", SqlDbType.Float);
                    vCurMonthSal.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vCurMonthSal);
                    SqlParameter vusername = new SqlParameter("@username", SqlDbType.VarChar, 250);
                    vusername.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vusername);
                    SqlParameter vpassword = new SqlParameter("@password", SqlDbType.VarChar, 250);
                    vpassword.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vpassword);
                    SqlParameter vRole = new SqlParameter("@Role", SqlDbType.NVarChar, 256);
                    vRole.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vRole);
                    SqlParameter vQual = new SqlParameter("@Qual", SqlDbType.NVarChar, 256);
                    vQual.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vQual);
                    SqlParameter vYrGd = new SqlParameter("@YrGd", SqlDbType.DateTime);
                    vYrGd.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vYrGd);
                    SqlParameter vYrPG = new SqlParameter("@YrPG", SqlDbType.DateTime);
                    vYrPG.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vYrPG);
                    SqlParameter vYrRj = new SqlParameter("@YrRj", SqlDbType.DateTime);
                    vYrRj.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vYrRj);

                    SqlParameter vIsApproved = new SqlParameter("@IsApproved", SqlDbType.Bit);
                    vIsApproved.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vIsApproved);
                    SqlParameter vUserId = new SqlParameter("@UserId", SqlDbType.UniqueIdentifier);
                    vUserId.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vUserId);
                    SqlParameter vLastLogin = new SqlParameter("@LastLogin", SqlDbType.DateTime);
                    vLastLogin.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vLastLogin);
                    SqlParameter vLogins = new SqlParameter("@Logins", SqlDbType.Int);
                    vLogins.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vLogins);
                    SqlParameter vIsDeleted = new SqlParameter("@IsDeleted", SqlDbType.Bit);
                    vIsDeleted.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vIsDeleted);
                    SqlParameter vIshod = new SqlParameter("@ishod", SqlDbType.Bit);
                    vIshod.Direction = ParameterDirection.Output;
                    sqlCommand.Parameters.Add(vIshod);

                    // Set input parameter values
                    SqlServerHelper.SetParameterValue(vStaffCode, staffMaster.StaffCode);

                    // Execute command
                    sqlCommand.ExecuteNonQuery();

                    try
                    {
                        // Get output parameter values
                        staffMaster.StaffCode = SqlServerHelper.ToInt32(vStaffCode);
                        staffMaster.CompId = SqlServerHelper.ToNullableInt32(vCompId);
                        staffMaster.CLTId = SqlServerHelper.ToNullableInt32(vCLTId);
                        staffMaster.StaffName = SqlServerHelper.ToString(vStaffName);
                        staffMaster.Addr1 = SqlServerHelper.ToString(vAddr1);
                        staffMaster.Addr2 = SqlServerHelper.ToString(vAddr2);
                        staffMaster.Addr3 = SqlServerHelper.ToString(vAddr3);
                        staffMaster.City = SqlServerHelper.ToString(vCity);
                        staffMaster.Mobile = SqlServerHelper.ToString(vMobile);
                        staffMaster.Email = SqlServerHelper.ToString(vEmail);
                        staffMaster.DepId = SqlServerHelper.ToNullableInt32(vDepId);
                        staffMaster.DsgId = SqlServerHelper.ToNullableInt32(vDsgId);
                        staffMaster.BrId = SqlServerHelper.ToNullableInt32(vBrId);
                        staffMaster.Staffrole = SqlServerHelper.ToNullableInt32(vStaffrole);
                        staffMaster.DateOfJoining = SqlServerHelper.ToNullableDateTime(vDateOfJoining);
                        staffMaster.DateOfLeaving = SqlServerHelper.ToNullableDateTime(vDateOfLeaving);
                        staffMaster.HourlyCharges = SqlServerHelper.ToNullableDouble(vHourlyCharges);
                        staffMaster.CurMonthSal = SqlServerHelper.ToNullableDouble(vCurMonthSal);
                        staffMaster.username = SqlServerHelper.ToString(vusername);
                        staffMaster.password = SqlServerHelper.ToString(vpassword);
                        staffMaster.Role = SqlServerHelper.ToString(vRole);
                        staffMaster.Qual = SqlServerHelper.ToString(vQual);
                        staffMaster.YrGd = SqlServerHelper.ToNullableDateTime(vYrGd);
                        staffMaster.YrPG = SqlServerHelper.ToNullableDateTime(vYrPG);
                        staffMaster.YrRj = SqlServerHelper.ToNullableDateTime(vYrRj);
                        staffMaster.IsApproved = SqlServerHelper.ToNullableBoolean(vIsApproved);
                        staffMaster.UserId = SqlServerHelper.ToNullableGuid(vUserId);
                        staffMaster.LastLogin = SqlServerHelper.ToNullableDateTime(vLastLogin);
                        staffMaster.Logins = SqlServerHelper.ToNullableInt32(vLogins);
                        staffMaster.IsDeleted = SqlServerHelper.ToNullableBoolean(vIsDeleted);
                        staffMaster.ishod = SqlServerHelper.ToNullableBoolean(vIshod);

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

        public int Update(StaffMaster staffMaster)
        {
            int __rowsAffected = 0;

            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("StaffMasterUpdate"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure;

                // Add command parameters
                SqlParameter vStaffCode = new SqlParameter("@StaffCode", SqlDbType.Int);
                vStaffCode.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vStaffCode);
                SqlParameter vCompId = new SqlParameter("@CompId", SqlDbType.Int);
                vCompId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vCompId);
                SqlParameter vCLTId = new SqlParameter("@CLTId", SqlDbType.Int);
                vCLTId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vCLTId);
                SqlParameter vStaffName = new SqlParameter("@StaffName", SqlDbType.VarChar, 70);
                vStaffName.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vStaffName);
                SqlParameter vAddr1 = new SqlParameter("@Addr1", SqlDbType.VarChar, 50);
                vAddr1.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vAddr1);
                SqlParameter vAddr2 = new SqlParameter("@Addr2", SqlDbType.VarChar, 50);
                vAddr2.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vAddr2);
                SqlParameter vAddr3 = new SqlParameter("@Addr3", SqlDbType.VarChar, 50);
                vAddr3.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vAddr3);
                SqlParameter vCity = new SqlParameter("@City", SqlDbType.VarChar, 50);
                vCity.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vCity);
                SqlParameter vMobile = new SqlParameter("@Mobile", SqlDbType.VarChar, 50);
                vMobile.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vMobile);
                SqlParameter vEmail = new SqlParameter("@Email", SqlDbType.VarChar, 70);
                vEmail.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vEmail);
                SqlParameter vDepId = new SqlParameter("@DepId", SqlDbType.Int);
                vDepId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vDepId);
                SqlParameter vDsgId = new SqlParameter("@DsgId", SqlDbType.Int);
                vDsgId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vDsgId);
                SqlParameter vBrId = new SqlParameter("@BrId", SqlDbType.Int);
                vBrId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vBrId);
                SqlParameter vStaffrole = new SqlParameter("@Staff_role", SqlDbType.Int);
                vStaffrole.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vStaffrole);
                SqlParameter vDateOfJoining = new SqlParameter("@DateOfJoining", SqlDbType.DateTime);
                vDateOfJoining.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vDateOfJoining);
                SqlParameter vDateOfLeaving = new SqlParameter("@DateOfLeaving", SqlDbType.DateTime);
                vDateOfLeaving.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vDateOfLeaving);
                SqlParameter vHourlyCharges = new SqlParameter("@HourlyCharges", SqlDbType.Float);
                vHourlyCharges.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vHourlyCharges);
                SqlParameter vCurMonthSal = new SqlParameter("@CurMonthSal", SqlDbType.Float);
                vCurMonthSal.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vCurMonthSal);
                SqlParameter vusername = new SqlParameter("@username", SqlDbType.VarChar, 250);
                vusername.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vusername);
                SqlParameter vpassword = new SqlParameter("@password", SqlDbType.VarChar, 250);
                vpassword.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vpassword);
                SqlParameter vRole = new SqlParameter("@Role", SqlDbType.NVarChar, 256);
                vRole.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vRole);

                SqlParameter vQual = new SqlParameter("@Qual", SqlDbType.NVarChar, 256);
                vQual.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vQual);
                SqlParameter vYrGd = new SqlParameter("@YrGd", SqlDbType.DateTime);
                vYrGd.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vYrGd);
                SqlParameter vYrPG = new SqlParameter("@YrPG", SqlDbType.DateTime);
                vYrPG.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vYrPG);
                SqlParameter vYrRj = new SqlParameter("@YrRj", SqlDbType.DateTime);
                vYrRj.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vYrRj);

                SqlParameter vIsApproved = new SqlParameter("@IsApproved", SqlDbType.Bit);
                vIsApproved.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vIsApproved);
                SqlParameter vUserId = new SqlParameter("@UserId", SqlDbType.UniqueIdentifier);
                vUserId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vUserId);
                SqlParameter vLastLogin = new SqlParameter("@LastLogin", SqlDbType.DateTime);
                vLastLogin.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vLastLogin);
                SqlParameter vLogins = new SqlParameter("@Logins", SqlDbType.Int);
                vLogins.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vLogins);
                SqlParameter vIsDeleted = new SqlParameter("@IsDeleted", SqlDbType.Bit);
                vIsDeleted.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vIsDeleted);
                SqlParameter vjobDept = new SqlParameter("@jobdept", SqlDbType.Bit);
                vjobDept.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vjobDept);

                SqlParameter objstaffThumblogin = new SqlParameter("@staffThumblogin", SqlDbType.NVarChar, 256);
                objstaffThumblogin.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(objstaffThumblogin);

                SqlParameter vishod = new SqlParameter("@ishod", SqlDbType.Bit);
                vishod.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vishod);

                SqlParameter EmpType = new SqlParameter("@EmpType", SqlDbType.VarChar, 250);
                EmpType.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(EmpType);
                // Set input parameter values
                SqlServerHelper.SetParameterValue(vStaffCode, staffMaster.StaffCode);
                SqlServerHelper.SetParameterValue(vishod, staffMaster.ishod);
                SqlServerHelper.SetParameterValue(vCompId, staffMaster.CompId);
                SqlServerHelper.SetParameterValue(vCLTId, staffMaster.CLTId);
                SqlServerHelper.SetParameterValue(vStaffName, staffMaster.StaffName);
                SqlServerHelper.SetParameterValue(vAddr1, staffMaster.Addr1);
                SqlServerHelper.SetParameterValue(vAddr2, staffMaster.Addr2);
                SqlServerHelper.SetParameterValue(vAddr3, staffMaster.Addr3);
                SqlServerHelper.SetParameterValue(vCity, staffMaster.City);
                SqlServerHelper.SetParameterValue(vMobile, staffMaster.Mobile);
                SqlServerHelper.SetParameterValue(vEmail, staffMaster.Email);
                SqlServerHelper.SetParameterValue(vDepId, staffMaster.DepId);
                SqlServerHelper.SetParameterValue(vDsgId, staffMaster.DsgId);
                SqlServerHelper.SetParameterValue(vBrId, staffMaster.BrId);
                SqlServerHelper.SetParameterValue(vStaffrole, staffMaster.Staffrole);
                SqlServerHelper.SetParameterValue(vDateOfJoining, staffMaster.DateOfJoining);
                SqlServerHelper.SetParameterValue(vDateOfLeaving, staffMaster.DateOfLeaving);
                SqlServerHelper.SetParameterValue(vHourlyCharges, staffMaster.HourlyCharges);
                SqlServerHelper.SetParameterValue(vCurMonthSal, staffMaster.CurMonthSal);
                SqlServerHelper.SetParameterValue(vusername, staffMaster.username);
                SqlServerHelper.SetParameterValue(vpassword, staffMaster.password);
                SqlServerHelper.SetParameterValue(vRole, staffMaster.Role);
                SqlServerHelper.SetParameterValue(vQual, staffMaster.Qual);
                SqlServerHelper.SetParameterValue(vYrGd, staffMaster.YrGd);
                SqlServerHelper.SetParameterValue(vYrPG, staffMaster.YrPG);
                SqlServerHelper.SetParameterValue(vYrRj, staffMaster.YrRj);

                SqlServerHelper.SetParameterValue(vIsApproved, staffMaster.IsApproved);
                SqlServerHelper.SetParameterValue(vUserId, staffMaster.UserId);
                SqlServerHelper.SetParameterValue(vLastLogin, staffMaster.LastLogin);
                SqlServerHelper.SetParameterValue(vLogins, staffMaster.Logins);
                SqlServerHelper.SetParameterValue(vIsDeleted, staffMaster.IsDeleted);
                SqlServerHelper.SetParameterValue(vjobDept, staffMaster.JobDep);
                SqlServerHelper.SetParameterValue(objstaffThumblogin, staffMaster.staffThumbLoginID);
                SqlServerHelper.SetParameterValue(EmpType, staffMaster.EmpType);

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

        public int Delete(StaffMaster staffMaster)
        {
            int __rowsAffected = 0;

            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("StaffMasterDelete"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure;

                try
                {
                    // Attach command
                    AttachCommand(sqlCommand);

                    // Add command parameters
                    SqlParameter vStaffCode = new SqlParameter("@StaffCode", SqlDbType.Int);
                    vStaffCode.Direction = ParameterDirection.Input;
                    sqlCommand.Parameters.Add(vStaffCode);

                    // Set input parameter values
                    SqlServerHelper.SetParameterValue(vStaffCode, staffMaster.StaffCode);

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

        public int Insert(StaffMaster staffMaster)
        {
            int __rowsAffected = 0;

            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("StaffMasterInsert"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure;

                // Add command parameters
                SqlParameter vStaffCode = new SqlParameter("@StaffCode", SqlDbType.Int);
                vStaffCode.Direction = ParameterDirection.InputOutput;
                sqlCommand.Parameters.Add(vStaffCode);
                SqlParameter vCompId = new SqlParameter("@CompId", SqlDbType.Int);
                vCompId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vCompId);
                SqlParameter vCLTId = new SqlParameter("@CLTId", SqlDbType.Int);
                vCLTId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vCLTId);
                SqlParameter vStaffName = new SqlParameter("@StaffName", SqlDbType.VarChar, 70);
                vStaffName.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vStaffName);
                SqlParameter vAddr1 = new SqlParameter("@Addr1", SqlDbType.VarChar, 50);
                vAddr1.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vAddr1);
                SqlParameter vAddr2 = new SqlParameter("@Addr2", SqlDbType.VarChar, 50);
                vAddr2.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vAddr2);
                SqlParameter vAddr3 = new SqlParameter("@Addr3", SqlDbType.VarChar, 50);
                vAddr3.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vAddr3);
                SqlParameter vCity = new SqlParameter("@City", SqlDbType.VarChar, 50);
                vCity.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vCity);
                SqlParameter vMobile = new SqlParameter("@Mobile", SqlDbType.VarChar, 50);
                vMobile.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vMobile);
                SqlParameter vEmail = new SqlParameter("@Email", SqlDbType.VarChar, 70);
                vEmail.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vEmail);
                SqlParameter vDepId = new SqlParameter("@DepId", SqlDbType.Int);
                vDepId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vDepId);
                SqlParameter vDsgId = new SqlParameter("@DsgId", SqlDbType.Int);
                vDsgId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vDsgId);
                SqlParameter vBrId = new SqlParameter("@BrId", SqlDbType.Int);
                vBrId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vBrId);
                SqlParameter vStaffrole = new SqlParameter("@Staff_role", SqlDbType.Int);
                vStaffrole.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vStaffrole);
                SqlParameter vDateOfJoining = new SqlParameter("@DateOfJoining", SqlDbType.DateTime);
                vDateOfJoining.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vDateOfJoining);
                SqlParameter vDateOfLeaving = new SqlParameter("@DateOfLeaving", SqlDbType.DateTime);
                vDateOfLeaving.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vDateOfLeaving);
                SqlParameter vHourlyCharges = new SqlParameter("@HourlyCharges", SqlDbType.Float);
                vHourlyCharges.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vHourlyCharges);
                SqlParameter vCurMonthSal = new SqlParameter("@CurMonthSal", SqlDbType.Float);
                vCurMonthSal.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vCurMonthSal);
                SqlParameter vusername = new SqlParameter("@username", SqlDbType.VarChar, 250);
                vusername.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vusername);
                SqlParameter vpassword = new SqlParameter("@password", SqlDbType.VarChar, 250);
                vpassword.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vpassword);
                SqlParameter vRole = new SqlParameter("@Role", SqlDbType.NVarChar, 256);
                vRole.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vRole);
                SqlParameter vQual = new SqlParameter("@Qual", SqlDbType.NVarChar, 256);
                vRole.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vQual);
                SqlParameter vYrGd = new SqlParameter("@YrGd", SqlDbType.DateTime);
                vRole.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vYrGd);
                SqlParameter vYrPG = new SqlParameter("@YrPG", SqlDbType.DateTime);
                vYrPG.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vYrPG);
                SqlParameter vYrRj = new SqlParameter("@YrRj", SqlDbType.DateTime);
                vYrRj.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vYrRj);

                SqlParameter vIsApproved = new SqlParameter("@IsApproved", SqlDbType.Bit);
                vIsApproved.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vIsApproved);
                SqlParameter vUserId = new SqlParameter("@UserId", SqlDbType.UniqueIdentifier);
                vUserId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vUserId);
                SqlParameter vLastLogin = new SqlParameter("@LastLogin", SqlDbType.DateTime);
                vLastLogin.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vLastLogin);
                SqlParameter vLogins = new SqlParameter("@Logins", SqlDbType.Int);
                vLogins.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vLogins);
                SqlParameter vIsDeleted = new SqlParameter("@IsDeleted", SqlDbType.Bit);
                vIsDeleted.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vIsDeleted);
                SqlParameter vjobDept = new SqlParameter("@jobdept", SqlDbType.Bit);
                vjobDept.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vjobDept);
                SqlParameter objstaffThumblogin = new SqlParameter("@staffThumblogin", SqlDbType.NVarChar, 256);
                objstaffThumblogin.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(objstaffThumblogin);
                SqlParameter vishod = new SqlParameter("@ishod", SqlDbType.Bit);
                vishod.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vishod);
                SqlParameter EmpType = new SqlParameter("@EmpType", SqlDbType.VarChar, 250);
                EmpType.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(EmpType);

                // Set input parameter values
                SqlServerHelper.SetParameterValue(
                    vStaffCode,
                    staffMaster.StaffCode,
                    0);

                SqlServerHelper.SetParameterValue(vCompId, staffMaster.CompId);
                SqlServerHelper.SetParameterValue(vCLTId, staffMaster.CLTId);
                SqlServerHelper.SetParameterValue(vStaffName, staffMaster.StaffName);
                SqlServerHelper.SetParameterValue(vAddr1, staffMaster.Addr1);
                SqlServerHelper.SetParameterValue(vAddr2, staffMaster.Addr2);
                SqlServerHelper.SetParameterValue(vAddr3, staffMaster.Addr3);
                SqlServerHelper.SetParameterValue(vCity, staffMaster.City);
                SqlServerHelper.SetParameterValue(vMobile, staffMaster.Mobile);
                SqlServerHelper.SetParameterValue(vEmail, staffMaster.Email);
                SqlServerHelper.SetParameterValue(vDepId, staffMaster.DepId);
                SqlServerHelper.SetParameterValue(vDsgId, staffMaster.DsgId);
                SqlServerHelper.SetParameterValue(vBrId, staffMaster.BrId);
                SqlServerHelper.SetParameterValue(vStaffrole, staffMaster.Staffrole);
                SqlServerHelper.SetParameterValue(vDateOfJoining, staffMaster.DateOfJoining);
                SqlServerHelper.SetParameterValue(vDateOfLeaving, staffMaster.DateOfLeaving);
                SqlServerHelper.SetParameterValue(vHourlyCharges, staffMaster.HourlyCharges);
                SqlServerHelper.SetParameterValue(vCurMonthSal, staffMaster.CurMonthSal);
                SqlServerHelper.SetParameterValue(vusername, staffMaster.username);
                SqlServerHelper.SetParameterValue(vpassword, staffMaster.password);
                SqlServerHelper.SetParameterValue(vRole, staffMaster.Role);
                SqlServerHelper.SetParameterValue(vQual, staffMaster.Qual);
                SqlServerHelper.SetParameterValue(vYrGd, staffMaster.YrGd);
                SqlServerHelper.SetParameterValue(vYrPG, staffMaster.YrPG);
                SqlServerHelper.SetParameterValue(vYrRj, staffMaster.YrRj);

                SqlServerHelper.SetParameterValue(vIsApproved, staffMaster.IsApproved);
                SqlServerHelper.SetParameterValue(vUserId, staffMaster.UserId);
                SqlServerHelper.SetParameterValue(vLastLogin, staffMaster.LastLogin);
                SqlServerHelper.SetParameterValue(vLogins, staffMaster.Logins);
                SqlServerHelper.SetParameterValue(vIsDeleted, staffMaster.IsDeleted);
                SqlServerHelper.SetParameterValue(vjobDept, staffMaster.JobDep);
                SqlServerHelper.SetParameterValue(objstaffThumblogin, staffMaster.staffThumbLoginID);
                SqlServerHelper.SetParameterValue(vishod, staffMaster.ishod);
                SqlServerHelper.SetParameterValue(EmpType, staffMaster.EmpType);
                

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
                    staffMaster.StaffCode = SqlServerHelper.ToInt32(vStaffCode);

                }
                finally
                {
                    // Detach command
                    DetachCommand(sqlCommand);
                }

            }

            return __rowsAffected;
        }

        public IReader<StaffMaster> ListAll()
        {
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("StaffMasterListAll"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure;

                // Execute command
                SqlDataReader reader = sqlCommand.ExecuteReader(AttachReaderCommand(sqlCommand));

                // Return reader
                return new SqlServerStaffMasterReader(reader);
            }
        }

        public IReader<StaffMaster> ListForCompId(int? compId)
        {
            // Create command
            using (SqlCommand sqlCommand = new SqlCommand("StaffMasterListForCompId"))
            {
                // Set command type
                sqlCommand.CommandType = CommandType.StoredProcedure;

                // Add command parameters
                SqlParameter vCompId = new SqlParameter("@CompId", SqlDbType.Int);
                vCompId.Direction = ParameterDirection.Input;
                sqlCommand.Parameters.Add(vCompId);

                // Set input parameter values
                SqlServerHelper.SetParameterValue(vCompId, compId);

                // Execute command
                SqlDataReader reader = sqlCommand.ExecuteReader(AttachReaderCommand(sqlCommand));

                // Return reader
                return new SqlServerStaffMasterReader(reader);
            }
        }

    }

    public partial class SqlServerStaffMasterReader : IReader<StaffMaster>
    {
        private SqlDataReader sqlDataReader;

        private StaffMaster _StaffMaster;

        private int _StaffCodeOrdinal = -1;
        private int _CompIdOrdinal = -1;
        private int _CLTIdOrdinal = -1;
        private int _StaffNameOrdinal = -1;
        private int _Addr1Ordinal = -1;
        private int _Addr2Ordinal = -1;
        private int _Addr3Ordinal = -1;
        private int _CityOrdinal = -1;
        private int _MobileOrdinal = -1;
        private int _EmailOrdinal = -1;
        private int _DepIdOrdinal = -1;
        private int _DsgIdOrdinal = -1;
        private int _BrIdOrdinal = -1;
        private int _StaffrollOrdinal = -1;
        private int _DateOfJoiningOrdinal = -1;
        private int _DateOfLeavingOrdinal = -1;
        private int _HourlyChargesOrdinal = -1;
        private int _CurMonthSalOrdinal = -1;
        private int _usernameOrdinal = -1;
        private int _passwordOrdinal = -1;
        private int _RoleOrdinal = -1;
        private int _QualOrdinal = -1;
        private int _YrGdOrdinal = -1;
        private int _YrPGOrdinal = -1;
        private int _YrRjOrdinal = -1;

        private int _IsApprovedOrdinal = -1;
        private int _UserIdOrdinal = -1;
        private int _LastLoginOrdinal = -1;
        private int _LoginsOrdinal = -1;
        private int _IsDeletedOrdinal = -1;
        private int _Job_DeptOrdinal = -1;
        public SqlServerStaffMasterReader(SqlDataReader sqlDataReader)
        {
            this.sqlDataReader = sqlDataReader;
            for (int i = 0; i < sqlDataReader.FieldCount; i++)
            {
                string columnName = sqlDataReader.GetName(i);
                columnName = columnName.ToUpper();
                switch (columnName)
                {
                    case "STAFFCODE":
                        _StaffCodeOrdinal = i;
                        break;

                    case "COMPID":
                        _CompIdOrdinal = i;
                        break;

                    case "CLTID":
                        _CLTIdOrdinal = i;
                        break;

                    case "STAFFNAME":
                        _StaffNameOrdinal = i;
                        break;

                    case "ADDR1":
                        _Addr1Ordinal = i;
                        break;

                    case "ADDR2":
                        _Addr2Ordinal = i;
                        break;

                    case "ADDR3":
                        _Addr3Ordinal = i;
                        break;

                    case "CITY":
                        _CityOrdinal = i;
                        break;

                    case "MOBILE":
                        _MobileOrdinal = i;
                        break;

                    case "EMAIL":
                        _EmailOrdinal = i;
                        break;

                    case "DEPID":
                        _DepIdOrdinal = i;
                        break;

                    case "DSGID":
                        _DsgIdOrdinal = i;
                        break;

                    case "BRID":
                        _BrIdOrdinal = i;
                        break;

                    case "STAFF_ROLE":
                        _StaffrollOrdinal = i;
                        break;

                    case "DATEOFJOINING":
                        _DateOfJoiningOrdinal = i;
                        break;

                    case "DATEOFLEAVING":
                        _DateOfLeavingOrdinal = i;
                        break;

                    case "HOURLYCHARGES":
                        _HourlyChargesOrdinal = i;
                        break;

                    case "CURMONTHSAL":
                        _CurMonthSalOrdinal = i;
                        break;

                    case "USERNAME":
                        _usernameOrdinal = i;
                        break;

                    case "PASSWORD":
                        _passwordOrdinal = i;
                        break;

                    case "ROLE":
                        _RoleOrdinal = i;
                        break;
                    case "QUAL":
                        _QualOrdinal = i;
                        break;

                    case "YRGD":
                        _YrGdOrdinal = i;
                        break;

                    case "YRPG":
                        _YrPGOrdinal = i;
                        break;
                    case "YRRJ":
                        _YrRjOrdinal = i;
                        break;


                    case "ISAPPROVED":
                        _IsApprovedOrdinal = i;
                        break;

                    case "USERID":
                        _UserIdOrdinal = i;
                        break;

                    case "LASTLOGIN":
                        _LastLoginOrdinal = i;
                        break;

                    case "LOGINS":
                        _LoginsOrdinal = i;
                        break;

                    case "ISDELETED":
                        _IsDeletedOrdinal = i;
                        break;
                    case "JOBDEP":
                        _Job_DeptOrdinal = i;
                        break;
                }
            }
        }

        #region IReader<StaffMaster> Implementation

        public bool Read()
        {
            _StaffMaster = null;
            return this.sqlDataReader.Read();
        }

        public StaffMaster Current
        {
            get
            {
                if (_StaffMaster == null)
                {
                    _StaffMaster = new StaffMaster();
                    if (_StaffCodeOrdinal != -1)
                    {
                        _StaffMaster.StaffCode = SqlServerHelper.ToInt32(sqlDataReader, _StaffCodeOrdinal);
                    }
                    _StaffMaster.CompId = SqlServerHelper.ToNullableInt32(sqlDataReader, _CompIdOrdinal);
                    _StaffMaster.CLTId = SqlServerHelper.ToNullableInt32(sqlDataReader, _CLTIdOrdinal);
                    _StaffMaster.StaffName = SqlServerHelper.ToString(sqlDataReader, _StaffNameOrdinal);
                    _StaffMaster.Addr1 = SqlServerHelper.ToString(sqlDataReader, _Addr1Ordinal);
                    _StaffMaster.Addr2 = SqlServerHelper.ToString(sqlDataReader, _Addr2Ordinal);
                    _StaffMaster.Addr3 = SqlServerHelper.ToString(sqlDataReader, _Addr3Ordinal);
                    _StaffMaster.City = SqlServerHelper.ToString(sqlDataReader, _CityOrdinal);
                    _StaffMaster.Mobile = SqlServerHelper.ToString(sqlDataReader, _MobileOrdinal);
                    _StaffMaster.Email = SqlServerHelper.ToString(sqlDataReader, _EmailOrdinal);
                    _StaffMaster.DepId = SqlServerHelper.ToNullableInt32(sqlDataReader, _DepIdOrdinal);
                    _StaffMaster.DsgId = SqlServerHelper.ToNullableInt32(sqlDataReader, _DsgIdOrdinal);
                    _StaffMaster.BrId = SqlServerHelper.ToNullableInt32(sqlDataReader, _BrIdOrdinal);
                    _StaffMaster.Staffrole = SqlServerHelper.ToNullableInt32(sqlDataReader, _StaffrollOrdinal);
                    _StaffMaster.DateOfJoining = SqlServerHelper.ToNullableDateTime(sqlDataReader, _DateOfJoiningOrdinal);
                    _StaffMaster.DateOfLeaving = SqlServerHelper.ToNullableDateTime(sqlDataReader, _DateOfLeavingOrdinal);
                    _StaffMaster.HourlyCharges = SqlServerHelper.ToNullableDouble(sqlDataReader, _HourlyChargesOrdinal);
                    _StaffMaster.CurMonthSal = SqlServerHelper.ToNullableDouble(sqlDataReader, _CurMonthSalOrdinal);
                    _StaffMaster.username = SqlServerHelper.ToString(sqlDataReader, _usernameOrdinal);
                    _StaffMaster.password = SqlServerHelper.ToString(sqlDataReader, _passwordOrdinal);
                    _StaffMaster.Role = SqlServerHelper.ToString(sqlDataReader, _RoleOrdinal);
                    _StaffMaster.Qual = SqlServerHelper.ToString(sqlDataReader, _QualOrdinal);
                    _StaffMaster.YrGd = SqlServerHelper.ToNullableDateTime(sqlDataReader, _YrGdOrdinal);
                    _StaffMaster.YrPG = SqlServerHelper.ToNullableDateTime(sqlDataReader, _YrPGOrdinal);
                    _StaffMaster.YrRj = SqlServerHelper.ToNullableDateTime(sqlDataReader, _YrRjOrdinal);

                    _StaffMaster.IsApproved = SqlServerHelper.ToNullableBoolean(sqlDataReader, _IsApprovedOrdinal);
                    _StaffMaster.UserId = SqlServerHelper.ToNullableGuid(sqlDataReader, _UserIdOrdinal);
                    _StaffMaster.LastLogin = SqlServerHelper.ToNullableDateTime(sqlDataReader, _LastLoginOrdinal);
                    _StaffMaster.Logins = SqlServerHelper.ToNullableInt32(sqlDataReader, _LoginsOrdinal);
                    _StaffMaster.IsDeleted = SqlServerHelper.ToNullableBoolean(sqlDataReader, _IsDeletedOrdinal);
                }


                return _StaffMaster;
            }
        }

        public void Close()
        {
            sqlDataReader.Close();
        }

        public List<StaffMaster> ToList()
        {
            List<StaffMaster> list = new List<StaffMaster>();
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

        #region IEnumerable<StaffMaster> Implementation

        public IEnumerator<StaffMaster> GetEnumerator()
        {
            return new StaffMasterEnumerator(this);
        }

        #endregion

        #region IEnumerable Implementation

        IEnumerator IEnumerable.GetEnumerator()
        {
            return new StaffMasterEnumerator(this);
        }

        #endregion


        private partial class StaffMasterEnumerator : IEnumerator<StaffMaster>
        {
            private IReader<StaffMaster> staffMasterReader;

            public StaffMasterEnumerator(IReader<StaffMaster> staffMasterReader)
            {
                this.staffMasterReader = staffMasterReader;
            }

            #region IEnumerator<StaffMaster> Members

            public StaffMaster Current
            {
                get { return this.staffMasterReader.Current; }
            }

            #endregion

            #region IDisposable Members

            public void Dispose()
            {
                this.staffMasterReader.Dispose();
            }

            #endregion

            #region IEnumerator Members

            object IEnumerator.Current
            {
                get { return this.staffMasterReader.Current; }
            }

            public bool MoveNext()
            {
                return this.staffMasterReader.Read();
            }

            public void Reset()
            {
                throw new Exception("Reset of staffmaster reader is not supported.");
            }

            #endregion

        }
    }
}
