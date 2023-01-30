// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require Chart.min
//= require rails-ujs
//= require turbolinks
//= require_tree .



// // とある4週間分のデータログ
// var barChartData = {
//     labels: ['8/26','8/27','8/28','8/29','8/30','8/31','9/1',
//         '9/2','9/3','9/4','9/5','9/6','9/7','9/8',
//         '9/9','9/10','9/11','9/12','9/13','9/14',
//         '9/15','9/16','9/17','9/18','9/19','9/20','9/21','9/22'
//     ],
//     datasets: [
//     {
//         label: 'sample-line',
//         data: ['0.155','0.118','0.121','0.068','0.083','0.060','0.067',
//             '0.121','0.121','0.150','0.118','0.097','0.078','0.127',
//             '0.155','0.140','0.101','0.140','0.041','0.093','0.189',
//             '0.146','0.134','0.127','0.116','0.111','0.125','0.116'
//         ],
//         borderColor : "rgba(254,97,132,0.8)",
//         backgroundColor : "rgba(254,97,132,0.5)",
//     },
//     {
//         label: 'sample-bar',
//         data: ['0.3','0.1','0.1','0.3','0.4','0.2','0.0',
//             '0.2','0.3','0.11','0.5','0.2','0.5','0.4',
//             '0.0','0.3','0.7','0.3','0.6','0.4','0.9',
//             '0.7','0.4','0.8','0.7','0.4','0.7','0.8'
//         ],
//         borderColor : "rgba(54,164,235,0.8)",
//         backgroundColor : "rgba(54,164,235,0.5)",
//     },
//     ],
// };

// var complexChartOption = {
//     responsive: true,
// };

// window.onload = function() {
//     ctx = document.getElementById("canvas").getContext("2d");
//     window.myBar = new Chart(ctx, {
//         type: 'bar', // ここは bar にする必要があります
//         data: barChartData,
//         options: complexChartOption
//     });
// };