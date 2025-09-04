"${registryname}_${cbi}": {
  "trigger": "minecraft:location",
  "conditions": {
  	"biome": "${generator.map(field$biome, "biomes")}"
  }
},