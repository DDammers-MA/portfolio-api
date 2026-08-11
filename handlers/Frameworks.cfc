component extends="coldbox.system.RestHandler" {
    property name="qb" inject="provider:QueryBuilder@qb";

    function index(event, rc, prc){
            var frameworks = getInstance("Frameworks").asQuery()
     	.select([
                "id",
                "skill_id",
                "framework_name"
            ]);

            if (structKeyExists(rc, "skill_id") && len(rc.skill_id)) {
            frameworks = frameworks.where("skill_id", "=", rc.skill_id);
        }
        
        

        var results = frameworks.get();
        event.getResponse().setData(results);
    }


}