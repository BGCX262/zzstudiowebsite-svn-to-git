<%@ Page Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Messages.aspx.cs" Inherits="Comment" %>

<%@ Register Assembly="AspNetPager" Namespace="Wuqi.Webdiyer" TagPrefix="webdiyer" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<!-- TinyMCE -->
<script type="text/javascript" src="/js/tiny_mce/tiny_mce.js"></script>
<script type="text/javascript">
	// O2k7 skin (silver)
	tinyMCE.init({
		// General options
//		mode : "exact",
//		elements : "message",
        mode : "textareas",
		theme : "advanced",
		skin : "o2k7",
		skin_variant : "silver",
		plugins : "safari,pagebreak,style,layer,table,save,advhr,advimage,advlink,emotions,iespell,inlinepopups,insertdatetime,preview,media,searchreplace,print,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template",

		// Theme options
		theme_advanced_buttons1 : "bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,styleselect,formatselect,fontselect,fontsizeselect",
		theme_advanced_buttons2 : "bullist,numlist,|,outdent,indent,blockquote,|,undo,redo,|,link,unlink,anchor,image,cleanup,help,|,insertdate,inserttime,preview,|,forecolor,backcolor,|,sub,sup,|,charmap,emotions,iespell,media,advhr",
		theme_advanced_buttons3 : "",
		theme_advanced_toolbar_location : "top",
		theme_advanced_toolbar_align : "left",
		theme_advanced_statusbar_location : "bottom",
		theme_advanced_resizing : true,
		
		// Example content CSS (should be your site CSS)
		content_css : "css/tinyMCE.css", 
		
		// Replace values for the template plugin
		template_replace_values : {
			XSS :  "",
			staffid : "991234"
		}
	});

</script>
<!-- /TinyMCE -->

<script type="text/javascript">
$(document).ready(function($) {
    //提交留言
    $("#submitMessage").click(function() {
        if(!$.formValidator.PageIsValid()) return false;
        if(tinyMCE.get('message').getContent() == "") {
            alert("内容不能为空！");
            return false;
        }
        var name = htmlEncode($("#username").val());
        var email = htmlEncode($("#email").val());
        var subjest = htmlEncode($("#subject").val());
        var message = tinyMCE.get('message').getContent();
        $("#aspnetForm :text").attr("disable", "disable");
        PageMethods.AddMessage(name, email, subjest, message, function(result) {
            refreshMessagesList();
            $("#aspnetForm :text").attr("disable", "disable").val("");
            tinyMCE.get('message').setContent("");
        });
    });
    
    $.formValidator.initConfig({alertMessage: false});
	$("#username").formValidator({empty:false,onshow:"请输入姓名",onfocus:"姓名至少3个字符,最多30个字符",oncorrect:"你输对了"}).InputValidator({min:3,max:30,onerror:"你输入的姓名非法,请确认"});
    $("#email").formValidator({onshow:"请输入邮箱",onfocus:"邮箱至少6个字符,最多50个字符",oncorrect:"你输对了"}).InputValidator({min:6,max:50,onerror:"你输入的邮箱长度非法,请确认"}).RegexValidator({regexp:"^([\\w-.]+)@(([[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.)|(([\\w-]+.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(]?)$",onerror:"你输入的邮箱格式不正确"});
    $("#subject").formValidator({empty:false,onshow:"请输入主题",onfocus:"主题至少2个字符, 最多100个字符",oncorrect:"你输对了"}).InputValidator({min:2, max:100,onerror:"你输入的主题非法,请确认"});
});

Sys.Application.add_load(function() {
    bindButtonEvent();
});

var replyMsgId;
function bindButtonEvent() {
    //回复
    $("a.replyMessageButton").click(function(event) {
        event.preventDefault();
        tinyMCE.get('replyBody').setContent("");
        $(this).parent().before($("#replyForm").show());
        replyMsgId = $(this).attr("msgId");
        
        if($("#reply"+replyMsgId).length == 1) {
            var oldMsg = $("#reply"+replyMsgId).html();
            tinyMCE.get('replyBody').setContent(oldMsg);
        }
    });
    
    //提交回复
    $("#submitReply").click(function() {
        var replyBody = tinyMCE.get('replyBody').getContent();
        PageMethods.ReplyMessage(replyMsgId, replyBody, function(result) {
            $("#aspnetForm").append($("#replyForm").hide()); //将replyForm移出List
            
            refreshMessagesList();
        });
    });
    
    //删除
    $("a.deleteMessageButton").click(function(event) {
        event.preventDefault();
        replyMsgId = $(this).attr("msgId");
        if(window.confirm("确定删除此留言吗？")) {
            PageMethods.DeleteMessage(replyMsgId, function(result) {
                if(result) {
                    refreshMessagesList();
                }
            });
        }
    });
}

function refreshMessagesList() {
    __doPostBack('<%=lbtnRefreshMessagesBottom.UniqueID %>','');
}
</script>

<div id="page">
<h1 class="name">我要留言</h1>
<div class="form">
    <p>
        <label>姓名</label> 
        <input class="text" type="text" size="30" id="username" value="" />
        <span id="usernameTip"></span>
        <label>邮箱</label> 
        <input class="text" type="text" size="30" id="email" value="" /> 
        <span id="emailTip"></span>
        <label>主题</label> 
        <input class="text" type="text" size="100" id="subject" value="" /> 
        <span id="subjectTip"></span>
        <label>内容</label> 
        <textarea id="message" rows="5" cols="5"></textarea> 
        <br />
        <input id="submitMessage" class="button" type="button" value="发送留言" /> 
    </p>
</div>
<div class="form" id="replyForm" style="display: none;">
    <p>
        <label>回复内容</label> 
        <textarea id="replyBody" rows="5" cols="5"></textarea> 
        <br />
        <input id="submitReply" class="button" type="button" value="发送回复" /> 
    </p>
</div>
<h1 class="name">留言列表</h1>  
<div id="messageList">
<%--<asp:LinkButton ID="lbtnRefreshMessagesTop" runat="server" 
        onclick="lbtnRefreshMessages_Click">刷新留言列表</asp:LinkButton>--%>
<asp:UpdatePanel ID="UpdatePanel1" runat="server">
<ContentTemplate>
<asp:Repeater ID="rptMessageList" runat="server">
    <ItemTemplate>
        <div class="message">
            <h1>
                <a href='mailto:<%# Eval("Email") %>' title='mailto:<%# Eval("Email") %>'><%# Eval("UserName") %>(<%# Eval("Email") %>)</a> |  
                <strong><%# Eval("Subject") %></strong> | <%# Eval("CreateDate", "发表于 {0}") %></h1>
            <%# Eval("Body") %>
            <%# Eval("Reply").ToString() != string.Empty ? 
                string.Format("<div class='messageReply'><p class='replyDate'>回复于 {0}：</p><div class='replyBody' id='reply{1}'>{2}</div></div>",
                    Eval("ReplyDate"), Eval("Id"), Eval("Reply")) : string.Empty%>
            <% if (User.Identity.IsAuthenticated)
               { %>
            <p><a class="replyMessageButton" href='#' msgId='<%# Eval("Id") %>'> 回复 </a> | 
            <%--<a class="editMessageButton" href='#' msgId='<%# Eval("Id") %>'> 修改 </a> | --%>
            <a class="deleteMessageButton" href='#' msgId='<%# Eval("Id") %>'> 删除 </a></p>
            <%} %>
        </div>
    </ItemTemplate>
</asp:Repeater>
<webdiyer:AspNetPager ID="anpMessagesList"  runat="server" PageSize="15" 
        UrlPaging="True"></webdiyer:AspNetPager>
</ContentTemplate>
    
<Triggers>
    <asp:AsyncPostBackTrigger ControlID="lbtnRefreshMessagesBottom" />
</Triggers>
</asp:UpdatePanel>
    <asp:LinkButton ID="lbtnRefreshMessagesBottom" runat="server" 
        onclick="lbtnRefreshMessages_Click">刷新留言列表</asp:LinkButton>
</div>
</div>
</asp:Content>

