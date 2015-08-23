<%@ Page Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="MovieList.aspx.cs" Inherits="MovieList" Title="Untitled Page" %>
<%@ Register src="Controls/SidebarRight.ascx" tagname="SidebarRight" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<!-- start page -->
<div id="page">
	<!-- start contentTwo -->
	<div id="contentTwo">
	<% if (User.Identity.IsAuthenticated) { %>
	<p><asp:HyperLink ID="hlAddMovie" NavigateUrl="~/Movie.aspx" runat="server">添加放映信息</asp:HyperLink></p>
	<%} %>
    <asp:Repeater ID="rptMovies" runat="server">
    <ItemTemplate>
        <div class="post">
			<h1 class="title">
                <asp:HyperLink ID="HyperLink1" ToolTip='<%# Eval("Title") %>' NavigateUrl='<%# Eval("Id", "~/Movie.aspx?id={0}") %>' runat="server"><%# Eval("Title") %></asp:HyperLink></h1>
			<p class="meta"><a href="#" class="author"><%# Eval("Author") %></a> 发布于 <%# Eval("CreateDate") %></p>
			<div class="entry">
				<p><%# Eval("Description") %></p>
			</div>
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

