<html>  
<head>  
    <meta charset="utf-8">  
    <title>D3--bar</title>  
    <style>  
        .axis path,  
        .axis line {  
            fill: none;  
            stroke: black;  
            -webkit-shape-rendering: crispEdges;  
            -moz-shape-rendering: crispEdges;  
            -ms-shape-rendering: crispEdges;  
            -o-shape-rendering: crispEdges;  
            shape-rendering: crispEdges;  
        }  
  
        .referline{  
            stroke-width: 0.5px;  
            stroke: black;  
        }  
  
        .axis text {  
            font-family: sans-serif;  
            font-size: 12px;  
            fill: #000000 !important;  
        }  
    </style>  
</head>  
  
<body>  
<script src="js/d3.js" charset="utf-8"></script>  
<script type="text/javascript" src="js/jquery-2.1.4.min.js"></script>  
<center style="font-size:35px; color:red">2015年三次产业就业人数</center>  
<script>  
    var padding = { top: 30, right: 30, bottom: 30, left: 400 };  
    var h = 450 + padding.top + padding.bottom;  
    var w = 600 + padding.left + padding.right;  
  
  
    var info = {"opt": "bar"};  
    var ds = [];  
    $.post("./GetBarData", info, function(data){  
        ds.length=0;  
        for(var i=0; i < data.length; i++){  
            ds.push({"value":Math.round(data[i].value), "name": data[i].name });  
        }  
        var enter = d3.selectAll("svg").data(ds).enter().append("svg").attr({  
            width: w,  
            height: h  
        });  
  
        var svg = d3.select("svg");  
  
        var xd = ds.map(function (d) {  
            return d.name;  
        });  
  
        var yd = ds.map(function (d) {  
            return d.value;  
        });  
  
        var x = d3.scale.ordinal().domain(xd).rangeBands([padding.left, w - padding.right], 0.5);  
        var y = d3.scale.linear().domain([0, d3.max(yd, function (d) { return d; })])  
                .range([h - padding.bottom, padding.top]);  
  
        var xAxis = d3.svg.axis().scale(x).orient("bottom");  
        var yAxis = d3.svg.axis().scale(y).orient("left");  
        var band = x.rangeBand();  
        var ranges = x.range();  
  
        var rects = svg.selectAll("rect").data(yd);  
        rects.enter().append("rect").attr("x", function (d, i) {  
            return ranges[i];  
        }).attr("y", function (d) {  
            return y(d);  
        }).attr("width", 0).attr("height", function (d) {  
            return h - y(d) - padding.bottom;  
        }).attr("fill", "red");  
        rects.transition().duration(500).attr("x", function (d, i) {  
            return ranges[i];  
        }).attr("y", function (d) {  
            return y(d);  
        }).attr("width", band).attr("height", function (d) {  
            return h - y(d) - padding.bottom;  
        }).attr("fill", "red").style("opacity", 0.75);  
        rects.exit().transition()  
                .duration(500)  
                .style('opacity', 0)  
                .remove();  
  
        enter.append("line").attr({  
            "x1": padding.left,  
            "y1": padding.top,  
            "x2": padding.left,  
            "y2": h - padding.bottom  
        }).classed("referline", true);  
  
        enter.append("line").attr({  
            "x1": padding.left,  
            "y1": h - padding.bottom,  
            "x2": w - padding.right,  
            "y2": h - padding.bottom  
        }).classed("referline", true);  
  
        enter.append("g").attr("class", "x axis")  
                .attr("transform", "translate(0," + (h - padding.bottom) + ")");  
        enter.append("g").attr("class", "y axis")  
                .attr("transform", "translate(" + padding.left + ",0)")  
                .append("text")  
                .attr("transform", "rotate(-90)")  
                .attr("y", 16)  
                .attr("dy", ".71em")  
                .style("text-anchor", "end")  
                .text("number (万)");  
        svg.select('.x.axis').transition().duration(500).call(xAxis);  
        svg.select('.y.axis').transition().duration(500).call(yAxis);  
  
  
        window.onload = function () {  
        }  
    }, 'json');  
</script>  
</body>  
</html>
