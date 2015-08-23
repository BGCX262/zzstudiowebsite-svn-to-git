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
using Net4.Common.Entities;
using Net4.Services.Access;
using Net4.Common;
using System.IO;

public partial class News : System.Web.UI.Page
{
    private Article _CurrentArticle;

    protected Article CurrentArticle
    {
        get 
        {
            if (_CurrentArticle == null && !string.IsNullOrEmpty(Request.QueryString["id"]))
            {
                int id = int.Parse(Request.QueryString["id"]);
                _CurrentArticle = AccessArticleService.Instance.Select(id);
            }
            return _CurrentArticle; 
        }
        set
        {
            _CurrentArticle = value;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (CurrentArticle == null)  //new
            {
                if (User.Identity.IsAuthenticated)
                {
                    this.articleContainer.Visible = false;
                    this.articleForm.Visible = true;
                }
                else
                {
                    Response.Redirect("~/NewsList.aspx", true);
                }
            }
            else if (User.Identity.IsAuthenticated && Request.QueryString["action"] == "edit") //edit
            {
                this.articleContainer.Visible = false;
                this.articleForm.Visible = true;

                this.articleTitle.Value = CurrentArticle.Title;
                this.articleDescription.Value = CurrentArticle.Description;
                this.articleContent.Value = CurrentArticle.Content;


            }
            else if (User.Identity.IsAuthenticated && Request.QueryString["action"] == "delete") //delete
            {
                AccessArticleService.Instance.Delete(CurrentArticle.Id);
                Response.Redirect("~/NewsList.aspx", true);
            }
            //others, view
            BindFilesView();
        }
    }

    protected void btnSaveArticle_Click(object sender, EventArgs e)
    {
        if (CurrentArticle == null)
        {
            AddArticle();
        }
        else
        {
            UpdateArticle();
        }

        Response.Redirect(string.Format("~/News.aspx?id={0}", CurrentArticle.Id), true);
    }

    private void BindFilesView()
    {
        if (CurrentArticle != null)
        {
            this.FilesView1.DataSource = CurrentArticle.Attachments;
        }
    }

    private void AddArticle()
    {
        string title = HttpUtility.HtmlEncode(articleTitle.Value);
        string description = articleDescription.Value;
        string content = articleContent.Value;

        AccessArticleService service = AccessArticleService.Instance;
        if (CurrentArticle == null)
        {
            Article art = new Article(title, HttpContext.Current.User.Identity.Name,
            string.Empty, content, description, string.Empty, Category.News);
            service.Insert(art);
            CurrentArticle = art;
        }
    }

    private void UpdateArticle()
    {
        string title = HttpUtility.HtmlEncode(articleTitle.Value);
        string description = articleDescription.Value;
        string content = articleContent.Value;

        AccessArticleService service = AccessArticleService.Instance;
        CurrentArticle.Title = title;
        CurrentArticle.Description = description;
        CurrentArticle.Content = content;
        service.Update(CurrentArticle);
    }

    private void SaveFile()
    {
        string filepath = AttachmentManager.Instance.SaveAttachment(fuAttachment.PostedFile, fuAttachment.FileName);
        Attachment attach;
        if (AttachmentManager.Instance.IsImage(fuAttachment.FileName)) // is image
        {
            attach = new ImageInfo(fuAttachment.FileName, CurrentArticle.Id);

            articleContent.Value += string.Format("<img src='{0}' alt='{1}' />", attach.VirtualPath, attach.FileName);
        }
        else //file
        {
            attach = new Attachment(fuAttachment.FileName, CurrentArticle.Id);

            articleContent.Value += string.Format("<a href='{0}' title='{1}' alt='{1}'>{1}</a> ({2})", 
                attach.VirtualPath, attach.FileName, attach.DisplaySize);
        }
        AccessFileService.Instance.Insert(attach);

        CurrentArticle.Attachments.Add(attach);
        UpdateArticle();
    }

    protected void btnUploadAttachment_Click(object sender, EventArgs e)
    {
        //1.如果是新添加文章，先添加文章
        if (CurrentArticle == null)
        {
            AddArticle();
            Response.Redirect(string.Format("~/News.aspx?id={0}&action=edit", CurrentArticle.Id), false);
        }

        //2.保存文件
        SaveFile();
        BindFilesView();
    }
}
