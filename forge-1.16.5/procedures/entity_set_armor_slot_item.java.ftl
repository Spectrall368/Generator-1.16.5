<#include "mcitems.ftl">
<#include "mcelements.ftl">
{
	Entity _entity = ${input$entity};
	if (_entity instanceof PlayerEntity) {
		((PlayerEntity) _entity).inventory.armorInventory.set(${opt.toInt(input$slotid)}, ${mappedMCItemToItemStackCode(input$item, 1)});
		((PlayerEntity) _entity).inventory.markDirty();
	} else if (_entity instanceof LivingEntity) {
		((LivingEntity) _entity).setItemStackToSlot(${toArmorSlot(input$slotid)}, ${mappedMCItemToItemStackCode(input$item, 1)});
	}
}
