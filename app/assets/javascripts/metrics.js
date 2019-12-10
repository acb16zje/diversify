//= require chartkick
//= require Chart.bundle

document.addEventListener("DOMContentLoaded", function (event) {

    // initalise timepicker
    const singleCalendars = flatpickr(".single-calendar", {
        mode: "range",
        dateFormat: "d.m.Y",
        maxDate: "today"
    });

    if (singleCalendars.length > 0 && Array.isArray(singleCalendars)) {
        for (var i = 0; i < singleCalendars.length + 1; i++) {
            singleCalendars[i].config.onChange.push(function (selectedDates, dateStr, instance) {
                const graph = document.getElementById("graph-select").value;
                updateGraphRequest(graph, selectedDates, dateStr, graph)
            });
        }
    }

    //initialise datatable
    $('#newsletterTable').DataTable({
        responsive: true,
        dom: 'B<"clear">lfrtip',
        language: {
            searchPlaceholder: "Search",
            search: "",
        },
        "columns": [
            null,
            null
        ]
    });
});

/**
 * AJAX function to update graph
 * Send the selected date and graph and return with partial html
 */
function updateGraphRequest(selectedDates, dateStr, graph) {
    $.ajax({
        url: '/update_graph_time',
        dataType: 'json',
        type: 'post',
        contentType: 'application/json',
        data: JSON.stringify({"time": selectedDates, "graph_name": graph}),
        success: function (result) {
            $(result.title).html(result.html);
        },
        error: function (xhr, status, error) {
            $("#graph-div").html("<p>No Data</p>");
        }
    });
}

/**
 * Function to update graph
 */
function changeIndexGraph() {
    const graph = document.getElementById("graph-select").value;
    const date = document.querySelector(".single-calendar")._flatpickr.selectedDates;
    updateGraphRequest(date, null, graph);
}






