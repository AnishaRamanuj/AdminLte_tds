<%@ WebService Language="C#" Class="Company" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data.SqlClient;
using System.Data;
using DataAccessLayer;
using Microsoft.ApplicationBlocks1.Data;
using CommonLibrary;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using System.Globalization;
using System.Web.Security;
using System.Text.RegularExpressions;
using JTMSProject;
using System.Security.Cryptography;
using System.IO;
using System.Text;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Company  : System.Web.Services.WebService {

    [System.Web.Services.WebMethod(EnableSession = true)]
    public string CreateCompany(string hdndtls) {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<CreateCompany> List_DS = new List<CreateCompany>();
        string[] dtls = hdndtls.ToString().Split('^');
        try
        {
            if (emailValid(dtls[3]))
            {

                MembershipCreateStatus status;
                string mail = dtls[3] + "- Company-Admin";

                string hashKey = "c/5vDl5UusKXMRvqFrJtMrsFJvaUuWKrGT35BLJnuE4=";
                string passEncrypt = string.Empty;
                passEncrypt = Encrypt( dtls[5]);


                Membership.CreateUser(dtls[4], dtls[5].Trim(), mail, "question", "answer", true, out status);
                switch (status)
                {
                    case (MembershipCreateStatus.Success):
                        {
                            Roles.AddUserToRole(dtls[4], "company");
                            Guid uid = new Guid((Membership.GetUser(dtls[4]).ProviderUserKey).ToString());

                            SqlParameter[] param = new SqlParameter[8];

                            param[0] = new SqlParameter("@CompanyName", dtls[0]);
                            param[1] = new SqlParameter("@Phone", dtls[2]);
                            param[2] = new SqlParameter("@Email", dtls[3]);
                            param[3] = new SqlParameter("@username", dtls[4]);
                            param[4] = new SqlParameter("@password", passEncrypt);
                            param[5] = new SqlParameter("@UserId", uid);
                            param[6] = new SqlParameter("@FirstName", dtls[1]);
                            param[7] = new SqlParameter("@hashKey", hashKey);

                            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_CreateCompany", param))
                            {
                                while (drrr.Read())
                                {
                                    List_DS.Add(new CreateCompany()
                                    {
                                        CompanyName = objComm.GetValue<string>(drrr["companyname"].ToString()),
                                        FirstName = objComm.GetValue<string>(drrr["firstname"].ToString()),
                                        Phone = objComm.GetValue<string>(drrr["phone"].ToString()),
                                        Email = objComm.GetValue<string>(drrr["email"].ToString()),
                                        Msg = "Thanks for SignUP.Please check your Mail for Login Details.",
                                    });
                                }
                            }

                            break;

                        }
                    case MembershipCreateStatus.DuplicateUserName:
                        {
                            List_DS.Add(new CreateCompany()
                            {
                                Msg = "USERNAME already exist, please try with different USERNAME",
                            });
                            break;
                        }
                    case MembershipCreateStatus.DuplicateEmail:
                        {
                            List_DS.Add(new CreateCompany()
                            {
                                Msg = "EMAIL already exist, please try with different EMAIL ID",
                            });
                            break;
                        }
                    case MembershipCreateStatus.InvalidEmail:
                        {
                            List_DS.Add(new CreateCompany()
                            {
                                Msg = "Email address you provided in invalid.",
                            });

                            break;
                        }
                    case MembershipCreateStatus.InvalidPassword:
                        {
                            List_DS.Add(new CreateCompany()
                            {
                                Msg = "The password provided is invalid. It must be seven characters long and have at least one non-alphanumeric character.",
                            });
                            break;
                        }
                    default:
                        {
                            List_DS.Add(new CreateCompany()
                            {
                                Msg = status.ToString(),
                            });

                            break;
                        }
                }
            }
            else
            {

                List_DS.Add(new CreateCompany()
                {
                    Msg = "Invalid EMAIL ID",
                });
            }

        }

        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<CreateCompany> tbl = List_DS as IEnumerable<CreateCompany>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }


    public bool emailValid(string email)
    {
        if (email != "")
        {
            //  string pattern = @"^[a-z][a-z|0-9|[-]]*([_][-][a-z|0-9]+)*([.][a-z|0-9]+([_][-][a-z|0-9]+)*)?@[a-z][-][a-z|0-9|]*\.([a-z][-][a-z|0-9]*(\.[a-z][-][a-z|0-9]*)?)$";
            string pattern = @"^(?!\.)(""([^""\r\\]|\\[""\r\\])*""|"
           + @"([-a-z0-9!#$%&'*+/=?^_`{|}~]|(?<!\.)\.)*)(?<!\.)"
           + @"@[a-z0-9][\w\.-]*[a-z0-9]\.[a-z][a-z\.]*[a-z]$";

            System.Text.RegularExpressions.Match match = Regex.Match(email.Trim(), pattern, RegexOptions.IgnoreCase);
            if (match.Success)
            {
                //string b = "true";
                //return b;
                return true;
            }
            else
            {
                //string b = "false";
                //return b;
                return false;
            }
        }
        else
        {
            return true;
        }
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