/**
 * This is your application router.  From here you can controll all the incoming routes to your application.
 *
 * https://coldbox.ortusbooks.com/the-basics/routing
 */
component {

	function configure(){
		/**
		 * --------------------------------------------------------------------------
		 * App Routes
		 * --------------------------------------------------------------------------
		 * Here is where you can register the routes for your web application!
		 * Go get Funky!
		 */

		// A nice healthcheck route example
		route( "/healthcheck", function( event, rc, prc ){
			return "Ok!";
		} );

// route( "/api/:any*" )
//   .withAction( {
//     "OPTIONS": function( event, rc, prc ){
//       cfheader( name="Access-Control-Allow-Origin", value="*" );
//       cfheader( name="Access-Control-Allow-Methods", value="GET, POST, PUT, DELETE, OPTIONS" );
//       cfheader( name="Access-Control-Allow-Headers", value="Content-Type, Authorization" );
//       return "";
//     }
//   } );

		// API Echo
		get( "/api/echo", "Echo.index" );

		// API Authentication Routes
		post( "/api/login", "Auth.login" );
		post( "/api/logout", "Auth.logout" );
		post( "/api/register", "Auth.register" );
		get( "/api/user", "User.index" );

	post( "/api/project/image", "image.upload" );
		get( "/api/projects/featured", "Projects.featured" );
		put( "/api/projects/:id", "Projects.update" );
		delete( "/api/projects/:id", "Projects.delete" );
		get( "/api/projects", "Projects.index" );
		post( "/api/projects", "Projects.create" );


	put( "/api/experiences/:id", "Experience.update" );
	delete( "/api/experiences/:id", "Experience.delete" );
	get( "/api/experiences", "Experience.index" );
	post( "/api/experiences", "Experience.create" );
	

post("/api/contact", "Contact.create");

		get( "/api/skills", "Skills.index" );
		get( "/api/frameworks", "Frameworks.index" );


		// API Secured Routes
		get( "/api/whoami", "Echo.whoami" );

		// @app_routes@

		// Conventions-Based Routing
		route( ":handler/:action?" ).end();
	}

}
