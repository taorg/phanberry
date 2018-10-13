import { Socket } from "phoenix"

if (!document.getElementById("zone_joystick")) { }
else {

  let socket = new Socket("/socket", { params: { token: window.userToken } })
  socket.connect()

  // Now that you are connected, you can join channels with a topic:
  let channel = socket.channel("wschannel:joystick", {})

  channel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })
  //------------------------------------------------------------------------------------
  //  RESOLUTION
  //------------------------------------------------------------------------------------
  function updateMyScreenResolution(){
    /** const swidth = window.screen.width;
    const sheight = window.screen.height;
    const resolution = swidth+' x '+sheight;
    const vwidth = window.innerWidth;
    const vheight = window.innerHeight;
    const bresolution = vwidth+' x '+vheight; */
    var wsize = ((window.innerWidth < window.innerWidth) ? window.innerHeight/3 : window.innerWidth/3)
    const dsize = ((wsize < 300) ? wsize : 400)
    console.log('wsize:'+wsize)
    console.log('dsize:'+dsize)
    return dsize
  }
  
  updateMyScreenResolution();
  
  window.addEventListener('resize', () => {
    updateMyScreenResolution();

  sId('buttons').onclick = createNipple;
  createNipple('static');
  });
  //------------------------------------------------------------------------------------
  //  NIPPLE
  //------------------------------------------------------------------------------------
  var s = function (sel) {
    return document.querySelector(sel);
  };
  var sId = function (sel) {
    return document.getElementById(sel);
  };
  var removeClass = function (el, clss) {
    if (el != null) {
      el.className = el.className.replace(new RegExp('\\b' + clss + ' ?\\b', 'g'), '');
    }
  }


  var joysticks = {
    dynamic: {
      zone: s('.zone.dynamic'),
      mode: 'dynamic',
      color: '#1e7e34',
      multitouch: true,
      size: updateMyScreenResolution(),
      restJoystick: true,
      restOpacity: 7
    },

    static: {
      zone: s('.zone.static'),
      mode: 'static',
      position: {
        left: '50%',
        top: '20%'
      },
      multitouch: true,
      color: '#0062cc',
      size: updateMyScreenResolution(),
      restJoystick: true,
      restOpacity: 7
    }
  };
  var joystick;

  // Get debug elements and map them
  var elDebug = sId('joystick_debug');
  var elDump = elDebug.querySelector('.dump');
  var els = {
    position: {
      x: elDebug.querySelector('.position .x .data'),
      y: elDebug.querySelector('.position .y .data')
    },
    force: elDebug.querySelector('.force .data'),
    pressure: elDebug.querySelector('.pressure .data'),
    distance: elDebug.querySelector('.distance .data'),
    angle: {
      radian: elDebug.querySelector('.angle .radian .data'),
      degree: elDebug.querySelector('.angle .degree .data')
    },
    direction: {
      x: elDebug.querySelector('.direction .x .data'),
      y: elDebug.querySelector('.direction .y .data'),
      angle: elDebug.querySelector('.direction .angle .data')
    }
  };

  sId('buttons').onclick = createNipple;
  createNipple('static');

  function bindNipple() {
    joystick.on('start end', function (evt, data) {
      dump(evt.type);
      debug(data);
    }).on('move', function (evt, data) {
      debug(data);
    }).on('dir:up plain:up dir:left plain:left dir:down ' +
      'plain:down dir:right plain:right',
      function (evt, data) {
        dump(evt.type);
      }
    ).on('pressure', function (evt, data) {
      debug({
        pressure: data
      });
    });
  }

  function createNipple(evt) {
    var type = typeof evt === 'string' ?
      evt : evt.target.getAttribute('data-type');
    if (type == 'exit') return
    if (joystick) {
      joystick.destroy();
    }
    removeClass(s('.zone.active'), 'active');
    removeClass(s('.btn.active'), 'active');
    s('.btn.' + type).className += ' active';
    s('.zone.' + type).className += ' active';
    joystick = nipplejs.create(joysticks[type]);
    bindNipple();
  }

  // Print data into elements
  function debug(obj) {
    channel.push("new_jstick_chn_obj", { jstick_obj: obj })
    function parseObj(sub, el) {
      for (var i in sub) {
        if (typeof sub[i] === 'object' && el) {
          parseObj(sub[i], el[i]);
        } else if (el && el[i]) {
          el[i].innerHTML = sub[i];
        }
      }
    }
    setTimeout(function () {
      parseObj(obj, els);
    }, 0);
  }

  var nbEvents = 0;

  // Dump data
  function dump(evt) {
    channel.push("new_jstick_chn_evnt", { jstick_event: evt })
    setTimeout(function () {
      if (elDump.children.length > 4) {
        elDump.removeChild(elDump.firstChild);
      }
      var newEvent = document.createElement('div');
      newEvent.innerHTML = '#' + nbEvents + ' : <span class="data">' +
        evt + '</span>';
      elDump.appendChild(newEvent);
      nbEvents += 1;
    }, 0);
  }
  //------------------------------------------------------------------------------------
  //  END ELSE JOYSTICK CODE
  //------------------------------------------------------------------------------------
}