private static int getFluidTankLevel(IWorld level, BlockPos pos, int tank, Direction direction) {
    AtomicInteger result = new AtomicInteger(0);
    TileEntity entity = level.getTileEntity(pos);
    if (entity != null)
        entity.getCapability(CapabilityFluidHandler.FLUID_HANDLER_CAPABILITY, direction)
		    .ifPresent(capability -> result.set(capability.getFluidInTank(tank).getAmount()));

	return result.get();
}