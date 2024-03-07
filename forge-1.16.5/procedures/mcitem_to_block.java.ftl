<#include "mcitems.ftl">
/*@BlockState*/(${mappedMCItemToItem(input$source)} instanceof BlockItem ? ((BlockItem) ${mappedMCItemToItem(input$source)}).getBlock().getDefaultState() : Blocks.AIR.getDefaultState())
