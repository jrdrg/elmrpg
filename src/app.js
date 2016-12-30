(function() {
    'use strict';

    // elm-css
    /* require('./Stylesheets');*/

    require('bulma/css/bulma.css');
    require('../styles.css');
    require('../font/game-icons.css');

    // inject elm
    var Elm = require('./Main');
    Elm.Main.embed(document.getElementById('app'));
})();
