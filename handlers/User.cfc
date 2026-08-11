component extends="coldbox.system.RestHandler" {
	property name="bcrypt" inject="BCrypt@BCrypt";
    /**
     * index
     */
    function index(event, rc, prc){

var authUser = jwtAuth().getUser();

        // writeDump(var=rc, abort=true, label="rc");

        // var users = getInstance("Users").asQuery()
        // .select()
        // .where("email", rc)
        // .first()
    
    	event.getResponse().setData( authUser.getMemento()  );
    }





/**
 * index
 */
function create(event, rc, prc){
    // writeDump(var=rc, abort=true, label="rc");

    var users = populate("Users");

   var hashedPassword = bcrypt.hashPassword(rc.password);
    users.setPassword(hashedPassword);


    // Validate it
    var vResults = validateModel( users );
    // Check it
    if ( vResults.hasErrors() ) {
        // Return the errors
        event.getResponse().setStatus( 400 );
        event.getResponse().setData( vResults.getAllErrors() );
    } else {
        // Save the message
        users.save();
        // Return the message
        event.getResponse().setStatus( 201 );
        event.getResponse().setData( { 'item': users.getMemento() } );
    }
}

}