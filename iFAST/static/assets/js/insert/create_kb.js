function hideFunction(id_selector) {
  // hide every fields on startup
  if (!id_selector) {
    id_selector = "issue_sequence_card_1";
  }
  var selector = $("#" + id_selector);
  //  selector.find('.checkbox-group').closest('div').hide();
  selector.find(".checkbox-group ").children().hide();
  selector.find("#scName").closest(".form-group").hide();
  selector.find("#ip").closest(".form-group").hide();
  selector.find("#scLoc").closest(".form-group").hide();
  selector.find("#scOwner").closest(".form-group").hide();
  selector.find("#scPath").closest(".form-group").hide();
  selector.find("#pattern_grep").closest("div").hide();
  selector.find("#check_condition").closest("div").hide();
  selector.find("#regex").closest("div").hide();
  selector.find("#ip").closest("div").hide();
  selector.find("#scLoc").closest("div").hide();
  selector.find("#scOwner").closest("div").hide();
  selector.find("#scPath").closest("div").hide();
  selector.find("#uid").closest("div").hide();
  selector.find("#pwd").closest("div").hide();
  selector.find("#pattern_grep").closest("div").hide();
  selector.find("#om_counters").closest("div").hide();
}

function changeFunction(idx) {
  console.log("changeFunction");
  id_selector = "#issue_sequence_card_1";
  formId = "#IssueSequenceForm";
  if (idx) {
    id_selector = "#issue_sequence_card_" + idx;
    formId = "#IssueSequenceForm" + idx;
  }
  // debugger
  idx = idx ? idx : 1;
  var selector = $(id_selector);
  var $form = selector.find(formId);
  //  debugger
  // Collect all form inputs
  $form.find("input, textarea, select").each(function () {
    let $input = $(this);
    let inputType = $input.attr("type");

    // Handle different input types
    if (inputType === "checkbox") {
      $input.prop("checked", false);
    } else if (inputType === "radio") {
      if ($input.is(":checked")) {
        $input.prop("checked", false);
      }
    } else {
      // debugger
      let excludedIds = [
        "issue_id",
        "status_val",
        "sequenceid",
        "action_type",
        `savebtn_${idx}`,
        `editbtn_${idx}`,
        "action_id",
        "sw_val",
      ];
      if (!excludedIds.includes($input.attr("id"))) {
        $input.val("");
      }
    }
  });

  var selval = selector.find(formId).find("#action_type").val();
  if (selval === "PULL OM") {
    selector.find(formId).find("#scName").closest("div").hide();
    selector.find(formId).find("#ip").closest("div").hide();
    selector.find(formId).find("#scLoc").closest("div").hide();
    selector.find(formId).find("#scOwner").closest("div").hide();
    selector.find(formId).find("#scPath").closest("div").hide();
    selector.find(formId).find("#uid").closest("div").hide();
    selector.find(formId).find("#pwd").closest("div").hide();
    selector.find(formId).find("#check_condition").closest("div").show();
    selector.find(formId).find("#regex").closest("div").hide();
    selector.find(formId).find("#om_counters").closest("div").show();
    selector.find(formId).find("#pattern_grep").closest("div").hide();

    selector.find(formId).find(".checkbox-group").children().show();
  } else if (selval === "RUN CLI") {
    selector.find(formId).find("#uid").closest(".form-group").show();
    selector.find(formId).find("#pwd").closest(".form-group").show();

    //   selector.find(formId).find('#uid').prop('disabled', true);
    //   selector.find(formId).find('#pwd').prop('disabled', true);

    selector.find(formId).find("#scName").closest("div").hide();
    selector.find(formId).find("#ip").closest("div").hide();
    selector.find(formId).find("#scLoc").closest("div").hide();
    selector.find(formId).find("#scOwner").closest("div").hide();
    selector.find(formId).find("#scPath").closest("div").hide();
    selector.find(formId).find("#om_counters").closest("div").hide();
    selector
      .find(formId)
      .find("#check_condition")
      .prev("label")
      .text("Command:");
    selector.find(formId).find("#check_condition").closest("div").show();
    selector.find(formId).find("#regex").closest("div").hide();
    selector.find(formId).find("#pattern_grep").closest("div").hide();
    selector.find(formId).find(".checkbox-group").children().show();
  } else if (selval === "RUN GREP") {
    selector.find(formId).find("#uid").closest(".form-group").hide();
    selector.find(formId).find("#pwd").closest(".form-group").hide();
    selector.find(formId).find("#scName").closest("div").hide();
    selector.find(formId).find("#ip").closest("div").hide();
    selector.find(formId).find("#scLoc").closest("div").hide();
    selector.find(formId).find("#scOwner").closest("div").hide();
    selector.find(formId).find("#scPath").closest("div").hide();
    selector.find(formId).find("#check_condition").closest("div").hide();
    selector.find(formId).find("#regex").closest("div").hide();
    selector.find(formId).find("#om_counters").closest("div").hide();
    selector.find(formId).find("#pattern_grep").closest("div").show();
    selector.find(formId).find(".checkbox-group").children().hide();
  } else {
    selector.find(formId).find("#scName").closest(".form-group").show();
    selector.find(formId).find("#ip").closest(".form-group").show();
    selector.find(formId).find("#scLoc").closest(".form-group").show();
    selector.find(formId).find("#scOwner").closest(".form-group").show();
    selector.find(formId).find("#scPath").closest(".form-group").show();
    selector.find(formId).find("#pattern_grep").closest("div").hide();
    selector.find(formId).find("#check_condition").closest("div").show();
    selector.find(formId).find("#regex").closest("div").show();
    selector.find(formId).find("#om_counters").closest("div").hide();
    selector.find(formId).find(".checkbox-group").children().show();
    //$('.checkbox-group').show(); // Show the entire checkbox group
  }
}

$(document).ready(function () {
  hideFunction();
  $("#nav-profile-tab").attr("disabled", true);
  $("#nav-profile-tab").on("click", function (e) {
    if ($(this).attr("disabled")) {
      e.preventDefault();
      e.stopPropagation();
      return false;
    }
  });

  /*

    $('[name="action_type"]').on('change',function(){
        console.log('sadasdas')
        var selval = $(this).val();
        if (selval === "PULL OM"){
             $('#scName').closest('div').hide();
             $('#ip').closest('div').hide();
             $('#scLoc').closest('div').hide();
             $('#scOwner').closest('div').hide();
             $('#scPath').closest('div').hide();
             $('#uid').closest('div').hide();
             $('#pwd').closest('div').hide();
             $('#check_condition').closest('div').show();
             $('#regex').closest('div').show();
             $('#pattern_grep').closest('div').hide();
              $('.checkbox-group').closest('div').show();
        }else if(selval === "RUN CLI" ) {
             $('#uid').closest('.form-group').show();
             $('#pwd').closest('.form-group').show();
             $('#scName').closest('div').hide();
             $('#ip').closest('div').hide();
             $('#scLoc').closest('div').hide();
             $('#scOwner').closest('div').hide();
             $('#scPath').closest('div').hide();
             $('#check_condition').closest('div').show();
             $('#regex').closest('div').show();
             $('#pattern_grep').closest('div').hide();
              $('.checkbox-group').closest('div').show();
        }  else if(selval === "GREP" ) {
             $('#uid').closest('.form-group').hide();
             $('#pwd').closest('.form-group').hide();
             $('#scName').closest('div').hide();
             $('#ip').closest('div').hide();
             $('#scLoc').closest('div').hide();
             $('#scOwner').closest('div').hide();
             $('#scPath').closest('div').hide();
             $('#check_condition').closest('div').hide();
             $('#regex').closest('div').hide();
             $('#pattern_grep').closest('div').show();
             $('.checkbox-group').closest('div').hide();
        } else {
                 $('.checkbox-group').closest('div').show();
                $('#scName').closest('.form-group').show();
                $('#ip').closest('.form-group').show();
                $('#scLoc').closest('.form-group').show();
                $('#scOwner').closest('.form-group').show();
                $('#scPath').closest('.form-group').show();
                $('#pattern_grep').closest('div').hide();
                 $('#check_condition').closest('div').show();
                 $('#regex').closest('div').show();
                //$('.checkbox-group').show(); // Show the entire checkbox group
        }
    });

  */

  const sequenceIdInput = $("#sequenceid");
  const nextButton = $("#next2");
  const prevButton = $("#prev5");
  const steps = $(".step");

  let formStepsNum = 1;
  let totalSteps = parseInt($("#totalSteps").val());
  $("#totalSteps").change(function () {
    totalSteps = parseInt($(this).val());
    formStepsNum = 1;
    //         updateProgressBar(formStepsNum);
  });
  if (formStepsNum === 1) {
    prevButton.hide();
  }
  function updateForm() {
    const progressBar = document.getElementById("progressbar");
    sequenceIdInput.val("1");
    //  sequenceIdInput.val(`${formStepsNum + 1}`);

    // Update steps
    steps.removeClass("active");
    steps.each(function (index) {
      if (index <= formStepsNum) {
        $(this).addClass("active");
      }
    });
  }

  nextButton.on("click", function () {
    prevButton.show();
    if (formStepsNum < totalSteps) {
      formStepsNum++;
      //      updateProgressBar(formStepsNum);
    }
    if (formStepsNum === totalSteps) {
      nextButton.prop("disabled", true);
    }
    //updateForm();
  });
  function updateProgressBar(step) {
    const progressBar = $("#progressbar");
    progressBar.empty(); // Clear the progress bar

    const stepWidth = 100 / totalSteps;

    for (let i = 1; i <= totalSteps; i++) {
      const stepElement = $("<div>").addClass("step").text(i);
      if (i <= step) {
        stepElement.addClass("active");
      }
      progressBar.append(stepElement);

      if (i < totalSteps) {
        const lineElement = $("<div>")
          .addClass("line")
          .css({
            width: `calc(${stepWidth}% - 30px)`, // Adjust width based on step width and step element width
            left: `calc(${i * stepWidth}% - ${stepWidth / 2}%)`, // Adjust left position to be between steps
          });
        if (i < step) {
          lineElement.addClass("active");
        }
        progressBar.append(lineElement);
      }
    }
  }

  prevButton.on("click", function () {
    if (formStepsNum > 0) {
      formStepsNum--;
    }
    updateForm();
  });

  updateForm();

  $(".dropdown").hover(
    function () {
      $(this)
        .find(".dropdown-menu")
        .stop(true, true)
        .delay(100)
        .fadeIn(300)
        .addClass("show");
    },
    function () {
      $(this)
        .find(".dropdown-menu")
        .stop(true, true)
        .delay(100)
        .fadeOut(300)
        .removeClass("show");
    }
  );

  $("#advsrch-link").on("click", function () {
    $("#advsrch").toggle();
    //$('#search').hide();
  });
  $("#resetBtn").on("click", function () {
    $("#searchID").val("");
    $("#select_SW, #select_Tech, #select_kpi, #select_Area").each(function () {
      var firstOption = $(this).find("option:first");
      $(this).val(firstOption.val()).trigger("change");
    });
  });
  $("#searchForm").validate({
    rules: {
      issue_sw: {
        required: true,
      },
      rca: {
        required: true,
      },
      area_val: {
        required: true,
      },
      tech: {
        required: true,
      },
      Visibility: {
        required: true,
      },
      kpi: {
        required: true,
      },
      rca: {
        required: true,
      },
      //    totalSteps: {
      //        required: true
      //    },
    },
    messages: {
      issue_sw: {
        required: "SW field is required",
      },
      rca: {
        required: "Root Cause field is required",
      },
      area_val: {
        required: "Area field is required",
      },
      tech: {
        required: "Technology field is required",
      },
      //      totalSteps: {
      //          required: "Number of steps is required"
      //      },
    },
    errorPlacement: function (error, element) {
      error.appendTo(element.parent()); // Adjust the placement of the error message
    },
  });
  console.log($("#IssueSequenceForm"));
  //  $('#IssueSequenceForm').validate({

  //        $('#update_kb').on('click', function() {
  //            // Validate searchForm
  //            var searchFormValid = $('#searchForm').valid();
  //            var searchFormErrors = [];
  //            if (!searchFormValid) {
  //                $('#searchForm .error').each(function() {
  //                    var fieldName = $(this).prev('label').text().replace('*', '').trim();
  //                    fieldName = fieldName.split(':')
  //                    var errorMessage = $(this).text();
  //                    searchFormErrors.push(fieldName[0]);
  //                });
  //            }
  //
  //            // Validate IssueSequenceForm
  //            var issueSequenceFormValid = $('#IssueSequenceForm').valid();
  //            var issueSequenceFormErrors = [];
  //            if (!issueSequenceFormValid) {
  //                $('#IssueSequenceForm .error').each(function() {
  //                    var fieldName = $(this).prev('label').text().replace('*', '').trim();
  //                    fieldName = fieldName.split(':')
  //                    var errorMessage = $(this).text();
  //                    issueSequenceFormErrors.push(fieldName[0]);
  //                });
  //            }
  //
  //            // Combine error messages from both forms
  //            var errorMessages = searchFormErrors.concat(issueSequenceFormErrors);
  //            var errorMessageText = errorMessages.join('<br>');
  //
  //            // Display error message if any field is missing in either form
  //            if (errorMessages.length > 0) {
  //                Swal.fire({
  //                    icon: 'error',
  //                    title: 'Required fields are missing',
  //                    html: errorMessageText
  //                });
  //            } else {
  //                // Proceed with AJAX call to update the forms
  //                var formData = $('#searchForm').serialize();
  //                $.ajax({
  //                    url: "/insert_kb",
  //                    type: "post",
  //                    data: formData,
  //                    success: function(data) {
  //                        if (data.message) {
  //                            if (data.redirect_url) {
  //                                $('#exampleModal').modal('show');
  //                                $('#modalMessage').html(data.message);
  //                                $('#update_kb').hide();
  //                                $('#searchForm :input').prop('readonly', true);
  //                                $('#searchForm textarea').prop('readonly', true);
  //                                $('#redirectModalButton').on('click', function() {
  //                                    window.location.href = data.redirect_url;
  //                                });
  //                            } else {
  //                                $('#update_ret').html(data.message).removeClass('text-danger').addClass('text-success');
  //                            }
  //                        } else {
  //                            $('#update_ret').html(data.error).removeClass('text-success').addClass('text-danger');
  //                        }
  //                    },
  //                });
  //            }
  //        });

  $("#update_kb").on("click", function () {
    var formData = $("#searchForm").serialize();
    var errorMessages = [];

    if (!$("#searchForm").valid()) {
      $("#searchForm .error").each(function () {
        var fieldName1 = $(this).prev("label").text();
        var fieldName2 = $(this).prev("label").text().replace("*", "");
        var fieldName3 = $(this).prev("label").text().replace("*", "").trim();
        //   fieldName = fieldName.split(':')
        console.log("fieldName1", fieldName1);
        console.log("fieldName2", fieldName2);
        console.log("fieldName3", fieldName3);
        // debugger
        fieldName = $(this).text();
        console.log("field_name", fieldName);
        var errorMessage = $(this).text();
        errorMessages.push(fieldName);
        // errorMessages.push(fieldName[0]);
        console.log("errorMessages", errorMessages);
      });
      var errorMessageText = errorMessages.join("<br>");
      console.log("errorMessageText", errorMessageText);
      Swal.fire({
        icon: "error",
        title: "Required fields are missing",
        html: errorMessageText,
      });
    } else {
      $.ajax({
        url: "/insert_kb",
        type: "post",
        data: formData,
        success: function (data) {
          if (data.message) {
            if (data.redirect_url) {
              $("#exampleModal").modal("show");
              $("#modalMessage").html(data.message);
              $("#update_kb").hide();
              $("#searchForm :input").prop("readonly", true);
              $("#searchForm textarea").prop("readonly", true);
              $("#redirectModalButton").on("click", function () {
                window.location.href = data.redirect_url;
              });
            } else {
              $("#issue_id").val(data.issue_id);
              $("#sw_val").val(data.sw_val);
              $("#status_val").val(data.status_val);
              //  $('#nav-profile-tab').tab('show');

              $("#nav-profile-tab").attr("href", "#nav-profile");
              //   $('#nav-profile-tab').attr("data-action-steps", data.steps)
              $("#nav-profile-tab").removeAttr("disabled");
              $("#nav-profile-tab").attr("aria-disabled", "false");
              $("#nav-profile-tab").tab("show");
              $("#nav-profile-tab").addClass("active");
              $("#nav-profile").addClass("show active");
              console.log("message With No Redirect URL");
            }
          } else {
            $("#issue_id").val(data.issue_id);
            $("#sw_val").val(data.sw_val);
            $("#status_val").val(data.status_val);
            //    $('#nav-profile-tab').tab('show');

            $("#nav-profile-tab").attr("href", "#nav-profile");
            //    $('#nav-profile-tab').attr("data-action-steps", data.steps)
            $("#nav-profile-tab").removeAttr("disabled");
            $("#nav-profile-tab").attr("aria-disabled", "false");
            $("#nav-profile-tab").tab("show");
            $("#nav-profile-tab").addClass("active");
            $("#nav-profile").addClass("show active");
          }
        },
        error: function (jqXHR) {
          const message =
            jqXHR.responseJSON && jqXHR.responseJSON.message
              ? jqXHR.responseJSON.message
              : "Something went wrong.";
          Swal.fire({
            icon: "error",
            title: "Error",
            html: message, 
          });
        },
      });
    }
  });
  // updateProgressBar(formStepsNum);
});
