<script>	
	export default {
		onLaunch: function(launchInfo) {
			console.log('App Launch 获取启动参数:', launchInfo);
			
			uni.onNativeEventReceive((event,data)=>{
			    console.log('接收到宿主App消息：' + event + data);
			    this.nativeMsg = '接收到宿主App消息 event：' + event + " data: " + data;
			})
		},
		onShow: function() {
			console.log('App Show')
		},
		onHide: function() {
			console.log('App Hide')
		},
		onError(err) {
			console.log("出现异常了" + err);
		}
	}
</script>

<style lang="scss">
	@import "@/uni_modules/uview-ui/index.scss";
	/*每个页面公共css */
	@import '@/uni_modules/uni-scss/index.scss';
	/* #ifndef APP-NVUE */
	@import '@/static/customicons.css';
	// 设置整个项目的背景色
	page {
		background-color: #f5f5f5;
	}

	/* #endif */
	.example-info {
		font-size: 14px;
		color: #333;
		padding: 10px;
	}
</style>
