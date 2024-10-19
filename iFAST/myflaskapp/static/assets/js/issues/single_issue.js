$(document).ready(function() {
    $('#go_back').on('click', function() {
        $('#nav-home-tab').tab('show');
    });
    $('#proceed').on('click', function() {
        $('#nav-profile-tab').tab('show');
    });
    $('.dropdown').hover(function() {
        $(this).find('.dropdown-menu').stop(true, true).delay(100).fadeIn(300).addClass('show');
    }, function() {
        $(this).find('.dropdown-menu').stop(true, true).delay(100).fadeOut(300).removeClass('show');
    });
    $('#saveissue').hide();
    $('#saveissue_seq').hide();
    $('#saveissue').on('click', function(e) {
        e.preventDefault();

        var formData = $('#singleissueform').serialize();
        $.ajax({
            url: "/save_singleissue",
            type: "post",
            data: formData,
            success: function(data) {
                if (data.message) {
                    $('#update_ret').html(data.message).removeClass('text-danger').addClass('text-success');
                    $('#singleissueform :input').prop('readonly', true);
                    $('#singleissueform textarea').prop('readonly', true);
                    location.rload();
                } else {
                    $('#update_ret').html(data.error).removeClass('text-success').addClass('text-danger');
                }

            },

        });
    });
    $('#editissue').click(function() {

        $('input[type="text"], textarea, input[type="text"]').removeAttr('readonly');
        $('select').removeAttr('disabled');
        //$('input[type="text"], textarea').removeAttr('readonly');
        $('#editissue').hide();
        $('#saveissue').show();
    });
    $('#editissue_seq').click(function() {
        $('input[type="text"], textarea, input[type="text"]').removeAttr('readonly');
        $('select').removeAttr('disabled');
        //$('input[type="text"], textarea').removeAttr('readonly');
        $('#editissue_seq').hide();
        $('#saveissue').show();
    });
});