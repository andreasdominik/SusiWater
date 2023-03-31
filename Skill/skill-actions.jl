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
    rounds = get_config(INI_ROUNDS, multiple=false, cast_to=Int, default=1)
    pause_min = get_config(INI_PAUSE, multiple=false, cast_to=Int, default=1)

    println("pumps: $pumps, rounds: $rounds, pause: $pause_min")   

    for i in 1:rounds
        for pump in pumps
            one_pump(pump)
            sleep(60 * pause_min)
        end
    end


    publish_end_session(:end_say)
    return true
end



"""
    Susi_WaterIfDry_action(topic, payload)

Run irrigarion as defined in config.ini only if
there is no rain in the last days.
"""
function Susi_WaterIfDry_action(topic, payload)

    print_log("action Susi_WaterIfDry_action() started.")
    run_it = true

    # read config:
    #
    dry_days = get_config(INI_DAYS, cast_to=Int)
    dry_mm = get_config(INI_MM, cast_to=Float64)

    if isnothing(dry_days) || isnothing(dry_mm)
        run_it = false
        print_log("dry_days or dry_mm not defined in config.ini")
    end

    # check weather history in database:
    #
    if db_has_entry(:SusiWeather)
        weather_history = db_read_value(:SusiWeather, :times)
        
        if !isnothing(weather_history) && length(weather_history) > 0
            run_it = check_is_dry(weather_history, dry_days, dry_mm)
            if !run_it
                print_log("no irrigation needed - enough rain in the last days.")
                publish_say(:no_irrigation_needed)
            end
        else
            run_it = false
            print_log("weather history not found in database")
        end
    else
        run_it = false
        print_log("weather history not found in database")
    end

    if run_it
        SusiGiveWater_action(topic, payload)
    end

    publish_end_session()
    return true
end


