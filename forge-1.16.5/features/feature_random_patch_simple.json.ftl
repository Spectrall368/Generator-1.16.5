<#include "mcitems.ftl">
new BlockClusterFeatureConfig.Builder(${mappedBlockToBlockStateProvider(input$block)}, CustomBlockPlacer.PLACER).tries(${field$tries}).xSpread(${field$xzSpread}).ySpread(${field$ySpread}).zSpread(${field$xzSpread}).withCondition(${input$condition})
