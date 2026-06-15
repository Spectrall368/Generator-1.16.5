<#include "mcitems.ftl">
<#include "mcelements.ftl">
if (${input$entity} instanceof LivingEntity) {
	((LivingEntity) ${input$entity}).setItemStackToSlot(${toArmorSlot(input$slotid)}, ${mappedMCItemToItemStackCode(input$item, 1)});
}