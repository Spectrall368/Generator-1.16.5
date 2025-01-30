<#-- @formatter:off -->
<#include "../mcitems.ftl">
<#import "multi_noise.json.ftl" as ms>
{
  "type": "${modid}:${registryname}",
  "generator": {
    "type": "minecraft:noise",
    "seed": ${thelper.randomlong(registryname)},
    "biome_source": <@ms.multiNoiseSource/>,
    "settings": {
      "name": "${modid}:${registryname}",
      "bedrock_roof_position": -10,
      "bedrock_floor_position": -10,
      "sea_level": ${data.seaLevel},
      "disable_mob_generation": false,
      "default_block": ${mappedMCItemToBlockStateJSON(data.mainFillerBlock)},
      "default_fluid": ${mappedMCItemToBlockStateJSON(data.fluidBlock)},
      "noise": {
        "height": 128,
        "density_factor": 0,
        "density_offset": 0,
        "size_horizontal": ${data.horizontalNoiseSize},
        "size_vertical": ${data.verticalNoiseSize},
        "simplex_surface_noise": true,
        "island_noise_override": true,
        "sampling": {
          "xz_scale": 2,
          "y_scale": 1,
          "xz_factor": 80,
          "y_factor": 160
        },
        "bottom_slide": {
          "target": -30,
          "size": 7,
          "offset": 1
        },
        "top_slide": {
          "target": -3000,
          "size": 64,
          "offset": -46
        }
      },
      "structures": {
        "structures": {
        }
      }
    }
  }
}
<#-- @formatter:on -->
