<#include "mcelements.ftl">
/*@int*/(world instanceof World ? ((World) world).getRedstonePowerFromNeighbors(${toBlockPos(input$x,input$y,input$z)}):0)
