function showErrorModal(errorMessage) {
    $('#errmsg').text(errorMessage);
    $('#errorModal').modal('show');
}

function scrollToBottom() {
    $('html, body').animate({ scrollTop: $(document).height() }, 'slow');
}

function showPreloader() {
    $('#preloader').fadeIn();
}

function hidePreloader() {
    $('#preloader').fadeOut();
}

function fetch_steps(currentStep, issue) {
    $.ajax({
        url: '/fetch_step_data',
        method: 'POST',
        data: { step: currentStep, issue: issue },
        success: function(response) {
            const fields = ['SW', 'Status', 'action_type', 'script_name', 'server_Login', 'server_password', 'Server_IP', 'Script_location', 'Script_owner', 'script_path', 'Issue_Category', 'file_name', 'args', 'counter_info', 'check_condition'];
            fields.forEach(field => {
                $('#' + field).val(response[field] || '');
            });
            if (response.check_condition && response.action_type) {
                addOrUpdateRow(currentStep, response.check_condition, response.action_type,'add');
            }
        },
        error: function(xhr, status, error) {
            console.error('Error fetching step data:', error);
        }
    });
}

function updateStatus(sequence, status, color, message, row, condition, action_type) {
    if (!row) {
        console.error(`Row for sequence ${sequence} not found.`);
        return;
    }

    const statusColumn = row.find('.status-column');
    statusColumn.css('background-color', color).text(status);
    if (status === 'In Progress') {
        statusColumn.append('<img src="/static/assets/img/preloader.gif" height="20px" width="30px">');
    }
    row.find('.check_condition').html(condition);
    row.find('.action_type').text(typeof action_type === 'object' ? JSON.stringify(action_type) : action_type);

    const resultColumn = row.find('.result-column');
    resultColumn.empty();
    if (status === 'Completed') {
        resultColumn.html(`<a href="#" class="log-link"><i class="fas fa-file fa-lg"></i> &nbsp;<span class="success-span" style="color: green"><i class="fa-solid fa-check fa-lg" data-toggle="tooltip" title="Success"></i></span></a>`);
    } else if (status === 'Error' || status === 'No matches Found') {
        resultColumn.html(`<a href="#" class="log-link"><i class="fas fa-file fa-lg"></i> &nbsp;<span class="error-span" style="color: red"><i class="fa-solid fa-xmark fa-lg" data-toggle="tooltip" title="${status === 'Error' ? 'Failure' : 'No Matches'}"></i></span></a>`);
    }
}

function addOrUpdateRow(sequence, condition, action_type, flag=null) {
    let stat, clr;
    if (flag){
        stat = 'In Progress <img src="/static/assets/img/preloader.gif" height="20px" width="30px">';
        clr = 'orange';
    } else {
        stat = 'Pending';
        clr = 'grey';
    }
    const rowHtml = `
        <tr data-sequence="${sequence}">
            <td style="width:10%">${sequence}</td>
            <td style="width:10%" class="action_type">${action_type}</td>
            <td style="width:50%" class="check_condition">${condition}</td>
            <td class="status-column" style="background-color: ${clr};width:10%">${stat}</td>
            <td class="result-column" style="width:10%">
                <a href="#" class="log-link"><i class="fas fa-file fa-lg"></i></a>
                <span style="color:green;display:none" class="success-span"><i class="fa-solid fa-check fa-lg" data-toggle="tooltip" title="Success"></i></span>
                <span style="color:red;display:none" class="error-span"><i class="fa-solid fa-xmark fa-lg" data-toggle="tooltip" title="Error"></i></span>
            </td>
        </tr>`;

    const existingRow = $(`tr[data-sequence="${sequence}"]`);
    if (existingRow.length === 0) {
        $('#status-table-body').append(rowHtml);
    } else {
        existingRow.find('.check_condition').text(condition);
        existingRow.find('.action_type').html(action_type);
        existingRow.find('.status-column').css('background-color', 'orange').html('In Progress <img src="/static/assets/img/preloader.gif" height="20px" width="30px">');
        existingRow.find('.result-column').html('<a href="#" class="log-link"><i class="fas fa-file fa-lg"></i></a>');
        existingRow.find('.success-span, .error-span').hide();
    }
}

function updateProgressBar_forall(sequence) {
    $('.progressbar .step').removeClass('active');
    $(`.progressbar .step:nth-child(${sequence})`).addClass('active');
}

$(document).ready(function() {
    $('#send_email, #reload').hide();
    $('.success-span, .error-span').hide();
    const socket = io();
    let initialLoad = true;
    let currentSequence = parseInt($('#sequence_id').val(), 10);
    const issue = $('#issue_id').val();

    addOrUpdateRow(1, $('#check_condition').val(), $('#action_type').val());

    socket.on('progress_update', function(progressUpdate) {
        scrollToBottom();
        const { sequence_num: sequenceNum, status, color, message, condition, action } = progressUpdate;
        const nextSequence = sequenceNum + 1;
        const maxSequence = 4;
        const row = $(`tr[data-sequence="${sequenceNum}"]`);

        $('#sequence_id').val(nextSequence);
        if (status !== "Error" || status !== "No matches Found"){

        }
        if (row.length > 0) {
            if (status === 'Error') {
                updateStatus(sequenceNum, status, 'Red', message, row, condition, action);

            } else if (status === 'Completed' && nextSequence  <= maxSequence ) {

                    fetch_steps(nextSequence, issue);
                    updateStatus(sequenceNum, status, '#C6EFCE', message, row, condition, action);
                    updateProgressBar_forall(nextSequence);

            } else if (status === 'No matches Found') {
                updateStatus(sequenceNum, status, '#FFC7CE', message, row, condition, action);
            }
            row.find('.log-link').data({ message, condition });
        } else if (nextSequence <= maxSequence) {
            const newRow = $(`tr[data-sequence="${sequenceNum}"]`);
            updateStatus(nextSequence, status, color, message, newRow, condition, action);
            newRow.find('.log-link').data('message', message);
        }
    });

    function isHTML(str) {
        return /<[a-z][\s\S]*>/i.test(str);
    }

    $(document).on('click', '.log-link', function(e) {
        e.preventDefault();
        const $link = $(this);
        const message = $link.data('message');
        const $row = $link.closest('tr');
        const issueSequence = $row.find('td').eq(0).text();
        const action_type = $row.find('td').eq(1).text();
        const sequenceCondition = $row.find('td').eq(2).text();
        const executionStatus = $row.find('td').eq(3).text().trim();
        const logContent = `Issue Action ID: ${issueSequence}\n\nAction Type: ${action_type}\n\nAction Condition: ${sequenceCondition}\n\nExecution Status: ${executionStatus}\n\n${message}`;
        const $logContent = $('#logContent');

        if (isHTML(message)) {
            $logContent.html(logContent);
        } else {
            $logContent.text(logContent);
        }

        const offset = $link.offset();
        const $modal = $('#customModal');
        $modal.css({ top: (offset.top - $modal.outerHeight()) + 'px', left: offset.left + 'px', display: 'block' });
    });

    $('#execute_all').on('click', function(event) {
        var messageToSend;
        let issueId = $('#issue_id').val();
        var email_to = $('#email').val();
        $('#execute_all').prop('disabled', true);
        showPreloader();
        if (initialLoad) {
            addOrUpdateRow(1, $('#check_condition').val(), $('#action_type').val());
            initialLoad = false;
        }

        $('#status-table-body tr').each(function() {
            updateStatus($(this).data('sequence'), 'In Progress', 'orange', null, $(this), $('#check_condition').val(), $('#action_type').val());
        });

        $.ajax({
            url: "/execute_all",
            type: "POST",
            data: $('#saveaction').serialize(),
            success: function(progressUpdates) {

                if (progressUpdates.all_tasks_completed) {
                var updates = progressUpdates.progress_updates;
                for (var key in updates) {
                    if (updates.hasOwnProperty(key)) {
                        if (typeof updates[key] === 'object') {
                            console.log(key + ":");
                            for (var nestedKey in updates[key]) {
                                if (updates[key].hasOwnProperty(nestedKey)) {
                                    console.log("  " + nestedKey + ": " + updates[key][nestedKey]);
                                    if (nestedKey === 'message') {
                                        messageToSend = updates[key][nestedKey];
                                    }
                                }
                            }
                        } else {
                            console.log(key + ": " + updates[key]);
                        }
                    }
                }
                    socket.disconnect();
                    $('#flashModal').modal('show');
                    $('#sucmsg').html("Execution Completed!!");
                    hidePreloader();
                    $('#execute_all, #execute_btn').hide();
                    $('#reload').show();
                    $("#status-table-body tr").each(function() {
                        if ($(this).find("td:contains('Pending')").length > 0) {
                            $(this).remove();
                        }
                    });

                    $.ajax({
                        url: "/send_exe_email",
                        type: "POST",
                        data: { issueId: issueId, email_to:email_to },
                        success: function(response) {
                            console.log("");
                        },
                        error: function(xhr, status, error) {
                            console.error("An error occurred while sending the email.");
                        }
                    });
                }
            },
            error: function(xhr, status, error) {
                hidePreloader();
                showErrorModal("An error occurred while executing tasks.");
                updateStatus(1, 'Error', '#FFC7CE', "Socket Issue. Script either failed or not connectable", $(`tr[data-sequence="1"]`), $('#check_condition').val(), $('#action_type').val());
            }
        });
    });

    $('#reload').on('click', function() {
        location.reload();
    });

    $('#closeModalBtn').on('click', function() {
        $('#customModal').css('display', 'none');
    });
});
