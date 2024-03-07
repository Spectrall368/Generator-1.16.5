<#if field$dimension??><#--Here for legacy reasons as field$dimension does not exist in older workspaces-->
if (${input$entity} instanceof ServerPlayerEntity && !((ServerPlayerEntity) ${input$entity}).world.isRemote()) {
	<#if field$dimension=="Surface">
		RegistryKey<World> destinationType = Level.OVERWORLD;
	<#elseif field$dimension=="Nether">
		RegistryKey<World> destinationType = Level.NETHER;
	<#elseif field$dimension=="End">
		RegistryKey<World> destinationType = Level.END;
	<#else>
		RegistryKey<World> destinationType = RegistryKey.getOrCreateKey(Registry.WORLD_KEY,
			new ResourceLocation("${generator.getResourceLocationForModElement(field$dimension.replace("CUSTOM:", ""))}"));
	</#if>
	if (((ServerPlayerEntity) ${input$entity}).world.dimension() == destinationType) return;

	ServerWorld nextWorld = ((ServerPlayerEntity) ${input$entity}).getWorld(destinationType);
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
