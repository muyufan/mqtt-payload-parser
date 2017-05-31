-- 协议定义
--

local main = beecloud or {}
if main.protocol ~= nil then
    return main.protocol
end

-- 数值-->描述
local DESCRIPTION = {
    ["application_id"] = {
        [0] = "身份认证", 
        [1] = "虚拟钥匙开锁", 
        [2] = "虚拟钥匙锁车",
        [3] = "虚拟钥匙启动汽车",
        [4] = "车辆状态被动上传",
        [5] = "熄火状态上传",
        [6] = "车辆状态延时上传",
        [7] = "获取车辆配置",
        [8] = "启动状态上传",
        [9] = "运行中地理位置上传",
        [10] = "停止后地址位置上传",
        [11] = "远程定位",
        [12] = "异常移动报警",
        [13] = "异常晃动报警",
        [14] = "远程控制",
        [15] = "碰撞记录上传",
        [16] = "车辆部件状态获取",
        [17] = "远程诊断",
        [18] = "车辆自检",
        [20] = "汽车组件状态改变上传",
    },
    ["身份认证"] = {
        [0] = "Authentication Request Message", 
        [1] = "ACK Message"
    },
    ["虚拟钥匙开锁"] = {
        [2] = "Request Message", 
        [3] = "ACK Message",
        [5] = "Response Message",
        [8] = "ACK Message"
    },
    ["虚拟钥匙锁车"] = {
        [2] = "Request Message", 
        [3] = "ACK Message",
        [5] = "Response Message",
        [8] = "ACK Message"
    },
    ["虚拟钥匙启动汽车"] = {
        [2] = "Request Message", 
        [3] = "ACK Message",
        [5] = "Response Message",
        [8] = "ACK Message"
    },
    ["车辆状态被动上传"] = {
        [2] = "Request Message", 
        [3] = "ACK Message",
        [5] = "Response AutoState",
        [8] = "ACK Message"
    },
    ["熄火状态上传"] = {
        [5] = "Notify AutoState",
        [8] = "ACK Message"
    },
    ["车辆状态延时上传"] = {
        [5] = "Notify AutoState",
        [8] = "ACK Message"
    },
    ["启动状态上传"] = {
        [5] = "Notify AutoState",
        [8] = "ACK Message"
    },
    ["获取车辆配置"] = {
        [2] = "Notify AutoRemind",
        [3] = "ACK Message",
        [5] = "AutoConfig Message",
        [8] = "ACK Message",
    },
    ["运行中地理位置上传"] = {
        [5] = "Auto Location Message"
    },
    ["停止后地址位置上传"] = {
        [5] = "Auto Location Message"
    },
    ["远程定位"] = {
        [2] = "Request Message", 
        [3] = "ACK Message",
        [5] = "Remote Location Message",
        [8] = "ACK Message"
    },
    ["异常移动报警"] = {
        [1] = "Notify AutoAlarm", 
        [2] = "ACK Message", 
        [3] = "Auto Location Message",
        [5] = "Notify AutoAlarm",
        [8] = "ACK Message"
    },
    ["异常晃动报警"] = {
        [2] = "Notify AutoRemind", 
        [3] = "ACK Message", 
    },
    ["远程控制"] = {
        [2] = "Remote Control Message",
        [3] = "ACK Message",
        [5] = "Remote Notify Message",
        [8] = "ACK Message"
    },
    ["碰撞记录上传"] = {
        [2] = "Notify Collision Message", 
        [3] = "ACK Message", 
    },
    ["车辆部件状态获取"] = {
        [2] = "Request State Message", 
        [3] = "ACK Message",
        [5] = "Response State Message",
        [8] = "ACK Message"
    },
    ["远程诊断"] = {
        [2] = "Remote Diagnose Command Message",
        [3] = "ACK Message",
        [5] = "Remote Diagnose Notify Message",
        [8] = "ACK Message"
    },
    ["车辆自检"] = {
        [2] = "Remote Diagnose Notify Message",
        [3] = "ACK Message",
    },
    ["汽车组件状态改变上传"] = {
        [5] = "Notify AutoState",
        [8] = "ACK Message"
    },
--------------- -----------------------
    ["command_status"] = {
        [1] = "Complete（完成）", 
        [2] = "Processing"
    },
    ["open_close_status"] = {
        [0] = "未采集到", 
        [3] = "开", 
        [2] = "关",
    },
    ["档位是否有效"] = {
        [0] = "无效", 
        [1] = "有效"
    },
    ["变速杆"] = {
        [0] = "未采集到", 
        [1] = "手动1", 
        [2] = "手动2", 
        [3] = "手动3", 
        [4] = "手动4", 
        [5] = "手动5", 
        [7] = "手动倒挡", 
        [8] = "自动N",
        [9] = "自动P",
        [10] = "自动R",
        [11] = "自动D",
        [12] = "自动S",
        [13] = "手动N",
    },
    ["location_type"] = {
        [1] = "WGS84"
    },
    ["alarm_type"] = {
        [1] = "异常开始",
        [2] = "异常停止",
    },
    ["配置项编号"] = {
        [1] = "Location Run Frequency",
        [2] = "Location Stopped Frequency",
        [3] = "Abnormal Moving Video Duration",
        [4] = "Abnormal Moving Start Time Limit",
        [5] = "Abnormal Moving Start Distance Limit",
        [6] = "Abnormal Moving Stop Time Limit",
        [7] = "Abnormal Moving Stop Distance Limit",
        [8] = "Honk Count",
        [9] = "Honk Length",
    },
    ["控制项编码"] = {
        [1] = "风速",
        [2] = "前除霜开关",
        [3] = "后除霜开关",
        [4] = "温度",
        [5] = "空气循环模式",
        [6] = "吹风模式",
        [7] = "压缩机开关",
        [8] = "自动模式",
        [9] = "双驱模式",
        [10] = "制冷模式",
        [11] = "远程锁车",
        [12] = "鸣笛",
        [13] = "左前车窗",
        [14] = "左后车窗",
        [15] = "右前车窗",
        [16] = "右后车窗",
        [17] = "天窗",
        [18] = "闪灯",
        [19] = "引擎",
        [19] = "空调开关",

    },
    ["open_close_control"] = {
        [0] = "关",
        [1] = "开",
    },
    ["空气循环模式"] = {
        [0] = "内循环",
        [1] = "外循环",
    },
    ["吹风模式"] = {
        [1] = "吹面",
        [2] = "吹面、吹脚",
        [3] = "吹脚",
        [4] = "吹脚、除霜",
    },
    ["双驱模式"] = {
        [0] = "左驱",
        [1] = "右驱",
        [2] = "全部",
    },
    ["制冷模式"] = {
        [0] = "制冷",
        [1] = "制热",
    },
    ["风速"] = {
        [0] = "关",
        [1] = "1档",
        [2] = "2档",
        [3] = "3档",
        [4] = "4档",
        [5] = "5档",
        [6] = "6档",
        [7] = "7档",
    },
    ["温度"] = {
        [1] = "1档",
        [2] = "2档",
        [3] = "3档",
        [4] = "4档",
        [5] = "5档",
        [6] = "6档",
        [7] = "7档",
        [18] = "18度",
        [19] = "19度",
        [20] = "20度",
        [21] = "21度",
        [22] = "22度",
        [23] = "23度",
        [24] = "24度",
        [25] = "25度",
        [26] = "26度",
        [27] = "27度",
        [28] = "28度",
        [29] = "29度",
        [30] = "30度",
        [31] = "31度",
        [32] = "32度",
    },
   
    ["control_result"] = {
        [0] = "该子项控制成功",
        [1] = "该子项控制失败",
        [2] = "该状态已存在",
        [4] = "没有权限",
        [5] = "参数错误",
        [6] = "引擎状态错误",
        [7] = "车门状态不对",
        [8] = "中控状态不对",
        [9] = "档位状态不对",
        [10] = "刹车状态不对",
        [11] = "空调状态不对",
        [12] = "速度值错误",
        [13] = "手刹状态不对",
        [14] = "电源状态不对",
    },
    ["command_source"] = {
        [0] = "保留",
        [1] = "管理员Portal",
        [2] = "用户Portal",
        [3] = "手机",
    },
    ["function_command"] = {
        [0] = "保留",
        [2] = "Enable (Start/On/Valid/Lock)",
        [3] = "Disable (Stop/Off/Invalid/Unlock)",
        [4] = "Request",
    },
    ["状态项编号"] = {
        [2] = "左前门",
        [3] = "右前门",
        [4] = "左后门",
        [5] = "右后门",
        [6] = "引擎盖",
        [7] = "后备箱",
        [8] = "充电口",
        [9] = "中控锁",
        [10] = "左前窗",
        [11] = "右前窗",
        [12] = "左后窗",
        [13] = "右后窗",
        [14] = "天窗",
        [15] = "刹车",
        [16] = "油门",
        [17] = "变速杆",
        [18] = "手刹",
        [19] = "点火状态",
        [20] = "总里程",
        [21] = "剩余油量",
        [22] = "主驾驶位安全带",
        [23] = "副驾驶位安全带",
        [1] = "温度",
        [24] = "压缩机（AC）",
        [25] = "自动模式",
        [26] = "温度模式",
        [27] = "空气模式",
        [28] = "吹风模式",
        [29] = "吹风量",
        [30] = "前除雾",
        [31] = "后除雾",
        [32] = "后视镜加热",
        [33] = "双驱模式",
        [34] = "空调开关状态",
    },
    ["event_type"] = {
        [1] = "急加速事件", 
        [2] = "急减速事件", 
        [3] = "急刹车事件", 
        [4] = "急左转弯事件", 
        [5] = "急右转弯事件", 
        [6] = "上颠簸事件", 
        [7] = "下颠簸事件", 
        [8] = "驻停摇晃事件",
        [9] = "保留",
    },
    ["dtc_type"] = {
        [1] = "读取DTC数目",
        [2] = "读取DTC的值",
    },
    ["ECU编码"] = {
        [1] = "1",
        [2] = "2",
    },
    ["ECU状态"] = {
        [0] = "ECU读取失败",
        [1] = "ECU读取成功",
    },
    ["error_code"] = {
        [0] = "无错误", 
        [1] = "Identity验证失败",
        [2] = "车辆身份认证失败",
        [4] = "协议解析错误",
        [5] = "CAN通信错误",
        [6] = "TBox系统忙",
        [7] = "无效指令",
        [9] = "CRC验证失败",
        [10] = "任务执行失败",
        [11] = "任务执行超时",
        [12] = "应答数据过长",
        [13] = "车辆配置错误",
        [14] = "任务执行条件不满足",
        [17] = "车辆未上电",
        [18] = "电压异常",
    }
}

-- 
DESCRIPTION["前除霜开关"] = DESCRIPTION["open_close_control"]
DESCRIPTION["后除霜开关"] = DESCRIPTION["open_close_control"]
DESCRIPTION["压缩机开关"] = DESCRIPTION["open_close_control"]
DESCRIPTION["自动模式"] = DESCRIPTION["open_close_control"]
DESCRIPTION["远程锁车"] = DESCRIPTION["open_close_control"]
DESCRIPTION["鸣笛"] = DESCRIPTION["open_close_control"]
DESCRIPTION["左前车窗"] = DESCRIPTION["open_close_control"]
DESCRIPTION["右前车窗"] = DESCRIPTION["open_close_control"]
DESCRIPTION["左后车窗"] = DESCRIPTION["open_close_control"]
DESCRIPTION["右后车窗"] = DESCRIPTION["open_close_control"]
DESCRIPTION["天窗"] = DESCRIPTION["open_close_control"]
DESCRIPTION["闪灯"] = DESCRIPTION["open_close_control"]
DESCRIPTION["引擎"] = DESCRIPTION["open_close_control"]
DESCRIPTION["空调开关状态"] = DESCRIPTION["open_close_status"]


DESCRIPTION["左前门"] = DESCRIPTION["open_close_status"]
DESCRIPTION["右前门"] = DESCRIPTION["open_close_status"]
DESCRIPTION["左后门"] = DESCRIPTION["open_close_status"]
DESCRIPTION["右后门"] = DESCRIPTION["open_close_status"]
DESCRIPTION["引擎盖"] = DESCRIPTION["open_close_status"]
DESCRIPTION["后备箱"] = DESCRIPTION["open_close_status"]
DESCRIPTION["充电口"] = DESCRIPTION["open_close_status"]
DESCRIPTION["中控锁"] = DESCRIPTION["open_close_status"]
DESCRIPTION["左前窗"] = DESCRIPTION["open_close_status"]
DESCRIPTION["右前窗"] = DESCRIPTION["open_close_status"]
DESCRIPTION["左后窗"] = DESCRIPTION["open_close_status"]
DESCRIPTION["右后窗"] = DESCRIPTION["open_close_status"]
DESCRIPTION["手刹"] = DESCRIPTION["open_close_status"]
DESCRIPTION["点火状态"] = DESCRIPTION["open_close_status"]
DESCRIPTION["主驾驶位安全带"] = DESCRIPTION["open_close_status"]
DESCRIPTION["副驾驶位安全带"] = DESCRIPTION["open_close_status"]
DESCRIPTION["压缩机（AC）"] = DESCRIPTION["open_close_status"]
DESCRIPTION["自动模式"] = DESCRIPTION["open_close_status"]
DESCRIPTION["温度模式"] = {[0]="未采集到",[1]="制冷",[2]="制热"}
DESCRIPTION["空气模式"] = {[0]="未采集到",[1]="内循环",[2]="外循环"}
DESCRIPTION["吹风模式"] = {[0]="未采集到",[1]="吹面",[2]="吹面和吹脚",[3]="吹脚",[4]="吹脚和除霜"}
DESCRIPTION["前除雾"] = DESCRIPTION["open_close_status"]
DESCRIPTION["后除雾"] = DESCRIPTION["open_close_status"]
DESCRIPTION["后视镜加热"] = DESCRIPTION["open_close_status"]
DESCRIPTION["双驱模式"] = {[0]="未采集到",[1]="左驱",[2]="右驱",[3]="全部"}
DESCRIPTION["压缩机（AC）"] = DESCRIPTION["open_close_status"]

--常量定义
local CONSTANT = {
    open_close = 3,
    sunroof = 15,
    brake = 255,
    throttle = 255,
    transmission = 12
}

-- 协议字段长度
local FIELD_LENGTH = {
    --报文头
    ["start_of_frame"] = 4, 
    ["protocol_version1"] = 1,
    ["package_length"] = 3,
    --消息头
    ["application_id"] = 2,
    ["step_id"] = 1,
    ["protocol_version2"] = 1,
    ["sequence_id"] = 8,
    ["messages_length"] = 3,
    --通用
    ["element_length"] = 2,
    --元素:Vehicle Descriptor
    ["vehicle_descriptor"] = 74,
    ["pid"] = 16,
    --元素:Time Stamp
    ["time_stamp"] = 8,
    --元素:Auto State
    ["auto_state"] = 14,
    ["auto_location"] = 20,
    --元素：Auto Alarm
    ["auto_alarm"] = 1,
    --元素：Notify Collision
    ["notify_collision"] = 4,
    --元素:Auth Token
    ["identity"] = 4,
    --元素: Auto Config
    ["Location Run Frequency"] = 2,
    ["Location Stopped Frequency"] = 2,
    ["Abnormal Moving Video Duration"] = 2,
    ["Abnormal Moving Start Time Limit"] = 1,
    ["Abnormal Moving Start Distance Limit"] = 1,
    ["Abnormal Moving Stop Time Limit"] = 1,
    ["Abnormal Moving Stop Distance Limit"] = 1,
    ["Honk Count"] = 1,
    ["Honk Length"] = 1,
    --元素: Remote Control Command
    ["function_command"] = 1,
    ["command_source"] = 1,
    ["remote_control"] = 1,
    --元素:Function Command Status
    ["command_status"] = 1,
    --元素:State Value
    ["左前门"] = 1,
    ["右前门"] = 1,
    ["左后门"] = 1,
    ["右后门"] = 1,
    ["引擎盖"] = 1,
    ["后备箱"] = 1,
    ["中控锁"] = 1,
    ["充电口"] = 1,
    ["左前窗"] = 1,
    ["右前窗"] = 1,
    ["左后窗"] = 1,
    ["右后窗"] = 1,
    ["天窗"] = 1,
    ["引擎"] = 1,
    ["闪灯"] = 1,
    ["刹车"] = 1,
    ["油门"] = 1,
    ["变速杆"] = 1,
    ["手刹"] = 1,
    ["点火状态"] = 1,
    ["总里程"] = 4,
    ["剩余油量"] = 2,
    ["主驾驶位安全带"] = 1,
    ["副驾驶位安全带"] = 1,
    ["温度"] = 1,
    ["压缩机（AC）"] = 1,
    ["自动模式"] = 1,
    ["温度模式"] = 1,
    ["空气模式"] = 1,
    ["吹风模式"] = 1,
    ["吹风量"] = 1,
    ["前除雾"] = 1,
    ["后除雾"] = 1,
    ["后视镜加热"] = 1,
    ["双驱模式"] = 1,
    ["空调开关状态"] = 1,
    --元素:Error
    ["error_code"] = 1,
    --报文尾
    ["crc32"] = 4,
    ["end_of_frame"] = 4
}

local BP = Proto("beecloud", "MQTT payload postdissector for Beecloud")
local BPWebsocket = Proto("beecloud-over-websocket", "MQTT payload postdissector for Beecloud over websocket")

--datagram header fields
BP.fields.start_of_frame = ProtoField.uint32("beecloud.start_of_frame", "Start Of Frame", base.HEX)
BP.fields.protocol_version1 = ProtoField.uint8("beecloud.protocol_version1", "Protocol Version 1", base.DEC, {}, 0x0f)
BP.fields.package_length = ProtoField.uint24("beecloud.package_length", "Package Length")

--message header fields
BP.fields.application_id = ProtoField.uint16("beecloud.application_id", "Application ID", base.DEC, DESCRIPTION["application_id"])
BP.fields.step_id = ProtoField.uint8("beecloud.step_id", "Step ID", base.DEC, DESCRIPTION["step_unlock"], 0xf0)
BP.fields.protocol_version2 = ProtoField.uint8("beecloud.protocol_version2", "Protocol Version 2", base.DEC, {}, 0x0f)
BP.fields.sequence_id = ProtoField.uint64("beecloud.sequence_id", "Sequence ID", base.DEC)
BP.fields.messages_length = ProtoField.uint24("beecloud.messages_length", "消息长度", base.DEC)

--element fields:Vehicle Descriptor
BP.fields.vehicle_descriptor = ProtoField.string("beecloud.vehicle_descriptor", "Vehicle Descriptor", base.DEC)

--element fields:Authentication
BP.fields.pid = ProtoField.string("beecloud.pid", "PID", base.DEC)

--element fields:Auth Token
BP.fields.identity = ProtoField.uint32("beecloud.identity", "Identity")

--element fields:Time Stamp
BP.fields.time_stamp = ProtoField.string("beecloud.time_stamp", "时间")

--element fields:Remote Control Command
BP.fields.element_length = ProtoField.uint16("beecloud.element_length", "元素长度", base.DEC)
BP.fields.function_command = ProtoField.uint8("beecloud.function_command", "Function Command", base.DEC, DESCRIPTION["function_command"], 0xf0)
BP.fields.command_source = ProtoField.uint8("beecloud.command_source", "Command Source", base.DEC, DESCRIPTION["command_source"], 0x0f)
BP.fields.control_num = ProtoField.uint8("beecloud.control_num", "控制项数目", base.DEC)

--element fields:Function Command Status
BP.fields.command_status = ProtoField.uint8("beecloud.command_status", "Command Status", base.DEC, DESCRIPTION["command_status"])
BP.fields.control_num = ProtoField.uint8("beecloud.control_num", "控制项数目", base.DEC)

--element fields:Remote Diagnose
BP.fields.dtc_type = ProtoField.uint8("beecloud.dtc_type", "DTC Type", base.DEC, DESCRIPTION["dtc_type"])
BP.fields.ecu_code = ProtoField.uint8("beecloud.ecu_code", "ECU编码", base.DEC, DESCRIPTION["ECU编码"])
BP.fields.ecu_status = ProtoField.uint8("beecloud.ecu_status", "ECU状态", base.DEC, DESCRIPTION["ECU状态"])

--element fields:AutoLocationElement
BP.fields.location_type = ProtoField.uint8("beecloud.location_type", "location type", base.DEC, DESCRIPTION["location_type"], 0x7)
BP.fields.latitude = ProtoField.string("beecloud.latitude", "Latitude")
BP.fields.longitude = ProtoField.string("beecloud.longitude", "Longitude")
BP.fields.altitude = ProtoField.string("beecloud.altitude", "Altitude")
BP.fields.speed = ProtoField.uint16("beecloud.speed", "Speed")
BP.fields.satellite_number = ProtoField.uint8("beecloud.satellite_number", "Satellite Number")
BP.fields.direction_angel = ProtoField.uint16("beecloud.direction_angel", "Direction angel")

--element fields:AutoAlarmElement
BP.fields.auto_alarm = ProtoField.uint8("beecloud.alarm_type", "alarm type", base.DEC, DESCRIPTION["alarm_type"])

--element fields:AutoConfigElement
BP.fields.config_num = ProtoField.uint8("beecloud.config_num", "配置项个数", base.DEC)

--element fields:NotifyCollisionElement
BP.fields.event_type = ProtoField.uint8("beecloud.alarm_type", "event type", base.DEC, DESCRIPTION["event_type"])
BP.fields.collision_level = ProtoField.uint8("beecloud.collision_level", "collision level", base.DEC)

--element fields:RequestStateElement
BP.fields.state_num = ProtoField.uint8("beecloud.state_num", "状态项数目", base.DEC)

--element fields:ResponseStateElement
BP.fields.state_num = ProtoField.uint8("beecloud.state_num", "状态项数目", base.DEC)

--element fields:Error
BP.fields.error_code = ProtoField.uint8("beecloud.error_code", "Error Code", base.DEC, DESCRIPTION["error_code"])

--datagram end fields
BP.fields.crc32 = ProtoField.uint32("beecloud.crc32", "CRC32", base.HEX)
BP.fields.end_of_frame = ProtoField.uint32("beecloud.end_of_frame", "End Of Frame", base.HEX)

--expert info field
BP.experts.unkown_application_step = ProtoExpert.new("unkown", "未知的application和step id组合", expert.group.UNDECODED, expert.severity.ERROR)

BP.experts.not_legal = ProtoExpert.new("out", "不合法的值", expert.group.PROTOCOL, expert.severity.WARN)

main.protocol = {
    beecloud_protocol = BP,
    beecloud_protocol_websocket = BPWebsocket,
    ALL_FIELD = ALL_FIELD,
    DESCRIPTION = DESCRIPTION,
    FIELD_LENGTH = FIELD_LENGTH,
    CONSTANT = CONSTANT
}

beecloud = main
return main.protocol