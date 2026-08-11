component extends="coldbox.system.RestHandler" {
	property name="mailService" inject="MailService@cbmailservices";


	    function create(event, rc, prc) {
        // Deserialize JSON body into rc
        var body = event.getHTTPContent();
        if (isJSON(body)) {
            structAppend(rc, deserializeJSON(body), true);
        }

        var mailResult  = this.sendMail(rc);

        if (mailResult) {
            event.getResponse()
                .setStatusCode(200)
                .setData({ message: "Bericht verstuurd" });
        } else {
            event.getResponse()
                .setError(true)
                .setStatusCode(500)
                .setData({ message: "Er ging iets mis bij het versturen" });
        }
    }

function sendMail(rc, contact) {
		var sendTo = "dammersdaniel@gmail.com";
	
		var bReturn = false;

		// if (Lcase(rc.subject) EQ "fout") {
		// 	sendTo = "dammersdaniel@gmail.com";
		// }

		// var user = getInstance("User").where( "email", rc.email ).first();

		newMail(
			to          : sendTo,
			from        : "portfolio@dammienet.eu",
			subject     : rc.subject,
			replyto		  : rc.email,
			type        : "html",
			bodyTokens  : {
				subject   : rc.subject,
				user      : rc.naam,
				email	    : rc.email,
				msg 	    : rc.msg,
				aanhef 	  : rc.mv,
				telefoon  : rc.tel ?: 'Geen telefoonnummer opgegeven',
		
		
			}
		)
		.setBody("
			<p>Daniel,</p>
			<p>Er is een mial binnen gekomen van <b>@user@</b> over <b>@subject@</b>: </p>
			<p>
				Naam: @user@ (@aanhef@)
				<br />
				Email: @email@
				<br />
				Telefoon: @telefoon@
				<br />

			</p>
			<p>Vraag/opmerking: </p>
			<p>@msg@</p>
		")
		.send(async = false)
		.onSuccess( function( result, mail ) {
			// Process the success
			 writeLog(
        file = "mail_errors",
        text = "Mail failed: #result.toString()#",
        type = "error"
    );
			bReturn = true;
			// writeDump(var=result, abort=true)
		})
		.onError( function( result, mail ){
			// Process the error
throw(message="Mail error: #result.toString()#");
        bReturn = false;
			
		});

		return bReturn;
	}
}