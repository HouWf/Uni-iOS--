<template>
	<view>
		
	</view>
</template>

<script>
	import { doRequest } from "@/utils/request.manager.js"
	export default {
		data() {
			return {
				
			};
		},
		methods: {
			getVersion(){
				plus.runtime.getProperty(plus.runtime.appid, wgtinfo=>{
					var version = wgtinfo.version;
					this.getAppVersion(version)
				})
			},
			async getAppVersion(v){
				let this_ = this;
				var system = uni.getSystemInfoSync().platform;
				if (system.toLowerCase() == "ios") {
					doRequest("checkversion",{}).then(res=>{
						if(res.ver !== v){
							if(res.ios_url){
								let down_url = res.ios_url;
								this_.downLoadFileAndinstall(down_url)
							}
						}
					}).catch(err=>{
						
					})
				}else if(system.toLowerCase() == "android"){
					
				}
			},
			downLoadFileAndinstall(url){
				let this_ = this;
				plus.downloader.createDownload(url,{filename:'_doc/update/'},(d, status)=>{
					if(status == 200){
						// plus.nativeUI.toast('下载成功，安装中')
						// 下载成功，安装
						this_.installWgt(d.filename);
					}else{
						// 下载失败
					}
					// plus.nativeUI.closeWaiting()
				}).start()
			},
			installWgt(filename){
				plus.runtime.install(filename, {force:true}, (res)=>{
					plus.runtime.restart()
				},(err)=>{
					plus.nativeUI.toast('安装wgt文件失败[' + err.code + ']：' + err.message);
				})
			}
			
		},
		onInit() {
			// 仅百度小程序基础库 3.260 以上支持 onInit 生命周期
		},
		onLoad() {
			
		},
		onShow() {
			
		},
		onReady() {
			
		},
		onHide() {
			
		},
		onUnload() {
			
		},
		onResize() {
			
		},
		onPullDownRefresh() {
			
		},
		onReachBottom() {
			
		},
		onTabItemTap() {
			
		},
		onShareAppMessage() {
			return {}
		},
		onShareTimeline() {
			
		},
		onAddToFavorites() {
			
		},
		onPageScroll() {
			// 不要写交互复杂的js，比如频繁修改页面。
			// 因为这个生命周期是在渲染层触发的，在非h5端，js是在逻辑层执行的，两层之间通信是有损耗的。
			// 如果在滚动过程中，频发触发两层之间的数据交换，可能会造成卡顿。
		},
		onNavigationBarButtonTap() {
			
		},
		onBackPress() {
			// 	
			return false
		},
		onNavigationBarSearchInputChanged() {
			
		},
		onNavigationBarSearchInputConfirmed() {
			
		},
	}
</script>

<style lang="scss">

</style>
