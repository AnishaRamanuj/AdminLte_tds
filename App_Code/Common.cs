using System;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.ApplicationBlocks1.Data;
using System.Security.Cryptography;
namespace DataAccessLayer
{
    public class Common
    {

        #region Variables
        //Declare all your variables here 
        public string cnnstring = "";
        public string cnnstring1 = "";
        public string cnnstring2 = "";
        public static byte[] imageBytes;
        public string companyid = "";
        public string UserRole = "";
        public string RoleName = "";
        public string StaffID = "";
        public string PrjID = "";

        #endregion

        #region PropertyNames and Setter, Getters
        //variables declared above will be set into property in your each class. 
        public string _cnnString
        {
            get { return cnnstring; }
            set { cnnstring = value; }
        }

        #endregion

        #region PropertyNames and Setter, Getters
        //variables declared above will be set into property in your each class. 
        public string _cnnString1
        {
            get { return cnnstring1; }
            set { cnnstring1 = value; }
        }

        public string _Compid
        {
            get { return companyid; }
            set { companyid = value; }
        }

        public string _RoleNm
        {
            get { return RoleName; }
            set { RoleName = value; }
        }

        public string _URole
        {
            get { return UserRole; }
            set { UserRole = value; }
        }

        public string _StaffId
        {
            get { return StaffID; }
            set { StaffID = value; }
        }

        public string _Pid
        {
            get { return PrjID; }
            set { PrjID = value; }
        }

        public string _cnnString2
        {
            // get { return cnnstring2; }
            get { return this.Connection_String_2(); }
            set { cnnstring2 = value; }
        }

        #endregion

        public string Connection_String_2()
        {
            string DB_Con = "";
            try
            {
                
                    DB_Con = (string)HttpContext.Current.Session["DB_Conn"];
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
            return DB_Con;
        }



        public Common()
        {


            HttpCookie reqCookies = HttpContext.Current.Request.Cookies["CDetails"];
            if (reqCookies != null)
            {
                if (reqCookies.Values.ToString() != "")
                {
                    //  DB_Con = reqCookies["DBName"].ToString();
                    _Compid = DecryptCookieValue(reqCookies["Compid"].ToString(), "c/5vDl5UusKXMRvqFrJtMrsFJvaUuWKrGT35BLJnuE4=");
                    _RoleNm = DecryptCookieValue(reqCookies["RoleName"].ToString(), "c/5vDl5UusKXMRvqFrJtMrsFJvaUuWKrGT35BLJnuE4=");
                    _URole = DecryptCookieValue(reqCookies["UserRole"].ToString(), "c/5vDl5UusKXMRvqFrJtMrsFJvaUuWKrGT35BLJnuE4=");
                    _StaffId = DecryptCookieValue(reqCookies["Staffid"].ToString(), "c/5vDl5UusKXMRvqFrJtMrsFJvaUuWKrGT35BLJnuE4=");
                }
            }

            HttpCookie PrjCookies = HttpContext.Current.Request.Cookies["PrjID"];
            if (PrjCookies != null)
            {
                if (PrjCookies.Values.ToString() != "")
                {
                    //  DB_Con = reqCookies["DBName"].ToString();
                    _Pid = DecryptCookieValue(PrjCookies["PID"].ToString(), "c/5vDl5UusKXMRvqFrJtMrsFJvaUuWKrGT35BLJnuE4=");
                }
            }
            _cnnString = System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString();


        }

        public static string DecryptCookieValue(string encryptedText, string key)
        {
            using (Aes aesAlg = Aes.Create())
            {
                aesAlg.Key = Convert.FromBase64String(key);

                byte[] fullCipher = Convert.FromBase64String(encryptedText);

                // Extract the IV from the beginning of the cipher text
                byte[] iv = new byte[aesAlg.BlockSize / 8];
                Array.Copy(fullCipher, 0, iv, 0, iv.Length);

                // Extract the actual encrypted data
                byte[] cipherText = new byte[fullCipher.Length - iv.Length];
                Array.Copy(fullCipher, iv.Length, cipherText, 0, cipherText.Length);

                ICryptoTransform decryptor = aesAlg.CreateDecryptor(aesAlg.Key, iv);

                using (MemoryStream msDecrypt = new MemoryStream(cipherText))
                using (CryptoStream csDecrypt = new CryptoStream(msDecrypt, decryptor, CryptoStreamMode.Read))
                using (StreamReader srDecrypt = new StreamReader(csDecrypt))
                {
                    return srDecrypt.ReadToEnd();
                }
            }
        }

        public SqlConnection openConnection()
        {
            SqlConnection cnn = new SqlConnection();
            try
            {
                _cnnString = ConfigurationManager.ConnectionStrings["ConnectionString"].ToString();
                cnn.ConnectionString = _cnnString;
                cnn.Open();
            }
            catch (Exception ex)
            {
                if (cnn.State == ConnectionState.Open)
                    cnn.Close();
                throw ex;
            }
            return cnn;
        }

        public void closeConnection(SqlConnection cnn)
        {
            if (cnn.State == ConnectionState.Open)
                cnn.Close();
            cnn.Dispose();
        }

        public DataSet getValues(string sp_name)
        {
            DataSet ds = new DataSet();

            return ds;
        }

        public string ReturnHTML(string Path)
        {
            string strBody = "";
            try
            {

                StreamReader objReader = new StreamReader(Path);
                strBody = objReader.ReadToEnd();
                objReader.Close();
            }
            catch (Exception ex)
            {
                strBody = "";
                throw ex;
            }
            return strBody;
        }


        public SqlConnection getConnection()
        {
            SqlConnection cn = new SqlConnection(_cnnString);
            cn.Open();
            return cn;
        }

        public DataSet GetDBName()
        {
            DataSet ds = null;
            string sql = "";
            
            sql = "Select DBname from company_master where compid=" + HttpContext.Current.Session["companyid"];
            try
            {
                ds = SqlHelper.ExecuteDataset(_cnnString, CommandType.Text, sql);
            }
            catch (Exception ex)
            {
               
            }

            return ds;
        }






        /*-------------------------------------------*/


        //public Common()
        //{
        //    _cnnString1 = System.Configuration.ConfigurationManager.ConnectionStrings["McdConn1"].ToString();
        //}

    }
	
}
