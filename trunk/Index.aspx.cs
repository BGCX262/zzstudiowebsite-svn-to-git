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

public partial class Index : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Page.Response.Expires = -1; //设置马上过期，因为浏览器会缓存上次的内容
        Random rand = new Random(DateTime.Now.Millisecond);
        indexLogo.Src = string.Format("~/images/index_logo{0}.jpg", rand.Next(1, 12));
    }
}
