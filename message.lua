--
--

local main = beecloud or {}
if main.message ~= nil then
    return main.message
end

local utilities = beecloud.utilities
local DESCRIPTION = beecloud.protocol.DESCRIPTION
local FIELD_LENGTH = beecloud.protocol.FIELD_LENGTH
local BP = beecloud.protocol.beecloud_protocol
local element = beecloud.element

local Message = {}

function Message:new(message_name)
    local attribute = {message_name = message_name}
    setmetatable(attribute, self)
    self.__index = self
    return attribute
end

function Message.to_table(all_messages)
	local table = {}
	for i, message in ipairs(all_messages) do
		table[message.message_name] = message
	end
	return table
end

function Message:application_body(range)
    local elements = {}
    return elements
end

function Message:description()
    return self.message_name
end

---------------
local AuthenticationRequestMessage = Message:new("Authentication Request Message")
function AuthenticationRequestMessage:dissect_message_body(message_elements_tree, payload, offset)
    local vehicle_descriptor_element_tree = message_elements_tree:add("Element: Vehicle Descriptor")
    element.VehicleDescriptorElement:dissect(vehicle_descriptor_element_tree, payload.range(offset, FIELD_LENGTH["vehicle_descriptor"]), offset)
    offset = offset + FIELD_LENGTH["vehicle_descriptor"]

    message_elements_tree:add(BP.fields.element_length, payload.range(offset, FIELD_LENGTH["element_length"]))
    offset = offset + FIELD_LENGTH["element_length"]

    message_elements_tree:add(BP.fields.pid, payload.range(offset, FIELD_LENGTH["pid"]))
    offset = offset + FIELD_LENGTH["pid"]

    local time_stamp_element_tree = message_elements_tree:add("Element: Time Stamp")
    element.TimeStampElement:dissect(time_stamp_element_tree, payload.range(offset, FIELD_LENGTH["time_stamp"]), offset)
end

local RequestMessage = Message:new("Request Message")
function RequestMessage:dissect_message_body(message_elements_tree, payload, offset)
    message_elements_tree:add(BP.fields.element_length, payload.range(offset, FIELD_LENGTH["element_length"]))
    offset = offset + FIELD_LENGTH["element_length"]

    message_elements_tree:add(BP.fields.identity, payload.range(offset, FIELD_LENGTH["identity"]))
    offset = offset + FIELD_LENGTH["identity"]

    local time_stamp_element_tree = message_elements_tree:add("Element: Time Stamp")
    element.TimeStampElement:dissect(time_stamp_element_tree, payload.range(offset, FIELD_LENGTH["time_stamp"]), offset)
end

local ResponseMessage = Message:new("Response Message")
function ResponseMessage:dissect_message_body(message_elements_tree, payload, offset)
    message_elements_tree:add(BP.fields.element_length, payload.range(offset, FIELD_LENGTH["element_length"]))
    offset = offset + FIELD_LENGTH["element_length"]
    message_elements_tree:add(BP.fields.identity, payload.range(offset, FIELD_LENGTH["identity"]))
    offset = offset + FIELD_LENGTH["identity"]

    local time_stamp_element_tree = message_elements_tree:add("Element: Time Stamp")
    element.TimeStampElement:dissect(time_stamp_element_tree, payload.range(offset, FIELD_LENGTH["time_stamp"]), offset)
    offset = offset + FIELD_LENGTH["time_stamp"]

    message_elements_tree:add(BP.fields.element_length, payload.range(offset, FIELD_LENGTH["element_length"]))
    offset = offset + FIELD_LENGTH["element_length"]
    message_elements_tree:add(BP.fields.error_code, payload.range(offset, FIELD_LENGTH["error_code"]))
    offset = offset + FIELD_LENGTH["error_code"]

    local function_command_status_element_tree = message_elements_tree:add("Function Command Status")
    local function_command_status_element_length = payload.range(offset, FIELD_LENGTH["element_length"]):uint()
    function_command_status_element_tree:add(BP.fields.element_length, payload.range(offset, FIELD_LENGTH["element_length"]))
    offset = offset + FIELD_LENGTH["element_length"]
    function_command_status_element_tree:add(BP.fields.command_status, payload.range(offset, FIELD_LENGTH["command_status"]))
    offset = offset + FIELD_LENGTH["command_status"]

    function_command_status_element_tree:add("status_code", payload.range(offset, function_command_status_element_length-1):int())
    offset = offset + function_command_status_element_length-1
end

local ACKMessage = Message:new("ACK Message")
function ACKMessage:dissect_message_body(message_elements_tree, payload, offset)
    message_elements_tree:add(BP.fields.element_length, payload.range(offset, FIELD_LENGTH["element_length"]))
    offset = offset + FIELD_LENGTH["element_length"]
    message_elements_tree:add(BP.fields.identity, payload.range(offset, FIELD_LENGTH["identity"]))
    offset = offset + FIELD_LENGTH["identity"]

    local time_stamp_element_tree = message_elements_tree:add("Element: Time Stamp")
    element.TimeStampElement:dissect(time_stamp_element_tree, payload.range(offset, FIELD_LENGTH["time_stamp"]), offset)
    offset = offset + FIELD_LENGTH["time_stamp"]

    message_elements_tree:add(BP.fields.element_length, payload.range(offset, FIELD_LENGTH["element_length"]))
    offset = offset + FIELD_LENGTH["element_length"]
    message_elements_tree:add(BP.fields.error_code, payload.range(offset, FIELD_LENGTH["error_code"]))
    offset = offset + FIELD_LENGTH["error_code"]
end

local ResponseAutoStateMessage = Message:new("Response AutoState")
function ResponseAutoStateMessage:dissect_message_body(message_elements_tree, payload, offset)
    message_elements_tree:add(BP.fields.element_length, payload.range(offset, FIELD_LENGTH["element_length"]))
    offset = offset + FIELD_LENGTH["element_length"]
    message_elements_tree:add(BP.fields.identity, payload.range(offset, FIELD_LENGTH["identity"]))
    offset = offset + FIELD_LENGTH["identity"]

    local time_stamp_element_tree = message_elements_tree:add("Element: Time Stamp")
    element.TimeStampElement:dissect(time_stamp_element_tree, payload.range(offset, FIELD_LENGTH["time_stamp"]), offset)
    offset = offset + FIELD_LENGTH["time_stamp"]

    message_elements_tree:add(BP.fields.element_length, payload.range(offset, FIELD_LENGTH["element_length"]))
    offset = offset + FIELD_LENGTH["element_length"]
    message_elements_tree:add(BP.fields.error_code, payload.range(offset, FIELD_LENGTH["error_code"]))
    offset = offset + FIELD_LENGTH["error_code"]

    local response_state_element_tree = message_elements_tree:add("Element: Response State Element")
    element.ResponseStateElement:dissect(response_state_element_tree, payload.range(offset), offset)
end

local NotifyAutoStateMessage = Message:new("Notify AutoState")
function NotifyAutoStateMessage:dissect_message_body(message_elements_tree, payload, offset)
    message_elements_tree:add(BP.fields.element_length, payload.range(offset, FIELD_LENGTH["element_length"]))
    offset = offset + FIELD_LENGTH["element_length"]
    message_elements_tree:add(BP.fields.identity, payload.range(offset, FIELD_LENGTH["identity"]))
    offset = offset + FIELD_LENGTH["identity"]

    local time_stamp_element_tree = message_elements_tree:add("Element: Time Stamp")
    element.TimeStampElement:dissect(time_stamp_element_tree, payload.range(offset, FIELD_LENGTH["time_stamp"]), offset)
    offset = offset + FIELD_LENGTH["time_stamp"]

    local response_state_element_tree = message_elements_tree:add("Element: Response State Element")
    element.ResponseStateElement:dissect(response_state_element_tree, payload.range(offset), offset)
end

local NotifyAutoRemindMessage = Message:new("Notify AutoRemind")
function NotifyAutoRemindMessage:dissect_message_body(message_elements_tree, payload, offset)
    message_elements_tree:add(BP.fields.element_length, payload.range(offset, FIELD_LENGTH["element_length"]))
    offset = offset + FIELD_LENGTH["element_length"]

    message_elements_tree:add(BP.fields.identity, payload.range(offset, FIELD_LENGTH["identity"]))
    offset = offset + FIELD_LENGTH["identity"]

    local time_stamp_element_tree = message_elements_tree:add("Element: Time Stamp")
    element.TimeStampElement:dissect(time_stamp_element_tree, payload.range(offset, FIELD_LENGTH["time_stamp"]), offset)
    offset = offset + FIELD_LENGTH["time_stamp"]
end

local NotifyAutoAlarmMessage = Message:new("Notify AutoAlarm")
function NotifyAutoAlarmMessage:dissect_message_body(message_elements_tree, payload, offset)
    message_elements_tree:add(BP.fields.element_length, payload.range(offset, FIELD_LENGTH["element_length"]))
    offset = offset + FIELD_LENGTH["element_length"]
    message_elements_tree:add(BP.fields.identity, payload.range(offset, FIELD_LENGTH["identity"]))
    offset = offset + FIELD_LENGTH["identity"]

    local time_stamp_element_tree = message_elements_tree:add("Element: Time Stamp")
    element.TimeStampElement:dissect(time_stamp_element_tree, payload.range(offset, FIELD_LENGTH["time_stamp"]), offset)
    offset = offset + FIELD_LENGTH["time_stamp"]

    message_elements_tree:add(BP.fields.element_length, payload.range(offset, FIELD_LENGTH["element_length"]))
    offset = offset + FIELD_LENGTH["element_length"]
    message_elements_tree:add(BP.fields.auto_alarm, payload.range(offset, FIELD_LENGTH["auto_alarm"]))
    offset = offset + FIELD_LENGTH["auto_alarm"]
end

local AutoConfigMessage = Message:new("AutoConfig Message")
function AutoConfigMessage:dissect_message_body(message_elements_tree, payload, offset)
    message_elements_tree:add(BP.fields.element_length, payload.range(offset, FIELD_LENGTH["element_length"]))
    offset = offset + FIELD_LENGTH["element_length"]
    message_elements_tree:add(BP.fields.identity, payload.range(offset, FIELD_LENGTH["identity"]))
    offset = offset + FIELD_LENGTH["identity"]

    local time_stamp_element_tree = message_elements_tree:add("Element: Time Stamp")
    element.TimeStampElement:dissect(time_stamp_element_tree, payload.range(offset, FIELD_LENGTH["time_stamp"]), offset)
    offset = offset + FIELD_LENGTH["time_stamp"]

    message_elements_tree:add(BP.fields.element_length, payload.range(offset, FIELD_LENGTH["element_length"]))
    offset = offset + FIELD_LENGTH["element_length"]
    message_elements_tree:add(BP.fields.error_code, payload.range(offset, FIELD_LENGTH["error_code"]))
    offset = offset + FIELD_LENGTH["error_code"]
    
    local auto_config_element_tree = message_elements_tree:add("Element: AutoConfig")
    element.AutoConfigElement:dissect(auto_config_element_tree, payload.range(offset), offset)
end


local AutoLocationMessage = Message:new("Auto Location Message")
function AutoLocationMessage:dissect_message_body(message_elements_tree, payload, offset)
    message_elements_tree:add(BP.fields.element_length, payload.range(offset, FIELD_LENGTH["element_length"]))
    offset = offset + FIELD_LENGTH["element_length"]
    message_elements_tree:add(BP.fields.identity, payload.range(offset, FIELD_LENGTH["identity"]))
    offset = offset + FIELD_LENGTH["identity"]

    local time_stamp_element_tree = message_elements_tree:add("Element: Time Stamp")
    element.TimeStampElement:dissect(time_stamp_element_tree, payload.range(offset, FIELD_LENGTH["time_stamp"]), offset)
    offset = offset + FIELD_LENGTH["time_stamp"]

    local auto_location_element_tree = message_elements_tree:add("Element: Auto Location")
    element.AutoLocationElement:dissect(auto_location_element_tree, payload.range(offset, FIELD_LENGTH["auto_location"]), offset)
end

local RemoteLocationMessage = Message:new("Remote Location Message")
function RemoteLocationMessage:dissect_message_body(message_elements_tree, payload, offset)
    message_elements_tree:add(BP.fields.element_length, payload.range(offset, FIELD_LENGTH["element_length"]))
    offset = offset + FIELD_LENGTH["element_length"]
    message_elements_tree:add(BP.fields.identity, payload.range(offset, FIELD_LENGTH["identity"]))
    offset = offset + FIELD_LENGTH["identity"]

    local time_stamp_element_tree = message_elements_tree:add("Element: Time Stamp")
    element.TimeStampElement:dissect(time_stamp_element_tree, payload.range(offset, FIELD_LENGTH["time_stamp"]), offset)
    offset = offset + FIELD_LENGTH["time_stamp"]

    message_elements_tree:add(BP.fields.element_length, payload.range(offset, FIELD_LENGTH["element_length"]))
    offset = offset + FIELD_LENGTH["element_length"]
    message_elements_tree:add(BP.fields.error_code, payload.range(offset, FIELD_LENGTH["error_code"]))
    offset = offset + FIELD_LENGTH["error_code"]

    local auto_location_element_tree = message_elements_tree:add("Element: Auto Location")
    element.AutoLocationElement:dissect(auto_location_element_tree, payload.range(offset, FIELD_LENGTH["auto_location"]), offset)
end

local RemoteControlMessage = Message:new("Remote Control Message")
function RemoteControlMessage:dissect_message_body(message_elements_tree, payload, offset)
    message_elements_tree:add(BP.fields.element_length, payload.range(offset, FIELD_LENGTH["element_length"]))
    offset = offset + FIELD_LENGTH["element_length"]
    message_elements_tree:add(BP.fields.identity, payload.range(offset, FIELD_LENGTH["identity"]))
    offset = offset + FIELD_LENGTH["identity"]

    local time_stamp_element_tree = message_elements_tree:add("Element: Time Stamp")
    element.TimeStampElement:dissect(time_stamp_element_tree, payload.range(offset, FIELD_LENGTH["time_stamp"]), offset)
    offset = offset + FIELD_LENGTH["time_stamp"]

    local remote_control_command_element_tree = message_elements_tree:add("Element: Remote Control Command")
    element.RemoteControlCommandElement:dissect(remote_control_command_element_tree, payload.range(offset), "Control")
end

local RemoteNotifyMessage = Message:new("Remote Notify Message")
function RemoteNotifyMessage:dissect_message_body(message_elements_tree, payload, offset)
    message_elements_tree:add(BP.fields.element_length, payload.range(offset, FIELD_LENGTH["element_length"]))
    offset = offset + FIELD_LENGTH["element_length"]
    message_elements_tree:add(BP.fields.identity, payload.range(offset, FIELD_LENGTH["identity"]))
    offset = offset + FIELD_LENGTH["identity"]

    local time_stamp_element_tree = message_elements_tree:add("Element: Time Stamp")
    element.TimeStampElement:dissect(time_stamp_element_tree, payload.range(offset, FIELD_LENGTH["time_stamp"]), offset)
    offset = offset + FIELD_LENGTH["time_stamp"]

    message_elements_tree:add(BP.fields.element_length, payload.range(offset, FIELD_LENGTH["element_length"]))
    offset = offset + FIELD_LENGTH["element_length"]
    message_elements_tree:add(BP.fields.error_code, payload.range(offset, FIELD_LENGTH["error_code"]))
    offset = offset + FIELD_LENGTH["error_code"]

    local function_command_status_element_tree = message_elements_tree:add("Element: Function Command Status")
    element.FunctionCommandStatusElement:dissect(function_command_status_element_tree, payload.range(offset), "Control")
end

local NotifyCollisionMessage = Message:new("Notify Collision Message")
function NotifyCollisionMessage:dissect_message_body(message_elements_tree, payload, offset)
    message_elements_tree:add(BP.fields.element_length, payload.range(offset, FIELD_LENGTH["element_length"]))
    offset = offset + FIELD_LENGTH["element_length"]
    message_elements_tree:add(BP.fields.identity, payload.range(offset, FIELD_LENGTH["identity"]))
    offset = offset + FIELD_LENGTH["identity"]

    local time_stamp_element_tree = message_elements_tree:add("Element: Time Stamp")
    element.TimeStampElement:dissect(time_stamp_element_tree, payload.range(offset, FIELD_LENGTH["time_stamp"]), offset)
    offset = offset + FIELD_LENGTH["time_stamp"]

    local auto_location_element_tree = message_elements_tree:add("Element: Auto Location")
    element.AutoLocationElement:dissect(auto_location_element_tree, payload.range(offset, FIELD_LENGTH["auto_location"]), offset)
    offset = offset + FIELD_LENGTH["auto_location"]

    local notify_collision_element_tree = message_elements_tree:add("Element: Notify Collision Element")
    element.NotifyCollisionElement:dissect(notify_collision_element_tree, payload.range(offset, FIELD_LENGTH["notify_collision"]), offset)
end

local RequestStateMessage = Message:new("Request State Message")
function RequestStateMessage:dissect_message_body(message_elements_tree, payload, offset)
    message_elements_tree:add(BP.fields.element_length, payload.range(offset, FIELD_LENGTH["element_length"]))
    offset = offset + FIELD_LENGTH["element_length"]
    message_elements_tree:add(BP.fields.identity, payload.range(offset, FIELD_LENGTH["identity"]))
    offset = offset + FIELD_LENGTH["identity"]

    local time_stamp_element_tree = message_elements_tree:add("Element: Time Stamp")
    element.TimeStampElement:dissect(time_stamp_element_tree, payload.range(offset, FIELD_LENGTH["time_stamp"]), offset)
    offset = offset + FIELD_LENGTH["time_stamp"]

    local request_state_element_tree = message_elements_tree:add("Element: Request State Element")
    element.RequestStateElement:dissect(request_state_element_tree, payload.range(offset), offset)
end

local ResponseStateMessage = Message:new("Response State Message")
function ResponseStateMessage:dissect_message_body(message_elements_tree, payload, offset)
    message_elements_tree:add(BP.fields.element_length, payload.range(offset, FIELD_LENGTH["element_length"]))
    offset = offset + FIELD_LENGTH["element_length"]
    message_elements_tree:add(BP.fields.identity, payload.range(offset, FIELD_LENGTH["identity"]))
    offset = offset + FIELD_LENGTH["identity"]

    local time_stamp_element_tree = message_elements_tree:add("Element: Time Stamp")
    element.TimeStampElement:dissect(time_stamp_element_tree, payload.range(offset, FIELD_LENGTH["time_stamp"]), offset)
    offset = offset + FIELD_LENGTH["time_stamp"]

    message_elements_tree:add(BP.fields.element_length, payload.range(offset, FIELD_LENGTH["element_length"]))
    offset = offset + FIELD_LENGTH["element_length"]
    message_elements_tree:add(BP.fields.error_code, payload.range(offset, FIELD_LENGTH["error_code"]))
    offset = offset + FIELD_LENGTH["error_code"]
    
    local response_state_element_tree = message_elements_tree:add("Element: Response State Element")
    element.ResponseStateElement:dissect(response_state_element_tree, payload.range(offset), offset)
end

local RemoteDiagnoseCommandMessage = Message:new("Remote Diagnose Command Message")
function RemoteDiagnoseCommandMessage:dissect_message_body(message_elements_tree, payload, offset)
    message_elements_tree:add(BP.fields.element_length, payload.range(offset, FIELD_LENGTH["element_length"]))
    offset = offset + FIELD_LENGTH["element_length"]
    message_elements_tree:add(BP.fields.identity, payload.range(offset, FIELD_LENGTH["identity"]))
    offset = offset + FIELD_LENGTH["identity"]

    local time_stamp_element_tree = message_elements_tree:add("Element: Time Stamp")
    element.TimeStampElement:dissect(time_stamp_element_tree, payload.range(offset, FIELD_LENGTH["time_stamp"]), offset)
    offset = offset + FIELD_LENGTH["time_stamp"]

    local remote_control_command_element_tree = message_elements_tree:add("Element: Remote Control Command")
    element.RemoteControlCommandElement:dissect(remote_control_command_element_tree, payload.range(offset), "Diagnose")
end

local RemoteDiagnoseNotifyMessage = Message:new("Remote Diagnose Notify Message")
function RemoteDiagnoseNotifyMessage:dissect_message_body(message_elements_tree, payload, offset)
    message_elements_tree:add(BP.fields.element_length, payload.range(offset, FIELD_LENGTH["element_length"]))
    offset = offset + FIELD_LENGTH["element_length"]
    message_elements_tree:add(BP.fields.identity, payload.range(offset, FIELD_LENGTH["identity"]))
    offset = offset + FIELD_LENGTH["identity"]

    local time_stamp_element_tree = message_elements_tree:add("Element: Time Stamp")
    element.TimeStampElement:dissect(time_stamp_element_tree, payload.range(offset, FIELD_LENGTH["time_stamp"]), offset)
    offset = offset + FIELD_LENGTH["time_stamp"]

    message_elements_tree:add(BP.fields.element_length, payload.range(offset, FIELD_LENGTH["element_length"]))
    offset = offset + FIELD_LENGTH["element_length"]
    message_elements_tree:add(BP.fields.error_code, payload.range(offset, FIELD_LENGTH["error_code"]))
    offset = offset + FIELD_LENGTH["error_code"]

    local function_command_status_element_tree = message_elements_tree:add("Element: Function Command Status")
    element.FunctionCommandStatusElement:dissect(function_command_status_element_tree, payload.range(offset), "Diagnose")
end

local messages = Message.to_table({
    AuthenticationRequestMessage,
	RequestMessage,
    ResponseMessage,
    ACKMessage,
    ResponseAutoStateMessage,
    NotifyAutoStateMessage,
    NotifyAutoRemindMessage,
    NotifyAutoAlarmMessage,
    AutoConfigMessage,
    AutoLocationMessage,
    RemoteLocationMessage,
    RemoteControlMessage,
    RemoteNotifyMessage,
    NotifyCollisionMessage,
    RequestStateMessage,
    ResponseStateMessage,
    RemoteDiagnoseCommandMessage,
    RemoteDiagnoseNotifyMessage
})

local function message_lookup(application_id, step_id)
	local application_name = DESCRIPTION["application_id"][application_id]

    if nil == application_name then
        --report_failure("Unknown protocol data: Application ID: "..application_id)
    end      

    local message_name = DESCRIPTION[application_name][step_id]

    if nil == message_name then
    end

	return messages[message_name]
end

main.message = {
	message_lookup = message_lookup
}

beecloud = main
return main.message
