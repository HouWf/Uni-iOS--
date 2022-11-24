<template>
	<view class="container">
		<u-button @click="showSheet">{{actTitle}}</u-button>
		<u-button @click="sendMsgToApp">向原生发送消息</u-button>
		<u-action-sheet :actions="list" title="选项" :show="show" @select="selectClick" :closeOnClickOverlay="true"
			:closeOnClickAction="true" @close="closeSheet">
		</u-action-sheet>
	</view>
</template>

<script>
	import {
		doCustomNativeRequest
	} from '@/utils/request.manager.js'
	export default {
		data() {
			return {
				actTitle: "hello",
				list: [{
					name: '点赞'
				}, {
					name: '分享'
				}, {
					name: '评论'
				}],
				show: false
			}
		},
		onLoad() {
			uni.onNativeEventReceive((event,data)=>{
			    console.log('onLoad 接收到宿主App消息：' + event + data);
			    this.nativeMsg = '接收到宿主App消息 event：' + event + " data: " + data;
			})
		},
		methods: {
			showSheet() {
				this.show = true
			},
			closeSheet() {
				this.show = false
			},
			selectClick(item) {
				console.log(item);
				this.show = false
			},
			sendMsgToApp() {
				doCustomNativeRequest('event', {
					msg: "unimp message!!!"
				}).then(res => {
					console.log('宿主App回传的数据：' + ret);
				}).catch(err => {
					console.log('宿主App回传的异常数据：' + err);
				})
			}
		},
		// 监听胶囊按钮点击事件
		onNavigationBarButtonTap(e) {
			console.log(e)
			// plus.runtime.quit()
		},
		onReachBottom() {
			
		},
		onPullDownRefresh() {
			setTimeout(function() {
				uni.stopPullDownRefresh();
			}, 3000);
		},
		onPageScroll() {
			
		}
	}
</script>

<style lang="scss">
	.container {
		padding: 20px;
		font-size: 14px;
		line-height: 24px;

		.intro {
			color: red;
		}
	}
</style>
