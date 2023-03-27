# SusiWater - Skill for a Snips/Rhasspy based home assistant


Simple skill to start irrigation with voice commands with a
Snips-like home assistant (i.e. Rhasspy).     
The skill is written in Julia with the HermesMQTT.jl framework.

### Julia

This skill is (like the entire HermesMQTT.jl framework) written in the
modern programming language Julia (because Julia is faster
then Python and coding is much much easier and much more straight forward).
However "Pythonians" often need some time to get familiar with Julia.

If you are ready for the step forward, start here: https://julialang.org/

Learn more about writing skills in Julia with HermesMQTT.jl here: 
 [![](https://img.shields.io/badge/docs-latest-blue.svg)](https://andreasdominik.github.io/HermesMQTT.jl/dev)



## Installation

The skill can be installed from within the Julia REPL with the following
commands, if the HermesMQTT.jl framework is already installed 
and configured:

```julia
using HermesMQTT

install("SusiWater")
```

If the Rhasspy server is running (recommended) the installer will
install the skill on the local machine and upload intents and slots
to the Rhasspy server (locally or remote in a server-satellite setup).

## Usage

Basic idea is to configure pumps or valves 
in the config.ini file. 
Then the skill can be used to run a preconfigured irrigation program.



## Device definitions

All available actors are defined in the config.ini file 
in the line `pumps`:
```ini
pumps = pump1, pump2, pump3
```

For each `pump` 2 lines define its properties:

```ini
<name>:driver = driver, param1, param2, ...
<name>:minutes = 10
```
The number of params depend on the driver. For the *shelly1* driver
the additional parameter *ip-address* and optional username and password
are required.

The minutes line defines the duration of the irrigation of one round for the 
respective pump in minutes (the actor will receive an *on* command to start 
and an *off* command to stop after the specified number of minutes).
With additional parameters the number of rounds and the break between the 
rounds can be defined:

```ini
pause_minutes = 15
rounds = 2
```

## Weather-dependent irrigation

If a weather service is configured in the framework ini-file the skill
can be configured to start the irrigation only if cumulative 
precipitation of the
last days is below a certain threshold.

```ini
dry_days = 3
dry_mm = 5.0
```

### Example config.ini file:

```ini
[global]
this_skill_name = SusiWater

# unique IDs for the pumps:
#
pumps = pump_left, pump_right

# settings for each pump
# driver, credentials, and minutes to run:
#
pump_left:driver = shelly1, 192.168.0.1, rhasspy, password
pump_left:minutes = 10

pump_right:driver = shelly1, 192.168.0.2, rhasspy, password
pump_right:minutes = 10

# pause between pump actions in minutes and number of rounds:
#
pause_minutes = 15
rounds = 2


# mm and days to define dry condition for the conditional intent.
# Irrigation is only started if cummulated precipitation of the last 
# <days> days is less than <mm> mm.
# The conditions is only applied, if a weather service is configured
# in the HermesMQTT config file (WeatherAPI or OpenWeather).
#
dry_days = 2
dry_mm = 5.0
```

## Drivers
### Shelly devices

Only Shelly actors are supported at the moment.


### Other drivers

Other hardware drivers may be added easily as long as they can be 
controlled via http or MQTT requests. 

Because the shelly devices are are low-price, easy to use and 
cloud-free, the autor of this skill discontinued to use other hardware. But
if somebody has an installation with Hue, Ikea or other frameworks, please 
contact me and we can easily add a driver for your hardware 
(if you help with testing ;-).

## Slots

The skill has no slots because the voice commands are only used to start
preconfigured irrigation program. All configurations 
are set in the config.ini file.

## Intents

### Susi:GiveWater
Start the irrigation program.

### Susi:WaterIfDry
Start the irrigation program only if the last days were dry
(condition is only applied, if a weather service is configured).


## Language support
Of course home automation skills are language dependent. Within the HermesMQTT.jl
Framework a Skill can support multiple languages by defining the intents for
different languages in the `profiles/<language>` subdirectory of the repository and
by defining dialogues for different languages in the config.ini file of the skill.

Currently English and German are supported.

Native speakers of other languages are welcome to contribute to the skill to make 
it available for more languages.
No changes in the code are required to support a new language.