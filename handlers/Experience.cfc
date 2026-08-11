component extends="coldbox.system.RestHandler" {

    property name="qb" inject="provider:QueryBuilder@qb";

    function index(event, rc, prc){
        
        var experience = getInstance("Experiences")
            .asQuery()
            .select([
                "id",
                "role",    
                "company",
                "description",
                "start_date",
                "end_date",
                "current"
            ])
            .orderBy("start_date", "desc");

        var results = experience.get();

        event.getResponse().setData(results);
    }

    function create(event, rc, prc) {
		// Populate the model, based on request body.
		var experience = populate("Experiences");
		// Validate it
		var vResults = validateModel( experience );
		// Check it
		if ( vResults.hasErrors() ) {
			// Return the errors
			event.getResponse().setStatus( 400 );
			event.getResponse().setData( vResults.getAllErrors() );
		} else {
			// Save the message
			experience.save();
			// Return the message
			event.getResponse().setStatus( 201 );
			event.getResponse().setData( { 'item': experience.getMemento() } );
		}
	}

        function update(event, rc, prc) {
		// Populate the model, based on request body.
		var experience = getInstance("Experiences").findOrFail(rc.id);

        experience.populate(rc, true);
		// Validate it
		// Validate it
		var vResults = validateModel( experience );
		// Check it
		if ( vResults.hasErrors() ) {
			// Return the errors
			event.getResponse().setStatus( 400 );
			event.getResponse().setData( vResults.getAllErrors() );
		} else {
			// Save the message
			experience.save();
			// Return the message
			event.getResponse().setStatus( 201 );
			event.getResponse().setData( { 'item': experience.getMemento() } );
		}
	}

    
	function delete(event, rc, prc) {
		var experience = getInstance( "Experiences" ).findOrFail(rc.id);
		experience.delete()
		event.getResponse().setData({ "result": 1 });
	}


}