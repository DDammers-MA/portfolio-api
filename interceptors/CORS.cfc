component {

  function preProcess( event, interceptData ) {

    // Allow your frontend (change this in production)
    var origin = event.getHTTPHeader( "Origin", "*" );

    cfheader( name="Access-Control-Allow-Origin", value=origin );
    cfheader( name="Vary", value="Origin" );

    cfheader( name="Access-Control-Allow-Methods", value="GET, POST, PUT, DELETE, OPTIONS" );
    cfheader( name="Access-Control-Allow-Headers", value="Content-Type, Authorization" );

    // If using cookies/auth later:
    // cfheader( name="Access-Control-Allow-Credentials", value="true" );

    // 🚨 Handle preflight EARLY
    if ( event.getHTTPMethod() == "OPTIONS" ) {
      event.setHTTPHeader( statusCode = 200, statusText = "OK" );
      event.renderData( type="plain", data="" );
      abort;
    }
  }

}