# Zulu
DIY Home Automation App with tons of features.

Take a look at [this](http://zulu.oooseun.com/) for more info. 

The App is ready to go,just insert links and Go! The format of the "Vitals link" has to be 'specially structured', this is shown below.

My (personal) backend setup can be seen [here](https://github.com/oooseun/ZuluBackend). I HIGHLY recommend you take a good look at it. 

```Javascript
var vitals = {                                        
    'temp': 0,
    'light': 0,
    'outsideTemp': 0,
    'icon': "",
    'ishome': "yes",
    'ismotion': false,
    'isnoise': false,
    'state1': "off",
    'state2': "off",
    'state3': "off",
    'state4': "off",
    'visits': 0,
    'webcamstatus': "undefined",
    'tempRaw': 0,
    'uptime': moment().from(startTime),
    'motionLights':"0000",
    'motionlight1':0,
    'motionlight2':0,
    'motionlight3':0,
    'motionlight4':0,
    'tempArray':[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
};

```

And tempArray :

```Javascript

tempArray = [100.0,100.0,100.0,100.0,100.0,100.0,100.0,100.0,100.0,100.0,100.0,100.0,100.0,100.0,100.0,100.0,0,0,0,0,0]

```

But other than making sure the links are correct, the app is good to go!
