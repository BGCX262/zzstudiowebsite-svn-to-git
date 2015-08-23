<%@ Page Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Movie.aspx.cs" Inherits="Movie" Title="Untitled Page" ValidateRequest="false" %>
<%@ Register src="Controls/SidebarRight.ascx" tagname="SidebarRight" tagprefix="uc1" %>
<%@ Register src="Controls/FilesView.ascx" tagname="FilesView" tagprefix="uc2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<!-- TinyMCE -->
<script type="text/javascript" src="/js/tiny_mce/tiny_mce.js"></script>
<script type="text/javascript">
// O2k7 skin (silver)
tinyMCE.init({
	// General options
	mode : "exact",
	elements : '<%= articleContent.ClientID %>, <%= articleDescription.ClientID %>',
	theme : "advanced",
	skin : "o2k7",
	skin_variant : "silver",
	plugins : "safari,pagebreak,style,layer,table,save,advhr,advimage,advlink,emotions,iespell,inlinepopups,insertdatetime,preview,media,searchreplace,print,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template",

	// Theme options
	theme_advanced_buttons1 : "bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,styleselect,formatselect,fontselect,fontsizeselect",
	theme_advanced_buttons2 : "cut,copy,paste,pastetext,pasteword,|,search,replace,|,bullist,numlist,|,outdent,indent,blockquote,|,undo,redo,|,link,unlink,anchor,image,cleanup,help,code,|,insertdate,inserttime,preview,|,forecolor,backcolor",
	theme_advanced_buttons3 : "tablecontrols,|,hr,removeformat,visualaid,|,sub,sup,|,charmap,emotions,iespell,media,advhr,|,print,|,ltr,rtl",
	theme_advanced_buttons4 : "insertlayer,moveforward,movebackward,absolute,|,styleprops,|,cite,abbr,acronym,del,ins,attribs,|,visualchars,nonbreaking,template,pagebreak",
	theme_advanced_toolbar_location : "top",
	theme_advanced_toolbar_align : "left",
	theme_advanced_statusbar_location : "bottom",
	theme_advanced_resizing : true,
	
	// Example content CSS (should be your site CSS)
	content_css : "css/tinyMCE.css"
});

$(document).ready(function($) {
    $.formValidator.initConfig({alertMessage: false});
	$("#<%=articleTitle.ClientID %>").formValidator({empty:false, onshow:"请输入标题", onfocus:"姓名至少1个字符,最多50个字符", oncorrect:"输入正确"}).InputValidator({min:1, max:50, onerror:"请输入正确的标题"});
	$("#<%=fuAttachment.ClientID %>").formValidator({empty:false, onshow:"请选择文件", onfocus:"请选择文件", oncorrect:"已选择"}).InputValidator({min:3, onerror:"请选择文件"});
});
</script>
<!-- /TinyMCE -->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<!-- start page -->
<div id="page">
	<!-- start contentTwo -->
	<div id="contentTwo">
	    <div id="articleForm" class="form" runat="server" visible="false">
            <label>电影名</label> 
            <input class="text" type="text" size="100" id="articleTitle" value="" runat="server" />
            <label id='<%= articleTitle.ClientID %>Tip'></label>
            <label>摘要介绍</label> 
            <textarea id="articleDescription" rows="3" cols="5" runat="server"></textarea> 
           <%-- <label id="emailTip"></label>--%>
            <label>图片或附件</label>
            <uc2:FilesView ID="FilesView1" ShowSnapShot="true" Editable="true" runat="server" />
            <asp:FileUpload ContentEditable="false" ID="fuAttachment" CssClass="file" runat="server" />
            <asp:Button ID="btnUploadAttachment" OnClientClick="return $.formValidator.PageIsValid();" CssClass="button" runat="server" Text="上传" 
                onclick="btnUploadAttachment_Click" />
            <label id='<%= fuAttachment.ClientID %>Tip'></label>
            <label>详细介绍</label> 
            <textarea id="articleContent" rows="5" cols="5" style="height: 500px" runat="server"></textarea> 
            <br />
            <asp:Button ID="btnSaveArticle" CssClass="button" runat="server" Text="发布" 
                onclick="btnSaveArticle_Click" />
        </div>
	    <div id="articleContainer" class="post" runat="server">
			<h1 class="title">
                <a title='<%= CurrentArticle.Title %>' href='<%= Page.ResolveUrl(string.Format("~/News.aspx?id={0}", CurrentArticle.Id)) %>'><%= CurrentArticle.Title %></a></h1>
			<p class="meta"><a href="#" class="author"><%= CurrentArticle.Author %></a> 发布于 <%= CurrentArticle.CreateDate.ToString() %></p>
			<div class="entry">
				<%= CurrentArticle.Content %>
			</div>
			<p class="links"><a href='<%= Page.ResolveUrl(string.Format("~/News.aspx?id={0}", CurrentArticle.Id)) %>' class="permalink">永久链接</a>
			<% if (User.Identity.IsAuthenticated) { %>
			| <a href='<%= Page.ResolveUrl(string.Format("~/News.aspx?id={0}&action=edit", CurrentArticle.Id)) %>'>编辑</a>
			| <a href='<%= Page.ResolveUrl(string.Format("~/News.aspx?id={0}&action=delete", CurrentArticle.Id)) %>' onclick="return window.confirm('确定要删除吗?');">删除</a>
			<%} %>
			</p>
            <p class="tags"><strong>Tags:</strong></p>
            </div>
    </div>
    <!-- end contentTwo -->
    <uc1:SidebarRight ID="SidebarRight2" runat="server" />
	<div style="clear: both;">&nbsp;</div>
</div>
<!-- end page -->
</asp:Content>

