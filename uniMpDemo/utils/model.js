class baseModel {
	constructor(name, age) {
		this.name = name
		this.age = age
		// 可以访问外部属性
		this._height = 170
	}
	count = 1; // 读写 默认public
	private _fullName = "" // 私有 不可被外部访问
	protected _proName = "" // 只可被派生和本类访问
	readonly _height = 170 // 只读  不可被修改
	// 静态属性，只可被本类调用 const field = baseModel.staticField
	static staticField = "static field"; 

	// set get方法
	get _fullName(): String {
		return this._fullName
	}
	set _fullName(newValue: String) {
		if (newValue.indexOf("name")) {
			this._fullName = newValue
		} else {
			console.log("不合规");
		}
	}

	getAge() {
		this.count++
		return this.age
	}
	drow() {
		console.log("父类");
	}
	
	// 静态方法 baseModel.staticMethod()
	static staticMethod(): string {
		return "static method has been called.";
	}
}

class userInfo extends baseModel {
	override count = 2;
	override getAge() {
		return this.age += 1
	}
	override drow() {
		super.drow()
		console.log("子类");
	}
}
