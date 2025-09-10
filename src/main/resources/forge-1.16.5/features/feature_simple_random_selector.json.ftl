<#include "mcelements.ftl">
new SingleRandomFeature(ImmutableList.of(<#list input_list$feature as feature>() -> ${toPlacedFeature(input_id_list$feature[feature?index], feature)}<#sep>,</#list>))