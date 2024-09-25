using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MailToApproverSchedular
{
    public class CommonFunction
    {
        public string cnnstring = "";
        public string _cnnString
        {
            get { return cnnstring; }
            set { cnnstring = value; }
        }

        public CommonFunction()
        {
            _cnnString = System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString();

        }
    }
}