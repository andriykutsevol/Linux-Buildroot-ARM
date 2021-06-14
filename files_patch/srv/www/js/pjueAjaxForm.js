"use strict";

/*\
|*|
|*|  :: XMLHttpRequest.prototype.sendAsBinary() Polyfill ::
|*|
|*|  https://developer.mozilla.org/en-US/docs/DOM/XMLHttpRequest#sendAsBinary()
\*/

if (!XMLHttpRequest.prototype.sendAsBinary) {
  XMLHttpRequest.prototype.sendAsBinary = function(sData) {
    var nBytes = sData.length, ui8Data = new Uint8Array(nBytes);
    for (var nIdx = 0; nIdx < nBytes; nIdx++) {
      ui8Data[nIdx] = sData.charCodeAt(nIdx) & 0xff;
    }
    /* send as ArrayBufferView...: */
    this.send(ui8Data);
    /* ...or as ArrayBuffer (legacy)...: this.send(ui8Data.buffer); */
  };
}

/*\
|*|
|*|  :: AJAX Form Submit Framework ::
|*|
|*|  https://developer.mozilla.org/en-US/docs/DOM/XMLHttpRequest/Using_XMLHttpRequest
|*|
|*|  This framework is released under the GNU Public License, version 3 or later.
|*|  http://www.gnu.org/licenses/gpl-3.0-standalone.html
|*|
|*|  Syntax:
|*|
|*|   AJAXSubmit(HTMLFormElement);
\*/

var onloadRes_raw;
var onloadRes;
var net_vars;
var cfg_vars;
var fill = "yes";

var onload_cfg_flag;

function chomp(raw_text)
{
  return raw_text.replace(/(\n|\r)+$/, '');
}

var AJAXSubmit = (function () {
  
  function ajaxSuccess () {
    //alert(this.responseText);
    onloadRes_raw = this.responseText;
	onloadRes = chomp(onloadRes_raw);
    if (fill == "yes") {
	  if (onload_cfg_flag == "cfg"){
		fill_data_cfg();
	  }else{
		fill_data();
	  }
	  
	}else{
	  
	  if (onload_cfg_flag == "cfg"){
		//alert("Done");
		document.getElementById('conf_button').style.color = "black";
		document.getElementById('conf_button').value = "Set";
		
		
	  }else{
		//alert("Done");
		document.getElementById('eth_button').style.color = "black";
		document.getElementById('eth_button').value = "Set Ethernet Settingss";
	  
		document.getElementById('ntp_button').style.color = "black";
		document.getElementById('ntp_button').value = "Set External NTP Servers";
	  
		document.getElementById('dns_button').style.color = "black";
		document.getElementById('dns_button').value = "Set DNS server";
	  }
	  
	  
// 	  
	}
    
    /* you can get the serialized data through the "submittedData" custom property: */
    /* alert(JSON.stringify(this.submittedData)); */
  }

  function submitData (oData) {
    /* the AJAX request... */
    var oAjaxReq = new XMLHttpRequest();
    oAjaxReq.submittedData = oData;
    oAjaxReq.onload = ajaxSuccess;
    if (oData.technique === 0) {
      /* method is GET */
      oAjaxReq.open("get", oData.receiver.replace(/(?:\?.*)?$/, oData.segments.length > 0 ? "?" + oData.segments.join("&") : ""), true);
      oAjaxReq.send(null);
    } else {
      /* method is POST */
      oAjaxReq.open("post", oData.receiver, true);
      if (oData.technique === 3) {
        /* enctype is multipart/form-data */
        var sBoundary = "---------------------------" + Date.now().toString(16);
        oAjaxReq.setRequestHeader("Content-Type", "multipart\/form-data; boundary=" + sBoundary);
        oAjaxReq.sendAsBinary("--" + sBoundary + "\r\n" + oData.segments.join("--" + sBoundary + "\r\n") + "--" + sBoundary + "--\r\n");
      } else {
        /* enctype is application/x-www-form-urlencoded or text/plain */
        oAjaxReq.setRequestHeader("Content-Type", oData.contentType);
        oAjaxReq.send(oData.segments.join(oData.technique === 2 ? "\r\n" : "&"));
      }
    }
  }

  function processStatus (oData) {
    if (oData.status > 0) { return; }
    /* the form is now totally serialized! do something before sending it to the server... */
    /* doSomething(oData); */
    /* console.log("AJAXSubmit - The form is now serialized. Submitting..."); */
    submitData (oData);
  }

  function pushSegment (oFREvt) {
    this.owner.segments[this.segmentIdx] += oFREvt.target.result + "\r\n";
    this.owner.status--;
    processStatus(this.owner);
  }

  function plainEscape (sText) {
    /* how should I treat a text/plain form encoding? what characters are not allowed? this is what I suppose...: */
    /* "4\3\7 - Einstein said E=mc2" ----> "4\\3\\7\ -\ Einstein\ said\ E\=mc2" */
    return sText.replace(/[\s\=\\]/g, "\\$&");
  }

  function SubmitRequest (oTarget) {
    var nFile, sFieldType, oField, oSegmReq, oFile, bIsPost = oTarget.method.toLowerCase() === "post";
    /* console.log("AJAXSubmit - Serializing form..."); */
    this.contentType = bIsPost && oTarget.enctype ? oTarget.enctype : "application\/x-www-form-urlencoded";
    this.technique = bIsPost ? this.contentType === "multipart\/form-data" ? 3 : this.contentType === "text\/plain" ? 2 : 1 : 0;
    this.receiver = oTarget.action;
    this.status = 0;
    this.segments = [];
    var fFilter = this.technique === 2 ? plainEscape : escape;
    for (var nItem = 0; nItem < oTarget.elements.length; nItem++) {
      oField = oTarget.elements[nItem];
      if (!oField.hasAttribute("name")) { continue; }
      sFieldType = oField.nodeName.toUpperCase() === "INPUT" ? oField.getAttribute("type").toUpperCase() : "TEXT";
      if (sFieldType === "FILE" && oField.files.length > 0) {
        if (this.technique === 3) {
          /* enctype is multipart/form-data */
          for (nFile = 0; nFile < oField.files.length; nFile++) {
            oFile = oField.files[nFile];
            oSegmReq = new FileReader();
            /* (custom properties:) */
            oSegmReq.segmentIdx = this.segments.length;
            oSegmReq.owner = this;
            /* (end of custom properties) */
            oSegmReq.onload = pushSegment;
            this.segments.push("Content-Disposition: form-data; name=\"" + oField.name + "\"; filename=\""+ oFile.name + "\"\r\nContent-Type: " + oFile.type + "\r\n\r\n");
            this.status++;
            oSegmReq.readAsBinaryString(oFile);
          }
        } else {
          /* enctype is application/x-www-form-urlencoded or text/plain or method is GET: files will not be sent! */
          for (nFile = 0; nFile < oField.files.length; this.segments.push(fFilter(oField.name) + "=" + fFilter(oField.files[nFile++].name)));
        }
      } else if ((sFieldType !== "RADIO" && sFieldType !== "CHECKBOX") || oField.checked) {
        /* field type is not FILE or is FILE but is empty */
        this.segments.push(
          this.technique === 3 ? /* enctype is multipart/form-data */
            "Content-Disposition: form-data; name=\"" + oField.name + "\"\r\n\r\n" + oField.value + "\r\n"
          : /* enctype is application/x-www-form-urlencoded or text/plain or method is GET */
            fFilter(oField.name) + "=" + fFilter(oField.value)
        );
      }
    }
    processStatus(this);
  }

  return function (oFormElement) {
    if (!oFormElement.action) { return; }
    new SubmitRequest(oFormElement);
  };

})();
 
 function fill_data_cfg(){
   //alert("fill_data_cfg");
   // [1PPS] RS [Delay] 0 [PPSOUT] 1PPS [NMEA] RS
   
  
   cfg_vars = onloadRes.split(' '); 

   //alert(cfg_vars[1]);
   switch (cfg_vars[1]) {            // [1PPS] returned value
	 case 'GPS':
	   //alert('GPS');
	   document.getElementById('gl_gs').checked = true;
	   break;
	 case '1PPS':
	   //alert('1PPS');
	   document.getElementById('1pps').checked = true;
	   break;
	 case 'RS':
	  //alert('RS');
	   document.getElementById('rs').checked = true;
	   break;
   }
  
  // alert(cfg_vars[7]);
   switch (cfg_vars[7]) {            // [NMEA] returned value
	 case 'GPS':
	   //alert('GPS');
	   document.getElementById('gl_gs_na').checked = true;
	   break;
	 case 'Emulator':
	   //alert('Emulator');
	   document.getElementById('emul').checked = true;
	   break;
	 case 'RS':
	   //alert('RS');
	   document.getElementById('rs_na').checked = true;
	   break;
   }
   
	document.getElementById('Delay').value = cfg_vars[3];
   	document.getElementById('cancel_cfg').style.color = "black";
	document.getElementById('cancel_cfg').value = "Cancel";
   
 }
 
 function fill_data(){
	//alert("fill_data");
   
   document.getElementById("s1e_ch").checked = false;
   document.getElementById("s2e_ch").checked = false;
   document.getElementById("s3e_ch").checked = false;
   document.getElementById("s4e_ch").checked = false;
   
   document.getElementById("ds1e_ch").checked = false;
   document.getElementById("ds2e_ch").checked = false;
   document.getElementById("ds3e_ch").checked = false;
   document.getElementById("ds4e_ch").checked = false;
   
   document.getElementById("ip_addr").value = "";
   document.getElementById("mask").value = "";
   document.getElementById("subn").value = "";
   document.getElementById("getw").value = "";
   
   document.getElementById("ntp_1").value = "";
   document.getElementById("ntp_2").value = "";
   document.getElementById("ntp_3").value = "";
   document.getElementById("ntp_4").value = "";
   
   document.getElementById("dns_1").value = "";
   document.getElementById("dns_2").value = "";
   document.getElementById("dns_3").value = "";
   document.getElementById("dns_4").value = "";
   
   
	net_vars = onloadRes.split(' ');
	document.getElementById('ip_addr').value = net_vars[1];
	document.getElementById('mask').value = net_vars[3];
	document.getElementById('subn').value = net_vars[5];
	document.getElementById('getw').value = net_vars[7];
	
	// ---------------------------------------------------------------
	
	document.getElementById('ntp_1').value = net_vars[9];
		if (net_vars[8][0] != "#"){
			document.getElementById("s1e_ch").checked = true;
		}
	document.getElementById('ntp_2').value = net_vars[11];
	if (net_vars[10][0] != "#"){
			document.getElementById("s2e_ch").checked = true;
		}
	document.getElementById('ntp_3').value = net_vars[13];
		if (net_vars[12][0] != "#"){
			document.getElementById("s3e_ch").checked = true;
		}
	document.getElementById('ntp_4').value = net_vars[15];
		if (net_vars[14][0] != "#"){
			document.getElementById("s4e_ch").checked = true;
		}

     // ---------------------------------------------------------------
	
	document.getElementById('dns_1').value = net_vars[17];
		if (net_vars[16][0] != "#"){
			document.getElementById("ds1e_ch").checked = true;
		}
	document.getElementById('dns_2').value = net_vars[19];
		if (net_vars[18][0] != "#"){
			document.getElementById("ds2e_ch").checked = true;
		}
	document.getElementById('dns_3').value = net_vars[21];
		if (net_vars[20][0] != "#"){
			document.getElementById("ds3e_ch").checked = true;
		}
	document.getElementById('dns_4').value = net_vars[23];
		if (net_vars[22][0] != "#"){
			document.getElementById("ds4e_ch").checked = true;
		}
	
	document.getElementById('cnancel_eth').style.color = "black";
	document.getElementById('cnancel_eth').value = "Cancel";
	
    document.getElementById('cnancel_ntp').style.color = "black";
	document.getElementById('cnancel_ntp').value = "Cancel";
	
	document.getElementById('cnancel_dns').style.color = "black";
	document.getElementById('cnancel_dns').value = "Cancel";
}


function onloadData(){
   fill = "yes";
   if (onload_cfg_flag == "cfg"){
	 //alert("CFG onloadData");
	 AJAXSubmit(document.onsubmitForm_cfg);
   } else {
	 //alert("Ethernet onloadData");
	  AJAXSubmit(document.onsubmitForm);
   }
}

//----------------------------------------------

function verifyIP (IPvalue) {
  //alert(IPvalue);
  //IPvalue="192.168.2.100";
  var ipPattern = /^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/;
  var ipArray = IPvalue.match(ipPattern);
  //alert(ipArray);
  if (ipArray == null)
	return 1;
  else {
	var segment;
	var i;
	for(i=1; i<5; i++){
	  if (ipArray[i] > 255) return 1;
	}
  }
return 0;
}

//----------------------------------------------



function update_eth_form(){
	//alert("updata_eth_from()");
    var ip_check = 0;
	ip_check +=verifyIP(document.getElementById('ip_addr').value);
	ip_check +=verifyIP(document.getElementById('mask').value);
	ip_check +=verifyIP(document.getElementById('subn').value);
	ip_check +=verifyIP(document.getElementById('getw').value);
	if(ip_check > 0){
	  alert("Wrong IP ! Push 'Cancel' and try again");
	  return 0;
	}
	
	fill = "no";
	document.getElementById('eth_button').style.color = "red";
	document.getElementById('eth_button').value = "BUSY";
	AJAXSubmit(document.eth_form);
}

function update_ntp_form(){
   // alert("update_ntp_from");
  
	var ip_check = 0;
	ip_check +=verifyIP(document.getElementById('ntp_1').value);
	ip_check +=verifyIP(document.getElementById('ntp_2').value);
	ip_check +=verifyIP(document.getElementById('ntp_3').value);
	ip_check +=verifyIP(document.getElementById('ntp_4').value);
	if(ip_check > 0){
	  alert("Wrong IP ! Push 'Cancel' and try again");
	  return 0;
	}
	
	fill = "no";
	document.getElementById('ntp_button').style.color = "red";
	document.getElementById('ntp_button').value = "BUSY";
	AJAXSubmit(document.ntp_form); 
}

function update_dns_form(){
   // alert("update_ntp_from");
  
  	var ip_check = 0;
	ip_check +=verifyIP(document.getElementById('dns_1').value);
	ip_check +=verifyIP(document.getElementById('dns_2').value);
	ip_check +=verifyIP(document.getElementById('dns_3').value);
	ip_check +=verifyIP(document.getElementById('dns_4').value);
	//alert(ip_check);
	if(ip_check > 0){
	  alert("Wrong IP ! Push 'Cancel' and try again");
	  return 0;
	}
	//alert("ip ok");
	fill = "no";
	document.getElementById('dns_button').style.color = "red";
	document.getElementById('dns_button').value = "BUSY";
	AJAXSubmit(document.dns_form); 
}

function update_cfg_form(){
	fill = "no"
	//alert('update_cfg_form');
	document.getElementById('conf_button').style.color = "red";
	document.getElementById('conf_button').value = "BUSY";
	AJAXSubmit(document.cfg_form);
	//alert('After AJAX');
}


function onload_cfg(){
 onload_cfg_flag = "cfg";
}

function cancel_ethernet(){
  window.location.reload()
}
   

window.onload = onloadData;
