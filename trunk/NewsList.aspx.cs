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
using Net4.Services.Access;
using Net4.Common.Entities;

public partial class NewsList : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            this.rptNews.DataSource = AccessArticleService.Instance.SelectArticles(Category.News, 1, 15);
            this.rptNews.DataBind();
        }
    }
}
