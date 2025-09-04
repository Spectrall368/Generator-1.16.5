<#include "mcelements.ftl">
(world instanceof ServerWorld && ((ServerWorld) world).hasRaid(${toBlockPos(input$x,input$y,input$z)}))