<#include "mcelements.ftl">
new SingleRandomFeature(List.of(<#list input_list$feature as feature>() -> ${toPlacedFeature(input_id_list$feature[feature?index], feature)}<#sep>,</#list>))