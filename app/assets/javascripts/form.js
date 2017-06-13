//
//= require jquery.mask
//
//= require summernote
//= require summernote/locales/es-ES
//
//= require bootstrap-datetimepicker
//


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
        height: 100,
        lang: 'es-ES'//,
        //callbacks: {
        //    onImageUpload: function(files) {
        //        // upload image to server and create imgNode...
        //        sendFile(files[0], $(this));
        //    }
        //}
    });
}

function newDateTimePicker(inputArea, tz) {
    var inputField = inputArea.find('.form-control');
    // Save the value for later use before it gets reset
    var intValue = inputField.val();

    var maxDate;
    if (inputField.attr('data-max') === undefined) {
        maxDate = Date.now();
    } else {
        maxDate = false; // Should parse data-max
    }
    var format = inputField.attr('data-format');

    inputArea.datetimepicker({
        locale: moment.locale('es'),
        format: format,
        useCurrent: false,
        maxDate: maxDate,
        timeZone: tz,
        icons: {
            time: "fa fa-clock-o",
            date: "fa fa-calendar",
            up: "fa fa-arrow-up",
            down: "fa fa-arrow-down",
            previous: "fa fa-arrow-left",
            next: "fa fa-arrow-right"
        }
    });

    inputField.val(moment.unix(parseInt(intValue)).format(format));
}

