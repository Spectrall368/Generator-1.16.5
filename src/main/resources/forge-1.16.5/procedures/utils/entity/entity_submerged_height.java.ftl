private static double getEntitySubmergedHeight(Entity entity) {
	for (ITag.INamedTag<Fluid> fluidType : FluidTags.getAllTags()) {
		if (entity.world.getFluidState(entity.getPosition()).getFluid().getRegistryName().equals(fluidType.getName()))
			return entity.func_233571_b_(fluidType);
	}
	return 0;
}