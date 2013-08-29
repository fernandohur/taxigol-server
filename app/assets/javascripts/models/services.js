/**
 * [Service description]
 * @type {[type]}
 */
var Service = Backbone.Model.extend({

	urlRoot : '/api/v1/services',
	defaults: {
		service_type: "normal",
		state: "pendiente",
		taxi_id: null
	},
	find : function(id){
		this.set({id:id});
		return this.fetch();
	},
	cancel : function(){
		return this.set({state:"cancelado"});
	}
});


