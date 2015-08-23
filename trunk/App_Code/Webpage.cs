using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Collections.Generic;
using System.Reflection;
using System.Xml;

/// <summary>
/// Summary description for Webpage
/// </summary>
public class Webpage
{
    private string _authorIntroTitle;
    /// <summary>
    /// Gets or sets the author intro title.
    /// </summary>
    /// <value>The author intro title.</value>
    public string AuthorIntroTitle
    {
        get
        {
            return string.IsNullOrEmpty(_authorIntroTitle) ? "author introductory title" : _authorIntroTitle;
        }
        set { _authorIntroTitle = value; }
    }

    private string _authorIntro;
    /// <summary>
    /// Gets or sets the author intro.
    /// </summary>
    /// <value>The author intro.</value>
    public string AuthorIntro
    {
        get
        {
            return string.IsNullOrEmpty(_authorIntro) ? "author introductory" : _authorIntro;
        }
        set { _authorIntro = value; }
    }

    private string _studioIntroTitle;
    /// <summary>
    /// Gets or sets the studio intro title.
    /// </summary>
    /// <value>The studio intro title.</value>
    public string StudioIntroTitle
    {
        get
        {
            return string.IsNullOrEmpty(_studioIntroTitle) ? "studio introductory title" : _studioIntroTitle;
        }
        set { _studioIntroTitle = value; }
    }

    private string _studioIntro;
    /// <summary>
    /// Gets or sets the studio intro.
    /// </summary>
    /// <value>The studio intro.</value>
    public string StudioIntro
    {
        get
        {
            return string.IsNullOrEmpty(_studioIntro) ? "studio introductory" : _studioIntro;
        }
        set { _studioIntro = value; }
    }

    private Webpage()
    {
        Load();
    }

    private void Load()
    {
        Type type = this.GetType();
        string filename = System.Web.HttpContext.Current.Server.MapPath("~/App_Data/webpageInfos.xml");
        if (!System.IO.File.Exists(filename))
        {
            this.Save();
        }
        XmlDocument doc = new XmlDocument();
        doc.Load(filename);

        foreach (XmlNode settingsNode in doc.SelectSingleNode("webpageInfos").ChildNodes)
        {
            string name = settingsNode.Name;
            string value = settingsNode.InnerText;

            type.GetProperty(name).SetValue(this, value, null);
        }

    }

    private static Webpage _instance;

    /// <summary>
    /// Gets the instance.
    /// </summary>
    /// <value>The instance.</value>
    public static Webpage Instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = new Webpage();
            }
            return _instance;
        }
    }

    /// <summary>
    /// Updates the specified property name.
    /// </summary>
    /// <param name="propertyName">Name of the property.</param>
    /// <param name="propertyValue">The property value.</param>
    public void Update(string propertyName, string propertyValue)
    {
        this.GetType().GetProperty(propertyName).SetValue(this, propertyValue, null);
        this.Save();
    }

    #region Save()
    /// <summary>
    /// Saves the webpage information to disk.
    /// </summary>
    public void Save()
    {
        Type settingsType = this.GetType();
        string filename = System.Web.HttpContext.Current.Server.MapPath("~/App_Data/webpageInfos.xml");
        XmlWriterSettings writerSettings = new XmlWriterSettings(); ;
        writerSettings.Indent = true;
        using (XmlWriter writer = XmlWriter.Create(filename, writerSettings))
        {
            writer.WriteStartElement("webpageInfos");

            //------------------------------------------------------------
            //	Enumerate through settings properties
            //------------------------------------------------------------
            foreach (PropertyInfo propertyInformation in settingsType.GetProperties())
            {
                try
                {
                    if (propertyInformation.Name != "Instance")
                    {
                        //------------------------------------------------------------
                        //	Extract property value and its string representation
                        //------------------------------------------------------------
                        object propertyValue = propertyInformation.GetValue(this, null);
                        string valueAsString = propertyValue.ToString();

                        //------------------------------------------------------------
                        //	Format null/default property values as empty strings
                        //------------------------------------------------------------
                        if (propertyValue.Equals(null))
                        {
                            valueAsString = String.Empty;
                        }
                        if (propertyValue.Equals(Int32.MinValue))
                        {
                            valueAsString = String.Empty;
                        }
                        if (propertyValue.Equals(Single.MinValue))
                        {
                            valueAsString = String.Empty;
                        }

                        //------------------------------------------------------------
                        //	Write property name/value pair
                        //------------------------------------------------------------
                        writer.WriteElementString(propertyInformation.Name, valueAsString);
                    }
                }
                catch
                { }
            }

            writer.WriteEndElement();
        }

        
    }
    #endregion
}