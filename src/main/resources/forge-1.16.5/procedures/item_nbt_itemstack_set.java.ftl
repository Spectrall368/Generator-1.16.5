<#include "mcitems.ftl">
{
	String _tagName = ${input$tagName};
	ItemStack _tagValue = ${mappedMCItemToItemStackCode(input$tagValue, 1)};
	${mappedMCItemToItemStackCode(input$item, 1)}.getOrCreateTag().put(_tagName, !_tagValue.isEmpty() ? _tagValue.write(new CompoundNBT()) : new CompoundNBT());
}