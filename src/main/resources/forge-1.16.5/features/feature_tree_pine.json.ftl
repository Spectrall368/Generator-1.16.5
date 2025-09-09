<#include "mcitems.ftl">
<#include "trees.ftl">
new BaseTreeFeatureConfig.Builder(${toStateProvidertoFeatureState(input$trunk)}, ${toStateProvidertoFeatureState(input$foliage)},
<#if field$type == "pine">
new PineFoliagePlacer(FeatureSpread.func_242252_a(1), FeatureSpread.func_242252_a(1), FeatureSpread.func_242253_a(${input$foliage_height}, 1)),
<@simpleTrunkPlacer "StraightTrunkPlacer" field$base_height field$height_variation_a field$height_variation_b/>,
<@twoLayersFeatureSize limit=2 lower_size=0 upper_size=2/>
  <#elseif field$type == "mega pine">
new MegaPineFoliagePlacer(FeatureSpread.func_242252_a(0), FeatureSpread.func_242252_a(0), FeatureSpread.func_242253_a(${input$foliage_height}, 4)),
<@simpleTrunkPlacer "GiantTrunkPlacer" field$base_height field$height_variation_a field$height_variation_b/>,
<@twoLayersFeatureSize limit=1 lower_size=1 upper_size=2/>,
</#if>)<#if field$ignore_vines == "TRUE">.setIgnoreVines()</#if><#if field$force_dirt == "TRUE">.setMaxWaterDepth(0)</#if>.setDecorators(ImmutableList.of(<#list input_list$decorator as decorator>${decorator}<#sep>,</#list>)).build()
