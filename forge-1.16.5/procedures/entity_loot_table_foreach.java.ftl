<#include "mcelements.ftl">
<#-- @formatter:off -->
if (${input$entity} instanceof LivingEntity && !LivingEntity.world.isClientSide() && LivingEntity.getServer() != null) {
	DamageSource _dsLootTbl = LivingEntity.getLastDamageSource();
	if (_dsLootTbl == null) _dsLootTbl = DamageSource.GENERIC;
	for (ItemStack itemstackiterator : LivingEntity.getServer().getLootTables().get(${toResourceLocation(input$location)})
			.getRandomItems(new LootContext.Builder((ServerWorld) LivingEntity.world)
					.withParameter(LootContextParams.THIS_ENTITY, _entLootTbl)
					.withOptionalParameter(LootContextParams.LAST_DAMAGE_PLAYER, LivingEntity.getLastHurtByMob() instanceof PlayerEntity ?  PlayerEntity : null)
					.withParameter(LootContextParams.DAMAGE_SOURCE, _dsLootTbl)
					.withOptionalParameter(LootContextParams.KILLER_ENTITY, _dsLootTbl.getEntity())
					.withOptionalParameter(LootContextParams.DIRECT_KILLER_ENTITY, _dsLootTbl.getDirectEntity())
					.withParameter(LootContextParams.ORIGIN, LivingEntity.position())
					.withParameter(LootContextParams.BLOCK_STATE, _entLootTbl.world.getBlockState(LivingEntity.blockPosition()))
					.withOptionalParameter(LootContextParams.BLOCK_ENTITY, LivingEntity.world.getBlockEntity(LivingEntity.blockPosition()))
					.withParameter(LootContextParams.TOOL, LivingEntity instanceof PlayerEntity ? PlayerEntity.getInventory().getSelected() : LivingEntity.getUseItem())
					.withParameter(LootContextParams.EXPLOSION_RADIUS, 0f)
					.withLuck(_entLootTbl instanceof PlayerEntity ? PlayerEntity.getLuck() : 0)
					.create(LootContextParamSets.EMPTY))) {
		${statement$foreach}
	}
}
<#-- @formatter:on -->
