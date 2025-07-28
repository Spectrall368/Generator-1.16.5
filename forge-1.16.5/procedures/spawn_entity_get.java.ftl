<#include "mcelements.ftl">
<#assign entity = generator.map(field$entity, "entities", 1)!"null">
<#if entity != "null">
(world instanceof ServerWorld ? ${entity}.onInitialSpawn((ServerWorld) world, world.getDifficultyForLocation(${toBlockPos(input$x,input$y,input$z)}), SpawnReason.MOB_SUMMONED, null, null) : null)
<#else>
null
</#if>