<%@ Page Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div id="page">
    <asp:LoginView ID="LoginView1" runat="server">
    <AnonymousTemplate>
        <asp:Login ID="Login1" runat="server">
        </asp:Login>
    </AnonymousTemplate>
    <LoggedInTemplate>
        <asp:LoginStatus ID="LoginStatus1" runat="server" />
    </LoggedInTemplate>
    </asp:LoginView>
</div>
</asp:Content>

