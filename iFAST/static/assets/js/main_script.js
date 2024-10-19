var selectedRows = [];

function switch_tab(){
   $('#nav-exec-tab').tab('show');
}

function selecttoselect2(){

}

function isHTML(str) {
    const doc = new DOMParser().parseFromString(str, 'text/html');
    return Array.from(doc.body.childNodes).some(node => node.nodeType === 1); // Check for elements
}

function toggle(source) {
   let checkboxes = document.querySelectorAll('input[type="checkbox"]');
   for (let i = 0; i < checkboxes.length; i++) {
      if (checkboxes[i] != source)
         checkboxes[i].checked = source.checked;
   }
}

$(document).ready(function() {
   selecttoselect2();
   var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
   var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
      return new bootstrap.Tooltip(tooltipTriggerEl)
   });
   $('#iconCard2').on('click', function() {
        $('#iconCard2').addClass('d-none');
        $('#iconCard2Minus').removeClass('d-none');
    });

    $('#iconCard2Minus').on('click', function() {
        $('#iconCard2Minus').addClass('d-none');
        $('#iconCard2').removeClass('d-none');
    });

    // Handle the toggle on collapse/expand via Bootstrap events
    $('#collapseCard2').on('show.bs.collapse', function() {
        $('#iconCard2').addClass('d-none');
        $('#iconCard2Minus').removeClass('d-none');
    }).on('hide.bs.collapse', function() {
        $('#iconCard2Minus').addClass('d-none');
        $('#iconCard2').removeClass('d-none');
    });
   $('#issueTable .result_checkbox:checked').each(function() {
      var row = $(this).closest('tr');

      var rowData = {
         'session_id': row.find('td').eq(0).text(), // Assuming session_id is in the first <td>
         'issue': row.find('td').eq(1).text(),
         'sw': row.find('td').eq(2).text(),
         'status': row.find('td').eq(3).text(),
         'area': row.find('td').eq(4).text(),
         'technology': row.find('td').eq(5).text(),
         'visibility': row.find('td').eq(6).text(),
         'major_kpi_degradation': row.find('td').eq(7).text(),
         'issue_category': row.find('td').eq(8).text(),
         'description': row.find('td').eq(9).text(),
         'sites': $('#regex').val()
      };

      // Update the cell for the selected row
      row.find('td.exec_class').html('<a href="#" onclick="switch_tab()"> <u>In-progress</u><img src="/assets/img/preloader.gif" height="10px" width="20px"></a>');
      row.find('td.exec_class').css('background-color', 'orange');
      row.find('td.exec_class').show();

      selectedRows.push(rowData);
   });

   $.ajax({
         url: '/execute-multi',
         method: 'POST',
         contentType: 'application/json',
         data: JSON.stringify({ issues: selectedRows }),
         success: function(response) {

            $('#execTable tbody').empty();
            $.each(response.results, function(index, record) {
               var rowHtml = `
                  <tr class="${index % 2 === 0 ? 'even' : 'odd'}">
                     <td>${record.session_id}</td>
                     <td>${record.user_name}</td>
                     <td>${record.issue}</td>
                     <td>${record.issue_category}</td>
                     <td style="background-color: orange;">In-progress<img src="/assets/img/preloader.gif" height="10px" width="20px"></td>
                     <td style="width:10%">${record.curr_action_no}</td>
                     <td>${record.timestamp_start}</td>
                     <td>${record.timestamp_end}</td>
                     <td class="result-column" style="width:10%">
                        <a href="#" class="log-link-matches" title="Matches log">
                           <i class="fa fa-file-text"></i>
                        </a>
                        <span id="matches"></span>
                     </td>
                     <td class="result-column" style="width:10%">
                        <a href="#" class="log-link-live" title="Live Log">
                           <i class="fa fa-file" style="color:#95A5A6 ;"></i>
                        </a> &nbsp; &nbsp; &nbsp;
                        <a href="#" class="log-link" title="Summary">
                           <i class="fa fa-file-text-o" style="color:#95A5A6 ;"></i>
                        </a>
                     </td>
                  </tr>
               `;
               $('#execTable tbody').append(rowHtml);
            });
         },
         error: function(xhr, status, error) {
            console.error('Error:', error);
         }
   });

    $('#issueTable').DataTable({
        searching: true,
        ordering: false,

    "columnDefs": [
         { "targets": "_all", "width": "auto" } ],
        autoWidth: false,
    });
    var table = $('#issueTable2').DataTable({
        dom: '<"d-flex justify-content-between"f<"ml-2"l>>tip',
        language: {
            emptyTable: "No Issues Found"
        }
    });
    $('.dropdown').hover(function() {
        $(this).find('.dropdown-menu').show();
    }, function() {
        $(this).find('.dropdown-menu').hide();
    });
   $('#issueTable2_filter').append('&nbsp;&nbsp;<a href="#" id="searchLink" class="btn btn-primary btn-sm">GO</a>');
    $('#issueTable2_filter').append('&nbsp;<a href="#" id="advanceSearchLink" class="btn btn-link ml-2" data-bs-toggle="modal" data-bs-target="#advanceSearchModal"><u>Advanced Search</u></a>');

    $('#searchLink').on('click', function(e) {
        e.preventDefault();
        performSearch();
    });
    $('#advanceSearchButton').on('click', function(e) {
        alert();
        e.preventDefault();
        performSearch();
        $('#advanceSearchModal').modal('hide');
    });
    $('select').select2({
        dropdownParent: $('#advanceSearchModal') // Ensure dropdown is attached to modal
    });

    $('#saveissue').hide();
    $('#editissue').click(function() {
        $('input[type="text"], textarea').removeAttr('readonly');
        $('#editissue').hide();
        $('#saveissue').show();
    });

    $('#execute_selected').click(function(event) {
      $('#issueTable .result_checkbox:checked').each(function() {
         var row = $(this).closest('tr');

         var execCell = row.find('td.exec_class');
         execCell.html('<a href="#" onclick="switch_tab()"> <u>In-progress</u><img src="/static/assets/img/preloader.gif" height="10px" width="20px"></a>'); // Update the text
         execCell.css('background-color', 'orange'); // Update the background color
         execCell.show(); // Make sure it is visible

      });
   });

    function performSearch() {
        var searchText = $('#issueTable2_filter input[type="search"]').val();
        var advancedSearch = false;
        var select_SW = $('#select_SW').val();
        var select_Tech = $('#select_Tech').val();
        var select_kpi = $('#select_kpi').val();
        var select_Area = $('#select_Area').val();


        if (select_SW !== "nothing_sw" || select_Tech !== "nothing_tech" || select_kpi !== "nothing_kpi" || select_Area !== "nothing_area") {
            advancedSearch = true;
        }

        var data = {
            searchValue: searchText,
            select_SW: select_SW,
            select_Tech: select_Tech,
            select_kpi: select_kpi,
            select_Area: select_Area
        };

        $.ajax({
            url: '/fetch_issues',
            type: 'POST',
           data: data,
            success: function(data) {
                table.clear();
                data.forEach(function(record) {
                    table.row.add([
                        record.issue,
                        record.SW,
                        record.Status,
                        record.Area,
                        record.Technology,
                        record.Visibility,
                        record.Major_KPI_Degradation,
                        record.Issue_Category,
                        record.Description,
                        record.Impact,
                        `<a href="/act_srch/${record.issue}">&#x1F441;</a>`
                    ]).draw();
                });
            },
            error: function(xhr, status, error) {
                console.error('Error fetching data:', error);
            }
        });
    }
});
