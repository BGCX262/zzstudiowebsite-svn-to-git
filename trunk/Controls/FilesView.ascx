<%@ Control Language="C#" AutoEventWireup="true" CodeFile="FilesView.ascx.cs" Inherits="Controls_FilesView" %>
<%@ Import namespace="System.Data" %>
<%@ Import namespace="Net4.Common.Entities" %>

<ul class="filesView">
<asp:Repeater ID="rptFiles" runat="server">
<ItemTemplate>
<li>
<label><a href='<%# Eval("VirtualPath") %>' 
    title='<%# Eval("FileName") %>'><%# Eval("FileName") %> <%# Eval("DisplaySize", "({0})")%></a></label>
<p>
    <%# Container.DataItem is ImageInfo && this.ShowSnapShot ?
                string.Format("<img src='{0}' alt='{1}' />", Eval("Snapshot"), Eval("FileName"))
                        : string.Format("<img src='/images/icons/32/{1}.gif' alt='{0}' />", Eval("FileName"), Eval("Extension").ToString().Substring(1))%>
</p>
</li>
</ItemTemplate>
</asp:Repeater>
</ul>

