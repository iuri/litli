function FileProgress(fileObj, target_id) {
    this.file_progress_id = fileObj.id;

    this.opacity = 100;
    this.height = 0;

    this.fileProgressWrapper = document.getElementById(this.file_progress_id);
    if (!this.fileProgressWrapper) {
        this.fileProgressWrapper = document.createElement("div");
        this.fileProgressWrapper.className = "progressWrapper";
        this.fileProgressWrapper.id = this.file_progress_id;

        this.fileProgressElement = document.createElement("div");
        this.fileProgressElement.className = "progressContainer";

        var progressCancel = document.createElement("a");
        progressCancel.className = "progressCancel";
        progressCancel.href = "#";
        progressCancel.style.visibility = "hidden";
        progressCancel.appendChild(document.createTextNode(" "));

        var progressText = document.createElement("div");
        progressText.className = "progressName";
        progressText.appendChild(document.createTextNode(fileObj.name));

        var progressBar = document.createElement("div");
        progressBar.className = "progressBarInProgress";

        var progressStatus = document.createElement("div");
        progressStatus.className = "progressBarStatus";
        progressStatus.innerHTML = "&nbsp;";

        this.fileProgressElement.appendChild(progressCancel);
        this.fileProgressElement.appendChild(progressText);
        this.fileProgressElement.appendChild(progressStatus);
        this.fileProgressElement.appendChild(progressBar);

        this.fileProgressWrapper.appendChild(this.fileProgressElement);

        document.getElementById(target_id).appendChild(this.fileProgressWrapper);
    } else {
        this.fileProgressElement = this.fileProgressWrapper.firstChild;
    }

    this.height = this.fileProgressWrapper.offsetHeight;

}
FileProgress.prototype.SetProgress = function(percentage) {
    this.fileProgressElement.className = "progressContainer green";
    this.fileProgressElement.childNodes[3].className = "progressBarInProgress";
    this.fileProgressElement.childNodes[3].style.width = percentage + "%";
}
FileProgress.prototype.SetComplete = function() {
    this.fileProgressElement.className = "progressContainer blue";
    this.fileProgressElement.childNodes[3].className = "progressBarComplete";
    this.fileProgressElement.childNodes[3].style.width = "";

    var oSelf = this;
    setTimeout(function() { oSelf.Disappear(); }, 10000);
}
FileProgress.prototype.SetError = function() {
    this.fileProgressElement.className = "progressContainer red";
    this.fileProgressElement.childNodes[3].className = "progressBarError";
    this.fileProgressElement.childNodes[3].style.width = "";
    var oSelf = this;
    setTimeout(function() { oSelf.Disappear(); }, 5000);
}
FileProgress.prototype.SetCancelled = function() {
    this.fileProgressElement.className = "progressContainer";
    this.fileProgressElement.childNodes[3].className = "progressBarError";
    this.fileProgressElement.childNodes[3].style.width = "";

    var oSelf = this;
    setTimeout(function() { oSelf.Disappear(); }, 2000);
}
FileProgress.prototype.SetStatus = function(status) {
    this.fileProgressElement.childNodes[2].innerHTML = status;
}
FileProgress.prototype.ToggleCancel = function(show, upload_obj) {
    this.fileProgressElement.childNodes[0].style.visibility = show ? "visible" : "hidden";
    if (upload_obj) {
        var file_id = this.file_progress_id;
        var oSelf = this;
        this.fileProgressElement.childNodes[0].onclick = function() {
            upload_obj.cancelUpload(file_id,false);
            oSelf.SetCancelled();
            oSelf.SetStatus(acs_lang_text.uploadcancel || "Cancelled (This item will be removed shortly)");
            oSelf.ToggleCancel(false);
            return false; 
        };
    }
}
FileProgress.prototype.Disappear = function() {

    var reduce_opacity_by = 15;
    var reduce_height_by = 4;
    var rate = 30;  // 15 fps

    if (this.opacity > 0) {
        this.opacity -= reduce_opacity_by;
        if (this.opacity < 0) this.opacity = 0;

        if (this.fileProgressWrapper.filters) {
            try {
                this.fileProgressWrapper.filters.item("DXImageTransform.Microsoft.Alpha").opacity = this.opacity;
            } catch (e) {
                // If it is not set initially, the browser will throw an error.  This will set it if it is not set yet.
                this.fileProgressWrapper.style.filter = 'progid:DXImageTransform.Microsoft.Alpha(opacity=' + this.opacity + ')';
            }
        } else {
            this.fileProgressWrapper.style.opacity = this.opacity / 100;
        }
    }

    if (this.height > 0) {
        this.height -= reduce_height_by;
        if (this.height < 0) this.height = 0;

        this.fileProgressWrapper.style.height = this.height + "px";
    }

    if (this.height > 0 || this.opacity > 0) {
        var oSelf = this;
        setTimeout(function() { oSelf.Disappear(); }, rate);
    } else {
        this.fileProgressWrapper.style.display = "none";
        this.fileProgressWrapper.parentNode.removeChild(this.fileProgressWrapper);
    }
}


