<%@ page language="java" contentType="text/html; charset=UTF-8"  
    pageEncoding="UTF-8"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">  
<html>  
<head>  
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">  
    <link rel="stylesheet"type="text/css" href="js/bee.css" />  
    <title>D3--line</title>  
</head>  
<body>  
<script type="text/javascript" src="js/jquery-2.1.4.min.js"></script>  
<script type="text/javascript" src="js/d3.js"></script>  
<script type="text/javascript">  
    var info = {  
        "opt" : "line"  
    };  
    var date = [];  
    var number = [];  
    $.post("./GetLineData", info, function(data) {  
  
        for ( var i = 0; i < eval(data).length; i++) {  
            date.push(eval(data)[i].date);  
            number.push(eval(data)[i].number);  
        }  
        console.log(date);  
        console.log(number);  
  
  
  
        var w = 1300;  
        var h = 1000;  
        var title = "��������סլ��ǩ�����ƣ��ף�";  
        //���廭��  
        var svg = d3.select("body")  
                .append("svg")  
                .attr("width", w)  
                .attr("height", h);  
  
        svg.append("g")  
                .append("text")  
                .text(title)  
                .attr("class", "title")  
                .attr("x", 660)  
                .attr("y", 60);  
  
        //�������������  
        var xScale = d3.scale.linear()  
                .domain([0,number.length-1])  
                .range([180,1200]);//���range�൱�ں��������ƽ��  
        //�������������  
        var yScale = d3.scale.linear()  
                .domain([0,d3.max(number)])  
                .range([660,180]);  
        //�������������  
        var xInner = d3.svg.axis()  
                .scale(xScale)  
                .tickSize(-480,0,0)//���������߳���  
                .orient("bottom")  
                .ticks(number.length);  
        //��Ӻ���������  
        svg.append("g")  
                .attr("class","inner_line")  
                .attr("transform","translate(0," + 660 + ")")  
                .call(xInner)//  
                .selectAll("text")  
                .text("");  
        .scale(yScale)  
                .tickSize(-1020,0,0)  
                .tickFormat("")  
                .orient("left")  
                .ticks(10);  
  
        //�������������  
        var yBar=svg.append("g")  
                .attr("class","inner_line")  
                .attr("transform","translate("+180+",0)")  
                .call(yInner);  
  
  
        //�������  
        var xAxis = d3.svg.axis()  
                .scale(xScale)  
                .orient("bottom")  
                .ticks(number.length);  
  
        //��Ӻ������Ტͨ����Ż�ȡ��Ӧ�ĺ����ǩ  
        var xBar=svg.append("g")  
                .attr("class","axis")  
                .attr("transform","translate(0," + 660 + ")")//��������ƽ�ƺ���λ��  
                .call(xAxis)  
                .selectAll("text")  
                .text(function(d){  
                    return date[d];  
                });  
  
  
        //��������  
        var yAxis = d3.svg.axis()  
                .scale(yScale)  
                .orient("left")  
                .ticks(10);///�����ϸ�ֶ�  
  
  
        //�������  
        var yBar=svg.append("g")  
                .attr("class", "axis")  
                .attr("transform","translate("+180+",0)")  
                .call(yAxis);  
  
  
        //�������  
        var line = d3.svg.line()  
                .x(function(d,i){return xScale(i);})  
                .y(function(d){return yScale(d);});  
        var path=svg.append("path")  
                .attr("d", line(number))  
                .style("fill","#F00")  
                .style("fill","none")  
                .style("stroke-width",1)  
                .style("stroke","#09F")  
                .style("stroke-opacity",0.9);  
  
  
        //���ϵ�е�СԲ��  
        svg.selectAll("circle")  
                .data(number)  
                .enter()  
                .append("circle")  
                .attr("cx", function(d,i) {  
                    return xScale(i);  
                })  
  
                .attr("cy", function(d) {  
                    return yScale(d);  
                })  
                .attr("r",5)  
                .attr("fill","#09F");  
    });  
  
</script>  
</body>  
</html> 
