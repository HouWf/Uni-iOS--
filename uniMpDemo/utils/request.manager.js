
export function doCustomNativeRequest(event, data={}){
	return new Promise((resolve,reject)=>{
		uni.sendNativeEvent(event, data, res => {
			console.log('宿主App回传的数据：' + res);
			resolve(res)
		})
	})
}

export function doRequest(url="", data={}, method="POST"){
	return new Promise((resolve, reject)=>{
		uni.request({
			url:url,
			data:data,
			method: method,
			timeout: 60000,
			dataType: 'json',
			responseType:'text',
			success:function(res){
				resolve(res)
			},
			fail:function(err){
				reject(err)
			}
		})
	})
}