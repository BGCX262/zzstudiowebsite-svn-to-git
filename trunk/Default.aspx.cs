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

public partial class _Default : System.Web.UI.Page
{
    protected Webpage webpage;
    protected void Page_Load(object sender, EventArgs e)
    {
        webpage  = Webpage.Instance;

        if (!IsPostBack)
        {
            rptNews.DataSource = AccessArticleService.Instance.SelectArticles(Category.News, 1, 5);
            rptNews.DataBind();

            rptMovies.DataSource = AccessArticleService.Instance.SelectArticles(Category.Movie, 1, 5);
            rptMovies.DataBind();
        }
    }

    [WebMethod]
    public static void SaveData(string propertyName, string propertyValue)
    {
        Webpage p = Webpage.Instance;
        p.Update(propertyName, propertyValue);
    }
}
