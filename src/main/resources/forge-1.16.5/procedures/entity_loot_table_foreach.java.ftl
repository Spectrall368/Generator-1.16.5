<#include "mcelements.ftl">
<#-- @formatter:off -->
if (${input$entity} instanceof LivingEntity && !((LivingEntity) ${input$entity}).world.isRemote() && ((LivingEntity) ${input$entity}).getServer() != null) {
	DamageSource _dsLootTbl = ((LivingEntity) ${input$entity}).getLastDamageSource();
	if (_dsLootTbl == null) _dsLootTbl = DamageSource.GENERIC;
	for (ItemStack itemstackiterator : ((LivingEntity) ${input$entity}).getServer().getLootTableManager().getLootTableFromLocation(${toResourceLocation(input$location)})
			.generate(new LootContext.Builder((ServerWorld) ((LivingEntity) ${input$entity}).world)
					.withParameter(LootParameters.THIS_ENTITY, (LivingEntity) ${input$entity})
					.withNullableParameter(LootParameters.LAST_DAMAGE_PLAYER, ((LivingEntity) ${input$entity}).getRevengeTarget() instanceof PlayerEntity ?  ((PlayerEntity) ((LivingEntity) ${input$entity}).getRevengeTarget()) : null)
					.withParameter(LootParameters.DAMAGE_SOURCE, _dsLootTbl)
					.withNullableParameter(LootParameters.KILLER_ENTITY, _dsLootTbl.getTrueSource())
					.withNullableParameter(LootParameters.DIRECT_KILLER_ENTITY, _dsLootTbl.getImmediateSource())
					.withParameter(LootParameters.field_237457_g_, ((LivingEntity) ${input$entity}).getPositionVec())
					.withParameter(LootParameters.BLOCK_STATE, ((LivingEntity) ${input$entity}).world.getBlockState(((LivingEntity) ${input$entity}).getPosition()))
					.withNullableParameter(LootParameters.BLOCK_ENTITY, ((LivingEntity) ${input$entity}).world.getTileEntity(((LivingEntity) ${input$entity}).getPosition()))
					.withParameter(LootParameters.TOOL, ((LivingEntity) ${input$entity}) instanceof PlayerEntity ? ((PlayerEntity) ((LivingEntity) ${input$entity})).inventory.getCurrentItem() : ((LivingEntity) ${input$entity}).getActiveItemStack())
					.withParameter(LootParameters.EXPLOSION_RADIUS, 0f)
					.withLuck(((LivingEntity) ${input$entity}) instanceof PlayerEntity ? ((PlayerEntity) ((LivingEntity) ${input$entity})).getLuck() : 0)
					.build(LootParameterSets.EMPTY))) {
		${statement$foreach}
	}
}
<#-- @formatter:on -->
