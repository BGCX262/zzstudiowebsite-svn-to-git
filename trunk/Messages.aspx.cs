using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.Services;
using Net4.Services.Access;
using Net4.Common.Entities;

public partial class Comment : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindDatas();
        }
    }

    private int PageIndex
    {
        get 
        {
            int page = 1;
            if (!string.IsNullOrEmpty(Request.QueryString["page"]))
            {
                page = int.Parse(Request.QueryString["page"]);
                if (page < 1) page = 1;
            }
            return page;
        }
    }

    private void BindDatas()
    {
        this.rptMessageList.DataSource = 
            AccessMessageService.Instance.SelectMessages(PageIndex, anpMessagesList.PageSize);
        this.rptMessageList.DataBind();
        anpMessagesList.RecordCount = AccessMessageService.Instance.GetMessagesTotalCount();
    }

    [WebMethod]
    public static Message AddMessage(string userName, string email, string subject, string message)
    {
        AccessMessageService service = AccessMessageService.Instance;
        Message msg = new Message(userName, email, subject, 
            message, HttpContext.Current.Request.UserHostAddress);
        service.Insert(msg);
        return msg;
    }

    [WebMethod]
    public static Message ReplyMessage(int id, string replyBody)
    {
        if (!HttpContext.Current.User.Identity.IsAuthenticated)
        {
            throw new System.Security.SecurityException("没有权限.");
        }
        AccessMessageService service = AccessMessageService.Instance;
        Message msg = service.Select(id);
        msg.Reply = replyBody;
        msg.ReplyDate = DateTime.Now;
        service.Update(msg);
        return msg;
    }

    [WebMethod]
    public static bool DeleteMessage(int id)
    {
        if (!HttpContext.Current.User.Identity.IsAuthenticated)
        {
            throw new System.Security.SecurityException("没有权限.");
        }
        AccessMessageService service = AccessMessageService.Instance;
        service.Delete(id);
        return true;
    }

    protected void lbtnRefreshMessages_Click(object sender, EventArgs e)
    {
        BindDatas();
    }
}
