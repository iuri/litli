/********** UTILS *********************/

/* readCookie
read value of a cookie */
function readCookie(name) {
    var ca = document.cookie.split(';');
    var nameEQ = name + "=";
    for(var i=0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') { c = c.substring(1, c.length) }
        if (c.indexOf(nameEQ) == 0) { return c.substring(nameEQ.length, c.length) }
    }
    return null;
}

/* createCookie
used to maintain state, e.g. when login expires */
function createCookie(name, value, days){
    if (days) {
        var date = new Date();
        date.setTime(date.getTime()+(days*24*60*60*1000));
        var expires = "; expires="+date.toGMTString();
    } else { var expires = "" }
    document.cookie = name+"="+value+expires+"; path=/";
}

/* read query string
read the value of a querystring */
function readQs(q) {
    var query = window.location.search.substring(1);
    var parms = query.split('&');
    for (var i=0; i<parms.length; i++) {
        var pos = parms[i].indexOf('=');
        if (pos > 0) {
            var key = parms[i].substring(0,pos);
            var val = parms[i].substring(pos+1);
            if (key == q) {
                return val;
            }
        }
    }
    return null;
}

/* check Flash Version */
function checkFlashVersion() {

    var x;
    var pluginversion;

    if(navigator.plugins && navigator.mimeTypes.length){
        x = navigator.plugins["Shockwave Flash"];
        if(x && x.description) x = x.description;
    } else if (Ext.isIE){
        try {
            x = new ActiveXObject("ShockwaveFlash.ShockwaveFlash");
            x = x.GetVariable("$version");
        } catch(e){}
    }

    pluginVersion = (typeof(x) == 'string') ? parseInt(x.match(/\d+/)[0]) : 0;

    return pluginVersion;
}

// check if the string argument is a url
function isURL(argvalue) {

  if (argvalue.indexOf(" ") != -1)
    return false;
  else if (argvalue.indexOf("http://") == -1)
    return false;
  else if (argvalue == "http://")
    return false;
  else if (argvalue.indexOf("http://") > 0)
    return false;

  argvalue = argvalue.substring(7, argvalue.length);
  if (argvalue.indexOf(".") == -1)
    return false;
  else if (argvalue.indexOf(".") == 0)
    return false;
  else if (argvalue.charAt(argvalue.length - 1) == ".")
    return false;

  if (argvalue.indexOf("/") != -1) {
    argvalue = argvalue.substring(0, argvalue.indexOf("/"));
    if (argvalue.charAt(argvalue.length - 1) == ".")
      return false;
  }

  if (argvalue.indexOf(":") != -1) {
    if (argvalue.indexOf(":") == (argvalue.length - 1))
      return false;
    else if (argvalue.charAt(argvalue.indexOf(":") + 1) == ".")
      return false;
    argvalue = argvalue.substring(0, argvalue.indexOf(":"));
    if (argvalue.charAt(argvalue.length - 1) == ".")
      return false;
  }

  return true;

}