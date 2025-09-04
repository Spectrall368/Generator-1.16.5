<#if field$dimension??><#--Here for legacy reasons as field$dimension does not exist in older workspaces-->
if (${input$entity} instanceof ServerPlayerEntity && !((ServerPlayerEntity) ${input$entity}).world.isRemote()) {
	RegistryKey<World> destinationType = ${generator.map(field$dimension, "dimensions")};
	if (((ServerPlayerEntity) ${input$entity}).world.getDimensionKey() == destinationType) return;

	ServerWorld nextWorld = ((ServerPlayerEntity) ${input$entity}).getServer().getWorld(destinationType);
	if (nextWorld != null) {
		((ServerPlayerEntity) ${input$entity}).connection.sendPacket(new SChangeGameStatePacket(SChangeGameStatePacket.field_241768_e_, 0));
		((ServerPlayerEntity) ${input$entity}).teleport(nextWorld, ((ServerPlayerEntity) ${input$entity}).getPosX(), ((ServerPlayerEntity) ${input$entity}).getPosY(), ((ServerPlayerEntity) ${input$entity}).getPosZ(), ((ServerPlayerEntity) ${input$entity}).rotationYaw, ((ServerPlayerEntity) ${input$entity}).rotationPitch);
		((ServerPlayerEntity) ${input$entity}).connection.sendPacket(new SPlayerAbilitiesPacket(((ServerPlayerEntity) ${input$entity}).abilities));
		for(EffectInstance effectinstance : ((ServerPlayerEntity) ${input$entity}).getActivePotionEffects())
			((ServerPlayerEntity) ${input$entity}).connection.sendPacket(new SPlayEntityEffectPacket(((ServerPlayerEntity) ${input$entity}).getEntityId(), effectinstance));
		((ServerPlayerEntity) ${input$entity}).connection.sendPacket(new SPlaySoundEventPacket(1032, BlockPos.ZERO, 0, false));
	}
}
</#if>
