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

Run irrigarion as defined in config.ini
"""
function Susi_GiveWater_action(topic, payload)

    print_log("action Susi_GiveWater_action() started.")

    # read config:
    #
    pumps = get_config(INI_PUMPS, multiple=true)
    rounds = get_config(INI_ROUNDS, multiple=false)
    pause_min = get_config(INI_PAUSE, multiple=false)

    
    for i in i:rounds
        for pump in pumps
            one_pump(pump)
            sleep(60 * pause_min)
        end
    end


    publish_end_session(:end_say)
    return true
end
