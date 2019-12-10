//= require chartkick
//= require Chart.bundle

document.addEventListener("DOMContentLoaded", function (event) {

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
    } else if (singleCalendars.length > 0) {
        console.log(singleCalendars)
        singleCalendars.config.onChange.push(function (selectedDates, dateStr, instance) {
            if (selectedDates.length == 2) {
                const graph = document.getElementById("graph-select").value;
                updateGraphRequest(selectedDates, dateStr, graph)
            }
        });
    }

    $('#newsletterTable').DataTable({
        responsive: true,
        dom: 'B<"clear">lfrtip',
        "columns": [
            null,
            null
        ]
    });
});

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
};

function changeIndexGraph() {
    const graph = document.getElementById("graph-select").value;
    const date = document.querySelector(".single-calendar")._flatpickr.selectedDates;
    updateGraphRequest(date, null, graph);
}

function showModal(id) {
    $.ajax({
        url: '/newsletters/'+id,
        type:'get',
        contentType: 'application/json',
        success: function (result) {
            const modal = document.querySelector('.modal');  // assuming you have only 1
            const html = document.querySelector('html');
            
            modal.classList.add('is-active');
            html.classList.add('is-clipped');

            modal.querySelector('.modal-background').addEventListener('click', function(e) {
                e.preventDefault();
                closemodal();
            });

            modal.querySelector('.delete').addEventListener('click', function(e) {
                e.preventDefault();
                closemodal();
            });

            const title = document.querySelector('.modal-card-title')
            const content = document.querySelector('.modal-card-body')
            title.innerHTML = result.title;
            content.innerHTML = result.content;
        }
    });
}

function closemodal() {
    document.querySelector('.modal').classList.remove('is-active');
    document.querySelector('html').classList.remove('is-clipped');
}

$(document).on('click', '.notification > button.delete', function() {
    $(this).parent().addClass('is-hidden');
    return false;
});




