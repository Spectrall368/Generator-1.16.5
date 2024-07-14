<#include "mcitems.ftl">
new BlockClusterFeatureConfig.Builder(${mappedBlockToBlockStateProvider(input$block)}, SimpleBlockPlacer.PLACER).tries(${field$tries}).xSpread(${field$xzSpread}).ySpread(${field$ySpread}).zSpread(${field$xzSpread}).build().withCondition(${input$condition})
