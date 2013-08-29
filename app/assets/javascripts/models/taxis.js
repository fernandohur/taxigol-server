/**
 * [Taxi description]
 * @type {[type]}
 */
var Taxi = Backbone.Model.extend({

	urlRoot : '/api/v1/taxis',
	defaults: {

	},
	find : function(id){
		this.set({id:id});
		return this.fetch();
	}
});


