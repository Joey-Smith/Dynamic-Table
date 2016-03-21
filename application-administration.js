/********************************* TOGGLECHECKBOX *********************************
DESCRIPTION: ONCLICK EVENT FOR CHECK BOXES IN IMPORT STAFF PAGE
FUNCTIONALITY: DETERMINES WHETHER CHECKBOX WAS CHECKED OR UNCHECKED AND MAKES
		THE CALL TO THE AJAX PAGE ACCORDINGLY.
PARAMETERS:
	STAFFID - RECORD ID IN _SSAMS_STAFF TABLE
	CLASSID - RECORD ID IN _SSAMS_CASETYPE_TO_CLASS TABLE
*/
function toggleCheckbox(StaffID, ClassID) {
	var elementID = StaffID + "_" + ClassID;
	var objCheckbox = document.getElementById(elementID);
	var ajaxResponse;

	if (objCheckbox.checked) {
		//	USER CHECKED CHECKBOX
		ajaxResponse = PostAjax("what=check&StaffID=" + StaffID + "&AppID=" + ClassID);
	} else {
		// OTHERWISE IT WAS UNCHECKED
		ajaxResponse = PostAjax("what=uncheck&StaffID=" + StaffID + "&AppID=" + ClassID);
	}
	// TRUE - UPDATE WORKED PROPERLY
	// FALSE - UPDATE DID NOT WORK
	if (ajaxResponse != "True") {
		alert(ajaxResponse);
		objCheckbox.checked = false;
	}
}

/********************************* ADMINPOSTAJAX *********************************
DESCRIPTION: POSTS PARAMS FROM TOGGLECHECKBOX 
FUNCTIONALITY: POSTS PARAMS FROM TOGGLECHECKBOX WITH A RANDOMIZED URL TO PREVENT
        CACHING IN IE.
PARAMETERS: 
        PARAMS - CONCAT'D VARIABLES POSTED TO AJAX PAGE
*/
function PostAjax(params) {
	var AjaxRequest = new XMLHttpRequest();

	// OPEN ADDRESS TO BE POSTED TO, MATH.RANDOM PREVENTS CACHING IN IE
	AjaxRequest.open("POST", '/AJAX/ajx-application-administration.aspx?t=' + Math.random(), false);
	AjaxRequest.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	// SEND PARAMETER STRING
	AjaxRequest.send(params);
	// RETURN POTENTIAL ERROR MESSAGE
	return AjaxRequest.responseText;
}

/********************************* REPOSVERTICAL *********************************
DESCRIPTION: SCROLLS STAFF AND PERMISSIONS DIV'S CONTAINING THEIR RESPECTIVE TABLES
FUNCTIONALITY: AS THE THIRD DIV IN THE RECORD IS SCROLLED, SO ARE THE FIRST TWO.
PARAMETERS: 
	E - THE DIV BEING SCROLLED BY THE USER.
*/
function reposVertical(e) {
    var h = document.getElementById('thisdiv');
    var c = document.getElementById('divStaff');
    h.scrollTop = e.scrollTop;
    c.scrollTop = e.scrollTop;
}

/********************************* MOUSEOVERTD *********************************
DESCRIPTION: HIGHLIGHTS ROW AND COLUMN OF THE CELL UNDER MOUSE CURSOR
FUNCTIONALITY: SETS BACKGROUND OF CELLS AS IT ITERATES ACROSS ROWS AND COLUMNS.
PARAMETERS: 
	ROW - THE INDEX OF THE ROW TO BE HIGHLIGHTED
	COL - THE INDEX OF THE COLUMN TO BE HIGHLIGHTED
*/
function mouseOverTd(Row, Col) {
	var indexRow, indexCol;
	var tdHeader = document.getElementById("headTable").rows[0].cells[Col];
	var tableContent = document.getElementById("contentTable");
	var tableStaffContent = document.getElementById("tableStaff");

	// SET BACKGROUND OF CELL IN HEADER TABLE
	tdHeader.style.backgroundColor = "#CCCCCC";

	// SET BACKGROUND OF CELL IN STAFF TABLE
	tableStaffContent.rows[Row].style.backgroundColor = "#CCCCCC";

	// ITERATE ACROSS PERMISSIONS TABLE
	for (indexRow = 0; indexRow < tableContent.rows.length; indexRow++) {
		// FOR EVERY ROW, SET BACKGROUND OF CELL IN SPECIFIED COLUMN
		tableContent.rows[indexRow].cells[Col].style.backgroundColor = "#CCCCCC";

		// IF THE CURRENT ROW IS THE SPECIFIED ROW TO BE HIGHLIGHTED
		if (indexRow == Row) {
			// ITERATE ACROSS CELLS IN THE ROW
			for (indexCol = 0; indexCol < tableContent.rows[0].cells.length; indexCol++) {
				// HIGHLIGHT ALL CELLS IN THE ROW
				tableContent.rows[indexRow].cells[indexCol].style.backgroundColor = "#CCCCCC";
			}
		}
	}
}

/********************************* MOUSEOUTTD *********************************
DESCRIPTION: REMOVES HIGHLIGHT OF ROW AND COLUMN OF CELL AS MOUSE LEAVES
FUNCTIONALITY: SETS BACKGROUND OF CELLS BACK TO WHITE AS IT ITERATES ACROSS
		ROWS AND COLUMNS.
PARAMETERS: 
	ROW - THE INDEX OF THE ROW TO BE UNHIGHLIGHTED
	COL - THE INDEX OF THE COLUMN TO BE UNHIGHLIGHTED
*/
function mouseOutTd(Row, Col) {
	var indexRow, indexCol;
	var tdHeader = document.getElementById("headTable").rows[0].cells[Col];
	var tableContent = document.getElementById("contentTable");
	var tableStaffContent = document.getElementById("tableStaff");

	// SET BACKGROUND OF CELL IN HEADER TABLE
	tdHeader.style.backgroundColor = "#FFFFFF";

	// SET BACKGROUND OF CELL IN STAFF TABLE
	tableStaffContent.rows[Row].style.backgroundColor = "#FFFFFF";

	// ITERATE ACROSS PERMISSIONS TABLE
	for (indexRow = 0; indexRow < tableContent.rows.length; indexRow++) {
		// FOR EVERY ROW, SET BACKGROUND OF CELL IN SPECIFIED COLUMN
		tableContent.rows[indexRow].cells[Col].style.backgroundColor = "#FFFFFF";

		// IF THE CURRENT ROW IS THE SPECIFIED ROW TO BE UNHIGHLIGHTED
		if (indexRow == Row) {
			// ITERATE ACROSS CELLS IN THE ROW
			for (indexCol = 0; indexCol < tableContent.rows[0].cells.length; indexCol++) {
				// UNHIGHLIGHT ALL CELLS IN THE ROW
				tableContent.rows[indexRow].cells[indexCol].style.backgroundColor = "#FFFFFF";
			}
		}
	}
}