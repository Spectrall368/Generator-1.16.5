<#include "mcitems.ftl">
<#include "trees.ftl">
new BaseTreeFeatureConfig.Builder(${mappedBlockToBlockStateProvider(input$trunk)}, ${mappedBlockToBlockStateProvider(input$foliage)},
  <#if field$type == "oak">
    <@simpleFoliagePlacer type="minecraft:blob_foliage_placer" radius=2 offset=0 height=3/>,
    <@simpleTrunkPlacer "minecraft:straight_trunk_placer" field$base_height field$height_variation_a field$height_variation_b/>,
    <@twoLayersFeatureSize limit=1 lower_size=0 upper_size=1/>,
  <#elseif field$type == "acacia">
    <@simpleFoliagePlacer type="minecraft:acacia_foliage_placer" radius=2 offset=0/>,
    <@simpleTrunkPlacer "minecraft:forking_trunk_placer" field$base_height field$height_variation_a field$height_variation_b/>,
    <@twoLayersFeatureSize limit=1 lower_size=0 upper_size=2/>,
  <#elseif field$type == "dark oak">
    <@simpleFoliagePlacer type="minecraft:dark_oak_foliage_placer" radius=0 offset=0/>,
    <@simpleTrunkPlacer "minecraft:dark_oak_trunk_placer" field$base_height field$height_variation_a field$height_variation_b/>,
    <@threeLayersFeatureSize limit=1 upper_limit=1 lower_size=0 middle_size=1 upper_size=2/>,
  <#elseif field$type == "jungle bush">
    <@simpleFoliagePlacer type="minecraft:bush_foliage_placer" radius=2 offset=1 height=2/>,
    <@simpleTrunkPlacer "minecraft:straight_trunk_placer" field$base_height field$height_variation_a field$height_variation_b/>,
    <@twoLayersFeatureSize limit=0 lower_size=0 upper_size=0/>,
  <#elseif field$type == "mega jungle">
    <@simpleFoliagePlacer type="minecraft:jungle_foliage_placer" radius=2 offset=0 height=2/>,
    <@simpleTrunkPlacer "minecraft:mega_jungle_trunk_placer" field$base_height field$height_variation_a field$height_variation_b/>,
    <@twoLayersFeatureSize limit=1 lower_size=1 upper_size=2/>,
  </#if>
)<#if field$ignore_vines == "TRUE">.setIgnoreVines()</#if><#if field$force_dirt == "TRUE">.setMaxWaterDepth(0)</#if>.setDecorators(ImmutableList.of(<#list input_list$decorator as decorator>${decorator}<#sep>,</#list>))
