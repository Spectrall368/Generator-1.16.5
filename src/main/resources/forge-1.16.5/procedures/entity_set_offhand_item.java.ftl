<#include "mcitems.ftl">
<@head>if (${input$entity} instanceof LivingEntity) {
	LivingEntity _entity = (LivingEntity) ${input$entity};</@head>
	ItemStack _setstack${cbi} = ${mappedMCItemToItemStackCode(input$item, 1)}.copy();
	_setstack${cbi}.setCount(${opt.toInt(input$amount)});
	_entity.setHeldItem(Hand.OFF_HAND, _setstack${cbi});
<@tail>
	if (${input$entity} instanceof PlayerEntity) ((PlayerEntity) ${input$entity}).inventory.markDirty();
}</@tail>