<#include "mcelements.ftl">
(world.func_241828_r().getRegistry(Registry.BIOME_KEY).getKey(world.getBiome(${toBlockPos(input$x,input$y,input$z)})).is(TagKey.getOrCreateKey(Registry.BIOME_KEY, ${toResourceLocation(input$tag)})))
