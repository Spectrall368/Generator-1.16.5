<#include "mcitems.ftl">
new BlockClusterFeatureConfig.Builder(${mappedBlockToBlockStateProvider(input$block)}, SimpleBlockPlacer.PLACER)
.tries(${field$tries}).xspread(${field$xzSpread}).zspread(${field$xzSpread}).yspread(${field$ySpread}).build()