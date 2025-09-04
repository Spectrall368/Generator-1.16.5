<#include "mcelements.ftl">
<#-- @formatter:off -->
if (!world.isRemote() && world instanceof ServerWorld && ((ServerWorld) world).getServer() != null) {
	BlockPos _bpLootTblWorld = ${toBlockPos(input$x, input$y, input$z)};
	for (ItemStack itemstackiterator : ((ServerWorld) world).getServer().getLootTableManager().getLootTableFromLocation(${toResourceLocation(input$location)})
			.generate(new LootContext.Builder((ServerWorld) world)
					.withParameter(LootParameters.field_237457_g_, Vector3d.copyCentered(_bpLootTblWorld))
					.withParameter(LootParameters.BLOCK_STATE, world.getBlockState(_bpLootTblWorld))
					.withNullableParameter(LootParameters.BLOCK_ENTITY, world.getTileEntity(_bpLootTblWorld))
					.build(LootParameterSets.EMPTY))) {
		${statement$foreach}
	}
}
<#-- @formatter:on -->
