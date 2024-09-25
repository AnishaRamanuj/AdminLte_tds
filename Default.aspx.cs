using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using JTMSProject;
using System.Web.Security;
using System.Data;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks1.Data;
using System.Net;
using System.Security.Cryptography;
using System.IO;
using System.Text;
using CommonLogin;
public partial class _Default : System.Web.UI.Page
{
    private readonly DBAccess db = new DBAccess();
    string emailid = "";
    string msg = "";
    private static readonly byte[] Key = Encoding.UTF8.GetBytes("12345678901234567890123456789012"); // 32 bytes for AES-256
    private static readonly byte[] IV = Encoding.UTF8.GetBytes("1234567890123456"); // 16 bytes for AES

    protected void Page_Load(object sender, EventArgs e)
    {
		//if (Request.Browser["IsMobileDevice"] == "true")
        //{
          // Response.Redirect("MobDefault.aspx");
       // }

        if (!IsPostBack)
        {
            Session["Error"] = "";
		    Session["Login"]="1";
            string Urlhost = HttpContext.Current.Request.Url.ToString();
            Session["Urlhost"] = Urlhost;
            string Uhost = HttpContext.Current.Request.Url.Host;
            Session["Uhost"] = Uhost;
            //MessageBox.Show(Urhost);

            if (Request.Cookies.Count > 0)
            {
                HttpCookie reqCookies = Request.Cookies["tmxuserInfo"];
                if (reqCookies != null)
                {
                    if (reqCookies.Values[0].ToString() != "")
                    {
                        //if (Request.Cookies["tmxlogin"].Value == "true")
                        //{
                        //chkRememberMe_.Checked = true;
                        txtUsername.Value = reqCookies["tmxuser"].ToString();
                        txtPassword.Value = reqCookies["tmxpwd"].ToString();
                        Session["Username"] = reqCookies["tmxuser"].ToString();
                        Session["Password"] = reqCookies["tmxpwd"].ToString();
                        Session["Lat"] = hdnLat.Value;
                        Session["Log"] = hdnLog.Value;
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "alertEmployee", "Login()", true);
                        //}
                    }
                }
            }
        }
       // GetMenuDetails();
    }




    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        CommonLogin.CommonLoginUsr objComm = new CommonLogin.CommonLoginUsr();
        string u =  txtUsername.Value; 
      string p = txtPassword.Value;
        string passEncrypt = string.Empty;
        string passDecrypt = string.Empty;
        DataSet ds ;
        DataSet dds;
        if (Roles.IsUserInRole(u, "company"))
        {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@usrname", u.ToString());
            param[1] = new SqlParameter("@roles", "Company");

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Login", param);
           if (ds != null && ds.Tables[0].Rows.Count != 0)
            {
                var hashKey = ds.Tables[0].Rows[0]["Hashkey"].ToString();
                var uidsr = ds.Tables[0].Rows[0]["userid"].ToString();
                var pE = Encrypt(ds.Tables[0].Rows[0]["mPassword"].ToString());
                var pSE = (ds.Tables[0].Rows[0]["cPassword"].ToString());
                passEncrypt = Encrypt(p);
                ///////////////// haskKey is null
                if (string.IsNullOrEmpty(hashKey))
                {
                    hashKey = "c/5vDl5UusKXMRvqFrJtMrsFJvaUuWKrGT35BLJnuE4=";
                    SqlParameter[] Eparam = new SqlParameter[4];
                    Eparam[0] = new SqlParameter("@usrname", u.ToString());
                    Eparam[1] = new SqlParameter("@roles", "Company");
                    Eparam[2] = new SqlParameter("@Hash", hashKey);
                    Eparam[3] = new SqlParameter("@passEncrypt", pE);

                    dds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Login_Save", Eparam);

                }
                if (pE != pSE)
                {
                    hashKey = "c/5vDl5UusKXMRvqFrJtMrsFJvaUuWKrGT35BLJnuE4=";
                    SqlParameter[] Eparam = new SqlParameter[4];
                    Eparam[0] = new SqlParameter("@usrname", u.ToString());
                    Eparam[1] = new SqlParameter("@roles", "Company");
                    Eparam[2] = new SqlParameter("@Hash", hashKey);
                    Eparam[3] = new SqlParameter("@passEncrypt", pE);

                    dds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Login_Save", Eparam);
                }

                else
                {
                    passDecrypt = Decrypt(ds.Tables[0].Rows[0]["cPassword"].ToString());
                    
                    if (passDecrypt == p)
                    {
                        passEncrypt = ds.Tables[0].Rows[0]["cPassword"].ToString();
                    }
                }
                string strUpdateSql1 = "INSERT INTO [dbo].[Jtms_Logs]([Username],[password],[Encryptedpassword],[Decryptedpassword]) VALUES ('" + u.ToString()+"','"+p.ToString()+"','"+passEncrypt+ "', '" + passDecrypt + "')";
                db.ExecuteCommand(strUpdateSql1);
            }

        }
        else if(Roles.IsUserInRole(u, "staff"))
        {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@usrname", u.ToString());
            param[1] = new SqlParameter("@roles", "Staff");
            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Login", param);

            if (ds != null && ds.Tables[0].Rows.Count != 0)
            {
                var hashKey = ds.Tables[0].Rows[0]["Hashkey"].ToString();
                var uidsr = ds.Tables[0].Rows[0]["userid"].ToString();
                var pE = Encrypt(ds.Tables[0].Rows[0]["mPassword"].ToString());
                var pSE = (ds.Tables[0].Rows[0]["sPassword"].ToString());
                passEncrypt = Encrypt(p);
                ///////////////// haskKey is null
                if (string.IsNullOrEmpty(hashKey))
                {
                    hashKey = "c/5vDl5UusKXMRvqFrJtMrsFJvaUuWKrGT35BLJnuE4=";
                    SqlParameter[] Eparam = new SqlParameter[4];
                    Eparam[0] = new SqlParameter("@usrname", u.ToString());
                    Eparam[1] = new SqlParameter("@roles", "Staff");
                    Eparam[2] = new SqlParameter("@Hash", hashKey);
                    Eparam[3] = new SqlParameter("@passEncrypt", pE);

                    dds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Login_Save", Eparam);

                }
                if (pE != pSE)
                {
                    hashKey = "c/5vDl5UusKXMRvqFrJtMrsFJvaUuWKrGT35BLJnuE4=";
                    SqlParameter[] Eparam = new SqlParameter[4];
                    Eparam[0] = new SqlParameter("@usrname", u.ToString());
                    Eparam[1] = new SqlParameter("@roles", "Staff");
                    Eparam[2] = new SqlParameter("@Hash", hashKey);
                    Eparam[3] = new SqlParameter("@passEncrypt", pE);

                    dds =  SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Login_Save", Eparam);
                }

                else
                {
                    passDecrypt = Decrypt(ds.Tables[0].Rows[0]["sPassword"].ToString());
                    if (passDecrypt == p)
                    {
                        passEncrypt = Encrypt(p);
                    }
                }

                string strUpdateSql1 = "INSERT INTO [dbo].[Jtms_Logs]([Username],[password],[Encryptedpassword],[Decryptedpassword]) VALUES ('" + u.ToString() + "','" + p.ToString() + "','" + passEncrypt + "', '" + passDecrypt + "')";
                db.ExecuteCommand(strUpdateSql1);
            }
        }
        else if (Roles.IsUserInRole(u, "superadmin"))
        {
            passEncrypt = Encrypt(p);
            string strUpdateSql1 = "INSERT INTO [dbo].[Jtms_Logs]([Username],[password],[Encryptedpassword],[Decryptedpassword]) VALUES ('" + u.ToString() + "','" + p.ToString() + "','" + passEncrypt + "', '" + passDecrypt + "')";
            db.ExecuteCommand(strUpdateSql1);

        }
        Session["Username"] = u;
        Session["Password"] = passEncrypt;
        Session["Lat"] = hdnLat.Value;
        Session["Log"] = hdnLog.Value;
        HttpCookie userInfo = new HttpCookie("tmxuserInfo");

        //if (chkRememberMe_.Checked)
        //{
        userInfo["tmxuser"] = txtUsername.Value;
        userInfo["tmxpwd"] = passEncrypt;
        userInfo["tmxlogin"] = "true";
        userInfo["tmxrem"] = chkRememberMe_.Checked.ToString();
        userInfo.Expires.AddDays(15);
        Response.Cookies.Add(userInfo);

        //Response.Cookies["tmxuser"].Expires.AddDays(15);
        //    Response.Cookies["tmxpwd"].Expires.AddDays(15);
        //    Response.Cookies["tmxrem"].Expires.AddDays(15);
        //    Response.Cookies["tmxlogin"].Expires.AddDays(15);
        //}
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alertEmployee", "Login()", true);
    }

    private string Encrypt(string clearText)
    {
        string EncryptionKey = "c/5vDl5UusKXMRvqFrJtMrsFJvaUuWKrGT35BLJnuE4=";
        byte[] clearBytes = Encoding.Unicode.GetBytes(clearText);
        using (Aes encryptor = Aes.Create())
        {
            Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
            encryptor.Key = pdb.GetBytes(32);
            encryptor.IV = pdb.GetBytes(16);
            using (MemoryStream ms = new MemoryStream())
            {
                using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateEncryptor(), CryptoStreamMode.Write))
                {
                    cs.Write(clearBytes, 0, clearBytes.Length);
                    cs.Close();
                }
                clearText = Convert.ToBase64String(ms.ToArray());
            }
        }
        return clearText;
    }

    private string Decrypt(string cipherText)
    {
        string EncryptionKey = "c/5vDl5UusKXMRvqFrJtMrsFJvaUuWKrGT35BLJnuE4=";
        cipherText = cipherText.Replace(" ", "+");

        byte[] cipherBytes = Convert.FromBase64String(cipherText);
        using (Aes encryptor = Aes.Create())
        {
            Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
            encryptor.Key = pdb.GetBytes(32);
            encryptor.IV = pdb.GetBytes(16);
            using (MemoryStream ms = new MemoryStream())
            {
                using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateDecryptor(), CryptoStreamMode.Write))
                {
                    cs.Write(cipherBytes, 0, cipherBytes.Length);
                    cs.Close();
                }
                cipherText = Encoding.Unicode.GetString(ms.ToArray());
            }
        }
        return cipherText;
    }



}
