<#include "mcitems.ftl">
<#include "trees.ftl">
new BaseTreeFeatureConfig.Builder(${mappedBlockToBlockStateProvider(input$trunk)}, ${mappedBlockToBlockStateProvider(input$foliage)},
new SpruceFoliagePlacer(FeatureSpread.func_242253_a(${input$radius}, 1), FeatureSpread.func_242253_a(0, 2), FeatureSpread.func_242253_a(${input$trunk_height}, 1)), 
<@simpleTrunkPlacer "StraightTrunkPlacer" field$base_height field$height_variation_a field$height_variation_b/>, <@twoLayersFeatureSize limit=2 lower_size=0 upper_size=2/>
)<#if field$ignore_vines == "TRUE">.setIgnoreVines()</#if><#if field$force_dirt == "TRUE">.setMaxWaterDepth(0)</#if>.setDecorators(ImmutableList.of(<#list input_list$decorator as decorator>${decorator}<#sep>,</#list>)).build()
