//= require chartkick
//= require Chart.bundle

document.addEventListener("DOMContentLoaded", function (event) {
    changeIndexGraph();
});

function changeIndexGraph() {
    const value = document.getElementById("index-graph-select").value;
    const pie = document.getElementById("index-pie-graph");
    const line = document.getElementById("index-line-graph");
    if (pie != null && line != null) {
        console.log("trigger")
        if (value == "Subscription Ratio") {
            pie.style.display = "block";
            line.style.display = "none";
        } else if (value == "Subscriptions by Date") {
            line.style.display = "block";
            pie.style.display = "none";
        }
    }
}