private static boolean hasEntityRecipe(Entity entity, ResourceLocation recipe) {
	if (entity instanceof ServerPlayerEntity)
		return ((ServerPlayerEntity) entity).getRecipeBook().isUnlocked(recipe);
	else if (entity instanceof ClientPlayerEntity && ((ClientPlayerEntity) entity).world.isRemote())
		return ((ClientPlayerEntity) entity).getRecipeBook().isUnlocked(recipe);
	return false;
}