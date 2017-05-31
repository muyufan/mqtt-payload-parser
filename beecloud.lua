--插件入口
--

dofile(Dir.global_plugins_path().."\\beecloud\\protocol.lua")
dofile(Dir.global_plugins_path().."\\beecloud\\element.lua")
dofile(Dir.global_plugins_path().."\\beecloud\\message.lua")
dofile(Dir.global_plugins_path().."\\beecloud\\utilities.lua")

local BP = beecloud.protocol.beecloud_protocol
local BPWebsocket = beecloud.protocol.beecloud_protocol_websocket
local FIELD_LENGTH = beecloud.protocol.FIELD_LENGTH
local DESCRIPTION = beecloud.protocol.DESCRIPTION
local message_lookup = beecloud.message.message_lookup

--Wireshark内部自带的mqtt解析器已经解析出的payload和topic字段
local mqtt_type = Field.new("mqtt.msgtype")
local mqtt_msg = Field.new("mqtt.msg")
local mqtt_topic = Field.new("mqtt.topic")

local beecloud_application_id = Field.new("beecloud.application_id")
local beecloud_step_id = Field.new("beecloud.step_id")

local websocket_data = Field.new("data.data")

function BP.dissector(buffer, pinfo, tree)
    local mqtt_type = mqtt_type()
    if mqtt_type == nil or mqtt_type.value ~= 3 then
        return
    end

    local payload = mqtt_msg()
    
    if string.sub(mqtt_topic().value, 1, 2) == "cc" then
        local payload_tree = tree:add("MQTT Payload Data")
        payload_tree:add(payload.range():string())
        pinfo.cols.info:set("Publish Message: 推送到中控| Topic("..mqtt_topic().value..")")
        return
    end
    if string.sub(mqtt_topic().value, 1, 7) == "databus" then
        local payload_tree = tree:add("MQTT Payload Data")
        payload_tree:add(payload.range():string())
        pinfo.cols.info:set("Publish Message: 推送到出行后台| Topic("..mqtt_topic().value..")")
        return
    end
    if "{" == payload.range(0, 1):string() then
        local payload_tree = tree:add("MQTT Payload Data")
        payload_tree:add(payload.range():string())
        pinfo.cols.info:set("Publish Message: 推送到手机| Topic("..mqtt_topic().value..")")
        return
    end
    
    if payload then
    	--定义结构树
        local payload_tree = tree:add("MQTT Payload Data")
        local datagram_header_tree = payload_tree:add("Datagram Header")
        local message_tree = payload_tree:add("Message")
        local message_header_tree = message_tree:add("Message Header")
        local message_elements_tree = message_tree:add("Message elements")
        local datagram_end_tree = payload_tree:add("Datagram End")       

        --报文头
        local offset = 0
        datagram_header_tree:add(BP.fields.start_of_frame, payload.range(offset, FIELD_LENGTH["start_of_frame"]))
        offset = offset + FIELD_LENGTH["start_of_frame"]

        datagram_header_tree:add(BP.fields.protocol_version1, payload.range(offset, FIELD_LENGTH["protocol_version1"]))
        offset = offset + FIELD_LENGTH["protocol_version1"]

        datagram_header_tree:add(BP.fields.package_length, payload.range(offset, FIELD_LENGTH["package_length"]))
        offset = offset + FIELD_LENGTH["package_length"]

        --消息头
        message_header_tree:add(BP.fields.application_id, payload.range(offset, FIELD_LENGTH["application_id"]))
        offset = offset + FIELD_LENGTH["application_id"]

        message_header_tree:add(BP.fields.step_id, payload.range(offset, FIELD_LENGTH["step_id"]))

        app_id = beecloud_application_id().value
        step_id = beecloud_step_id().value
        app_id_CN = DESCRIPTION["application_id"][app_id]
        
        --在Packet List窗口的Info列直接显示application_id的描述
        pinfo.cols.info:set("Publish Message: "..app_id..app_id_CN.."| "..step_id..DESCRIPTION[app_id_CN][step_id].."| Topic("..mqtt_topic().value..")")

        message_header_tree:add(BP.fields.protocol_version2, payload.range(offset, FIELD_LENGTH["protocol_version2"]))
        offset = offset + FIELD_LENGTH["protocol_version2"]

        message_header_tree:add(BP.fields.sequence_id, payload.range(offset, FIELD_LENGTH["sequence_id"]))
        offset = offset + FIELD_LENGTH["sequence_id"]

        message_header_tree:add(BP.fields.messages_length, payload.range(offset, FIELD_LENGTH["messages_length"]))
        offset = offset + FIELD_LENGTH["messages_length"]

        --消息体
        local message = message_lookup(app_id, step_id)
        if nil == message then
            message_header_tree:add_proto_expert_info(BP.experts.unkown_application_step)
        else
            message:dissect_message_body(message_elements_tree, payload, offset)
        end

        --报文尾
        datagram_end_tree:add(BP.fields.crc32, payload.range(payload.len-FIELD_LENGTH["end_of_frame"]-FIELD_LENGTH["crc32"], FIELD_LENGTH["crc32"]))
        datagram_end_tree:add(BP.fields.end_of_frame, payload.range(payload.len-FIELD_LENGTH["end_of_frame"], FIELD_LENGTH["end_of_frame"]))
    end
end

function BPWebsocket.dissector(buffer, pinfo, tree)
    if websocket_data() then
        local websocket_data_tvb = websocket_data().source

        if websocket_data_tvb:raw(websocket_data_tvb:len()-1, 1) == "}" then
            --在Packet List窗口的Info列直接显示websocket_data的摘要
            pinfo.cols.info:set("Publish Message: 推送到出行手机")
        end

    end
end

--report_failure(Dir.personal_plugins_path())
register_postdissector(BP)
register_postdissector(BPWebsocket)
