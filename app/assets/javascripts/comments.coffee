# window.onload = function() {
# window.onload = () ->{
#     barChartData = {
#         labels: ['8/26','8/27','8/28','8/29','8/30','8/31','9/1',
#             '9/2','9/3','9/4','9/5','9/6','9/7','9/8',
#             '9/9','9/10','9/11','9/12','9/13','9/14',
#             '9/15','9/16','9/17','9/18','9/19','9/20','9/21','9/22'
#         ],
#         datasets: [
#         {
#             label: 'sample-line',
#             data: ['0.155','0.118','0.121','0.068','0.083','0.060','0.067',
#                 '0.121','0.121','0.150','0.118','0.097','0.078','0.127',
#                 '0.155','0.140','0.101','0.140','0.041','0.093','0.189',
#                 '0.146','0.134','0.127','0.116','0.111','0.125','0.116'
#             ],
#             borderColor : "rgba(254,97,132,0.8)",
#             backgroundColor : "rgba(254,97,132,0.5)",
#         },
#         {
#             label: 'sample-bar',
#             data: ['0.3','0.1','0.1','0.3','0.4','0.2','0.0',
#                 '0.2','0.3','0.11','0.5','0.2','0.5','0.4',
#                 '0.0','0.3','0.7','0.3','0.6','0.4','0.9',
#                 '0.7','0.4','0.8','0.7','0.4','0.7','0.8'
#             ],
#             borderColor : "rgba(54,164,235,0.8)",
#             backgroundColor : "rgba(54,164,235,0.5)",
#         },
#         ],
#     };

#     complexChartOption = {
#         responsive: true,
#     };

#     ctx = document.getElementById("canvas").getContext("2d");
#     window.myBar = new Chart(ctx, {
#         type: 'bar',
#         # // ここは bar にする必要があります
#         data: barChartData,
#         options: complexChartOption
#     });
# };






# // とある4週間分のデータログ
# var barChartData = {
#     labels: ['8/26','8/27','8/28','8/29','8/30','8/31','9/1',
#         '9/2','9/3','9/4','9/5','9/6','9/7','9/8',
#         '9/9','9/10','9/11','9/12','9/13','9/14',
#         '9/15','9/16','9/17','9/18','9/19','9/20','9/21','9/22'
#     ],
#     datasets: [
#     {
#         label: 'sample-line',
#         data: ['0.155','0.118','0.121','0.068','0.083','0.060','0.067',
#             '0.121','0.121','0.150','0.118','0.097','0.078','0.127',
#             '0.155','0.140','0.101','0.140','0.041','0.093','0.189',
#             '0.146','0.134','0.127','0.116','0.111','0.125','0.116'
#         ],
#         borderColor : "rgba(254,97,132,0.8)",
#         backgroundColor : "rgba(254,97,132,0.5)",
#     },
#     {
#         label: 'sample-bar',
#         data: ['0.3','0.1','0.1','0.3','0.4','0.2','0.0',
#             '0.2','0.3','0.11','0.5','0.2','0.5','0.4',
#             '0.0','0.3','0.7','0.3','0.6','0.4','0.9',
#             '0.7','0.4','0.8','0.7','0.4','0.7','0.8'
#         ],
#         borderColor : "rgba(54,164,235,0.8)",
#         backgroundColor : "rgba(54,164,235,0.5)",
#     },
#     ],
# };



# var complexChartOption = {
#     responsive: true,
# };



# window.onload = function() {
#     ctx = document.getElementById("canvas").getContext("2d");
#     window.myBar = new Chart(ctx, {
#         type: 'bar', // ここは bar にする必要があります
#         data: barChartData,
#         options: complexChartOption
#     });
# };























# 動く元のデータ
# window.draw_graph = -> 
#     ctx = document.getElementById("myChart").getContext('2d')
#     myChart = new Chart(ctx, {
#         # type: 'bar',
#         type: 'line',
#         data: {
#             labels: ["Red", "Blue", "Yellow", "Green", "Purple", "Orange"],
#             datasets: [{
#                 label: '# of Votes',
#                 data: [12, 19, 3, 5, 2, 3],
#                 backgroundColor: [
#                     'rgba(255, 99, 132, 0.2)',
#                     'rgba(54, 162, 235, 0.2)',
#                     'rgba(255, 206, 86, 0.2)',
#                     'rgba(75, 192, 192, 0.2)',
#                     'rgba(153, 102, 255, 0.2)',
#                     'rgba(255, 159, 64, 0.2)'
#                 ],
#                 borderColor: [
#                     'rgba(255,99,132,1)',
#                     'rgba(54, 162, 235, 1)',
#                     'rgba(255, 206, 86, 1)',
#                     'rgba(75, 192, 192, 1)',
#                     'rgba(153, 102, 255, 1)',
#                     'rgba(255, 159, 64, 1)'
#                 ]
#                 borderWidth: 1
#             }],

#         },
#         options: {
#             scales: {
#                 yAxes: [{
#                     ticks: {
#                         beginAtZero:true
#                     }
#                 }]
#             }
#         }
#     })

