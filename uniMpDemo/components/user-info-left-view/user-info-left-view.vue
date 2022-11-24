<template>
	<u-popup :show="value" round="10rpx" mode="left" overlayOpacity="0.3" closeOnClickOverlay @close="click">
		<view class="model-container">
		</view>
	</u-popup>
	<!-- <u-transition :show="value">
		<view class="pop-bg-container" @click="click" :style="{marginTop: popTopMargin + 'px'}">
			<view class="model-container" @click.stop="">

			</view>
		</view>
	</u-transition> -->
</template>

<script>
	export default {
		name: "user-info-left-view",
		model: {
			prop: "value",
			event: "change"
		},
		data() {
			return {
				popTopMargin: 44.5
			};
		},
		props: {
			value: {
				type: Boolean,
				default: false
			},
		},
		methods: {
			click() {
				const newval = !this.value
				this.$emit('change', newval)
			},
		},
		created() {
			this.popTopMargin = 44.5 + this.StatusBar
			console.log('gaodu' + this.popTopMargin);
		}
	}
</script>

<style lang="scss">
	.pop-bg-container {
		position: fixed;
		top: 0;
		left: 0;
		right: 0;
		bottom: 0;
		z-index: 100;
		width: 100vw;
		// margin-top: 100rpx;
		background-color: rgba($color: #000000, $alpha: 0.1);
	}

	.model-container {
		width: 450rpx;
		height: 100vh;
		background-color: #fff;
	}
</style>
