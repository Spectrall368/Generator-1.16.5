<#include "mcelements.ftl">
<#-- @formatter:off -->
if (!world.isRemote() && world.getServer() != null) {
	BlockPos _bpLootTblWorld = ${toBlockPos(input$x, input$y, input$z)};
	for (ItemStack itemstackiterator : world.getServer().getLootTables().get(${toResourceLocation(input$location)})
			.getRandomItems(new LootContext.Builder((ServerWorld) world)
					.withParameter(LootContextParams.ORIGIN, Vec3.atCenterOf(_bpLootTblWorld))
					.withParameter(LootContextParams.BLOCK_STATE, world.getBlockState(_bpLootTblWorld))
					.withOptionalParameter(LootContextParams.BLOCK_ENTITY, world.getBlockEntity(_bpLootTblWorld))
					.create(LootContextParamSets.EMPTY))) {
		${statement$foreach}
	}
}
<#-- @formatter:on -->
