<%@ Page Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default"  %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>

<%@ Register src="Controls/SidebarRight.ascx" tagname="SidebarRight" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

    <script type="text/javascript">
    jQuery(document).ready(function($) {
      $('a[rel*=facebox]').facebox();
      
      $('*[rel*=editable_not]').click(function(event) {
        event.preventDefault();
        var context = $(this);
        var id = context.attr("id") || "editableObject";
        var container = $("#"+ id +"Container");
        if(container.size() == 0) {
            var editor = context.attr("editor") || "text";
            switch(editor) {
                case "text" : editor = "<input id='" + id 
                    + "Text' type='text' class='text' editElementId='"
                    + context.attr("id") +"' />";break;
                case "textarea" : editor = "<textarea id='" + id 
                    + "Text' class='text' editElementId='"
                    + context.attr("id") +"' />";break;
            }
            
            container = $("<div id='" + id
            + "Container'>" + editor + " <input id='" + id
            + "Submit' type='button' class='button' value='保存' /> <input id='" + id
            + "Cancel' type='button' class='button' value='取消' /> </div>");
            
            context.before(container);
            
            $("#"+id+"Submit").click(function() {
                saveData($("#"+id+"Text"));
                container.hide();
                context.show();
            });
            $("#"+id+"Cancel").click(function() {
                container.hide();
                context.show();
            });
         }
         context.hide();
         container.show();
         //设置文本框的值，并设置直接在文本框上回车就可以保存.
         $("#"+id+"Text").val(context.html()).keypress(function(event) {
            if(event.which == 13) {
                event.preventDefault(); //禁止默认的事件发生
                saveData($(this));
                container.hide();
                context.show();
                //event.stopPropagation();
            }
         });
      });
    });
    
    //保存数据到服务器端
    function saveData(jqText) {
        var value = jqText.val();
        var editElement = $("#"+jqText.attr("editElementId"));
        var key = editElement.attr("field");
        editElement.html(value);
        
        PageMethods.SaveData(key, value);
    }
  </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<!-- start page -->
<div id="page">
	<!-- start content -->
	<div id="content">
		<div class="post">
			<h1 class="title"><a href="#whoiszz" id="authorIntroTitle" rel="editable" field="AuthorIntroTitle"><%= webpage.AuthorIntroTitle %></a></h1>
			<div id="authorIntro" class="entry" editor="textarea" rel="editable" field="AuthorIntro"><%= webpage.AuthorIntro %>
				<br /><a href="#zhangzhiInfo" rel="facebox">点击查看更多关于张志的信息</a>
			</div>
			<div id="zhangzhiInfo" style="display:none;">
			    <p><strong>张志</strong>的个人资料：<br />
1995年毕业于北京解放军艺术学院舞蹈系。<br />
1995年开始参加工作。<br />
1998年-2000年再次考入北京解放军艺术学院舞蹈系“表演导演”大专毕业。<br />
表演主要获奖情况：<br />
2005年第二届韩国首尔国际芭蕾舞及现代舞大赛，现代舞组唯一金奖。<br />
2004年第八届全军文艺汇演，获表演一等奖。<br />
2003年主演的舞剧《菊夫人》获浙江省第九届戏剧节新剧目大奖<br />
2002年第二届CCTV电视舞蹈作品评选中获唯一的男演员最佳表演奖；<br />
2002年第二届CCTV电视舞蹈大赛当代舞组银奖。<br />
2001年第五届全国舞蹈比赛表演一等奖；<br />
2001年第六届日本国际“洋舞”大赛，现代舞组第二名，并获国际交流奖；<br />
2001年第六届全军文艺新作品奖表演一等奖；<br />
2000年全国桃李杯舞蹈比赛，古典舞青年组银奖；<br />
1999年第七届全军文艺汇演表演一等奖；<br />
<br />
编创获奖情况：<br />
2006年作为特邀编导，副总导演为辽宁芭蕾舞团创作的芭蕾舞剧《二泉映月》获（2005-2006）国家十佳舞台艺术精品工程奖。<br />
参加创作的舞剧《妈勒访天边》获“荷花杯”舞剧金奖，2002年文华大奖；文华大奖单项奖“编导奖”；第七届中国戏剧节优秀导演奖。<br />
第八届全军文艺会演编导一等奖。 <br />
第五届中国舞蹈荷花奖获现代舞编导铜奖，作品铜奖。<br />
主要重大演出或晚会情况：<br />
2003年曾应中国爱乐乐团邀请，与乐团七位首席演员还有姜昆、娄乃敏等人一起，自编自演了乐、舞、诗合作的斯特拉文斯基舞剧作品《一个士兵的故事》在中国的首演。<br />
2006年多哈亚运会闭幕式广州十分钟表演的舞蹈设计。<br />
1997年被评为广东跨世纪之星。<br />
2006年被评为广东新世纪之星。<br />
多次作为编导，演员参加2001、2003、2007中央电视台春节联欢晚会。2001年在中央电视台春节联欢晚会上编排的歌舞《越来越好》还获得了当年观众投票选出的歌舞类节目的一等奖；<br />
2003底至04年初期间，应邀作为中国红星舞蹈团特邀演员参加了“中法文化年”的活动。在法国巡回表演舞蹈专场。历时90天，演出多达60场。还曾赴、瑞士、西班牙、罗马尼亚、希腊、马耳他、安道尔、蒙古等国家进行过交流访问演出。<br />
2005年曾举办过名为“又是一年”的现代舞专场演出。<br />
中宣部、文化部、总政治部等单位联合主办的建国五十周年大型歌舞晚会<br />
首届中国舞蹈节精品展演晚会<br />
南宁民歌艺术节<br />
中央电视台同一首歌<br />
宁波国际服装节文艺晚会<br />
首届佛经论坛协会文艺晚会<br />
首届北京国际美术双年展文艺晚会。<br />
庆祝香港回归十周年文艺晚会等等一系列各种重大活动的演出与编排<br />
				</p>
				</div>
		</div>
		<div class="post">
			<h1 class="title"><a href="#">张志工作室的目的性和功能</a></h1>
			<div class="entry">
				<p><strong>工作室</strong>是希望能够更长的延续自己的艺术生命和试图打破现有的一些局限，在舞蹈与其他类艺术结合方面做更多的尝试，以丰富舞蹈的表现力。所以我希望更多的人关注这个平台，并积极参与进来，让艺术丰富生活，让生活充满艺术。
				</p>
				<p>
				<strong>工作室的主要功能：</strong><br />
<strong>舞蹈类：</strong>舞蹈编排，晚会策划，形体培训，私人指导，专业院校考学前辅导。<br />
<strong>其他类：</strong>音乐剪辑，视频编辑，录音，代为联系各艺术类专业权威的指导老师进行学习指导。
<br /><a href="#zzStudioInfo" rel="facebox">查看更多关于张志工作室的信息</a>。
				</p>
			</div>
		</div>
		<div id="zzStudioInfo" style="display:none;">
		    <p>
		        <strong>张志工作室</strong>位于广州海珠区昌岗中路110号11号楼，在远洋宿舍小区里一个独立的三层小楼。三楼是一个大约近百平方的练功房，可以用于练功，排舞，形体训练，摄影等。我会在此做一些实验性的创作，并定期邀请相关的专业人士在此做一些交流表演。
            </p>
            <p>
                二楼与三楼的面积相近，设置为一个小型会所。在这里准备了许多与艺术还有时尚相关的资料，（如舞蹈，话剧，音乐，杂技，时装，美术，人文地理等等影视资料）定期进行播放。以提供一个机会给专业人士和艺术爱好者欣赏各类作品和了解最新的艺术信息。同时还会不定期举办酒会，邀请各类的艺术专业人士，如：演员、画家、音乐人等，建立一个简易的平台，让更多人近距离接触艺术。还有，由于楼层的特殊结构，十分适合举办小型的美术作品和摄影图片的展览，如果有需要工作室将无偿提供给学生或者美术摄影爱好者展示作品。
            </p>
            <p>
                做这个工作室是希望能够更长的延续自己的艺术生命和试图打破现有的一些局限，在舞蹈与其他类艺术结合方面做更多的尝试，以丰富舞蹈的表现力。所以我希望更多的人关注这个平台，并积极参与进来，让艺术丰富生活，让生活充满艺术。
            </p>
            <p>
                <strong>张志工作室</strong>线路指引：因门口地铁正在施工当中。所以地铁只能乘坐至晓港站，A出口上来乘坐（69，70，206，565，812，）等公车2站地至橡胶新村下，行至马路对面昌岗综合市场进入20米左边就为远洋宿舍小区。
                进入小区直行60米转右直行100米转右看见独立的三层小楼就为张志工作室。
            </p>
            <p>
                <strong>张志工作室</strong>的主要功能：
                舞蹈类：舞蹈编排，晚会策划，形体培训，私人指导，专业院校考学前辅导。
                其他类：音乐剪辑，视频编辑，录音，代为联系各艺术类专业权威的指导老师进行学习指导。
		    </p>
		</div>
	</div>
	<!-- end content -->
	<!-- start sidebar one -->
	<div id="sidebar1" class="sidebar">
		<ul>
			<li id="recent-posts">
				<h2><a href="/newslist.aspx">最新资讯</a></h2>
				<ul>
				    <asp:Repeater ID="rptNews" runat="server">
				    <ItemTemplate>
				    <li>
						<h3><a href="<%# Eval("Id", "/News.aspx?id={0}") %>"><%# Eval("Title") %></a></h3>
						<%# Eval("Description").ToString().Substring(0, Eval("Description").ToString().LastIndexOf("</p>")) %> 
						<a href="<%# Eval("Id", "/News.aspx?id={0}") %>">More&hellip;</a></p>
					</li>
				    </ItemTemplate>
                    </asp:Repeater>
				</ul>
			</li>
		</ul>
	</div>
	<!-- end sidebar one -->
    <div id="sidebar2" class="sidebar">
	<ul>
		<li>
			<h2><a href="/movielist.aspx">放映厅</a></h2>
			<ul>
			    <asp:Repeater ID="rptMovies" runat="server">
			    <ItemTemplate>
			    <li>
			    <h3><a href="<%# Eval("Id", "/Movie.aspx?id={0}") %>"><%# Eval("Title") %></a></h3>
			    <%# Eval("Description").ToString().Substring(0, Eval("Description").ToString().LastIndexOf("</p>")) %> 
				<a href="<%# Eval("Id", "/Movie.aspx?id={0}") %>">More&hellip;</a></p>
			    </li>
			    </ItemTemplate>
				</asp:Repeater>
				<%--<li><a href="#">每周六，日下午都会播放艺术资料或优秀影视作品，定期会请专家和大家一起交流讨论影视作品观赏心得。</a></li>--%>
			</ul>
		</li>
		<li>
			<h2>演出信息</h2>
			<ul>
				<li><a href="#">期待中...</a></li>
			</ul>
		</li>
		<li>
			<h2>链接</h2>
			<ul>
				<li><a href="http://blog.sina.com.cn/danceZz">张志's Blog</a></li>
			</ul>
		</li>
	</ul>
</div>
	<div style="clear: both;">&nbsp;</div>
</div>
<!-- end page -->
</asp:Content>

