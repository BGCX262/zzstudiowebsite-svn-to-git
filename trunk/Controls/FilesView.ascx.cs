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

public partial class Controls_FilesView : System.Web.UI.UserControl
{
    public object DataSource
    {
        set
        {
            this.rptFiles.DataSource = value;
            //this.rptFiles.DataBind();
        }
    }

    protected bool _ShowSnapShot = false;

    public bool ShowSnapShot
    {
        get { return _ShowSnapShot; }
        set { _ShowSnapShot = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {

    }
}
