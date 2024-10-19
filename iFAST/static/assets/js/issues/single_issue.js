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
                    $('#update_ret').parent().removeClass('d-none');
                    $('#update_ret').html(data.message).removeClass('text-danger').addClass('text-success');
                    $('#singleissueform :input').prop('readonly', true);
                    $('#singleissueform select').prop('disabled', 'disabled');
                    $('#singleissueform select').css('background-color', '#e9ecef');
                    $('#singleissueform textarea').prop('readonly', true);
                     setTimeout(function(){
                        location.reload();
                    }, 2000);
                } else {
                    $('#update_ret').parent().removeClass('d-none');
                    $('#update_ret').html(data.error).removeClass('text-success').addClass('text-danger');
                }

            },

        });
    });


    $('#editissue').click(function() {
                // Remove readonly attribute from all input and textarea elements

                formSelector =$("#"+ $("#editissue").parent().parent().parent().next().find(".form").attr("id"))
                $(formSelector).find('input[type="text"], textarea').removeAttr('readonly');
                $(formSelector).find('input[type="password"], textarea').removeAttr('readonly');
                $(formSelector).find('#msId').attr('readonly', true)

                $(formSelector).find("#status").attr('readonly', false);
                $(formSelector).find("#status").attr('style', 'background-color:#fff;');
                $(formSelector).find("#status").prop('disabled', false)

                 $(formSelector).find("#sw").attr('readonly', false);
                 $(formSelector).find("#sw").attr('style', 'background-color:#fff;');
                 $(formSelector).find("#sw").removeAttr('disabled')

                $(formSelector).find("#Visibility").attr('readonly', false);
                 $(formSelector).find("#Visibility").removeAttr('disabled')
                 $(formSelector).find("#Visibility").attr('style', 'background-color:#fff;');

                 $(formSelector).find("#tech").attr('readonly', false);
                 $(formSelector).find("#tech").removeAttr('disabled')
                 $(formSelector).find("#tech").attr('style', 'background-color:#fff;');

                 $(formSelector).find("#action_type").attr('readonly', false);
                 $(formSelector).find("#action_type").removeAttr('disabled')
                 $(formSelector).find("#action_type").attr('style', 'background-color:#fff;');

                 $(formSelector).find("#kpi").attr('readonly', false);
                 $(formSelector).find("#kpi").removeAttr('disabled')
                 $(formSelector).find("#kpi").attr('style', 'background-color:#fff;');

                $(formSelector).find("#area").attr('readonly', false);
                 $(formSelector).find("#area").removeAttr('disabled')
                $(formSelector).find("#area").attr('style', 'background-color:#fff;');

                $('#editissue').attr('disabled', true);
               $('#saveissue').attr('disabled', false);
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


function hideFunction(id_selector){
     // hide every fields on startup
    if (!id_selector){
        id_selector = 'issue_sequence_card_1'
    }
    var selector = $('#'+ id_selector + ':not(.d-none)')
   // selector.find('.checkbox-group').closest('div').hide();
     selector.find('.checkbox-group ').children().hide();
    selector.find('input[name="scName"]').closest('.form-group').hide();
    selector.find('input[name="ip"]').closest('.form-group').hide();
    selector.find('input[name="scLoc"]').closest('.form-group').hide();
    selector.find('input[name="scOwner"]').closest('.form-group').hide();
    selector.find('input[name="scPath"]').closest('.form-group').hide();
    selector.find('textarea[name="pattern_grep"]').closest('div').hide();
     selector.find('textarea[name="check_condition"]').closest('div').hide();
     selector.find('textarea[name="regex"]').closest('div').hide();
     selector.find('input[name="ip"]').closest('div').hide();
     selector.find('input[name="scLoc"]').closest('div').hide();
     selector.find('input[name="scOwner"]').closest('div').hide();
     selector.find('input[name="scPath"]').closest('div').hide();
     selector.find('input[name="uid"]').closest('div').hide();
     selector.find('input[name="pwd"]').closest('div').hide();
}

function loadFunction(idx){
  //  hideFunction(idx)
    i_id = idx.split('_')[3]
    changeFunction(i_id)
}

//new function updatefunction  to update existing issue sequence in kb detail page just as like changefunction
function updateFunction(idx){
    formId = '#IssueSequenceForm' + idx
    var selector = $( '#issue_sequence_card_' + idx)
    var $form =  selector.find(formId)
    data = {}

    $form.find('input, textarea, select').each(function() {
        let $input = $(this);
        let includedIds = [`issue_id_${idx}`, `status_val_${idx}`, `action_id_${idx}`, `sequenceid_${idx}`, `action_type_${idx}`];
        if (includedIds.includes($input.attr('id'))) {
            data[$input.attr('id')] = $input.val()
            if($input.attr('id') === `action_type_${idx}`){
                data['prev_detection_type'] = $input.attr('data-prev-val')
            }
        }

    });

    console.log('data', data)

            var sequence_clone = $('#issue_sequence_card').clone();
            sequence_clone.removeClass('d-none')
            sequence_clone.attr('id', `issue_sequence_card_${idx}`)
            sequence_clone.find('.icon-container >  .iconCardMinus').attr('id', `iconCard${idx}Minus`);
            sequence_clone.find('.icon-container >  .iconCardMinus').attr('data-bs-target', `#collapseCard${idx}`);
            sequence_clone.find('.icon-container >  .iconCardMinus').attr('aria-controls', `collapseCard${idx}`);
            sequence_clone.find('.card-header > .icon-container').children().eq(1).remove();
            sequence_clone.find('.collapse').attr('id', `collapseCard${idx}`);
            sequence_clone.find(`#collapseCard${idx} > .card-body > #IssueSequenceForm`).attr('id', `IssueSequenceForm${idx}`);

            sequence_clone.find(`#IssueSequenceForm${idx} input[type="text"], #IssueSequenceForm${idx} input[type="password"], #IssueSequenceForm${idx} textarea`).val('');
            sequence_clone.find(`#IssueSequenceForm${idx} input[type="text"], #IssueSequenceForm${idx} input[type="hidden"], #IssueSequenceForm${idx} textarea, #IssueSequenceForm${idx} select, #IssueSequenceForm${idx} input[type="radio"], #IssueSequenceForm${idx} input[type="checkbox"], #IssueSequenceForm${idx} input[type="password"] `).each(function() {
                var currentId = $(this).attr('id'); // Get the current ID of the element
                if (currentId) {
                    console.log('currentId',currentId)
                    var newId = currentId + `_${idx}`; // Append _1 to the ID

                    // Update the element's ID
                    $(this).attr('id', newId);
                    console.log('newID', $(this).attr('id'))
                    // Find the corresponding label and update its 'for' attribute
                    $(this).siblings('label[for="' + currentId + '"]').attr('for', newId);
                    $(this).parent().siblings().find('label[for="proceed_yes"]').attr('for', 'procees_yes_' + idx);
                }
            });



            sequence_clone.find(`#IssueSequenceForm${idx} select`).prop('selectedIndex', 0);
            sequence_clone.find(`#IssueSequenceForm${idx} input[type="checkbox"], #IssueSequenceForm${idx} input[type="radio"]`).prop('checked', false);
            sequence_clone.find(`#issue_id_${idx}`).val(`${data[`issue_id_${idx}`]}`)
            sequence_clone.find(`#action_id_${idx}`).val(`${data[`action_id_${idx}`]}`)
            sequence_clone.find(`#sequenceid_${idx}`).val(`${idx}`)
          //  sequence_clone.find('.card-header > .icon-container').append(`<h5 class="text-white header ml-4" style="position: relative; bottom: 20px;"> &nbsp; &nbsp; &nbsp;Issue Detection Step Id: ${idx} &nbsp; &nbsp; &nbsp; Detection Type : ${data[`action_type_${idx}`]}</h5>`)
            sequence_clone.find('.card-header > .icon-container').append(selector.find('.card-header > .icon-container > h5').clone())
            current_editbtn_id  = sequence_clone.find(`.edit_btn`).attr('id').split("_")[0]
            current_savebtn_id  = sequence_clone.find(`.save_btn`).attr('id').split("_")[0]
            current_deletebtn_id  = sequence_clone.find(`.delete_btn`).attr('id').split("_")[0]
            sequence_clone.find(`.edit_btn`).attr('id',`${current_editbtn_id}_${idx}`)
            sequence_clone.find(`.save_btn`).attr('id',`${current_savebtn_id}_${idx}`)
            sequence_clone.find(`.delete_btn`).attr('id',`${current_deletebtn_id}_${idx}`)
            sequence_clone.find(`#IssueSequenceForm${idx} select`).attr('onchange', `changeFunction(${idx})`)
            sequence_clone.find(`#IssueSequenceForm${idx} select`).val(`${data[`action_type_${idx}`]}`)
            sequence_clone.find(`#IssueSequenceForm${idx} select`).attr('data-prev-val',`${data['prev_detection_type']}`)
            let excludedIds = ['issue_id', 'sequenceid', ]
            sequence_clone.find('input, textarea, select').each(function() {
            if (!excludedIds.includes($(this).attr('name'))) {
             $(this).prop('disabled', false);
             $(this).prop('readonly', false);
            }

            });
            sequence_clone.find('select[name="action_type"]').css('background-color', '#fff')
            selector.addClass('d-none')
            $("#nav-profile").append(sequence_clone)

             var divs = $('div[id^="issue_sequence_card_"]');

                // Sort the divs by extracting the number part of their IDs
                divs.sort(function(a, b) {
                    var numA = parseInt(a.id.split('_').pop());
                    var numB = parseInt(b.id.split('_').pop());
                    return numA - numB;
                });

                // Append the sorted divs back into the parent container
                var parent = $('#nav-profile'); // Replace with the actual parent container ID
                divs.appendTo(parent);





          //  $(`#issue_sequence_card_${issue_sequence_add_counter}`).after(sequence_clone);

        //    $("#nav-profile").append(sequence_clone)

            loadFunction(`issue_sequence_card_${idx}`)




}




  function changeFunction(idx){
         id_selector = '#issue_sequence_card_1'
         formId = '#IssueSequenceForm'
         if (idx){
            id_selector = '#issue_sequence_card_' + idx
            formId = '#IssueSequenceForm' + idx
            }

        idx = idx?idx:1
        var selector = $(id_selector + ':not(.d-none)')
        var $form =  selector.find(formId)

        // Collect all form inputs
        $form.find('input, textarea, select').each(function() {
            let $input = $(this);
            let inputType = $input.attr('type');

            // Handle different input types
            if (inputType === 'checkbox') {
                $input.prop('checked', false);
            }
            else if (inputType === 'radio') {
                if ($input.is(':checked')) {
                    $input.prop('checked', false);
                }
            } else  {

              //  let excludedIds = ['issue_id', 'status_val', 'sequenceid', 'action_type', `savebtn_${idx}`, `editbtn_${idx}`];
                let excludedIds = ['issue_id', 'status_val', 'action_id', 'sequenceid', 'action_type'];
                if (!excludedIds.includes($input.attr('name'))) {
                     $input.val('');
                }




            }
        });


/*
    var selval =  selector.find(formId).find(`#action_type_${idx}`).val()
         if (selval === "PULL OM"){

             selector.find(formId).find(`#scName_${idx}`).closest('div').hide();
             selector.find(formId).find(`#ip_${idx}`).closest('div').hide();
             selector.find(formId).find(`#scLoc_${idx}`).closest('div').hide();
             selector.find(formId).find(`#scOwner_${idx}`).closest('div').hide();
             selector.find(formId).find(`#scPath_${idx}`).closest('div').hide();
             selector.find(formId).find(`#uid_${idx}`).closest('div').hide();
             selector.find(formId).find(`#pwd_${idx}`).closest('div').hide();
             selector.find(formId).find(`#check_condition_${idx}`).closest('div').show();
             selector.find(formId).find(`#regex_${idx}`).closest('div').show();
             selector.find(formId).find(`#pattern_grep_${idx}`).closest('div').hide();
             selector.find(formId).find(`.checkbox-group`).closest('div').show();
        }else if(selval === "RUN CLI" ) {

             selector.find(formId).find(`#uid_${idx}`).closest('.form-group').show();
             selector.find(formId).find(`#pwd_${idx}`).closest('.form-group').show();
             selector.find(formId).find(`#scName_${idx}`).closest('div').hide();
             selector.find(formId).find(`#ip_${idx}`).closest('div').hide();
             selector.find(formId).find(`#scLoc_${idx}`).closest('div').hide();
             selector.find(formId).find(`#scOwner_${idx}`).closest('div').hide();
             selector.find(formId).find(`#scPath_${idx}`).closest('div').hide();
             selector.find(formId).find(`#check_condition_${idx}`).closest('div').show();
             selector.find(formId).find(`#regex_${idx}`).closest('div').show();
             selector.find(formId).find(`#pattern_grep_${idx}`).closest('div').hide();
             selector.find(formId).find(`.checkbox-group`).closest('div').show();
        }  else if(selval === "RUN GREP" ) {

             selector.find(formId).find(`#uid_${idx}`).closest('.form-group').hide();
             selector.find(formId).find(`#pwd_${idx}`).closest('.form-group').hide();
             selector.find(formId).find(`#scName_${idx}`).closest('div').hide();
             selector.find(formId).find(`#ip_${idx}`).closest('div').hide();
             selector.find(formId).find(`#scLoc_${idx}`).closest('div').hide();
             selector.find(formId).find(`#scOwner_${idx}`).closest('div').hide();
             selector.find(formId).find(`#scPath_${idx}`).closest('div').hide();
             selector.find(formId).find(`#check_condition_${idx}`).closest('div').hide();
             selector.find(formId).find(`#regex_${idx}`).closest('div').hide();
             selector.find(formId).find(`#pattern_grep_${idx}`).closest('div').show();
             selector.find(formId).find(`.checkbox-group`).closest('div').hide();
        } else {

             selector.find(formId).find(`.checkbox-group`).closest('div').show();
             selector.find(formId).find(`#scName_${idx}`).closest('.form-group').show();
             selector.find(formId).find(`#ip_${idx}`).closest('.form-group').show();
             selector.find(formId).find(`#scLoc_${idx}`).closest('.form-group').show();
             selector.find(formId).find(`#scOwner_${idx}`).closest('.form-group').show();
             selector.find(formId).find(`#scPath_${idx}`).closest('.form-group').show();
             selector.find(formId).find(`#pattern_grep_${idx}`).closest('div').hide();
             selector.find(formId).find(`#check_condition_${idx}`).closest('div').show();
             selector.find(formId).find(`#regex_${idx}`).closest('div').show();
                //$('.checkbox-group').show(); // Show the entire checkbox group
        }

*/


      var selval =  selector.find(formId).find("select[name='action_type']").val()
         if (selval === "PULL OM"){
             selector.find(formId).find('input[name="scName"]').closest('div').hide();
             selector.find(formId).find('input[name="ip"]').closest('div').hide();
             selector.find(formId).find('input[name="scLoc"]').closest('div').hide();
             selector.find(formId).find('input[name="scOwner"]').closest('div').hide();
             selector.find(formId).find('input[name="scPath"]').closest('div').hide();
             selector.find(formId).find('input[name="uid"]').closest('div').hide();
             selector.find(formId).find('input[name="pwd"]').closest('div').hide();
             selector.find(formId).find('textarea[name="check_condition"]').prev('label').text('Check Condition:');
             selector.find(formId).find('textarea[name="check_condition"]').closest('div').show();
             selector.find(formId).find('textarea[name="regex"]').closest('div').hide();
             selector.find(formId).find('textarea[name="om_counters"]').closest('div').show();
             selector.find(formId).find('textarea[name="pattern_grep"]').closest('div').hide();
             selector.find(formId).find('.checkbox-group').children().show();
        }else if(selval === "RUN CLI" ) {
             selector.find(formId).find('input[name="uid"]').closest('.form-group').hide();
             selector.find(formId).find('input[name="pwd"]').closest('.form-group').hide();
             selector.find(formId).find('input[name="scName"]').closest('div').hide();
             selector.find(formId).find('input[name="ip"]').closest('div').hide();
             selector.find(formId).find('input[name="scLoc"]').closest('div').hide();
             selector.find(formId).find('input[name="scOwner"]').closest('div').hide();
             selector.find(formId).find('input[name="scPath"]').closest('div').hide();
             selector.find(formId).find('textarea[name="om_counters"]').closest('div').hide();
             selector.find(formId).find('textarea[name="check_condition"]').prev('label').text('Command:');
             selector.find(formId).find('textarea[name="check_condition"]').closest('div').show();
             selector.find(formId).find('textarea[name="regex"]').closest('div').hide();
             selector.find(formId).find('textarea[name="pattern_grep"]').closest('div').hide();
             selector.find(formId).find('.checkbox-group').children().show();
        }  else if(selval === "RUN GREP" ) {
             selector.find(formId).find('input[name="uid"]').closest('.form-group').hide();
             selector.find(formId).find('input[name="pwd"]').closest('.form-group').hide();
             selector.find(formId).find('input[name="scName"]').closest('div').hide();
             selector.find(formId).find('input[name="ip"]').closest('div').hide();
             selector.find(formId).find('input[name="scLoc"]').closest('div').hide();
             selector.find(formId).find('input[name="scOwner"]').closest('div').hide();
             selector.find(formId).find('input[name="scPath"]').closest('div').hide();
             selector.find(formId).find('textarea[name="check_condition"]').closest('div').hide();
             selector.find(formId).find('textarea[name="regex"]').closest('div').hide();
             selector.find(formId).find('textarea[name="om_counters"]').closest('div').hide();
             selector.find(formId).find('textarea[name="pattern_grep"]').closest('div').show();
             selector.find(formId).find('.checkbox-group').children().hide();
        } else {
             selector.find(formId).find('input[name="scName"]').closest('.form-group').hide();
             selector.find(formId).find('input[name="ip"]').closest('.form-group').hide();
             selector.find(formId).find('input[name="scLoc"]').closest('.form-group').hide();
             selector.find(formId).find('input[name="scOwner"]').closest('.form-group').hide();
             selector.find(formId).find('input[name="scPath"]').closest('.form-group').hide();
             selector.find(formId).find('textarea[name="pattern_grep"]').closest('div').hide();
             selector.find(formId).find('textarea[name="check_condition"]').closest('div').hide();
             selector.find(formId).find('textarea[name="regex"]').closest('div').hide();
             selector.find(formId).find('textarea[name="om_counters"]').closest('div').hide();
             selector.find(formId).find('.checkbox-group').children().hide();
                //$('.checkbox-group').show(); // Show the entire checkbox group
        }



    }



