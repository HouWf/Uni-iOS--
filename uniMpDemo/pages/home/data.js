const statistic = [{
	text: "待办任务",
	num: "4",
	color: ""
}, {
	text: "已办任务",
	num: "3",
	color: ""
}, {
	text: "告警工单",
	num: "2",
	color: ""
}, {
	text: "系统通知",
	num: "5",
	color: ""
}]

const operationDetection = {
	title: '运行检测',
	col: 3,
	icon: "../../static/img/menu-icon.png",
	list: [{
		image: '../../static/image/demand-my-icon.png',
		text: '运维控制台',
		route: ""
	}, {
		image: '../../static/image/demand-put-icon.png',
		text: '数据检测',
		route: ""
	}, {
		image: '../../static/image/demand-handle-icon.png',
		text: '组件检测',
		route: ""
	}],
}

const alarmHandling = {
	title: '告警&处理',
	col: 4,
	icon: "../../static/img/menu-icon.png",
	list: [{
			image: '../../static/image/task-my-icon.png',
			text: '告警列表',
			badge: 0,
			route: ""
		},
		{
			image: '../../static/image/task-dealt-icon.png',
			text: '我的告警',
			badge: 1,
			route: ""
		},
		{
			image: '../../static/image/task-cop-icon.png',
			text: '检修报备',
			badge: 99,
			route: ""
		},
		{
			image: '../../static/image/task-evaluate-icon.png',
			text: '链路核减',
			badge: 100,
			route: ""
		}
	]
}

const demandManagement = {
	title: '需求管理',
	col: 4,
	icon: "../../static/img/menu-icon.png",
	list: [{
			image: '../../static/image/coop-warning-icon.png',
			text: '需求提报',
			badge: 0,
			route: ""
		},
		{
			image: '../../static/image/coop-report-icon.png',
			text: '需求列表',
			badge: 1,
			route: ""
		},
		{
			image: '../../static/image/coop-cut-icon.png',
			text: '我的工单',
			badge: 99,
			route: ""
		},
		{
			image: '../../static/image/task-evaluate-icon.png',
			text: '我的需求',
			badge: 100,
			route: ""
		}, {
			image: '../../static/image/task-my-icon.png',
			text: '需求评价',
			badge: 0,
			route: ""
		},
		{
			image: '../../static/image/task-dealt-icon.png',
			text: '统计报表',
			badge: 1,
			route: ""
		}
	]
}

const taskManagement = {
	title: '任务管理',
	col: 4,
	icon: "../../static/img/menu-icon.png",
	list: [{
			image: '../../static/image/service-menu-icon.png',
			text: '任务列表',
			path: '../service-directory/index'
		},
		{
			image: '../../static/image/service-process-icon.png',
			text: '我的任务',
			path: '../serve-progress/index'
		},
		{
			image: '../../static/image/service-person-icon.png',
			text: '协调任务',
			path: '../customer-service/index'
		},
		{
			image: '../../static/image/service-person-icon.png',
			text: '统计报表',
			path: '../customer-service/index'
		}
	]
}


module.exports = {
	statistic,
	operationDetection,
	alarmHandling,
	demandManagement,
	taskManagement
}
