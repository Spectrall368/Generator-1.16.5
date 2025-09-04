<#include "mcelements.ftl">
<#-- @formatter:off -->
if (!world.isRemote() && world instanceof ServerWorld && ((ServerWorld) world).getServer() != null) {
	for (ItemStack itemstackiterator : ((ServerWorld) world).getServer().getLootTableManager().getLootTableFromLocation(${toResourceLocation(input$location)})
			.generate(new LootContext.Builder((ServerWorld) world).build(LootParameterSets.EMPTY))) {
		${statement$foreach}
	}
}
<#-- @formatter:on -->
