<template>
	<view>
		<u-navbar @rightClick="showMsg" bgColor="#fff" border>
			<!--  -->
			<template #left>
				<u--image src="../../static/img/home-cus-user-icon.png" width="45rpx" height="45rpx"
					@click="userInfoShow=!userInfoShow"></u--image>
			</template>
			<template #center>
				<view>
					<text class="u-nav-title">首页</text>
				</view>
			</template>
			<template #right>
				<!-- <navigator url="../message/message" hover-class=""> -->
				<view class="" style="position: relative">
					<u--image src="../../static/img/home-cus-msg-icon.png" width="50rpx" height="50rpx"></u--image>
					<u-badge max="99" :value="msgBadge" bgColor="red" color="white" absolute :offset="msgBadgeOffset">
					</u-badge>
				</view>
				<!-- </navigator> -->
			</template>
		</u-navbar>
		<view class="container">
			<!-- 顶部banner -->
			<view class="banner-container">
				<u-swiper class="banner" :list="bannerlist" keyName="image" height="200" imgMode="widthFix"
					:indicator="bannerIndicator" circular @click="bannerClick">
				</u-swiper>
			</view>
			<!-- 统计内容 -->
			<view class="static-container">
				<u-grid :border="false" col="4">
					<u-grid-item v-for="(item,index) in statisticList" :key="index" @click="staticClick(item.text)">
						<view class="grid-num-bg ">
							<view class="grid-num-bg-in flex-column-container">
								<text class="grid-num">{{item.num}}</text>
							</view>
						</view>
						<text class="grid-text">{{item.text}}</text>
					</u-grid-item>
				</u-grid>
			</view>
			<u-gap height="20" bgColor="#f5f5f5"></u-gap>
			<!-- 检测数据 -->
			<view class="menu-container">
				<view class="menu-group" v-for="(item,index) in menuList" :key="index">
					<view class="menu-cell">
						<view class="menu-cell-header flex-row-container">
							<image :src="item.icon" style="width: 40rpx;height: 40rpx;"></image>
							<text class="cell-header-title">{{item.title}}</text>
						</view>
						<view class="menu-cell-conentview">
							<u-grid :border="true" :col="item.col">
								<u-grid-item v-for="(lsitem,lsindex) in item.list" :key="lsindex"
									@click="menuClick(lsitem)" bgColor="#fff">
									<image class="grid-img" :src="lsitem.image" mode="aspectFill"
										style="width: 70rpx;height: 70rpx;"></image>
									<text class="grid-text">{{lsitem.text}}</text>
								</u-grid-item>
							</u-grid>
						</view>
					</view>
					<u-gap height="20" bgColor="#f5f5f5"></u-gap>
				</view>
			</view>
		</view>

		<!-- toast提示 -->
		<u-toast ref="uToast" />

		<!-- 个人信息 -->
		<user-info-view v-model="userInfoShow"></user-info-view>
	</view>
</template>

<script>
	import dataModel from './data.js'
	import userInfoView from '@/components/user-info-left-view/user-info-left-view.vue'
	export default {
		data() {
			return {
				msgBadge: 1,
				msgBadgeOffset: [0, -4],
				bannerlist: [{
					image: '../../static/image/home-banner-first.png', //'https://cdn.uviewui.com/uview/swiper/swiper1.png',
					title: ''
				}],
				// 统计数据
				statisticList: dataModel.statistic,
				// menu数据
				menuList: [dataModel.operationDetection, dataModel.alarmHandling, dataModel.demandManagement, dataModel
					.taskManagement
				],
				userInfoShow: false, // 显示左侧个人信息
			};
		},
		computed: {
			bannerIndicator() {
				return this.bannerlist.length > 1
			}
		},
		methods: {
			showMsg() {
				// 消息
				uni.navigateTo({
					url: '../message/message',
					success: res => {},
					fail: () => {},
					complete: () => {}
				});
				if (this.userInfoShow) {
					this.userInfoShow = false
				}
			},
			bannerClick(e) {
				console.log(e);
			},
			staticClick(name) {
				// this.$refs.uToast.show({
				// 	type: 'default',
				// 	message: name,
				// })
				uni.showToast({
					title: name,
					icon: "none"
				});
			},
			menuClick(item) {
				console.log(item);
				uni.showToast({
					title: item.text,
					icon: "none"
				});
			}
		},
		components: {
			userInfoView
		}
	}
</script>

<style lang="scss">
	.u-nav-title {
		font-size: 1.2em;
		font-weight: 500;
		color: $main-global-color;
	}

	.container {
		margin-top: 88rpx;

		.banner-container {}

		.static-container {
			padding: 30rpx 0 10rpx;
			background-color: $background-color-white;

			.grid-num-bg {
				width: 75rpx;
				height: 75rpx;

				background: linear-gradient(-45deg, transparent 3px, #75A4A1 0) bottom right,
					linear-gradient(45deg, transparent 3px, #75A4A1 0) bottom left,
					linear-gradient(135deg, transparent 3px, #75A4A1 0) top left,
					linear-gradient(-135deg, transparent 3px, #75A4A1 0) top right;
				background-size: 50% 50%;
				background-repeat: no-repeat;

				.grid-num-bg-in {
					width: 100%;
					height: 100%;
					background: linear-gradient(-45deg, transparent 8px, #75A4A1 0) bottom right,
						linear-gradient(45deg, transparent 8px, #75A4A1 0) bottom left,
						linear-gradient(135deg, transparent 8px, #75A4A1 0) top left,
						linear-gradient(-135deg, transparent 8px, #75A4A1 0) top right;
					background-size: 50% 50%;
					background-repeat: no-repeat;
				}

				.grid-num {
					color: #fff;
					font-weight: 500;
					font-size: 1.4em;
				}
			}

			.grid-text {
				font-size: 0.9em;
				color: $text-color-gray;
				margin-top: 10rpx;
			}
		}

		.menu-group {
			.menu-cell {
				// background-color: #fff;

				.menu-cell-header {
					padding: 20rpx 30rpx;

					text {
						font-weight: bold;
						color: $main-global-color;
						font-size: 1em;
						margin-left: 30rpx;
					}

				}

				.menu-cell-conentview {
					background-color: $background-color-lightgray;

					/deep/ .u-grid-item {
						height: 180rpx;
						border-right: 1rpx solid #f5f5f5;
						border-top: 1rpx solid #f5f5f5;
					}

					.grid-text {
						font-size: 1em;
						color: $text-color-gray;
						margin-top: 15rpx;
					}
				}


			}
		}
	}
</style>
