{
  "ultrawarm": ${data.doesWaterVaporize},
  "natural": ${data.imitateOverworldBehaviour},
  "piglin_safe": ${data.piglinSafe},
  "respawn_anchor_works": ${data.canRespawnHere},
  "bed_works": ${data.bedWorks},
  "has_raids": ${data.hasRaids},
  "has_skylight": ${data.hasSkyLight},
  "has_ceiling": ${data.worldGenType == "Nether like gen"},
  "coordinate_scale": ${data.coordinateScale},
  "ambient_light": ${data.ambientLight},
  "infiniburn": "${data.infiniburnTag}",
  "logical_height": 256,
  <#if data.hasFixedTime>
  "fixed_time": ${data.fixedTimeValue},
  </#if>
  <#if data.useCustomEffects>
  "effects": "${modid}:${registryname}"
  <#else>
  "effects": "minecraft:${data.defaultEffects}"
  </#if>
}
