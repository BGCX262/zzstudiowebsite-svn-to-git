<%@ Page Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="NewsList.aspx.cs" Inherits="NewsList" %>
<%@ Register src="Controls/SidebarRight.ascx" tagname="SidebarRight" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<!-- start page -->
<div id="page">
	<!-- start contentTwo -->
	<div id="contentTwo">
	<% if (User.Identity.IsAuthenticated) { %>
	<p><asp:HyperLink ID="hlAddNews" NavigateUrl="~/News.aspx" runat="server">添加资讯</asp:HyperLink></p>
	<%} %>
    <asp:Repeater ID="rptNews" runat="server">
    <ItemTemplate>
        <div class="post">
			<h1 class="title">
                <asp:HyperLink ToolTip='<%# Eval("Title") %>' NavigateUrl='<%# Eval("Id", "~/News.aspx?id={0}") %>' runat="server"><%# Eval("Title") %></asp:HyperLink></h1>
			<p class="meta"><a href="#" class="author"><%# Eval("Author") %></a> 发布于 <%# Eval("CreateDate") %></p>
			<div class="entry">
				<p><%# Eval("Description") %></p>
			</div>
<%--			<p class="links"><asp:HyperLink ID="HyperLink1" ToolTip='permalink' NavigateUrl='<%# Eval("Id", "~/News.aspx?id={0}") %>' CssClass="permalink" runat="server">Permalink</asp:HyperLink></p>
--%>			<%--<p class="tags"><strong>Tags:</strong> <%# Eval("Tags") %></p>--%>
		</div>
    </ItemTemplate>
    </asp:Repeater>
    </div>
    <!-- end contentTwo -->
    <uc1:SidebarRight ID="SidebarRight2" runat="server" />
	<div style="clear: both;">&nbsp;</div>
</div>
<!-- end page -->
</asp:Content>

