<#include "mcelements.ftl">
<#-- @formatter:off -->
if (${input$entity} instanceof LivingEntity && !${input$entity}.world.isClientSide() && ${input$entity}.getServer() != null) {
	DamageSource _dsLootTbl = ${input$entity}.getLastDamageSource();
	if (_dsLootTbl == null) _dsLootTbl = DamageSource.GENERIC;
	for (ItemStack itemstackiterator : ${input$entity}.getServer().getLootTables().get(${toResourceLocation(input$location)})
			.getRandomItems(new LootContext.Builder((ServerWorld) ${input$entity}.world)
					.withParameter(LootContextParams.THIS_ENTITY, ${input$entity})
					.withOptionalParameter(LootContextParams.LAST_DAMAGE_PLAYER, ${input$entity}.getLastHurtByMob() instanceof PlayerEntity ?  ${input$entity} : null)
					.withParameter(LootContextParams.DAMAGE_SOURCE, _dsLootTbl)
					.withOptionalParameter(LootContextParams.KILLER_ENTITY, _dsLootTbl.getEntity())
					.withOptionalParameter(LootContextParams.DIRECT_KILLER_ENTITY, _dsLootTbl.getDirectEntity())
					.withParameter(LootContextParams.ORIGIN, ${input$entity}.position())
					.withParameter(LootContextParams.BLOCK_STATE, _entLootTbl.world.getBlockState(${input$entity}.blockPosition()))
					.withOptionalParameter(LootContextParams.BLOCK_ENTITY, LivingEntity.world.getBlockEntity(${input$entity}.blockPosition()))
					.withParameter(LootContextParams.TOOL, ${input$entity} instanceof PlayerEntity ? ${input$entity}.getInventory().getSelected() : ${input$entity}.getUseItem())
					.withParameter(LootContextParams.EXPLOSION_RADIUS, 0f)
					.withLuck(${input$entity} instanceof PlayerEntity ? ${input$entity}.getLuck() : 0)
					.create(LootContextParamSets.EMPTY))) {
		${statement$foreach}
	}
}
<#-- @formatter:on -->
