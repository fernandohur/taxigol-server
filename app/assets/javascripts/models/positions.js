/**
 * [Position description]
 * @type {[type]}
 */
var Position = Backbone.Model.extend({

	urlRoot : '/api/v1/positions',
	defaults: {

	},
	find : function(id){
		this.set({id:id});
		return this.fetch();
	}
});


