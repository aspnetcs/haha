<%@ page language="java" contentType="text/html; charset=UTF-8"  
    pageEncoding="UTF-8"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">  
<html>  
<head>  
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">  
    <script type="text/javascript" src="js/jquery-2.1.4.min.js"></script>  
    <script src="js/d3.js" charset="utf-8"></script>  
  
    <title>D3--gauge</title>  
    <style type="text/css">  
        .link line {  
            stroke: #696969;  
        }  
  
        .link line.separator {  
            stroke: #fff;  
            stroke-width: 2px;  
        }  
  
        .node circle {  
            stroke: #000;  
            stroke-width: 1.5px;  
        }  
  
        .node text {  
            font: 10px sans-serif;  
            pointer-events: none;  
        }  
    </style>  
</head>  
<body>  
  
<script type="text/javascript">  
    var info = {  
        "opt" : "graph1"  
    };  
  
    var datanodes = [];  
    var datalinks = [];  
  
    $.post("./GetGraphData1", info, function(graphdata) {  
        console.log(graphdata)  
        datanodes.length = 0;  
        datalinks.length = 0;  
        for ( var i = 0; i < eval(graphdata).length; i++) {  
            datanodes.push({  
                "size" : eval(graphdata)[i].size,  
                "name" : eval(graphdata)[i].name,  
                "atom" : eval(graphdata)[i].atom  
            });  
  
        }  
        $.post("./GetGraphData2", info, function(graphdata) {  
            for ( var i = 0; i < eval(graphdata).length; i++) {  
                datalinks.push({  
                    "source" : eval(graphdata)[i].source,  
                    "target" : eval(graphdata)[i].target,  
                    "bond" : eval(graphdata)[i].bond  
                })  
            }  
  
            var width = 960, height = 500;  
            var color = d3.scale.category20();  
            var radius = d3.scale.sqrt().range([ 0, 6 ]);  
  
            var svg = d3.select("body").append("svg").attr("width", width)  
                    .attr("height", height);  
            var force = d3.layout.force().size([ width, height ]).charge(  
                    -400).linkDistance(function(d) {  
                        return radius(d.source.size) + radius(d.target.size) + 20;  
                    }).nodes(datanodes).links(datalinks).on("tick", tick).start();  
  
            var link = svg.selectAll(".link").data(datalinks).enter()  
                    .append("g").attr("class", "link");  
  
            link.append("line").style("stroke-width", function(d) {  
                return (d.bond * 2 - 1) * 2 + "px";  
            });  
            var node = svg.selectAll(".node").data(datanodes).enter()  
                    .append("g").attr("class", "node").call(force.drag);  
  
            node.append("circle").attr("r", function(d) {  
                return radius(d.size);  
            }).style("fill", function(d) {  
                return color(d.name);  
            });  
  
            node.append("text").attr("dy", ".35em").attr("text-anchor",  
                    "middle").text(function(d) {  
                        return d.atom;  
                    });  
            function tick() {  
                link.selectAll("line").attr("x1", function(d) {  
                    return d.source.x;  
                }).attr("y1", function(d) {  
                    return d.source.y;  
                }).attr("x2", function(d) {  
                    return d.target.x;  
                }).attr("y2", function(d) {  
                    return d.target.y;  
                });  
                node.attr("transform", function(d) {  
                    return "translate(" + d.x + "," + d.y + ")";  
                });  
            }  
        })  
    });  
</script>  
  
</body>  
</html>  
