/* Define custom server-side HTTP routes for lineman's development server
 *   These might be as simple as stubbing a little JSON to
 *   facilitate development of code that interacts with an HTTP service
 *   (presumably, mirroring one that will be reachable in a live environment).
 *
 * It's important to remember that any custom endpoints defined here
 *   will only be available in development, as lineman only builds
 *   static assets, it can't run server-side code.
 *
 * This file can be very useful for rapid prototyping or even organically
 *   defining a spec based on the needs of the client code that emerge.
 *
 */
 var rest = require("restler");
 var moment = require("moment");
 var url = require('url');
 var Client = require('node-rest-client').Client;


module.exports = {
  drawRoutes: function(app) {
    // app.get('/api/greeting/:message', function(req, res){
    //   res.json({ message: "OK, "+req.params.message });
    // });
		app.get('/index', function(req, res){
			res.json({message: 'OK'});
		});
		app.get('/time_entries/:api_key', function(req, res){
			var urlParts = url.parse(req.url, true);
			var dateFormat = 'DD-MM-YYYY';
			var togglDateFormat = 'YYYY-MM-DD';
			var startDate = moment.utc(urlParts.query['start_date'], dateFormat);
			var endDate = moment.utc(urlParts.query['end_date'], dateFormat);
			var baseUrl = 'https://www.toggl.com/api/v8/time_entries?';
			var _url = baseUrl + 'start_date='+startDate.format(togglDateFormat)+'T00:00:00-00:00&end_date='+endDate.format(togglDateFormat)+'T00:00:00-00:00';

			var options_auth = {user: req.params.api_key, password: "api_token"};
			var client = new Client(options_auth);
			client.get(_url, function(data, response){
					res.json(data);
					console.log(data);
			 });

		});
  }
};


