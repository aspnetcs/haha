<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<html>  
<head>  
    <meta charset="utf-8">  
    <title>D3--pie</title>  
</head>  
  
<style>  
    .tooltip {  
        position: absolute;  
        width: 120px;  
        height: auto;  
        font-family: simsun;  
        font-size: 14px;  
        text-align: center;  
        color: white;  
        border-width: 2px solid black;  
        background-color: black;  
        border-radius: 5px;  
    }  
  
    .tooltip:after {  
        content: '';  
        position: absolute;  
        bottom: 100%;  
        left: 20%;  
        margin-left: -8px;  
        width: 0;  
        height: 0;  
        border-bottom: 12px solid black;  
        border-right: 12px solid transparent;  
        border-left: 12px solid transparent;  
    }  
</style>  
  
<body>  
<script type="text/javascript" src="js/jquery-2.1.4.min.js"></script>  
<script type="text/javascript" src="js/d3.js"></script>  
<center style="font-size: 35px; color: red">2015年淘宝平台月饼品牌网络销售情况</center>  
<div style="text-align: center;">  
    <script>  
        var width = 600;  
        var height = 600;  
        var svg = d3.select("div").append("svg").attr("width", width)  
                .attr("height", height);  
  
        var dataset = [];  
        $.post("./GetPieData", function(data) {  
            for ( var i = 0; i < eval(data).length; i++) {  
                dataset.push([ eval(data)[i].name, eval(data)[i].value ]);  
            }  
            var pie = d3.layout.pie().value(function(d) {  
                return d[1];  
            });  
            var piedata = pie(dataset);  
  
            var outerRadius = width / 3;  
            var innerRadius = 0  
  
            var arc = d3.svg.arc().innerRadius(innerRadius).outerRadius(  
                    outerRadius);  
            var color = d3.scale.category20();  
            var arcs = svg.selectAll("g").data(piedata).enter().append("g")  
                    .attr(  
                    "transform",  
                    "translate(" + (width/2)+","+(height/2) + ")");  
            arcs.append("path").attr("fill", function(d, i) {  
                return color(i);  
            }).attr("d", function(d) {  
                return arc(d);  
            });  
            arcs.append("text").attr("transform", function(d) {  
                var x = arc.centroid(d)[0] * 1.4;  
                var y = arc.centroid(d)[1] * 1.4;  
                return "translate(" + x + "," + y + ")";  
            }).attr("text-anchor", "middle").text(  
                    function(d) {  
                        var percent = Number(d.value)  
                                / d3.sum(dataset, function(d) {  
                                    return d[1];  
                                }) * 100;  
                        return percent.toFixed(1) + "%";  
                    });  
            arcs.append("line").attr("stroke", "black").attr("x1",  
                    function(d) {  
                        return arc.centroid(d)[0] * 2;  
                    }).attr("y1", function(d) {  
                        return arc.centroid(d)[1] * 2;  
                    }).attr("x2", function(d) {  
                        return arc.centroid(d)[0] * 2.2;  
                    }).attr("y2", function(d) {  
                        return arc.centroid(d)[1] * 2.2;  
                    });  
  
            var fontsize = 14;  
            arcs.append("line").style("stroke", "black").each(function(d) {  
                d.textLine = {  
                    x1 : 0,  
                    y1 : 0,  
                    x2 : 0,  
                    y2 : 0  
                };  
            }).attr("x1", function(d) {  
                d.textLine.x1 = arc.centroid(d)[0] * 2.2;  
                return d.textLine.x1;  
            }).attr("y1", function(d) {  
                d.textLine.y1 = arc.centroid(d)[1] * 2.2;  
                return d.textLine.y1;  
            }).attr("x2", function(d) {  
                var strLen = getPixelLength(d.data[0], fontsize) * 1.5;  
                var bx = arc.centroid(d)[0] * 2.2;  
                d.textLine.x2 = bx >= 0 ? bx + strLen : bx - strLen;  
                return d.textLine.x2;  
            }).attr("y2", function(d) {  
                d.textLine.y2 = arc.centroid(d)[1] * 2.2;  
                return d.textLine.y2;  
            });  
  
            arcs.append("text").attr("transform", function(d) {  
                var x = 0;  
                var y = 0;  
                x = (d.textLine.x1 + d.textLine.x2) / 2;  
                y = d.textLine.y1;  
                y = y > 0 ? y + fontsize * 1.1 : y - fontsize * 0.4;  
                return "translate(" + x + "," + y + ")";  
            }).style("text-anchor", "middle").style("font-size", fontsize)  
                    .text(function(d) {  
                        return d.data[0];  
                    });  
  
            var tooltip = d3.select("body").append("div").attr("class",  
                    "tooltip").style("opacity", 0.0);  
  
            arcs.on(  
                    "mouseover",  
                    function(d, i) {  
                        tooltip.html(  
                                d.data[0] + "ÏúÊÛ¶î" + "<br>" + d.data[1]  
                                + "ÍòÔª").style("left",  
                                (d3.event.pageX) + "px").style("top",  
                                (d3.event.pageY + 20) + "px").style(  
                                "opacity", 1.0);  
                        tooltip.style("box-shadow", "10px 0px 0px"  
                                + color(i));  
                    })  
                    .on(  
                    "mousemove",  
                    function(d) {  
  
                        tooltip.style("left",  
                                (d3.event.pageX) + "px")  
                                .style(  
                                "top",  
                                (d3.event.pageY + 20)  
                                + "px");  
                    }).on("mouseout", function(d) {  
                        tooltip.style("opacity", 0.0);  
                    })  
  
            function getPixelLength(str, fontsize) {  
                var curLen = 0;  
                for ( var i = 0; i < str.length; i++) {  
                    var code = str.charCodeAt(i);  
                    var pixelLen = code > 255 ? fontsize : fontsize / 2;  
                    curLen += pixelLen;  
                }  
                return curLen;  
            }  
        })  
    </script>  
</div>  
<div>  
        <style="right: 120px; position: absolute; bottom: 20; color:red;font-size: 18px">BATBigData
</div>  
</body>  
</html> 
