component extends="coldbox.system.RestHandler" {
    property name="qb" inject="provider:QueryBuilder@qb";

    function index(event, rc, prc){
        var skills = getInstance("Skills").asQuery()
     	.select([
                "id",
                "name",
                "description"
            ]);

        var results = skills.get();
        event.getResponse().setData(results);
    }


    

}