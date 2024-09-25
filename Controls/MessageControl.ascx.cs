using System;
using System.Web.UI;

///<summary>
/// 
///</summary>
public class MessageDisplay
{
    #region DisplayStyles enum

    ///<summary>
    /// Message display styles
    ///</summary>
    public enum DisplayStyles
    {
        Info,
        Success,
        Warning,
        Error,
        Validation,
        None
    }

    #endregion
}

///<summary>
///
///</summary>
public partial class controls_MessageControl : UserControl
{
    ///<summary>
    /// Message to be displayed.
    ///</summary>
    public string DisplayMessage
    {
        get { return ViewState["message"] != null ? ViewState["message"].ToString() : ""; }
        set
        {
            ViewState["message"] = value;
            msgBx.InnerText = value;
        }
    }

    ///<summary>
    /// Message style to be displayed.
    ///</summary>
    public MessageDisplay.DisplayStyles CssClass
    {
        set
        {
            ViewState["css"] = value;
            if (DisplayMessage.Length > 0)
                msgBx.Attributes.Add("class", className);
        }
    }

    private string className
    {
        get
        {
            string cssClass = "";
            if (ViewState["css"] != null)
            {
                switch (ViewState["css"].ToString())
                {
                    case "Info":
                        cssClass = "info";
                        break;
                    case "Success":
                        cssClass = "success";
                        break;
                    case "Warning":
                        cssClass = "warning";
                        break;
                    case "Validation":
                        cssClass = "validation";
                        break;
                    case "Error":
                        cssClass = "error";
                        break;
                }
            }
            return cssClass;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
        {
            DisplayMessage = "";
            if (DisplayMessage.Length > 0) msgBx.Attributes.Add("class", className);
        }
        if (ScriptManager.GetCurrent(Page) != null)
            ScriptManager.RegisterStartupScript(Label1, Label1.GetType(), Guid.NewGuid().ToString(),
                                                "disappearControl('" + msgBx.ClientID + "');", true);
    }

    ///<summary>
    /// Sets the message and style to display the message in the message control
    ///</summary>
    ///<param name="message">Message to be displayed</param>
    ///<param name="cssClass">Style of display of message</param>
    public void SetMessage(string message, MessageDisplay.DisplayStyles cssClass)
    {
        DisplayMessage = message;
        CssClass = cssClass;
    }
}