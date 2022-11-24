<template>
	<view>
		<div>已跳转到直达页</div>
		<u-button @click="closeUniMP">关闭小程序</u-button>
	</view>
</template>

<script>
	export default {
		data() {
			return {

			}
		},
		onLoad() {
			// #ifdef APP-PLUS
			// 判断是否为启动直达页面
			// 启动直达二级页面屏蔽返回手势及返回按钮
			if (e.action === "redirect") {
				const currentWebview = this.$scope.$getAppWebview();
				currentWebview.setStyle({
					popGesture: 'none', // 取消手势返回
					titleNView: {
						autoBackButton: false // 取消默认返回按钮
					}
				})
			}
			// #endif
		},
		methods: {
			closeUniMP() {
				// #ifdef APP-PLUS
				plus.runtime.quit()
				// #endif
			}
		}
	}
</script>

<style>

</style>
