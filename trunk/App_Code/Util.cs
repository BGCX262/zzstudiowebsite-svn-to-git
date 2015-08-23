using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

/// <summary>
/// Summary description for Util
/// </summary>
public class Util
{
	public Util()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public readonly static string YapFileName = HttpContext.Current.Server.MapPath("/App_Data/ZzStudio.Yap");
}
