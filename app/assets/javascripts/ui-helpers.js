function Alert(){
	
}
Alert.success = function(text){
	return function(){
		noty({text: text,closeWith:["hover"],type:"success"});
	}
}

Alert.error = function(text){
	return function(){
		noty({text: text,closeWith:["hover"],type:"error"});
	}
}