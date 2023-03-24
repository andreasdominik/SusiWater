#
# actions called by the main callback()
# provide one function for each intent, defined in the Snips/Rhasspy
# console.
#
# ... and link the function with the intent name as shown in config.jl
#
# The functions will be called by the main callback function with
# 2 arguments:
# + MQTT-Topic as String
# + MQTT-Payload (The JSON part) as a nested dictionary, with all keys
#   as Symbols (Julia-style).
#




"""
    Susi_GiveWater_action(topic, payload)

Generated dummy action for the intent Susi:GiveWater.
This function will be executed when the intent is recognized.
"""
function Susi_GiveWater_action(topic, payload)

    print_log("action Susi_GiveWater_action() started.")
    publish_say(:skill_echo, get_intent(payload))

    if ask_yes_or_no(:ask_echo_slots)
publish_say(:no_slot)
    else   # ask returns false
        # do nothing
    end

    publish_end_session(:end_say)
    return true
end
