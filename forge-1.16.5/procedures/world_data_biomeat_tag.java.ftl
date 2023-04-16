<#include "mcelements.ftl">
(world.getChunk(${toBlockPos(input$x,input$y,input$z)}).getBiome(${toResourceLocation(input$tag)}))
