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
      "bedrock_roof_position": 0,
      "bedrock_floor_position": 0,
      "sea_level": ${data.seaLevel},
      "disable_mob_generation": false,
      "default_block": ${mappedMCItemToBlockStateJSON(data.mainFillerBlock)},
      "default_fluid": ${mappedMCItemToBlockStateJSON(data.fluidBlock)},
      "noise": {
        "height": 128,
        "density_factor": 0,
        "density_offset": 0.019921875,
        "size_horizontal": ${data.horizontalNoiseSize},
        "size_vertical": ${data.verticalNoiseSize},
        "simplex_surface_noise": false,
        "sampling": {
          "xz_scale": 1,
          "y_scale": 3,
          "xz_factor": 80,
          "y_factor": 60
        },
        "bottom_slide": {
          "target": 320,
          "size": 4,
          "offset": -1
        },
        "top_slide": {
          "target": 120,
          "size": 3,
          "offset": 0
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
