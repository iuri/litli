// small cross browser function to get an HTTP object for making 
// AJAX style http requests in the background 
// -gustaf neumann Jan, 2006
// exended for dotlrn-chat, message coloring and listing of users
// -peter alberer March, 2006

// global variables
var msgcount = 0; // hack to overcome IE
var dataConnections = new Object; // variable to find all the registered datasources
// var inactivityTimeout = setTimeout(stopUpdates,300000);

// helper function to get a new http request object
function getHttpObject() {
     var http_request = false;
     if (window.XMLHttpRequest) { // Mozilla, Safari,...
         http_request = new XMLHttpRequest();
         if (http_request.overrideMimeType) {
              http_request.overrideMimeType('text/xml');
         }
     } else if (window.ActiveXObject) { // IE
         try {
             http_request = new ActiveXObject("Msxml2.XMLHTTP");
         } catch (e) {
             try {
                 http_request = new ActiveXObject("Microsoft.XMLHTTP");
             } catch (e) {}
         }
     }
     if (!http_request) {
         alert('Cannot create an instance of XMLHTTP');
     }
   return http_request;
}

if (typeof DOMParser == "undefined") {
   DOMParser = function () {}
   DOMParser.prototype.parseFromString = function (str, contentType) {
      if (typeof ActiveXObject != "undefined") {
         var d = new ActiveXObject("MSXML.DomDocument");
         d.loadXML(str);
         return d;
        }
   }
}

// functions that handle the incoming xml/html data
function messagesReceiver(node,doc,div) {
    var tr, td, e, s;
    var msgCount = 0;
    for (var i = 0 ; i < node.childNodes.length ; i++) {
        if (node.childNodes[i].nodeType == 3 ) {
            // if this is a textnode, skip it
            continue;
        }
        msgCount++;
        p = doc.createElement('p');
        p.className = 'line';
        e = node.childNodes[i].getElementsByTagName('span');
        span = doc.createElement('span');
	span.innerHTML = e[0].innerHTML;
        span.className = 'timestamp';
        p.appendChild(span);
        
        span = doc.createElement('span');
        s = e[1].firstChild.nodeValue;
	span.innerHTML = e[1].innerHTML;
        span.className = 'user';
        p.appendChild(span);
        
        span = doc.createElement('span');
        span.innerHTML = e[2].innerHTML;
        span.className = 'message';
        p.appendChild(span);
        
        div.appendChild(p);
    }
    if ( msgCount > 0 ) { 
        frames['ichat'].window.scrollTo(0,div.offsetHeight);
    }
}

function pushReceiver(content) {
    updateReceiver(content);
    var msgField = document.getElementById('chatMsg');
    msgField.value = '';
    msgField.disabled = false;
    msgField.focus();
}

function updateReceiver(content) {
    var xmlobject = (new DOMParser()).parseFromString(content, 'application/xhtml+xml');
    var body = xmlobject.getElementsByTagName('body');
    
    for (var i = 0 ; i < body[0].childNodes.length ; i++) {
        if (body[0].childNodes[i].nodeType == 3 ) {
            // if this is a textnode, skip it
            continue;
        }
        var attribute = body[0].childNodes[i].getAttribute('id');
        switch (attribute) {
            case "messages":
                var messagesNode = body[0].childNodes[i];
                if (messagesNode.hasChildNodes()) {
                    var messagesDoc = frames['ichat'].document;
                    var messagesDiv = messagesDoc.getElementById('messages');
		    if (messagesDiv == null) {
			messagesDiv = messagesDoc.createElement('div');
			messagesDiv.id = 'messages';
			messagesDoc.body.appendChild(messagesDiv);
		    }
                    messagesReceiver(messagesNode,messagesDoc,messagesDiv);
                }                
                break;
            case "users":
                var usersNode = body[0].childNodes[i].childNodes[0];
                var usersDoc = frames['ichat-users'].document;
                var usersTbody = usersDoc.getElementById('users').tBodies[0];
                usersReceiver(usersNode,usersDoc,usersTbody);                
                break;
        }
    }
}

function usersReceiver(node,doc,tbody) {
    var tr, td, e, s, nbody;
    nbody = doc.createElement('tbody');
    for (var i = 0 ; i < node.childNodes.length ; i++) {
        if (node.childNodes[i].nodeType == 3 ){
            // if this is a textnode, skip it
            continue;
        }
        tr = doc.createElement('tr');
        e = node.childNodes[i].getElementsByTagName('TD');
        
        td = doc.createElement('td');
	// 2017-04-06:	
	// - td.innerHTML = e[0].innerHTML: Explorer 11 will show
	//   undefined instead of username	
	// - td.appendChild(e[0].firstChild): Chrome loses href and
	//   style
	// copying by hand is currently the only solution I have found
	ea = e[0].firstChild;
	a = doc.createElement('a');
	a.setAttribute('target', ea.getAttribute('target'));
	a.setAttribute('href', ea.getAttribute('href'));
	a.setAttribute('style', ea.getAttribute('style'));
	a.textContent = ea.textContent;
	td.appendChild(a);
        td.className = 'user';
        tr.appendChild(td);
        
        td = doc.createElement('td');	
	td.appendChild(e[1].firstChild);
        td.className = 'timestamp';
        tr.appendChild(td);   
        
        nbody.appendChild(tr);
    }
    tbody.parentNode.replaceChild(nbody,tbody);
}

function DataConnection() {};

DataConnection.prototype = {
    handler: null,
    url: null,
    connection: null,
    busy: null,
    autoConnect: null,
    
    httpSendCmd: function(url) {
        // if (!this.connection) {
            this.busy = true;
            this.connection = getHttpObject();
        // }
        this.connection.open('GET', url + '&mc=' + msgcount++, true);
        var self = this;
        this.connection.onreadystatechange = function() {
            self.httpReceiver(self);
        }
        this.connection.send('');
    },
    
    httpReceiver: function(obj) {
         if (obj.connection.readyState == 4) {
            if (obj.connection.status == 200) {
                obj.handler(obj.connection.responseText);
                obj.busy = false;
            } else {
                clearInterval(updateInterval);
		var errmsg = obj.connection.responseText.trim();		
		if (!errmsg.match("^chat-errmsg: .*")) {
		    errmsg = 'Something wrong in HTTP request, status code = ' + obj.connection.status;
		} else {
		    errmsg = errmsg.substr(13);
		}
		alert(errmsg);
            }
        }       
    }, 
    
    chatSendMsg: function(send_url) {
        // if (inactivityTimeout) {
        //     clearTimeout(inactivityTimeout);
            // alert("Clearing inactivityTimeout");
        // }
        // if (!updateInterval) {
            // alert("Rescheduling updateInterval");
        //     updateInterval = setInterval(updateDataConnections,5000);
        // }
        if (this.busy) {
            alert("chatSendMsg conflict! Maybe banned?");
        }
        var msgField = document.getElementById('chatMsg');
	msg = encodeURIComponent(msgField.value);	
        if (msg == '') {
            return;
        }
        msgField.disabled = true;	
        this.httpSendCmd(send_url + msg);
        msgField.value = '#chat.sending_message#';
        // alert("Reseting inactivityTimeout");
        // inactivityTimeout = setTimeout(stopUpdates,300000);
    },   
    
    updateBackground: function() {
        //alert("binda = " + this);
        if (this.busy) {
            //alert("Message update function cannot run because the last connection is still busy!");
            return;
        } else {
            this.httpSendCmd(this.url);
        }
    }
}

function registerDataConnection(handler,url,autoConnect) {
    // var ds = new DataConnection(handler,url,autoConnect);
    var ds = new DataConnection();
    ds.handler = handler;
    ds.url = url;
    ds.autoConnect = autoConnect;
    ds.busy = false;
    dataConnections[url] = ds;
    return ds;
}

function updateDataConnections() {
    for (var ds in dataConnections) {
        if (dataConnections[ds].autoConnect) {
            // alert("updating " + dataConnections[ds].url);
            dataConnections[ds].updateBackground();
        }
    }
}

function stopUpdates() {
    // alert("Stopping all update operations");
    clearInterval(updateInterval);
    updateInterval = null;
    clearTimeout(inactivityTimeout);
    inactivityTimeout = null;
}

function startProc() {
    document.getElementById('chatMsg').focus();
    var messagesDiv = frames['ichat'].document.getElementById('messages');
    if (messagesDiv) { 
        frames['ichat'].window.scrollTo(0,messagesDiv.offsetHeight); 
    }
}

window.onload = startProc;

