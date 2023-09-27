<#include "mcelements.ftl">
<#-- @formatter:off -->
if (${input$entity} instanceof LivingEntity _entLootTbl && !_entLootTbl.world.isClientSide() && _entLootTbl.getServer() != null) {
	DamageSource _dsLootTbl = _entLootTbl.getLastDamageSource();
	if (_dsLootTbl == null) _dsLootTbl = DamageSource.GENERIC;
	for (ItemStack itemstackiterator : _entLootTbl.getServer().getLootTables().get(${toResourceLocation(input$location)})
			.getRandomItems(new LootContext.Builder((ServerWorld) _entLootTbl.world)
					.withParameter(LootContextParams.THIS_ENTITY, _entLootTbl)
					.withOptionalParameter(LootContextParams.LAST_DAMAGE_PLAYER, _entLootTbl.getLastHurtByMob() instanceof PlayerEntity _player ?  _player : null)
					.withParameter(LootContextParams.DAMAGE_SOURCE, _dsLootTbl)
					.withOptionalParameter(LootContextParams.KILLER_ENTITY, _dsLootTbl.getEntity())
					.withOptionalParameter(LootContextParams.DIRECT_KILLER_ENTITY, _dsLootTbl.getDirectEntity())
					.withParameter(LootContextParams.ORIGIN, _entLootTbl.position())
					.withParameter(LootContextParams.BLOCK_STATE, _entLootTbl.world.getBlockState(_entLootTbl.blockPosition()))
					.withOptionalParameter(LootContextParams.BLOCK_ENTITY, _entLootTbl.world.getBlockEntity(_entLootTbl.blockPosition()))
					.withParameter(LootContextParams.TOOL, _entLootTbl instanceof PlayerEntity _player ? _player.getInventory().getSelected() : _entLootTbl.getUseItem())
					.withParameter(LootContextParams.EXPLOSION_RADIUS, 0f)
					.withLuck(_entLootTbl instanceof PlayerEntity _player ? _player.getLuck() : 0)
					.create(LootContextParamSets.EMPTY))) {
		${statement$foreach}
	}
}
<#-- @formatter:on -->