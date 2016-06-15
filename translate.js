var text_origin = require("system").args[1];
if ( text_origin === undefined ) {
  phantom.exit();
}
var text_encoded = encodeURI(text_origin);

var page = require("webpage").create();
page.settings.userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36"

var url = "http://fanyi.baidu.com/#zh/jp/" + text_encoded;

page.onLoadFinished = function(){
  var cnt = 0;
  var translate = function() {
    if(cnt++ > 20) {
      phantom.exit();      
    }
    var text_output = page.evaluate(function() {
      return $(".target-output").text().replace(/^ /, "");            
    });

    if(text_output.length <= 0) {
      setTimeout(translate, 200);
    } else {
      console.log(text_output);
      phantom.exit();      
    }
  }
  translate();
};

page.open(url);
