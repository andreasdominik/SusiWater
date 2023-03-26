#
# API function go here, to be called by the
# skill-actions (and trigger-actions):
#

function one_pump(pump)

    # get timing:
    #
    minutes = get_config("minutes", one_prefix=pump, multiple=false)

    # get driver:
    #
    drivers = get_config("driver", one_prefix=pump, multiple=true)
    driver = drivers[1]


    if driver == shelly1 
        ip = drivers[2]

        username = password = nothing
        if length(drivers) > 2
            username = drivers[3]
        end
        if length(drivers) > 3
            password = drivers[4]
        end

        # turn on pump and wait and turn off:
        #
        publish_say(:start_pump, Symbol(pump))
        switch_shelly_1(ip, :on, user=username, password=password)
        sleep(60 * minutes)
        publish_say(:stop, Symbol(pump))
        switch_shelly_1(ip, :off, user=username, password=password)
    end
end




function check_is_dry(weather_history, dry_days, dry_mm)

    old = Dates.now() - Dates.Day(dry_days) |> string
    cumulative_mm = 0.0

    for w in weather_history
        if w[:time] > old && haskey(w, :rain1h)
            cumulative_mm += w[:rain1h]
        end
    end

    return cumulative_mm < dry_mm
end