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

public partial class MovieList : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            this.rptMovies.DataSource = AccessArticleService.Instance.SelectArticles(Category.Movie, 1, 15);
            this.rptMovies.DataBind();
        }
    }
}
