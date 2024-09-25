using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using JTMSProject;

public partial class controls_CompletedJobs : System.Web.UI.UserControl
{
    private readonly DBAccess db = new DBAccess();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["companyid"] != null)
            {
                ViewState["compid"] = Session["companyid"].ToString();
            }
            else if (Session["staffid"] != null)
            {
                ViewState["compid"] = Session["cltcomp"].ToString();
            }


            if (ViewState["compid"] != null)
            {
                bindgrid1();
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
        }

    }
    public SqlDataSource userlist_data
    {
        get { return SqlDataSource1; }
    }

    public void bindgrid1()
    {

        try
        {

            int j = 0;
            int i = 0;
            if (Session["first"] == null)
            {
                Session["first"] = 1;
                j = 1;
                i = 1;
            }
            else
            {
                i = int.Parse(Session["first"].ToString());
            }
            //i = Griddealers.PageIndex;
            if (i == 0)
            {
                i = 1;
                j = 1;
            }
            i = i * 25;
            j = i - 25;
            if (j == 0)
            {
                j = 1;
            }
            string sql = "";
            //sql = "select * from (select row_number() over(order by j.mJobName asc)as sino,j.JobId,j.mJobName,j.BudHours,CONVERT(numeric(18,2),j.BudAmt) as 'BudAmt',jg.JobGroupName as jobgroup,dbo.SumTotal(j.JobId) as Total,j.Jobstatus,CONVERT(VARCHAR(10), j.CreationDate, 103) AS CreationDate,(case when j.EndDate <> '' then CONVERT(VARCHAR(10),  j.EndDate, 103) else null end) as 'EndDate',DATEDIFF(DD,j.CreationDate,j.EndDate) as 'Diff' ,CM.ClientName from vw_Job_New as j left join dbo.JobGroup_Master as jg on j.JobGId=jg.JobGId LEFT OUTER JOIN Client_Master CM ON j.cltid=CM.CLTId where j.CompId='" + ViewState["compid"].ToString() + "' and JobStatus='OnGoing' ) as a  where  sino BETWEEN " + j + " AND " + i + " ";
            sql = "select * from (SELECT row_number() over(order by JM.MJobName asc)as sino,J.JobId,JM.MJobName, SUM(convert(numeric(18,2),tt.TotalTime)) as ActualHours, sum(convert(numeric(18,2),tt.HourlyCharges)) as ActualAmt,"
                + " J.CLTId, C.ClientName, J.mJobID, CONVERT(VARCHAR(10), J.CreationDate, 103) AS CreationDate, J.EndDate, J.BudHours,  J.BudAMt, J.JobStatus, J.JobGId, JG.JobGroupName, "
+ " CONVERT(VARCHAR(10), J.ActualJobEndate, 103) AS ActualJobEndate FROM  dbo.Job_Master as J INNER JOIN dbo.Client_Master as C  ON C.CLTId = J.CLTId  INNER JOIN dbo.JobName_Master as JM ON J.mJobID = JM.MJobId "
+ "  LEFT OUTER JOIN  dbo.JobGroup_Master as JG ON J.JobGId = JG.JobGId  LEFT OUTER JOIN TimeSheet_Table tt on j.JobId=tt.JobId  where J.CompId='" + ViewState["compid"].ToString() + "'  and J.JobStatus='Completed' "
+ "  group by  j.JobId,jm.MJobName, j.CLTId,c.ClientName, j.mJobID, j.CreationDate, J.EndDate,J.BudHours,  J.BudAMt, J.JobStatus, J.JobGId, JG.JobGroupName, J.ActualJobEndate  ) as a  "
+ "  where  sino BETWEEN " + j + " AND " + i + " ";

            DataTable dt2 = db.GetDataTable(sql);
            if (dt2.Rows.Count != 0 && dt2 != null)
            {
                Griddealers.DataSource = dt2;
                Griddealers.DataBind();
            }
            else
            {
                BtnPrevious.Visible = false;
                BtnNext.Visible = false;

            }
        }
        catch (Exception ex)
        {

        }
    }

    public SqlDataSource Job
    {
        get { return SqlDataSource3; }
    }

    protected void lnkChangeStatus_Click(object sender, EventArgs e)
    {
        try
        {
            LinkButton lnkbtn = sender as LinkButton;
            if (lnkbtn != null)
            {
                string JobID = lnkbtn.CommandArgument;
                string StrSQL = "update Job_Master set JobStatus='OnGoing' where JobId=" + JobID;
                Job.UpdateCommand = StrSQL;
                int res = db.ExecuteCommand(StrSQL);
                if (res > 0)
                {
                    bindgrid1();
                    MessageControl.SetMessage("Job updated successfully", MessageDisplay.DisplayStyles.Info);
                }
            }
        }
        catch
        {
        }
    }

    protected void Griddealers_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        try
        {
            Griddealers.PageIndex = e.NewPageIndex;

            bindgrid1();

            UpdatePanel1.Update();
        }
        catch (Exception ex)
        {

        }
    }
    protected void Griddealers_RowCommand(object sender, GridViewCommandEventArgs e)
    {

    }


    protected void Griddealers_RowDataBound(object sender, GridViewRowEventArgs e)
    {


    }
    protected void BtnPrevious_Click(object sender, EventArgs e)
    {
        if (Session["first"].ToString() == "1")
        {
            BtnPrevious.Enabled = false;
        }
        else
        {
            int i = int.Parse(Session["first"].ToString());
            i = i - 1;
            Session["first"] = i;
            bindgrid1();
        }
    }
    protected void BtnNext_Click(object sender, EventArgs e)
    {
        int i = int.Parse(Session["first"].ToString());
        i = i + 1;
        Session["first"] = i;
        bindgrid1();
    }

    protected void btnsrchjob_Click(object sender, EventArgs e)
    {
        string txtval = "";
        string txtcl = "";
        if (ddlSearchby.SelectedValue == "Job")
        { txtval = txtSearchby.Text; }
        else if (ddlSearchby.SelectedValue == "Client")
        { txtcl = txtSearchby.Text; }
        string sql = "";

        if (txtval != "")
        {
            if (txtcl != "")
            {
                sql = " and  jm.mJobName like '%" + txtval + "%' and C.ClientName like '%" + txtcl + "%'";
            }

            else
            {
                sql = " and  jm.mJobName like '%" + txtval + "%'";
            }
        }
        else
        {
            sql = " and C.ClientName like '%" + txtcl + "%'";
        }


        int j = 0;
        int i = 0;
        if (Session["first"] == null)
        {
            Session["first"] = 1;
            j = 1;
            i = 1;
        }
        else
        {
            i = int.Parse(Session["first"].ToString());
        }
        //i = Griddealers.PageIndex;
        if (i == 0)
        {
            i = 1;
            j = 1;
        }
        i = i * 25;
        j = i - 25;
        if (j == 0)
        {
            j = 1;
        }

        //sql = "select * from (select row_number() over(order by j.mJobName asc)as sino,j.JobId,j.mJobName,j.BudHours,CONVERT(numeric(18,2),j.BudAmt) as 'BudAmt',jg.JobGroupName as jobgroup,dbo.SumTotal(j.JobId) as Total,j.Jobstatus,CONVERT(VARCHAR(10), j.CreationDate, 103) AS CreationDate,(case when j.EndDate <> '' then CONVERT(VARCHAR(10),  j.EndDate, 103) else null end) as 'EndDate',DATEDIFF(DD,j.CreationDate,j.EndDate) as 'Diff' ,CM.ClientName from vw_Job_New as j left join dbo.JobGroup_Master as jg on j.JobGId=jg.JobGId LEFT OUTER JOIN Client_Master CM ON j.cltid=CM.CLTId where j.CompId='" + ViewState["compid"].ToString() + "' and JobStatus='OnGoing' ) as a  where  sino BETWEEN " + j + " AND " + i + " ";


        sql = "select * from (SELECT row_number() over(order by JM.MJobName asc)as sino,J.JobId,JM.MJobName, SUM(convert(numeric(18,2),tt.TotalTime)) as ActualHours, sum(convert(numeric(18,2),tt.HourlyCharges)) as ActualAmt,"
            + " J.CLTId, C.ClientName, J.mJobID, CONVERT(VARCHAR(10), J.CreationDate, 103) AS CreationDate, J.EndDate, J.BudHours,  J.BudAMt, J.JobStatus, J.JobGId, JG.JobGroupName, "
            + " CONVERT(VARCHAR(10), J.ActualJobEndate, 103) AS ActualJobEndate FROM  dbo.Job_Master as J INNER JOIN dbo.Client_Master as C  ON C.CLTId = J.CLTId  INNER JOIN dbo.JobName_Master as JM ON J.mJobID = JM.MJobId "
            + "  LEFT OUTER JOIN  dbo.JobGroup_Master as JG ON J.JobGId = JG.JobGId  inner join TimeSheet_Table tt on j.JobId=tt.JobId  where J.CompId='" + ViewState["compid"].ToString() + "'  and J.JobStatus='Completed' " + sql + " "
            + "  group by  j.JobId,jm.MJobName, j.CLTId,c.ClientName, j.mJobID, j.CreationDate, J.EndDate,J.BudHours,  J.BudAMt, J.JobStatus, J.JobGId, JG.JobGroupName, J.ActualJobEndate ) as a  where  sino BETWEEN " + j + " AND " + i + " ";
        DataTable dt2 = db.GetDataTable(sql);
        if (dt2.Rows.Count != 0 && dt2 != null)
        {
            Griddealers.DataSource = dt2;
            Griddealers.DataBind();
        }
        else
        {
            MessageControl.SetMessage("Completed Jobs not found", MessageDisplay.DisplayStyles.Info);
            BtnPrevious.Visible = false;
            BtnNext.Visible = false;

        }

    }
}
