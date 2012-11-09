var system = require('system');
var page, filename, renderFunction, url;

if (system.args.length < 3) {
  console.log('Usage: screenshoot.js url=http://www.google.com filename=/tmp/google.png [clip=0,0,200,100]');
  phantom.exit();
}

page = new WebPage();

for (var i = 1; i < system.args.length; i++) {
  var k = system.args[i].split('=')[0];
  var v = system.args[i].split('=')[1];
  switch(k) {
    case 'url':
      url = v;
      break;
    case 'filename':
      filename = v;
      break;
    case 'clip':
      page.clipRect = {left: v.split(',')[0], top: v.split(',')[1], width: v.split(',')[2], height: v.split(',')[3]}
      break;
    default:
      console.log("Unknown argument: " + k);
  }
}

renderFunction = function() {
  page.render(filename);
  return phantom.exit();
};

page.open(url, function(status) {
  if (status !== 'success') {
    console.log("An error occurred. Status: " + status);
  }
  return window.setTimeout(renderFunction, 5000);
});
