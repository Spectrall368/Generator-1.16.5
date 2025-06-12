private static GameType getEntityGameType(Entity entity){
	if(entity instanceof ServerPlayerEntity) {
		return ((ServerPlayerEntity) entity).interactionManager.getGameType();
	} else if(entity instanceof PlayerEntity && ((PlayerEntity) entity).world.isRemote()) {
		NetworkPlayerInfo playerInfo = Minecraft.getInstance().getConnection().getPlayerInfo(((PlayerEntity) entity).getGameProfile().getId());
		if (playerInfo != null)
			return playerInfo.getGameType();
	}
	return null;
}