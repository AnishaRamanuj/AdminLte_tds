using System.Data;
using System.Web;

namespace JTMSProject
{
    /// <summary>
    /// Summary description for HospitalCommon
    /// </summary>
    public class Timecommon
    {
        private readonly DBAccess DB = new DBAccess();

        public int CurrentPatientID
        {
            get
            {
                int id;
                int.TryParse(
                    HttpContext.Current.Session["staffid"] != null
                        ? HttpContext.Current.Session["patientID"].ToString()
                        : "0", out id);
                if (id == 0)
                    HttpContext.Current.Response.Redirect("~/Default.aspx");
                return id;
            }
            set { HttpContext.Current.Session["staffid"] = value; }
        }

        public int CurrentContactID
        {
            get
            {
                int id;
                int.TryParse(
                    HttpContext.Current.Session["staffid"] != null
                        ? HttpContext.Current.Session["staffid"].ToString()
                        : "0", out id);
                return id;
            }
            set { HttpContext.Current.Session["staffid"] = value; }
        }

        /// <summary>
        /// Gets or sets the names of currently stored patients in the cache for better search speed
        /// </summary>
        public DataTable PatientNames
        {
            get
            {
                DataTable dtNames = HttpContext.Current.Cache["patientNames"] as DataTable;
                if (dtNames == null)
                {
                    HttpContext.Current.Cache["patientNames"] =
                        DB.GetDataTable("SELECT FirstName + ' ' + SurName AS patientname FROM tblMainData");
                }
                return dtNames;
            }
            set
            {
                HttpContext.Current.Cache["patientNames"] = value;
                if (value == null)
                {
                    HttpContext.Current.Cache["patientNames"] =
                        DB.GetDataTable("SELECT FirstName + ' ' + SurName AS patientname FROM tblMainData");
                }
            }
        }

        public DataTable SearchPatientIds
        {
            get
            {
                DataTable dtNames = HttpContext.Current.Cache["searchpatientids"] as DataTable;
                if (dtNames == null)
                {
                    HttpContext.Current.Cache["searchpatientids"] =
                        DB.GetDataTable("SELECT convert(varchar, PatientID) AS patientid FROM tblMainData");
                }
                return dtNames;
            }
            set
            {
                HttpContext.Current.Cache["searchpatientids"] = value;
                if (value == null)
                {
                    HttpContext.Current.Cache["searchpatientids"] =
                        DB.GetDataTable("SELECT convert(varchar, PatientID) AS patientid FROM tblMainData");
                }
            }
        }

        public DataTable SearchPatientSSN
        {
            get
            {
                DataTable dtNames = HttpContext.Current.Cache["searchpatientssn"] as DataTable;
                if (dtNames == null)
                {
                    HttpContext.Current.Cache["searchpatientssn"] =
                        DB.GetDataTable("SELECT SosialSecurityNum AS patientssn FROM tblMainData");
                }
                return dtNames;
            }
            set
            {
                HttpContext.Current.Cache["searchpatientssn"] = value;
                if (value == null)
                {
                    HttpContext.Current.Cache["searchpatientssn"] =
                        DB.GetDataTable("SELECT SosialSecurityNum AS patientssn FROM tblMainData");
                }
            }
        }

        public void ResetSearchData()
        {
            PatientNames = null;
            SearchPatientIds = null;
            SearchPatientSSN = null;
        }
    }
}