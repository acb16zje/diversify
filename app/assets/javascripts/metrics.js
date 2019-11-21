//= require chartkick
//= require Chart.bundle

document.addEventListener("DOMContentLoaded", function (event) {
    changeIndexGraph();

    const singleCalendars = flatpickr(".single-calendar", {
        mode: "range",
        dateFormat: "d.m.Y",
        maxDate: "today"
    });
    if (Array.isArray(singleCalendars)) {
        for (var i = 0; i < singleCalendars.length + 1; i++) {
            singleCalendars[i].config.onChange.push(function (selectedDates, dateStr, instance) {
                updateGraphRequest(selectedDates, dateStr, instance)
            });
        }
    } else {
        singleCalendars.config.onChange.push(function (selectedDates, dateStr, instance) {
            updateGraphRequest(selectedDates, dateStr, instance)
        });
    }


});

function updateGraphRequest(selectedDates, dateStr, instance) {
    if (selectedDates.length === 2) {
        $.ajax({
            url: '/update_graph_time',
            dataType: 'json',
            type: 'post',
            contentType: 'application/json',
            data: JSON.stringify({"time": selectedDates, "graph_name": instance.element.id}),
            success: function (results) {

                results.forEach(result => {
                    if (result.html != undefined) {
                        $(result.title).html(result.html);
                    }
                });
            },
            error: function (xhr, status, error) {
                $("#index-line-div").html("<p>No Data</p>");
                $("#index-pie-div").html("<p>No Data</p>");
            }
        });
    }
};

function changeIndexGraph() {
    const value = document.getElementById("index-graph-select").value;
    const pie = document.getElementById("index-pie-div");
    const line = document.getElementById("index-line-div");
    if (pie != null && line != null) {
        if (value == "Subscription Ratio") {
            pie.style.display = "block";
            line.style.display = "none";
        } else if (value == "Subscriptions by Date") {
            line.style.display = "block";
            pie.style.display = "none";
        }
    }
}




