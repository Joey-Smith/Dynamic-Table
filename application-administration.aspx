Imports System.Data.Odbc

Partial Class administration_application_administration_application_administration
    Inherits System.Web.UI.Page

	'USERNAME OF PAGE VIEWER
	Private username As String

	'STORES FIRST PERMISSION (USED TO IDENTIFY WHEN PERMISSIONS LOOP AND NEW RECORD BEGINS)
	Private tempClassID As String

	'X AND Y COORDINATES OF CHECKBOXES (FOR HIGHLIGHTING ROW AND COLUMN)
	Private indexCol As Integer
	Private indexRow As Integer

	'CLASS CONTAINING DATABASE CALLS TO FETCH AND STORE IMPORT PERMISSIONS
	Private dalPermissions As dalPermissions

	'CLASS CONTAINING CALL TO DATABASE TO CHECK USER'S ACCESS
	Private dalStaff As dalStaff

	'USER ACCESS CHECK
	Private access As Boolean

	Private contentBuilder As StringBuilder

	'********************************* PAGE_LOAD *********************************
	'DESCRIPTION: INTIALIZE PRIVATE VARIABLES
	'FUNCTIONALITY: 
	'PARAMETERS: 
	'
	Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
		dalPermissions = New dalPermissions
		dalStaff = New dalStaff
		contentBuilder = New StringBuilder

		indexCol = 0
		indexRow = 0

		'DETERMINE IF THE USER HAS ACCESS TO THE PAGE BY CHECKING THE IMPORTS COLUMN OF THE _SSAMS_STAFF TABLE
		username = Master.UsrName
		access = dalStaff.StaffAccess(username, "App_Administration")
	End Sub

	'********************************* PAGE_LOADCOMPLETE *********************************
	'DESCRIPTION: GENERATES THE STAFF TABLE ON THE APPLICATION ACCESS PAGE
	'FUNCTIONALITY: CALLS THE DATA ACCESS LAYER TO FETCH ALL RECORDS IN THE _SSAMS_STAFF
	'       TABLE. THEN DISPLAYS THIS INFORMATION IN TABLE FORMAT.
	'PARAMETERS: 
	'       USERNAME - STAFFCODE FOR THE USER CURRENTLY ACCESSING THE APPLICATION ACCESS
	'           PAGE. TO BE USED IN THE MODIFIED BY COLUMN (NOT YET IMPLEMENTED).
	'
	Protected Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
		'FETCH STAFF AND PERMISSIONS
		Using dr As OdbcDataReader = dalPermissions.AppAdminGetStaff()
			'CREATE STAFF HEADER TABLE
			litStaffHead.Text = "<tr style='color:#000000;'><td class='LabelAC' style='vertical-align:bottom;overflow:hidden;text-align:center;'>Staff Code</td></tr>"

			'IF ANYTHING WAS RETURNED FROM THE DATABASE I.E. THERE ARE STAFF MEMBERS
			If dr.Read Then
				'SET MARKER TO BEGINNING OF FIRST LOOP
				tempClassID = dr.Item("applicationID").ToString

				'*************************************************************************************************************
				'THIS SEGEMENT DEALS WITH ESTABLISHING THE COLUMN HEADERS DYNAMICALLY FOR THE TABLE.
				'TO FETCH ALL POSSIBLE PERMISSIONS FOR HEADERS, LOOP THROUGH ALL THE PERMISSIONS IN THE DATAREADER FOR THE
				'FIRST STAFF MEMBER.

				'BEGIN NEW STAFF/PERM RECORD
				BeginRecord(dr.Item("staffCode"))

				'CREATE CASETYPE/CLASS HEADER TABLE
				litHead.Text += "<tr style='color:#000000;'>"

				'DO WHILE A FULL LOOP HAS NOT BEEN COMPLETE. I.E. MARKER HAS NOT BEEN REACHED
				Do
					'CREATE COLUMN HEADER
					litHead.Text += "<td class='LabelAC' style='vertical-align:bottom;overflow:hidden;'>" & dr.Item("application").ToString.Replace("_", "<br />") & "</td>"

					'CREATE STAFF PERMISSION CHECKBOX
					CreateCheckCell(dr.Item("staffID"), dr.Item("applicationID"), dr.Item("permID").ToString)

					'IN THE CASE THAT THERE IS ONLY ONE STAFF MEMBER
					If Not dr.Read() Then
						'CLOSE RECORDS
						contentBuilder.Append("</tr>")
						litHead.Text += "</tr>"

						'FINISH EXECUTION
						Exit Sub
					End If
				Loop Until String.Equals(dr.Item("applicationID").ToString, tempClassID)

				'*************************************************************************************************************
				'COLUMN HEADERS HAVE BEEN ESTABLISHED.
				'CONTINUE TO CREATE RECORDS FOR EVERY STAFF MEMBER RECORD BY RECORD.

				'DO WHILE A HAS BEEN READ
				Do
					'IF A FULL LOOP HAS BEEN COMPLETED I.E. MARKER HAS BEEN REACHED
					If String.Equals(dr.Item("applicationID").ToString, tempClassID) Then
						'CLOSE RECORD
						contentBuilder.Append("</tr>")

						'BEGIN NEW STAFF RECORD
						BeginRecord(dr.Item("staffCode"))

						'INCREMENT Y COORDINATE
						indexRow += 1
					End If

					'CREATE STAFF PERMISSION CHECKBOX
					CreateCheckCell(dr.Item("staffID"), dr.Item("applicationID"), dr.Item("permID").ToString)
				Loop Until Not dr.Read()

				'CLOSE FINAL RECORD
				contentBuilder.Append("</tr>")
			End If 'dr.read()
		End Using 'dr As OdbcDataReader = dal.getStaff()
		litContent.Text = contentBuilder.ToString
	End Sub

	'********************************* BEGINRECORD *********************************
	'DESCRIPTION: BEGINS NEW RECORD BY INSERTING STAFF CODE AND BEGINNING A TABLE
	'		RECORD FOR PERMISSIONS.
	'FUNCTIONALITY: 
	'PARAMETERS: 
	'	STAFFCODE - STRING. STAFF MEMBER WHO IS REPRESENTED BY THE RECORD.
	'
	Sub BeginRecord(ByVal staffCode As String)
		'EACH NEW RECORD BEGINS AT FIRST COLUMN
		indexCol = 0

		'CREATE STAFF RECORD
		litStaffContent.Text += "<tr onmouseout='this.style.backgroundColor=" & Chr(34) & Chr(34) & "' style='height:26px;'><td> &nbsp;" & staffCode & "</td></tr>"

		'BEGIN PERMISSIONS RECORD
		contentBuilder.Append("<tr style='height:26px;'>")
	End Sub

	'********************************* CREATECHECKCELL *********************************
	'DESCRIPTION: CREATES NEW CHECKBOX
	'FUNCTIONALITY: CREATES A CHECKBOX FIELD FOR THE STAFF MEMBER AND PERMISSION COMBINATION.
	'		IF THE USER DOES NOT HAVE ACCESS TO ADMIN THIS TABLE, CHECKBOXES ARE DISABLED.
	'PARAMETERS: 
	'	STAFFID - STRING. STAFF MEMBER ID OF PERMISSION
	'	CLASSID - STRING. CASETYPE/CLASS ID OF PERMISSION
	'	PERMID - THE ID OF THE PERMISSION. WILL EQUAL CLASSID IF USER HAS PERMISSION.
	'		OTHERWISE IT IS AN EMPTY STRING.
	'
	Sub CreateCheckCell(ByVal staffID As String, ByVal classID As String, ByVal permID As String)
		'CREATE CELL WITH CHECKBOX.
		'MOUSE OVER/OUT HIGHLIGHT ROW AND COLUMN
		contentBuilder.Append( _
		 "<td style='text-align:center;'" _
		 & "onmouseover='mouseOverTd(" & indexRow & ", " & indexCol & ");'" _
		 & "onmouseout='mouseOutTd(" & indexRow & ", " & indexCol & ");'>" _
		 & "<input type='checkbox' Id='" & staffID & "_" & classID & "'" _
		 & "onclick='toggleCheckbox(" & staffID & ", " & classID & ")' ")

		'IF CLASSID AND PERMID ARE EQUAL, THE STAFFMEMBER HAS THIS PERMISSION
		If String.Equals(classID, permID) Then
			contentBuilder.Append("checked ")
		End If

		'IF ACCESS IS FALSE, THE USER DOES NOT HAVE THE ABILITY TO EDIT THIS TABLE
		If Not access Then
			contentBuilder.Append("disabled")
		End If

		'END OF CELL
		contentBuilder.Append("></td>")

		'PROCEED TO NEXT COLUMN
		indexCol += 1
	End Sub
End Class