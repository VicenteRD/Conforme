//= require summernote
//= require summernote/locales/es-ES

//= require bootstrap-datetimepicker

function sendFile(file, toSummernote) {
    var data;
    data = new FormData;
    data.append('upload[image]', file);
    return $.ajax({
        data: data,
        type: 'POST',
        url: '/uploads',
        cache: false,
        contentType: false,
        processData: false,
        success: function(data) {
            console.log('file uploading...');
            return toSummernote.summernote("insertImage", data.url);
        }
    });
}

function newSummernote(field) {
    field.summernote({
        height: 300,
        maxHeight: 350,
        lang: 'es-ES'//,
        //callbacks: {
        //    onImageUpload: function(files) {
        //        // upload image to server and create imgNode...
        //        sendFile(files[0], $(this));
        //    }
        //}
    });
}