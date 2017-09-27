   
<graph-of-use>
    <div class="containerV" style="flex-grow:1">
        <div style="display: flex;">
            <div class="card">
                <h4>Credits consumed yesterday</h4></br>
                <span class="second-title-card">{yesterdayCredit} €</span>
            </div>
            <div class="card">
                <h4>Credits consumed last 30 days</h4></br>
                <span class="second-title-card">{totalConsume} €</span>
            </div>
            <div class="card">
                <h4> Running Components </h4></br>
                <span class="second-title-card">{runningComponent} </span>
            </div>
        </div>
        <div style="text-align: center; padding: 5%;" >
            <div>
                Consomation sur vos 30 jours 
            </div>
        </div>
    <div style="display: flex" >
        <div class="item-flex">
            <svg id="stacked"></svg></div>
        </div>
    </div>
    </div>
    

<style>

.card {
    background: #fff;
    border-radius: 5px;
    box-shadow: rgba(0, 0, 0, .2) 2px 4px 5px 3px;
    font-family: "adelle-sans", sans-serif;
    font-weight: 100;
    margin: 48px auto;
    width: 20rem;
    padding: 20px;
    text-align: center;
}

.second-title-card {
    
}

form {
  font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
  position: absolute;
  left: 10px;
  top: 10px;
}

label {
  display: block;
}

.text {
    font-size: 10px;
    fill: white;
    font-family: sans-serif
}

div.tooltip {
    position: absolute;
    text-align: left;
    width: 200px;
    height: 70px;
    padding: 10px;
    font: 12px sans-serif;
    background: lightsteelblue;
    border: 0px;
    border-radius: 8px;
    pointer-events: none;
}

</style>
<script>
    this.yesterdayCredit = 0
    this.totalConsume = 0
    this.runningComponent = 0
    Object.defineProperty(this, 'data', {
    set: function (data) {

        //this.innerData=new Proxy(data, arrayChangeHandler);
        this.innerData = data;
        this.update();

        //this.reportCss(); this.reportFlex(); console.log(this.items,data);
    }.bind(this),
    get: function () {
        return this.innerData;
    },
    configurable: true
    });

    this.on('mount', function () {

    var barChartData = {}
    barChartData.datasets = [];
    barChartData.labels = [];
    var consumption_by_day = {};
    var c = {}
    var r = 10
    var g = 10
    var b = 50
    var compteurCompoflow = {}
    var day = []
    //var dateObj = new Date();
    //var month = dateObj.getUTCMonth() + 1; //months from 1-12
    //var day = dateObj.getUTCDate();
    //var year = dateObj.getUTCFullYear();
    Allday = []
    AllDayObject = {}
    for (var i = 0 ; i < new Date().getUTCDate(); i ++){
        console.log()
        Allday.push(moment().subtract(i, 'days')._d.getUTCDate() + moment().subtract(i, 'days')._d.getUTCMonth() + 1)
        AllDayObject[moment().subtract(i, 'days')._d.getUTCDate()] = []
    }
    this.innerData.components.forEach(function (component) {
        if (component.consumption_history.length > 0) {
             console.log(component)
            compteurCompoflow[component.module] = 0
                component.consumption_history.forEach(function (consumption_history) {
                    var d = new Date(consumption_history.dates.created_at);
                    if(Allday.indexOf(d.getUTCDate() + d.getUTCMonth() + 1) != -1){
                        var c = {}
                        if (component.name) {
                            var name = component.name
                        } else {
                            var name = "no name"
                        }
                        AllDayObject[d.getDate()].push(c[component.module] = {
                            day: d.getDate(),
                            fullDate: d,
                            pricing: component.pricing,
                            price: consumption_history.price,
                            data: consumption_history.flow_size,
                            id: component._id,
                            label: component.module,
                            name: name,
                            date: consumption_history.dates.created_at
                        }) 
                    }
                })
            }
    })

     console.log("AllDayObject", AllDayObject)


   
    // aggregation des flux 
    var lasttab = {}
    for (var conso in AllDayObject) {
        lasttab[conso] = {}
        if(AllDayObject[conso].length > 0){
            AllDayObject[conso].forEach(function (compo) {
                console.log(compo.id, compo.price, compo.label, compo.day)
                if (lasttab[conso][compo.id] == null) {
                    lasttab[conso][compo.id] = {}
                    lasttab[conso][compo.id].data = compo.data
                    lasttab[conso][compo.id].label = compo.label
                    lasttab[conso][compo.id].name = compo.name
                    lasttab[conso][compo.id].day = compo.day
                    lasttab[conso][compo.id].fullDate = compo.fullDate
                    lasttab[conso][compo.id].price = compo.price
                    lasttab[conso][compo.id].pricing = compo.pricing
                }else{
                    lasttab[conso][compo.id].data += compo.data
                    lasttab[conso][compo.id].price += compo.price
                    lasttab[conso][compo.id].id = compo.id
                    lasttab[conso][compo.id].name = compo.name
                    lasttab[conso][compo.id].day = compo.day
                    lasttab[conso][compo.id].fullDate = compo.fullDate
                    lasttab[conso][compo.id].pricing = compo.pricing
                }
            })
        }else{
            console.log("no data")
        }
    };

    console.log(lasttab)

    /// mis des data dans un meme tableau
    var data = []
    for (var conso in lasttab) {
        var c = {}
        c["Day"] = conso
        for (var consoFinal in lasttab[conso]) {
            c[consoFinal] = {
                pricing: lasttab[conso][consoFinal].pricing,
                label: lasttab[conso][consoFinal].label,
                price: lasttab[conso][consoFinal].price,
                datasize: lasttab[conso][consoFinal].data,
                name: lasttab[conso][consoFinal].name,
                id: lasttab[conso][consoFinal].id,
                fullDate: lasttab[conso][consoFinal].fullDate
            }
        }
        data.push(c)
    }

    console.log(data)


    function decimalAdjust(type, value, exp) {
        // Si la valeur de exp n'est pas définie ou vaut zéro...
        if (typeof exp === 'undefined' || +exp === 0) {
        return Math[type](value);
        }
        value = +value;
        exp = +exp;
        // Si la valeur n'est pas un nombre 
        // ou si exp n'est pas un entier...
        if (isNaN(value) || !(typeof exp === 'number' && exp % 1 === 0)) {
        return NaN;
        }
        // Si la valeur est négative
        if (value < 0) {
        return decimalAdjust(type, -value, exp);
        }
        // Décalage
        value = value.toString().split('e');
        value = Math[type](+(value[0] + 'e' + (value[1] ? (+value[1] - exp) : -exp)));
        // Décalage inversé
        value = value.toString().split('e');
        return +(value[0] + 'e' + (value[1] ? (+value[1] + exp) : exp));
  }


/// D3 JS INITIALIZE

    var marginStackChart = {
        top: 20,
        right: 200,
        bottom: 30,
        left: 30
        },
        widthStackChart = 1000 - marginStackChart.left - marginStackChart.right,
        heightStackChart = 500 - marginStackChart.top - marginStackChart.bottom;

    var xStackChart = d3.scaleBand()
        .range([0, widthStackChart])
        .padding(0.1);
    var yStackChart = d3.scaleLinear()
        .range([heightStackChart, 0]);


    var colorStackChart = d3.scaleOrdinal(["rgb(53, 122, 183)", "rgb(15, 157, 232)","rgb(38, 196, 236)","rgb(0, 149, 182)", "rgb(84, 114, 174)", "rgb(104, 111, 140)", "rgb(58, 142, 186)", "rgb(169, 234, 254)", "rgb(116, 208, 241)", "rgb(30, 127, 203)", "rgb(0, 127, 255)", "rgb(121, 248, 248)"])


    var canvasStackChart = d3.select("#stacked")
        .attr("width", widthStackChart + marginStackChart.left + marginStackChart.right)
        .attr("height", heightStackChart + marginStackChart.top + marginStackChart.bottom)
        .append("g")
        .attr("transform", "translate(" + marginStackChart.left + "," + marginStackChart.top + ")");


    var div = d3.select(".item-flex").append("div")
    .attr("class", "tooltip")
    .style("opacity", 0);



//// UPDATE CARD VALUE
    var table = []
    data.forEach(function (d) {  
        var y0 = 0
        for(var prop in d ){
            if(Object.keys(d).length > 1){
                if(table.indexOf(d[prop].id) == -1 && d[prop].id != undefined ){
                    table.push(d[prop].id)
                    this.runningComponent += 1
                }
            }
                if(prop != "Day" && prop != "ages"){
                    table.push(
                        {
                        price: d[prop].price,
                        y1: y0 += +d[prop].datasize
                        }
                    );
                    
                }
            if(d[prop].price != undefined){
                this.totalConsume += decimalAdjust('round', d[prop].price , -4)
            }
        }
        
        if(d["Day"] == new Date().getUTCDate()){
            if( d[prop].price){
                this.yesterdayCredit = decimalAdjust('round', d[prop].price, -4); 
            }
        }else{
            this.yesterdayCredit = 0
        }
        this.update()
    }.bind(this));


//// d3JS DRAW FUNCTION

    function drawStackChart() {
        colorStackChart.domain(d3.keys(data[0]).filter(function (key) {;
        return key !== "Day";
        }));
        data.forEach(function (d) {
            if(Object.keys(d).length > 1){
                d.ages = []
                var y0 = 0;
                for(var prop in d ){
                    if(prop != "Day" && prop != "ages"){
                        console.log("if",prop,  d[prop].price)  
                        d.ages.push(
                            {
                                pricing: d[prop].pricing,
                                name: d[prop].label,
                                module: d[prop].name,
                                datasize: d[prop].datasize,
                                y0: +y0,
                                y1: y0 += d[prop].price
                            }
                        );
                    }
                }
                d.total = d.ages[d.ages.length - 1].y1;
                console.log("total", d.total)
            }else{
                d.ages = []
                var y0 = 0;
                d.ages.push({
                    name: "name",
                    y0: y0,
                    y1: y0
                });
                d.total = 0;
            }
        });

        console.log("last data", data)

        xStackChart.domain(data.map(function (d) {;
            return d.Day;
        }));
        yStackChart.domain([0, d3.max(data, function (d) {
            return d.total;
        })]);

        canvasStackChart.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + heightStackChart + ")")
        .call(d3.axisBottom(xStackChart));

        canvasStackChart.append("text")
        .attr("class", "x label")
        .attr("text-anchor", "end")
        .attr("x", widthStackChart + 5)
        .attr("y", heightStackChart + 30)
        .attr("font-size", "12px")
        .text("jours");

        canvasStackChart.append("g")
        .attr("class", "y axis")
        .call(d3.axisLeft(yStackChart))
        .append("text")
        .attr("transform", "rotate(-90)")
        .attr("y", 6)
        .attr("dy", ".71em")
        .style("text-anchor", "end")


        canvasStackChart.append("text")
        .attr("class", "y label")
        .attr("text-anchor", "end")
        .attr("y", 6)
        .attr("dy", ".75em")
        .attr("transform", "rotate(-90)")
        .attr("font-size", "12px")
        .text("Consomation( € )");


        var state = canvasStackChart.selectAll(".Day")
        .data(data)
        .enter().append("g")
        .attr("class", "g")
        .attr("transform", function (d) {
            return "translate(" + xStackChart(d.Day) + ",0)";
        })
        

        state.selectAll("rect")
        .data(function (d) {
            return d.ages;
        })
        .enter().append("rect")
        .attr("width", xStackChart.bandwidth())
        .attr("y", function (d) {
            return yStackChart(d.y1);
        })
        .attr("height", function (d) {
            return yStackChart(d.y0) - yStackChart(d.y1);
        })
        .style("fill", function (d) {
            return colorStackChart(d.name);
        })
        .on("mouseover", function(d) {
            var conso =  decimalAdjust('round', (d.datasize), -4); 
            var price =  decimalAdjust('round', d.y1 - d.y0, -4 );
            d3.select(this).style("opacity", .6)  
            div.transition()
                .duration(200)
                .style("opacity", .9);
            div.html("module:" + d.name + "<br/>" + "name:" + d.module + "<br/>" + "conso : " + d.datasize + "Mo" + "<br/>" + "pricing : " + d.pricing + "€ / 100 Mo" +  "<br/>" +  "price : " + price + "€" )
                .style("left", d3.event.pageX  + "px")
                .style("top", d3.event.pageY - 28 +  "px");
        })
        .on("mouseout", function(d) {
            d3.select(this).style("opacity", .9) 
            div.transition()
                .duration(500)
                .style("opacity", 0);
        })


        var legend = canvasStackChart.selectAll(".legend")
        .data(colorStackChart.domain().slice().reverse())
        .enter().append("g")
        .attr("class", "legend")
        .attr("transform", function (d, i) {
            return "translate(0," + i * 20 + ")";
        });

        legend.append("rect")
        .attr("x", widthStackChart + 170)
        .attr("width", 16)
        .attr("height", 16)
        .style("fill",colorStackChart)

        legend.append("text")
        .attr("x", widthStackChart + 160)
        .attr("y", 9)
        .attr("font-size", "12px")
        .attr("dy", ".35em")
        .style("text-anchor", "end")
        .text(function (d) {
            if(d != "name"){
                return d;
            }
        });


    };
    drawStackChart();
})
</script>

</graph-of-use>



<!--  
function t
    data.forEach(function (d) {
        if(Object.keys(d).length > 1){
            d.compt = []
            var y0 = 0;
            for(var prop in d ){
                if(prop != "Day" && prop != "ages"){
                    console.log("if", prop)  
                    d.compt.push(
                        {
                        name: prop,
                        price: d[prop].price,
                        y0: +y0,
                        y1: y0 += +d[prop].datasize
                        }
                    );
                }
            }

            d.totalcompt = d.compt[d.compt.length - 1].y1;
            if(d["Day"] == new Date().getUTCDate()){
                this.yesterdayCredit = d.compt[d.compt.length - 1].y1
            }
            this.totalConsume +=  d.compt[d.compt.length - 1].y1
            this.update()
        }else{
            if(d["Day"] == new Date().getUTCDate()){
                this.yesterdayCredit = 0 
            }
            d.compt = []
            var y0 = 0;
            d.compt.push({
                name: "name",
                y0: y0,
                y1: y0
            });
            d.totalcompt = 0;
        }
    }.bind(this));  -->