var fs = require('fs');

fs.writeFile("/tmp/hello-js", "Hello", function(err) {
    console.log("done");
}); 
