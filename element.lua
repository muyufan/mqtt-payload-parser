--
--
local main = beecloud or {}
if main.element ~= nil then
    return main.element
end

local BP = beecloud.protocol.beecloud_protocol
local DESCRIPTION = beecloud.protocol.DESCRIPTION
local FIELD_LENGTH = beecloud.protocol.FIELD_LENGTH
local ALL_FIELD = beecloud.protocol.ALL_FIELD
local CONSTANT = beecloud.protocol.CONSTANT

local Element = {}

function Element:new(name, len)
    local result = {name = name, len = len}
    setmetatable(result, self)
    self.__index = self
    return result
end

function Element:display()
end

function Element:description()
    return self.element_name
end

---------------
local VehicleDescriptorElement = Element:new("Vehicle Descriptor Element")
function VehicleDescriptorElement:dissect(element_tree, element_payload, offset)    
    element_tree:add(BP.fields.element_length, element_payload(0, FIELD_LENGTH["element_length"]):int())

    local vin = element_payload:range(2, 17):string()
    local tbox_serial = element_payload:range(19, 20):string()
    local imei = element_payload:range(39, 15):string()
    local iccid = element_payload:range(54, 20):string()
        
    element_tree:add("VIN: "..vin)
    element_tree:add("TBox Serial: "..tbox_serial)
    element_tree:add("IMEI: "..imei)
    element_tree:add("ICCID: "..iccid)
end
---------------
local TimeStampElement = Element:new("Time Stamp Element")
function TimeStampElement:dissect(time_stamp_element_tree, time_stamp_payload, offset)
    time_stamp_element_tree:add(BP.fields.element_length, time_stamp_payload(0, FIELD_LENGTH["element_length"]):int())

	local year = time_stamp_payload:range(2, 1):int() + 1900
	local month = time_stamp_payload:range(3, 1):int()
	local day = time_stamp_payload:range(4, 1):int()
	local hour = time_stamp_payload:range(5, 1):int()
	local minute = time_stamp_payload:range(6, 1):int()
	local second = time_stamp_payload:range(7, 1):int()
	local time_stamp = year.."-"..month.."-"..day.." "..hour..":"..minute..":"..second

    time_stamp_element_tree:add(BP.fields.time_stamp, time_stamp)
end

---------------
local AutoLocationElement = Element:new("Auto Location Element")
function AutoLocationElement:dissect(auto_location_element_tree, auto_location_payload, offset)

    local auto_location_element_len = auto_location_payload(0, FIELD_LENGTH["element_length"]):int()

    auto_location_element_tree:add(BP.fields.element_length, auto_location_element_len)
    AutoLocationElement:check_length(auto_location_element_tree, auto_location_element_len, FIELD_LENGTH["auto_location"])

    auto_location_element_tree:add(BP.fields.location_type, auto_location_payload(2, 1))
    --auto_location_element_tree:add(BP.fields.latitude, auto_location_payload(3, 4), string.format("%.6f", (auto_location_payload(3, 4):int()/1000000)-90))
    local latitude = tostring(auto_location_payload(3, 4):uint())
    local longitude = tostring(auto_location_payload(7, 4):uint())
    local altitude = tostring(auto_location_payload(11, 4):uint())
    auto_location_element_tree:add(BP.fields.latitude, auto_location_payload(3, 4), tostring(string.sub(latitude, 1, 3)-90).."."..string.sub(latitude, 4, -1))
    auto_location_element_tree:add(BP.fields.longitude, auto_location_payload(7, 4), tostring(string.sub(longitude, 1, 3)-180).."."..string.sub(longitude, 4, -1))
    auto_location_element_tree:add(BP.fields.altitude, auto_location_payload(11, 4), (auto_location_payload(11, 4):int()-100000)/10)
    auto_location_element_tree:add(BP.fields.speed, auto_location_payload(15, 2), string.format("%.2f", (auto_location_payload(15, 2):int()/100)))
    auto_location_element_tree:add(BP.fields.satellite_number, auto_location_payload(17, 1))
    auto_location_element_tree:add(BP.fields.direction_angel, auto_location_payload(18, 2), string.format("%.2f", (auto_location_payload(18, 2):int()/100)))
end

function AutoLocationElement:check_length(tree, compare, legal)
    if compare ~= legal -2  then
        tree:add_tvb_expert_info(BP.experts.not_legal, tree.text.."的长度值协议规定是: "..FIELD_LENGTH["auto_location"]-2)
    end
end

local AutoConfigElement = Element:new("Auto Config Element")
function AutoConfigElement:dissect(auto_config_element_tree, auto_config_payload, offset)
    local auto_config_element_len = auto_config_payload(0, FIELD_LENGTH["element_length"]):int()
    auto_config_element_tree:add(BP.fields.element_length, auto_config_element_len)
    local offset = 0 + FIELD_LENGTH["element_length"]

    local config_num = auto_config_payload(offset, 1):int()
    auto_config_element_tree:add(BP.fields.config_num, auto_config_payload(offset, 1))
    offset = offset + 1

    while(config_num > 0)
    do
        local config_code = auto_config_payload(offset, 1):int()
        local current_config = DESCRIPTION["配置项编号"][config_code]
        auto_config_element_tree:add(current_config, auto_config_payload(offset+2, FIELD_LENGTH[current_config]):int())

        offset = offset + 1 + FIELD_LENGTH[current_config] + 1
        config_num = config_num - 1
    end
end

-----------------
local RemoteControlCommandElement = Element:new("Remote Control Command Element")
function RemoteControlCommandElement:dissect(remote_control_command_element_tree, remote_control_command_payload, app_id)
	local remote_control_command_element_len = remote_control_command_payload(0, FIELD_LENGTH["element_length"]):int()
    remote_control_command_element_tree:add(BP.fields.element_length, remote_control_command_element_len)
    local offset = 0 + FIELD_LENGTH["element_length"]

    remote_control_command_element_tree:add(BP.fields.function_command, remote_control_command_payload(offset, 1))
    remote_control_command_element_tree:add(BP.fields.command_source, remote_control_command_payload(offset, 1))
    offset = offset + 1

    if app_id == "Control" then
        RemoteControlCommandElement:control_raw_data(remote_control_command_element_tree, remote_control_command_payload, offset)
    elseif app_id == "Diagnose" then
        RemoteControlCommandElement:diagnose_raw_data(remote_control_command_element_tree, remote_control_command_payload, offset)
    end
end
function RemoteControlCommandElement:control_raw_data(remote_control_command_element_tree, remote_control_command_payload, offset)
    local control_num = remote_control_command_payload(offset, 1):int()
    remote_control_command_element_tree:add(BP.fields.control_num, remote_control_command_payload(offset, 1))
    offset = offset + 1

    while(control_num > 0)
    do
        local control_command = remote_control_command_payload(offset, 1):int()
        local current_control_command = DESCRIPTION["控制项编码"][control_command]
        remote_control_command_element_tree:add(current_control_command, DESCRIPTION[current_control_command][remote_control_command_payload(offset+1, 1):int()])
        offset = offset + 2
        control_num = control_num - 1
    end
end
function RemoteControlCommandElement:diagnose_raw_data(remote_control_command_element_tree, remote_control_command_payload, offset)
    local dtc_type = remote_control_command_payload(offset, 1):int()
    remote_control_command_element_tree:add(BP.fields.dtc_type, remote_control_command_payload(offset, 1))
    offset = offset + 1

    local ecu_num = remote_control_command_payload(offset, 1):int()
    remote_control_command_element_tree:add("ECU数目: ", remote_control_command_payload(offset, 1):int())
    offset = offset + 1

    while(ecu_num > 0)
    do
        local ecu_code = remote_control_command_payload(offset, 1):int()
        local current_ecu_code = DESCRIPTION["ECU编码"][ecu_code]
        remote_control_command_element_tree:add(BP.fields.ecu_code, remote_control_command_payload(offset, 1))

        offset = offset + 1
        ecu_num = ecu_num - 1
    end
end

local FunctionCommandStatusElement = Element:new("Function Command Status Element")
function FunctionCommandStatusElement:dissect(function_command_status_element_tree, function_command_status_payload, app_id)
	local function_command_status_element_len = function_command_status_payload(0, FIELD_LENGTH["element_length"]):int()
    function_command_status_element_tree:add(BP.fields.element_length, function_command_status_element_len)
    local offset = 0 + FIELD_LENGTH["element_length"]

	function_command_status_element_tree:add(BP.fields.command_status, function_command_status_payload(offset, 1))
    offset = offset + 1

    if app_id == "Control" then
        FunctionCommandStatusElement:control_raw_data(function_command_status_element_tree, function_command_status_payload, offset)
    elseif app_id == "Diagnose" then
        FunctionCommandStatusElement:diagnose_raw_data(function_command_status_element_tree, function_command_status_payload, offset)
    end

end
function FunctionCommandStatusElement:control_raw_data(function_command_status_element_tree, function_command_status_payload, offset)
    local control_num = function_command_status_payload(offset, 1):int()
    function_command_status_element_tree:add(BP.fields.control_num, function_command_status_payload(offset, 1))
    offset = offset + 1

    while(control_num > 0)
    do
        local control_command = function_command_status_payload(offset, 1):int()
        local current_control_command = DESCRIPTION["控制项编码"][control_command]
        local corrent_control_result = DESCRIPTION["control_result"][function_command_status_payload(offset+1, 1):int()]
        function_command_status_element_tree:add(current_control_command, corrent_control_result)

        offset = offset + 2
        control_num = control_num - 1
    end
end
function FunctionCommandStatusElement:diagnose_raw_data(function_command_status_element_tree, function_command_status_payload, offset)
    local dtc_type = function_command_status_payload(offset, 1):int()
    function_command_status_element_tree:add(BP.fields.dtc_type, function_command_status_payload(offset, 1))
    offset = offset + 1

    local ecu_num = function_command_status_payload(offset, 1):int()
    function_command_status_element_tree:add("ECU数目: ", function_command_status_payload(offset, 1):int())
    offset = offset + 1

    while(ecu_num > 0)
    do
        local ecu_code = function_command_status_payload(offset, 1):int()
        local current_ecu_code = DESCRIPTION["ECU编码"][ecu_code]
        function_command_status_element_tree:add(BP.fields.ecu_code, function_command_status_payload(offset, 1))
        offset = offset + 1
        function_command_status_element_tree:add(BP.fields.ecu_status, function_command_status_payload(offset, 1))
        offset = offset + 1

        local dtc_num = function_command_status_payload(offset, 2):int()
        function_command_status_element_tree:add("DTC数目: ", function_command_status_payload(offset, 2):int())
        offset = offset + 2

        while(dtc_num > 0)
        do
            function_command_status_element_tree:add("DTC编码: ", function_command_status_payload(offset, 3):uint())
            offset = offset + 3
            dtc_num = dtc_num - 1
        end

        ecu_num = ecu_num - 1
    end
end
---------------------------
local NotifyCollisionElement = Element:new("Notify Collision Element")
function NotifyCollisionElement:dissect(notify_collision_element_tree, notify_collision_payload, offset)
    local notify_collision_element_len = notify_collision_payload(0, FIELD_LENGTH["element_length"]):int()
    notify_collision_element_tree:add(BP.fields.element_length, notify_collision_element_len)

    notify_collision_element_tree:add(BP.fields.event_type, notify_collision_payload(2, 1))
    notify_collision_element_tree:add(BP.fields.collision_level, notify_collision_payload(3, 1))
end

---------------------------
local RequestStateElement = Element:new("Request State Element")
function RequestStateElement:dissect(request_state_element_tree, request_state_payload, offset)
    local request_state_element_len = request_state_payload(0, FIELD_LENGTH["element_length"]):int()
    request_state_element_tree:add(BP.fields.element_length, request_state_element_len)
    offset = 0 + FIELD_LENGTH["element_length"]

    local state_num = request_state_payload(2, 1):int()
    request_state_element_tree:add(BP.fields.state_num, request_state_payload(2, 1))
    offset = offset + 1

    while(state_num > 0)
    do
        local state_code = request_state_payload(offset, 1):int()
        local current_state_item = DESCRIPTION["状态项编号"][state_code]
        request_state_element_tree:add(current_state_item, request_state_payload(offset, 1):int())

        offset = offset + 1
        state_num = state_num - 1
    end

end

---------------------------
local ResponseStateElement = Element:new("Response State Element")
function ResponseStateElement:dissect(response_state_element_tree, response_state_payload, offset)
    local response_state_element_len = response_state_payload(0, FIELD_LENGTH["element_length"]):int()
    response_state_element_tree:add(BP.fields.element_length, response_state_element_len)
    offset =  0 + FIELD_LENGTH["element_length"]

    local state_num = response_state_payload(2, 1):int()
    response_state_element_tree:add(BP.fields.state_num, response_state_payload(2, 1))
    offset = offset + 1

    while(state_num > 0)
    do
        local state_code = response_state_payload(offset, 1):int()
        local current_state_item = DESCRIPTION["状态项编号"][state_code]

        if current_state_item == "温度" or current_state_item == "吹风量"  or current_state_item == "天窗" or current_state_item == "刹车" or current_state_item == "油门" then
            response_state_element_tree:add(current_state_item, response_state_payload(offset+1,FIELD_LENGTH[current_state_item]):int())   
            offset = offset + 2
        elseif current_state_item == "总里程" or current_state_item == "剩余油量" then
            response_state_element_tree:add(current_state_item, response_state_payload(offset+1,FIELD_LENGTH[current_state_item]):int()/100)
            offset = offset + FIELD_LENGTH[current_state_item] + 1
        else
            response_state_element_tree:add(current_state_item, DESCRIPTION[current_state_item][response_state_payload(offset+1,FIELD_LENGTH[current_state_item]):int()])
            offset = offset + 2
        end
        
        
        state_num = state_num - 1
    end 
end

---------------
main.element = {
    VehicleDescriptorElement = VehicleDescriptorElement,
    TimeStampElement = TimeStampElement,
    AutoStateElement = AutoStateElement,
    AutoLocationElement = AutoLocationElement,
    AutoConfigElement = AutoConfigElement,
    NotifyCollisionElement = NotifyCollisionElement,
    RemoteControlCommandElement = RemoteControlCommandElement,
    FunctionCommandStatusElement = FunctionCommandStatusElement,
    RequestStateElement = RequestStateElement,
    ResponseStateElement =ResponseStateElement

}

beecloud = main
return main.element