component extends="coldbox.system.RestHandler" {

    function upload(event, rc, prc) {
        
        var uploadDir = expandPath("/assets/uploads/projects/");
        
        // Ensure folder exists
        if (!directoryExists(uploadDir)) {
            directoryCreate(uploadDir, true);
        }
        
        try {
            // Upload file
            var fileResult = fileUpload(
                destination  = uploadDir,
                fileField    = "file",
                nameConflict = "makeUnique"
            );
            
            // Return response
            event.getResponse().setData({
                "success": true,
                "filename": fileResult.serverFile,
                "url": "/assets/uploads/projects/" & fileResult.serverFile
            });
            
            // Set proper status code
            event.setHTTPHeader(statusCode = 200, statusText = "OK");
            
        } catch (any e) {
            event.getResponse().setData({
                "success": false,
                "error": e.message
            });
            event.setHTTPHeader(statusCode = 500, statusText = "Upload Failed");
        }
        
        return event.getResponse().getData();
    }
}