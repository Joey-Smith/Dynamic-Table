<%@ Page Title="SSAMS&#8482; Application Access" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="application-administration.aspx.vb" Inherits="administration_application_administration_application_administration" %>
<%@ MasterType VirtualPath="~/Site.master" %>


<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
	<style type="text/css">
		#tblStaffDevelopmentAdministration td{border:0px solid #000000; vertical-align:top; height:20px; overflow:visible;}
		#tblStaffDevelopmentAdministration table td{border:1px; vertical-align:top; height:20px; overflow:visible;}
	</style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="PageHeadingContent" Runat="Server">
    Application Permissions
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" Runat="Server">
	<div style="text-align:left;">

		<table border="1" class="DataAL" id="tblStaffDevelopmentAdministration" style="table-layout:fixed; width:1350px; background:#FFFFFF; margin-top:5px;" cellspacing="0">
			<tr>
                <td style="width:80px;">
                    <!--<div style="text-align:center;">-->
                        <table style="height:83px;width:100%;table-layout:fixed;">
                            <asp:Literal runat="server" ID="litStaffHead" />
                        </table>
                    <!--</div>-->
                    <div style="overflow-y:hidden;">
                    <div id="divStaff" style="overflow-y:scroll;overflow:hidden;">
                        <table id="tableStaff" style="table-layout:fixed;border-collapse:collapse;">
                            <asp:Literal runat="server" ID="litStaffContent" />
                        </table>
                    </div>
                    </div>
                </td>
                <td>
                    <div style="overflow-x:scroll;overflow-y:hidden;width:100%;">
                        <table id ="headTable" style="width:1220px;height:80px;table-layout:fixed;">
                            <asp:Literal runat="server" ID="litHead" />
                        </table>
                        <div id="thisdiv" style="overflow-y:scroll;overflow:hidden;width:1240px;">
                            <table id="contentTable" style="width:1220px;table-layout:fixed;border-collapse:collapse;">
                                <asp:Literal runat="server" ID="litContent" />
                            </table>
                        </div>
                    </div>
                </td>
                <td style="width:23px;">
                    <div id="scrollBar" style="height:100%;width: 22px;overflow: hidden;overflow-y: scroll;margin-top:80px;" onscroll="reposVertical(this);">
                        <div id="divScroll" style="width: 0.1px;"></div>
                    </div>
                </td>
            </tr>
		</table>
	</div>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ReportContent" Runat="Server">
	<script type="text/javascript" src="/includes/application-administration.js"></script>
	<script type="text/javascript">
		//WINDOW HEIGHT AND WIDTH
		//USING THE HEIGHT TO RESIZE TABED DOCUMENT TO FIT THE USERS WINDOW
		var winW = 660, winH = 460;
		function getHW() {
			if (document.body && document.body.offsetWidth) {
				winW = document.body.offsetWidth;
				winH = document.body.offsetHeight;
			} if (document.compatMode == 'CSS1Compat' && document.documentElement && document.documentElement.offsetWidth) {
				winW = document.documentElement.offsetWidth;
				winH = document.documentElement.offsetHeight;
			} if (window.innerWidth && window.innerHeight) {
				winW = window.innerWidth;
				winH = window.innerHeight;
			}
		}

		//SET THE HEIGHT ON THE SCROLLING TABLE SECTION
		function setHT() {
			var tabH = (winH - 285) + 'px';
			document.getElementById('tblStaffDevelopmentAdministration').style.height = tabH;
			document.getElementById('thisdiv').style.height = tabH;
			document.getElementById('divStaff').style.height = tabH;
			document.getElementById('scrollBar').style.height = tabH;

			document.getElementById('divScroll').style.height = (document.getElementById('tableStaff').offsetHeight) + 'px';
		}

		function setWD() {
			var newWidth = (window.innerWidth - document.getElementById("adminNavHeader").offsetWidth);
			if (newWidth < 1350) {
				document.getElementById('tblStaffDevelopmentAdministration').style.width = (newWidth - 12) + 'px';
			}
			else {
				document.getElementById('tblStaffDevelopmentAdministration').style.width = 1350 + 'px';
			}
		}

		getHW();
		setHT();

		window.onload = function () {
			setWD();
		}

		window.onresize = function () {
			getHW();
			setHT();
			setWD();
		}
	</script>
</asp:Content>