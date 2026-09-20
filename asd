<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0,
               maximum-scale=1.0,user-scalable=no">

<title>Prodium Battery Monitor</title>

<!-- MQTT.js -->
<script src="https://unpkg.com/mqtt/dist/mqtt.min.js"></script>


<style>

/* =====================================================
   GLOBAL
===================================================== */

*{
    box-sizing:border-box;
    margin:0;
    padding:0;
}

body{
    background:
        radial-gradient(circle at 50% 15%,
        rgba(0,150,255,.12),
        transparent 30%),
        #010914;

    color:white;
    font-family:Arial,Helvetica,sans-serif;

    min-height:100vh;

    display:flex;
    justify-content:center;

    overflow-x:hidden;
}

.dashboard{

    width:100%;
    max-width:520px;

    padding:15px 12px 30px;

    position:relative;
}


/* =====================================================
   HEADER
===================================================== */

.logo{
    text-align:center;
    margin-top:5px;
}

.logo-main{
    font-size:34px;
    font-weight:900;
    letter-spacing:6px;

    background:linear-gradient(
        90deg,
        #ffffff,
        #00cfff,
        #ffffff
    );

    -webkit-background-clip:text;
    color:transparent;
}

.logo-sub{
    font-size:9px;
    letter-spacing:5px;
    color:#8ba9bd;
    margin-top:2px;
}

.online{
    margin-top:8px;

    display:flex;
    justify-content:center;
    align-items:center;
    gap:8px;

    color:#00ff4c;
    font-weight:bold;
    letter-spacing:2px;
}

.online-dot{
    width:8px;
    height:8px;
    border-radius:50%;
    background:#00ff4c;

    box-shadow:
        0 0 8px #00ff4c,
        0 0 18px #00ff4c;

    animation:pulse 1.5s infinite;
}

@keyframes pulse{
    0%,100%{opacity:1}
    50%{opacity:.35}
}


/* =====================================================
   CONNECTION
===================================================== */

.connection-status{
    text-align:center;
    margin-top:5px;
    font-size:8px;
    color:#7f9aaa;
}


/* =====================================================
   BATTERY HEADER
===================================================== */

.battery-title{

    margin-top:12px;

    height:42px;

    border:1px solid #00cfff;
    border-radius:25px;

    display:flex;
    justify-content:center;
    align-items:center;

    font-size:17px;
    font-weight:bold;

    background:
        linear-gradient(
            90deg,
            rgba(0,100,150,.12),
            rgba(0,220,255,.08),
            rgba(0,100,150,.12)
        );

    box-shadow:
        0 0 8px rgba(0,210,255,.35);
}


/* =====================================================
   GAUGE AREA
===================================================== */

.gauges{

    display:grid;

    grid-template-columns:
        repeat(2,1fr);

    gap:10px;

    margin-top:15px;
}


/* =====================================================
   GAUGE
===================================================== */

.gauge{

    position:relative;

    aspect-ratio:1/1;

    border-radius:50%;

    background:
        radial-gradient(
            circle,
            #061523 0 51%,
            #02101c 52% 62%,
            transparent 63%
        );

    border:2px solid #123a55;

    box-shadow:
        inset 0 0 25px #001827,
        0 0 15px rgba(0,170,255,.3);

    overflow:hidden;
}


/* outer ring */

.gauge::before{

    content:"";

    position:absolute;

    inset:7%;

    border-radius:50%;

    background:
        conic-gradient(
            from 220deg,
            #00bfff 0deg,
            #008cff 70deg,
            #00d9ff 145deg,
            #20ff78 210deg,
            #ffffff 235deg,
            #ff3131 275deg,
            transparent 276deg 360deg
        );

    -webkit-mask:
        radial-gradient(
            circle,
            transparent 0 76%,
            #000 77% 82%,
            transparent 83%
        );

    mask:
        radial-gradient(
            circle,
            transparent 0 76%,
            #000 77% 82%,
            transparent 83%
        );
}


/* gauge tick effect */

.gauge::after{

    content:"";

    position:absolute;

    inset:13%;

    border-radius:50%;

    border:
        1px dashed
        rgba(170,230,255,.55);
}


/* =====================================================
   GAUGE NUMBERS
===================================================== */

.numbers{

    position:absolute;

    inset:0;

    pointer-events:none;

    font-size:12px;
    font-weight:bold;
    color:white;
}

.numbers span{
    position:absolute;
}

.n0{
    left:15%;
    bottom:22%;
}

.n20{
    left:12%;
    top:46%;
}

.n40{
    left:23%;
    top:25%;
}

.n60{
    left:45%;
    top:17%;
}

.n80{
    right:23%;
    top:25%;
}

.n100{
    right:11%;
    top:46%;
}

.n120{
    right:15%;
    bottom:22%;
}


/* =====================================================
   NEEDLE
===================================================== */

.needle{

    position:absolute;

    width:3px;
    height:38%;

    left:50%;
    top:18%;

    transform-origin:
        50% 85%;

    transform:
        translateX(-50%)
        rotate(-55deg);

    background:
        linear-gradient(
            to top,
            #00d9ff,
            white
        );

    box-shadow:
        0 0 8px #00d9ff,
        0 0 15px #00d9ff;

    border-radius:5px;

    z-index:5;

    transition:
        transform .7s ease;
}

.needle-dot{

    position:absolute;

    width:13px;
    height:13px;

    border-radius:50%;

    left:50%;
    top:50%;

    transform:translate(-50%,-50%);

    background:#dffaff;

    border:3px solid #00aeea;

    box-shadow:
        0 0 10px #00d9ff;

    z-index:6;
}


/* =====================================================
   GAUGE VALUE
===================================================== */

.gauge-value{

    position:absolute;

    left:0;
    right:0;

    top:48%;

    text-align:center;

    font-size:23px;
    font-weight:bold;

    text-shadow:
        0 0 8px #00cfff;

    z-index:7;
}

.gauge-label{

    position:absolute;

    left:0;
    right:0;

    bottom:20%;

    text-align:center;

    font-size:9px;

    letter-spacing:2px;

    color:#b5d5e8;

    z-index:7;
}


/* =====================================================
   INFO CARDS
===================================================== */

.info-row{

    display:grid;

    grid-template-columns:
        repeat(2,1fr);

    gap:8px;

    margin-top:12px;
}

.info{

    border:1px solid #00bfff;

    border-radius:12px;

    padding:12px 5px;

    text-align:center;

    background:
        linear-gradient(
            180deg,
            rgba(0,100,150,.12),
            rgba(0,0,0,.2)
        );

    box-shadow:
        0 0 8px rgba(0,180,255,.15);
}

.info-value{

    font-size:19px;
    font-weight:bold;
}

.current{
    color:#ffae32;
}

.temp{
    color:#ff6e91;
}

.info-label{

    font-size:8px;
    letter-spacing:2px;

    color:#86a5b8;

    margin-top:4px;
}


/* =====================================================
   GRAPH
===================================================== */

.graph-box{

    margin-top:12px;

    border:1px solid #00cfff;

    border-radius:12px;

    padding:9px;

    background:
        rgba(0,20,35,.75);

    box-shadow:
        inset 0 0 15px rgba(0,150,255,.08);
}

.graph-head{

    display:flex;

    justify-content:space-between;

    font-size:9px;

    color:#9db8c9;

    margin-bottom:5px;
}

.live{
    color:#00ff54;
}

.graph{

    width:100%;
    height:90px;

    position:relative;

    overflow:hidden;

    border-radius:5px;

    background:
        repeating-linear-gradient(
            90deg,
            rgba(0,190,255,.08) 0 1px,
            transparent 1px 40px
        ),
        repeating-linear-gradient(
            0deg,
            rgba(0,190,255,.08) 0 1px,
            transparent 1px 20px
        );
}

.wave{

    position:absolute;

    left:0;

    width:200%;

    height:100%;

    animation:
        graphMove 5s linear infinite;
}

.wave svg{
    width:50%;
    height:100%;
}

.wave path{

    fill:none;

    stroke:#00d9ff;

    stroke-width:2;

    filter:
        drop-shadow(0 0 5px #00d9ff);
}

@keyframes graphMove{

    from{
        transform:translateX(0);
    }

    to{
        transform:translateX(-50%);
    }

}


/* =====================================================
   STATUS
===================================================== */

.status{

    margin-top:12px;

    border:1px solid #00cfff;

    border-radius:12px;

    padding:13px;

    text-align:center;

    background:
        rgba(0,40,55,.45);
}

.status-icon{

    font-size:27px;

    color:#00ff4c;

    text-shadow:
        0 0 10px #00ff4c;
}

.status-text{

    color:#00ff4c;

    font-size:14px;

    font-weight:bold;

    margin-top:3px;
}

.status-label{

    font-size:8px;

    color:#89a8ba;

    letter-spacing:2px;
}


/* =====================================================
   ODO
===================================================== */

.meta{

    display:grid;

    grid-template-columns:
        repeat(2,1fr);

    gap:8px;

    margin-top:10px;
}

.meta-box{

    border:1px solid #008ac2;

    border-radius:10px;

    padding:9px;

    text-align:center;
}

.meta-title{

    font-size:7px;

    color:#8ba6b7;

    letter-spacing:1px;
}

.meta-value{

    margin-top:3px;

    font-size:10px;

    font-weight:bold;
}


/* =====================================================
   BATTERY BUTTONS
===================================================== */

.battery-grid{

    display:grid;

    grid-template-columns:
        repeat(6,1fr);

    gap:6px;

    margin-top:12px;
}

.bat-btn{

    min-height:30px;

    border-radius:6px;

    border:1px solid #00bfff;

    background:
        linear-gradient(
            180deg,
            rgba(0,80,130,.35),
            rgba(0,20,40,.8)
        );

    color:white;

    font-size:8px;

    font-weight:bold;

    cursor:pointer;

    transition:.2s;
}

.bat-btn:hover{

    box-shadow:
        0 0 10px #00cfff;

}

.bat-btn.active{

    background:
        linear-gradient(
            180deg,
            #008fc4,
            #004d75
        );

    box-shadow:
        0 0 10px #00cfff,
        inset 0 0 10px #00d9ff;
}


/* =====================================================
   FOOTER
===================================================== */

.footer{

    margin-top:25px;

    text-align:center;

    color:#6e899b;

    font-size:8px;

    letter-spacing:2px;
}

.footer strong{

    color:#00bfff;

}


/* =====================================================
   MOBILE
===================================================== */

@media(max-width:380px){

    .logo-main{
        font-size:28px;
    }

    .gauge-value{
        font-size:19px;
    }

    .battery-grid{
        gap:4px;
    }

    .bat-btn{
        font-size:7px;
    }
}

</style>

</head>


<body>

<div class="dashboard">


<!-- ===================================================
     HEADER
=================================================== -->

<div class="logo">

    <div class="logo-main">
        PRODIUM
    </div>

    <div class="logo-sub">
        BATTERY MONITOR
    </div>

</div>


<div class="online">

    <span
        class="online-dot"
        id="onlineDot">
    </span>

    <span id="onlineText">
        CONNECTING
    </span>

</div>


<div
    class="connection-status"
    id="mqttStatus">

    MQTT CONNECTING...

</div>


<!-- ===================================================
     BATTERY SELECTED
=================================================== -->

<div class="battery-title">

    <span id="batteryTitle">
        BAT01
    </span>

</div>


<!-- ===================================================
     GAUGES
=================================================== -->

<div class="gauges">


<!-- VOLTAGE -->

<div class="gauge">

    <div class="numbers">

        <span class="n0">0</span>
        <span class="n20">20</span>
        <span class="n40">40</span>
        <span class="n60">60</span>
        <span class="n80">80</span>
        <span class="n100">100</span>
        <span class="n120">120</span>

    </div>


    <div
        class="needle"
        id="voltageNeedle">
    </div>


    <div class="needle-dot"></div>


    <div
        class="gauge-value"
        id="voltageValue">

        -- V

    </div>


    <div class="gauge-label">

        VOLTAGE

    </div>

</div>


<!-- SOC -->

<div class="gauge">

    <div class="numbers">

        <span class="n0">0</span>
        <span class="n20">20</span>
        <span class="n40">40</span>
        <span class="n60">60</span>
        <span class="n80">80</span>
        <span class="n100">100</span>

    </div>


    <div
        class="needle"
        id="socNeedle">
    </div>


    <div class="needle-dot"></div>


    <div
        class="gauge-value"
        id="socValue">

        -- %

    </div>


    <div class="gauge-label">

        SOC

    </div>

</div>

</div>


<!-- ===================================================
     CURRENT / TEMPERATURE
=================================================== -->

<div class="info-row">


    <div class="info">

        <div
            class="info-value current"
            id="currentValue">

            ⚡ -- A

        </div>

        <div class="info-label">

            CURRENT

        </div>

    </div>


    <div class="info">

        <div
            class="info-value temp"
            id="tempValue">

            🌡 -- °C

        </div>

        <div class="info-label">

            TEMPERATURE

        </div>

    </div>


</div>


<!-- ===================================================
     GRAPH
=================================================== -->

<div class="graph-box">

    <div class="graph-head">

        <span id="graphTitle">

            VOLTAGE / REAL-TIME

        </span>

        <span class="live">

            LIVE ●

        </span>

    </div>


    <div class="graph">

        <div class="wave">

            <svg
                viewBox="0 0 1000 100"
                preserveAspectRatio="none">

                <path
                    d="
                    M0 55
                    L40 55
                    L70 52
                    L100 58
                    L130 50
                    L160 54
                    L190 48
                    L220 52
                    L250 45
                    L280 55
                    L310 53
                    L340 49
                    L370 55
                    L400 51
                    L430 56
                    L460 52
                    L490 54
                    L520 48
                    L550 52
                    L580 50
                    L610 54
                    L640 49
                    L670 53
                    L700 51
                    L730 55
                    L760 50
                    L790 53
                    L820 49
                    L850 54
                    L880 51
                    L910 55
                    L940 50
                    L970 54
                    L1000 52
                    "
                />

            </svg>

        </div>

    </div>

</div>


<!-- ===================================================
     STATUS
=================================================== -->

<div class="status">

    <div class="status-icon"
         id="statusIcon">

        ✓

    </div>


    <div
        class="status-text"
        id="statusText">

        WAITING FOR DATA

    </div>


    <div class="status-label">

        STATUS

    </div>

</div>


<!-- ===================================================
     ODO / UPDATE
=================================================== -->

<div class="meta">


    <div class="meta-box">

        <div class="meta-title">

            ODO

        </div>

        <div
            class="meta-value"
            id="odoValue">

            --

        </div>

    </div>


    <div class="meta-box">

        <div class="meta-title">

            LAST UPDATE

        </div>

        <div
            class="meta-value"
            id="updateValue">

            --:--:--

        </div>

    </div>


</div>


<!-- ===================================================
     BATTERY BUTTONS
=================================================== -->

<div
    class="battery-grid"
    id="batteryGrid">

</div>


<!-- ===================================================
     FOOTER
=================================================== -->

<div class="footer">

    <strong>PRODIUM</strong>

    &nbsp; POWERING A GREENER TOMORROW

    <br><br>

    WIFI • MQTT • ESP32

</div>


</div>


<script>

/* =====================================================
   MQTT SETTINGS
===================================================== */

const MQTT_URL =
    "wss://broker.hivemq.com:8884/mqtt";

const MQTT_TOPIC =
    "prodium/battery";


/* =====================================================
   BATTERY DATA
===================================================== */

const batteries = [];


/*
   Create 24 battery slots.

   BAT01-BAT04 akan menerima
   data sebenar daripada MQTT.

   BAT05-BAT24 menunggu ESP32
   lain yang akan kita tambah nanti.
*/

for(let i=1;i<=24;i++){

    batteries.push({

        id:
            "BAT" +
            String(i).padStart(2,"0"),

        voltage:null,

        soc:null,

        current:null,

        temp:null,

        odo:null

    });

}


/* =====================================================
   CREATE BATTERY BUTTONS
===================================================== */

const grid =
    document.getElementById(
        "batteryGrid"
    );


batteries.forEach(
    (battery,index)=>{

        const button =
            document.createElement(
                "button"
            );

        button.className =
            "bat-btn";

        button.textContent =
            battery.id;

        button.onclick =
            () => selectBattery(index);

        grid.appendChild(button);

    }
);


/* =====================================================
   SELECT BATTERY
===================================================== */

let selectedBattery = 0;


function selectBattery(index){

    selectedBattery = index;

    const data =
        batteries[index];


    /* TITLE */

    document.getElementById(
        "batteryTitle"
    ).textContent =
        data.id;


    /* VOLTAGE */

    if(data.voltage !== null){

        document.getElementById(
            "voltageValue"
        ).textContent =
            data.voltage.toFixed(2)
            + " V";

        updateVoltageNeedle(
            data.voltage
        );

    }
    else{

        document.getElementById(
            "voltageValue"
        ).textContent =
            "-- V";

    }


    /* SOC */

    if(data.soc !== null){

        document.getElementById(
            "socValue"
        ).textContent =
            data.soc.toFixed(0)
            + " %";

        updateSocNeedle(
            data.soc
        );

    }
    else{

        document.getElementById(
            "socValue"
        ).textContent =
            "-- %";

    }


    /* CURRENT */

    if(data.current !== null){

        document.getElementById(
            "currentValue"
        ).textContent =
            "⚡ " +
            data.current.toFixed(1) +
            " A";

    }
    else{

        document.getElementById(
            "currentValue"
        ).textContent =
            "⚡ -- A";

    }


    /* TEMPERATURE */

    if(data.temp !== null){

        document.getElementById(
            "tempValue"
        ).textContent =
            "🌡 " +
            data.temp.toFixed(1) +
            " °C";

    }
    else{

        document.getElementById(
            "tempValue"
        ).textContent =
            "🌡 -- °C";

    }


    /* ODO */

    if(data.odo !== null){

        document.getElementById(
            "odoValue"
        ).textContent =
            String(data.odo)
            .padStart(6,"0")
            + " km";

    }
    else{

        document.getElementById(
            "odoValue"
        ).textContent =
            "--";

    }


    /* ACTIVE BUTTON */

    document
        .querySelectorAll(".bat-btn")
        .forEach(
            (btn,i)=>{

                btn.classList.toggle(
                    "active",
                    i === index
                );

            }
        );


    updateTime();

}


/* =====================================================
   VOLTAGE NEEDLE
   0 - 120V
===================================================== */

function updateVoltageNeedle(
    voltage
){

    let percent =
        voltage / 120;


    percent =
        Math.max(
            0,
            Math.min(
                1,
                percent
            )
        );


    let angle =
        -55 +
        percent * 110;


    document.getElementById(
        "voltageNeedle"
    ).style.transform =

        `translateX(-50%)
         rotate(${angle}deg)`;

}


/* =====================================================
   SOC NEEDLE
   0 - 100%
===================================================== */

function updateSocNeedle(
    soc
){

    let percent =
        soc / 100;


    percent =
        Math.max(
            0,
            Math.min(
                1,
                percent
            )
        );


    let angle =
        -55 +
        percent * 110;


    document.getElementById(
        "socNeedle"
    ).style.transform =

        `translateX(-50%)
         rotate(${angle}deg)`;

}


/* =====================================================
   TIME
===================================================== */

function updateTime(){

    const now =
        new Date();


    document.getElementById(
        "updateValue"
    ).textContent =
        now.toLocaleTimeString();

}


/* =====================================================
   MQTT CLIENT
===================================================== */

const mqttClient =
    mqtt.connect(
        MQTT_URL,
        {

            clientId:
                "PRODIUM-DASHBOARD-" +
                Math.random()
                    .toString(16)
                    .slice(2),

            clean:true,

            connectTimeout:10000,

            reconnectPeriod:3000

        }
    );


/* =====================================================
   MQTT CONNECTED
===================================================== */

mqttClient.on(
    "connect",
    function(){

        console.log(
            "MQTT CONNECTED"
        );


        document.getElementById(
            "onlineText"
        ).textContent =
            "ONLINE";


        document.getElementById(
            "onlineDot"
        ).style.background =
            "#00ff4c";


        document.getElementById(
            "mqttStatus"
        ).textContent =
            "MQTT CONNECTED";


        document.getElementById(
            "mqttStatus"
        ).style.color =
            "#00ff4c";


        mqttClient.subscribe(
            MQTT_TOPIC,
            function(error){

                if(error){

                    console.error(
                        "SUBSCRIBE ERROR",
                        error
                    );

                    document.getElementById(
                        "mqttStatus"
                    ).textContent =
                        "SUBSCRIBE ERROR";

                }
                else{

                    console.log(
                        "SUBSCRIBED:",
                        MQTT_TOPIC
                    );

                }

            }
        );

    }
);


/* =====================================================
   MQTT MESSAGE
===================================================== */

mqttClient.on(
    "message",
    function(topic,message){

        if(topic !== MQTT_TOPIC){

            return;

        }


        try{

            const data =
                JSON.parse(
                    message.toString()
                );


            console.log(
                "MQTT DATA:",
                data
            );


            /*
               Contoh data:

               {
                 BAT01:1.80,
                 BAT02:1.90,
                 BAT03:2.00,
                 BAT04:2.30
               }
            */


            for(
                let i=1;
                i<=24;
                i++
            ){

                const id =
                    "BAT" +
                    String(i)
                    .padStart(2,"0");


                if(
                    data[id] !== undefined
                ){

                    batteries[i-1]
                        .voltage =
                        Number(
                            data[id]
                        );

                }

            }


            /*
               Update battery yang sedang
               dipilih.
            */

            selectBattery(
                selectedBattery
            );


            /* STATUS */

            document.getElementById(
                "statusText"
            ).textContent =
                "DATA RECEIVED";


            document.getElementById(
                "statusIcon"
            ).textContent =
                "✓";


            document.getElementById(
                "statusIcon"
            ).style.color =
                "#00ff4c";


            /* TIME */

            updateTime();


            console.log(
                "BAT01:",
                batteries[0].voltage
            );

            console.log(
                "BAT02:",
                batteries[1].voltage
            );

            console.log(
                "BAT03:",
                batteries[2].voltage
            );

            console.log(
                "BAT04:",
                batteries[3].voltage
            );

        }

        catch(error){

            console.error(
                "JSON ERROR:",
                error
            );


            document.getElementById(
                "statusText"
            ).textContent =
                "INVALID DATA";


            document.getElementById(
                "statusIcon"
            ).textContent =
                "!";

        }

    }
);


/* =====================================================
   MQTT OFFLINE
===================================================== */

mqttClient.on(
    "offline",
    function(){

        console.log(
            "MQTT OFFLINE"
        );


        document.getElementById(
            "onlineText"
        ).textContent =
            "OFFLINE";


        document.getElementById(
            "onlineDot"
        ).style.background =
            "#ff3333";


        document.getElementById(
            "mqttStatus"
        ).textContent =
            "MQTT OFFLINE";


        document.getElementById(
            "mqttStatus"
        ).style.color =
            "#ff3333";


        document.getElementById(
            "statusText"
        ).textContent =
            "OFFLINE";

    }
);


/* =====================================================
   MQTT RECONNECT
===================================================== */

mqttClient.on(
    "reconnect",
    function(){

        console.log(
            "MQTT RECONNECTING..."
        );


        document.getElementById(
            "onlineText"
        ).textContent =
            "RECONNECTING";


        document.getElementById(
            "mqttStatus"
        ).textContent =
            "MQTT RECONNECTING...";


        document.getElementById(
            "mqttStatus"
        ).style.color =
            "#ffd000";

    }
);


/* =====================================================
   MQTT ERROR
===================================================== */

mqttClient.on(
    "error",
    function(error){

        console.error(
            "MQTT ERROR:",
            error
        );

    }
);


/* =====================================================
   START BAT01
===================================================== */

selectBattery(0);

</script>

</body>

</html>
