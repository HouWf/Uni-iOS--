
export deepCoopy(item){
	if (item == undefined || item == null) {
		return ""
	}
	if(typeof item == "Array" || item.constructor().toString() == "Array" || Array.isArray((item))){
		return item.slice()
	}
	if (typeof item == "Object" || item.constructor().toString() == "Object" ) {
		return Object.assign({}, item)
	}
	else{
		return JSON.parse(JSON.stringify(item))
	}
}